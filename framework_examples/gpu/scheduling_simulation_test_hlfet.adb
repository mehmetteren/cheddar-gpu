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
------------------------------------------------------------------------------
-- Last update :
--    $Date$
--    $Author: Dridi $
------------------------------------------------------------------------------
------------------------------------------------------------------------------


with Text_IO;                           use Text_IO;
with Processor_Set;                     use Processor_Set;
use Processor_Set.Generic_Processor_Set;
with Ada.Strings.Unbounded;             use Ada.Strings.Unbounded;
with unbounded_strings;                 use unbounded_strings;
use unbounded_strings.strings_table_package;
use unbounded_strings.unbounded_string_list_package;
with Parameters;                        use Parameters;
with Parameters.extended;               use Parameters.extended;
use Parameters.Framework_Parameters_Table_Package;
with Task_Set;                          use Task_Set;
use Task_Set.Generic_Task_Set;
with Systems;                           use Systems;
with Call_Framework;                    use Call_Framework;
with Call_Framework_Interface;          use Call_Framework_Interface;
use Call_Framework_Interface.Framework_Response_Package;
use Call_Framework_Interface.Framework_Request_Package;
with framework;                         use framework;
with Call_Scheduling_Framework;         use Call_Scheduling_Framework;
with Multiprocessor_Services;           use Multiprocessor_Services;
with Multiprocessor_Services_Interface; use Multiprocessor_Services_Interface;
use Multiprocessor_Services_Interface.Scheduling_Result_Per_Processor_Package;
with GNAT.Command_Line;
with GNAT.OS_Lib;                       use GNAT.OS_Lib;
with Version;                           use Version;
with Ada.Exceptions;                    use Ada.Exceptions;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; 		use Ada.Text_IO.Unbounded_IO;
with sets;
with Tasks;			use Tasks;
with Task_Set;                  use Task_Set;
with Message_Set ; use Message_Set ; 
with Messages; use Messages ; 


package body scheduling_simulation_test_hlfet is 

procedure compute_scheduling_of_tasks
     (Period 		: in Natural;
      Sys 		: in out System;
      Output_File_Name 	: in Unbounded_String;
      Export_Data 	: in Boolean := FALSE --;
      --Result 		: out Natural
      ) 

   is

       Response_List : Framework_Response_Table;
       Request_List  : Framework_Request_Table;
       A_Request     : Framework_Request;
       A_Param       : Parameter_Ptr;
       dir1          : unbounded_string_list;

   begin

	Call_Framework.initialize (False);

	--initialize(Sys);
        --Read_From_Xml_File (Sys, dir1, "framework_examples/transformation_algo_for_spw/output_Model.xmlv3" );
        


	Initialize (Response_List);
	Initialize (Request_List);
	Initialize (A_Request);
	A_Request.statement    := Scheduling_Simulation_Time_Line;
	A_Param                := new Parameter (Integer_Parameter);
	A_Param.parameter_name := To_Unbounded_String ("period");
	A_Param.integer_value  := Period;
	Add (A_Request.param, A_Param);
	A_Param                := new Parameter (Boolean_Parameter);
	A_Param.parameter_name := To_Unbounded_String ("schedule_with_offsets");
	A_Param.boolean_value  := True;
	Add (A_Request.param, A_Param);
	A_Param                := new Parameter (Boolean_Parameter);
	A_Param.parameter_name := To_Unbounded_String ("schedule_with_precedencies");
	A_Param.boolean_value  := True;
	Add (A_Request.param, A_Param);
	A_Param                := new Parameter (Boolean_Parameter);
	A_Param.parameter_name := To_Unbounded_String ("schedule_with_resources");
	A_Param.boolean_value  := True;
	Add (A_Request.param, A_Param);
	A_Param                := new Parameter (Integer_Parameter);
	A_Param.parameter_name := To_Unbounded_String ("seed_value");
	A_Param.integer_value  := 0;
	Add (A_Request.param, A_Param);
	Add (Request_List, A_Request);
	Sequential_Framework_Request (Sys, Request_List, Response_List);


	initialize (Request_List);
	initialize (Response_List);
	Initialize (A_Request);
	A_Request.statement := Scheduling_Simulation_Basics;
	Add (A_Request.param, A_Param);
	add (Request_List, A_Request);
	Sequential_Framework_Request (Sys, Request_List, Response_List);


	Put_Line("Simulation Complete.");
	Put_Line("Nb Response:" & Response_List.Nb_Entries'Img);	

	Put_Line (To_String (Response_List.Entries (0).title));
	for J in 0 .. Response_List.Nb_Entries - 1 loop
	 	Put_Line (To_String (Response_List.Entries (J).text));
	end loop;



    end compute_scheduling_of_tasks;




    procedure display_system (	System2  	: in System 
	)
    is 
 
       	My_Iterator1    : Tasks_Iterator	;
        My_Iterator2    : Messages_iterator	;

        a_task          : Generic_Task_Ptr	;
        a_message       : Generic_Message_Ptr	;

        my_tasks	: Tasks_set    		; 
	my_messages	: Messages_Set 		;

    begin 


      my_tasks  	:= System2.tasks 	; 
      my_messages 	:= System2.messages 	; 
    --my_processors  	:= System2.Processors 	;


      put_line ("   " ) ; 
      put_line ("   " ) ; 
      put_line ("   liste des processeurs   :   " ) ; 

		------------------------------------
		------ DISPLAY PROCESSORS  ---------
		------------------------------------







      put_line ("   " ) ; 
      put_line ("   " ) ; 
      put_line ("   liste des tâches   :   " ) ; 

		------------------------------------
		------ DISPLAY TASKS	------------
		------------------------------------

     if not is_empty (my_tasks) then
        reset_iterator (my_tasks, My_Iterator1);
	loop
            current_element  (my_tasks, a_task,     My_Iterator1);
  	    put(To_String(a_task.name));
	    put("  /  ") ; 
  	    put(To_String(a_task.cpu_name));
	    put("||| ") ; 
	    exit when is_last_element       (my_tasks, My_Iterator1);
  	    next_element (my_tasks, My_Iterator1);
	
	end loop ; 
     end if ;     


      put_line ("   " ) ; 
      put_line ("   " ) ; 
      put_line ("   liste des messages   :   " ) ; 

		------------------------------------
		------ DISPLAY MESSAGES	------------
		------------------------------------

     if not is_empty (my_messages) then
        reset_iterator (my_messages, My_Iterator2);
	loop
            current_element  (my_messages, a_message,     My_Iterator2);
  	    put(To_String(a_message.name));

	    exit when is_last_element       (my_messages, My_Iterator2);
  	    next_element (my_messages, My_Iterator2);
	
	end loop ; 
     end if ;     
     


      put_line ("   " ) ; 
      put_line ("   " ) ; 
      put_line ("   liste des dependency   :   " ) ; 


		------------------------------------
		------ DISPLAY Dependency  ---------
		------------------------------------







    end display_system ; 
  
 end scheduling_simulation_test_hlfet ; 



