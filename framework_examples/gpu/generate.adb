with gpu_generator;         use gpu_generator;
with write_xml;             use write_xml;
with Ada.Text_IO;           use Ada.Text_IO;
with unbounded_strings;     use unbounded_strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with static_transformer;    use static_transformer;
with Systems;               use Systems;

procedure generate is

  DAGss : DAGList :=
   new DAGArray'
    (1 =>
      (Id => 1, kernel_count => 4, Stream => 1, period => 40, deadline => 40,
       kernels =>
        new Kernel_Array'
         (1 => (id => 1, block_count => 2, block_size => 256, capacity => 2),
          2 => (id => 2, block_count => 4, block_size => 256, capacity => 3),
          3 => (id => 3, block_count => 8, block_size => 256, capacity => 2),
          4 => (id => 4, block_count => 2, block_size => 256, capacity => 3))),
    2 =>
      (Id => 2, kernel_count => 3, Stream => 1, period => 30, deadline => 30,
       kernels =>
        new Kernel_Array'
         (1 => (id => 11, block_count => 2, block_size => 1024, capacity => 2),
          2 => (id => 12, block_count => 4, block_size => 1024, capacity => 1),
          3 => (id => 13, block_count => 2, block_size => 1024, capacity => 3))));

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

begin

  filename := Suppress_space ("framework_examples/gpu/inputs/gpu_system.xml");
  write_xml.write_to_xml_file
   (DAGss, TPCss, stream_to_TPC, TPC_count, filename);

  gpu_generator.iterate_over_system(DAGss, stream_to_TPC, TPCss, TPC_count, 0);

  current_cpu_utilization := 0.0;
  static_transformer.static_transformer
    (system1, DAGss, stream_to_TPC, TPCss, TPC_count, To_Unbounded_String("fixed_priority"));
   static_transformer.finalize (system1, current_cpu_utilization, To_Unbounded_String("fixed_priority"), 0);

end generate;
