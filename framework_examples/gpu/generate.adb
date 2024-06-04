with gpu_generator;         use gpu_generator;
with write_xml;             use write_xml;
with Ada.Text_IO;           use Ada.Text_IO;
with unbounded_strings;     use unbounded_strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with static_transformer;    use static_transformer;
with Systems;               use Systems;

procedure generate is

    DAGss : DAGList := new DAGArray'
       (1 =>
           (Id      => 1, kernel_count => 4, Stream => 1,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 2, block_size => 1024, capacity => 10), 
                2 => (id => 2, block_count => 1, block_size => 1024, capacity => 10),
                3 => (id => 3, block_count => 8, block_size => 1024, capacity => 10), 
                4 => (id => 4, block_count => 1, block_size => 1024, capacity => 10)), others => <>),
         2 =>
           (Id      => 2, kernel_count => 3, Stream => 2,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 4, block_size => 1024, capacity => 10), 
                2 => (id => 2, block_count => 2, block_size => 1024, capacity => 10),
                3 => (id => 3, block_count => 8, block_size => 1024, capacity => 10)), others => <>));

   TPC_count     : constant Integer := 2;

   TPC13_1 : constant TPC_ptr :=
     new TPC'(Id => 1, max_block_size => 1_024, resource_multiplier => 1, SMs => null);
   TPC13_2 : constant TPC_ptr :=
     new TPC'(Id => 2, max_block_size => 1_024, resource_multiplier => 3, SMs => null);

   TPC13ss : TPCList := (1 => TPC13_1, 2 => TPC13_2);

   stream_to_TPC13 : StreamTPCMap     := (1 => new TPCList'(1 => TPC13_1), 2 => new TPCList'(1 => TPC13_2));

 -- ------- ------- ------- -------

   TPC31_1 : constant TPC_ptr :=
     new TPC'(Id => 1, max_block_size => 1_024, resource_multiplier => 3, SMs => null);
   TPC31_2 : constant TPC_ptr :=
     new TPC'(Id => 2, max_block_size => 1_024, resource_multiplier => 1, SMs => null);

   TPC31ss : TPCList := (1 => TPC31_1, 2 => TPC31_2);

   stream_to_TPC31 : StreamTPCMap     := (1 => new TPCList'(1 => TPC31_1), 2 => new TPCList'(1 => TPC31_2));

   -- ------- ------- ------- -------
      
   TPC22_1 : constant TPC_ptr :=
     new TPC'(Id => 1, max_block_size => 1_024, resource_multiplier => 2, SMs => null);
   TPC22_2 : constant TPC_ptr :=
     new TPC'(Id => 2, max_block_size => 1_024, resource_multiplier => 2, SMs => null);

   TPC22ss : TPCList := (1 => TPC22_1, 2 => TPC22_2);

   stream_to_TPC22 : StreamTPCMap     := (1 => new TPCList'(1 => TPC22_1), 2 => new TPCList'(1 => TPC22_2));

   current_cpu_utilization : Float   := 0.0;
   dag_cpu_utilization     : Float;
   total_block_count      : Integer := 0;
   -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4, 3 => 0.5, 4 => 0.6, 5 => 0.7, 6 => 0.8, 7 => 0.9, 8 => 1.0);
   -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4);

   filename       : Unbounded_string;
   system13 : system;
   system31 : system;
   system22 : system;

   cur_dag : DAG;
   task_capacities : IntegerArray_ptr;

begin
   for dag_index in 1 .. DAGss'Length loop
      cur_dag := DAGss(dag_index);
      for kernel_index in 1 .. cur_dag.kernels'Length loop
         total_block_count := total_block_count + cur_dag.kernels(kernel_index).block_count;
      end loop;
   end loop;
   task_capacities := new IntegerArray(1..total_block_count);

   gpu_generator.generate_dag_specs_uunifast
     (DAGs => DAGss, total_block_count => total_block_count, capacities => task_capacities,
      target_cpu_utilization  => 1.0, n_different_periods => 2,
      current_cpu_utilization => current_cpu_utilization);

   --  filename := Suppress_space ("framework_examples/gpu/inputs/gpu_system.xml");
   --  write_xml.write_to_xml_file
   --    (DAGss, TPCss, stream_to_TPC, TPC_count, filename);

   dag_cpu_utilization := current_cpu_utilization;

   static_transformer.static_transformer
     (system13, DAGss, stream_to_TPC13, TPC13ss, TPC_count, task_capacities);
   static_transformer.finalize (system13, 0.13);

   static_transformer.static_transformer
     (system31, DAGss, stream_to_TPC31, TPC31ss, TPC_count, task_capacities);
   static_transformer.finalize (system31, 0.31);

   static_transformer.static_transformer
     (system22, DAGss, stream_to_TPC22, TPC22ss, TPC_count, task_capacities);
   static_transformer.finalize (system22, 0.22);

end generate;
