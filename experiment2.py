import subprocess
import argparse, os, re
MODELS_DIR = "framework_examples/gpu/inputs/"

def get_integer_list():
    user_input = input("Enter a list of integers separated by spaces: ")
    #user_input2 = input("Enter a list of hyperperiods separated by spaces: ")
    integer_list = [int(item) for item in user_input.split()]
    #integer_list2 = [int(item) for item in user_input2.split()]

    #return integer_list, integer_list2
    return integer_list

def run_simulation(sim_duration):
    for filename in sorted(os.listdir(MODELS_DIR)):
        print(filename)
        if filename.endswith('xmlv3'):
            name, extension = filename.split('.')
            cmd = f"./gpu_run_simulation {sim_duration} framework_examples/gpu/inputs/{filename} 0 > framework_examples/gpu/results/{name}.txt"
            print(f"Running command: {cmd}")
            subprocess.run(cmd, shell=True, check=True)

def plot_results():
    cmd = "python3 framework_examples/gpu/plot_e2.py framework_examples/gpu/results framework_examples/gpu/e2_plot"
    print(f"Running command: {cmd}")
    subprocess.run(cmd, shell=True, check=True)

def main():
    parser = argparse.ArgumentParser(description="Run simulation and plot results")
    parser.add_argument("hyperperiod", help="Hyperperiod")
    args = parser.parse_args()

    try:
        run_simulation(args.hyperperiod)
        plot_results()
    except ValueError:
        print("Error: Please ensure you only enter integers.")
    except subprocess.CalledProcessError:
        print("An error occurred while executing the simulation.")

if __name__ == "__main__":
    main()
