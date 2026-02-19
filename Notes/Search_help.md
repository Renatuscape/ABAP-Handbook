# Search Help
You can create your own search help for input fields.

### Parameters
The input parameter must be specified before the main bulk of the program.

```ABAP
PARAMETERS:
    p_postxt TYPE t285t-plstx. " Short text from table with positions
```

### Run form
The form that builds and triggers your search help functionality must be triggered before main. This code block will run when the search help button for the field is clicked at the selection screen. This should be placed after PARAMETERS, but before START-OF-SELECTION.

```ABAP
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_postxt.
    PERFORM f4_for_positiontxt.
```

## Building and executing search help
In a separate FORM, you build the list of options that will be available in your search help window.


### Reading screen value
The user is not unlikely to write something in the search field before pressing the search help button, in which case you will want to take their search text into account. If your form is executed before screen values have been read, you may need to do so manually.

You may wish to declare the dynpread table and structure at the top of your program if you are collecting multiple screen values at the same time. DYNP_VALUES_READ must be called somewhere before your search help code, inside or outside the form that builds your search help.

```ABAP
DATA:   ls_dynpfields   TYPE dynpread,
        lt_dynpfields   TYPE TABLE OF dynpread.

CLEAR:  " If more fields are being read
    lt_dynpfields,
    ls_dynpfields. 

ls_dynpfields-fieldname = 'p_postxt'. " The field to be read
APPEND ls_dynpfields TO lt_dynpfields.

CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
        dyname      = sy-repid
        dynumb      = sy-dynnr
    TABLES
        dynpfields  = lt_dynpfields
    EXCEPTIONS
        OTHERS      = 1.

IF sy-subrc EQ 0.
    READ TABLE lt_dynpfields INTO ls_dynpfields INDEX 1.
    IF sy-sybrc EQ 0.
        p-soktxt = ls_dynpfields-fieldvalue. " Set the parameter field to the read value
    ENDIF.
ENDIF.
```

### Search help
Building the search help consists of two parts. First, building a tables of the values available in your search, then passing those values to the function module F4IF_INT_TABLE_VALUE_REQUEST. Any table can be used for this, as long as the function module is passed the correct values. For this example, the list will be populated with positions from the t528t table.

```ABAP
* Find positions
SELECT * FROM t528t INTO CORRESPONDING FIELDS OF TABLE lt_t528t
    WHERE sprsl EQ sy-langu
        AND otype EQ 'S'
        AND begda LE sy-datum
        AND endda GE sy-datum.

* Add further filtering using p_postxt if it is not initial
```

All fields from the database table will be displayed in the search help window, and will appear as parameters that can be used in the search. You can move your values to a custom type, even a locally declared type, and pass that to the funtion module without fields that are superfluous for the search.

```ABAP
DATA: lt_return TYPE TABLE OF ddshretval.

* Display the value help popup

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
        ddic_structure  = 't528t'       " This can be left blank ('')
        retfield        = 'PLSTX'       " Match the type of your in-parameter
        dynprog         = sy-repid
        dynpnr          = sy-dynnr
        dynprofield     = 'p_postxt'    " Name of your in-parameter
        value_org       = 'S'           " Source. Internal table
    TABLES
        value_tab       = lt_t528t      " Your list of values
        return_tab      = lt_return     " The values chosen by the user
    EXCEPTIONS
        OTHERS          = 1.
```

Note that ddic_structure should either be blank, or it should match the type of the table passed to value_tab. The export parameter value_org needs to reflect the value_tab.

* S - Source = internal table
* M - Memory = from SAP memory or a globally shared memory-ID
* D - Dictionary = generates values from a DDIC structure or standard value-help definition
* C - Custom = indicates a value-help-exit, and does not exist in all systems

Once the search help pop-up has been closed, return_tab will populate the table with the user's choice (initial if no choice was made). The table passed to return_tab must be of the ddshretval type, and will hold the contents of the choice in ddshretval-fieldval. This choice will populate the in-parameter passed to dynprofield (p_postxt in this example).