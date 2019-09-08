FIRE_ROCKETS = {
	private ["_incomingAngle", "_sourceHeight", "_targetLocation", "_projectiles", "_projectileClassName", "_numberToSend", "_source2dDistance", "_pitch", "_pitchVariance", "_yawVariance", "_minTimeBetween", "_maxRandomTime", "_sourceLocation", "_i"];

	if(!isserver) exitwith{};

	_incomingAngle = random 360;
	_sourceHeight = 1300;

	_targetLocation = _this select 0;
	_incomingAngle = _this select 1;
	_projectiles = _this select 2;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_source2dDistance = _projectiles select 2;
	_pitch = _projectiles select 3;
	_pitchVariance = _projectiles select 4;
	_yawVariance = _projectiles select 5;
	_minTimeBetween = _projectiles select 6;
	_maxRandomTime  = _projectiles select 7;

	_sourceLocation = _targetLocation getPos[_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	for "_i" from 0 to _numberToSend - 1 do {
		private ["_targetLocationRandom", "_velocity", "_rocket", "_targetSourceDifference", "_pitchRandom", "_yaw", "_roll"];

		_targetSourceDifference =  (_targetLocation vectorDiff _sourceLocation);
        _targetSourceDifference set [2,0];

		_targetSourceDifference = vectorNormalized _targetSourceDifference;

		_rocket = _projectileClassName createVehicle _sourceLocation;
		_rocket setPosASL  _sourceLocation;

		_yaw = 180 + _incomingAngle + ([-_yawVariance, _yawVariance] call BIS_fnc_randomNum);
		_roll = 0;
		_pitchRandom = _pitch + ([-_pitchVariance, _pitchVariance] call BIS_fnc_randomNum);

		_rocket setDir(_yaw);
		[_rocket, _pitchRandom, _roll] call BIS_fnc_setPitchBank;

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};