

import matplotlib.pyplot as plt
import os
import re
import argparse

def parse_total_result(file_path):
    total_count = 0
    with open(file_path, 'r') as file:
        content = file.read()
        
        total_count = len(re.findall(r'<\s*type_of_event\s*>END_OF_TASK_CAPACITY<\s*/type_of_event\s*>', content))
        print(total_count)
    return total_count

def parse_sum_result(file_path):
    missed_count = 0
    with open(file_path, 'r') as file:
        content = file.read()
        
        tasks = re.findall(r'DAG\d+-Kernel\d+-Block\d+ => \d+/worst(.*?)\n', content)
        for task in tasks:
            print(task)
            missed_count += len(re.findall(r'missed its deadline', task))
            print(missed_count)
    
    return missed_count

def main(results_dir, output_filename):
    block_per_kernel_values = []
    schedulability_rates = []
    total_counts = []
    missed_counts = []
    
    for filename in sorted(os.listdir(results_dir), key=lambda x: int(re.search(r'\d+', x).group())):
        print(filename)

        if filename.startswith("sum") and filename.endswith(".txt"):
            block_per_kernel = int(re.search(r'\d+', filename).group())
            block_per_kernel_values.append(block_per_kernel)
            file_path = os.path.join(results_dir, filename)
            missed_count = parse_sum_result(file_path)
            missed_counts.append(missed_count)
        elif filename.startswith("total") and filename.endswith(".xml"):
            file_path = os.path.join(results_dir, filename)
            total_count = parse_total_result(file_path)
            total_counts.append(total_count)
        
    for i in range(len(block_per_kernel_values)):
        print(block_per_kernel_values[i], missed_counts[i], total_counts[i])
        missed_count = missed_counts[i]
        total_count = total_counts[i]
        if total_count > 0:
            schedulability_rate = (total_count - missed_count) / total_count
        else:
            schedulability_rate = 0
        
        schedulability_rates.append(schedulability_rate)
        
    # Plotting the results
    plt.figure(figsize=(10, 5))
    plt.plot(block_per_kernel_values, schedulability_rates, marker='o', linestyle='-')
    plt.xlabel('Block per Kernel')
    plt.ylabel('Schedulability Rate')
    plt.title('Schedulability Rate vs Block per Kernel')
    plt.grid(True)
    plt.savefig(output_filename)  # Save the plot to a file
    plt.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate and plot schedulability rates from task set simulation results.")
    parser.add_argument("input_directory", help="Directory containing result files")
    parser.add_argument("output_filename", help="Filename to save the plot")
    args = parser.parse_args()
    
    main(args.input_directory, args.output_filename)