*--------------------------------------------------------------------*
* Display SALV
*--------------------------------------------------------------------*
FORM display_salv USING l_displaytable TYPE any.
  DATA:
    lo_salv  TYPE REF TO cl_salv_table,
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

      " Optimaliser kolonnebredde
      DATA(lo_columns) = lo_salv->get_columns( ).
      lo_columns->set_optimize( gc_x ).

      " Vis SALV
      lo_salv->display( ).
    CATCH cx_salv_msg INTO gx_error.
      MESSAGE gx_error->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.