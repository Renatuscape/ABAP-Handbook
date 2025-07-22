*--------------------------------------------------------------------*
* Display SALV - with selection and event handling
*--------------------------------------------------------------------*
FORM display_salv USING l_displaytable TYPE any.
  DATA:
    lo_salv  TYPE REF TO cl_salv_table,
    lo_events TYPE REF TO cl_salv_events,
    lo_handler TYPE REF TO lcl_event_handler,
    gx_error TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lo_salv
        CHANGING
          t_table = l_displaytable ).

      " Hent standard SALV funksjonalitet
      DATA(lo_functions) = lo_salv->get_functions( ).
      lo_functions->set_all( ).

      " Legg til flervalgsfunksjonalitet
      go_selections = lo_salv->get_selections( ).
      go_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

      " Optimaliser kolonnebredde
      DATA(lo_columns) = lo_salv->get_columns( ).
      lo_columns->set_optimize( gc_x ).

      " Add status buttons. The status must be active in hierarchy (not blue) 
      " Status must be combined with event handling
      lo_salv->set_screen_status(
      pfstatus = 'STANDARD'  " Use standard (copy from function group SALV GUI Status) or replace with own
      report =  sy-repid
      set_functions = lo_salv->c_functions_all ).

      " Set up event handler
      CREATE OBJECT lo_handler.
      lo_events = lo_salv->get_event( ).
      SET HANDLER lo_handler->on_user_command FOR lo_events.

      " Vis SALV
      lo_salv->display( ).
    CATCH cx_salv_msg INTO gx_error.
      MESSAGE gx_error->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.

*--------------------------------------------------------------------*
* Additional code for event handling (if needed)
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Class definition - for event handling
*   - Place after data declarations, before main
*--------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITIONS.
  PUBLIC SECTION.
    METHODS: on_user_command FOR EVENT added_function OF cl_salv_events
      IMPORTING e_salv_function.
  ENDCLASS.

*--------------------------------------------------------------------*
* Event handler class implementation
*   - Place with subroutines/subforms, after main
*--------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_user_command.

    CASE e_salv_function.
      WHEN 'UPDATE'.  " Refers to a GUI Status button. Add as necessary
        PERFORM update_status.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.