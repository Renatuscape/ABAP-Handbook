## Tables
Tables are ABAP's equivalent to lists.

*Database tables* are persistent data stored in the database.

*Internal tables* are temporary data structures in memory.

### Internal tables
Internal tables come in three flavors:

* Standard tables - like arrays, accessed by index, can have duplicates
* Sorted tables - kept in sorted order, accessed by index or key
* Hashed tables - like hash maps, accessed only by key, very fast lookups

Internal tables can be looped through and accessed by index or key.

## Database tables
They exist on the SAP database (HANA, Oracle, etc)

* Persistent (survive program end, system restart)
* Shared across all users/programs
* Need SQL statements (SELECT, INSERT, UPDATE, DELETE)
* Can be huge (millions of records)

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