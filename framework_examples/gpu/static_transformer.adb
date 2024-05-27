------------------------------------------------------------------------------
-- GPU
-- architecture_generator/architecture_factory.adb for unifast generator
------------------------------------------------------------------------------
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Generic_Graph;         use Generic_Graph;
with Core_Units;            use Core_Units;
use Core_Units.Core_Units_Table_Package;
with Tasks;          use Tasks;
with Task_Set;       use Task_Set;
with Task_Groups;    use Task_Groups;
with Task_Group_Set; use Task_Group_Set;
with Buffers;        use Buffers;
with Messages;       use Messages;
with Dependencies;   use Dependencies;
with Resources;      use Resources;
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
with Ada.Numerics.Discrete_Random;
with Ada.containers.vectors;
with gpu_generator;        use gpu_generator;

with Framework;                    	use Framework;
with Call_Framework;                    use Call_Framework;
with Call_Framework_Interface;          use Call_Framework_Interface;
use Call_Framework_Interface.Framework_Response_Package;
use Call_Framework_Interface.Framework_Request_Package;
with Call_Scheduling_Framework;         use Call_Scheduling_Framework;
with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;


package body static_transformer is

    procedure static_transformer
       (DAGs :        DAGList; Stream_To_TPC : in out StreamTPCMap;
        TPCs : in out TPCList; TPC_count : Integer)
    is

        package Task_Vector is new Ada.Containers.Vectors
           (Index_Type => Natural, Element_Type => Generic_Task_Ptr);

        dir1         			 	 : unbounded_string_list;	

        transformed_system : System;
        generated_system   : System;
        core_ptr           : Core_Unit_Ptr;
        cpu_ptr            : generic_processor_ptr;
        cur_task           : Generic_Task_Ptr;
        prev_task          : Generic_Task_Ptr;
        message_ptr        : generic_message_ptr;
        cur_kernel         : Kernel;
        cur_dag            : DAG;

        task_index       : Integer          := 1;
        core_name_prefix : unbounded_string := Suppress_Space ("SM_");
        sm_per_tpc       : Integer          := 2;
        max_sm_size      : Integer          := 1_024;

        --core_unit_table_ptr : Core_Units_Table;

        subtype Range_1_10 is Integer range 1 .. 10;
        subtype Range_1_100 is Integer range 1 .. 100;
        package Rand_1_10 is new Ada.Numerics.Discrete_Random (Range_1_10);
        package Rand_1_100 is new Ada.Numerics.Discrete_Random (Range_1_100);
        Gen_1_10          : Rand_1_10.Generator;
        Gen_1_100         : Rand_1_100.Generator;
        tpc_block_size    : Integer;
        cpu_count         : Integer;
        cpu_index         : Integer;
        cur_tpc           : TPC_ptr;
        prev_tasks        : Task_Vector.Vector;
        cur_tasks         : Task_Vector.Vector;
        prev_task_counter : Integer;

    begin
        Rand_1_10.Reset (Gen_1_10);
        Rand_1_100.Reset (Gen_1_100);

        --  Call_Framework.initialize (False);

        --  initialize (generated_system);

        --  Read_From_Xml_File
        --     (generated_system, dir1,
        --      "framework_examples/gpu/inputs/input_Model.xmlv3");

        Set_initialize;
        initialize (transformed_system);

        for i in 1 .. TPC_count loop
            tpc_block_size := TPCs (i).max_block_size;
            Put_Line ("TPC " & i'Img & " block size: " & tpc_block_size'Img);
            cpu_count    := (max_sm_size / tpc_block_size) * sm_per_tpc;
            TPCs (i).SMs := new SM_Array (1 .. cpu_count);
            --core_unit_table_ptr := new Core_Units_Table;
            for j in 1 .. cpu_count loop
                Add_core_unit
                   (My_core_units            => transformed_system.Core_units,
                    A_core_unit              => core_ptr,
                    Name                     =>
                       Suppress_Space
                          ((("core-TPC_" & i'Img) & "-" & core_name_prefix &
                            j'Img)),
                    Is_Preemptive => preemptive, Quantum => 5, speed => 1,
                    capacity                 => 1, period => 1, priority => 1,
                    File_Name                => empty_string,
                    A_Scheduler => posix_1003_highest_priority_first_protocol,
                    scheduling_protocol_name => To_Unbounded_String (""),
                    automaton_name           => empty_string, start_time => 0);
                Put_Line ("Core unit added");

                add_processor
                   (My_Processors => transformed_system.Processors,
                    Name          =>
                       Suppress_Space
                          ((("TPC_" & i'Img) & "-" & core_name_prefix &
                            j'Img)),
                    a_processor   => cpu_ptr, a_core => core_ptr);

                TPCs (i).SMs (j) := cpu_ptr;

                Put_Line ("Processor added");

                Add_Address_Space
                   (My_Address_Spaces => transformed_system.Address_Spaces,
                    Name              =>
                       Suppress_Space
                          (("Address_Space_" & ("TPC_" & i'Img) & "-" &
                            core_name_prefix & j'Img)),
                    Cpu_Name          =>
                       Suppress_Space
                          ((("TPC_" & i'Img) & "-" & core_name_prefix &
                            j'Img)),
                    Text_Memory_Size  => 1_024, Stack_Memory_Size => 1_024,
                    Data_Memory_Size  => 1_024, Heap_Memory_Size => 1_024);
                Put_Line ("Address space added");
            end loop;
        end loop;

        -- tasks
        Initialize (transformed_system.Tasks);

        for dag_index in 1 .. DAGs'Length loop
            cur_dag := DAGs (dag_index);
            for tpc_index in 1 .. stream_to_tpc (cur_dag.stream)'Length loop
                cur_tpc := stream_to_TPC (cur_dag.stream) (tpc_index);
                prev_tasks.Clear;
                cur_tasks.Clear;
                cur_task  := null;
                prev_task := null;

                for i in 1 .. cur_dag.kernel_count
                loop -- for kernel in cur_dag.kernels
                    cur_kernel := cur_dag.kernels (i);
                    cpu_index  := 1;

                    for j in 1 .. cur_kernel.block_count loop

                        Add_Task
                           (My_Tasks           => transformed_system.Tasks,
                            A_Task             => cur_task,
                            Name               =>
                               Suppress_Space
                                  (To_Unbounded_String
                                      ("DAG" & Integer'Image (cur_dag.id) &
                                       "-Kernel" & Integer'Image (i) &
                                       "-Block" & Integer'Image (j))),
                            -- TPC_x-SM_y
                            Cpu_Name           =>
                               Suppress_Space
                                  ("TPC_" &
                                   Integer'Image
                                      (cur_tpc.id) &
                                   "-" & core_name_prefix & cpu_index'Img),
                            core_name          => empty_string,
                            Address_Space_Name =>
                               Suppress_Space
                                  ("Address_Space_" &
                                   ("TPC_" &
                                    Integer'Image
                                       (cur_tpc.id) &
                                    "-" & core_name_prefix & cpu_index'Img)),
                            Task_Type => Periodic_Type, Start_Time => 0,
                            Capacity           => cur_kernel.capacity,
                            Period             => cur_dag.period,
                            Deadline => cur_dag.deadline,
                            Priority           => cur_dag.stream,
                            -- User_Defined_Parameters_Table, ???????
                            Jitter             => 0,
                            Blocking_Time      => 0, Criticality => 0,
                            Policy             => Sched_Fifo);

                        cur_tasks.Append (cur_task);
                        put_line
                           ("Task " & to_string (cur_task.name) &
                            " added to system");

                        -- task_index := task_index + 1;

                        if i > 1 then
                            prev_task_counter := 1;
                            for prev_taskk of prev_tasks loop
                                add_message
                                   (my_messages => transformed_system.messages,
                                    a_message          => message_ptr,
                                    name               =>
                                       Suppress_Space
                                          (To_Unbounded_String
                                              ("message:DAG" &
                                               Integer'Image (cur_dag.id) & "-" &
                                               "Kernel" & Integer'Image (i - 1) &
                                               "_to_" & "Kernel" &
                                               Integer'Image (i) & "::Prev" &
                                               Integer'Image
                                                  (prev_task_counter) &
                                               "-Block" & Integer'Image (j))),
                                    size => 0, period => 0, deadline => 0,
                                    jitter             => 0,
                                    param => no_user_defined_parameter,
                                    response_time      => 0,
                                    communication_time => 0);

                                add_one_task_dependency_asynchronous_communication
                                   (my_dependencies   =>
                                       transformed_system.dependencies,
                                    a_task => cur_task, a_dep => message_ptr,
                                    a_type            => from_object_to_task,
                                    protocol_property => first_message);

                                add_one_task_dependency_asynchronous_communication
                                   (my_dependencies   =>
                                       transformed_system.dependencies,
                                    a_task => prev_taskk, a_dep => message_ptr,
                                    a_type            => from_task_to_object,
                                    protocol_property => first_message);
                                prev_task_counter := prev_task_counter + 1;
                                put_line
                                   ("Message " & to_string (message_ptr.name) &
                                    " added to system");
                            end loop;
                        end if;

                        cpu_index := cpu_index + 1;
                        if cur_tpc.SMs'Length > 0 then
                            cpu_index := (cpu_index mod cur_tpc.SMs'Length);
                        else
                            put_line ("Error: SMs length is 0");
                        end if;
                        if cpu_index = 0 then
                            cpu_index := 1;
                        end if;
                    end loop;

                    prev_tasks.Clear;
                    for taskk of cur_tasks loop
                        prev_tasks.Append (taskk);
                    end loop;
                    cur_tasks.Clear;
                end loop;
            end loop;
        end loop;

        Put_Line ("------------------------");
        Put_Line("Hyperperiod: " & Integer'Image (compute_hyperperiod(transformed_system.Tasks)));
        Put_Line ("Write system to xml file");
        Write_To_Xml_File
           (a_system => transformed_system,
            File_Name          =>
               Suppress_Space
                  (To_Unbounded_String
                      ("framework_examples/gpu/inputs/analysis_model_" & DAGs(1).kernels(1).block_count'Img & ".xmlv3")));
        Put_Line ("Finish write");
        Put_Line ("System Transformed for Cheddar Simulation");
        Put_Line ("------------------------");

    end static_transformer;

end static_transformer;
