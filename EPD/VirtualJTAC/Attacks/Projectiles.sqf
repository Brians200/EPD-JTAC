SHOOT_PROJECTILES = {	
	private ["_incomingAngle", "_sourceHeight", "_source2dDistance", "_projectileSpeed", "_targetLocation", "_projectiles", "_projectileClassName", "_verticalOffset", "_numberToSend", "_spreadRadial", "_spreadNormal", "_minTimeBetween", "_maxRandomTime", "_sourceLocation", "_i"];

	if(!isserver) exitwith{};

	_sourceHeight = 982.1129;
	_source2dDistance = 2000;
	_projectileSpeed = 1000;

	_targetLocation = _this select 0;
	_incomingAngle = _this select 1;
	_projectiles = _this select 2;
	_projectileClassName = _projectiles select 0;
	_verticalOffset = _projectiles select 1;
	_numberToSend = _projectiles select 2;
	_spreadRadial = _projectiles select 3;
	_spreadNormal = _projectiles select 4;
	_minTimeBetween = _projectiles select 5;
	_maxRandomTime  = _projectiles select 6;

	_sourceLocation = _targetLocation getPos [_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	for "_i" from 0 to _numberToSend - 1 do {
		private ["_targetLocationRandom", "_targetSourceDifference", "_velocity", "_projectile", "_spreadNormalAmount"];

		//Add some inaccurary...
		_targetLocationRandom = _targetLocation getpos [_spreadRadial * sqrt random 1, random 360];
		_spreadNormalAmount = [-_spreadNormal, _spreadNormal] call BIS_fnc_randomNum;
		_targetLocationRandom set [2, (_targetLocation select 2) + _spreadNormalAmount];

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