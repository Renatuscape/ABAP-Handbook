## Eclipse IDE for SAP/ABAP


### General Tips
SAP GUI can be opened inside Eclipse through the menu Navigate -> Open SAP GUI (Ctrl+6).
* Transactions can be run as normal within Eclipse
* Objects in Eclipse's SAP GUI-interface will be opened in Eclipse if possible

Eclipse's debugger uses only external break points when debugging. You do not need different types of breakpoints for backend and frontend.

The $TMP package contains your locally stored objects (not unique to Eclipse). It will be automatically added to the Favourites tab in Eclipse, at the top of the project hierarchy.

The System Library folder contains all the content of a solution organised by packages. Within the packages, you will find all code and customisation. Find the Source Code Library when looking for ABAP code.
