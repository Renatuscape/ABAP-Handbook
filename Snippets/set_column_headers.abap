*---------------------------------------------------------------------*
* Form set_column_headers
*---------------------------------------------------------------------*
* Subroutine for giving custom names to headers in a salv table.
* Assumes the salv object is called go_alv
*---------------------------------------------------------------------*

FORM set_column_headers.

    DATA: lo_column TYPE REF TO cl_salv_column.

    TRY.
        " Example custom header for short, medium, and long text
        lo_column = go_alv->getcolumns( )->get_column( 'PERNR' ).
        lo_column->set_short_text( 'Anum' ).
        lo_column->set_medium_text( 'Ansatt' ).
        lo_column->set_long_text( 'Ansattnummer' ).

    CATCH cx_salv_not_found.
        " Column not found - set error message
    ENDTRY.

ENDFORM.s