with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package test is

    type Kernel is record
        id          : Integer;
        block_count : Integer;
        block_size  : Integer := 1;
        period      : Integer := 1;
        capacity    : Integer := 1;
        deadline    : Integer := 1;
    end record;

    type Kernel_Array is array (Integer range <>) of Kernel;
    type Kernel_List is access Kernel_Array;

    type DAG is record
        id           : Integer;
        kernel_count : Integer;
        stream       : Integer;
        kernels      : Kernel_List;
    end record;

    type DAGArray is array (Integer range <>) of DAG;
    type DAGList is access DAGArray;

    --type SM_Array is array (Integer range <>) of generic_processor_ptr;
    --type SM_List is access SM_Array;

    type TPC is record
        id             : Integer;
        max_block_size : Integer;
        --SMs            : SM_List;
    end record;
    type TPC_ptr is access all TPC;

    type TPCList is array (Integer range <>) of TPC_ptr;
    type TPCList_ptr is access all TPCList;
    type StreamTPCMap is array (Integer range <>) of TPCList_ptr;


    procedure write_to_xml_file
     (in_dag_list  : in DAGList;
        in_tpc_list  : in TPCList;
        in_stream_tpc_map : in StreamTPCMap;
        tpc_count : in Integer;
      file_name : in String);

end test;
