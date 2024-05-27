
with Input_Sources.File; use Input_Sources.File;
with Sax.Readers;        use Sax.Readers;
with DOM.Readers;        use DOM.Readers;
with DOM.Core;           use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes;     use DOM.Core.Nodes;
with DOM.Core.Attrs;     use DOM.Core.Attrs;
with Ada.Text_IO;        use Ada.Text_IO;

package test is
    type Kernel is record
        id          : Integer;
        block_count : Integer;
        block_size  : Integer := 1;
        period      : Integer := 1;
        capacity    : Integer := 1;
        deadline    : Integer := 1;
    end record;

    type Kernel_ptr is access all Kernel;
    type Kernel_Array is array (Integer range <>) of Kernel_ptr;
    type Kernel_List is access Kernel_Array;

    type DAG is record
        id           : Integer;
        kernel_count : Integer;
        stream       : Integer;
        kernels      : Kernel_List;
    end record;

    type DAG_ptr is access all DAG;
    type DAGArray is array (Integer range <>) of DAG_ptr;
    type DAGList is access DAGArray;

    --type SM_Array is array (Integer range <>) of generic_processor_ptr;
    --type SM_List is access SM_Array;

    type TPC is record
        id             : Integer;
        max_block_size : Integer;
        --SMs            : SM_List;
    end record;
    type TPC_ptr is access all TPC;

    type TPCArray is array (Integer range <>) of TPC_ptr;
    type TPCList is access all TPCArray;
    type StreamTPCMap is array (Integer range <>) of TPCList;
    type StreamTPCMap_ptr is access all StreamTPCMap;

    type System is record
        dags      : DAGList;
        tpc_count : Integer;
        tpcs      : TPCList;
        stream_tpc_map : StreamTPCMap_ptr;
    end record;
    type System_ptr is access all System;

procedure DomExample;
procedure DomExample2;
procedure ParseDAGs(
        the_system : in out System_ptr
    );
procedure ParseTPCs(
        the_system : in out System_ptr
    );
procedure ParseStreamTPCMap(
        the_system : in out System_ptr
    );
end test;