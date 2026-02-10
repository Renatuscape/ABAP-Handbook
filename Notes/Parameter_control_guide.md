# MODIF ID - Parameter Control Guide

## Purpose
MODIF ID allows dynamic control of selection screen fields at runtime - show/hide, enable/disable, or modify field properties.

## Basic Syntax
```abap
PARAMETERS: p_field TYPE data_type MODIF ID abc.
SELECT-OPTIONS: s_field FOR data_field MODIF ID xyz.
```

## Control Logic Structure
```abap
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'abc'.
      screen-invisible = 1.    " Hide field
      screen-input = 0.        " Make read-only
      screen-active = 0.       " Deactivate completely
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
```

## Key Screen Properties
- **screen-invisible**: 1 = hidden, 0 = visible
- **screen-input**: 1 = input enabled, 0 = display only
- **screen-active**: 1 = active, 0 = completely inactive
- **screen-required**: 1 = mandatory, 0 = optional

## Common Patterns

### Toggle Between Fields
```abap
" Parameters
PARAMETERS: p_single TYPE sy-datum MODIF ID sin.
SELECT-OPTIONS: s_range FOR sy-datum MODIF ID ran.
PARAMETERS: p_mode AS CHECKBOX DEFAULT 'X'.

" Control logic
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF p_mode = 'X'.
      IF screen-group1 = 'ran'.
        screen-active = 0.  " Hide range, show single
      ENDIF.
    ELSE.
      IF screen-group1 = 'sin'.
        screen-active = 0.  " Hide single, show range
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
```

### Authorization-Based Control
```abap
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'adv'.
      " Only show advanced options to authorized users
      AUTHORITY-CHECK OBJECT 'Z_ADVANCED' ID 'ACTVT' FIELD '03'.
      IF sy-subrc <> 0.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
```

### Conditional Field Display
```abap
PARAMETERS: p_type TYPE c LENGTH 1 OBLIGATORY.
PARAMETERS: p_detail TYPE c LENGTH 10 MODIF ID det.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'det'.
      IF p_type = 'S'.  " Only show detail for 'S' type
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
```

## Best Practices
- Use **meaningful MODIF IDs** (e.g., 'adv' for advanced, 'his' for history)
- Group **related fields** with same MODIF ID
- Always use **MODIFY SCREEN** after changing screen properties
- Consider **performance** - avoid complex logic in AT SELECTION-SCREEN OUTPUT

## Quick Reference
```abap
" Show/Hide: screen-active = 0/1
" Enable/Disable: screen-input = 0/1  
" Visible/Invisible: screen-invisible = 1/0
" Required/Optional: screen-required = 1/0
```