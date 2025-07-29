### Remove duplicate rows
```ABAP
SORT lt_table BY field1 field2.
DELETE ADJACENT DUPLICATES FROM lt_table COMPARING field1 field2.
```

### Check if line exists
Modern ABAP syntax.

```ABAP
IF line_Exists( lt_target_table[ variable = lv_value ] ).
    " Do something
ENDIF.
```