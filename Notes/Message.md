### Message

#### String formatting
For messages that include variables, without having to use message classes.

```ABAP
DATA: lv_message TYPE string.
lv_message = |Employee { lv_pernr } ({ lv_name }) has been processed|.
MESSAGE lv_message TYPE 'I'.
```