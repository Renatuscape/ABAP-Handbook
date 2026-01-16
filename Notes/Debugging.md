### Debugging

#### Shortcuts
Selecting a line and pressing **shift+8** will run the program until it hits that line, then break. This allows you to create a temporary breakpoint.

#### Go To
Be aware of how 'go to' works, and be particularly careful of using it in production systems. 'Go to' does not run code, but skips, then runs from that point.

When you 'go to' a point further ahead in your code, you are not executing the code between the original point and your 'go to' point.

When you 'go to' a point further back in your code, the previously run code is not undone. You will be re-executing any code that you backtracked over. This means if you commit something to the database and use 'go to' at a point in the code before the commit, then run the code, you will commit twice. A lot of code is not meant to be ran twice, so be wary when debugging in a production environment.

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