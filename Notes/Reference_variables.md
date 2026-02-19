# Reference variables


### Bound
IS [NOT] BOUND can be used to check whether a reference variable is usable. It functions like a null check, but in the case that the reference is not null, it also checks whether the value is useable, or if it's pointing to something useless, such as a line in an internal table that has been deleted.