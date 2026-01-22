## Eclipse IDE for SAP/ABAP
Notes on using Eclipse IDE for SAP/ABAP development.


### General Tips
SAP GUI can be opened inside Eclipse through the menu Navigate > Open SAP GUI (Ctrl+6).
* Transactions can be run as normal within Eclipse
* Objects in Eclipse's SAP GUI-interface will be opened in Eclipse if possible

Eclipse's debugger uses only external break points when debugging. You do not need different types of breakpoints for backend and frontend.
* Breakpoints can be disabled without being removed, en masse or one by one
* Breakpoints can also be removed all at once

The $TMP package contains your locally stored objects (not unique to Eclipse). It will be automatically added to the Favourites tab in Eclipse, at the top of the project hierarchy.

The System Library folder contains all the content of a solution organised by packages. Within the packages, you will find all code and customisation. Find the Source Code Library when looking for ABAP code.


### Coding in Eclipse
When you fail to find an option in Eclipse, you can always choose Navigate > Open SAP GUI for Object, which will take you to the appropriate SAP GUI window with all the usual features.

#### Shortcuts
|Action|Shortcut|Note|
|------|--------|----|
|Check|Ctrl+F2|
|Activate|Ctrl+F3|
|Run|F8|Run as ABAP Application|
|Run|Alt+F8|Run ABAP Dev object as Application in GUI|
|Format code |Shift + F1    | Source Code > Format|
|Format block|Ctrl + Shift + F1|
|Rename|ALt + Shift + R|Refactors a variable name everywhere in the code|

