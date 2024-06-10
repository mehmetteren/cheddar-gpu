------------------------------------------------------------------------------
-- Simplified 2-Core System
-- architecture_generator/architecture_factory.adb for unifast generator
------------------------------------------------------------------------------
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Core_Units;            use Core_Units;
use Core_Units.Core_Units_Table_Package;
with Tasks;          use Tasks;
with Task_Set;       use Task_Set;
with Task_Groups;    use Task_Groups;
with Task_Group_Set; use Task_Group_Set;
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
with initialize_framework; use initialize_framework;
with Random_Tools;         use Random_Tools;
with Ada.Numerics.Float_Random;
with Ada.Numerics.Discrete_Random;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;

package body gpu_generator is

    procedure iterate_over_system
       (DAGs             : in out DAGList; stream_to_TPC : in out StreamTPCMap;
        TPCs             : in out TPCList; TPC_count : in Integer;
        block_per_kernel : in     Integer)
    is
        cur_dag    : DAG;
        cur_kernel : Kernel;
    begin

        for i in 1 .. DAGs'Length loop
            cur_dag := DAGs (i);

            for j in 1 .. cur_dag.kernel_count loop
                cur_dag.kernels (j).block_count := block_per_kernel;

                put_line
                   ("DAG " & cur_dag.id'Img & " Kernel " & cur_kernel.id'Img &
                    " Period: " & cur_dag.period'Img & " Capacity: " &
                    cur_kernel.capacity'Img & " Deadline: " &
                    cur_dag.deadline'Img);
            end loop;
        end loop;

    end iterate_over_system;

    procedure generate_dag_specs_uunifast
       (DAGs : in out DAGList; total_block_count : in Integer;
        target_cpu_utilization  : in Float; n_different_periods : in Integer;
        current_cpu_utilization : in out Float; d_min : in Float := 1.0;
        d_max : in     Float := 1.0; is_synchronous : in Boolean := True)

    is
        use Ada.Numerics.Float_Random;

        a_factor                    : Integer;
        a_capacity                  : Natural := 0;
        a_period                    : Natural := 0;
        a_deadline                  : Natural := 0;
        a_start_time                : Natural := 0;
        a_random_deadline           : Float;
        omin, omax                  : Float;
        g                           : Ada.Numerics.Float_Random.Generator;
        cur_dag                     : DAG;
        u_values : random_tools.float_array (0 .. DAGs'Length - 1);
        t_values : random_tools.integer_array (1 .. DAGs'Length);
        block_index                 : Integer := 1;
        cur_max_capacity_for_kernel : Integer := 1;

        generic_Gen :
           Ada.Numerics.Float_Random
              .Generator;

        -- Function to generate a random integer between Low and High
        function Random_Range (Low, High : Integer) return Integer is
            Random_Value : Float   :=
               Ada.Numerics.Float_Random.Random
                  (generic_Gen); 
            the_range    : Integer := High - Low + 1;
            Scaled_Value : Integer :=
               Integer (Random_Value * Float (the_range)) +
               Low;
        begin
            return Scaled_Value; 
        end Random_Range;

        --  procedure Free is new Ada.Unchecked_Deallocation
        --   (Object => IntegerArray, Name => IntegerArray_ptr);

        function Random_Partition
           (Target_Value : Integer; Num_Parts : Natural)
            return IntegerArray_ptr
        is
            subtype Part_Range is Integer range 1 .. Num_Parts;
            subtype Target_Range is Integer range 1 .. Target_Value;

            package Rand_Int is new Ada.Numerics.Discrete_Random
               (Target_Range);
            Gen    : Rand_Int.Generator;
            Parts  : IntegerArray (Part_Range);
            Sum    : Integer := 0;
            Factor : Float;
        begin
            Rand_Int.Reset (Gen);
            for I in Part_Range loop
                Parts (i) := Rand_Int.Random (Gen);
                Sum       := Sum + Parts (I);
                put_line ("sum: " & sum'Img & "  parts: " & Parts (i)'Img);
            end loop;

            Factor := Float (Target_Value) / Float (Sum);

            Sum := 0;
            for I in Part_Range loop
                Parts (I) := Integer (Float (Parts (I)) * Factor);
                Sum       := Sum + Parts (I);
            end loop;

            if Sum /= Target_Value then
                Parts (Num_Parts) := Parts (Num_Parts) + (Target_Value - Sum);
            end if;

            for x in Part_Range loop
                put_line (Parts (x)'Img);
            end loop;

            return new IntegerArray'(Parts);
        end Random_Partition;

    begin

        a_factor := 2;--N_Tasks;
        Reset (g);
        Ada.Numerics.Float_Random.reset (generic_Gen);

        put_line ("Total block count: " & total_block_count'Img);
        put_line ("DAG count: " & DAGs'Length'Img);

        --  u_values := gen_uunifast (DAGs'Length, target_cpu_utilization);

        --  t_values :=
        --     generate_period_set_with_limited_hyperperiod
        --        (DAGs'Length, n_different_periods);

        for i in 1 .. DAGs'Length loop
            cur_dag  := DAGs (i);
            --  a_period :=
            --     Natural
            --        (t_values (i) *
            --         a_factor); -- A_factor inflates the periods to avoid too much execution times
            --  -- equal to zero due to integer rounding

            --  a_capacity :=
            --     Integer (Float'Rounding (Float (a_period) * u_values (i - 1)));
            --  if a_capacity = 0 then
            --      a_capacity := 1;
            --  end if;

            --  a_random_deadline := d_min + Random (g) * (d_max - d_min);
            --      while (a_random_deadline > d_max) or
            --         (a_random_deadline < d_min)
            --      loop
            --          a_random_deadline := d_min + Random (g) * (d_max - d_min);
            --      end loop;

            --      a_deadline :=
            --         Integer
            --            (Float'Rounding
            --                (Float (a_period - a_capacity) *
            --                 a_random_deadline)) +
            --         a_capacity;

            --      omin := 0.0;
            --      omax := Float (a_period);

            a_start_time := 0;

            --DAGs (i).period   := cur_dag.id * 20;
            --DAGs (i).deadline := cur_dag.id * 20;

            current_cpu_utilization :=
               current_cpu_utilization + Float (a_capacity) / Float (a_period);

            for kernel_index in 1 .. cur_dag.kernel_count loop
                cur_dag.kernels (kernel_index).capacity := Random_Range(1, 7);
                put_line
                   ("DAG " & cur_dag.id'Img & " Kernel " &
                    cur_dag.kernels (kernel_index).id'Img & " Period: " &
                    DAGs (i).period'Img & " Capacity: " &
                    cur_dag.kernels (kernel_index).capacity'Img &
                    " Deadline: " & DAGs (i).deadline'Img);
            end loop;
        end loop;

    end generate_dag_specs_uunifast;

    procedure gpu_generator
       (DAGs : in out DAGList; stream_to_TPC : in out StreamTPCMap;
        TPCs : in out TPCList; TPC_count : in Integer)
    is

        a_system    : System;
        core_ptr    : Core_Unit_Ptr;
        cpu_ptr     : generic_processor_ptr;
        cur_task    : Generic_Task_Ptr;
        prev_task   : Generic_Task_Ptr;
        message_ptr : generic_message_ptr;
        cur_kernel  : Kernel;
        cur_dag     : DAG;

        task_index              : Integer          := 1;
        core_name_prefix        : unbounded_string := Suppress_Space ("SM_");
        sm_per_tpc              : Integer          := 4;
        max_sm_size             : Integer          := 1_024;
        total_kernel_count      : Integer          := 0;
        current_cpu_utilization : Float            := 0.0;

        core_units : Core_Units_Table;

        subtype Range_1_10 is Integer range 1 .. 10;
        subtype Range_1_100 is Integer range 1 .. 100;
        package Rand_1_10 is new Ada.Numerics.Discrete_Random (Range_1_10);
        package Rand_1_100 is new Ada.Numerics.Discrete_Random (Range_1_100);
        Gen_1_10       : Rand_1_10.Generator;
        Gen_1_100      : Rand_1_100.Generator;
        tpc_block_size : Integer;
        cur_tpc        : TPC_ptr;

    begin
        for i in 1 .. DAGs'Length loop
            total_kernel_count := total_kernel_count + DAGs (i).kernel_count;
        end loop;

        --  generate_dag_specs_uunifast
        --     (DAGs => DAGs, total_kernel_count => total_kernel_count,
        --      target_cpu_utilization  => 0.4, n_different_periods => 10,
        --      current_cpu_utilization => current_cpu_utilization);

        Rand_1_10.Reset (Gen_1_10);
        Rand_1_100.Reset (Gen_1_100);

        Set_Initialize;
        Initialize (A_System => a_system);

        -- generate symbolic core units (SMs)
        for i in 1 .. sm_per_tpc loop
            Add_core_unit
               (My_core_units => a_system.Core_units, A_core_unit => core_ptr,
                Name => Suppress_Space ((core_name_prefix & i'Img)),
                Is_Preemptive => preemptive, Quantum => 5, speed => 1,
                capacity                 => 1, period => 1, priority => 1,
                File_Name                => empty_string,
                A_Scheduler => posix_1003_highest_priority_first_protocol,
                scheduling_protocol_name => To_Unbounded_String (""),
                automaton_name           => empty_string, start_time => 0);
            Put_Line ("Core unit " & i'Img & " created");
            add (core_units, core_ptr);
        end loop;

        for i in 1 .. TPC_count loop
            cur_tpc := TPCs (i);
            add_processor
               (My_Processors => a_system.Processors,
                Name          => Suppress_Space (("TPC_" & cur_tpc.id'Img)),
                a_processor   => cpu_ptr, cores => core_units);

            Put_Line ("Processor" & cur_tpc.id'Img & " created");

            Add_Address_Space
               (My_Address_Spaces => a_system.Address_Spaces,
                Name              =>
                   Suppress_Space
                      ("Address_Space_" & ("TPC_" & cur_tpc.id'Img)),
                Cpu_Name => Suppress_Space (("TPC_" & cur_tpc.id'Img)),
                Text_Memory_Size  => 1_024, Stack_Memory_Size => 1_024,
                Data_Memory_Size  => 1_024, Heap_Memory_Size => 1_024);
            Put_Line ("Address space added");
        end loop;

        -- tasks
        Initialize (a_system.Tasks);

        for dag_index in 1 .. DAGs'Length loop
            cur_dag   := DAGs (dag_index);
            cur_task  := null;
            prev_task := null;
            cur_tpc   := null;
            for tpc_index in 1 .. stream_to_TPC (cur_dag.stream)'Length
            loop -- add task to each tpc that this dag is assigned to
                cur_tpc := stream_to_TPC (cur_dag.stream) (tpc_index);
                for i in 1 .. cur_dag.kernel_count
                loop -- for kernel in cur_dag.kernels
                    cur_kernel := cur_dag.kernels (i);

                    Add_Task
                       (My_Tasks => a_system.Tasks, A_Task => cur_task,
                        Name               =>
                           Suppress_Space
                              (To_Unbounded_String
                                  ("DAG_" & Integer'Image (cur_dag.id) &
                                   "-Kernel_" & Integer'Image (i))),
                        Cpu_Name => Suppress_Space (("TPC_" & cur_tpc.id'Img)),
                        core_name          => empty_string,
                        Address_Space_Name =>
                           Suppress_Space
                              ("Address_Space_" &
                               Suppress_Space (("TPC_" & cur_tpc.id'Img))),
                        Task_Type          => Periodic_Type, Start_Time => 0,
                        Capacity           => cur_kernel.capacity,
                        Period => cur_dag.period, Deadline => cur_dag.deadline,
                        Priority           => cur_dag.stream,
                        -- User_Defined_Parameters_Table, ???????
                        Jitter             => 0,
                        Blocking_Time      => 0, Criticality => 0,
                        Policy             => Sched_Fifo);
                    put_line
                       ("Task " & to_string (cur_task.name) &
                        " added to system");

                    if i > 1 then
                        add_message
                           (my_messages   => a_system.messages,
                            a_message     => message_ptr,
                            name          =>
                               Suppress_Space
                                  (To_Unbounded_String
                                      ("message:DAG" &
                                       Integer'Image (cur_dag.id) & "-" &
                                       "kernel" & Integer'Image (i - 1) &
                                       "_to_" & "kernel" & Integer'Image (i) &
                                       "_TPC" & cur_tpc.id'Img)),
                            size => 0, period => 0, deadline => 0, jitter => 0,
                            param         => no_user_defined_parameter,
                            response_time => 0, communication_time => 0);

                        put_line
                           ("Message " & to_string (message_ptr.name) &
                            " added to system");

                        add_one_task_dependency_asynchronous_communication
                           (my_dependencies   => a_system.dependencies,
                            a_task => cur_task, a_dep => message_ptr,
                            a_type            => from_task_to_object,
                            protocol_property => first_message);

                        add_one_task_dependency_asynchronous_communication
                           (my_dependencies   => a_system.dependencies,
                            a_task => prev_task, a_dep => message_ptr,
                            a_type            => from_object_to_task,
                            protocol_property => first_message);

                        put_line
                           ("Dependency added between " &
                            to_string (prev_task.name) & " and " &
                            to_string (cur_task.name));
                    end if;
                    prev_task := cur_task;
                end loop;
            end loop;
        end loop;

        Put_Line ("------------------------");
        Put_Line ("Write system to xml file");
        Write_To_Xml_File
           (A_System  => a_system,
            File_Name =>
               Suppress_Space
                  (To_Unbounded_String
                      ("framework_examples/gpu/inputs/input_model.xmlv3")));
        Put_Line ("Finish write");
        Put_Line ("System Generated for Cheddar Simulation");
        Put_Line ("------------------------");

    end gpu_generator;

end gpu_generator;
