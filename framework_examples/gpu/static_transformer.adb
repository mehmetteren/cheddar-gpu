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

with Framework;                use Framework;
with Call_Framework;           use Call_Framework;
with Call_Framework_Interface; use Call_Framework_Interface;
use Call_Framework_Interface.Framework_Response_Package;
use Call_Framework_Interface.Framework_Request_Package;
with Call_Scheduling_Framework; use Call_Scheduling_Framework;
with feasibility_test.processor_utilization;
use feasibility_test.processor_utilization;

with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;

package body static_transformer is

   procedure generate_dummy_workload_simple
     (cheddar_system      : in out System; current_utilization : in out Float;
      no_of_tasks_per_cpu : in     Integer; TPCs : in TPCList; algo : in Unbounded_string)
   is
      a_factor          : Integer;
      a_capacity        : Natural := 0;
      a_period          : Natural := 0;
      a_deadline        : Natural := 0;
      a_start_time      : Natural := 0;
      a_priority : Integer := 2;
      a_random_deadline : Float;

      a_random_offset : Float;
      my_tasks        : tasks_set;
      cur_TPC         : TPC_ptr;
      cur_cpu         : generic_processor_ptr;
      cur_task        : generic_task_ptr;
   begin
      for tpc_index in 1 .. TPCs'Length loop
         cur_TPC := TPCs (tpc_index);

         for cpu_index in 1 .. cur_TPC.SMs'Length loop
            cur_cpu             := cur_TPC.SMs (cpu_index);
            current_utilization :=
              Float
                (processor_utilization_over_period
                   (cheddar_system.tasks, cur_cpu.name));

            if current_utilization > 0.9 then
               put_line ("current utilization is higher than 0.9");
            end if;
            for i in 1 .. no_of_tasks_per_cpu loop
               a_capacity := i * 2;
               a_period := i * 30;
               a_deadline := a_period;

               if algo = "round_robin" then
                  a_priority := (i mod 2) + 1;
               else
                  a_priority := 2;
               end if;

               current_utilization :=
                 current_utilization + Float (a_capacity) / Float (a_period);

               --  put_line
               --    ("Current CPU utilization: " & current_utilization'Img);

               add_task
                 (my_tasks => cheddar_system.tasks, A_Task => cur_task,
                  name               =>
                    suppress_space
                      (To_Unbounded_String
                         (tpc_index'Img & "_" & cpu_index'Img &
                          "_dummy_task_" & i'Img)),
                  cpu_name           => cur_cpu.name,
                  address_space_name =>
                    suppress_space ("Address_Space_" & cur_cpu.name),
                  core_name => empty_string, task_type => periodic_type,
                  start_time         => 0, capacity => a_capacity,
                  period => a_period, deadline => a_deadline, jitter => 0,
                  blocking_time      => 0, priority => a_priority,
                  criticality        => 0, policy => Sched_Fifo);

               -- put_line ("Added task " & to_string (cur_task.name));
            end loop;
         end loop;
      end loop;
   end generate_dummy_workload_simple;

   procedure generate_dummy_workload
     (cheddar_system     : in out System; current_utilization : in out Float;
      target_utilization : in out Float; no_of_tasks_per_cpu : in Integer;
      TPCs               : in     TPCList; algo : in Unbounded_String)
   is
      n_different_periods : Integer := 10;
      d_min               : Float   := 1.0;
      d_max               : Float   := 1.0;
      is_synchronous      : Boolean := True;

      use Ada.Numerics.Float_Random;

      a_factor          : Integer;
      a_capacity        : Natural := 0;
      a_period          : Natural := 0;
      a_deadline        : Natural := 0;
      a_start_time      : Natural := 0;
      a_random_deadline : Float;
      omin, omax        : Float;
      g                 : Ada.Numerics.Float_Random.Generator;
      u_values : random_tools.float_array (0 .. no_of_tasks_per_cpu - 1);
      t_values : random_tools.integer_array (1 .. no_of_tasks_per_cpu);

      a_random_offset : Float;
      my_tasks        : tasks_set;
      cur_TPC         : TPC_ptr;
      cur_cpu         : generic_processor_ptr;
      cur_task        : generic_task_ptr;

      a_priority : Integer := 2;
   begin

      a_factor := 2;--N_Tasks;

      for tpc_index in 1 .. TPCs'Length loop
         cur_TPC := TPCs (tpc_index);

         for cpu_index in 1 .. cur_TPC.SMs'Length loop
            cur_cpu             := cur_TPC.SMs (cpu_index);
            current_utilization :=
              Float
                (processor_utilization_over_period
                   (cheddar_system.tasks, cur_cpu.name));

            if current_utilization > target_utilization then
               put_line ("current utilization is higher than target");
            end if;

            Reset (g);

            u_values := gen_uunifast (no_of_tasks_per_cpu, target_utilization);

            t_values :=
              generate_period_set_with_limited_hyperperiod
                (no_of_tasks_per_cpu, n_different_periods);

            for i in 1 .. no_of_tasks_per_cpu loop

               if algo = "round_robin" then
                  a_priority := (i mod 2) + 1;
               end if;
               if current_utilization < target_utilization then
                  a_period :=
                    Natural
                      (t_values (i) *
                       a_factor); -- A_factor inflates the periods to avoid too much execution times
                  -- equal to zero due to integer rounding

                  a_capacity :=
                    Integer
                      (Float'Rounding (Float (a_period) * u_values (i - 1)));
                  if a_capacity = 0 then
                     a_capacity := 1;
                  end if;

                  a_random_deadline := d_min + Random (g) * (d_max - d_min);
                  while (a_random_deadline > d_max) or
                    (a_random_deadline < d_min)
                  loop
                     a_random_deadline := d_min + Random (g) * (d_max - d_min);
                  end loop;

                  a_deadline :=
                    Integer
                      (Float'Rounding
                         (Float (a_period - a_capacity) * a_random_deadline)) +
                    a_capacity;

                  omin := 0.0;
                  omax := Float (a_period);

                  if (not is_synchronous) then
                     a_random_offset := omin + Random (g) * (omax - omin);
                     while (a_random_offset > omax) or (a_random_offset < omin)
                     loop
                        a_random_offset := omin + Random (g) * (omax - omin);
                     end loop;
                     a_start_time :=
                       Integer (Float'Rounding (a_random_offset));
                  else
                     a_start_time := 0;
                  end if;

                  current_utilization :=
                    current_utilization +
                    Float (a_capacity) / Float (a_period);

                  put_line
                    ("Current CPU utilization: " & current_utilization'Img);

                  add_task
                    (my_tasks => cheddar_system.tasks, A_Task => cur_task,
                     name               =>
                       suppress_space
                         (To_Unbounded_String
                            (tpc_index'Img & "_" & cpu_index'Img &
                             "_dummy_task_" & i'Img)),
                     cpu_name           => cur_cpu.name,
                     address_space_name =>
                       suppress_space ("Address_Space_" & cur_cpu.name),
                     core_name => empty_string, task_type => periodic_type,
                     start_time => a_start_time, capacity => a_capacity,
                     period => a_period, deadline => a_deadline, jitter => 0,
                     blocking_time      => 0, priority => a_priority,
                     criticality        => 0, policy => Sched_Fifo);

                  put_line ("Added task " & to_string (cur_task.name));
               end if;
            end loop;
         end loop;
      end loop;

   end generate_dummy_workload;

   procedure static_transformer
     (transformed_system : in out System; DAGs : DAGList;
      Stream_To_TPC      : in out StreamTPCMap; TPCs : in out TPCList;
      TPC_count          :        Integer; algo : in unbounded_string)
   is

      package Task_Vector is new Ada.Containers.Vectors
        (Index_Type => Natural, Element_Type => Generic_Task_Ptr);

      dir1 : unbounded_string_list;

      generated_system : System;
      core_ptr         : Core_Unit_Ptr;
      cpu_ptr          : generic_processor_ptr;
      cur_task         : Generic_Task_Ptr;
      prev_task        : Generic_Task_Ptr;
      message_ptr      : generic_message_ptr;
      cur_kernel       : Kernel;
      cur_dag          : DAG;

      task_index       : Integer          := 1;
      core_name_prefix : unbounded_string := Suppress_Space ("SM_");
      sm_per_tpc       : Integer          := 2;
      max_sm_size      : Integer          := 1_024;

      --core_unit_table_ptr : Core_Units_Table;
      subtype Range_1_10 is Integer range 1 .. 10;
      subtype Range_1_100 is Integer range 1 .. 100;
      package Rand_1_10 is new Ada.Numerics.Discrete_Random (Range_1_10);
      package Rand_1_100 is new Ada.Numerics.Discrete_Random (Range_1_100);
      Gen_1_10            : Rand_1_10.Generator;
      Gen_1_100           : Rand_1_100.Generator;
      tpc_block_size      : Integer;
      cpu_count           : Integer;
      cpu_index           : Integer;
      cur_tpc             : TPC_ptr;
      prev_tasks          : Task_Vector.Vector;
      cur_tasks           : Task_Vector.Vector;
      prev_task_counter   : Integer;
      inc_cpu_count       : Boolean;
      task_capacity_index : Integer := 1;
      generic_Gen         :
        Ada.Numerics.Float_Random
          .Generator; -- Declare the random number generator.
         
      sched_type : Schedulers_Type;
      a_priority : Integer := 2;
      subsub : Boolean := false;
      sub_counter : Integer := 1;


      -- Function to generate a random integer between Low and High
      function Random_Range (Low, High : Integer) return Integer is
         Random_Value : Float   :=
           Ada.Numerics.Float_Random.Random
             (generic_Gen); -- Generate a random float between 0.0 and 1.0
         the_range    : Integer := High - Low + 1; -- Compute the range size
         Scaled_Value : Integer :=
           Integer (Random_Value * Float (the_range)) +
           Low; -- Scale and shift the random value
      begin
         return Scaled_Value; -- Return the scaled random integer
      end Random_Range;

   begin
      Rand_1_10.Reset (Gen_1_10);
      Rand_1_100.Reset (Gen_1_100);
      Ada.Numerics.Float_Random.reset (generic_Gen);

      --  Call_Framework.initialize (False);

      --  initialize (generated_system);

      --  Read_From_Xml_File
      --     (generated_system, dir1,
      --      "framework_examples/gpu/inputs/input_Model.xmlv3");

      Set_initialize;
      initialize (transformed_system);

      if algo = "round_robin" or algo = "fixed_priority" then
         sched_type := Posix_1003_Highest_Priority_First_Protocol;
      elsif algo = "rate_monotonic" then
         sched_type := Rate_Monotonic_Protocol;
      elsif algo = "deadline_monotonic" then
         sched_type := Deadline_Monotonic_Protocol;
      end if;

      for i in 1 .. TPC_count loop
         sm_per_tpc     := 2;
         tpc_block_size := TPCs (i).max_block_size;
         sm_per_tpc     := sm_per_tpc * TPCs (i).resource_multiplier;
         Put_Line ("TPC " & i'Img & " block size: " & tpc_block_size'Img);
         cpu_count := (max_sm_size / tpc_block_size) * sm_per_tpc;
         put_line
           ("smpertpc: " & sm_per_tpc'Img & "  cpu_count: " & cpu_count'Img);
         TPCs (i).SMs := new SM_Array (1 .. cpu_count);
         --core_unit_table_ptr := new Core_Units_Table;

         for j in 1 .. cpu_count loop
            Add_core_unit
              (My_core_units            => transformed_system.Core_units,
               A_core_unit              => core_ptr,
               Name                     =>
                 Suppress_Space
                   ((("core-TPC_" & i'Img) & "-" & core_name_prefix & j'Img)),
               Is_Preemptive => preemptive, Quantum => 0, speed => 1,
               capacity                 => 1, period => 1, priority => 1,
               File_Name                => empty_string,
               A_Scheduler => sched_type,
               scheduling_protocol_name => To_Unbounded_String (""),
               automaton_name           => empty_string, start_time => 0);
            --Put_Line ("Core unit added");

            add_processor
              (My_Processors => transformed_system.Processors,
               Name          =>
                 Suppress_Space
                   ((("TPC_" & i'Img) & "-" & core_name_prefix & j'Img)),
               a_processor   => cpu_ptr, a_core => core_ptr);

            TPCs (i).SMs (j) := cpu_ptr;

            --Put_Line ("Processor added");

            Add_Address_Space
              (My_Address_Spaces => transformed_system.Address_Spaces,
               Name              =>
                 Suppress_Space
                   (("Address_Space_" & ("TPC_" & i'Img) & "-" &
                     core_name_prefix & j'Img)),
               Cpu_Name          =>
                 Suppress_Space
                   ((("TPC_" & i'Img) & "-" & core_name_prefix & j'Img)),
               Text_Memory_Size  => 1_024, Stack_Memory_Size => 1_024,
               Data_Memory_Size  => 1_024, Heap_Memory_Size => 1_024);
            --Put_Line ("Address space added");
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
               if i mod 2 = 1 then
                  inc_cpu_count := True;
                  cpu_index     := 1;
               else
                  inc_cpu_count := False;
                  cpu_index     := cur_tpc.SMs'Length;
               end if;

               for j in 1 .. cur_kernel.block_count loop

                  if algo = "round_robin" then
                     a_priority := ((i+1) mod 2) + 1;
                  end if;                  

                  Add_Task
                    (My_Tasks => transformed_system.Tasks, A_Task => cur_task,
                     Name               =>
                       Suppress_Space
                         (To_Unbounded_String
                            ("DAG" & Integer'Image (cur_dag.id) & "-Kernel" &
                             Integer'Image (i) & "-Block" &
                             Integer'Image (j))),
                     -- TPC_x-SM_y
                     Cpu_Name           =>
                       Suppress_Space
                         ("TPC_" & Integer'Image (cur_tpc.id) & "-" &
                          core_name_prefix & cpu_index'Img),
                     core_name          => empty_string,
                     Address_Space_Name =>
                       Suppress_Space
                         ("Address_Space_" &
                          ("TPC_" & Integer'Image (cur_tpc.id) & "-" &
                           core_name_prefix & cpu_index'Img)),
                     Task_Type          => Periodic_Type, Start_Time => 0,
                     Capacity => cur_kernel.capacity, Period => cur_dag.period,
                     Deadline => cur_dag.deadline, Priority => a_priority,
                     -- User_Defined_Parameters_Table, ???????
                     Jitter => 0, Blocking_Time => 0, Criticality => 0,
                     Policy             => Sched_Fifo);
                  task_capacity_index := task_capacity_index + 1;
                  cur_tasks.Append (cur_task);
                  --  put_line
                  --    ("Task " & to_string (cur_task.name) & " added to system");

                  -- task_index := task_index + 1;

                  if i > 1 then
                     prev_task_counter := 1;
                     for prev_taskk of prev_tasks loop
                        add_message
                          (my_messages   => transformed_system.messages,
                           a_message     => message_ptr,
                           name          =>
                             Suppress_Space
                               (To_Unbounded_String
                                  ("message:DAG" & Integer'Image (cur_dag.id) &
                                   "-" & "Kernel" & Integer'Image (i - 1) &
                                   "_to_" & "Kernel" & Integer'Image (i) &
                                   "::Prev" &
                                   Integer'Image (prev_task_counter) &
                                   "-Block" & Integer'Image (j))),
                           size => 0, period => 0, deadline => 0, jitter => 0,
                           param         => no_user_defined_parameter,
                           response_time => 0, communication_time => 0);

                        add_one_task_dependency_asynchronous_communication
                          (my_dependencies => transformed_system.dependencies,
                           a_task            => cur_task, a_dep => message_ptr,
                           a_type            => from_object_to_task,
                           protocol_property => first_message);

                        add_one_task_dependency_asynchronous_communication
                          (my_dependencies => transformed_system.dependencies,
                           a_task => prev_taskk, a_dep => message_ptr,
                           a_type            => from_task_to_object,
                           protocol_property => first_message);
                        prev_task_counter := prev_task_counter + 1;
                        --  put_line
                        --    ("Message " & to_string (message_ptr.name) &
                        --     " added to system");
                     end loop;
                  end if;
                  if inc_cpu_count then
                     if cur_tpc.SMs'Length > 0 then
                        cpu_index := (cpu_index mod cur_tpc.SMs'Length);
                     else
                        put_line ("Error: SMs length is 0");
                     end if;
                     cpu_index := cpu_index + 1;
                  else
                     cpu_index := cpu_index - 1;
                     if cpu_index <= 0 then
                        cpu_index := cur_tpc.SMs'Length;
                     end if;
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

   end static_transformer;

   procedure finalize
     (transformed_system : in System; utilization : in out Float; algo : in Unbounded_string; index: Integer)
   is
      cpu_count       : Float := 0.0;
      total           : Float := 0.0;
      avg_utilization : Float := 0.0;
      util            : Float := 0.0;
      iterator        : Processors_Iterator;
      cpu             : generic_processor_ptr;
   begin
      reset_iterator (transformed_system.Processors, iterator);
      loop
         current_element (transformed_system.Processors, cpu, iterator);

         cpu_count := cpu_count + 1.0;
         util      :=
           Float
             (processor_utilization_over_period
                (transformed_system.tasks, cpu.name));
         Put_Line ("Util: " & Float'Image (util * 100.0));
         total := total + util;

         exit when is_last_element (transformed_system.Processors, iterator);
         next_element (transformed_system.Processors, iterator);
      end loop;

      avg_utilization := total / cpu_count;
      utilization     := avg_utilization;
      Put_Line ("------------------------");
      Put_Line(to_string("Scheduling algorithm: " & algo));
      Put_Line
        ("Hyperperiod: " &
         Integer'Image (compute_hyperperiod (transformed_system.Tasks)));
      Put_Line
        ("Average Utilization: %" & Integer (avg_utilization * 100.0)'Img);
      Put_Line ("Write system to xml file");
      --  Write_To_Xml_File
      --    (a_system  => transformed_system,
      --     File_Name =>
      --       Suppress_Space
      --         (
      --            ("framework_examples/gpu/inputs/" & algo & "_" &
      --             Integer (utilization * 100.0)'Img & ".xmlv3")));
      Write_To_Xml_File
        (a_system  => transformed_system,
         File_Name =>
           Suppress_Space
             (
                ("framework_examples/gpu/inputs/analysis_system_" & index'Img  &".xmlv3")));
      Put_Line ("Finish write");
      Put_Line ("System Transformed for Cheddar Simulation");
      Put_Line ("------------------------");

   end finalize;

end static_transformer;
