# RegLaunch
(Please use the "Releases" link over on the right side of the GitHub page if you just want to download the EXE ------->

Utility to Apply Registry Setting(s) only while a specified app is running (RetinaEngrave Registry Fix)

This utility was written PRIMARILY for users of the RetinaEngrave3D application which Full Spectrum Laser refuses to support.

(A Microsoft XPS update in Dec 2022 provided additional data formats in the XPS data stream which RetinaEngrave does not
know how to handle.  RetinaEngrave will simply ignore entities in the data stream which it does not know how to process)

This utility is written to be as flexible as possible and its use may therefore be of value in other unrelated situations.

It was also written to allow future modifications such that its behavior can be defined simply through modifications to its
companion INI file.  It will also support modification to MULTIPLE registry keys should that prove necessary in the future.
(i.e. Disabling multiple Microsoft Patches if it is required in the future)

Once REGLAUNCH is configured to meet your needs it is completely transparent and automatic.  (No screen or popups are required)

REGLAUNCH:

- Applies one of more registry updates prior to launching a specified program
- Waits for the specified program to terminate
- Then Removes (or re-sets) the registry update(s) intitially applied

REGLAUNCH is useful if you only want/need a specied registry modification (or modifications) to be in place while a particular
program is running.  This can minimize the impact on your O/S if you are downgrading a recent patch just for the benefit of
a single program.  All other times, the associated update can remain fully functional.

Multiple copies of RegLaunch can be used for multiple puposes.  Simply ensure each copy of REGLAUNCH runs from its own independant
folder and has its own unique configuration INI in the very same folder.

REGLAUNCH will process one or more registry values simply by declaring the appropriate number of sections in its configuration INI.
INI Section Names don't matter except that "[Config]" is reserved (It holds the name of the program to be launched)

REGLAUNCH will either Create and then fully Delete a registry setting (FUNCTION=CREATE) or simply change the values of a registry setting
(FUNCTION=SET).  It will do this for each registry key identified in an associated section of the INI file.  If using FUNCTION=CREATE
then the DATA record will specify the data to be used.  If using FUNCTION=SET, then the DATA record specifies the data to be set BEFORE
the program is run and the UNSET record specifies the data to be set AFTER the program terminates.

As with any program that requires modification of the Registry, this program requires Administrator rights.  It can not be run from a
user account which does not have these rights (as would be expected).  However, if it is being run from a user account which has the 
appropriate rights, then it will automatically elevate the rights as needed (UAC permitting).
