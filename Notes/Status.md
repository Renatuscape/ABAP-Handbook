## Status customisation

### SALV status options
1. Open Repository Browser
2. Choose 'Function Group' from dropdown
    * Subcategory SALV, ([Return] to confirm)
3. Navigate into GUI Status folder
4. Right-click STANDARD and 'Copy...'
    * Keep the status name 'STANDARD', input your program as the 'to Program'
5. Return to Development Object your program (click the Function Group button again) and activate the status

Statuses shown in blue text are inactive. Right-click the status and choose change to add your custom options.
Copying the standard status gives you a variety of filtering options and other built-in options for the displayed SALV table.

In order for the status options to appear, this code must run before [SALV object]->display( ) is called.
```ABAP
[SALV object]->set_screen_status(
    pfstatus = 'STANDARD'
    report = sy_repid
    set_functions = [SALV object]->c_functions_all ).
```