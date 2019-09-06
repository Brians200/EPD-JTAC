DROP_BOMBS = {
	private ["_incomingAngle", "_sourceHeight", "_source2dDistance", "_targetLocation", "_projectiles", "_projectileClassName", "_numberToSend", "_bombSpeed", "_speedVariance", "_spreadRadial", "_minTimeBetween", "_maxRandomTime", "_sourceLocation", "_i"];
	
	if(!isserver) exitwith{};
	
	_incomingAngle = random 360;
	_sourceHeight = 1300;
	_source2dDistance = 3919.25;
	
	_targetLocation = _this select 0;
	_projectiles = _this select 1;
	_projectileClassName = _projectiles select 0;
	_numberToSend = _projectiles select 1;
	_bombSpeed = _projectiles select 2;
	_speedVariance = _projectiles select 3;
	_spreadRadial = _projectiles select 4;
	_minTimeBetween = _projectiles select 5;
	_maxRandomTime  = _projectiles select 6;

	_sourceLocation = _targetLocation getPos[_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	for "_i" from 0 to _numberToSend - 1 do{
		private ["_spawnLocation", "_targetSourceDifference", "_bomb", "_angle", "_velocity", "_bombSpeedWithVariance"];

		_spawnLocation = _sourceLocation getPos[_spreadRadial * sqrt random 1, random 360];
		_spawnLocation set [2, _sourceLocation select 2];

		_targetSourceDifference =  (_targetLocation vectorDiff _sourceLocation);
        _targetSourceDifference set [2,0];

		_targetSourceDifference = vectorNormalized _targetSourceDifference;
		_bomb = _projectileClassName createVehicle _spawnLocation;
		_bomb setPosASL  _spawnLocation;
		_angle = 180 + _incomingAngle;
		_bomb setDir _angle;
		_bombSpeedWithVariance = _bombSpeed + ([-_speedVariance, _speedVariance] call BIS_fnc_randomNum);
		_velocity = [_bombSpeedWithVariance * (_targetSourceDifference select 0), _bombSpeedWithVariance * (_targetSourceDifference select 1),0];
		_bomb setVelocity _velocity;

		sleep (_minTimeBetween + random _maxRandomTime);
	};
};