CLIENT_REQUEST_PERMISSION_TO_FIRE = {
	[[player, _this], "SERVER_REQUEST_PERMISSION_TO_FIRE", false, false, false] call BIS_fnc_MP; 
};

SERVER_REQUEST_PERMISSION_TO_FIRE = {
	private["_unit", "_reloadDelay", "_payload"];
	_unit = _this select 0;
	_payload = _this select 1;
	[[JtacCanFireSalvo, JtacReloadTimer, _payload], "CLIENT_RECEIVE_PERMISSION_TO_FIRE", _unit, false, false] call BIS_fnc_MP; 
};

CLIENT_RECEIVE_PERMISSION_TO_FIRE = {
	private ["_permissionToFire", "_reloadTimeRemaining", "_payloadInformation"];
	_canFireSalvo = _this select 0;
	_reloadTimeRemaining = _this select 1;
	_payloadInformation = _this select 2;
	JtacAvailable = false;
	if( _canFireSalvo ) then {
		private["_counterSleepTime", "_counter", "_targetAcquired", "_firemission", "_laserLocation", "_currentLaserLocation"];
		_counterSleepTime = _payloadInformation select 0;
		_reloadDelay = _payloadInformation select 1;
		_counter = 0;
		_targetAcquired = true;
		_laserLocation = [0,0,0];
		while {_counter < 100 } do {
			_counter = _counter + 1 ;
			hintSilent format["Acquiring target: %1%2", _counter, "%"];
			if(isNull laserTarget player) exitwith{_targetAcquired = false; };
			_currentLaserLocation = getPosASL laserTarget player;
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
			[[player, _firemission, _reloadDelay], "SERVER_PERFORM_FIRE_MISSION", false, false, false] call BIS_fnc_MP; 
		} else {
			hint format["Laser turned off. Targeting canceled"];
		};
		
		JtacAvailable = true;
	} else {
		hint format["Cannot fire! The guns need another %1 seconds to reload!", _reloadTimeRemaining];
		JtacAvailable = true;
	};
};

SERVER_PERFORM_FIRE_MISSION = {
	private ["_unit", "_fireMission", "_reloadDelay"];
	_unit = _this select 0;
	_fireMission = _this select 1;
	_reloadDelay = _this select 2;
	
	
	if (JtacCanFireSalvo) then {
		JtacCanFireSalvo = false;
		JtacReloadTimer = _reloadDelay;
		sleep (5 + random 15);
		call compile _fireMission;
		[] spawn {
			if(not EPDJtacDebug) then {
				while {JtacReloadTimer > 0 } do {
					JtacReloadTimer = JtacReloadTimer - 1;
					sleep 1;
				};
			};
			JtacCanFireSalvo = true;		
		};
	} else {
		[JtacReloadTimer, "CLIENT_ANOTHER_JTAC_FIRED", false, false, false] call BIS_fnc_MP; 
	};
};

CLIENT_ANOTHER_JTAC_FIRED = {
	hint format["Could not fire! Another JTAC operator called in a strike before you could complete yours. The guns need another %1 seconds to reload!", _this];
	JtacAvailable = true;
};



INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD = {
	if(!isserver) exitwith{};
	
	private ["_targetLocation", "_projectileSet", "_projectileSetCount", "_i"];
	//[targetLocationASL, [[className, verticalOffset, numberToSend, spreadRadial, spreadNormal, minTimeBetween, maxRandomTime],...]]
	_targetLocation = _this select 0;
	_projectileSet = _this select 1;
	_projectileSetCount = count _projectileSet;
	for "_i" from 0 to _projectileSetCount - 1 do{
		private "_projectiles";
		_projectiles = _projectileSet select _i;
		[_targetLocation, _projectiles] spawn SHOOT_PROJECTILES;
	};
};

SHOOT_PROJECTILES = {
	private ["_incomingAngle", "_sourceHeight", "_source2dDistance", "_targetLocation", "_projectiles", "_projectileClassName", "_verticalOffset", "_numberToSend", "_spreadRadial", "_spreadNormal", "_minTimeBetween", "_maxRandomTime", "_sourceLocation", "_projectileSpeed"];
	_incomingAngle = random 360;
	_sourceHeight = 982.1129;
	_source2dDistance = 1000;
	_projectileSpeed = 1000;
	
	_targetLocation = _this select 0;
	_projectiles = _this select 1;
	_projectileClassName = _projectiles select 0;
	_verticalOffset = _projectiles select 1;
	_numberToSend = _projectiles select 2;
	_spreadRadial = _projectiles select 3;
	_spreadNormal = _projectiles select 4;
	_minTimeBetween = _projectiles select 5;
	_maxRandomTime  = _projectiles select 6;
	
	_sourceLocation = [ (_targetLocation select 0) + (cos _incomingAngle) * _source2dDistance,
					(_targetLocation select 1) + (sin _incomingAngle) * _source2dDistance,
					_sourceHeight + (_targetLocation select 2)];
					
	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_velocity", "_projectile", "_targetSourceDifference"];
		
		//Add some inaccurary...
		_targetLocationRandom = [ (_targetLocation select 0) + (random 2*_spreadRadial) - _spreadRadial,
								(_targetLocation select 1) + (random 2*_spreadRadial) - _spreadRadial,
								(_targetLocation select 2) + (random 2*_spreadNormal) - _spreadNormal
		];
		
		_targetSourceDifference =  (_targetLocationRandom vectorDiff _sourceLocation);
		_targetSourceDifference set [2, (_targetSourceDifference select 2) + _verticalOffset];
		_targetSourceDifference = vectorNormalized _targetSourceDifference;
		_velocity = [_projectileSpeed * (_targetSourceDifference select 0),_projectileSpeed * (_targetSourceDifference select 1),_projectileSpeed * (_targetSourceDifference select 2)];

		_projectile = _projectileClassName createVehicle [(_sourceLocation select 0),(_sourceLocation select 1),_sourceLocation select 2];
		_projectile setPosASL [(_sourceLocation select 0), (_sourceLocation select 1), (_sourceLocation select 2)];
		_projectile setVelocity _velocity;
		
		sleep (_minTimeBetween + random _maxRandomTime);
	};
};

INITIATE_AND_DROP_PROJECTILE_PAYLOAD = {
	if(!isserver) exitwith{};
	private ["_targetLocation", "_projectileSet", "_projectileSetCount", "_i"];
	//[targetLocationASL, [[className, numberToSend, spreadRadial, minTimeBetween, maxRandomTime],...]]
	_targetLocation = _this select 0;
	_projectileSet = _this select 1;
	_projectileSetCount = count _projectileSet;
	for "_i" from 0 to _projectileSetCount - 1 do{
		private "_projectiles";
		_projectiles = _projectileSet select _i;
		[_targetLocation, _projectiles] spawn DROP_PROJECTILES;
	};
};

DROP_PROJECTILES = {
	private ["_sourceHeight", "_targetLocation", "_projectiles", "_projectileClassName", "_numberToSend", "_spreadRadial", "_minTimeBetween", "_maxRandomTime"];
	_sourceHeight = 1000;
	
	_targetLocation = _this select 0;
	_projectiles = _this select 1;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_spreadRadial = _projectiles select 2;
	_minTimeBetween = _projectiles select 3;
	_maxRandomTime  = _projectiles select 4;
					
	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_velocity", "_projectile", "_targetSourceDifference"];
		
		//Add some inaccurary...
		_targetLocationRandom = [ (_targetLocation select 0) + (random 2*_spreadRadial) - _spreadRadial,
								(_targetLocation select 1) + (random 2*_spreadRadial) - _spreadRadial,
								_sourceHeight
		];
		
		_velocity = [0,0,-80];

		_projectile = _projectileClassName createVehicle _targetLocationRandom;
		_projectile setPosASL _targetLocationRandom;
		_projectile setVelocity _velocity;
		
		sleep (_minTimeBetween + random _maxRandomTime);
	};
};

INITIATE_AND_DROP_EVEN_PAYLOAD = {
	if(!isserver) exitwith{};
	private ["_targetLocation", "_projectileSet"];
	//[targetLocationASL, [[className, numberToSend, spreadRadial, minTimeBetween, maxRandomTime],...]]
	_targetLocation = _this select 0;
	//we aren't looping over projectiles with this one, so need to go one more step into the array
	_projectileSet = (_this select 1) select 0;
	
	[_targetLocation, _projectileSet] spawn EVEN_SPREAD_PROJECTILES;
};

EVEN_SPREAD_PROJECTILES = {
	private ["_sourceHeight", "_targetLocation", "_projectileClassNames", "_numberToSend", "_spreadRadial", "_sourceLocation", "_initialAngle", "_downwardSpeed"];
	_targetLocation = _this select 0;
	_projectileClassNames = (_this select 1) select 0;
	_spreadRadial = (_this select 1) select 1;
	_downwardSpeed = (_this select 1) select 2;
	_numberToSend = 12;
	_sourceHeight = (_targetLocation select 2) + ((_this select 1) select 3);
	
	_initialAngle = random 360;
	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_velocity", "_projectile", "_targetSourceDifference", "_loopRadius"];
		
		_targetLocationRandom = [0,0,0];
				
		if(_i < 3) then {
			_loopRadius = _spreadRadial / 2;
			_targetLocationRandom = [ (_targetLocation select 0) + cos(_initialAngle + 120*(_i)) * _loopRadius,
									(_targetLocation select 1) + sin(_initialAngle + 120*(_i)) * _loopRadius,
									_sourceHeight
									];
		} else {
			_loopRadius = _spreadRadial;
			_targetLocationRandom = [ (_targetLocation select 0) + cos(_initialAngle + 40*(_i-3)) * _loopRadius,
									(_targetLocation select 1) + sin(_initialAngle + 40*(_i-3)) * _loopRadius,
									_sourceHeight
									];
		};
			
		_velocity = [0,0,_downwardSpeed];

		_projectile = (_projectileClassNames call BIS_fnc_selectRandom) createVehicle _targetLocationRandom;
		_projectile setPosASL _targetLocationRandom;
		_projectile setVelocity _velocity;
		
	};
};

INITIATE_MISSILES_AND_BOMBS_PAYLOAD = {
	if(!isserver) exitwith{};
	private ["_targetLocation", "_projectileSet", "_projectileSetCount", "_i"];
	//[targetLocationASL, [[className, numberToSend, spreadRadial, minTimeBetween, maxRandomTime],...]]
	_targetLocation = _this select 0;
	_projectileSet = _this select 1;
	_projectileSetCount = count _projectileSet;
	for "_i" from 0 to _projectileSetCount - 1 do{
		private "_projectiles";
		_projectiles = _projectileSet select _i;
		[_targetLocation, _projectiles] spawn DROP_MISSILES_AND_BOMBS;
	};
};

DROP_MISSILES_AND_BOMBS = {
	private ["_sourceHeight", "_targetLocation", "_projectiles", "_projectileClassName", "_numberToSend", "_spreadRadial", "_minTimeBetween", "_maxRandomTime"];
	_sourceHeight = 1000;
	
	_targetLocation = _this select 0;
	_projectiles = _this select 1;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_spreadRadial = _projectiles select 2;
	_minTimeBetween = _projectiles select 3;
	_maxRandomTime  = _projectiles select 4;
					
	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_velocity", "_projectile", "_targetSourceDifference"];
		
		//Add some inaccurary...
		_targetLocationRandom = [ (_targetLocation select 0) + (random 2*_spreadRadial) - _spreadRadial,
								(_targetLocation select 1) + (random 2*_spreadRadial) - _spreadRadial,
								_sourceHeight
		];
		
		_velocity = [0,0,0];
		
		//Rockets just float if you don't give them an initial velocity
		if(_projectileClassName select [0,2] == "R_") then {
			_velocity = [0,0,-30];
		};
		
		_projectile = _projectileClassName createVehicle _targetLocationRandom;
		_projectile setPosASL _targetLocationRandom;
		_projectile setVectorDirAndUp  [[0,0,-1],[1,0,0]];
		_projectile setVelocity _velocity;
		
		sleep (_minTimeBetween + random _maxRandomTime);
	};
};

PARSE_AVAILABLE_JTAC_ATTACKS = {
	private ["_numJtacAttacks", "_jtackAttackI"];
	
	_bullets = [];
	_shells = [];
	_grenades = [];
	_bombs = [];
	_missiles = [];
	_nonlethal = [];
	
	jtacBulletsString = "";
	
	_numJtacAttacks = count availableJtacAttacks;
	for "_jtackAttackI" from 0 to _numJtacAttacks -1 do {
		private ["_currentAttack", "_attackType"];
		_currentAttack = availableJtacAttacks select _jtackAttackI;
		_attackType = _currentAttack select 0;
		if(_attackType == "BULLETS") then {
			_bullets set [ count _bullets, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else {	
			if(_attackType == "SHELLS") then {
				_shells set [ count _shells, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
			} else {		
				if(_attackType == "GRENADES") then {
					_grenades set [ count _grenades, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
				} else {		
					if(_attackType == "BOMBS") then {
						_bombs set [ count _bombs, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
					} else {	
						if(_attackType == "MISSILES") then {
						_missiles set [ count _missiles, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
						} else {
							if(_attackType == "NONLETHAL") then {
								_nonlethal set [ count _nonlethal, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
							} else {		
								diag_log format ["VirtualJTAC :::: Ignoring unknown payloadCategory for: %1",  _currentAttack];
							};
						};
					};
				};
			};
		};
	};
	
	_bulletsCount = count _bullets;
	JtacBulletMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _bullets select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacBulletMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
	
	_bulletsCount = count _shells;
	JtacShellMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _shells select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacShellMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
	
	_bulletsCount = count _grenades;
	JtacGrenadeMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _grenades select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacGrenadeMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
	
	_bulletsCount = count _bombs;
	JtacBombsMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _bombs select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacBombsMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
	
	_bulletsCount = count _missiles;
	JtacMissilesMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _missiles select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacMissilesMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
	
	_bulletsCount = count _nonlethal;
	JtacNonLethalMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		_currentBullet = _nonlethal select _bulletsI;
		_innerExpressionString = format ["[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, [" +
								format["%1", _currentBullet select 4] +
								format["]] call %1;'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacNonLethalMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};
};
