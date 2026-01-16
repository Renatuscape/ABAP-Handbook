### Debugging

#### Watchpoints
In addition to breakpoints, there are watchpoints. An attribute can be watched, and the program will break when the attribute changes. A condition can be added, and the program only breaks when the condition is met.

### Expanded Stack Trace
Transaction ST12 allows you to trace a program and see which processes are taking up the most resources, among other things. Useful when something runs slowly. ST12 requires higher authorisations.

#### The Endless Loop
Never use this on batch operations; your colleagues will hate you.

```ABAP
do.

enddo.
```

This will create an infinate loop, stalling the program and allowing you to investigate it in SM50. This can be useful when breakpoints do not properly stop the program.