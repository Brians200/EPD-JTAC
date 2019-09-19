EPDJtacCategories = [];
EPDJtacAmounts = [];
EPDJtacCapacities = [];
EPDJtacShortReloadTimes = [];
EPDJtacLongReloadTimes = [];
EPDJtacReloadTimeLeft = [];
EPDJtacCanFire = [];
EPDJtacGunsFiring = [];

CAN_PERFORM_FIRE_MISSION = {
	private _category = _this;
	private _index = EPDJtacCategories find _category;
	EPDJtacCanFire select _index;
};

RECORD_FIRE_MISSION = {
	private _category = _this select 0;
	private _amountUsed = _this select 1;

	private _index = EPDJtacCategories find _category;
	EPDJtacCanFire set [_index, false];
	EPDJtacGunsFiring set [_index, true];

	private _newAmount = _amountUsed + (EPDJtacAmounts select _index);

	private _sleepTime = 0;
	if ( _newAmount >= (EPDJtacCapacities select _index)) then {
		//long reload
		_sleepTime = EPDJtacLongReloadTimes select _index;
		EPDJtacAmounts set [_index, 0];
	} else {
		// short reload
		_sleepTime = EPDJtacShortReloadTimes select _index;
		EPDJtacAmounts set [_index, _newAmount];
	};

	EPDJtacReloadTimeLeft set [_index, _sleepTime];
};

GET_RELOAD_TIME_REMAINING = {
	private _category = _this;
	private _index = EPDJtacCategories find _category;
	if ( EPDJtacGunsFiring select _index ) then {
		-20;
	} else {
		EPDJtacReloadTimeLeft select _index;
	};
};

START_RELOAD_TIMER = {

	private _category = _this;
	private _index = EPDJtacCategories find _category;

	EPDJtacGunsFiring set [_index, false];
	[_index, EPDJtacReloadTimeLeft select _index] call PERFORM_TIMER_COUNTDOWN;

	EPDJtacCanFire set [_index, true];

	{
		_category remoteExec ["CLIENT_RELOAD_FINISHED", _x, false];
	} forEach allPlayers;
};

PERFORM_TIMER_COUNTDOWN = {
	private _index = _this select 0;
	private _timeLeft = _this select 1;

	if(not EPDJtacDebug) then {
		while { _timeLeft > 0 } do {
			sleep 1;
			_timeLeft = _timeLeft - 1;
			EPDJtacReloadTimeLeft set [_index, _timeLeft];
		};
	};
	EPDJtacReloadTimeLeft set [_index, 0];
};

GET_RELOAD_STATUS_ARRAY = {
	private _array = [];

	{
		private _category = _x select 0;
		private _index = EPDJtacCategories find _category;
		private _asterisk = "";
		private _timeLeft = 0;

		if ( EPDJtacGunsFiring select _index ) then {
			_asterisk = "*";
		};
		_timeLeft = EPDJtacReloadTimeLeft select _index;

		if (_timeLeft > 0) then {
			private _prettyString  = _category call CATEGORY_TO_PRETTY_STRING;
			private _reloadInfo = format ["%1 - %2%3 seconds", _prettyString , _timeLeft, _asterisk ];
			_array pushBack [_reloadInfo, .2, .1];
		}

	} foreach EPDJtacReloads;

	if ( count _array == 0) then {
		_array pushBack ["All attacks ready to fire", .2, 0];
	};
	_array pushBack["", 0,0,3];
	_array remoteExec ["CLIENT_DISPLAY_RELOAD_STATUS", _this, false];
};

CLIENT_DISPLAY_RELOAD_STATUS = {
	_this spawn  BIS_fnc_EXP_camp_SITREP;
};

CLIENT_RELOAD_FINISHED = {
	if (player getVariable ["JTAC",false] ) then {
		private _prettyName = _this call CATEGORY_TO_PRETTY_STRING;
		["JtacReloadNotification", [format ["%1 ready to fire!", _prettyName]]] call BIS_fnc_showNotification;
	};
};

CATEGORY_TO_PRETTY_STRING = {
	switch (_this) do {
		case "BULLETS": { "Bullets" };
		case "SHELLS": { "Shells" };
		case "STRAFINGRUN": { "Strafing Run" };
		case "BOMBS": { "Bombs" };
		case "ROCKETS": { "Rockets" };
		case "GUIDEDMISSILE": { "Guided Missile" };
		case "MINES": { "Mines" };
		case "NONLETHAL": { "Nonlethal" };
		default { _this };
	};
};

{
	EPDJtacCategories pushBack (_x select 0);
	EPDJtacCapacities pushBack (_x select 1);
	EPDJtacShortReloadTimes pushBack (_x select 2);
	EPDJtacLongReloadTimes  pushBack (_x select 3);
	EPDJtacAmounts pushBack 0;
	EPDJtacCanFire pushBack true;
	EPDJtacReloadTimeLeft pushBack 0;
	EPDJtacGunsFiring pushBack false;
} foreach EPDJtacReloads;