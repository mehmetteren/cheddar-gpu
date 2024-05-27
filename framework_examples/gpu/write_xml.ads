with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with gpu_generator; use gpu_generator;

package write_xml is

    procedure write_to_xml_file
     (in_dag_list  : in DAGList;
        in_tpc_list  : in TPCList;
        in_stream_tpc_map : in StreamTPCMap;
        tpc_count : in Integer;
      file_name : in Unbounded_String);

end write_xml;
