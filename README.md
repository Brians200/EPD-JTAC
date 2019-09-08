# EPD-JTAC
JTAC script for ARMA 3

More information on the forums here: https://forums.bohemia.net/forums/topic/218512-standalone-jtac-script

# How to use
1. Copy the EPD folder to your Mission Folder
2. In the server's init.sqf, add the following: ```call compile preprocessFileLineNumbers "EPD\VirtualJTAC\init.sqf";```
3. On the players you want to have JTAC abilities, add the following: ```this setVariable ["JTAC",true];```
4. Copy the following into your description.ext
```
class CfgNotifications
{
	class JtacReloadNotification
	{
		title = "JTAC";				// Title displayed as text on black background. Filled by arguments.
		iconPicture = "a3\ui_f\data\gui\cfg\communicationmenu\call_ca.paa";		// Small icon displayed in left part. Colored by "color", filled by arguments.
		iconText = "1";			// Short text displayed over the icon. Colored by "color", filled by arguments.
		description = "%1";		// Brief description displayed as structured text. Colored by "color", filled by arguments.
		color[] = {0.153, 0.933, 0.122, 1};	// Icon and text color
		duration = 5;			// How many seconds will the notification be displayed
		priority = 0;			// Priority; higher number = more important; tasks in queue are selected by priority
		difficulty[] = {};		// Required difficulty settings. All listed difficulties has to be enabled
	};
};
```