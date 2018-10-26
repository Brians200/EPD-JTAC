FIRE_ROCKETS = {
	private ["_incomingAngle", "_sourceHeight", "_targetLocation", "_projectiles", "_projectileClassName", "_numberToSend", "_source2dDistance", "_pitch", "_pitchVariance", "_yawVariance", "_minTimeBetween", "_maxRandomTime", "_sourceLocation", "_i"];
	
	if(!isserver) exitwith{};
	
	_incomingAngle = random 360;
	_sourceHeight = 1300;

	_targetLocation = _this select 0;
	_projectiles = _this select 1;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_source2dDistance = _projectiles select 2;
	_pitch = _projectiles select 3;
	_pitchVariance = _projectiles select 4;
	_yawVariance = _projectiles select 5;
	_minTimeBetween = _projectiles select 6;
	_maxRandomTime  = _projectiles select 7;

	_sourceLocation = [ (_targetLocation select 0) + (cos _incomingAngle) * _source2dDistance,
					(_targetLocation select 1) + (sin _incomingAngle) * _source2dDistance,
					_sourceHeight + (_targetLocation select 2)];

	for "_i" from 0 to _numberToSend - 1 do{
		private ["_targetLocationRandom", "_velocity", "_rocket", "_targetSourceDifference", "_pitchRandom", "_yaw", "_roll"];

		_targetSourceDifference =  (_targetLocation vectorDiff _sourceLocation);
        _targetSourceDifference set [2,0];

		_targetSourceDifference = vectorNormalized _targetSourceDifference;

		_rocket = _projectileClassName createVehicle _sourceLocation;
		_rocket setPosASL  _sourceLocation;

		_yaw = 270 - _incomingAngle + (random (2*_yawVariance)) - _yawVariance;
		_roll = 0;
		_pitchRandom = _pitch + (random (2*_pitchVariance)) - _pitchVariance;
		_rocket setVectorDirAndUp [
			[ sin _yaw * cos _pitchRandom,cos _yaw * cos _pitchRandom,sin _pitchRandom],
			[ [ sin _roll,-sin _pitchRandom,cos _roll * cos _pitchRandom],-_yaw] call BIS_fnc_rotateVector2D
		];

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};