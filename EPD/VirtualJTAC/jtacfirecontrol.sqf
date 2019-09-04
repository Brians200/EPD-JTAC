CLIENT_REQUEST_PERMISSION_TO_FIRE = {
	[player, _this select 0, _this select 1] remoteExec ["SERVER_GRANT_PERMISSION_TO_FIRE", 2, false];
};

SERVER_GRANT_PERMISSION_TO_FIRE = {
	private["_unit", "_payload", "_acquisitionMethod"];
	_unit = _this select 0;
	_payload = _this select 1;
	_acquisitionMethod = _this select 2;
	[JtacCanFireSalvo, JtacReloadTimer, EPDJtacAquisitionGlobalModifier, _payload, _acquisitionMethod] remoteExec ["CLIENT_BEGIN_TARGETING", _unit, false];
};

CLIENT_BEGIN_TARGETING = {
	private ["_permissionToFire", "_reloadDelay", "_reloadTimeRemaining", "_payloadInformation", "_aquisitionGlobalModifier", "_acquisitionMethod"];
	_canFireSalvo = _this select 0;
	_reloadTimeRemaining = _this select 1;
	_aquisitionGlobalModifier = _this select 2;
	_payloadInformation = _this select 3;
	_acquisitionMethod = _this select 4;

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
		hint format["Cannot fire! The guns need another %1 seconds to reload!", _reloadTimeRemaining];
		JtacAvailable = true;
	};
};

CLIENT_LOCK_AND_FIRE_AVERAGE_LOCATION = {
	private["_counterSleepTime", "_counter", "_targetAcquired", "_firemission", "_laserLocation", "_aquisitionGlobalModifier", "_payloadInformation"];

	_aquisitionGlobalModifier = _this select 0;
	_payloadInformation = _this select 1;

	_counterSleepTime = (_payloadInformation select 0) * _aquisitionGlobalModifier;
	_reloadDelay = _payloadInformation select 1;
	_counter = 0;
	_targetAcquired = true;
	_laserLocation = [0,0,0];
	while {_counter < 100 } do {
		private["_laserTarget", "_currentLaserLocation", "_designatorName"];
		_counter = _counter + 1 ;

		_laserTarget = objNull;
		_designatorName = "Laser Designator";
		_laserTarget = laserTarget player;

		hint format["%1", laserTarget (getConnectedUAV player)];

		if(isNull _laserTarget and !isNull laserTarget (getConnectedUAV player)) then {
			_laserTarget = laserTarget (getConnectedUAV player);
			_designatorName = "Connected UAV";
		};

		if(isNull _laserTarget and !isNull laserTarget (vehicle player)) then {
			_laserTarget = laserTarget (vehicle player);
			_designatorName = "Your Vehicle";
		};

		hintSilent format["Using %1\nAcquiring target: %2%3", _designatorName, _counter, "%"];

		if(isNull _laserTarget) exitwith{_targetAcquired = false; };
		_currentLaserLocation = getPosASL _laserTarget;
		_laserLocation = [ (_laserLocation select 0) + (_currentLaserLocation select 0),
							(_laserLocation select 1) + (_currentLaserLocation select 1),
							(_laserLocation select 2) + (_currentLaserLocation select 2)
						];
		sleep _counterSleepTime;
	};
	
	if(_targetAcquired) then {
		_laserLocation = [ (_laserLocation select 0) / _counter,
						(_laserLocation select 1) / _counter,
						(_laserLocation select 2) / _counter
		];
		hint "Rounds inbound, take cover! \n(It's safe to turn your laser off.)";
		_firemission = format[(_payloadInformation select 2), _laserLocation];
		[player, _firemission, _reloadDelay, []] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
	} else {
		hint format["Laser turned off. Targeting canceled"];
	};
};

CLIENT_LOCK_AND_FIRE_LASER_LOCATION = {

	private ["_aquisitionGlobalModifier", "_payloadInformation", "_laser", "_counter", "_firemission", "_reloadDelay"];

	_aquisitionGlobalModifier = _this select 0;
	_payloadInformation = _this select 1;
	_reloadDelay = _payloadInformation select 1;

	_counterSleepTime = (_payloadInformation select 0) * _aquisitionGlobalModifier;

	_laser = laserTarget player;
	
	_counter = 0;
	while {true} do {
		if (isNull _laser) exitWith {hint "Laser turned off. Locking canceled" };
		hintSilent format ["Locking onto laser: %1%2", _counter, "%"];
		_counter = _counter + 1;
		
		if (_counter >= 100) exitWith {
			hint "Missile is fired. Targeting your laser.";
			_firemission = format[(_payloadInformation select 2), _laser];
			
			//0 = _laser spawn {[_this select 0, "M_Titan_AT_long"] call FIRE_GUIDED_MISSILE;}
			[player, _firemission, _reloadDelay, [_laser]] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
			//[_laser, "M_Titan_AT_long", 0 ] spawn FIRE_GUIDED_MISSILE;
		};
		
		sleep _counterSleepTime;
	};
};

CLIENT_LOCK_AND_FIRE_VEHICLE = {

	_aquisitionGlobalModifier = _this select 0;
	_payloadInformation = _this select 1;
	_reloadDelay = _payloadInformation select 1;
	_counterSleepTime = (_payloadInformation select 0) * _aquisitionGlobalModifier;

	_laser = laserTarget player;
	_oneThird = (1.0/3.0);
	_oneHalf = (1.0/2.0);

	_aimedAtTargetCounter = 0;
	_notAimedAtTargetCounter = 0;
	_currentTarget = objNull;
	_displayName = objNull;
	while {true} do {
		private "_aimedAtCurrentTarget";
		
		if (isNull _laser) exitWith {hint "Laser turned off. Locking canceled" };
		
		_aimedAtCurrentTarget = false;		
		_nearestEntities = _laser nearEntities [["Car", "Motorcycle", "Tank"], 5];
		if (count _nearestEntities > 0) then {
			if (isNull _currentTarget) then {
				_currentTarget = _nearestEntities select 0;
				_targetType = typeOf _currentTarget;
				_displayName =  getText (configFile >>  "CfgVehicles" >> _targetType >> "displayName");
			} else {
				{ if ( _currentTarget == _x) then {_aimedAtCurrentTarget = true}; } forEach _nearestEntities;				
			};		
		};
		
		if (_aimedAtCurrentTarget) then {
			_aimedAtTargetCounter = _aimedAtTargetCounter + _oneThird;
			_notAimedAtTargetCounter = 0.0;
		} else {
			_notAimedAtTargetCounter = _notAimedAtTargetCounter + _oneHalf;
		};
		
		if (_notAimedAtTargetCounter >= 100) exitWith {hint "Target Lost. Locking Canceled";};
		
		if (_aimedAtTargetCounter >= 100) exitWith {
			hint "Vehicle locked. It is safe to turn off your laser and take cover.";
			_firemission = format[(_payloadInformation select 2), _currentTarget];
			[player, _firemission, _reloadDelay, [_currentTarget]] remoteExec ["SERVER_PERFORM_FIRE_MISSION", 2, false];
		};
		hintSilent format["Current Target: %1\nOn Target: %2\nLock: %3%5\nLock Lost: %4%5", _displayName, _aimedAtCurrentTarget, _aimedAtTargetCounter toFixed 2, _notAimedAtTargetCounter toFixed 2,"%"];
		
		sleep _counterSleepTime;
	};
};


SERVER_PERFORM_FIRE_MISSION = {
	private ["_unit", "_fireMission", "_reloadDelay"];
	_unit = _this select 0;
	_fireMission = _this select 1;
	fireMission = compile _fireMission;
	_reloadDelay = (_this select 2) * EPDJtacCoolDownGlobalModifier;
	_extraParams = _this select 3;
	
	if (JtacCanFireSalvo) then {
		JtacCanFireSalvo = false;
		JtacReloadTimer = _reloadDelay;
		if (!EPDJtacDebug) then {
			sleep (5 + random 15);
		};
		//0 = _extraParams spawn compile _fireMission;
		0 = [_extraParams, compile _fireMission] remoteExec ["spawn", _unit, false];
		0 = [] spawn {
			if(not EPDJtacDebug) then {
				while {JtacReloadTimer > 0 } do {
					JtacReloadTimer = JtacReloadTimer - 1;
					sleep 1;
				};
			};
			JtacCanFireSalvo = true;		
		};
	} else {
		JtacReloadTimer remoteExec ["CLIENT_ANOTHER_JTAC_FIRED", _unit, false];
	};
};

CLIENT_ANOTHER_JTAC_FIRED = {
	hint format["Could not fire! Another JTAC operator called in a strike before you could complete yours. The guns need another %1 seconds to reload!", _this];
	JtacAvailable = true;
};
