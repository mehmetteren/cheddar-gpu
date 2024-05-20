with Unicode.CES;              use Unicode.CES;
with Unicode.Encodings;        use Unicode.Encodings;
with Ada.Direct_IO;
with Ada.IO_Exceptions;        use Ada.IO_Exceptions;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Unchecked_Deallocation;
with DOM.Core.Documents;
use DOM.Core, DOM.Core.Documents;
with DOM.Core;           use DOM.Core;
with DOM.Core.Nodes;     use DOM.Core.Nodes;
with DOM.Readers;        use DOM.Readers;
with GNAT.Command_Line;  use GNAT.Command_Line;
with GNAT.Expect;        use GNAT.Expect;
with GNAT.OS_Lib;        use GNAT.OS_Lib;
with Input_Sources.File; use Input_Sources.File;
with Input_Sources.Http; use Input_Sources.Http;
with Input_Sources;      use Input_Sources;
with Sax.Encodings;      use Sax.Encodings;
with Sax.Readers;        use Sax.Readers;
with Sax.Utils;          use Sax.Utils;
with Sax.Symbols;

package body test is

    function xml_string
       (obj : in Kernel; level : in Natural := 0) return Unbounded_String
    is
        result : Unbounded_String := To_Unbounded_String ("");
    begin
        result := result & "<kernel>";

        result :=
           result & to_unbounded_string ("<id>") & obj.id'Img &
           to_unbounded_string ("</id>");
        result :=
           result & to_unbounded_string ("<block_count>") &
           obj.block_count'Img & to_unbounded_string ("</block_count>");
        result :=
           result & to_unbounded_string ("<block_size>") & obj.block_size'Img &
           to_unbounded_string ("</block_size>");
        result :=
           result & to_unbounded_string ("<period>") & obj.period'Img &
           to_unbounded_string ("</period>");
        result :=
           result & to_unbounded_string ("<capacity>") & obj.capacity'Img &
           to_unbounded_string ("</capacity>");
        result :=
           result & to_unbounded_string ("<deadline>") & obj.deadline'Img &
           to_unbounded_string ("</deadline>");

        --  if obj.dependencies /= null then
        --      if not is_empty (obj.dependencies.depends) then
        --          result := result & "<dependencies>";
        --          result := result & xml_root_string (obj.dependencies);
        --          result := result & "</dependencies>";
        --      end if;
        --  end if;

        --  if not is_empty (obj.scheduling_errors) then
        --      result := result & "<scheduling_errors>";
        --      result := result & xml_root_string (obj.scheduling_errors);
        --      result := result & "</scheduling_errors>";
        --  end if;

        result := result & "</kernel>";

        return result;

    end xml_string;

    function xml_string
       (obj : in DAG; level : in Natural := 0) return Unbounded_String
    is
        result : Unbounded_String := To_Unbounded_String ("");
    begin
        result := result & "<DAG>";

        result :=
           result & to_unbounded_string ("<id>") & obj.id'Img &
           to_unbounded_string ("</id>");
        result :=
           result & to_unbounded_string ("<kernel_count>") &
           obj.kernel_count'Img & to_unbounded_string ("</kernel_count>");
        result :=
           result & to_unbounded_string ("<stream>") & obj.stream'Img &
           to_unbounded_string ("</stream>");

        if obj.kernels /= null then
            result := result & "<kernels>";
            for i in obj.kernels'Range loop
                result := result & xml_string (obj.kernels (i));
            end loop;
            result := result & "</kernels>";
        end if;

        result := result & "</DAG>";

        return result;

    end xml_string;

    function xml_string
       (obj : in TPC; level : in Natural := 0) return Unbounded_String
    is
        result : Unbounded_String := To_Unbounded_String ("");
    begin
        result := result & "<TPC>";

        result :=
           result & to_unbounded_string ("<id>") & obj.id'Img &
           to_unbounded_string ("</id>");
        result :=
           result & to_unbounded_string ("<max_block_size>") & obj.max_block_size'Img &
           to_unbounded_string ("</max_block_size>");

        result := result & "</TPC>";

        return result;

    end xml_string;

    procedure write_to_xml_file
       (in_dag_list       : in DAGList; in_tpc_list : in TPCList;
        in_stream_tpc_map : in StreamTPCMap; tpc_count : in Integer;
        file_name         : in String)
    is

        input               : file_input;
        reader              : tree_reader;
        d                   : document;
        into                : File_Type;
        file_name_unbounded : Unbounded_String;

    begin
        file_name_unbounded := To_Unbounded_String (file_name);

        -- Open file and Write XML Header
        --
        Create
           (into, Mode => Out_File, Name => To_String (file_name_unbounded));

        Put_Line (into, "<?xml version=""1.0"" standalone=""no""?>  ");
        New_Line (into, 2);
        Put_Line (into, "<cheddar_gpu>");

        Put_Line (into, "<DAG_list>");
        for i in in_dag_list'Range loop
            Put (into, To_String (xml_string (in_dag_list (i))));
        end loop;
        Put_Line (into, "</DAG_list>");




        Put_Line (into, "<TPC_list>");
        for i in in_tpc_list'Range loop
            Put (into, To_String (xml_string (in_tpc_list (i).all)));
        end loop;
        Put_Line (into, "</TPC_list>");

        Put_Line (into, "<stream_TPC_map>");
        for i in in_stream_tpc_map'Range loop
            Put_Line (into, "<assigned_TPCs>");
            for j in in_stream_tpc_map (i)'Range loop
                Put (into, To_String (xml_string (in_stream_tpc_map (i) (j).all)));
            end loop;
            Put_Line (into, "</assigned_TPCs>");
        end loop;
        Put_Line (into, "</stream_TPC_map>");

        Put_Line (into, "<TPC_count>" & tpc_count'Img & "</TPC_count>");


        Put_Line (into, "</cheddar_gpu>");

        Close (into);

        Open (To_String (file_name_unbounded), input);
        Parse (reader, input);
        d := Get_Tree (reader);
        Close (input);

        Create
           (into, Mode => Out_File, Name => To_String (file_name_unbounded));
        Write
           (Stream => Stream (into), N => d, Print_Comments => False,
            Print_XML_Declaration => True, With_URI => False,
            EOL_Sequence          => "" & ASCII.LF, Pretty_Print => True,
            Encoding              => Unicode.Encodings.Get_By_Name ("utf-8"),
            Collapse_Empty_Nodes  => False);

        Free (reader);
        Close (into);

    end write_to_xml_file;

    --  function xml_string
    --      (obj   : in access;
    --      level : in Natural := 0) return Unbounded_String
    --  is
    --  begin
    --      return xml_string (obj.all, level);
    --  end xml_string;

    procedure put_xml (in_kernel : in Kernel) is
    begin
        Put (To_String (xml_string (in_kernel)));
    end put_xml;
end test;
