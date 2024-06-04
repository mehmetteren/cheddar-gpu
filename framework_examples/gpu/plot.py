

import matplotlib.pyplot as plt
import os
import re
import argparse

TOTAL_TASK_COUNT = 26
A_TOTAL = 12
B_TOTAL = 14
def parse_total_result(file_path):
    total_count = 0
    with open(file_path, 'r') as file:
        content = file.read()
        
        total_count = len(re.findall(r'<\s*type_of_event\s*>END_OF_TASK_CAPACITY<\s*/type_of_event\s*>', content))
        print(total_count)
    return total_count

def parse_sum_result(file_path):
    a_missed_count = 0
    b_missed_count = 0
    with open(file_path, 'r') as file:
        content = file.read()
        
        a_tasks = re.findall(r'DAG1+-Kernel\d+-Block\d+ => \d+/worst(.*?)\n', content)
        b_tasks = re.findall(r'DAG2+-Kernel\d+-Block\d+ => \d+/worst(.*?)\n', content)
        for task in a_tasks:
            if 'missed its deadline' in task:
                a_missed_count += 1
        for task in b_tasks:
            if 'missed its deadline' in task:
                b_missed_count += 1             
        print(f"a missed: {a_missed_count}, b missed: {b_missed_count}")
    
    return a_missed_count, b_missed_count

def calculate_rates(missed_counts, total_counts, x_list):
    schedulability_rates = []
    for i in range(len(x_list)):
        print(f"x: {x_list[i]}, missed: {missed_counts[i]}, total: {total_counts[i]}")
        missed_count = missed_counts[i]
        total_count = total_counts[i]
        if total_count > 0:
            schedulability_rate = (total_count - missed_count) / total_count
        else:
            schedulability_rate = 0
        
        schedulability_rates.append(schedulability_rate)
    return schedulability_rates

def main(results_dir, output_filename):
    model_and_dag_rates = {}
    hyperperiods = set()

    model_and_dag_missed = {}
    model_and_dag_total = {}
    
    for filename in sorted(os.listdir(results_dir), key=lambda x: int(re.search(r'\d+', x).group())):
        print(filename)
        if filename.startswith("sum") and filename.endswith(".txt"):
            vals = [int(num) for num in re.findall(r'\d+', filename)]
            hyperperiods.add(vals[1])
            
            a_key = f"{vals[0] // 10}-{vals[0] % 10} A"
            b_key = f"{vals[0] // 10}-{vals[0] % 10} B"

            file_path = os.path.join(results_dir, filename)
            a_missed_count, b_missed_count = parse_sum_result(file_path)

            try:
                model_and_dag_missed[a_key].append(a_missed_count)
            except KeyError:
                model_and_dag_missed[a_key] = [a_missed_count]
            try:
                model_and_dag_missed[b_key].append(b_missed_count)
            except KeyError:
                model_and_dag_missed[b_key] = [b_missed_count]

            try:
                model_and_dag_total[a_key].append(A_TOTAL)
            except KeyError:
                model_and_dag_total[a_key] = [A_TOTAL]
            try:
                model_and_dag_total[b_key].append(B_TOTAL)
            except KeyError:
                model_and_dag_total[b_key] = [B_TOTAL]
        # elif filename.startswith("total") and filename.endswith(".xml"):
        #     file_path = os.path.join(results_dir, filename)
        #     total_count = parse_total_result(file_path)
        #     total_counts.append(total_count)
    hyperperiods = sorted(list(hyperperiods))
    print(hyperperiods)
    print(model_and_dag_missed)
    print(model_and_dag_total)

    for a_key in model_and_dag_missed.keys():
        a_rates = calculate_rates(model_and_dag_missed[a_key], model_and_dag_total[a_key], hyperperiods)
        model_and_dag_rates[a_key] = a_rates

    for b_key in model_and_dag_missed.keys():
        b_rates = calculate_rates(model_and_dag_missed[b_key], model_and_dag_total[b_key], hyperperiods)
        model_and_dag_rates[b_key] = b_rates
        
    plt.figure(figsize=(10, 5))
    colors = ['b', 'g', 'r', 'c', 'm', 'y']
    line_styles = ['-', '--', '-.', ':']
    markers = ['o', 's', '^', 'd']

    for i, (model_and_dag, rates) in enumerate(model_and_dag_rates.items()):
        plt.plot(hyperperiods, rates, label=model_and_dag,
                color=colors[i % len(colors)],
                linestyle=line_styles[i % len(line_styles)],
                marker=markers[i % len(markers)],
                linewidth=2, alpha=0.7)

    plt.xlabel('Hyperperiod')
    plt.ylabel('Schedulability Rate')
    plt.title('Schedulability Rate vs Hyperperiod')
    plt.grid(True)
    plt.legend()
    plt.savefig(output_filename)  # Save the plot to a file
    plt.show()  # Show the plot
    plt.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate and plot schedulability rates from task set simulation results.")
    parser.add_argument("input_directory", help="Directory containing result files")
    parser.add_argument("output_filename", help="Filename to save the plot")
    args = parser.parse_args()
    
    main(args.input_directory, args.output_filename)