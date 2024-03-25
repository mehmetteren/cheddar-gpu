with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with AADL_Config;              use AADL_Config;
with unbounded_strings;        use unbounded_strings;
with Text_IO;                  use Text_IO;
with Ada.Exceptions;           use Ada.Exceptions;
with translate;                use translate;
with processor_set;            use processor_set;
with text_io;                  use text_io;
with ada.strings.unbounded;    use ada.strings.unbounded;
with unbounded_strings;        use unbounded_strings;
with Dependencies;             use Dependencies;
with Task_Dependencies;        use Task_Dependencies;
with Task_Dependencies;        use Task_Dependencies.Half_Dep_Set;
with sets;
with Tasks;                    use Tasks;
with Task_Set;                 use Task_Set;
with Message_Set;              use Message_Set;
with Messages;                 use Messages;
with Systems;                  use Systems;
with Framework;                use Framework;
with Call_Framework;           use Call_Framework;
with Call_Framework_Interface; use Call_Framework_Interface;
use Call_Framework_Interface.Framework_Response_Package;
use Call_Framework_Interface.Framework_Request_Package;
with Call_Scheduling_Framework;         use Call_Scheduling_Framework;
with Multiprocessor_Services;           use Multiprocessor_Services;
with Multiprocessor_Services_Interface; use Multiprocessor_Services_Interface;
with Multiprocessor_Services_Interface;
use Multiprocessor_Services_Interface.Scheduling_Result_Per_Processor_Package;
with GNAT.Command_Line;
with GNAT.OS_Lib; use GNAT.OS_Lib;
with Version;     use Version;
with Parameters;  use Parameters;
use Parameters.User_Defined_Parameters_Table_Package;
with Parameters.extended;              use Parameters.extended;
with Network_Set;                      use Network_Set;
with Networks;                         use Networks;
with noc_analysis;                     use noc_analysis;
with noc_flow_transformation;          use noc_flow_transformation;
with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;
with Parameters;                       use Parameters;
with Parameters.extended;              use Parameters.extended;
use Parameters.Framework_Parameters_Table_Package;
procedure transformator is
    dir1 : unbounded_string_list;
    Sys : System;
    Task_List : Task_Set_Ptr;
begin

    Call_Framework.initialize (False);

    initialize (Sys);

    Read_From_Xml_File
       (Sys, dir1,
        "framework_examples/real_time/input_model.xmlv3");

    display_system (System2 => Sys);

    Task_List := Sys.Tasks;

    for task_ in Task_List'Range loop

        Declare
            task_deadline : Natural := task_.deadline;
            task_id       : String  := task_.id;
        Begin
            task_.priority := task_deadline * task_id;
        End;
    end loop;

    Write_To_Xml_File
        (A_System  => Sys,
        File_Name =>
            "framework_examples/real_time/output_model.xmlv3");


end Adjust_Task_Priorities_By_Deadline;
