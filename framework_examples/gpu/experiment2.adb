with gpu_generator;         use gpu_generator;
with write_xml;             use write_xml;
with Ada.Text_IO;           use Ada.Text_IO;
with unbounded_strings;     use unbounded_strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with static_transformer;    use static_transformer;
with Systems;               use Systems;

procedure experiment2 is

  DAGss : DAGList :=
   new DAGArray'
    (1 =>
      (Id => 1, kernel_count => 4, Stream => 1, period => 90, deadline => 90,
       kernels =>
        new Kernel_Array'
         (1 => (id => 1, block_count => 16, block_size => 256, capacity => 10),
          2 => (id => 2, block_count => 4, block_size => 256, capacity => 10),
          3 => (id => 3, block_count => 16, block_size => 256, capacity => 10),
          4 =>
           (id => 4, block_count => 8, block_size => 256, capacity => 10))));

  TPC_count : constant Integer := 1;

  TPC1 : constant TPC_ptr :=
   new TPC'
    (Id => 1, max_block_size => 256, resource_multiplier => 1, SMs => null);

  TPCss : TPCList := (1 => TPC1);

  stream_to_TPC : StreamTPCMap := (1 => new TPCList'(1 => TPC1));

  -- ------- ------- ------- -------

  current_cpu_utilization : Float   := 0.0;
  total_block_count       : Integer := 0;
  -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4, 3 => 0.5, 4 => 0.6, 5 => 0.7, 6 => 0.8, 7 => 0.9, 8 => 1.0);
  -- utilizations : FloatArray := (1 => 0.3, 2 => 0.4);

  filename : Unbounded_string;
  system1  : system;

  cur_dag                 : DAG;
  task_capacities         : IntegerArray_ptr;
  dummy_task_per_cpu_mult : Integer := 1;

  type StringArray is array (Integer range <>) of unbounded_string;

   algos : StringArray :=
      (1 => To_Unbounded_String("fixed_priority"),
       2 => To_Unbounded_String("round_robin"),
       3 => To_Unbounded_String("rate_monotonic"),
       4 => To_Unbounded_String("deadline_monotonic"));

begin

  gpu_generator.generate_dag_specs_uunifast
   (DAGs                    => DAGss, total_block_count => total_block_count,
    target_cpu_utilization  => 1.0, n_different_periods => 2,
    current_cpu_utilization => current_cpu_utilization);

  filename := Suppress_space ("framework_examples/gpu/inputs/gpu_system.xml");
  write_xml.write_to_xml_file
   (DAGss, TPCss, stream_to_TPC, TPC_count, filename);

  for algo of algos loop
    dummy_task_per_cpu_mult := 1;
    loop
      current_cpu_utilization := 0.0;
      static_transformer.static_transformer
       (system1, DAGss, stream_to_TPC, TPCss, TPC_count, algo);
      static_transformer.generate_dummy_workload_simple
       (system1, current_cpu_utilization, dummy_task_per_cpu_mult, TPCss, algo);
      static_transformer.finalize (system1, current_cpu_utilization, algo);
      dummy_task_per_cpu_mult := dummy_task_per_cpu_mult + 1;
      exit when current_cpu_utilization >= 0.9;
    end loop;
    put_line(dummy_task_per_cpu_mult'Img);
  end loop;

end experiment2;
