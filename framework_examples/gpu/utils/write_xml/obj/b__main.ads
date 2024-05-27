pragma Warnings (Off);
pragma Ada_95;
with System;
with System.Parameters;
with System.Secondary_Stack;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: Community 2021 (20210519-103)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   GNAT_Version_Address : constant System.Address := GNAT_Version'Address;
   pragma Export (C, GNAT_Version_Address, "__gnat_version_address");

   Ada_Main_Program_Name : constant String := "_ada_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#c8d0f1ce#;
   pragma Export (C, u00001, "mainB");
   u00002 : constant Version_32 := 16#2e11c0b1#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#eb6e0dda#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#8c178268#;
   pragma Export (C, u00004, "ada__strings__text_buffersB");
   u00005 : constant Version_32 := 16#0800bb5e#;
   pragma Export (C, u00005, "ada__strings__text_buffersS");
   u00006 : constant Version_32 := 16#76789da1#;
   pragma Export (C, u00006, "adaS");
   u00007 : constant Version_32 := 16#e6d4fa36#;
   pragma Export (C, u00007, "ada__stringsS");
   u00008 : constant Version_32 := 16#a2da961d#;
   pragma Export (C, u00008, "systemS");
   u00009 : constant Version_32 := 16#34742901#;
   pragma Export (C, u00009, "system__exception_tableB");
   u00010 : constant Version_32 := 16#b1e67ab7#;
   pragma Export (C, u00010, "system__exception_tableS");
   u00011 : constant Version_32 := 16#adf22619#;
   pragma Export (C, u00011, "system__soft_linksB");
   u00012 : constant Version_32 := 16#ee9070f7#;
   pragma Export (C, u00012, "system__soft_linksS");
   u00013 : constant Version_32 := 16#6c2097a7#;
   pragma Export (C, u00013, "system__secondary_stackB");
   u00014 : constant Version_32 := 16#5371a199#;
   pragma Export (C, u00014, "system__secondary_stackS");
   u00015 : constant Version_32 := 16#7a7a1ff8#;
   pragma Export (C, u00015, "ada__exceptionsB");
   u00016 : constant Version_32 := 16#661890aa#;
   pragma Export (C, u00016, "ada__exceptionsS");
   u00017 : constant Version_32 := 16#19b42e05#;
   pragma Export (C, u00017, "ada__exceptions__last_chance_handlerB");
   u00018 : constant Version_32 := 16#fc9377ef#;
   pragma Export (C, u00018, "ada__exceptions__last_chance_handlerS");
   u00019 : constant Version_32 := 16#fc140986#;
   pragma Export (C, u00019, "system__exceptionsS");
   u00020 : constant Version_32 := 16#69416224#;
   pragma Export (C, u00020, "system__exceptions__machineB");
   u00021 : constant Version_32 := 16#59a6462e#;
   pragma Export (C, u00021, "system__exceptions__machineS");
   u00022 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00022, "system__exceptions_debugB");
   u00023 : constant Version_32 := 16#92c2ea31#;
   pragma Export (C, u00023, "system__exceptions_debugS");
   u00024 : constant Version_32 := 16#1253e556#;
   pragma Export (C, u00024, "system__img_intS");
   u00025 : constant Version_32 := 16#ced09590#;
   pragma Export (C, u00025, "system__storage_elementsB");
   u00026 : constant Version_32 := 16#8f19dc19#;
   pragma Export (C, u00026, "system__storage_elementsS");
   u00027 : constant Version_32 := 16#01838199#;
   pragma Export (C, u00027, "system__tracebackB");
   u00028 : constant Version_32 := 16#e2576046#;
   pragma Export (C, u00028, "system__tracebackS");
   u00029 : constant Version_32 := 16#1f08c83e#;
   pragma Export (C, u00029, "system__traceback_entriesB");
   u00030 : constant Version_32 := 16#8472457c#;
   pragma Export (C, u00030, "system__traceback_entriesS");
   u00031 : constant Version_32 := 16#53898024#;
   pragma Export (C, u00031, "system__traceback__symbolicB");
   u00032 : constant Version_32 := 16#4f57b9be#;
   pragma Export (C, u00032, "system__traceback__symbolicS");
   u00033 : constant Version_32 := 16#179d7d28#;
   pragma Export (C, u00033, "ada__containersS");
   u00034 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00034, "ada__exceptions__tracebackB");
   u00035 : constant Version_32 := 16#bba159a5#;
   pragma Export (C, u00035, "ada__exceptions__tracebackS");
   u00036 : constant Version_32 := 16#edec285f#;
   pragma Export (C, u00036, "interfacesS");
   u00037 : constant Version_32 := 16#fb01eaa4#;
   pragma Export (C, u00037, "interfaces__cB");
   u00038 : constant Version_32 := 16#7300324d#;
   pragma Export (C, u00038, "interfaces__cS");
   u00039 : constant Version_32 := 16#896564a3#;
   pragma Export (C, u00039, "system__parametersB");
   u00040 : constant Version_32 := 16#e58852d6#;
   pragma Export (C, u00040, "system__parametersS");
   u00041 : constant Version_32 := 16#e865e681#;
   pragma Export (C, u00041, "system__bounded_stringsB");
   u00042 : constant Version_32 := 16#d527b704#;
   pragma Export (C, u00042, "system__bounded_stringsS");
   u00043 : constant Version_32 := 16#eb3389a7#;
   pragma Export (C, u00043, "system__crtlS");
   u00044 : constant Version_32 := 16#9e37a39c#;
   pragma Export (C, u00044, "system__dwarf_linesB");
   u00045 : constant Version_32 := 16#053853aa#;
   pragma Export (C, u00045, "system__dwarf_linesS");
   u00046 : constant Version_32 := 16#5b4659fa#;
   pragma Export (C, u00046, "ada__charactersS");
   u00047 : constant Version_32 := 16#ba03ad8f#;
   pragma Export (C, u00047, "ada__characters__handlingB");
   u00048 : constant Version_32 := 16#21df700b#;
   pragma Export (C, u00048, "ada__characters__handlingS");
   u00049 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00049, "ada__characters__latin_1S");
   u00050 : constant Version_32 := 16#24ece25f#;
   pragma Export (C, u00050, "ada__strings__mapsB");
   u00051 : constant Version_32 := 16#ac61938c#;
   pragma Export (C, u00051, "ada__strings__mapsS");
   u00052 : constant Version_32 := 16#9097e839#;
   pragma Export (C, u00052, "system__bit_opsB");
   u00053 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00053, "system__bit_opsS");
   u00054 : constant Version_32 := 16#89dde28e#;
   pragma Export (C, u00054, "system__unsigned_typesS");
   u00055 : constant Version_32 := 16#20c3a773#;
   pragma Export (C, u00055, "ada__strings__maps__constantsS");
   u00056 : constant Version_32 := 16#a0d3d22b#;
   pragma Export (C, u00056, "system__address_imageB");
   u00057 : constant Version_32 := 16#03360b27#;
   pragma Export (C, u00057, "system__address_imageS");
   u00058 : constant Version_32 := 16#d5cc70e4#;
   pragma Export (C, u00058, "system__img_unsS");
   u00059 : constant Version_32 := 16#20ec7aa3#;
   pragma Export (C, u00059, "system__ioB");
   u00060 : constant Version_32 := 16#3c986152#;
   pragma Export (C, u00060, "system__ioS");
   u00061 : constant Version_32 := 16#06253b73#;
   pragma Export (C, u00061, "system__mmapB");
   u00062 : constant Version_32 := 16#c8dac3e3#;
   pragma Export (C, u00062, "system__mmapS");
   u00063 : constant Version_32 := 16#92d882c5#;
   pragma Export (C, u00063, "ada__io_exceptionsS");
   u00064 : constant Version_32 := 16#b124b6b0#;
   pragma Export (C, u00064, "system__mmap__os_interfaceB");
   u00065 : constant Version_32 := 16#060dd44f#;
   pragma Export (C, u00065, "system__mmap__os_interfaceS");
   u00066 : constant Version_32 := 16#8a2d7d24#;
   pragma Export (C, u00066, "system__mmap__unixS");
   u00067 : constant Version_32 := 16#4a925d7c#;
   pragma Export (C, u00067, "system__os_libB");
   u00068 : constant Version_32 := 16#1c53dcbe#;
   pragma Export (C, u00068, "system__os_libS");
   u00069 : constant Version_32 := 16#ec4d5631#;
   pragma Export (C, u00069, "system__case_utilB");
   u00070 : constant Version_32 := 16#9d0f2049#;
   pragma Export (C, u00070, "system__case_utilS");
   u00071 : constant Version_32 := 16#2a8e89ad#;
   pragma Export (C, u00071, "system__stringsB");
   u00072 : constant Version_32 := 16#ee9775cf#;
   pragma Export (C, u00072, "system__stringsS");
   u00073 : constant Version_32 := 16#a2bb689b#;
   pragma Export (C, u00073, "system__object_readerB");
   u00074 : constant Version_32 := 16#f0abf593#;
   pragma Export (C, u00074, "system__object_readerS");
   u00075 : constant Version_32 := 16#7f3a47d4#;
   pragma Export (C, u00075, "system__val_lliS");
   u00076 : constant Version_32 := 16#945fbd74#;
   pragma Export (C, u00076, "system__val_lluS");
   u00077 : constant Version_32 := 16#879d81a3#;
   pragma Export (C, u00077, "system__val_utilB");
   u00078 : constant Version_32 := 16#0e7a20e3#;
   pragma Export (C, u00078, "system__val_utilS");
   u00079 : constant Version_32 := 16#992dbac1#;
   pragma Export (C, u00079, "system__exception_tracesB");
   u00080 : constant Version_32 := 16#a0f69396#;
   pragma Export (C, u00080, "system__exception_tracesS");
   u00081 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00081, "system__wch_conB");
   u00082 : constant Version_32 := 16#b9a7b4cf#;
   pragma Export (C, u00082, "system__wch_conS");
   u00083 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00083, "system__wch_stwB");
   u00084 : constant Version_32 := 16#94b698ce#;
   pragma Export (C, u00084, "system__wch_stwS");
   u00085 : constant Version_32 := 16#1f681dab#;
   pragma Export (C, u00085, "system__wch_cnvB");
   u00086 : constant Version_32 := 16#b6100e3c#;
   pragma Export (C, u00086, "system__wch_cnvS");
   u00087 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00087, "system__wch_jisB");
   u00088 : constant Version_32 := 16#3660171d#;
   pragma Export (C, u00088, "system__wch_jisS");
   u00089 : constant Version_32 := 16#ce3e0e21#;
   pragma Export (C, u00089, "system__soft_links__initializeB");
   u00090 : constant Version_32 := 16#5697fc2b#;
   pragma Export (C, u00090, "system__soft_links__initializeS");
   u00091 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00091, "system__stack_checkingB");
   u00092 : constant Version_32 := 16#2c65fdf5#;
   pragma Export (C, u00092, "system__stack_checkingS");
   u00093 : constant Version_32 := 16#cd3494c7#;
   pragma Export (C, u00093, "ada__strings__utf_encodingB");
   u00094 : constant Version_32 := 16#37e3917d#;
   pragma Export (C, u00094, "ada__strings__utf_encodingS");
   u00095 : constant Version_32 := 16#d1d1ed0b#;
   pragma Export (C, u00095, "ada__strings__utf_encoding__wide_stringsB");
   u00096 : constant Version_32 := 16#103ad78c#;
   pragma Export (C, u00096, "ada__strings__utf_encoding__wide_stringsS");
   u00097 : constant Version_32 := 16#c2b98963#;
   pragma Export (C, u00097, "ada__strings__utf_encoding__wide_wide_stringsB");
   u00098 : constant Version_32 := 16#91eda35b#;
   pragma Export (C, u00098, "ada__strings__utf_encoding__wide_wide_stringsS");
   u00099 : constant Version_32 := 16#b3f0dfa6#;
   pragma Export (C, u00099, "ada__tagsB");
   u00100 : constant Version_32 := 16#cb8ac80c#;
   pragma Export (C, u00100, "ada__tagsS");
   u00101 : constant Version_32 := 16#5534feb6#;
   pragma Export (C, u00101, "system__htableB");
   u00102 : constant Version_32 := 16#261825f7#;
   pragma Export (C, u00102, "system__htableS");
   u00103 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00103, "system__string_hashB");
   u00104 : constant Version_32 := 16#84464e89#;
   pragma Export (C, u00104, "system__string_hashS");
   u00105 : constant Version_32 := 16#0e8dc0f8#;
   pragma Export (C, u00105, "testB");
   u00106 : constant Version_32 := 16#8ec5c555#;
   pragma Export (C, u00106, "testS");
   u00107 : constant Version_32 := 16#d8bb58e0#;
   pragma Export (C, u00107, "ada__text_ioB");
   u00108 : constant Version_32 := 16#93922930#;
   pragma Export (C, u00108, "ada__text_ioS");
   u00109 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00109, "ada__streamsB");
   u00110 : constant Version_32 := 16#67e31212#;
   pragma Export (C, u00110, "ada__streamsS");
   u00111 : constant Version_32 := 16#5fc04ee2#;
   pragma Export (C, u00111, "system__put_imagesB");
   u00112 : constant Version_32 := 16#dff4266b#;
   pragma Export (C, u00112, "system__put_imagesS");
   u00113 : constant Version_32 := 16#e264263f#;
   pragma Export (C, u00113, "ada__strings__text_buffers__utilsB");
   u00114 : constant Version_32 := 16#608bd105#;
   pragma Export (C, u00114, "ada__strings__text_buffers__utilsS");
   u00115 : constant Version_32 := 16#73d2d764#;
   pragma Export (C, u00115, "interfaces__c_streamsB");
   u00116 : constant Version_32 := 16#066a78a0#;
   pragma Export (C, u00116, "interfaces__c_streamsS");
   u00117 : constant Version_32 := 16#30f1a29e#;
   pragma Export (C, u00117, "system__file_ioB");
   u00118 : constant Version_32 := 16#05ab7778#;
   pragma Export (C, u00118, "system__file_ioS");
   u00119 : constant Version_32 := 16#86c56e5a#;
   pragma Export (C, u00119, "ada__finalizationS");
   u00120 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00120, "system__finalization_rootB");
   u00121 : constant Version_32 := 16#ed28e58d#;
   pragma Export (C, u00121, "system__finalization_rootS");
   u00122 : constant Version_32 := 16#5f450cb5#;
   pragma Export (C, u00122, "system__file_control_blockS");
   u00123 : constant Version_32 := 16#eeeb4b65#;
   pragma Export (C, u00123, "ada__text_io__text_streamsB");
   u00124 : constant Version_32 := 16#4986ba89#;
   pragma Export (C, u00124, "ada__text_io__text_streamsS");
   u00125 : constant Version_32 := 16#2bd88f63#;
   pragma Export (C, u00125, "domS");
   u00126 : constant Version_32 := 16#b1004cdd#;
   pragma Export (C, u00126, "dom__coreB");
   u00127 : constant Version_32 := 16#65629f00#;
   pragma Export (C, u00127, "dom__coreS");
   u00128 : constant Version_32 := 16#17965ec6#;
   pragma Export (C, u00128, "saxS");
   u00129 : constant Version_32 := 16#5c0f0294#;
   pragma Export (C, u00129, "sax__encodingsS");
   u00130 : constant Version_32 := 16#81555d43#;
   pragma Export (C, u00130, "unicodeB");
   u00131 : constant Version_32 := 16#a421878d#;
   pragma Export (C, u00131, "unicodeS");
   u00132 : constant Version_32 := 16#d4c0c09c#;
   pragma Export (C, u00132, "ada__wide_charactersS");
   u00133 : constant Version_32 := 16#7059439a#;
   pragma Export (C, u00133, "ada__wide_characters__unicodeB");
   u00134 : constant Version_32 := 16#585e6558#;
   pragma Export (C, u00134, "ada__wide_characters__unicodeS");
   u00135 : constant Version_32 := 16#a23f8c52#;
   pragma Export (C, u00135, "system__utf_32B");
   u00136 : constant Version_32 := 16#8615e500#;
   pragma Export (C, u00136, "system__utf_32S");
   u00137 : constant Version_32 := 16#5ae6f8f8#;
   pragma Export (C, u00137, "unicode__namesS");
   u00138 : constant Version_32 := 16#54c0aec0#;
   pragma Export (C, u00138, "unicode__names__basic_latinS");
   u00139 : constant Version_32 := 16#6a391607#;
   pragma Export (C, u00139, "unicode__cesB");
   u00140 : constant Version_32 := 16#ed91c982#;
   pragma Export (C, u00140, "unicode__cesS");
   u00141 : constant Version_32 := 16#b37b69da#;
   pragma Export (C, u00141, "unicode__ces__utf32B");
   u00142 : constant Version_32 := 16#e40e527d#;
   pragma Export (C, u00142, "unicode__ces__utf32S");
   u00143 : constant Version_32 := 16#50a7378d#;
   pragma Export (C, u00143, "unicode__ccsB");
   u00144 : constant Version_32 := 16#bc6fae53#;
   pragma Export (C, u00144, "unicode__ccsS");
   u00145 : constant Version_32 := 16#23a227bd#;
   pragma Export (C, u00145, "unicode__ces__utf8B");
   u00146 : constant Version_32 := 16#38b0aa20#;
   pragma Export (C, u00146, "unicode__ces__utf8S");
   u00147 : constant Version_32 := 16#83ab70a8#;
   pragma Export (C, u00147, "sax__htableB");
   u00148 : constant Version_32 := 16#d78c6334#;
   pragma Export (C, u00148, "sax__htableS");
   u00149 : constant Version_32 := 16#1a789414#;
   pragma Export (C, u00149, "sax__symbolsB");
   u00150 : constant Version_32 := 16#b5e9d8f2#;
   pragma Export (C, u00150, "sax__symbolsS");
   u00151 : constant Version_32 := 16#b5988c27#;
   pragma Export (C, u00151, "gnatS");
   u00152 : constant Version_32 := 16#485b8267#;
   pragma Export (C, u00152, "gnat__task_lockS");
   u00153 : constant Version_32 := 16#05c60a38#;
   pragma Export (C, u00153, "system__task_lockB");
   u00154 : constant Version_32 := 16#c350a173#;
   pragma Export (C, u00154, "system__task_lockS");
   u00155 : constant Version_32 := 16#e4eee151#;
   pragma Export (C, u00155, "sax__pointersB");
   u00156 : constant Version_32 := 16#9cb28877#;
   pragma Export (C, u00156, "sax__pointersS");
   u00157 : constant Version_32 := 16#ca8c282d#;
   pragma Export (C, u00157, "system__finalization_mastersB");
   u00158 : constant Version_32 := 16#c318aa02#;
   pragma Export (C, u00158, "system__finalization_mastersS");
   u00159 : constant Version_32 := 16#35d6ef80#;
   pragma Export (C, u00159, "system__storage_poolsB");
   u00160 : constant Version_32 := 16#d9ac71aa#;
   pragma Export (C, u00160, "system__storage_poolsS");
   u00161 : constant Version_32 := 16#021224f8#;
   pragma Export (C, u00161, "system__pool_globalB");
   u00162 : constant Version_32 := 16#29da5924#;
   pragma Export (C, u00162, "system__pool_globalS");
   u00163 : constant Version_32 := 16#eca5ecae#;
   pragma Export (C, u00163, "system__memoryB");
   u00164 : constant Version_32 := 16#fba7f029#;
   pragma Export (C, u00164, "system__memoryS");
   u00165 : constant Version_32 := 16#c9a3fcbc#;
   pragma Export (C, u00165, "system__stream_attributesB");
   u00166 : constant Version_32 := 16#414158da#;
   pragma Export (C, u00166, "system__stream_attributesS");
   u00167 : constant Version_32 := 16#3e25f63c#;
   pragma Export (C, u00167, "system__stream_attributes__xdrB");
   u00168 : constant Version_32 := 16#ce9a2a0c#;
   pragma Export (C, u00168, "system__stream_attributes__xdrS");
   u00169 : constant Version_32 := 16#61e84971#;
   pragma Export (C, u00169, "system__fat_fltS");
   u00170 : constant Version_32 := 16#47da407c#;
   pragma Export (C, u00170, "system__fat_lfltS");
   u00171 : constant Version_32 := 16#3d0aee96#;
   pragma Export (C, u00171, "system__fat_llfS");
   u00172 : constant Version_32 := 16#886e3a55#;
   pragma Export (C, u00172, "sax__utilsB");
   u00173 : constant Version_32 := 16#b9556646#;
   pragma Export (C, u00173, "sax__utilsS");
   u00174 : constant Version_32 := 16#8e7c94d7#;
   pragma Export (C, u00174, "system__storage_pools__subpoolsB");
   u00175 : constant Version_32 := 16#8393ab70#;
   pragma Export (C, u00175, "system__storage_pools__subpoolsS");
   u00176 : constant Version_32 := 16#cafa918a#;
   pragma Export (C, u00176, "system__storage_pools__subpools__finalizationB");
   u00177 : constant Version_32 := 16#8bd8fdc9#;
   pragma Export (C, u00177, "system__storage_pools__subpools__finalizationS");
   u00178 : constant Version_32 := 16#f0a7720c#;
   pragma Export (C, u00178, "dom__core__documentsB");
   u00179 : constant Version_32 := 16#9a0c02e1#;
   pragma Export (C, u00179, "dom__core__documentsS");
   u00180 : constant Version_32 := 16#18cb740a#;
   pragma Export (C, u00180, "dom__core__elementsB");
   u00181 : constant Version_32 := 16#92281457#;
   pragma Export (C, u00181, "dom__core__elementsS");
   u00182 : constant Version_32 := 16#d6cfcab7#;
   pragma Export (C, u00182, "dom__core__attrsB");
   u00183 : constant Version_32 := 16#4f3aef62#;
   pragma Export (C, u00183, "dom__core__attrsS");
   u00184 : constant Version_32 := 16#5853eea9#;
   pragma Export (C, u00184, "dom__core__nodesB");
   u00185 : constant Version_32 := 16#d698d5da#;
   pragma Export (C, u00185, "dom__core__nodesS");
   u00186 : constant Version_32 := 16#a1d6147d#;
   pragma Export (C, u00186, "system__compare_array_unsigned_8B");
   u00187 : constant Version_32 := 16#0bd9e790#;
   pragma Export (C, u00187, "system__compare_array_unsigned_8S");
   u00188 : constant Version_32 := 16#a8025f3c#;
   pragma Export (C, u00188, "system__address_operationsB");
   u00189 : constant Version_32 := 16#b1d6282e#;
   pragma Export (C, u00189, "system__address_operationsS");
   u00190 : constant Version_32 := 16#f819c43c#;
   pragma Export (C, u00190, "system__strings__stream_opsB");
   u00191 : constant Version_32 := 16#ec029138#;
   pragma Export (C, u00191, "system__strings__stream_opsS");
   u00192 : constant Version_32 := 16#a8c2f76e#;
   pragma Export (C, u00192, "unicode__encodingsB");
   u00193 : constant Version_32 := 16#0dd3cf4a#;
   pragma Export (C, u00193, "unicode__encodingsS");
   u00194 : constant Version_32 := 16#42b36dfe#;
   pragma Export (C, u00194, "ada__strings__unboundedB");
   u00195 : constant Version_32 := 16#da258d18#;
   pragma Export (C, u00195, "ada__strings__unboundedS");
   u00196 : constant Version_32 := 16#36068beb#;
   pragma Export (C, u00196, "ada__strings__searchB");
   u00197 : constant Version_32 := 16#73987e07#;
   pragma Export (C, u00197, "ada__strings__searchS");
   u00198 : constant Version_32 := 16#020a3f4d#;
   pragma Export (C, u00198, "system__atomic_countersB");
   u00199 : constant Version_32 := 16#1686bb90#;
   pragma Export (C, u00199, "system__atomic_countersS");
   u00200 : constant Version_32 := 16#2cc3eaf2#;
   pragma Export (C, u00200, "unicode__ccs__iso_8859_1B");
   u00201 : constant Version_32 := 16#8e38bcbd#;
   pragma Export (C, u00201, "unicode__ccs__iso_8859_1S");
   u00202 : constant Version_32 := 16#5d55fc19#;
   pragma Export (C, u00202, "unicode__ccs__iso_8859_15B");
   u00203 : constant Version_32 := 16#92feba06#;
   pragma Export (C, u00203, "unicode__ccs__iso_8859_15S");
   u00204 : constant Version_32 := 16#f736a935#;
   pragma Export (C, u00204, "unicode__names__currency_symbolsS");
   u00205 : constant Version_32 := 16#78ee47b1#;
   pragma Export (C, u00205, "unicode__names__latin_1_supplementS");
   u00206 : constant Version_32 := 16#5cfe3178#;
   pragma Export (C, u00206, "unicode__names__latin_extended_aS");
   u00207 : constant Version_32 := 16#1c4bceb3#;
   pragma Export (C, u00207, "unicode__ccs__iso_8859_2B");
   u00208 : constant Version_32 := 16#349a01be#;
   pragma Export (C, u00208, "unicode__ccs__iso_8859_2S");
   u00209 : constant Version_32 := 16#c90d6e9f#;
   pragma Export (C, u00209, "unicode__names__spacing_modifier_lettersS");
   u00210 : constant Version_32 := 16#c7ca5c74#;
   pragma Export (C, u00210, "unicode__ccs__iso_8859_3B");
   u00211 : constant Version_32 := 16#487a726a#;
   pragma Export (C, u00211, "unicode__ccs__iso_8859_3S");
   u00212 : constant Version_32 := 16#480189f0#;
   pragma Export (C, u00212, "unicode__ccs__iso_8859_4B");
   u00213 : constant Version_32 := 16#ad57c2bd#;
   pragma Export (C, u00213, "unicode__ccs__iso_8859_4S");
   u00214 : constant Version_32 := 16#4b4b6a37#;
   pragma Export (C, u00214, "unicode__ccs__windows_1251B");
   u00215 : constant Version_32 := 16#ba76c289#;
   pragma Export (C, u00215, "unicode__ccs__windows_1251S");
   u00216 : constant Version_32 := 16#f6cba099#;
   pragma Export (C, u00216, "unicode__names__cyrillicS");
   u00217 : constant Version_32 := 16#4b7938ca#;
   pragma Export (C, u00217, "unicode__names__general_punctuationS");
   u00218 : constant Version_32 := 16#c0b9df8b#;
   pragma Export (C, u00218, "unicode__names__letterlike_symbolsS");
   u00219 : constant Version_32 := 16#706123e1#;
   pragma Export (C, u00219, "unicode__ccs__windows_1252B");
   u00220 : constant Version_32 := 16#7cee5e39#;
   pragma Export (C, u00220, "unicode__ccs__windows_1252S");
   u00221 : constant Version_32 := 16#958389e0#;
   pragma Export (C, u00221, "unicode__names__latin_extended_bS");
   u00222 : constant Version_32 := 16#ba342546#;
   pragma Export (C, u00222, "unicode__ces__basic_8bitB");
   u00223 : constant Version_32 := 16#4161d344#;
   pragma Export (C, u00223, "unicode__ces__basic_8bitS");
   u00224 : constant Version_32 := 16#ad1d2052#;
   pragma Export (C, u00224, "unicode__ces__utf16B");
   u00225 : constant Version_32 := 16#76c334e3#;
   pragma Export (C, u00225, "unicode__ces__utf16S");
   u00226 : constant Version_32 := 16#f24025b6#;
   pragma Export (C, u00226, "dom__readersB");
   u00227 : constant Version_32 := 16#b93c7452#;
   pragma Export (C, u00227, "dom__readersS");
   u00228 : constant Version_32 := 16#9ff1faba#;
   pragma Export (C, u00228, "dom__core__character_datasB");
   u00229 : constant Version_32 := 16#06ea1232#;
   pragma Export (C, u00229, "dom__core__character_datasS");
   u00230 : constant Version_32 := 16#21fdcff6#;
   pragma Export (C, u00230, "sax__attributesB");
   u00231 : constant Version_32 := 16#5ab7981b#;
   pragma Export (C, u00231, "sax__attributesS");
   u00232 : constant Version_32 := 16#0de7ae30#;
   pragma Export (C, u00232, "ada__strings__fixedB");
   u00233 : constant Version_32 := 16#64881af1#;
   pragma Export (C, u00233, "ada__strings__fixedS");
   u00234 : constant Version_32 := 16#3d8854f0#;
   pragma Export (C, u00234, "sax__modelsB");
   u00235 : constant Version_32 := 16#3350c648#;
   pragma Export (C, u00235, "sax__modelsS");
   u00236 : constant Version_32 := 16#55d60400#;
   pragma Export (C, u00236, "sax__exceptionsB");
   u00237 : constant Version_32 := 16#1bf9ab35#;
   pragma Export (C, u00237, "sax__exceptionsS");
   u00238 : constant Version_32 := 16#a7f1b3a1#;
   pragma Export (C, u00238, "sax__locatorsB");
   u00239 : constant Version_32 := 16#069b7760#;
   pragma Export (C, u00239, "sax__locatorsS");
   u00240 : constant Version_32 := 16#014c2eaa#;
   pragma Export (C, u00240, "gnat__directory_operationsB");
   u00241 : constant Version_32 := 16#d9c6d728#;
   pragma Export (C, u00241, "gnat__directory_operationsS");
   u00242 : constant Version_32 := 16#2b995a0d#;
   pragma Export (C, u00242, "gnat__os_libS");
   u00243 : constant Version_32 := 16#f6efe8c4#;
   pragma Export (C, u00243, "sax__readersB");
   u00244 : constant Version_32 := 16#20801fd7#;
   pragma Export (C, u00244, "sax__readersS");
   u00245 : constant Version_32 := 16#772f9c73#;
   pragma Export (C, u00245, "input_sourcesB");
   u00246 : constant Version_32 := 16#ef327363#;
   pragma Export (C, u00246, "input_sourcesS");
   u00247 : constant Version_32 := 16#5556565c#;
   pragma Export (C, u00247, "input_sources__fileB");
   u00248 : constant Version_32 := 16#e1007772#;
   pragma Export (C, u00248, "input_sources__fileS");
   u00249 : constant Version_32 := 16#956e676b#;
   pragma Export (C, u00249, "input_sources__stringsB");
   u00250 : constant Version_32 := 16#d2561cff#;
   pragma Export (C, u00250, "input_sources__stringsS");
   u00251 : constant Version_32 := 16#edf36f8d#;
   pragma Export (C, u00251, "gnat__command_lineB");
   u00252 : constant Version_32 := 16#0b5ceadc#;
   pragma Export (C, u00252, "gnat__command_lineS");
   u00253 : constant Version_32 := 16#236b2bc2#;
   pragma Export (C, u00253, "system__val_intS");
   u00254 : constant Version_32 := 16#28959a26#;
   pragma Export (C, u00254, "system__val_unsS");
   u00255 : constant Version_32 := 16#ab26c66f#;
   pragma Export (C, u00255, "ada__command_lineB");
   u00256 : constant Version_32 := 16#3cdef8c9#;
   pragma Export (C, u00256, "ada__command_lineS");
   u00257 : constant Version_32 := 16#40fe4806#;
   pragma Export (C, u00257, "gnat__regexpS");
   u00258 : constant Version_32 := 16#b9a3a304#;
   pragma Export (C, u00258, "system__regexpB");
   u00259 : constant Version_32 := 16#81e831d1#;
   pragma Export (C, u00259, "system__regexpS");
   u00260 : constant Version_32 := 16#fcd606d0#;
   pragma Export (C, u00260, "gnat__stringsS");
   u00261 : constant Version_32 := 16#0d4020cb#;
   pragma Export (C, u00261, "gnat__expectB");
   u00262 : constant Version_32 := 16#468cbbf9#;
   pragma Export (C, u00262, "gnat__expectS");
   u00263 : constant Version_32 := 16#dbe78fbc#;
   pragma Export (C, u00263, "ada__calendarB");
   u00264 : constant Version_32 := 16#31350a81#;
   pragma Export (C, u00264, "ada__calendarS");
   u00265 : constant Version_32 := 16#51f2d040#;
   pragma Export (C, u00265, "system__os_primitivesB");
   u00266 : constant Version_32 := 16#a527f3eb#;
   pragma Export (C, u00266, "system__os_primitivesS");
   u00267 : constant Version_32 := 16#8099c5e3#;
   pragma Export (C, u00267, "gnat__ioB");
   u00268 : constant Version_32 := 16#2a95b695#;
   pragma Export (C, u00268, "gnat__ioS");
   u00269 : constant Version_32 := 16#8f9f9fb7#;
   pragma Export (C, u00269, "gnat__regpatS");
   u00270 : constant Version_32 := 16#55156213#;
   pragma Export (C, u00270, "system__regpatB");
   u00271 : constant Version_32 := 16#20800d62#;
   pragma Export (C, u00271, "system__regpatS");
   u00272 : constant Version_32 := 16#9761820e#;
   pragma Export (C, u00272, "system__img_charB");
   u00273 : constant Version_32 := 16#3eeecefa#;
   pragma Export (C, u00273, "system__img_charS");
   u00274 : constant Version_32 := 16#98c06228#;
   pragma Export (C, u00274, "system__os_constantsS");
   u00275 : constant Version_32 := 16#95395c6c#;
   pragma Export (C, u00275, "input_sources__httpB");
   u00276 : constant Version_32 := 16#1ae898eb#;
   pragma Export (C, u00276, "input_sources__httpS");
   u00277 : constant Version_32 := 16#2128f13d#;
   pragma Export (C, u00277, "gnat__socketsB");
   u00278 : constant Version_32 := 16#7476f04d#;
   pragma Export (C, u00278, "gnat__socketsS");
   u00279 : constant Version_32 := 16#eee08ee5#;
   pragma Export (C, u00279, "gnat__sockets__linker_optionsS");
   u00280 : constant Version_32 := 16#c066048c#;
   pragma Export (C, u00280, "gnat__sockets__pollB");
   u00281 : constant Version_32 := 16#1f897301#;
   pragma Export (C, u00281, "gnat__sockets__pollS");
   u00282 : constant Version_32 := 16#41df414d#;
   pragma Export (C, u00282, "gnat__sockets__thinB");
   u00283 : constant Version_32 := 16#0802a288#;
   pragma Export (C, u00283, "gnat__sockets__thinS");
   u00284 : constant Version_32 := 16#ffaa9e94#;
   pragma Export (C, u00284, "ada__calendar__delaysB");
   u00285 : constant Version_32 := 16#d86d2f1d#;
   pragma Export (C, u00285, "ada__calendar__delaysS");
   u00286 : constant Version_32 := 16#01d87a0e#;
   pragma Export (C, u00286, "gnat__sockets__thin_commonB");
   u00287 : constant Version_32 := 16#c9e91cf5#;
   pragma Export (C, u00287, "gnat__sockets__thin_commonS");
   u00288 : constant Version_32 := 16#8d199472#;
   pragma Export (C, u00288, "interfaces__c__stringsB");
   u00289 : constant Version_32 := 16#eda3d306#;
   pragma Export (C, u00289, "interfaces__c__stringsS");
   u00290 : constant Version_32 := 16#2f9cb76c#;
   pragma Export (C, u00290, "system__arith_64B");
   u00291 : constant Version_32 := 16#10be6cf2#;
   pragma Export (C, u00291, "system__arith_64S");
   u00292 : constant Version_32 := 16#5de653db#;
   pragma Export (C, u00292, "system__communicationB");
   u00293 : constant Version_32 := 16#bbbac3cf#;
   pragma Export (C, u00293, "system__communicationS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.latin_1%s
   --  ada.wide_characters%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.img_char%s
   --  system.img_char%b
   --  system.img_int%s
   --  system.io%s
   --  system.io%b
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%s
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  system.unsigned_types%s
   --  system.img_uns%s
   --  system.utf_32%s
   --  system.utf_32%b
   --  ada.wide_characters.unicode%s
   --  ada.wide_characters.unicode%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%s
   --  system.wch_cnv%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.traceback%s
   --  system.traceback%b
   --  ada.characters.handling%s
   --  system.case_util%s
   --  system.os_lib%s
   --  system.secondary_stack%s
   --  system.standard_library%s
   --  ada.exceptions%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.soft_links%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_llu%s
   --  system.val_lli%s
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  ada.exceptions.traceback%b
   --  system.address_image%s
   --  system.address_image%b
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.bounded_strings%s
   --  system.bounded_strings%b
   --  system.case_util%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.maps%s
   --  ada.strings.maps%b
   --  ada.strings.maps.constants%s
   --  interfaces.c%s
   --  interfaces.c%b
   --  system.exceptions%s
   --  system.exceptions.machine%s
   --  system.exceptions.machine%b
   --  ada.characters.handling%b
   --  system.exception_traces%s
   --  system.exception_traces%b
   --  system.memory%s
   --  system.memory%b
   --  system.mmap%s
   --  system.mmap.os_interface%s
   --  system.mmap%b
   --  system.mmap.unix%s
   --  system.mmap.os_interface%b
   --  system.object_reader%s
   --  system.object_reader%b
   --  system.dwarf_lines%s
   --  system.dwarf_lines%b
   --  system.os_lib%b
   --  system.secondary_stack%b
   --  system.soft_links.initialize%s
   --  system.soft_links.initialize%b
   --  system.soft_links%b
   --  system.standard_library%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  ada.command_line%s
   --  ada.command_line%b
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.strings.fixed%s
   --  ada.strings.fixed%b
   --  ada.strings.utf_encoding%s
   --  ada.strings.utf_encoding%b
   --  ada.strings.utf_encoding.wide_strings%s
   --  ada.strings.utf_encoding.wide_strings%b
   --  ada.strings.utf_encoding.wide_wide_strings%s
   --  ada.strings.utf_encoding.wide_wide_strings%b
   --  ada.tags%s
   --  ada.tags%b
   --  ada.strings.text_buffers%s
   --  ada.strings.text_buffers%b
   --  ada.strings.text_buffers.utils%s
   --  ada.strings.text_buffers.utils%b
   --  gnat%s
   --  gnat.io%s
   --  gnat.io%b
   --  gnat.os_lib%s
   --  gnat.strings%s
   --  interfaces.c.strings%s
   --  interfaces.c.strings%b
   --  system.arith_64%s
   --  system.arith_64%b
   --  system.fat_flt%s
   --  system.fat_lflt%s
   --  system.fat_llf%s
   --  system.os_constants%s
   --  system.put_images%s
   --  system.put_images%b
   --  ada.streams%s
   --  ada.streams%b
   --  system.communication%s
   --  system.communication%b
   --  system.file_control_block%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.file_io%s
   --  system.file_io%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.storage_pools.subpools%b
   --  system.stream_attributes%s
   --  system.stream_attributes.xdr%s
   --  system.stream_attributes.xdr%b
   --  system.stream_attributes%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.task_lock%s
   --  system.task_lock%b
   --  gnat.task_lock%s
   --  system.val_uns%s
   --  system.val_int%s
   --  system.regpat%s
   --  system.regpat%b
   --  gnat.regpat%s
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.text_streams%s
   --  ada.text_io.text_streams%b
   --  gnat.directory_operations%s
   --  gnat.directory_operations%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  gnat.expect%s
   --  gnat.expect%b
   --  gnat.sockets%s
   --  gnat.sockets.linker_options%s
   --  gnat.sockets.poll%s
   --  gnat.sockets.thin_common%s
   --  gnat.sockets.thin_common%b
   --  gnat.sockets.thin%s
   --  gnat.sockets.thin%b
   --  gnat.sockets%b
   --  gnat.sockets.poll%b
   --  system.regexp%s
   --  system.regexp%b
   --  gnat.regexp%s
   --  gnat.command_line%s
   --  gnat.command_line%b
   --  system.strings.stream_ops%s
   --  system.strings.stream_ops%b
   --  unicode%s
   --  unicode.names%s
   --  unicode.names.basic_latin%s
   --  unicode%b
   --  unicode.names.currency_symbols%s
   --  unicode.names.cyrillic%s
   --  unicode.names.general_punctuation%s
   --  unicode.names.latin_1_supplement%s
   --  unicode.names.latin_extended_a%s
   --  unicode.names.latin_extended_b%s
   --  unicode.names.letterlike_symbols%s
   --  unicode.names.spacing_modifier_letters%s
   --  dom%s
   --  sax%s
   --  sax.htable%s
   --  sax.htable%b
   --  sax.pointers%s
   --  sax.pointers%b
   --  unicode.ccs%s
   --  unicode.ccs%b
   --  unicode.ccs.iso_8859_1%s
   --  unicode.ccs.iso_8859_1%b
   --  unicode.ccs.iso_8859_15%s
   --  unicode.ccs.iso_8859_15%b
   --  unicode.ccs.iso_8859_2%s
   --  unicode.ccs.iso_8859_2%b
   --  unicode.ccs.iso_8859_3%s
   --  unicode.ccs.iso_8859_3%b
   --  unicode.ccs.iso_8859_4%s
   --  unicode.ccs.iso_8859_4%b
   --  unicode.ccs.windows_1251%s
   --  unicode.ccs.windows_1251%b
   --  unicode.ccs.windows_1252%s
   --  unicode.ccs.windows_1252%b
   --  unicode.ces%s
   --  unicode.ces%b
   --  sax.symbols%s
   --  sax.symbols%b
   --  sax.locators%s
   --  sax.locators%b
   --  sax.exceptions%s
   --  sax.exceptions%b
   --  unicode.ces.utf32%s
   --  unicode.ces.utf32%b
   --  unicode.ces.basic_8bit%s
   --  unicode.ces.basic_8bit%b
   --  unicode.ces.utf16%s
   --  unicode.ces.utf16%b
   --  unicode.ces.utf8%s
   --  unicode.ces.utf8%b
   --  sax.encodings%s
   --  sax.models%s
   --  sax.models%b
   --  sax.attributes%s
   --  sax.attributes%b
   --  sax.utils%s
   --  sax.utils%b
   --  dom.core%s
   --  dom.core%b
   --  unicode.encodings%s
   --  unicode.encodings%b
   --  dom.core.nodes%s
   --  dom.core.nodes%b
   --  dom.core.attrs%s
   --  dom.core.attrs%b
   --  dom.core.character_datas%s
   --  dom.core.character_datas%b
   --  dom.core.documents%s
   --  dom.core.elements%s
   --  dom.core.elements%b
   --  dom.core.documents%b
   --  input_sources%s
   --  input_sources%b
   --  input_sources.file%s
   --  input_sources.file%b
   --  input_sources.http%s
   --  input_sources.http%b
   --  input_sources.strings%s
   --  input_sources.strings%b
   --  sax.readers%s
   --  sax.readers%b
   --  dom.readers%s
   --  dom.readers%b
   --  test%s
   --  test%b
   --  main%b
   --  END ELABORATION ORDER

end ada_main;
