with gpu_generator; use gpu_generator; 
-- with transformator;

procedure Main is
   DAGs : constant DAGList := (1 => (Id => 0, Size => 3, Stream => 1),
                                 2 => (Id => 1, Size => 4, Stream => 1),
                                 3 => (Id => 2, Size => 1, Stream => 1),
                                 4 => (Id => 3, Size => 2, Stream => 2));

   stream_to_TPC : constant StringList := (1 => "TPC1", 2 => "TPC1", 3 => "TPC2");
   TPC_count : constant Integer := 2; -- maximum of 9 TPCs because of StringList string length
begin
    gpu_generator.gpu_generator(DAGs, stream_to_TPC, TPC_count);
    -- transformator;
end Main;