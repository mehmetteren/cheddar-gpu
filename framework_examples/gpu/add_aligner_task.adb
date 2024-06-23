with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with unbounded_strings; use unbounded_strings; use unbounded_strings.unbounded_string_list_package;

with initialize_framework; use initialize_framework;
with Systems;              use Systems;
with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;


with Text_IO;       use Text_IO;
with processor_set; use processor_set;
use processor_set.generic_processor_set;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with unbounded_strings;     use unbounded_strings;
use unbounded_strings.strings_table_package;
use unbounded_strings.unbounded_string_list_package;
with parameters;          use parameters;
with parameters.extended; use parameters.extended;
use parameters.framework_parameters_table_package;
with task_set; use task_set;
use task_set.generic_task_set;
with systems;                  use systems;
with call_framework;           use call_framework;
with call_framework_interface; use call_framework_interface;
use call_framework_interface.framework_response_package;
use call_framework_interface.framework_request_package;
with framework;                         use framework;
with call_scheduling_framework;         use call_scheduling_framework;
with multiprocessor_services;           use multiprocessor_services;
with multiprocessor_services_interface; use multiprocessor_services_interface;
use multiprocessor_services_interface.scheduling_result_per_processor_package;
with GNAT.Command_Line;
with GNAT.OS_Lib;    use GNAT.OS_Lib;
with version;        use version;
with Ada.Exceptions; use Ada.Exceptions;
with gpu_generator;         use gpu_generator;

procedure add_aligner_task is
    start_time: Integer;
    capacity : Integer;
    cpu_name : Unbounded_String;
    task_id  : Unbounded_String;
    system_file_name : Unbounded_String;
    iteration: Integer;

begin
   Put_Line ("Number of arguments: " & Integer'Image (Argument_Count));

    Put_Line ("Start Time: " & Argument (1));
    Put_Line ("Capacity: " & Argument (2));
    Put_Line ("CPU Name: " & Argument (3));
    Put_Line ("Task ID: " & Argument (4));
    Put_Line ("System File Name: " & Argument (5));
    Put_Line ("Iteration: " & Argument (6));

    start_time := Integer'Value (Argument (1));
    capacity := Integer'Value (Argument (2));
    cpu_name := To_Unbounded_String (Argument (3));
    task_id := To_Unbounded_String (Argument (4));
    system_file_name := To_Unbounded_String (Argument (5));
    iteration := Integer'Value (Argument (6));

    gpu_generator.add_aligner_task(system_file_name, task_id, start_time, capacity, cpu_name, iteration);


end add_aligner_task;