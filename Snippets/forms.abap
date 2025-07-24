* Subforms are placed below the program's main body, usually declared with a "Subforms" or "Subroutines" header.
* Forms are similar to functions (not part of a class), and can have in parameters (USING) and in/out parameters (CHANGING).
* Forms are called using the PERFORM keyword, and must match the form's signature

*--------------------------------------------------------------------------------------------
* Main
*--------------------------------------------------------------------------------------------

* Calling form without parameters
PERFORM simple_form.

* Calling form with parameters (types are not specified)
PERFORM parameter_form USING lt_table CHANGING ls_structure.

* Calling with multiple USING parameters
PERFORM multiple_parameters USING lt_table ls_structure lo_object.

*--------------------------------------------------------------------------------------------
* Subforms
*--------------------------------------------------------------------------------------------
FORM parameter_form USING lt_table TYPE tt_table CHANGING ls_structure TYPE ts_structure.
    " lt_table can be read, not changed
    LOOP AT lt_table INTO DATA(ls_temp).
        IF ls_temp-var1 EQ ls_structure-var1.
            " ls_structure can be changed
            ls_structure-var2 = ls_temp-var2.
            EXIT.
        ENDIF.
    ENDLOOP.

ENDFORM.

* Forms can have multiple USING or CHANGING parameters. They are not separated by commas or keywords.
FORM multiple_parameters
    USING lt_table TYPE tt_table ls_structure TYPE ts_structure lo_object TYPE objec_t.

ENDFORM.


*--------------------------------------------------------------------------------------------
* Forms and types
*--------------------------------------------------------------------------------------------
* Forms do NOT accept TYPE TABLE OF. Instead, declare the type beforehand
*--------------------------------------------------------------------------------------------

TYPES:
    BEGIN OF ts_structure
        var1 TYPE c,
        var2 TYPE i,
        var3 TYPE pernr,
    END OF ts_structure,
    tt_table TYPE TABLE OF ts_structure.

FORM name_of_form CHANGING lt_table TYPE tt_table.

* Change lt_table

ENDFORM.