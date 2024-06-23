import matplotlib.pyplot as plt
import os
import re
import argparse
import pandas as pd
TOTAL_TASK_COUNT = 208

def parse_total_result(file_path):
    total_count = 0
    with open(file_path, 'r') as file:
        content = file.read()
        
        total_count = len(re.findall(r'<\s*type_of_event\s*>END_OF_TASK_CAPACITY<\s*/type_of_event\s*>', content))
        print(total_count)
    return total_count

def parse_sum_result(file_path):
    # Dictionaries to store missed counts by kernel
    a_missed_counts = {}
    a_total_counts = {}
    b_missed_counts = {}
    b_total_counts = {}

    with open(file_path, 'r') as file:
        content = file.read()

        # Find all relevant tasks and capture the kernel and block identifiers
        a_tasks = re.findall(r'(DAG1+-Kernel\d+-Block\d+) => \d+/worst(.*?)\n', content)
        b_tasks = re.findall(r'(DAG2+-Kernel\d+-Block\d+) => \d+/worst(.*?)\n', content)

        # Process tasks from DAG1
        for task_info, task in a_tasks:
            kernel_id = task_info.split('-')[1]  # Extract kernel identifier
            if kernel_id not in a_total_counts:
                a_total_counts[kernel_id] = 0
                a_missed_counts[kernel_id] = 0
            a_total_counts[kernel_id] += 1
            if 'missed its deadline' in task:
                if kernel_id not in a_missed_counts:
                    a_missed_counts[kernel_id] = 0
                a_missed_counts[kernel_id] += 1

        # Process tasks from DAG2
        for task_info, task in b_tasks:
            kernel_id = task_info.split('-')[1]  # Extract kernel identifier
            if kernel_id not in b_total_counts:
                b_total_counts[kernel_id] = 0
                b_missed_counts[kernel_id] = 0
            b_total_counts[kernel_id] += 1
            if 'missed its deadline' in task:
                if kernel_id not in b_missed_counts:
                    b_missed_counts[kernel_id] = 0
                b_missed_counts[kernel_id] += 1

    # Print results by kernel
    for kernel, count in sorted(a_total_counts.items()):
        rate = ((count - a_missed_counts[kernel]) / count) * 100
        print(f"{kernel} in DAG1 missed {a_missed_counts[kernel]} deadlines out of {a_total_counts[kernel]}: {rate}")
    for kernel, count in sorted(b_total_counts.items()):
        rate = (count - b_missed_counts[kernel]) / count * 100
        print(f"{kernel} in DAG2 missed {b_missed_counts[kernel]} deadlines out of {b_total_counts[kernel]}: {rate}")

    return a_missed_counts, b_missed_counts, a_total_counts, b_total_counts

def calculate_rates(missed_counts, total_counts):
    schedulability_rates = {}
    for model in missed_counts.keys():
        schedulability_rates[model] = {}
        for dag in missed_counts[model].keys():
            missed_count = missed_counts[model][dag]
            total_count = total_counts[model][dag]
            print(f"x: {model}, missed: {missed_count}, total: {total_count}")
            if total_count > 0:
                schedulability_rate = (total_count - missed_count) / total_count
            else:
                schedulability_rate = 0
            
            schedulability_rates[model][dag] = schedulability_rate
    return schedulability_rates

def main(results_dir, output_filename):
    model_and_dag_rates = {}

    model_and_dag_missed = {}
    model_and_dag_total = {}
    
    for filename in sorted(os.listdir(results_dir), key=lambda x: int(re.search(r'\d+', x).group())):
        print(filename)
        if filename.startswith("sum") and filename.endswith(".txt"):
            vals = [int(num) for num in re.findall(r'\d+', filename)]
            model = f"{vals[0]}"
            model_and_dag_missed[model] = {}
            model_and_dag_total[model] = {}

            a_key = "A"
            b_key = "B"

            file_path = os.path.join(results_dir, filename)
            a_missed_count_kernels, b_missed_count_kernels, a_total_kernels, b_total_kernels = parse_sum_result(file_path)

            a_missed_count = sum(a_missed_count_kernels.values())
            b_missed_count = sum(b_missed_count_kernels.values())

            model_and_dag_missed[model][a_key] = a_missed_count
            model_and_dag_missed[model][b_key] = b_missed_count

            model_and_dag_total[model][a_key] = sum(a_total_kernels.values())
            model_and_dag_total[model][b_key] = sum(b_total_kernels.values())
        # elif filename.startswith("total") and filename.endswith(".xml"):
        #     file_path = os.path.join(results_dir, filename)
        #     total_count = parse_total_result(file_path)
        #     total_counts.append(total_count)
    print(model_and_dag_missed)
    print(model_and_dag_total)

    rates = calculate_rates(model_and_dag_missed, model_and_dag_total)
    model_and_dag_rates = rates
        
    df = pd.DataFrame(model_and_dag_rates).T  

    # Plotting
    ax = df.plot(kind='bar', figsize=(10, 6))
    ax.set_xlabel("Model")
    ax.set_ylabel("Schedulability Rate")
    ax.set_title("Schedulability Rates of DAG A and DAG B")
    ax.set_ylim(0, 1)
    plt.xticks(rotation=0)  
    plt.legend(title='DAG')
    plt.grid(True)
    plt.show()
    plt.savefig(output_filename)  
    plt.close()




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate and plot schedulability rates from task set simulation results.")
    parser.add_argument("input_directory", help="Directory containing result files")
    parser.add_argument("output_filename", help="Filename to save the plot")
    args = parser.parse_args()
    
    main(args.input_directory, args.output_filename)