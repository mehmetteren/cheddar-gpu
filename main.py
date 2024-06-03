import subprocess
import argparse

def get_integer_list():
    user_input = input("Enter a list of integers separated by spaces: ")
    integer_list = [int(item) for item in user_input.split()]
    return integer_list

def run_simulation(integer_list, hyperperiod):
    for i in integer_list:
        cmd = f"./gpu_run_simulation {hyperperiod} framework_examples/gpu/inputs/analysis_model_{i}.xmlv3 {i} > framework_examples/gpu/results/sum_result_{i}.txt"
        print(f"Running command: {cmd}")
        subprocess.run(cmd, shell=True, check=True)

def plot_results():
    cmd = "python3 framework_examples/gpu/plot.py framework_examples/gpu/results framework_examples/gpu/plot"
    print(f"Running command: {cmd}")
    subprocess.run(cmd, shell=True, check=True)

def main():
    parser = argparse.ArgumentParser(description="Run simulation and plot results")
    parser.add_argument("hyperperiod", help="Hyperperiod")
    args = parser.parse_args()

    try:
        integer_list = get_integer_list()
        run_simulation(integer_list, args.hyperperiod)
        plot_results()
    except ValueError:
        print("Error: Please ensure you only enter integers.")
    except subprocess.CalledProcessError:
        print("An error occurred while executing the simulation.")

if __name__ == "__main__":
    main()
