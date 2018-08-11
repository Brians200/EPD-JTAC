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
	["Non Lethal", [7], "#USER:JtacNonLethalMenu", -5, [["expression", ""]], "1", "1"]	
];

//Client Variable to show and hide the addAction
JtacAvailable = true;

if (player getVariable ["JTAC", false]) then {
	hint "You are the Joint Terminal Attack Controller. It is your job to provide support to your team in the form of close air and artillery support. Make sure you bring a laser designator and batteries so you can call in support with the JTAC menu. Information about each attack capability is included in your diary.";
	player addaction [("<t color=""#27EE1F"">") + ("JTAC Salvos") + "</t>", { showCommandingMenu "#USER:JtacMainMenu";}, "", -10, false, true,"",'JtacAvailable'];
	player addEventHandler ["Respawn", {JtacAvailable = true; player setVariable ["JTAC",true]; player addaction [("<t color=""#27EE1F"">") + ("JTAC Salvos") + "</t>", { showCommandingMenu "#USER:JtacMainMenu";}, "", -10, false, true,"",'JtacAvailable'];}];
	call compile preprocessFileLineNumbers "EPD\VirtualJTAC\jtacdoc.sqf";
};

if(!isserver) exitwith{};

//Server Variables to handle state
JtacCanFireSalvo = true;
JtacReloadTimer = 0;