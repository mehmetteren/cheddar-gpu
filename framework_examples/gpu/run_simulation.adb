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


--  procedure run_simulation is

--     -- A set of variables required to call the framework
--     --
--     response_list         : framework_response_table;
--     request_list          : framework_request_table;
--     a_request             : framework_request;
--     a_param               : parameter_ptr;
--     sys                   : system;
--     project_file_list     : unbounded_string_list;
--     project_file_dir_list : unbounded_string_list;

--     -- Is the command should run in verbose mode ?
--     --
--     verbose : Boolean := False;

--     -- The XML file to read
--     --
--     input_file      : Boolean := False;
--     input_file_name : Unbounded_String;

--     -- The XML file to write
--     --
--     output_file      : Boolean := False;
--     output_file_name : Unbounded_String;

--     -- The duration on which we must compute the scheduling
--     --
--     period_string : Unbounded_String;
--     period        : Natural;
--     ok            : Boolean;

--     procedure usage is
--     begin
--        Put_Line
--          ("build_schedule_from_xml is a program which computes a scheduling from an XML  Cheddar project file and save the result into a second XML file.");

--        New_Line;
--        Put_Line
--          ("Check Cheddar home page for details :  http://beru.univ-brest.fr/cheddar ");
--        New_Line;
--        New_Line;
--        Put_Line ("Usage : build_schedule_from_xml [switch] period");
--        Put_Line ("   switch can be :");
--        Put_Line ("            -u get this help");
--        Put_Line ("            -v verbose mode ");
--        Put_Line
--          ("            -o file-name, write the scheduling into the XML file  file-name ");
--        Put_Line
--          ("            -i file-name, read the system to analyze from the XML file  file-name ");
--        New_Line;
--     end usage;

--  begin

--     copyright ("build_schedule_from_xml");

--     -- Get arguments
--     --
--     loop
--        case GNAT.Command_Line.Getopt ("u v i: o:") is
--           when ASCII.NUL =>
--              exit;

--           when 'i' =>
--              input_file      := True;
--              input_file_name :=
--                To_Unbounded_String (GNAT.Command_Line.Parameter);

--           when 'o' =>
--              output_file      := True;
--              output_file_name :=
--                To_Unbounded_String (GNAT.Command_Line.Parameter);
--           when 'v' =>
--              verbose := True;
--           when 'u' =>
--              usage;
--              OS_Exit (0);

--           when others =>
--              usage;
--              OS_Exit (0);
--        end case;
--     end loop;

--     loop
--        declare
--           s : constant String :=
--             GNAT.Command_Line.Get_Argument (Do_Expansion => True);

--        begin
--           exit when s'length = 0;
--           period_string := period_string & s;
--        end;
--     end loop;

--     -- Check the period on which we will compute the scheduling
--     --
--     to_natural (period_string, period, ok);
--     if not ok then
--        Raise_Exception
--          (Constraint_Error'identity,
--           "The period to compute the scheduling must be a numeric value");
--     end if;

--     -- Is an input file and an output file given ???
--     --
--     if (not input_file) or (not output_file) then
--        usage;
--        OS_Exit (0);
--     end if;

--     -- Initialize the Cheddar framework
--     --
--     call_framework.initialize (False);

--     -- Read the XML project file
--     --
--     initialize (project_file_list);
--     systems.read_from_xml_file (sys, project_file_dir_list, input_file_name);

--     -- Compute the scheduling on the period given by the argument
--     --
--     initialize (response_list);
--     initialize (request_list);
--     initialize (a_request);
--     a_request.statement    := scheduling_simulation_time_line;
--     a_param                := new parameter (integer_parameter);
--     a_param.parameter_name := To_Unbounded_String ("period");
--     a_param.integer_value  := period;
--     add (a_request.param, a_param);
--     a_param                := new parameter (boolean_parameter);
--     a_param.parameter_name := To_Unbounded_String ("schedule_with_offsets");
--     a_param.boolean_value  := True;
--     add (a_request.param, a_param);
--     a_param                := new parameter (boolean_parameter);
--     a_param.parameter_name :=
--       To_Unbounded_String ("schedule_with_precedencies");
--     a_param.boolean_value := True;
--     add (a_request.param, a_param);
--     a_param                := new parameter (boolean_parameter);
--     a_param.parameter_name := To_Unbounded_String ("schedule_with_resources");
--     a_param.boolean_value  := True;
--     add (a_request.param, a_param);
--     a_param                := new parameter (integer_parameter);
--     a_param.parameter_name := To_Unbounded_String ("seed_value");
--     a_param.integer_value  := 0;
--     add (a_request.param, a_param);
--     add (request_list, a_request);
--     sequential_framework_request (sys, request_list, response_list);

--     --if verbose then
--        Put_Line (To_String (response_list.entries (0).title));
--        for j in 0 .. response_list.nb_entries - 1 loop
--           Put_Line (To_String (response_list.entries (j).text));
--        end loop;
--     --end if;

--     -- Export Event table into the event_table.xml file
--     --
--     write_to_xml_file (framework.sched, sys, output_file_name);

--  end run_simulation;


procedure run_simulation is

    period : Integer;
    system_file_name : unbounded_string;
    extra : integer;
    the_system : System;
    dir1         			 	 : unbounded_string_list;	

begin
   Put_Line ("Number of arguments: " & Integer'Image (Argument_Count));

    Put_Line ("Period: " & Argument (1));
    Put_Line ("System: " & Argument (2));
    Put_Line ("Extra: " & Argument (3));
    period := Integer'Value (Argument (1));
    system_file_name := To_Unbounded_String (Argument (2));
    extra := Integer'Value (Argument (3));

    set_initialize;
    initialize (the_system);

    Read_From_Xml_File
        (the_system, dir1,
        system_file_name);

    compute_scheduling_of_tasks(period, the_system, Suppress_Space
                  (To_Unbounded_String
                      ("framework_examples/gpu/results/total_result_" & Integer'Image(extra) & ".txt")), true);

end run_simulation;