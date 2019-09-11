CLIENT_REQUEST_PERMISSION_TO_FIRE = {
	[player, _this select 0, _this select 1] remoteExec ["SERVER_GRANT_PERMISSION_TO_FIRE", 2, false];
};

SERVER_GRANT_PERMISSION_TO_FIRE = {
	private _unit = _this select 0;
	private _payload = _this select 1;
	private _acquisitionMethod = _this select 2;

	private _category = _payload select 0;

	[_category call CAN_PERFORM_FIRE_MISSION, _category call GET_RELOAD_TIME_REMAINING, EPDJtacAquisitionGlobalModifier, _payload, _acquisitionMethod] remoteExec ["CLIENT_BEGIN_TARGETING", _unit, false];
};

CLIENT_BEGIN_TARGETING = {
	private _canFireSalvo = _this select 0;
	private _reloadTimeRemaining = _this select 1;
	private _aquisitionGlobalModifier = _this select 2;
	private _payloadInformation = _this select 3;
	private _acquisitionMethod = _this select 4;

	JtacAvailable = false;
	if( _canFireSalvo ) then {
		
		if( _acquisitionMethod == "average") then {
			[_aquisitionGlobalModifier, _payloadInformation] call CLIENT_LOCK_AND_FIRE_AVERAGE_LOCATION;
		} else { if (_acquisitionMethod == "laser") then {
			[_aquisitionGlobalModifier, _payloadInformation] call CLIENT_LOCK_AND_FIRE_LASER_LOCATION;
		} else { if (_acquisitionMethod == "vehicle") then {
			[_aquisitionGlobalModifier, _payloadInformation] call CLIENT_LOCK_AND_FIRE_VEHICLE;
		};};};
		
		JtacAvailable = true;
	} else {
		if (_reloadTimeRemaining == -20) then {
			hint "The guns have not finished firing yet!";
		} else {
			hint format["Cannot fire! The guns need another %1 seconds to reload!", _reloadTimeRemaining];
		};
		JtacAvailable = true;
	};
};

CLIENT_LOCK_AND_FIRE_AVERAGE_LOCATION = {
	private _aquisitionGlobalModifier = _this select 0;
	private _payloadInformation = _this select 1;
	private _category = _payloadInformation select 0;
	private _capacityUsed = _payloadInformation select 2;
	private _counterSleepTime = (_payloadInformation select 1) * _aquisitionGlobalModifier / 100.0;

	private _counter = 0;
	private _targetAcquired = true;
	private _laserLocation = [0,0,0];

	while {_counter < 100 } do {
		_counter = _counter + 1 ;

		private _laserTarget = LaserTarget player;
		private _designatorName = "Laser Designator";

		if(isNull _laserTarget and !isNull laserTarget (getConnectedUAV player)) then {
			_laserTarget = laserTarget (getConnectedUAV player);
			_designatorName = "Connected UAV";
		};

		if(isNull _laserTarget and !isNull laserTarget (vehicle player)) then {
			_laserTarget = laserTarget (vehicle player);
			_designatorName = "Your Vehicle";
		};

		hintSilent format["Using %1\nAcquiring target: %2%3", _designatorName, _counter, "%"];

		if(isNull _laserTarget) exitwith{ _targetAcquired = false; };
		private _currentLaserLocation = getPosASL _laserTarget;

		_laserLocation = _laserLocation vectorAdd _currentLaserLocation;
		sleep _counterSleepTime;
	};
	
	if(_targetAcquired) then {
		_laserLocation = _laserLocation vectorMultiply ( 1.0 / _counter);
		hint "Rounds inbound, take cover! \n(It's safe to turn your laser off.)";
		private _firemission = format[(_payloadInformation select 3), _laserLocation, call CLIENT_GET_DIRECTION];
		[player, _firemission, _category, _capacityUsed, true, []] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
	} else {
		hint format["Laser turned off. Targeting canceled"];
	};
};

CLIENT_LOCK_AND_FIRE_LASER_LOCATION = {
	private _aquisitionGlobalModifier = _this select 0;
	private _payloadInformation = _this select 1;
	private _category = _payloadInformation select 0;
	private _capacityUsed = _payloadInformation select 2;
	private _counterSleepTime = (_payloadInformation select 1) * _aquisitionGlobalModifier  / 100.0;

	private _laser = laserTarget player;
	private _designatorName = "Laser Designator";

	if (isNull _laser) then {
		_laser = laserTarget (getConnectedUAV player);
		_designatorName = "Connected UAV";

		if (isNull _laser) then {
			_laser = laserTarget (vehicle player);
			_designatorName = "Your Vehicle";
		};
	};
	
	private _counter = 0;
	while {true} do {
		if (isNull _laser) exitWith {hint "Laser turned off. Locking canceled" };
		hintSilent format ["Using %3\nLocking onto laser: %1%2", _counter, "%", _designatorName];
		_counter = _counter + 1;
		
		if (_counter >= 100) exitWith {
			hint "Missile is fired. Targeting your laser.";
			private _firemission = format[(_payloadInformation select 3), _laser, call CLIENT_GET_DIRECTION];
			
			//0 = _laser spawn {[_this select 0, "M_Titan_AT_long"] call FIRE_GUIDED_MISSILE;}
			[player, _firemission, _category, _capacityUsed, false, [_laser]] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
			//[_laser, "M_Titan_AT_long", 0 ] spawn FIRE_GUIDED_MISSILE;
		};
		
		sleep _counterSleepTime;
	};
};

CLIENT_LOCK_AND_FIRE_VEHICLE = {

	private _aquisitionGlobalModifier = _this select 0;
	private _payloadInformation = _this select 1;
	private _category = _payloadInformation select 0;
	private _capacityUsed = _payloadInformation select 2;

	private _oneQuarter = (1.0/4.0);
	private _oneThird = (1.0/3.0);

	private _counterSleepTime = (_payloadInformation select 1) * _aquisitionGlobalModifier  / 450.0;

	private _laser = laserTarget player;
	private _designatorName = "Laser Designator";

	if (isNull _laser) then {
		_laser = laserTarget (getConnectedUAV player);
		_designatorName = "Connected UAV";

		if (isNull _laser) then {
			_laser = laserTarget (vehicle player);
			_designatorName = "Your Vehicle";
		};
	};

	private _aimedAtTargetCounter = 0;
	private _notAimedAtTargetCounter = 0;
	private _currentTarget = objNull;
	private _displayName = objNull;
	while {true} do {
		if (isNull _laser) exitWith {hint "Laser turned off. Locking canceled" };
		
		private _aimedAtCurrentTarget = false;
		private _nearestEntities = _laser nearEntities [["Car", "Motorcycle", "Tank"], 5];
		if (count _nearestEntities > 0) then {
			if (isNull _currentTarget) then {
				_currentTarget = _nearestEntities select 0;
				private _targetType = typeOf _currentTarget;
				_displayName =  getText (configFile >>  "CfgVehicles" >> _targetType >> "displayName");
			} else {
				{ if ( _currentTarget == _x) then {_aimedAtCurrentTarget = true}; } forEach _nearestEntities;				
			};		
		};
		
		if (_aimedAtCurrentTarget) then {
			_aimedAtTargetCounter = _aimedAtTargetCounter + _oneQuarter;
			_notAimedAtTargetCounter = 0.0;
		} else {
			_notAimedAtTargetCounter = _notAimedAtTargetCounter + _oneThird;
		};
		
		if (_notAimedAtTargetCounter >= 100) exitWith {hint "Target Lost. Locking Canceled";};
		
		if (_aimedAtTargetCounter >= 100) exitWith {
			hint "Vehicle locked. It is safe to turn off your laser and take cover.";
			private _firemission = format[(_payloadInformation select 3), _currentTarget, call CLIENT_GET_DIRECTION];
			[player, _firemission, _category, _capacityUsed, false, [_currentTarget]] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
		};
		hintSilent format["Using %6\nCurrent Target: %1\nOn Target: %2\nLock: %3%5\nLock Lost: %4%5", _displayName, _aimedAtCurrentTarget, _aimedAtTargetCounter toFixed 2, _notAimedAtTargetCounter toFixed 2,"%",_designatorName];
		
		sleep _counterSleepTime;
	};
};

CLIENT_GET_DIRECTION = {
	switch (JtacIncomingAngle) do {
		case "N": { 0 };
		case "NE": { 45 };
		case "E": { 90 };
		case "SE": { 135 };
		case "S": { 180 };
		case "SW": { 225 };
		case "W": { 270 };
		case "NW": { 315 };
		default { random 360 };
	};
};

SERVER_PERFORM_FIRE_MISSION = {
	private _unit = _this select 0;
	private _fireMission = _this select 1;
	private _category = _this select 2;
	private _capacityUsed = _this select 3;
	private _shouldPerformOnServer = _this select 4;
	private _extraParams = _this select 5;
	
	if (_category call CAN_PERFORM_FIRE_MISSION) then {
		[_category, _capacityUsed] call RECORD_FIRE_MISSION;

		if (!EPDJtacDebug) then {
			sleep (5 + random 15);
		};

		if (_shouldPerformOnServer) then {
			0 = [_extraParams, compile _fireMission] remoteExec ["spawn", 2, false];
		} else {
			0 = [_extraParams, compile _fireMission] remoteExec ["spawn", _unit, false];
		};

		0 = _category spawn START_RELOAD_TIMER;

	} else {
		(_category call GET_RELOAD_TIME_REMAINING) remoteExec ["CLIENT_ANOTHER_JTAC_FIRED", _unit, false];
	};
};

CLIENT_ANOTHER_JTAC_FIRED = {
	hint format["Could not fire! Another JTAC operator called in a strike before you could complete yours. The guns need another %1 seconds to reload!", _this];
	JtacAvailable = true;
};
