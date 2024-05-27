------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Cheddar is a GNU GPL real-time scheduling analysis tool.
-- This program provides services to automatically check schedulability and
-- other performance criteria of real-time architecture models.
--
-- Copyright (C) 2002-2023, Frank Singhoff, Alain Plantec, Jerome Legrand,
--                          Hai Nam Tran, Stephane Rubini
--
-- The Cheddar project was started in 2002 by
-- Frank Singhoff, Lab-STICC UMR CNRS 6285, Universite de Bretagne Occidentale
--
-- Cheddar has been published in the "Agence de Protection des Programmes/France" in 2008.
-- Since 2008, Ellidiss technologies also contributes to the development of
-- Cheddar and provides industrial support.
--
-- The full list of contributors and sponsors can be found in README.md
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
--
-- Contact : cheddar@listes.univ-brest.fr
--
------------------------------------------------------------------------------
-- Last update :
--    $Rev$
--    $Date$
--    $Author: singhoff $
------------------------------------------------------------------------------
------------------------------------------------------------------------------

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Maps;      use Ada.Strings.Maps;

with Sax.Readers;           use Sax.Readers;
with Sax.Exceptions;        use Sax.Exceptions;
with Sax.Locators;          use Sax.Locators;
with Sax.Attributes;        use Sax.Attributes;
with Unicode.CES;           use Unicode.CES;
with Unicode;               use Unicode;

with Offsets;               use Offsets;
with Offsets;               use Offsets.Offsets_Table_Package;
with Parameters;            use Parameters;
with Parameters; use Parameters.User_Defined_Parameters_Table_Package;
with strings;               use strings;
with unbounded_strings;     use unbounded_strings;
with Dependencies;          use Dependencies;
with Resources;             use Resources;
with Resources;             use Resources.Resource_Accesses;
with resource_set;          use resource_set;
with resource_set;          use resource_set.generic_resource_set;
with event_analyzer_set;    use event_analyzer_set;
with event_analyzer_set;    use event_analyzer_set.generic_event_analyzer_set;
with Address_Spaces;        use Address_Spaces;
with address_space_set;     use address_space_set;
with address_space_set;     use address_space_set.generic_address_space_set;
with Processors;            use Processors;
with Core_Units;            use Core_Units;
with Core_Units;            use Core_Units.Core_Units_Table_Package;
with Queueing_Systems;      use Queueing_Systems;
with time_unit_events;      use time_unit_events;
with time_unit_events;      use time_unit_events.time_unit_package;
with Scheduling_Analysis;   use Scheduling_Analysis;
with Scheduler_Interface;   use Scheduler_Interface;
with Processor_Interface;   use Processor_Interface;
with task_dependencies;     use task_dependencies;
with network_set;           use network_set;
with Networks;              use Networks;
with Networks;              use Networks.Positions_Table_Package;
with Networks;
use network_set.generic_network_set;
with debug;               use debug;
with xml_architecture_io; use xml_architecture_io;
with Tasks;               use Tasks;
with Tasks;               use Tasks.Generic_Task_List_Package;
with task_set;            use task_set;
with Task_Groups;         use Task_Groups;
with task_group_set;      use task_group_set;
with task_group_set;
use task_set.generic_task_set;
with Buffers;                           use Buffers;
use Buffers.Buffer_Roles_Package;
with buffer_set;                        use buffer_set;
use buffer_set.generic_buffer_set;
with Dependencies;                      use Dependencies;
with Messages;                          use Messages;
with message_set;                       use message_set;
with Memories;                          use Memories;
use Memories.Memories_Table_Package;
with memory_set;                        use memory_set;
with resource_set;                      use resource_set;
with Objects;                           use Objects;
use Objects.Generic_Object_Set_Package;
with CFGs;                              use CFGs;
with cfg_set;                           use cfg_set;
with CFG_Nodes;                         use CFG_Nodes;
use CFG_Nodes.CFG_Nodes_Table_Package;
with cfg_node_set.basic_block_set;      use cfg_node_set.basic_block_set;
with cfg_node_set;                      use cfg_node_set;
with basic_blocks;                      use basic_blocks;
with cfg_edges;                         use cfg_edges;
use cfg_edges.cfg_edges_table_package;
with cfg_edge_set;                      use cfg_edge_set;
with Caches;                            use Caches;
use Caches.Cache_Blocks_Table_Package;
with execution_units;      use execution_units;
use execution_units.execution_units_Table_Package;
with cache_set;                         use cache_set;
with cache_block_set;                   use cache_block_set;
with cache_access_profile_set;          use cache_access_profile_set;
with MILS_Security;                     use MILS_Security;
with Batteries;                         use Batteries;
with battery_set;                       use battery_set;
with Scheduling_Errors;                 use Scheduling_Errors;
use Scheduling_Errors.Scheduling_Errors_Table_Package;
with scheduling_error_set;              use scheduling_error_set;
with Xml_Architecture_Parser_Interface; use Xml_Architecture_Parser_Interface;
with id_generators;                     use id_generators;
with framework;                         use framework;


package body xml_generic_parsers.architecture is
   --------------------------------------------------------------------
   -- Global variable of the parser
   --------------------------------------------------------------------

   -- Variable  used by the XML parser to store content of XML tag
   --
   component_id  : Unbounded_String;
   component_ref : Unbounded_String;

   as1                    : address_space_io;
   co1                    : core_unit_io;
   bat1                   : battery_io;
   mco1                   : multi_cores_processor_io;
   nco1                   : mono_core_processor_io;
   ta1                    : sporadic_inner_periodic_task_io;
   ft1                    : frame_task_io;
   tg1                    : generic_task_group_io;
   re1                    : pcp_resource_io;
   bu1                    : buffer_io;
   dep1                   : dependency_io;
   me1                    : periodic_message_io;
   sched1                 : scheduling_parameters_io;
   ea1                    : event_analyzer_io;
   no1                    : noc_network_io;
   sp1                    : spacewire_network_io;
   bus1                   : bus_network_io;
   icache_i               : instruction_cache_io;
   dcache_i               : data_cache_io;
   cache_block_i          : cache_block_io;
   cfg_i                  : cfg_io;
   cfg_node_i             : cfg_node_io;
   cfg_edge_i             : cfg_edge_io;
   basic_block_i          : basic_block_io;
   cache_access_profile_i : cache_access_profile_io;
   generic_memory_i       : generic_memory_io;
   dram_memory_i          : dram_memory_io;
   kalray_memory_i        : kalray_memory_io;
   scheduling_error_i     : scheduling_error_io;

   -- Store vector values of a task
   --
   a_execution_unit  : execution_unit_io;
   values            : execution_units_table;
   capacity_values   : execution_units_table;
   quality_values    : execution_units_table;
   parsing_capacities: boolean := false;
   parsing_qualities : boolean := false;

   -- Store all offset of a task
   --
   an_offset_type : offset_type_io;
   an_offset      : offsets_table;

   -- Store parameters of a NOC
   --
   positions  : positions_table;
   a_position : position_io;

   -- Store parameters of a message or a task
   --
   param   : user_defined_parameters_table;
   a_param : parameter_io;

   -- Store the list of critical section of a resource entity
   --
   a_critical_section      : critical_section_io;
   a_critical_section_list : resource_accesses_table;

   -- Store buffer users for buffer entities
   --
   a_buffer_role : buffer_role_io;
   roles         : buffer_roles_table;

   -- Store the list of task of a  group of task entity
   --
   a_task_list : generic_task_list;

   -- Variable to store indexes of indexed_table entities
   --
   index_value : Unbounded_String;

   -- Variables to allocate entities
   --
   core1                 : core_unit_ptr;
   address_space1        : address_space_ptr;
   processor1            : generic_processor_ptr;
   network1              : generic_network_ptr;
   task1                 : generic_task_ptr;
   task_group1           : generic_task_group_ptr;
   resource1             : generic_resource_ptr;
   buffer1               : buffer_ptr;
   message1              : generic_message_ptr;
   cache1                : generic_cache_ptr;
   cfg1                  : cfg_ptr;
   cfg_node1             : cfg_node_ptr;
   cfg_edge1             : cfg_edge_ptr;
   cache_access_profile1 : cache_access_profile_ptr;
   cache_block1          : cache_block_ptr;
   scheduling_error1     : scheduling_error_ptr;
   memory1               : generic_memory_ptr;
   battery1              : battery_ptr;

   a_core_unit_table : core_units_table;
   a_memory_table    : memories_table;
   a_cfg_nodes_table : cfg_nodes_table;
   a_cfg_edges_table : cfg_edges_table;

   a_cache_blocks_table : cache_blocks_table;
   ucbs_table           : cache_blocks_table;
   ecbs_table           : cache_blocks_table;

   -- Indicate when where we are during the parsing
   --
   xml_unit           : xml_units := core_units_xml;
   xml_unit_attribute : xml_units;

   -- Record to stored parsed data
   --
   mem_rec              : memory_record;
   scheduling_error_rec : scheduling_error_record;

   --------------------------------------------------------------------
   -- XML parser for record like entity of the Cheddar Meta model
   --------------------------------------------------------------------

   -- Execution units records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out execution_units_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if (To_String (to_lower (qname)) = "capacities")
        then
         parsing_capacities:=true;
         parsing_qualities:=false;
         initialize (obj);
      end if;
      if (To_String (to_lower (qname)) = "qualities")
        then
         parsing_capacities:=false;
         parsing_qualities:=true;
         initialize (obj);
      end if;
   end start_element;

   procedure end_element_values
     (handler       : in out xml_generic_parser;
      obj           : in out execution_unit_io;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : execution_unit_ptr;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if (To_String (to_lower (qname)) = "values_eu") and
           parsing_qualities then
	 item            := new execution_unit;
         item.values_eu  := obj.values_eu;
         item.type_eu    := obj.type_eu;
         add (quality_values, item);
      end if;
      if (To_String (to_lower (qname)) = "values_eu") and
           parsing_capacities then
	 item            := new execution_unit;
         item.values_eu  := obj.values_eu;
         item.type_eu    := obj.type_eu;
         add (capacity_values, item);
      end if;
   end end_element_values;
   
   -- Buffer records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out buffer_roles_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if To_String (to_lower (qname)) = "roles" then
         initialize (obj);
      end if;
   end start_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      obj           : in out buffer_role_io;
      obj_table     : in out buffer_roles_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : buffer_role;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if To_String (to_lower (qname)) = "buffer_role" then
         item.the_role           := obj.the_role;
         item.size               := obj.size;
         item.time               := obj.time;
         item.timeout            := obj.timeout;
         item.amplitude_function := obj.amplitude_function;
         add (obj_table, index_value, item);
      end if;
   end end_element;

   -- Position records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out positions_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if To_String (to_lower (qname)) = "processor_positions" then
         initialize (obj);
      end if;
   end start_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      obj           : in out position_io;
      obj_table     : in out positions_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : position;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if To_String (to_lower (qname)) = "position" then
         item.X := obj.X;
         item.Y := obj.Y;
         add (obj_table, index_value, item);
      end if;
   end end_element;

   -- Resource records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out resource_accesses_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if To_String (to_lower (qname)) = "critical_sections" then
         initialize (obj);
      end if;
   end start_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      obj           : in out critical_section_io;
      obj_table     : in out resource_accesses_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : critical_section;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if To_String (to_lower (qname)) = "critical_section" then
         item.task_Synchronization := obj.task_synchronization;
         item.task_end   := obj.task_end;
         item.task_begin := obj.task_begin;
         add (obj_table, index_value, item);
      end if;
   end end_element;

   -- Offset records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out offsets_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if To_String (to_lower (qname)) = "offsets" then
         initialize (obj);
      end if;
   end start_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      obj           : in out offset_type_io;
      obj_table     : in out offsets_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : offset_type;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if To_String (to_lower (qname)) = "offset_type" then
         item.activation   := obj.activation;
         item.offset_value := obj.offset_value;
         add (obj_table, item);
      end if;
   end end_element;

   -- User defined parameter records
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out user_defined_parameters_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
   begin
      if To_String (to_lower (qname)) = "parameters" then
         initialize (obj);
      end if;
   end start_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      obj           : in out parameter_io;
      obj_table     : in out user_defined_parameters_table;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      item : parameter_ptr;
   begin
      End_Element (handler, obj, namespace_uri, local_name, qname);

      if To_String (to_lower (qname)) = "parameter" then
         if obj.type_of_parameter = double_parameter then
            item              := new parameter (double_parameter);
            item.double_value := obj.double_value;
         end if;
         if obj.type_of_parameter = integer_parameter then
            item               := new parameter (integer_parameter);
            item.integer_value := obj.integer_value;
         end if;
         if obj.type_of_parameter = string_parameter then
            item              := new parameter (string_parameter);
            item.string_value := obj.string_value;
         end if;
         if obj.type_of_parameter = boolean_parameter then
            item               := new parameter (boolean_parameter);
            item.boolean_value := obj.boolean_value;
         end if;
         item.parameter_name := obj.parameter_name;
         add (obj_table, item);
      end if;
   end end_element;

   -- Task list
   --
   procedure start_element
     (handler       : in out xml_generic_parser;
      obj           : in out generic_task_list;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is
      use Generic_Task_List_Package;
   begin
      if To_String (to_lower (qname)) = "task_list" then
         initialize (obj);
      end if;
   end start_element;

   -- Initialize all data
   --
   procedure initialize (handler : in out xml_architecture_parser) is
   begin

      Initialize (as1);
      Initialize (co1);
      Initialize (bat1);
      Initialize (mco1);
      Initialize (nco1);
      Initialize (ta1);
      Initialize (ft1);
      Initialize (no1);
      Initialize (sp1);
      Initialize (bus1);
      Initialize (tg1);
      Initialize (re1);
      Initialize (bu1);
      Initialize (me1);
      Initialize (dep1);
      Initialize (sched1);
      Initialize (ea1);
      Initialize (icache_i);
      Initialize (dcache_i);
      Initialize (cfg_i);
      Initialize (cfg_node_i);
      Initialize (cfg_edge_i);
      Initialize (basic_block_i);
      Initialize (cache_block_i);
      Initialize (cache_access_profile_i);
      Initialize (generic_memory_i);
      Initialize (dram_memory_i);
      Initialize (kalray_memory_i);
      Initialize (scheduling_error_i);

      Initialize (an_offset_type);
      initialize (an_offset);
      initialize (a_execution_unit);
      initialize (values);
      initialize (capacity_values);
      initialize (quality_values);
      initialize (param);
      Initialize (a_param);
      Initialize (a_position);
      initialize (positions);
      Initialize (a_critical_section);
      initialize (a_critical_section_list);
      initialize (a_task_list);
      Initialize (a_buffer_role);
      initialize (roles);

      initialize (a_core_unit_table);
      initialize (a_memory_table);
      initialize (a_cfg_nodes_table);
      initialize (a_cfg_edges_table);
      initialize (a_cache_blocks_table);
      initialize (ucbs_table);
      initialize (ecbs_table);

      handler.current_parameter := 1;

   end initialize;

   procedure start_document (handler : in out xml_architecture_parser) is
   begin
      initialize (handler);
      initialize (handler.parsed_system);
   end start_document;

   procedure start_element
     (handler       : in out xml_architecture_parser;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "";
      atts          :        Sax.Attributes.attributes'class)
   is

   begin
      handler.current_parameter := 1;

      if (To_String (to_lower (qname)) = "tasks") then
         xml_unit := tasks_xml;
      end if;

      if (To_String (to_lower (qname)) = "task_groups") then
         xml_unit := task_groups_xml;
      end if;

      if (To_String (to_lower (qname)) = "core_units") then
         xml_unit := core_units_xml;
      end if;

      if (To_String (to_lower (qname)) = "processors") then
         xml_unit := processors_xml;
      end if;

      if (To_String (to_lower (qname)) = "address_spaces") then
         xml_unit := address_spaces_xml;
      end if;

      if (To_String (to_lower (qname)) = "buffers") then
         xml_unit := buffers_xml;
      end if;

      if (To_String (to_lower (qname)) = "resources") then
         xml_unit := resources_xml;
      end if;

      if (To_String (to_lower (qname)) = "dependencies") then
         xml_unit := dependencies_xml;
      end if;

      if (To_String (to_lower (qname)) = "networks") then
         xml_unit := networks_xml;
      end if;

      if (To_String (to_lower (qname)) = "messages") then
         xml_unit := messages_xml;
      end if;

      if (To_String (to_lower (qname)) = "event_analyzers") then
         xml_unit := event_analyzers_xml;
      end if;

      if (To_String (to_lower (qname)) = "caches") then
         xml_unit := caches_xml;
      end if;

      if
        (To_String (to_lower (qname)) = "cache_blocks" and
         xml_unit /= caches_xml)
      then
         xml_unit := cache_blocks_xml;
      end if;

      if (To_String (to_lower (qname)) = "cfg_nodes") then
         xml_unit := cfg_nodes_xml;
      end if;

      if (To_String (to_lower (qname)) = "cfg_edges") then
         xml_unit := cfg_edges_xml;
      end if;

      if (To_String (to_lower (qname)) = "cfgs") then
         xml_unit := cfgs_xml;
      end if;

      if (To_String (to_lower (qname)) = "cache_access_profiles") then
         xml_unit := cache_access_profile_xml;
      end if;

      if (To_String (to_lower (qname)) = "ucbs") then
         xml_unit_attribute := ucbs_xml;
      end if;

      if (To_String (to_lower (qname)) = "ecbs") then
         xml_unit_attribute := ecbs_xml;
      end if;

      if (To_String (to_lower (qname)) = "memories") then
         xml_unit := memories_xml;
      end if;

      if (To_String (to_lower (qname)) = "batteries") then
         xml_unit := batteries_xml;
      end if;

      if (To_String (to_lower (qname)) = "scheduling_errors") then
         xml_unit := scheduling_errors_xml;
      end if;

      Start_Element
        (xml_generic_parser (handler),
         nco1,
         namespace_uri,
         local_name,
         qname,
         atts);
      Start_Element
        (xml_generic_parser (handler),
         component_ref,
         component_id,
         namespace_uri,
         local_name,
         qname,
         atts);
      Start_Element
        (xml_generic_parser (handler),
         nco1,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         a_task_list,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         values,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         an_offset,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         a_critical_section_list,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         positions,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         a_task_list,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         roles,
         namespace_uri,
         local_name,
         qname,
         atts);
      Start_Element
        (xml_generic_parser (handler),
         dep1,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         param,
         namespace_uri,
         local_name,
         qname,
         atts);
      start_element
        (xml_generic_parser (handler),
         positions,
         namespace_uri,
         local_name,
         qname,
         atts);

   end start_element;

   procedure end_element
     (handler       : in out xml_architecture_parser;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      period        : Integer;
      task_iterator : generic_task_iterator;
      a_task        : generic_task_ptr;
      use Generic_Task_List_Package;

   begin

      ------------------------------
      -- Parse component attributes
      ------------------------------

      End_Element
        (xml_generic_parser (handler),
         ea1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         sched1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         as1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         co1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         nco1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         mco1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         ta1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         bat1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         ft1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         tg1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         re1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         bu1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         dep1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         no1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         sp1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         bus1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         me1,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         icache_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         dcache_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         cache_block_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         cfg_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         cfg_node_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         cfg_edge_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         basic_block_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         cache_access_profile_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         generic_memory_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         dram_memory_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         kalray_memory_i,
         namespace_uri,
         local_name,
         qname);
      End_Element
        (xml_generic_parser (handler),
         scheduling_error_i,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         index_value,
         namespace_uri,
         local_name,
         qname);
      end_element_values
        (xml_generic_parser (handler),
         a_execution_unit,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         an_offset_type,
         an_offset,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         a_critical_section,
         a_critical_section_list,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         a_position,
         positions,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         a_buffer_role,
         roles,
         namespace_uri,
         local_name,
         qname);
      end_element
        (xml_generic_parser (handler),
         a_param,
         param,
         namespace_uri,
         local_name,
         qname);

      ------------------------------
      -- Parse entities
      ------------------------------

      ----------------------------
      --   Parse event analyzers
      ----------------------------
      if (To_String (to_lower (qname)) = "event_analyzer") then
         add_event_analyzer
           (handler.parsed_system.event_analyzers,
            ea1.name,
            ea1.event_analyzer_source_file_name);
         ea1.cheddar_private_id := component_id;
         set_if_greater (framework_id, component_id);
         initialize (handler);
      end if;

      ----------------------------
      --   Parse networks
      ----------------------------
      if xml_unit = networks_xml then
         if
           (To_String (to_lower (qname)) = "generic_network" or
            To_String (to_lower (qname)) = "bus_network" or
            To_String (to_lower (qname)) = "noc_network")
         then
            put_debug ("Add network " & no1.name & " " & component_id);
            add_network
              (handler.parsed_system.networks,
               network1,
               no1.name,
               no1.network_architecture_type,
               no1.topology,
               no1.link_delay,
               no1.number_of_processor,
               no1.dimension,
               sp1.Xdimension,
               sp1.Ydimension,
               no1.number_of_virtual_channel,
               no1.network_delay,
               no1.switching_protocol,
               no1.routing_protocol,
               positions);
            network1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "spacewire_network") then
            put_debug ("Add network " & sp1.name & " " & component_id);
            add_network
              (handler.parsed_system.networks,
               network1,
               sp1.name,
               sp1.network_architecture_type,
               no1.topology,
               sp1.link_delay,
               sp1.number_of_processor,
               no1.dimension,
               sp1.Xdimension,
               sp1.Ydimension,
               no1.number_of_virtual_channel,
               sp1.network_delay,
               no1.switching_protocol,
               sp1.routing_protocol,
               positions);
            network1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse messages
      ----------------------------
      if (To_String (to_lower (qname)) = "periodic_message") or
        (To_String (to_lower (qname)) = "aperiodic_message")
      then
         put_debug ("Add message " & me1.name & " " & component_id);
         add_message
           (handler.parsed_system.messages,
            message1,
            me1.name,
            me1.size,
            me1.period,
            me1.deadline,
            me1.jitter,
            param,
            me1.response_time,
            me1.communication_time,
            me1.mils_confidentiality_level,
            me1.mils_integrity_level);
         message1.cheddar_private_id := component_id;
         set_if_greater (framework_id, component_id);
         initialize (handler);
      end if;

      ----------------------------
      --   Parse groups of tasks
      ----------------------------
      if (To_String (to_lower (qname)) = "transaction_task_group") or
        (To_String (to_lower (qname)) = "multiframe_task_group")
      then
         put_debug ("Add task group " & tg1.name & " " & component_id);
         add_task_group
           (handler.parsed_system.task_groups,
            task_group1,
            tg1.name,
            tg1.task_group_type,
            tg1.start_time,
            tg1.period,
            tg1.deadline,
            tg1.jitter,
            tg1.priority,
            tg1.criticality);

         task_group1.cheddar_private_id := component_id;
         set_if_greater (framework_id, component_id);

         if not is_empty (a_task_list) then
            reset_head_iterator (a_task_list, task_iterator);

            loop
               current_element (task_group1.task_list, a_task, task_iterator);

               add_task_to_group (task_group1, a_task);

               exit when is_tail_element (a_task_list, task_iterator);
               next_element (a_task_list, task_iterator);
            end loop;
         end if;

         initialize (handler);
      end if;

      ----------------------------
      --   Parse tasks
      ----------------------------
      if (xml_unit = tasks_xml) then

         if (To_String (to_lower (qname)) = "periodic_task") or
           (To_String (to_lower (qname)) = "aperiodic_task") or
           (To_String (to_lower (qname)) = "sporadic_task") or
           (To_String (to_lower (qname)) = "parametric_task") or
           (To_String (to_lower (qname)) = "scheduling_task") or
           (To_String (to_lower (qname)) = "poisson_task") or
           (To_String (to_lower (qname)) = "sporadic_inner_periodic_task") or
           (To_String (to_lower (qname)) = "periodic_inner_periodic_task") or
           (To_String (to_lower (qname)) = "frame_task")
         then
            if (To_String (to_lower (qname)) = "frame_task") then
               period := ft1.interarrival;
            else
               period := ta1.period;
            end if;

            check_entity_location
              (handler.parsed_system,
               ta1.name,
               ta1.cpu_name,
               ta1.address_space_name);
            check_task_affinity
              (handler.parsed_system,
               ta1.name,
               ta1.cpu_name,
               ta1.core_name);

            add_task
              (handler.parsed_system.tasks,
               task1,
               ta1.name,
               ta1.cpu_name,
               ta1.address_space_name,
               ta1.core_name,
               ta1.task_type,
               ta1.start_time,
               ta1.capacity,
               period,
               ta1.deadline,
               ta1.jitter,
               ta1.blocking_time,
               ta1.priority,
               ta1.criticality,
               ta1.policy,
               an_offset,
               ta1.stack_memory_size,
               ta1.text_memory_size,
               param,
               ta1.activation_rule,
               ta1.seed,
               ta1.predictable,
               ta1.context_switch_overhead,
               ta1.every,
               ta1.energy_consumption,
               ta1.cache_access_profile_name,
               ta1.cfg_name,
               ta1.mils_confidentiality_level,
               ta1.mils_integrity_level,
               ta1.mils_component,
               ta1.mils_task,
               ta1.mils_compliant,
               ta1.text_memory_start_address,
               ta1.cfg_relocatable,
               ta1.capacity_model,
               capacity_values,
	       quality_values,
               ta1.completion_time,
               ta1.outer_period,
               ta1.outer_duration);

            put_debug ("Add task " & ta1.name & " " & component_id);

            task1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = task_groups_xml) then
         if (To_String (to_lower (qname)) = "periodic_task") or
           (To_String (to_lower (qname)) = "aperiodic_task") or
           (To_String (to_lower (qname)) = "sporadic_task") or
           (To_String (to_lower (qname)) = "parametric_task") or
           (To_String (to_lower (qname)) = "scheduling_task") or
           (To_String (to_lower (qname)) = "poisson_task") or
           (To_String (to_lower (qname)) = "frame_task")
         then
            put_debug ("Add task ref " & component_ref);
            task1 :=
              generic_task_ptr
                (search_task_by_id
                   (handler.parsed_system.tasks,
                    component_ref));
            add_tail (a_task_list, task1);
         end if;
      end if;

      ----------------------------
      --   Parse buffers
      ----------------------------
      if (To_String (to_lower (qname)) = "buffer") then
         put_debug ("Add buffer " & bu1.name & " " & component_id);
         check_task_buffer_roles
           (handler.parsed_system.tasks,
            bu1.name,
            roles);
         check_entity_location
           (handler.parsed_system,
            bu1.name,
            bu1.cpu_name,
            bu1.address_space_name);
         add_buffer
           (handler.parsed_system.buffers,
            buffer1,
            bu1.name,
            bu1.buffer_size,
            bu1.cpu_name,
            bu1.address_space_name,
            bu1.queueing_system_type,
            roles,
            bu1.buffer_initial_data_size);

         buffer1.cheddar_private_id := component_id;
         set_if_greater (framework_id, component_id);
         initialize (handler);
      end if;

      ----------------------------
      --   Parse resources
      ----------------------------
      if (xml_unit = resources_xml) then
         if (To_String (to_lower (qname)) = "np_resource") or
           (To_String (to_lower (qname)) = "pip_resource") or
           (To_String (to_lower (qname)) = "pcp_resource") or
           (To_String (to_lower (qname)) = "ppcp_resource") or
           (To_String (to_lower (qname)) = "ipcp_resource")
         then
            put_debug ("Add resource " & re1.name & " " & component_id);
            check_task_critical_sections
              (handler.parsed_system,
               re1.name, re1.cpu_name,  re1.protocol,
               a_critical_section_list);
            check_entity_location
              (handler.parsed_system,
               re1.name,
               re1.cpu_name,
               re1.address_space_name);
            add_resource
              (handler.parsed_system.resources,
               resource1,
               re1.name,
               re1.state,
               re1.address,
               re1.size,
               re1.cpu_name,
               re1.address_space_name,
               re1.protocol,
               a_critical_section_list,
               re1.priority,
               re1.priority_assignment);
            resource1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse address spaces
      ----------------------------
      if (To_String (to_lower (qname)) = "address_space") then
         put_debug ("Add address space " & as1.name & " " & component_id);
         check_hierarchical_schedulers
           (handler.parsed_system,
            as1.name,
            as1.cpu_name,
            sched1.scheduler_type);
         add_address_space
           (handler.parsed_system.address_spaces,
            address_space1,
            as1.name,
            as1.cpu_name,
            as1.text_memory_size,
            as1.stack_memory_size,
            as1.data_memory_size,
            as1.heap_memory_size,
            sched1.preemptive_type,
            sched1.quantum,
            sched1.user_defined_scheduler_source_file_name,
            sched1.scheduler_type,
            sched1.automaton_name,
            as1.mils_confidentiality_level,
            as1.mils_integrity_level,
            as1.mils_component,
            as1.mils_partition,
            as1.mils_compliant);
         address_space1.cheddar_private_id := component_id;
         set_if_greater (framework_id, component_id);
         initialize (handler);
      end if;

      ----------------------------
      --   Parse dependencies
      ----------------------------
      if (To_String (to_lower (qname)) = "dependency") then
         put_debug ("Add a dependency " & dep1.type_of_dependency'img);

         case dep1.type_of_dependency is
            when remote_procedure_call_dependency =>
               add_one_task_dependency_remote_procedure_call
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.remote_procedure_call_client),
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.remote_procedure_call_server));
            when precedence_dependency =>
               add_one_task_dependency_precedence
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.precedence_source),
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.precedence_sink));
            when queueing_buffer_dependency =>
               add_one_task_dependency_queueing_buffer
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.buffer_dependent_task),
                  search_buffer_by_id
                    (handler.parsed_system.buffers,
                     dep1.buffer_dependency_object),
                  dep1.buffer_orientation);
            when black_board_buffer_dependency =>
               add_one_task_dependency_black_board_buffer
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.black_board_dependent_task),
                  search_buffer_by_id
                    (handler.parsed_system.buffers,
                     dep1.black_board_dependency_object),
                  dep1.black_board_orientation);
            when asynchronous_communication_dependency =>
               add_one_task_dependency_asynchronous_communication
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.asynchronous_communication_dependent_task),
                  search_message_by_id
                    (handler.parsed_system.messages,
                     dep1.asynchronous_communication_dependency_object),
                  dep1.asynchronous_communication_orientation,
                  dep1.asynchronous_communication_protocol_property);
            when time_triggered_communication_dependency =>
               add_one_task_dependency_time_triggered
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.time_triggered_communication_source),
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.time_triggered_communication_sink),
                  dep1.time_triggered_timing_property);
            when resource_dependency =>
               add_one_task_dependency_resource
                 (handler.parsed_system.dependencies,
                  search_task_by_id
                    (handler.parsed_system.tasks,
                     dep1.resource_dependency_task),
                  search_resource_by_id
                    (handler.parsed_system.resources,
                     dep1.resource_dependency_resource));

         end case;

         initialize (handler);
      end if;

      ----------------------------
      --   Parse caches entities
      ----------------------------
      if
        (xml_unit = cache_access_profile_xml and xml_unit_attribute = ucbs_xml)
      then
         if (To_String (to_lower (qname)) = "cache_block") then
            put_debug
              ("Add cache block ref: " &
               cache_block_i.name &
               " " &
               component_ref);
            cache_block1 :=
              search_cache_block_by_id
                (handler.parsed_system.cache_blocks,
                 component_ref);
            add (ucbs_table, cache_block1);
         end if;
      end if;

      if
        (xml_unit = cache_access_profile_xml and xml_unit_attribute = ecbs_xml)
      then
         if (To_String (to_lower (qname)) = "cache_block") then
            put_debug
              ("Add cache block ref: " &
               cache_block_i.name &
               " " &
               component_ref);
            cache_block1 :=
              search_cache_block_by_id
                (handler.parsed_system.cache_blocks,
                 component_ref);
            add (ecbs_table, cache_block1);
         end if;
      end if;

      if (xml_unit = cache_access_profile_xml) then
         if (To_String (to_lower (qname)) = "cache_access_profile") then
            put_debug
              ("Add cache access profile: " &
               cache_access_profile_i.name &
               " " &
               component_id);
            add_cache_access_profile
              (my_cache_access_profiles =>
                 handler.parsed_system.cache_access_profiles,
               a_cache_access_profile => cache_access_profile1,
               name                   => cache_access_profile_i.name,
               ucbs                   => ucbs_table,
               ecbs                   => ecbs_table);
            cache_access_profile1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = cfg_nodes_xml) then
         if (To_String (to_lower (qname)) = "cfg_node") then
            put_debug ("Add CFG Node " & cfg_node_i.name & " " & component_id);
            add_cfg_node
              (my_cfg_nodes => handler.parsed_system.cfg_nodes,
               a_cfg_node   => cfg_node1,
               name         => cfg_node_i.name,
               node_type    => cfg_node_i.node_type,
               graph_type   => cfg_node_i.graph_type);
            cfg_node1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "basic_block") then
            put_debug
              ("Add Basic Block " & basic_block_i.name & " " & component_id);
            add_cfg_node
              (my_cfg_nodes         => handler.parsed_system.cfg_nodes,
               a_cfg_node           => cfg_node1,
               name                 => basic_block_i.name,
               node_type            => basic_block_i.node_type,
               graph_type           => basic_block_i.graph_type,
               instruction_offset   => basic_block_i.instruction_offset,
               instruction_capacity => basic_block_i.instruction_capacity,
               data_offset          => basic_block_i.data_offset,
               data_capacity        => basic_block_i.data_capacity,
               loop_bound           => basic_block_i.loop_bound);
            cfg_node1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = cfg_edges_xml) then
         if (To_String (to_lower (qname)) = "cfg_edge") then
            put_debug ("Add CFG Edge " & component_id);
            add_cfg_edge
              (my_cfg_edges => handler.parsed_system.cfg_edges,
               a_cfg_edge   => cfg_edge1,
               name         => cfg_edge_i.name,
               node         => cfg_edge_i.node,
               next_node    => cfg_edge_i.next_node);
            cfg_edge1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = cfgs_xml) then
         if (To_String (to_lower (qname)) = "cfg_node") then
            put_debug ("Add CFG Node to CFG " & component_id);
            cfg_node1 :=
              search_cfg_node_by_id
                (my_cfg_nodes => handler.parsed_system.cfg_nodes,
                 id           => component_ref);
            add (a_cfg_nodes_table, cfg_node1);
         end if;

         if (To_String (to_lower (qname)) = "basic_block") then
            put_debug ("Add Basic Block to CFG " & component_id);
            cfg_node1 :=
              search_cfg_node_by_id
                (my_cfg_nodes => handler.parsed_system.cfg_nodes,
                 id           => component_ref);
            add (a_cfg_nodes_table, cfg_node1);
         end if;

         if (To_String (to_lower (qname)) = "cfg_edge") then
            put_debug ("Add CFG Edge to CFG" & component_id);
            cfg_edge1 :=
              search_cfg_edge_by_id
                (my_cfg_edges => handler.parsed_system.cfg_edges,
                 id           => component_ref);
            add (a_cfg_edges_table, cfg_edge1);
         end if;

         if (To_String (to_lower (qname)) = "cfg") then
            put_debug ("Add CFG " & cfg_i.name & " " & component_id);
            add_cfg
              (my_cfgs       => handler.parsed_system.cfgs,
               a_cfg         => cfg1,
               name          => cfg_i.name,
               cfg_nodes_tbl => a_cfg_nodes_table,
               cfg_edges_tbl => a_cfg_edges_table);

            cfg1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = cache_blocks_xml) then
         if (To_String (to_lower (qname)) = "cache_block") then
            add_cache_block
              (my_cache_blocks    => handler.parsed_system.cache_blocks,
               a_cache_block      => cache_block1,
               name               => cache_block_i.name,
               cache_block_number => cache_block_i.cache_block_number);
            cache_block1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      if (xml_unit = caches_xml) then

         if (To_String (to_lower (qname)) = "cache_block") then
            cache_block1 :=
              search_cache_block_by_id
                (handler.parsed_system.cache_blocks,
                 component_ref);
            add (a_cache_blocks_table, cache_block1);
         end if;

         if (To_String (to_lower (qname)) = "instruction_cache") then
            put_debug ("Add cache " & icache_i.name & " " & component_id);
            add_cache
              (my_caches            => handler.parsed_system.caches,
               a_cache              => cache1,
               name                 => icache_i.name,
               cache_size           => icache_i.cache_size,
               line_size            => icache_i.line_size,
               associativity        => icache_i.associativity,
               block_reload_time    => icache_i.block_reload_time,
               coherence_protocol   => icache_i.coherence_protocol,
               replacement_policy   => icache_i.replacement_policy,
               cache_category       => icache_i.cache_category,
               a_cache_blocks_table => a_cache_blocks_table);
            cache1.cache_blocks       := a_cache_blocks_table;
            cache1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "data_cache") then
            put_debug ("Add cache " & dcache_i.name & " " & component_id);
            add_cache
              (my_caches            => handler.parsed_system.caches,
               a_cache              => cache1,
               name                 => dcache_i.name,
               cache_size           => dcache_i.cache_size,
               line_size            => dcache_i.line_size,
               associativity        => dcache_i.associativity,
               block_reload_time    => dcache_i.block_reload_time,
               coherence_protocol   => dcache_i.coherence_protocol,
               replacement_policy   => dcache_i.replacement_policy,
               cache_category       => dcache_i.cache_category,
               a_cache_blocks_table => a_cache_blocks_table);
            cache1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse core units
      ----------------------------
      if (xml_unit = core_units_xml) then
         if
           (To_String (to_lower (qname)) = "generic_memory" or
            To_String (to_lower (qname)) = "dram_memory" or
            To_String (to_lower (qname)) = "kalray_memory")
         then

            put_debug ("Add memory ref " & component_ref);
            memory1 :=
              search_memory_by_id
                (handler.parsed_system.memories,
                 component_ref);
            add (a_memory_table, memory1);
         end if;
         if (To_String (to_lower (qname)) = "core_unit") then
            put_debug ("Add core unit " & co1.name & " " & component_id);
            add_core_unit
              (handler.parsed_system.core_units,
               core_unit_ptr (core1),
               co1.name,
               sched1.preemptive_type,
               sched1.quantum,
               co1.speed,
               sched1.capacity,
               sched1.period,
               sched1.priority,
               sched1.user_defined_scheduler_source_file_name,
               sched1.user_defined_scheduler_protocol_name,
               sched1.scheduler_type,
               a_memory_table,
               sched1.automaton_name,
               co1.l1_cache_system_name,
               sched1.start_time,
               sched1.threshold);
            core1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse processors
      ----------------------------
      if (xml_unit = processors_xml) then
         if (To_String (to_lower (qname)) = "core_unit") then
            put_debug ("Add core unit ref " & component_ref);
            core1 :=
              search_core_unit_by_id
                (handler.parsed_system.core_units,
                 component_ref);
            add (a_core_unit_table, core_unit_ptr (core1));
         end if;

         if (To_String (to_lower (qname)) = "mono_core_processor") then

            -- Find corresponding core unit
            --
            put_debug
              ("Add monocore processor " & nco1.name & " " & component_id);
            core1 :=
              search_core_unit_by_id
                (handler.parsed_system.core_units,
                 nco1.core);
            add_processor
              (handler.parsed_system.processors,
               processor1,
               nco1.name,
               core_unit_ptr (core1));
            processor1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "multi_cores_processor") then
            put_debug
              ("Add multicore processor " & mco1.name & " " & component_id);
            add_processor
              (handler.parsed_system.processors,
               processor1,
               mco1.name,
               a_core_unit_table,
               mco1.migration_type,
               mco1.processor_type);
            processor1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse batteries
      ----------------------------
      if (xml_unit = batteries_xml) then

         if (To_String (to_lower (qname)) = "battery") then
            put_debug ("Add battery " & bat1.name & " " & component_id);
            add_battery
              (handler.parsed_system.batteries,
               battery1,
               bat1.name,
               bat1.cpu_name,
               bat1.capacity,
               bat1.e_max,
               bat1.e_min,
               bat1.initial_energy,
               bat1.rechargeable_power);
            battery1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

      end if;

      ----------------------------
      --   Parse memories
      ----------------------------
      if (xml_unit = memories_xml) then

         if (To_String (to_lower (qname)) = "generic_memory") then
            put_debug
              ("Add generic memory " &
               generic_memory_i.name &
               " " &
               component_id);
            mem_rec.size            := generic_memory_i.size;
            mem_rec.access_latency  := generic_memory_i.access_latency;
            mem_rec.memory_category := generic_memory_i.memory_category;

            add_memory
              (my_memories     => handler.parsed_system.memories,
               a_memory        => memory1,
               name            => generic_memory_i.name,
               a_memory_record => mem_rec);
            memory1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "dram_memory") then
            put_debug
              ("Add dram memory " &
               generic_memory_i.name &
               " " &
               component_id);
            mem_rec.size                  := dram_memory_i.size;
            mem_rec.access_latency        := dram_memory_i.access_latency;
            mem_rec.memory_category       := dram_memory_i.memory_category;
            mem_rec.shared_access_latency :=
              dram_memory_i.shared_access_latency;
            mem_rec.private_access_latency :=
              dram_memory_i.private_access_latency;
            mem_rec.l_act_inter := dram_memory_i.l_act_inter;
            mem_rec.l_rw_inter  := dram_memory_i.l_rw_inter;
            mem_rec.l_pre_inter := dram_memory_i.l_pre_inter;
            mem_rec.l_conf      := dram_memory_i.l_conf;
            mem_rec.n_reorder   := dram_memory_i.n_reorder;
            mem_rec.l_conhit    := dram_memory_i.l_conhit;

            add_memory
              (my_memories     => handler.parsed_system.memories,
               a_memory        => memory1,
               name            => dram_memory_i.name,
               a_memory_record => mem_rec);

            memory1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

         if (To_String (to_lower (qname)) = "kalray_memory") then
            put_debug
              ("Add kalray memory " &
               generic_memory_i.name &
               " " &
               component_id);
            mem_rec.size            := kalray_memory_i.size;
            mem_rec.access_latency  := kalray_memory_i.access_latency;
            mem_rec.memory_category := kalray_memory_i.memory_category;
            mem_rec.nb_bank         := kalray_memory_i.nb_bank;
            mem_rec.partition_mode  := kalray_memory_i.partition_mode;

            add_memory
              (my_memories     => handler.parsed_system.memories,
               a_memory        => memory1,
               name            => kalray_memory_i.name,
               a_memory_record => mem_rec);

            memory1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;
      end if;

      ----------------------------
      --   Parse scheduling_errors
      ----------------------------
      if (xml_unit = scheduling_errors_xml) then

         if (To_String (to_lower (qname)) = "scheduling_error") then
            put_debug
              ("Add scheduling error " &
               scheduling_error_i.name &
               " " &
               component_id);
            scheduling_error_rec.error_type   := scheduling_error_i.error_type;
            scheduling_error_rec.time         := scheduling_error_i.time;
            scheduling_error_rec.error_action :=
              scheduling_error_i.error_action;
            scheduling_error_rec.user_defined_action :=
              scheduling_error_i.user_defined_action;

            add_scheduling_error
              (my_scheduling_errors => handler.parsed_system.scheduling_errors,
               a_scheduling_error        => scheduling_error1,
               name                      => scheduling_error_i.name,
               a_scheduling_error_record => scheduling_error_rec);

            scheduling_error1.cheddar_private_id := component_id;
            set_if_greater (framework_id, component_id);
            initialize (handler);
         end if;

      end if;

   end end_element;

   function get_parsed_system
     (handler : in xml_architecture_parser) return system
   is
   begin
      return handler.parsed_system;
   end get_parsed_system;

end xml_generic_parsers.architecture;
