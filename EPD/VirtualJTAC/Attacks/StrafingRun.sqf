STRAFING_RUN_ROCKET = {
	if(!isserver) exitwith{};

	private _sourceHeight = 1300;

	private _targetLocation = _this select 0;
	private _incomingAngle = (_this select 1);
	private _projectiles = _this select 2;
	private _projectileClassName = _projectiles select 0;
	private _numberToSend = _projectiles select 1;
	private _distanceToStrafe = _projectiles select 2;
	private _source2dDistance = _projectiles select 3;
	private _pitch = _projectiles select 4;
	private _spread = _projectiles select 5;
	private _minTimeBetween = _projectiles select 6;
	private _maxRandomTime  = _projectiles select 7;

	private _distance = (vectorNormalized  [sin( _incomingAngle + 180), cos(_incomingAngle + 180), 0]) vectorMultiply _distanceToStrafe;
	private _distancePerRound = [(_distance select 0) / _numberToSend, (_distance select 1) / _numberToSend, (_distance select 2) / _numberToSend];

	private "_i";
	for "_i" from 0 to _numberToSend - 1 do {
		private _targetLocationRandom = _targetLocation vectorAdd ( _distancePerRound vectorMultiply _i);
		_targetLocationRandom = _targetLocationRandom vectorAdd [[-_spread, _spread] call BIS_fnc_randomNum, [-_spread, _spread] call BIS_fnc_randomNum, 0];

		private _sourceLocation = _targetLocationRandom getPos [_source2dDistance, _incomingAngle];
	    _sourceLocation set [2, _sourceHeight + (_targetLocationRandom select 2)];

		private _rocket = _projectileClassName createVehicle _sourceLocation;
		_rocket setPosASL  _sourceLocation;

		private _yaw = 180 + _incomingAngle;
		private _roll = 0;

		_rocket setDir(_yaw);
		[_rocket, _pitch, _roll] call BIS_fnc_setPitchBank;

		sleep (_minTimeBetween + random _maxRandomTime);
	};

};

STRAFING_RUN_PROJECTILE = {
	if(!isserver) exitwith{};

	private _sourceHeight = 982.1129;
	private _source2dDistance = 2000;
	private _projectileSpeed = 1000;
	
	private _targetLocation = _this select 0;
	private _incomingAngle = 180 + (_this select 1);
	private _projectiles = _this select 2;
	private _projectileClassName = _projectiles select 0;
	private _numberToSend = _projectiles select 1;
	private _verticalOffset = _projectiles select 2;
	private _distanceToStrafe = _projectiles select 3;
	private _spread = _projectiles select 4;
	private _minTimeBetween = _projectiles select 5;
	private _maxRandomTime  = _projectiles select 6;
	
	private _distance = (vectorNormalized  [sin( _incomingAngle), cos(_incomingAngle), 0]) vectorMultiply _distanceToStrafe;
	private _distancePerRound = [(_distance select 0) / _numberToSend, (_distance select 1) / _numberToSend, (_distance select 2) / _numberToSend];
	

	private "_i";
	for "_i" from 0 to _numberToSend - 1 do{
		
		private _targetLocationRandom = _targetLocation vectorAdd ( _distancePerRound vectorMultiply _i);
		_targetLocationRandom = _targetLocationRandom vectorAdd [[-_spread, _spread] call BIS_fnc_randomNum, [-_spread, _spread] call BIS_fnc_randomNum, 0];
	
		private _sourceLocation = _targetLocationRandom getPos [_source2dDistance, _incomingAngle];
	    _sourceLocation set [2, _sourceHeight + (_targetLocationRandom select 2)];
		
		private _targetSourceDifference =  (_targetLocationRandom vectorDiff _sourceLocation);
		_targetSourceDifference set [2, (_targetSourceDifference select 2) + _verticalOffset];
		_targetSourceDifference = vectorNormalized _targetSourceDifference;

		private _velocity = [_projectileSpeed * (_targetSourceDifference select 0),_projectileSpeed * (_targetSourceDifference select 1),_projectileSpeed * (_targetSourceDifference select 2)];

		private _projectile = _projectileClassName createVehicle [(_sourceLocation select 0),(_sourceLocation select 1),_sourceLocation select 2];
		_projectile setPosASL [(_sourceLocation select 0), (_sourceLocation select 1), (_sourceLocation select 2)];
		_projectile setVelocity _velocity;

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};