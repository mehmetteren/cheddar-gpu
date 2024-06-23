import re, json, subprocess
import xml.etree.ElementTree as ET
BIGGER_DAG = 'DAG2'
MULTIPLIER = 4
def parse_system(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    
    task_pattern = re.compile(r'<periodic_task id="(.*?)">\s*<object_type>TASK_OBJECT_TYPE</object_type>\s*<name>(.*?)</name>\s*<task_type>PERIODIC_TYPE</task_type>\s*<cpu_name>(.*?)</cpu_name>')

    tasks_dict = {}
    task_cpu_map = {}

    for match in task_pattern.finditer(content):
        task_id = match.group(1)
        task_name = match.group(2)
        if not task_name.startswith(BIGGER_DAG):
            continue
        task_cpu_map[task_id] = match.group(3)
        block_number = int(re.search(r'Block(\d+)', task_name).group(1))

        modified_block_number = (block_number - 1) // MULTIPLIER + 1
        
        modified_task_name = re.sub(r'Block\d+', f'Block{modified_block_number}', task_name)
        
        if modified_task_name in tasks_dict:
            tasks_dict[modified_task_name].append(task_id)
        else:
            tasks_dict[modified_task_name] = [task_id]

    print(tasks_dict)
    return tasks_dict, task_cpu_map

def parse_result(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    root = ET.fromstring(content)

    task_activations = {}

    current_time = 0

    for element in root:
        if element.tag == 'time_unit':
            current_time = int(element.text)
        elif element.tag == 'time_unit_event':
            event_type = element.find('type_of_event')
            if event_type is not None and event_type.text == 'START_OF_TASK_CAPACITY':
                activation_task = element.find('.//start_task')
                if activation_task is not None:
                    task_id = activation_task.get('ref')
                    if task_id in task_activations:
                        task_activations[task_id].append(current_time)
                    else:
                        task_activations[task_id] = [current_time]

    json.dump(task_activations, open('testo.json', 'w'))
    return task_activations

def detect(task_activations, tasks_dict):

    for block, tasks in tasks_dict.items():
        sub_dict = {key: task_activations[key] for key in tasks if key in task_activations}
        print(sub_dict)
        min_length = min(len(lst) for lst in sub_dict.values())

        for i in range(min_length):
            last_val = None
            last_key = None
            for task_id in sub_dict:
                val = sub_dict[task_id][i]
                if last_val is None:
                    last_val = val
                elif last_val < val:
                    print(f"ALLLEEEEEERT {last_val} < {val}")
                    return {"task_id": last_key, "start_time": last_val, "capacity": (val - last_val)}
                elif last_val > val:
                    print(f"ALLLEEEEEERT {last_val} > {val}")
                    return {"task_id": task_id, "start_time": val, "capacity": (last_val - val)}

                last_key = task_id
    return None


def main():
    cmd = f"./gpu_run_simulation 60 framework_examples/gpu/inputs/analysis_system_0_0.xmlv3 0 > framework_examples/gpu/results/sum_result_0.txt"
    subprocess.run(cmd, shell=True, check=True)

    system_file = f"framework_examples/gpu/inputs/analysis_system_0_0.xmlv3"
    tasks_dict, task_cpu_map = parse_system(system_file)
    task_activations = parse_result(f"framework_examples/gpu/results/total_result_0.txt")
    detect_result = detect(task_activations, tasks_dict)

    if detect_result is not None:
        print(detect_result)

    iteration = 0
    while detect_result is not None:
        start_time = detect_result['start_time']
        task_id = detect_result['task_id']
        capacity = detect_result['capacity']
        cpu_name = task_cpu_map[task_id]
        print(f"Adding aligner task with start time {start_time}, capacity {capacity}, cpu name {cpu_name}, task id {task_id} and system file {system_file}")

        system_file = f"analysis_system_0"
        cmd = f"./add_aligner_task {start_time} {capacity} {cpu_name} {task_id} {system_file} {iteration}"
        print(f"Running command: {cmd}")
        subprocess.run(cmd, shell=True, check=True)
        iteration += 1
        
        cmd = f"./gpu_run_simulation 60 framework_examples/gpu/inputs/analysis_system_0_{iteration}.xmlv3 {iteration} > framework_examples/gpu/results/sum_result_{iteration}.txt"
        print(f"Running command: {cmd}")
        subprocess.run(cmd, shell=True, check=True)

        tasks_dict, task_cpu_map = parse_system(f"framework_examples/gpu/inputs/analysis_system_0_{iteration}.xmlv3")
        task_activations = parse_result(f"framework_examples/gpu/results/total_result_{iteration}.txt")
        detect_result = detect(task_activations, tasks_dict)

        if detect_result is not None:
            print(detect_result)


main()