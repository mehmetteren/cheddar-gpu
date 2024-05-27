
package body test is

    procedure DomExample is
        Input  : File_Input;
        Reader : Tree_Reader;
        Doc    : Document;
    begin
        Set_Public_Id (Input, "Preferences file");
        Open ("gpu.xml", Input);

        Set_Feature (Reader, Validation_Feature, False);
        Set_Feature (Reader, Namespace_Feature, False);

        Parse (Reader, Input);
        Close (Input);

        Doc := Get_Tree (Reader);

        Free (Reader);
    end DomExample;

    procedure DomExample2 is
        the_system : System_ptr;
    begin

        the_system :=
           new System'
              (dags           => null, tpc_count => 0, tpcs => null,
               stream_tpc_map => null);

        ParseDAGs (the_system);

        Put_Line (the_system.dags (2).id'Img);
        Put_Line (the_system.dags (2).kernel_count'Img);
        Put_Line (the_system.dags (2).stream'Img);
        Put_Line (the_system.dags (2).kernels (1).id'Img);
        Put_Line (the_system.dags (2).kernels (1).period'Img);

        ParseTPCs (the_system);

        Put_Line (the_system.tpcs (1).id'Img);
        Put_Line (the_system.tpcs (2).max_block_size'Img);

        ParseStreamTPCMap (the_system);

        Put_Line (the_system.stream_tpc_map (1) (1).id'Img);

    end DomExample2;


    procedure ParseStreamTPCMap (the_system : in out System_ptr) is
        input : File_Input;
        doc : Document;
        Reader : Tree_Reader;
        assigned_TPCs : Node_List;
        assigned_TPC_node : Node;
        tpc_child : Node;
        map_ptr : StreamTPCMap_ptr;
        tpc_index : Integer := 1;
        a_tpc_list : TPCList;
        a_tpc : TPC_ptr;
        count : Integer;
        count_node : Node;
        tpc_count : Integer;
        tpc_attr_child : Node;

    begin
        Set_Public_Id (Input, "GPU architecture specs file");
        Open ("gpu.xml", Input);

        Set_Feature (Reader, Validation_Feature, False);
        Set_Feature (Reader, Namespace_Feature, False);

        Parse (Reader, Input);
        Close (Input);

        doc := Get_Tree (reader);

        assigned_TPCs := Get_Elements_By_Tag_Name(doc, "assigned_TPCs");
        
        if Length(assigned_TPCs) > 0 then
            Put_Line("assigned tpc count: " & Length(assigned_TPCs)'Img);
        else
            Put_Line("No 'assigned_TPCs' elements found.");
        end if;

        map_ptr := new StreamTPCMap(1 .. Length(assigned_TPCs));

        for index in 1 .. Length(assigned_TPCs) loop
            assigned_TPC_node := Item(assigned_TPCs, index - 1);
            Put_Line("Node name is " & Node_Name(assigned_TPC_node));
            count_node := First_Child(assigned_TPC_node);
            while Node_Name(count_node) /= "count" loop
                count_node := Next_Sibling(count_node);
            end loop;
            count := Integer'Value(Node_Value(First_Child(count_node)));
            Put_Line("TPC count: " & Integer'Image(count));

            a_tpc_list := new TPCArray(1 .. count);
            tpc_child := First_Child(count_node);
            tpc_index := 1;
            while tpc_child /= null loop
            if Node_Type (tpc_child) = Element_Node then
                if Node_Name (tpc_child) = "TPC" then
                    Put_Line ("Processing TPC" & Integer'Image(tpc_index));
                    a_tpc :=
                       new TPC'
                          (id => 0, max_block_size => 0);

                    tpc_attr_child := First_Child (tpc_child);
                    while tpc_attr_child /= null loop
                        if Node_Name (tpc_attr_child) = "id" then
                            a_tpc.id := Integer'Value(Node_Value (First_Child(tpc_attr_child)));
                        elsif Node_Name (tpc_attr_child) = "max_block_size" then
                            a_tpc.max_block_size := Integer'Value(Node_Value (First_Child(tpc_attr_child)));
                        end if;
                        tpc_attr_child := Next_Sibling (tpc_attr_child);
                    end loop;
                    a_tpc_list (tpc_index) := a_tpc;
                    tpc_index := tpc_index + 1;
                end if;
            end if;
            tpc_child := Next_Sibling (tpc_child);
            end loop;
            map_ptr(index) := a_tpc_list;
            Put_Line ("TPCs done" & Integer'Image(map_ptr(index)(1).max_block_size));
        end loop;

    end ParseStreamTPCMap;

    procedure ParseTPCs (the_system : in out System_ptr) is
        input : File_Input;
        doc : Document;
        Reader : Tree_Reader;
        test_xml1 : Node_List;
        test_xml2 : Node_List;
        xml_tpc_List     : Node;
        tpc_child    : Node;
        tpc_attr_child : Node;
        TPCs     : TPCList;
        a_tpc    : TPC_ptr;
        tpc_count : Integer;
        tpc_index : Integer := 1;
    begin
        Set_Public_Id (Input, "GPU architecture specs file");
        Open ("gpu.xml", Input);

        Set_Feature (Reader, Validation_Feature, False);
        Set_Feature (Reader, Namespace_Feature, False);

        Parse (Reader, Input);
        Close (Input);

        doc := Get_Tree (reader);

    test_xml1 := Get_Elements_By_Tag_Name(doc, "TPC_count");
    if Length(test_xml1) > 0 then
        tpc_count := Integer'Value(Node_Value(First_Child(Item(test_xml1, 0))));
        Put_Line("TPC count: " & Integer'Image(tpc_count));
    else
        Put_Line("No 'TPC_count' elements found.");
    end if;

    test_xml2 := Get_Elements_By_Tag_Name(doc, "TPC_list");
    if Length(test_xml2) > 0 then
        xml_tpc_List := Item(test_xml2, 0);
        Put_Line("Node name is " & Node_Name(xml_tpc_List));
    else
        Put_Line("No 'TPC_list' elements found.");
    end if;

        TPCs := new TPCArray (1 .. tpc_count);
        Put_Line ("TPC count: " & Integer'Image(TPCs'Length));

        tpc_child := First_Child (xml_tpc_List);
        while tpc_child /= null loop
            if Node_Type (tpc_child) = Element_Node then
                if Node_Name (tpc_child) = "TPC" then
                    Put_Line ("Processing TPC" & Integer'Image(tpc_index));
                    a_tpc :=
                       new TPC'
                          (id => 0, max_block_size => 0);

                    tpc_attr_child := First_Child (tpc_child);
                    while tpc_attr_child /= null loop
                        if Node_Name (tpc_attr_child) = "id" then
                            a_tpc.id := Integer'Value(Node_Value (First_Child(tpc_attr_child)));
                        elsif Node_Name (tpc_attr_child) = "max_block_size" then
                            a_tpc.max_block_size := Integer'Value(Node_Value (First_Child(tpc_attr_child)));
                        end if;
                        tpc_attr_child := Next_Sibling (tpc_attr_child);
                    end loop;
                    TPCs (tpc_index) := a_tpc;
                    tpc_index := tpc_index + 1;
                end if;
            end if;
            tpc_child := Next_Sibling (tpc_child);
        end loop;

        the_system.tpcs := TPCs;
        Put_Line ("TPCs done");

        --  Free (xml_tpc_List);
        --  Free (tpc_child);
        --  Free (tpc_attr_child);
        --  Free (test_xml1);
        --  Free (test_xml2);
        --  Free (doc);
        --  Free(reader);
    end ParseTPCs;


    procedure ParseDAGs (the_system : in out System_ptr) is
        input   : File_Input;
        reader   : Tree_Reader;
        doc : Document := Get_Tree (reader);
        List     : Node_List;
        N        : Node;
        Child    : Node;
        DAGs     : DAGList;
        a_dag    : DAG_ptr;
        a_kernel : Kernel_ptr;
    begin
                Set_Public_Id (Input, "GPU architecture specs file");
        Open ("gpu.xml", Input);
       
        Set_Feature (Reader, Validation_Feature, False);
        Set_Feature (Reader, Namespace_Feature, False);

        Parse (Reader, Input);
        Close (Input);

        doc := Get_Tree (reader); 


        List := Get_Elements_By_Tag_Name (doc, "DAG");
        DAGs := new DAGArray (1 .. Length (List));

        for Index in 1 .. Length (List) loop
            N := Item (List, Index - 1);
            Put_Line ("Node name is " & Node_Name (N));
            -- Iterate over child nodes of the current node
            Child := First_Child (N);

                a_dag :=
                       new DAG'
                          (id      => 0, kernel_count => 0, stream => 0,
                           kernels => null);

            while Child /= null loop -- iterate over DAG attributes

                if Node_Type (Child) = Element_Node then

                    Put_Line ("Child node name is " & Node_Name (Child));

                    -- Handle different types of child nodes
                    if Node_Name (Child) = "id" then
                        Put_Line ("Processing ID: " & Node_Value (First_Child(Child)));
                        a_dag.id := Integer'Value(Node_Value (First_Child(Child)));
                    elsif Node_Name (Child) = "kernel_count" then
                        Put_Line ("Kernel Count: " & Node_Value (First_Child(Child)));
                        a_dag.kernel_count := Integer'Value(Node_Value (First_Child(Child)));
                    elsif Node_Name (Child) = "stream" then
                        Put_Line ("Stream: " & Node_Value (First_Child(Child)));
                        a_dag.stream := Integer'Value(Node_Value (First_Child(Child)));
                    elsif Node_Name (Child) = "kernels" then
                    Put_Line ("Processing kernels" & Integer'Image(a_dag.kernel_count));
                        a_dag.kernels :=
                           new Kernel_Array (1 .. a_dag.kernel_count);
                        declare
                            Kernel_Child      : Node    := First_Child (Child);
                            Kernel_attr_child : Node;
                            kernel_index      : Integer := 1;
                        begin
                            while Kernel_Child /= null
                            loop -- iterate over kernels
                                if Node_Name (Kernel_Child) = "kernel" then
                                    Put_Line
                                       ("Processing kernel" &
                                        Integer'Image(kernel_index));
                                    a_kernel :=
                                       new Kernel'
                                          (id         => 0, block_count => 0,
                                           block_size => 0, period => 0,
                                           capacity   => 0, deadline => 0);

                                    kernel_attr_child := First_Child (Kernel_Child);
                                    while Kernel_attr_child /= null loop
                                        if Node_Name (Kernel_attr_child) = "id"
                                        then
                                            a_kernel.id :=
                                               Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));
                                        elsif Node_Name (Kernel_attr_child) =
                                           "block_count"
                                        then
                                            a_kernel.block_count :=
                                               Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));
                                        elsif Node_Name (Kernel_attr_child) =
                                             "block_size"
                                         then
                                              a_kernel.block_size :=
                                                  Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));

                                        elsif Node_Name (Kernel_attr_child) =
                                                "period"
                                            then
                                                a_kernel.period :=
                                                    Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));
                                        elsif Node_Name (Kernel_attr_child) =
                                                "capacity"
                                            then
                                                a_kernel.capacity :=
                                                    Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));
                                        elsif Node_Name (Kernel_attr_child) =
                                                "deadline"
                                            then
                                                a_kernel.deadline :=
                                                    Integer'Value(Node_Value
                                                  (First_Child(Kernel_attr_child)));
                                        end if;
                                        Kernel_attr_child :=
                                           Next_Sibling (Kernel_attr_child);
                                    end loop;
                                    Put_Line("Kernel list length: " & Integer'Image(a_dag.kernels'Length));
                                    Put_Line("Kernel index: " & Integer'Image(kernel_index));
                                    Put_Line("Kernel ID: " & Integer'Image(a_kernel.id));
                                    Put_Line("Kernel period: " & Integer'Image(a_kernel.period));

                                    a_dag.kernels (kernel_index) :=
                                       a_kernel;
                                    kernel_index := kernel_index + 1;
                                end if;
                                Kernel_Child := Next_Sibling (Kernel_Child);
                            end loop;
                            Free (Kernel_Child);
                            Free (Kernel_attr_child);
                        end;
                    end if;
                end if;
                Child := Next_Sibling (Child);
            end loop;
            DAGs (Index) := a_dag;
            Put_Line ("DAG done");
        end loop;

        the_system.dags := DAGs;

        --  Free (List);
        --  Free (N);
        --  Free (Child);
        --  Free (doc);
        --  Free (reader);

    end ParseDAGs;

end test;
