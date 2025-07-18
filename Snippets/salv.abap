*--------------------------------------------------------------------*
* Display SALV - with selection
*--------------------------------------------------------------------*
FORM display_salv USING l_displaytable TYPE any.
  DATA:
    lo_salv  TYPE REF TO cl_salv_table,
    " lo_events TYPE REF TO cl_salv_events,
    " lo_handler TYPE REF TO lcl_event_handler,
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
*      go_selections = lo_salv->get_selections( ).
*      go_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

      " Optimaliser kolonnebredde
      DATA(lo_columns) = lo_salv->get_columns( ).
      lo_columns->set_optimize( gc_x ).

      " Legg til statusknapper. STATUS må være aktiv for å unngå runtime error
      lo_salv->set_screen_status(
      pfstatus = 'STANDARD'
      report =  sy-repid
      set_functions = lo_salv->c_functions_all ).

      " Set up event handler
*      CREATE OBJECT lo_handler.
*      lo_events = lo_salv->get_event( ).
*      SET HANDLER lo_handler->on_user_command FOR lo_events.

      " Vis SALV
      lo_salv->display( ).
    CATCH cx_salv_msg INTO gx_error.
      MESSAGE gx_error->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.