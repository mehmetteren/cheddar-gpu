

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
    # utilizations = []
    models = []

    a_schedulability_rates = []
    b_schedulability_rates = []

    a_total_counts = []
    b_total_counts = []

    a_missed_counts = []
    b_missed_counts = []

    
    for filename in sorted(os.listdir(results_dir), key=lambda x: int(re.search(r'\d+', x).group())):
        print(filename)

        if filename.startswith("sum") and filename.endswith(".txt"):
            val = re.search(r'\d+', filename).group()
            val = f"Allocation {val}"
            models.append(val)
            file_path = os.path.join(results_dir, filename)
            a_missed_count, b_missed_count = parse_sum_result(file_path)
            a_missed_counts.append(a_missed_count)
            b_missed_counts.append(b_missed_count)
            a_total_counts.append(A_TOTAL)
            b_total_counts.append(B_TOTAL)
        # elif filename.startswith("total") and filename.endswith(".xml"):
        #     file_path = os.path.join(results_dir, filename)
        #     total_count = parse_total_result(file_path)
        #     total_counts.append(total_count)
        

        a_rates = calculate_rates(a_missed_counts, a_total_counts, models)
        b_rates = calculate_rates(b_missed_counts, b_total_counts, models)

        
    # Plotting the results
    plt.figure(figsize=(10, 5))
    plt.plot(models, a_rates, label='A Rates', marker='o')  # Plot A rates
    plt.plot(models, b_rates, label='B Rates', marker='o')  # Plot B rates    
    plt.xlabel('model')
    plt.ylabel('Schedulability Rate')
    plt.title('Schedulability Rate vs model')
    plt.grid(True)
    plt.legend()
    plt.savefig(output_filename)  # Save the plot to a file
    plt.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate and plot schedulability rates from task set simulation results.")
    parser.add_argument("input_directory", help="Directory containing result files")
    parser.add_argument("output_filename", help="Filename to save the plot")
    args = parser.parse_args()
    
    main(args.input_directory, args.output_filename)