with gpu_generator; use gpu_generator;
with static_transfomer; use static_transfomer;
-- with transformator;

procedure Main is
    DAGs : constant DAGList :=
       (1 =>
           (Id      => 1, kernel_count => 3, Stream => 1,
            kernels =>
               new Kernel_Array'
               (1 => (id => 1, block_count => 8, others => <>), 
                2 => (id => 2, block_count => 2, others => <>), 
                3 => (id => 3, block_count => 4, others => <>))),
        2 =>
           (Id      => 2, kernel_count => 4, Stream => 1,
            kernels =>
               new Kernel_Array'
                  (1 => (id => 1, block_count => 2, others => <>), 
                  2 => (id => 2, block_count => 16, others => <>), 
                  3 => (id => 3, block_count => 4, others => <>), 
                  4 => (id => 4, block_count => 4, others => <>))),
        3 =>
           (Id      => 3, kernel_count => 1, Stream => 1,
            kernels => new Kernel_Array'(1 => (id => 1, block_count => 8, others => <>))),
        4 =>
           (Id      => 4, kernel_count => 2, Stream => 2,
            kernels => new Kernel_Array'
                    (1 => (id => 1, block_count => 4, others => <>), 
                    2 => (id => 2, block_count => 2, others => <>))),
        5 =>
           (Id      => 5, kernel_count => 3, Stream => 3,
            kernels =>
               new Kernel_Array'(1 => (id => 1, block_count => 8, others => <>), 
               2 => (id => 2, block_count => 2, others => <>), 
               3 => (id => 3, block_count => 4, others => <>))));

    TPC1  : constant TPC_ptr :=
       new TPC'(Id => 1, max_block_size => 256, SMs => null);
    TPC2  : constant TPC_ptr :=
       new TPC'(Id => 2, max_block_size => 512, SMs => null);
    TPCss : TPCList          := (1 => TPC1, 2 => TPC2);

    stream_to_TPC : StreamTPCMap     :=
       (1 => new TPCList'(1 => TPC1), 2 => new TPCList'(1 => TPC1),
        3 => new TPCList'(1 => TPC2));
    TPC_count     : constant Integer := 2;
begin
    -- gpu_generator.gpu_generator (DAGs, stream_to_TPC, TPCss, TPC_count);
    static_transfomer.static_transfomer (DAGs, stream_to_TPC, TPCss, TPC_count);
end Main;
