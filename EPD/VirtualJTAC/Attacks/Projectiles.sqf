SHOOT_PROJECTILES = {	

	if(!isserver) exitwith{};

	private _sourceHeight = 982.1129;
	private _source2dDistance = 2000;
	private _projectileSpeed = 1000;

	private _targetLocation = _this select 0;
	private _incomingAngle = _this select 1;
	private _projectiles = _this select 2;
	private _projectileClassName = _projectiles select 0;
	private _verticalOffset = _projectiles select 1;
	private _numberToSend = _projectiles select 2;
	private _spreadRadial = _projectiles select 3;
	private _spreadNormal = _projectiles select 4;
	private _minTimeBetween = _projectiles select 5;
	private _maxRandomTime  = _projectiles select 6;

	private _sourceLocation = _targetLocation getPos [_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetLocation select 2)];

	private "_i";
	for "_i" from 0 to _numberToSend - 1 do {
		//Add some inaccurary...
		private _targetLocationRandom = _targetLocation getpos [_spreadRadial * sqrt random 1, random 360];
		private _spreadNormalAmount = [-_spreadNormal, _spreadNormal] call BIS_fnc_randomNum;
		_targetLocationRandom set [2, (_targetLocation select 2) + _spreadNormalAmount];

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