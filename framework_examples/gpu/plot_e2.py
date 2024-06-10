

import matplotlib.pyplot as plt
import os
import re
import argparse
import pandas as pd

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
    print(f"-----------------------------------------------------------------------------------------")
    print(file_path)
    # Dictionaries to store missed counts by kernel
    missed_counts = {}
    total_counts = {}

    with open(file_path, 'r') as file:
        content = file.read()

        # Find all relevant tasks and capture the kernel and block identifiers
        tasks = re.findall(r'(DAG1+-Kernel\d+-Block\d+) => \d+/worst(.*?)\n', content)

        # Process tasks from DAG1
        for task_info, task in tasks:
            kernel_id = task_info.split('-')[1]  # Extract kernel identifier
            if kernel_id not in total_counts:
                total_counts[kernel_id] = 0
                missed_counts[kernel_id] = 0
            total_counts[kernel_id] += 1
            if 'missed its deadline' in task:
                if kernel_id not in missed_counts:
                    missed_counts[kernel_id] = 0
                missed_counts[kernel_id] += 1

    # Print results by kernel
    for kernel, count in sorted(total_counts.items()):
        rate = ((count - missed_counts[kernel]) / count) * 100
        print(f"{kernel} in DAG1 missed {missed_counts[kernel]} deadlines out of {total_counts[kernel]}: {rate}")

    return missed_counts, total_counts

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
    results = {}
    directory = results_dir

    for filename in os.listdir(directory):
        if filename.endswith(".txt"):
            full_path = os.path.join(directory, filename)
            
            parts = filename.split('_')
            algorithm_name = '_'.join(parts[:-1])
            cpu_util = int(parts[-1].replace('.txt', ''))
            
            # Parse the results from the file
            missed_tasks, total_tasks = parse_sum_result(full_path)
            missed_tasks = sum(missed_tasks.values())
            total_tasks = sum(total_tasks.values())

            scheduling_rate = 1 - (missed_tasks / total_tasks)
            
            # Store the results in the dictionary
            if algorithm_name not in results:
                results[algorithm_name] = {}
            results[algorithm_name][cpu_util] = scheduling_rate

    # Plotting the results
    plt.figure(figsize=(10, 6))
    for algorithm, utilizations in results.items():
        # Sort the CPU utilizations and get corresponding scheduling rates
        sorted_utils = sorted(utilizations.keys())
        rates = [utilizations[u] for u in sorted_utils]
        
        plt.plot(sorted_utils, rates, label=algorithm, marker='o')

    plt.xlabel('CPU Utilization (%)')
    plt.ylabel('Scheduling Rate')
    plt.title('Scheduling Rate by CPU Utilization')
    plt.legend()
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