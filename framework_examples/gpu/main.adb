with gpu_generator; use gpu_generator; 
-- with transformator;

procedure Main is
   DAGs : constant DAGList := (1 => (Id => 1, Size => 3, Stream => 1, kernels => new Kernel_Array'(1 => (1, 8), 2 => (2, 2), 3 => (3, 4))),
                                 2 => (Id => 2, Size => 4, Stream => 1, kernels => new Kernel_Array'(1 => (1, 2), 2 => (2, 16), 3 => (3, 4), 4 => (4, 4))),
                                 3 => (Id => 3, Size => 1, Stream => 1, kernels => new Kernel_Array'(1 => (1, 8))),
                                 4 => (Id => 4, Size => 2, Stream => 2, kernels => new Kernel_Array'(1 => (1, 4), 2 => (2, 2))),
                                 5 => (Id => 5, Size => 3, Stream => 3, kernels => new Kernel_Array'(1 => (1, 8), 2 => (2, 2), 3 => (3, 4))));

   TPC1 : constant TPC_ptr := new TPC'(Id => 1, Block_Size => 256, SMs => null);
    TPC2 : constant TPC_ptr := new TPC'(Id => 2, Block_Size => 512, SMs => null);
    TPCss : TPCList := (1 => TPC1, 2 => TPC2);

   stream_to_TPC : TPCList := (1 => TPC1, 2 => TPC1, 3 => TPC2);
   TPC_count : constant Integer := 2; 
begin
    gpu_generator.gpu_generator(DAGs, stream_to_TPC, TPCss, TPC_count);
    -- transformator;
end Main;