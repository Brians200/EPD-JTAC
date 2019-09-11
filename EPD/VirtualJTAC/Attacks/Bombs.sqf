DROP_BOMBS = {

	if(!isserver) exitwith{};

	private _sourceHeight = 1300;
	private _source2dDistance = 3919.25;

	private _targetLocation = _this select 0;
	private _incomingAngle = _this select 1;
	private _projectiles = _this select 2;
	private _projectileClassName = _projectiles select 0;
	private _numberToSend = _projectiles select 1;
	private _bombSpeed = _projectiles select 2;
	private _speedVariance = _projectiles select 3;
	private _spreadRadial = _projectiles select 4;
	private _minTimeBetween = _projectiles select 5;
	private _maxRandomTime  = _projectiles select 6;

	private _sourceLocation = _targetLocation getPos[_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	private "_i";
	for "_i" from 0 to _numberToSend - 1 do {
		private _spawnLocation = _sourceLocation getPos[_spreadRadial * sqrt random 1, random 360];
		_spawnLocation set [2, _sourceLocation select 2];

		private _targetSourceDifference =  (_targetLocation vectorDiff _sourceLocation);
        _targetSourceDifference set [2,0];

		_targetSourceDifference = vectorNormalized _targetSourceDifference;
		private _bomb = _projectileClassName createVehicle _spawnLocation;
		_bomb setPosASL  _spawnLocation;
		private _angle = 180 + _incomingAngle;
		_bomb setDir _angle;
		private _bombSpeedWithVariance = _bombSpeed + ([-_speedVariance, _speedVariance] call BIS_fnc_randomNum);
		private _velocity = [_bombSpeedWithVariance * (_targetSourceDifference select 0), _bombSpeedWithVariance * (_targetSourceDifference select 1),0];
		_bomb setVelocity _velocity;

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};