## Classes
Classes are a collection of public and private methods that can be called from elsewhere in the code. Unlike Function Modules, they must be called within SAP, while a Function Module can be called from anywhere.

### Superclasses
A class does not need a superclass. A class will inherit all the public and protected methods of its superclass (equivalent to parent class in other languages).

### Interfaces
Interfaces are method signatures that work as a blueprint for what the class must implement. It is primarily used for implementing a specific SAP standard interface, for specific design patterns, or for allowing the same method to be called on multiple, distinct classes.

### Static vs Instanced
The methods within a class can be static or instanced. Static methods are called directly on the class, and are defined with the CLASS-METHODS keyword. 

Key Differences:
|Aspect|Instance|Static|
|---|---|---|
|Definition|METHODS|CLASS-METHODS|
|Call syntax|->|=>|
|Needs instance?|Yes (NEW)|No|
|Access to instance data?|Yes|No|


To call non-static methods, an instance of the class must be created with the NEW keyword. Then the method is called on the object using ->
```ABAP
DATA(lo_obj) = NEW zcl_myclass( ).

lo_obj->write_text( 'Hello' ).
```

A static method can be called directly on the class name using =>
```ABAP
zcl_myclass=>write_text( 'Hello' ).
```

