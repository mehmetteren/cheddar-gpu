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
with Ada.Strings.Maps;      use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Sax.Readers;           use Sax.Readers;
with Sax.Exceptions;        use Sax.Exceptions;
with Sax.Locators;          use Sax.Locators;
with Sax.Attributes;        use Sax.Attributes;
with Unicode.CES;           use Unicode.CES;
with Unicode;               use Unicode;

with Doubles;               use Doubles;
with strings;               use strings;
with unbounded_strings;     use unbounded_strings;
with debug;                 use debug;

package body xml_generic_parsers is

   procedure characters
     (handler : in out xml_generic_parser;
      ch      :        Unicode.CES.byte_sequence)
   is

      -- A pair of index objects to keep track of the beginning and
      -- ending of the tokens isolated from the string
      --
      first            : Natural;
      last             : Positive;
      index            : Positive;
      find_first_space : Boolean;

      -- A character set consisting of the "whitespace" characters
      -- that separate the tokens:
      --
      whitespace : constant Ada.Strings.Maps.Character_Set :=
        Ada.Strings.Maps.To_Set (" ");

      -- The string to split
      --
      the_line : Unbounded_String;

   begin

      -- suppress extra blank and unprintable characters before splitting
      --parameters
      --
      find_first_space := False;
      index            := ch'first;
      while index <= ch'last loop

         if (ch (index) /= ASCII.CR) and
           (ch (index) /= ASCII.LF) and
           (ch (index) /= ASCII.HT)
         then
            if (ch (index) = ' ') then
               if (not find_first_space) then
                  the_line := the_line & ch (index);
               end if;
               find_first_space := True;
            else
               the_line         := the_line & ch (index);
               find_first_space := False;
            end if;
         end if;

         index := index + 1;
      end loop;

      -- Remove blank in the beginnning/end of the string
      --
      if Slice (the_line, 1, 1) = " " then
         the_line :=
           To_Unbounded_String (Slice (the_line, 2, Length (the_line)));
      end if;
      if Slice (the_line, Length (the_line), Length (the_line)) = " " then
         the_line :=
           To_Unbounded_String (Slice (the_line, 1, Length (the_line) - 1));
      end if;

      -- XML tag without parameter
      --
      if the_line = empty_string then
         handler.parameter_list (1) := empty_string;
         return;
      end if;

      -- Split parameters
      --

      loop
         Find_Token
           (the_line,
            Set   => whitespace,
            Test  => Ada.Strings.Outside,
            First => first,
            Last  => last);

         handler.parameter_list (handler.current_parameter) :=
           To_Unbounded_String (Slice (the_line, first, last));
         handler.current_parameter := handler.current_parameter + 1;

         the_line :=
           To_Unbounded_String (Slice (the_line, last + 1, Length (the_line)));

         exit when Length (the_line) = 0;

      end loop;

   end characters;

   procedure warning
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class)
   is
   begin
      put_debug
        ("Xml parser warning (" &
         Get_Message (except) &
         ", at " &
         To_String (Get_Location (except)) &
         ')');
   end warning;

   procedure error
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class)
   is
   begin
      put_debug
        ("Xml parser warning (" &
         Get_Message (except) &
         ", at " &
         To_String (Get_Location (except)) &
         ')');
   end error;

   procedure fatal_error
     (handler : in out xml_generic_parser;
      except  :        Sax.Exceptions.sax_parse_exception'class)
   is
   begin
      Put_Line ("Xml parser fatal error (" & Get_Message (except) & ')');
      Fatal_Error (reader (handler), except);
   end fatal_error;

   -- Index value
   --
   procedure end_element
     (handler       : in out xml_generic_parser;
      val           : in out Unbounded_String;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

   begin
      if (To_String (to_lower (qname)) = "index") or
        (To_String (to_lower (qname)) = "time_unit") or
        (To_String (to_lower (qname)) = "processor_name") or
        (To_String (to_lower (qname)) = "task_name")
      then
         val := handler.parameter_list (1);
      end if;
   end end_element;

   procedure end_element
     (handler       : in out xml_generic_parser;
      val           : in out Integer;
      namespace_uri :        Unicode.CES.byte_sequence := "";
      local_name    :        Unicode.CES.byte_sequence := "";
      qname         :        Unicode.CES.byte_sequence := "")
   is

      val_string : Unbounded_String;
      ok         : Boolean;

   begin
      if (To_String (to_lower (qname)) = "index") or
        (To_String (to_lower (qname)) = "time_unit") or
        (To_String (to_lower (qname)) = "processor_name") or
        (To_String (to_lower (qname)) = "task_name")
      then
         val_string := handler.parameter_list (1);
         to_integer (val_string, val, ok);
         if not ok then
            Put_Line
              ("Warning : Error on data type. From " &
               To_String (handler.locator));
         end if;
      end if;
   end end_element;

end xml_generic_parsers;
