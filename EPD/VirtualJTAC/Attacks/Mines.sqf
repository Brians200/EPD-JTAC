ROTATE_PLACED_MINE = {
	private ["_mine", "_direction"];
	_mine = _this select 0;
	_direction = _this select 1;
	_mine setDir _direction;
};

LAY_MINE_FIELD = {
	private ["_targetLocation", "_mineClassNames", "_spreadRadial", "_numberToSend", "_i"];

	if(!isserver) exitwith{};

	_targetLocation = _this select 0;
	_targetLocation set [2, 0]; //mines belong on the ground
	_mineClassNames = (_this select 2) select 0;
	_numberToSend = (_this select 2) select 1;
	_spreadRadial = (_this select 2) select 2;

	for "_i" from 0 to _numberToSend - 1 do {
		private ["_mine", "_direction"];

		_mine = createMine [(_mineClassNames call BIS_fnc_selectRandom), _targetLocation, [], _spreadRadial];
		_direction = random 360;
		[_mine, _direction] remoteExec ["ROTATE_PLACED_MINE", 0, true];
		_mine setPos getPos _mine;
		//Add a little effect to the new mines so it is obvious they have landed.
		"CMflareAmmo" createVehicle getpos _mine;

		sleep (.1 + random .5);
	};
};