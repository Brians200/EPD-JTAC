call compile preprocessFileLineNumbers "EPD\VirtualJTAC\jtacsettings.sqf";
call compile preprocessFileLineNumbers "EPD\VirtualJTAC\jtacfunctions.sqf";

call PARSE_AVAILABLE_JTAC_ATTACKS;

JtacMainMenu = [
	["EPD JTAC", true],
	["Bullets", [2], "#USER:JtacBulletMenu", -5, [["expression", ""]], "1", "1"],
	["Shells", [3], "#USER:JtacShellMenu", -5, [["expression", ""]], "1", "1"],
	["Grenades", [4], "#USER:JtacGrenadeMenu", -5, [["expression", ""]], "1", "1"],
	["Bombs", [5], "#USER:JtacBombsMenu", -5, [["expression", ""]], "1", "1"],
	["Missile Barrage", [6], "#USER:JtacMissilesMenu", -5, [["expression", ""]], "1", "1"],
	["Mine Field", [7], "#USER:JtacMinesMenu", -5, [["expression", ""]], "1", "1"],
	["Non Lethal", [8], "#USER:JtacNonLethalMenu", -5, [["expression", ""]], "1", "1"]
];

if(!isDedicated) then {
	//Client Variable to show and hide the addAction
	JtacAvailable = true;

	//Wait for JIP to load in...
	waitUntil {sleep .5; !(isNull player)};

	if (player getVariable ["JTAC", false]) then {
		hint "You are the Joint Terminal Attack Controller. It is your job to provide support to your team in the form of close air and artillery support. Make sure you bring a laser designator and batteries so you can call in support with the JTAC menu. Information about each attack capability is included in your diary.";
		player addaction [("<t color=""#27EE1F"">") + ("JTAC Salvos") + "</t>", { showCommandingMenu "#USER:JtacMainMenu";}, "", -10, false, true,"",'JtacAvailable'];
		player addEventHandler ["Respawn", {JtacAvailable = true; player setVariable ["JTAC",true]; player addaction [("<t color=""#27EE1F"">") + ("JTAC Salvos") + "</t>", { showCommandingMenu "#USER:JtacMainMenu";}, "", -10, false, true,"",'JtacAvailable'];}];
		call compile preprocessFileLineNumbers "EPD\VirtualJTAC\jtacdoc.sqf";
	};

	0 = [] spawn {
		private ["_actionNumber","_booleanActionAdd","_addActionedUav"];
		_actionNumber = -1;
		_booleanActionAdd = false;
		_addActionedUav = objNull;
		while {true} do {
			private ["_currentUav"];
			_currentUav = getConnectedUAV player;

			if (!isNull _addActionedUav and _addActionedUav != _currentUav) then {
				_addActionedUav removeAction _actionNumber;
				_addActionedUav = objNull;
				_booleanActionAdd = false;
			};

			if (!_booleanActionAdd and !isNull _currentUav and (player getVariable ["JTAC", false])) then {
				_booleanActionAdd = true;
				_addActionedUav = getConnectedUAV player;
				_actionNumber = (getConnectedUAV player) addaction [("<t color=""#27EE1F"">") + ("JTAC Salvos") + "</t>", { showCommandingMenu "#USER:JtacMainMenu";}, "", -10, false, true,"",'JtacAvailable && ((UAVControl getConnectedUAV player) select 1) == "GUNNER"'];
			};

			sleep 1;
		};
	};
};

if(!isserver) exitwith{};

//Server Variables to handle state
JtacCanFireSalvo = true;
JtacReloadTimer = 0;
