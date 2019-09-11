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

CLIENT_RELOAD_FINISHED = {
	if (player getVariable ["JTAC",false] ) then {
		["JtacReloadNotification", [format ["%1 ready to fire!", _this]]] call BIS_fnc_showNotification;
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