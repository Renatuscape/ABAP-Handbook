# Preparing a HTML template in ABAP
Whether you are building a Web Application or an email, you are likely to need to compose an HTML layout within your ABAP code at some point.

## Tips
Like with any code, you should never have to repeat yourself. Identify what parts of the layout and contents that needs to be modular, and create variables.

In the case of sending an email, you will likely wish the receiver's name and some key information to be dynamic. By creating a form that accepts import parameters, you can avoid repeating yourself.

Another use-case could be a component in a web application that should be rendered differently when viewed by users with different roles. Check the role, populate your variables accordingly, then build the HTML layout using your variables.

```ABAP
IF lv_role EQ 'R_MNGR'.
    lv_display_title = '(Manager)'.
ELSE.
    lv_display_title = '(Corowker)'.
ENDIF.

CONCATENATE
    '<p>'
    'Hello'
    ` ` "Backticks preserve space
    lv_display_name
    ` `
    lv_display_title
    '</p>'
        INTO ls_layout-line.
```

This suffers the same issues as regular string concatenation. In strings where leading/trailing commas or spaces are required, consider using string templates for ease of use and readability.