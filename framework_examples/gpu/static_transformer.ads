with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Generic_Graph;         use Generic_Graph;
with Tasks;                 use Tasks;
with Task_Set;              use Task_Set;
with Task_Groups;           use Task_Groups;
with Task_Group_Set;        use Task_Group_Set;
with Buffers;               use Buffers;
with Messages;              use Messages;
with Dependencies;          use Dependencies;
with Resources;             use Resources;
use Resources.Resource_Accesses;
with Systems;            use Systems;
with Processors;         use Processors;
with Processor_Set;      use Processor_Set;
with Address_Spaces;     use Address_Spaces;
with Address_Space_Set;  use Address_Space_Set;
with Caches;             use Caches;
with Caches;             use Caches.Cache_Blocks_Table_Package;
with Message_Set;        use Message_Set;
with Buffer_Set;         use Buffer_Set;
with Network_Set;        use Network_Set;
with Event_Analyzer_Set; use Event_Analyzer_Set;
with Resource_Set;       use Resource_Set;
with Task_Dependencies;  use Task_Dependencies;
with Buffers;            use Buffers;
use Buffers.Buffer_Roles_Package;
with Queueing_Systems;     use Queueing_Systems;
with convert_strings;
with unbounded_strings;    use unbounded_strings;
with convert_unbounded_strings;
with Text_IO;              use Text_IO;
with Systems;              use Systems;
with Objects;              use Objects;
with Parameters.extended;  use Parameters.extended;
with Scheduler_Interface;  use Scheduler_Interface;
with Ada.Finalization;
with unbounded_strings;    use unbounded_strings;
with architecture_factory; use architecture_factory;
use unbounded_strings.unbounded_string_list_package;
with Unchecked_Deallocation;
with sets;
with Framework_Config;     use Framework_Config;
with Ada.Float_Text_IO;
with Offsets;              use Offsets;
with Offsets;              use Offsets.Offsets_Table_Package;
with Random_Tools;         use Random_Tools;
with initialize_framework; use initialize_framework;
with Random_Tools;         use Random_Tools;
with Ada.Numerics.Float_Random;
with Core_Units;           use Core_Units;
with Networks;             use Networks;
use networks.Positions_Table_Package;
with Ada.Numerics.Discrete_Random;
with gpu_generator;        use gpu_generator;
with scheduling_simulation_test_hlfet; use scheduling_simulation_test_hlfet;

package static_transformer is

    procedure static_transformer
       (transformed_system : in out System; DAGs : DAGList; Stream_To_TPC : in out StreamTPCMap; TPCs : in out TPCList; TPC_count : Integer);
    
    procedure generate_dummy_workload(cheddar_system : in out System; current_utilization : in out Float;
    target_utilization : in out Float; no_of_tasks_per_cpu : in Integer; TPCs : in TPCList);

    procedure finalize
(
        transformed_system : in System;
        utilization : in Float
    );


end static_transformer;
