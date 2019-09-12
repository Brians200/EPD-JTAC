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
		title = "JTAC";
		iconPicture = "a3\ui_f\data\gui\cfg\communicationmenu\call_ca.paa";
		iconText = "1";
		description = "%1";
		color[] = {0.153, 0.933, 0.122, 1};
		duration = 5;
		priority = 0;
		difficulty[] = {};
	};
};
```