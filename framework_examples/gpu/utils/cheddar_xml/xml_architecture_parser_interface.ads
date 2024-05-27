
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--  This source file was automatically generated by Platypus
--  see http://dossen.univ-brest.fr/apl
-- 
--  Any modification of this file will be lost. 
--  Please see the "platypus" directory instead : it contains the Cheddar's
--  model and its meta-model. 
------------------------------------------------------------------------------
 
------------------------------------------------------------------------------
-- Cheddar is a free real time scheduling tool.
-- This program provides services to automatically check temporal constraints
-- of real time tasks.
--
-- Copyright (C) 2002-2014   Frank Singhoff
-- Cheddar is developed by the LAB-STICC Team, University of Brest
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
-- 	To post to this mailing list, you must be subscribed
-- 	(see http//beru.univ-brest.fr/~singhoff/cheddar for details)
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with Framework_Config;
use Framework_Config;

with id_generators;
use id_generators;

with Convert_Strings;

with Convert_Unbounded_Strings;

with text_io;
use text_io;



Package Xml_Architecture_Parser_Interface is 
 
type XML_Units is (
	batteries_xml,
	core_units_xml,
	address_spaces_xml,
	processors_xml,
	memories_xml,
	buffers_xml,
	resources_xml,
	dependencies_xml,
	networks_xml,
	messages_xml,
	tasks_xml,
	task_groups_xml,
	deployments_xml,
	resource_entities_xml,
	consumer_entities_xml,
	event_analyzers_xml,
	caches_xml,
	cache_blocks_xml,
	cfgs_xml,
	cfg_nodes_xml,
	cfg_edges_xml,
	basic_blocks_xml,
	cache_access_profile_xml,
	ucbs_xml,
	ecbs_xml,
	scheduling_errors_xml);

procedure To_XML_Units is
new Convert_Strings(XML_Units, batteries_xml);
procedure To_XML_Units is
new Convert_Unbounded_Strings(XML_Units, batteries_xml);
function XML_String (obj : in XML_Units) return Unbounded_String;
function XML_Ref_String (obj : in XML_Units) return Unbounded_String;
package XML_Units_io is new text_io.enumeration_io(XML_Units);
use XML_Units_io;



End Xml_Architecture_Parser_Interface;