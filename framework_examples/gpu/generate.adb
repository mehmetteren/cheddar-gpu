with gpu_generator; use gpu_generator;
with write_xml; use write_xml;
with Ada.Text_IO; use Ada.Text_IO;
with unbounded_strings;    use unbounded_strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with static_transformer; use static_transformer;

procedure generate is
    DAGss : DAGList := new DAGArray'
       (1 =>
           (Id      => 1, kernel_count => 3, Stream => 1,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 1, others => <>), 
                2 => (id => 2, block_count => 1, others => <>), 
                3 => (id => 3, block_count => 1, others => <>))),
        2 =>
           (Id      => 2, kernel_count => 4, Stream => 2,
            kernels =>
               new Kernel_Array'
                  (1 => (id => 1, block_count => 1, others => <>), 
                  2 => (id => 2, block_count => 1, others => <>), 
                  3 => (id => 3, block_count => 1, others => <>), 
                  4 => (id => 4, block_count => 1, others => <>))));
      --    3 =>
      --       (Id      => 3, kernel_count => 1, Stream => 1,
      --        kernels => new Kernel_Array'(1 => (id => 1, block_count => 8, others => <>))),
      --    4 =>
      --       (Id      => 4, kernel_count => 2, Stream => 2,
      --        kernels => new Kernel_Array'
      --                (1 => (id => 1, block_count => 4, others => <>), 
      --                2 => (id => 2, block_count => 2, others => <>))),
      --    5 =>
      --       (Id      => 5, kernel_count => 3, Stream => 3,
      --        kernels =>
      --           new Kernel_Array'(1 => (id => 1, block_count => 8, others => <>), 
      --           2 => (id => 2, block_count => 2, others => <>), 
      --           3 => (id => 3, block_count => 4, others => <>))));

    TPC1  : constant TPC_ptr :=
       new TPC'(Id => 1, max_block_size => 256, SMs => null);
    TPC2  : constant TPC_ptr :=
       new TPC'(Id => 2, max_block_size => 512, SMs => null);
    TPCss : TPCList          := (1 => TPC1, 2 => TPC2);

    stream_to_TPC : StreamTPCMap     :=
       (1 => new TPCList'(1 => TPC1), 2 => new TPCList'(1 => TPC2),
        3 => new TPCList'(1 => TPC2));
    TPC_count     : constant Integer := 2;

    -- the_system : gpu_system_ptr := new gpu_system'(DAGs => DAGss, TPCs => access TPCss, Stream_to_TPC => stream_to_TPC, TPC_count => TPC_count);

    current_cpu_utilization : Float := 0.0;
    total_kernel_count : Integer := 0;
    block_counts : IntegerArray := (1 => 1, 2 => 2, 3 => 3, 4 => 5, 5 => 7, 6 => 8, 7 => 10, 8 => 12, 9 => 16);
    filename : Unbounded_string;
begin

   for i in 1 .. DAGss'Length loop
      total_kernel_count := total_kernel_count + DAGss (i).kernel_count;
   end loop;
      gpu_generator.generate_kernel_specs_uunifast
      (DAGs => DAGss, total_kernel_count => total_kernel_count, target_cpu_utilization => 0.9,
      n_different_periods => 2, current_cpu_utilization => current_cpu_utilization);

      for i in block_counts'Range loop
         Put_Line ("Block count: " & Integer'Image (block_counts (i)));
         gpu_generator.iterate_over_system (DAGss, stream_to_TPC, TPCss, TPC_count, block_counts (i));
         filename := Suppress_space("framework_examples/gpu/inputs/gpu_system_" & block_counts (i)'Img & ".xml");
         write_xml.write_to_xml_file (DAGss, TPCss, stream_to_TPC, TPC_count, filename);
         static_transformer.static_transformer (DAGss, stream_to_TPC, TPCss, TPC_count);
      end loop;



end generate;
