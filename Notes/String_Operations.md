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

ABAP will generally delete trailing and leading commas and spaces unless told otherwise.

In modern ABAP (7.40+), && can be used to create spaces.
```ABAP
CONCATENATE lv_a && lv_b && 'value.' INTO lv_c.
```

Backtick can also be used to preserve spaces.
```ABAP
CONCATENATE lv_a ` ` lv_b ` ` 'value.' INTO lv_c.
```

Alternately

```ABAP
CONCATENATE
    lv_a
    lv_b
        INTO lv_c
        SEPARATED BY space
        RESPECTING BLANKS.
```

But many of these will still strugglle with leading or trailing commas and blanks. This can be solved with string templates.

### String Templates
The easiest way of combining variables and text into one string.

```ABAP
lv_string = |Hello, { lv_username }. Please respond by { lv_date }.|.
```

### Substring
Accessing a portion of the string.
```ABAP
lv_a = lv_c +5.
```
Results in lv_a containing everything from lv_c from index 5 ('World').

### Special characters
|Symbol|Use|
|------|---|
|%|Any one character|
|*|Any amount of any characters|