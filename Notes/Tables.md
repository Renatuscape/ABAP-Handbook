### Remove duplicate rows
```ABAP
SORT lt_table BY field1 field2.
DELETE ADJACENT DUPLICATES FROM lt_table COMPARING field1 field2.
```