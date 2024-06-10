with gpu_generator; use gpu_generator;
with write_xml; use write_xml;
with Ada.Text_IO; use Ada.Text_IO;
with unbounded_strings;    use unbounded_strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with static_transformer; use static_transformer;
with Systems;            use Systems;


procedure generate is
    DAGss : DAGList := new DAGArray'
       (1 =>
           (Id      => 1, kernel_count => 4, Stream => 1, period => 30, deadline => 30,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 16, block_size => 128, capacity => 8), 
                2 => (id => 2, block_count => 8, block_size => 128, capacity => 7),
                3 => (id => 3, block_count => 64, block_size => 128, capacity => 9), 
                4 => (id => 4, block_count => 8, block_size => 128, capacity => 6))),
         2 =>
           (Id      => 2, kernel_count => 3, Stream => 1, period => 40, deadline => 40,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 32, block_size => 128, capacity => 8), 
                2 => (id => 2, block_count => 16, block_size => 128, capacity => 6),
                3 => (id => 3, block_count => 64, block_size => 128, capacity => 9))));

    TPC1  : constant TPC_ptr :=
       new TPC'(Id => 1, max_block_size => 128, SMs => null);
   TPCss : TPCList          := (1 => TPC1);

    stream_to_TPC : StreamTPCMap     :=
       (1 => new TPCList'(1 => TPC1));
    TPC_count     : constant Integer := 1;


    current_cpu_utilization : Float := 0.0;
    dag_cpu_utilization : Float;
    total_kernel_count : Integer := 0;
   -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4, 3 => 0.5, 4 => 0.6, 5 => 0.7, 6 => 0.8, 7 => 0.9, 8 => 1.0);
   -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4);

    filename : Unbounded_string;
    cheddar_system : system;
begin

      gpu_generator.generate_dag_specs_uunifast
      (DAGs => DAGss, total_kernel_count => total_kernel_count, target_cpu_utilization => 1.0,
      n_different_periods => 2, current_cpu_utilization => current_cpu_utilization);

      filename := Suppress_space("framework_examples/gpu/inputs/gpu_system.xml");
      write_xml.write_to_xml_file (DAGss, TPCss, stream_to_TPC, TPC_count, filename);

      dag_cpu_utilization := current_cpu_utilization;

         static_transformer.static_transformer (cheddar_system, DAGss, stream_to_TPC, TPCss, TPC_count);
      --  static_transformer.generate_dummy_workload(cheddar_system, 
      --        current_utilization => current_cpu_utilization, target_utilization => utilizations(i), 
      --        no_of_tasks_per_cpu => 10, TPCs => TPCss);
         static_transformer.finalize(cheddar_system, 0.1);



end generate;
