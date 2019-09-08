EVEN_SPREAD_PROJECTILES = {
	private ["_targetLocation", "_projectileClassNames", "_spreadRadial", "_downwardSpeed", "_numberToSend", "_sourceHeight", "_initialAngle", "_i"];

	if(!isserver) exitwith{};

	_initialAngle = random 360;
	_numberToSend = 12;

	_targetLocation = _this select 0;
	_projectileClassNames = (_this select 2) select 0;
	_spreadRadial = (_this select 2) select 1;
	_downwardSpeed = (_this select 2) select 2;
	_sourceHeight = (_targetLocation select 2) + ((_this select 2) select 3);

	for "_i" from 0 to _numberToSend - 1 do {
		private ["_targetLocationRandom", "_loopRadius", "_velocity", "_projectile"];
		_targetLocationRandom = [0,0,0];

		if(_i < 3) then {
			_loopRadius = _spreadRadial / 2;
			_targetLocationRandom = _targetLocation getPos[_loopRadius, _initialAngle + 120*_i];
			_targetLocationRandom set [2, _sourceHeight];
		} else {
			_loopRadius = _spreadRadial;
			_targetLocationRandom = _targetLocation getPos[_loopRadius, _initialAngle + 40*(_i-3)];
			_targetLocationRandom set [2, _sourceHeight];
		};

		_velocity = [0,0,_downwardSpeed];

		_projectile = (_projectileClassNames call BIS_fnc_selectRandom) createVehicle _targetLocationRandom;
		_projectile setPosASL _targetLocationRandom;
		_projectile setVelocity _velocity;
	};
};