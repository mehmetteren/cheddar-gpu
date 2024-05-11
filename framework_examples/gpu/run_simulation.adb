with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with unbounded_strings; use unbounded_strings; use unbounded_strings.unbounded_string_list_package;

with initialize_framework; use initialize_framework;
with Systems;              use Systems;
with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;


procedure run_simulation is

    period : Integer;
    system_file_name : unbounded_string;
    the_system : System;
    dir1         			 	 : unbounded_string_list;	

begin
   Put_Line ("Number of arguments: " & Integer'Image (Argument_Count));

    Put_Line ("Period: " & Argument (1));
    Put_Line ("System: " & Argument (2));
    period := Integer'Value (Argument (1));
    system_file_name := To_Unbounded_String (Argument (2));

    set_initialize;
    initialize (the_system);

    Read_From_Xml_File
        (the_system, dir1,
        system_file_name);

    compute_scheduling_of_tasks(period, the_system, Suppress_Space
                  (To_Unbounded_String
                      ("framework_examples/gpu/result")), true);

end run_simulation;