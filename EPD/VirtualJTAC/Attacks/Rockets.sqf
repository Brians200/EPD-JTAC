FIRE_ROCKETS = {
	if(!isserver) exitwith{};

	private _sourceHeight = 1300;

	private _targetLocation = _this select 0;
	private _incomingAngle = _this select 1;
	private _projectiles = _this select 2;
	private _projectileClassName = _projectiles select 0;
	private _numberToSend = _projectiles select 1;
	private _source2dDistance = _projectiles select 2;
	private _pitch = _projectiles select 3;
	private _pitchVariance = _projectiles select 4;
	private _yawVariance = _projectiles select 5;
	private _minTimeBetween = _projectiles select 6;
	private _maxRandomTime  = _projectiles select 7;

	private _sourceLocation = _targetLocation getPos[_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	private "_i";
	for "_i" from 0 to _numberToSend - 1 do {
		private _rocket = _projectileClassName createVehicle _sourceLocation;
		_rocket setPosASL  _sourceLocation;

		private _yaw = 180 + _incomingAngle + ([-_yawVariance, _yawVariance] call BIS_fnc_randomNum);
		private _roll = 0;
		private _pitchRandom = _pitch + ([-_pitchVariance, _pitchVariance] call BIS_fnc_randomNum);

		_rocket setDir(_yaw);
		[_rocket, _pitchRandom, _roll] call BIS_fnc_setPitchBank;

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};