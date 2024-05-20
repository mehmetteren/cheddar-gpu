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

------------------------------------------------------------------------------
with Sax.Exceptions;
with Sax.Locators;
with Sax.Readers;
with Sax.Attributes;
with Unicode.CES;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package xml_generic_parsers is

   ----------------------------------------------------------------------------
   ----------------    Mandatory code for all XML parser of Cheddar
   ----------------------------------------------------------------------------

   -- Exception raised by clients of Xml_Parses when something goes
   -- wrong during XML parsing
   --
   xml_read_error : exception;

   -- Types and constants to parser multiple values between tags
   --
   max_xml_tag_parameters : constant Natural := 10000;
   type parameter_list_type is
     array (1 .. max_xml_tag_parameters) of Unbounded_String;

   -- Generic XML parser
   --
   type xml_generic_parser is new Sax.Readers.reader with record

      -- Parser locator
      --
      locator : Sax.Locators.locator;

      -- Store values between each tag
      --
      current_parameter : Integer;
      parameter_list    : parameter_list_type;

      -- Variable for type conversion
      --
      ok : Boolean;

   end record;

   -- Methods for all Cheddar XML parsers
   --
   procedure characters
     (handler : in out xml_generic_parser;
      ch      :        Unicode.CES.byte_sequence);
   procedure error
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class);
   procedure fatal_error
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class);
   procedure warning
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class);

   -- Method to parse Index value
   --
   procedure end_element
     (handler       : in out xml_generic_parser;
      val           : in out Unbounded_String;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "");
   procedure end_element
     (handler       : in out xml_generic_parser;
      val           : in out Integer;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "");

end xml_generic_parsers;
