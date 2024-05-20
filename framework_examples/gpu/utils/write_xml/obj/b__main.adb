pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E068 : Short_Integer; pragma Import (Ada, E068, "system__os_lib_E");
   E016 : Short_Integer; pragma Import (Ada, E016, "ada__exceptions_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__soft_links_E");
   E010 : Short_Integer; pragma Import (Ada, E010, "system__exception_table_E");
   E033 : Short_Integer; pragma Import (Ada, E033, "ada__containers_E");
   E063 : Short_Integer; pragma Import (Ada, E063, "ada__io_exceptions_E");
   E007 : Short_Integer; pragma Import (Ada, E007, "ada__strings_E");
   E051 : Short_Integer; pragma Import (Ada, E051, "ada__strings__maps_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__strings__maps__constants_E");
   E038 : Short_Integer; pragma Import (Ada, E038, "interfaces__c_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exceptions_E");
   E074 : Short_Integer; pragma Import (Ada, E074, "system__object_reader_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "system__dwarf_lines_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "system__soft_links__initialize_E");
   E032 : Short_Integer; pragma Import (Ada, E032, "system__traceback__symbolic_E");
   E094 : Short_Integer; pragma Import (Ada, E094, "ada__strings__utf_encoding_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "ada__tags_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "ada__strings__text_buffers_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "gnat_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "interfaces__c__strings_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "ada__streams_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "system__file_control_block_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "system__finalization_root_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__finalization_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "system__file_io_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "system__storage_pools_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "system__finalization_masters_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "system__storage_pools__subpools_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "ada__strings__unbounded_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "system__regpat_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "ada__calendar_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "ada__calendar__delays_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "ada__text_io_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "ada__text_io__text_streams_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "gnat__directory_operations_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "system__pool_global_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "gnat__expect_E");
   E278 : Short_Integer; pragma Import (Ada, E278, "gnat__sockets_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "gnat__sockets__poll_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gnat__sockets__thin_common_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "gnat__sockets__thin_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "system__regexp_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "gnat__command_line_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "unicode_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "sax__htable_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "sax__pointers_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "unicode__ccs_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "unicode__ccs__iso_8859_1_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "unicode__ccs__iso_8859_15_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "unicode__ccs__iso_8859_2_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "unicode__ccs__iso_8859_3_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "unicode__ccs__iso_8859_4_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "unicode__ccs__windows_1251_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "unicode__ccs__windows_1252_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "unicode__ces_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "sax__symbols_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "sax__locators_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "sax__exceptions_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "unicode__ces__utf32_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "unicode__ces__basic_8bit_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "unicode__ces__utf16_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "unicode__ces__utf8_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "sax__models_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "sax__attributes_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "sax__utils_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "dom__core_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "unicode__encodings_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "dom__core__nodes_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "dom__core__attrs_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "dom__core__character_datas_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "dom__core__documents_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "dom__core__elements_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "input_sources_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "input_sources__file_E");
   E276 : Short_Integer; pragma Import (Ada, E276, "input_sources__http_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "input_sources__strings_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "sax__readers_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "dom__readers_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "test_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E227 := E227 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "dom__readers__finalize_spec");
      begin
         F1;
      end;
      E244 := E244 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "sax__readers__finalize_spec");
      begin
         F2;
      end;
      E250 := E250 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "input_sources__strings__finalize_spec");
      begin
         F3;
      end;
      E276 := E276 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "input_sources__http__finalize_spec");
      begin
         F4;
      end;
      E248 := E248 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "input_sources__file__finalize_spec");
      begin
         F5;
      end;
      E246 := E246 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "input_sources__finalize_spec");
      begin
         F6;
      end;
      E127 := E127 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "dom__core__finalize_spec");
      begin
         F7;
      end;
      E173 := E173 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "sax__utils__finalize_spec");
      begin
         F8;
      end;
      E231 := E231 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "sax__attributes__finalize_spec");
      begin
         F9;
      end;
      E237 := E237 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "sax__exceptions__finalize_spec");
      begin
         F10;
      end;
      E150 := E150 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "sax__symbols__finalize_spec");
      begin
         F11;
      end;
      E156 := E156 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "sax__pointers__finalize_spec");
      begin
         F12;
      end;
      E259 := E259 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "system__regexp__finalize_spec");
      begin
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "gnat__sockets__finalize_body");
      begin
         E278 := E278 - 1;
         F14;
      end;
      declare
         procedure F15;
         pragma Import (Ada, F15, "gnat__sockets__finalize_spec");
      begin
         F15;
      end;
      E262 := E262 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "gnat__expect__finalize_spec");
      begin
         F16;
      end;
      E162 := E162 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "system__pool_global__finalize_spec");
      begin
         F17;
      end;
      E108 := E108 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "ada__text_io__finalize_spec");
      begin
         F18;
      end;
      E195 := E195 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "ada__strings__unbounded__finalize_spec");
      begin
         F19;
      end;
      E175 := E175 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "system__storage_pools__subpools__finalize_spec");
      begin
         F20;
      end;
      E158 := E158 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "system__finalization_masters__finalize_spec");
      begin
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "system__file_io__finalize_body");
      begin
         E118 := E118 - 1;
         F22;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E010 := E010 + 1;
      Ada.Containers'Elab_Spec;
      E033 := E033 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E063 := E063 + 1;
      Ada.Strings'Elab_Spec;
      E007 := E007 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E051 := E051 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E055 := E055 + 1;
      Interfaces.C'Elab_Spec;
      E038 := E038 + 1;
      System.Exceptions'Elab_Spec;
      E019 := E019 + 1;
      System.Object_Reader'Elab_Spec;
      E074 := E074 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E045 := E045 + 1;
      System.Os_Lib'Elab_Body;
      E068 := E068 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E090 := E090 + 1;
      E012 := E012 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E032 := E032 + 1;
      E016 := E016 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E094 := E094 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E100 := E100 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      Ada.Strings.Text_Buffers'Elab_Body;
      E005 := E005 + 1;
      Gnat'Elab_Spec;
      E151 := E151 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E289 := E289 + 1;
      Ada.Streams'Elab_Spec;
      E110 := E110 + 1;
      System.File_Control_Block'Elab_Spec;
      E122 := E122 + 1;
      System.Finalization_Root'Elab_Spec;
      System.Finalization_Root'Elab_Body;
      E121 := E121 + 1;
      Ada.Finalization'Elab_Spec;
      E119 := E119 + 1;
      System.File_Io'Elab_Body;
      E118 := E118 + 1;
      System.Storage_Pools'Elab_Spec;
      E160 := E160 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E158 := E158 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Body;
      E175 := E175 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      Ada.Strings.Unbounded'Elab_Body;
      E195 := E195 + 1;
      System.Regpat'Elab_Spec;
      E271 := E271 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E264 := E264 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E285 := E285 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E108 := E108 + 1;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E124 := E124 + 1;
      Gnat.Directory_Operations'Elab_Spec;
      Gnat.Directory_Operations'Elab_Body;
      E241 := E241 + 1;
      System.Pool_Global'Elab_Spec;
      System.Pool_Global'Elab_Body;
      E162 := E162 + 1;
      Gnat.Expect'Elab_Spec;
      Gnat.Expect'Elab_Body;
      E262 := E262 + 1;
      Gnat.Sockets'Elab_Spec;
      Gnat.Sockets.Thin_Common'Elab_Spec;
      E287 := E287 + 1;
      E283 := E283 + 1;
      Gnat.Sockets'Elab_Body;
      E278 := E278 + 1;
      E281 := E281 + 1;
      System.Regexp'Elab_Spec;
      System.Regexp'Elab_Body;
      E259 := E259 + 1;
      Gnat.Command_Line'Elab_Spec;
      Gnat.Command_Line'Elab_Body;
      E252 := E252 + 1;
      Unicode'Elab_Body;
      E131 := E131 + 1;
      E148 := E148 + 1;
      Sax.Pointers'Elab_Spec;
      Sax.Pointers'Elab_Body;
      E156 := E156 + 1;
      Unicode.Ccs'Elab_Spec;
      E144 := E144 + 1;
      E201 := E201 + 1;
      E203 := E203 + 1;
      E208 := E208 + 1;
      E211 := E211 + 1;
      E213 := E213 + 1;
      E215 := E215 + 1;
      E220 := E220 + 1;
      Unicode.Ces'Elab_Spec;
      E140 := E140 + 1;
      Sax.Symbols'Elab_Spec;
      Sax.Symbols'Elab_Body;
      E150 := E150 + 1;
      E239 := E239 + 1;
      Sax.Exceptions'Elab_Spec;
      Sax.Exceptions'Elab_Body;
      E237 := E237 + 1;
      E142 := E142 + 1;
      E223 := E223 + 1;
      E225 := E225 + 1;
      E146 := E146 + 1;
      Sax.Models'Elab_Spec;
      E235 := E235 + 1;
      Sax.Attributes'Elab_Spec;
      Sax.Attributes'Elab_Body;
      E231 := E231 + 1;
      Sax.Utils'Elab_Spec;
      Sax.Utils'Elab_Body;
      E173 := E173 + 1;
      DOM.CORE'ELAB_SPEC;
      E127 := E127 + 1;
      E193 := E193 + 1;
      E185 := E185 + 1;
      E183 := E183 + 1;
      E229 := E229 + 1;
      E181 := E181 + 1;
      E179 := E179 + 1;
      Input_Sources'Elab_Spec;
      Input_Sources'Elab_Body;
      E246 := E246 + 1;
      Input_Sources.File'Elab_Spec;
      Input_Sources.File'Elab_Body;
      E248 := E248 + 1;
      Input_Sources.Http'Elab_Spec;
      Input_Sources.Http'Elab_Body;
      E276 := E276 + 1;
      Input_Sources.Strings'Elab_Spec;
      Input_Sources.Strings'Elab_Body;
      E250 := E250 + 1;
      Sax.Readers'Elab_Spec;
      Sax.Readers'Elab_Body;
      E244 := E244 + 1;
      DOM.READERS'ELAB_SPEC;
      DOM.READERS'ELAB_BODY;
      E227 := E227 + 1;
      E106 := E106 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /media/sf_shared/trunk/src/framework_examples/gpu/utils/write_xml/obj/test.o
   --   /media/sf_shared/trunk/src/framework_examples/gpu/utils/write_xml/obj/main.o
   --   -L/media/sf_shared/trunk/src/framework_examples/gpu/utils/write_xml/obj/
   --   -L/media/sf_shared/trunk/src/framework_examples/gpu/utils/write_xml/obj/
   --   -L/opt/GNAT/2021/lib/xmlada/xmlada_unicode.static/
   --   -L/opt/GNAT/2021/lib/xmlada/xmlada_sax.static/
   --   -L/opt/GNAT/2021/lib/xmlada/xmlada_input.static/
   --   -L/opt/GNAT/2021/lib/xmlada/xmlada_dom.static/
   --   -L/opt/GNAT/2021/lib/xmlada/xmlada_schema.static/
   --   -L/opt/GNAT/2021/lib/gcc/x86_64-pc-linux-gnu/10.3.1/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
