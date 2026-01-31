## String Operations

Declaration
```ABAP
DATA:
    lv_a TYPE string,
    lv_b TYPE string,
    lv_c TYPE string.
```

Defintion
```ABAP
 lv_a = 'Hello'.
 lv_b = 'World'.
```
### Concatenation
Allows you to combine two or more string variables into one variable. 
```ABAP
CONCATENATE
    lv_a
    lv_b
        INTO lv_c.
```
Results in 'HelloWorld' being stored in lv_c.

### Substring
Accessing a portion of the string.
```ABAP
lv_a = lv_c +5.
```
Results in lv_a containing everything from lv_c from index 5 ('World').