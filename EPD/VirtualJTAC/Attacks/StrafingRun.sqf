STRAFING_RUN_ROCKET = {
	if(!isserver) exitwith{};

	_sourceHeight = 1300;

	_targetLocation = _this select 0;
	_incomingAngle = (_this select 1);
	_projectiles = _this select 2;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_distanceToStrafe = _projectiles select 2;
	_source2dDistance = _projectiles select 3;
	_pitch = _projectiles select 4;
	_spread = _projectiles select 5;
	_minTimeBetween = _projectiles select 6;
	_maxRandomTime  = _projectiles select 7;

	_distance = (vectorNormalized  [sin( _incomingAngle + 180), cos(_incomingAngle + 180), 0]) vectorMultiply _distanceToStrafe;
	_distancePerRound = [(_distance select 0) / _numberToSend, (_distance select 1) / _numberToSend, (_distance select 2) / _numberToSend];


	for "_i" from 0 to _numberToSend - 1 do {
		private ["_targetLocationRandom", "_velocity", "_rocket", "_targetSourceDifference", "_yaw", "_roll"];

		_targetLocationRandom = _targetLocation vectorAdd ( _distancePerRound vectorMultiply _i);
		_targetLocationRandom = _targetLocationRandom vectorAdd [[-_spread, _spread] call BIS_fnc_randomNum, [-_spread, _spread] call BIS_fnc_randomNum, 0];

		_sourceLocation = _targetLocationRandom getPos [_source2dDistance, _incomingAngle];
	    _sourceLocation set [2, _sourceHeight + (_targetLocationRandom select 2)];

		_rocket = _projectileClassName createVehicle _sourceLocation;
		_rocket setPosASL  _sourceLocation;

		_yaw = 180 + _incomingAngle;
		_roll = 0;

		_rocket setDir(_yaw);
		[_rocket, _pitch, _roll] call BIS_fnc_setPitchBank;

		sleep (_minTimeBetween + random _maxRandomTime);
	};

};

STRAFING_RUN_PROJECTILE = {
	private ["_targetLocation", "_endLocation", "_distance", "_incomingAngle", "_sourceHeight", "_source2dDistance", "_projectileSpeed", "_projectileClassName", "_verticalOffset", "_numberToSend", "_distanceToStrafe", "_spreadNormal", "_minTimeBetween", "_maxRandomTime", "_distancePerRound"];
	
	if(!isserver) exitwith{};

	_sourceHeight = 982.1129;
	_source2dDistance = 2000;
	_projectileSpeed = 1000;
	
	_targetLocation = _this select 0;
	_incomingAngle = 180 + (_this select 1);
	_projectiles = _this select 2;
	_projectileClassName = _projectiles select 0;
	_verticalOffset = _projectiles select 1;
	_numberToSend = _projectiles select 2;
	_distanceToStrafe = _projectiles select 3;
	_spread = _projectiles select 4;
	_minTimeBetween = _projectiles select 5;
	_maxRandomTime  = _projectiles select 6;
	
	_distance = (vectorNormalized  [sin( _incomingAngle), cos(_incomingAngle), 0]) vectorMultiply _distanceToStrafe;	
	
	_distancePerRound = [(_distance select 0) / _numberToSend, (_distance select 1) / _numberToSend, (_distance select 2) / _numberToSend];
	

					
	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_targetSourceDifference", "_velocity", "_projectile"];
		
		_targetLocationRandom = _targetLocation vectorAdd ( _distancePerRound vectorMultiply _i);
		_targetLocationRandom = _targetLocationRandom vectorAdd [[-_spread, _spread] call BIS_fnc_randomNum, [-_spread, _spread] call BIS_fnc_randomNum, 0];
	
		_sourceLocation = _targetLocationRandom getPos [_source2dDistance, _incomingAngle];
	    _sourceLocation set [2, _sourceHeight + (_targetLocationRandom select 2)];
		
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