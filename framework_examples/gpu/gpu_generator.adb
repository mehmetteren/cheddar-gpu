------------------------------------------------------------------------------
-- Simplified 2-Core System
------------------------------------------------------------------------------
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Generic_Graph;         use Generic_Graph;
with Tasks;                 use Tasks;
with Task_Set;              use Task_Set;
with Task_Groups;           use Task_Groups;
with Task_Group_Set;        use Task_Group_Set;
with Buffers;               use Buffers;
with Messages;              use Messages;
with Dependencies;          use Dependencies;
with Resources;             use Resources;
use Resources.Resource_Accesses;
with Systems;            use Systems;
with Processors;         use Processors;
with Processor_Set;      use Processor_Set;
with Address_Spaces;     use Address_Spaces;
with Address_Space_Set;  use Address_Space_Set;
with Caches;             use Caches;
with Caches;             use Caches.Cache_Blocks_Table_Package;
with Message_Set;        use Message_Set;
with Buffer_Set;         use Buffer_Set;
with Network_Set;        use Network_Set;
with Event_Analyzer_Set; use Event_Analyzer_Set;
with Resource_Set;       use Resource_Set;
with Task_Dependencies;  use Task_Dependencies;
with Buffers;            use Buffers;
use Buffers.Buffer_Roles_Package;
with Queueing_Systems;     use Queueing_Systems;
with convert_strings;
with unbounded_strings;    use unbounded_strings;
with convert_unbounded_strings;
with Text_IO;              use Text_IO;
with Systems;              use Systems;
with Objects;              use Objects;
with Parameters.extended;  use Parameters.extended;
with Scheduler_Interface;  use Scheduler_Interface;
with Ada.Finalization;
with unbounded_strings;    use unbounded_strings;
with architecture_factory; use architecture_factory;
use unbounded_strings.unbounded_string_list_package;
with Unchecked_Deallocation;
with sets;
with Framework_Config;     use Framework_Config;
with Ada.Float_Text_IO;
with Offsets;              use Offsets;
with Offsets;              use Offsets.Offsets_Table_Package;
with Random_Tools;         use Random_Tools;
with initialize_framework; use initialize_framework;
with Random_Tools;         use Random_Tools;
with Ada.Numerics.Float_Random;
with Core_Units;           use Core_Units;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body gpu_generator is

    procedure gpu_generator is

        a_system                         : System;
        core_unit                        : Core_Unit_Ptr;
        address_space_1, address_space_2 : Address_Space;
        a_task                           : Generic_Task_Ptr;

        -- task parameters
        A_period   : Natural := 40;
        A_capacity : Natural := 20;

    begin

        Set_Initialize;
        Initialize (A_System => a_system);

        Add_core_unit
           (My_core_units  => a_system.Core_units, A_core_unit => core_unit,
            Name           =>
               Suppress_Space (To_Unbounded_String ("Core_1")),
            Is_Preemptive  => not_preemptive, Quantum => 0, speed => 1,
            capacity       => 1, period => 1, priority => 1,
            File_Name      => empty_string,
            A_Scheduler    => Earliest_Deadline_First_Protocol,
            scheduling_protocol_name => To_Unbounded_String(""),
            automaton_name => empty_string, start_time => 0);
        
        --  Add_core_unit
        --     (My_core_units  => a_system.Core_units, A_core_unit => core_unit,
        --      Name           =>
        --         Suppress_Space (To_Unbounded_String ("Core_2")),
        --      Is_Preemptive  => preemptive, Quantum => 0, speed => 1,
        --      capacity       => 1, period => 1, priority => 1,
        --      File_Name      => empty_string,
        --      A_Scheduler    => Earliest_Deadline_First_Protocol,
        --      scheduling_protocol_name => To_Unbounded_String(""),
        --      automaton_name => empty_string, start_time => 0);

        Add_Processor
           (My_Processors => a_system.Processors,
            Name          => (To_Unbounded_String ("Processor")),
            a_Core        => core_unit);

        -- adress spaces

        Add_Address_Space
           (My_Address_Spaces => a_system.Address_Spaces,
            Name              => To_Unbounded_String ("Address_Space"),
            Cpu_Name          => To_Unbounded_string ("Processor"),
            Text_Memory_Size  => 1_024, Stack_Memory_Size => 1_024,
            Data_Memory_Size  => 1_024, Heap_Memory_Size => 1_024);

        -- tasks
        Initialize (a_system.Tasks);

        for i in 1 .. 2 loop
            Add_Task
               (My_Tasks           => a_system.Tasks, A_Task => a_task,
                Name               => Suppress_Space(To_Unbounded_String ("Task1_" & i'Img)),
                Cpu_Name           => To_Unbounded_string ("Processor"),
                core_name          => empty_string,
                Address_Space_Name => To_Unbounded_String ("Address_Space"),
                Task_Type          => Periodic_Type, Start_Time => 0,
                Capacity           => A_capacity, Period => A_period,
                Deadline => A_period, Jitter => 0, Blocking_Time => 0,
                Priority => 1, Criticality => 0, Policy => Sched_Fifo);
        end loop;

        A_period   := 12;
        for i in 1 .. 2 loop
            
            Add_Task
               (My_Tasks           => a_system.Tasks, A_Task => a_task,
                Name               => Suppress_Space(To_Unbounded_String ("Task2_" & i'Img)),
                Cpu_Name           => To_Unbounded_string ("Processor"),
                core_name          => empty_string,
                Address_Space_Name => To_Unbounded_String ("Address_Space"),
                Task_Type          => Periodic_Type, Start_Time => 0,
                Capacity           => A_capacity, Period => A_period,
                Deadline => A_period, Jitter => 0, Blocking_Time => 0,
                Priority => 1, Criticality => 0, Policy => Sched_Fifo);
        end loop;


        Put_Line ("------------------------");
        Put_Line ("Write system to xml file");
        Write_To_Xml_File
           (A_System  => a_system,
            File_Name =>
               Suppress_Space
                  (To_Unbounded_String
                      ("framework_examples/real_time/inputs/input_model.xmlv3")));
        Put_Line ("Finish write");
        Put_Line ("Simple Monocore System Generated for Cheddar Simulation");
        Put_Line ("------------------------");

    end gpu_generator;

end gpu_generator;
