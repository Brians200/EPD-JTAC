PARSE_AVAILABLE_JTAC_ATTACKS = {
	private ["_numJtacAttacks", "_jtackAttackI", "_bullets", "_shells", "_grenades", "_bombs", "_rockets", "_mines", "_nonlethal", "_bulletsCount", "_keyNumber", "_guidedMissiles"];

	_bullets = [];
	_shells = [];
	_grenades = [];
	_bombs = [];
	_rockets = [];
	_guidedMissiles = [];
	_mines = [];
	_nonlethal = [];
	
	_numJtacAttacks = count availableJtacAttacks;
	for "_jtackAttackI" from 0 to _numJtacAttacks -1 do {
		private ["_currentAttack", "_attackType"];
		_currentAttack = availableJtacAttacks select _jtackAttackI;
		_attackType = _currentAttack select 0;
		if(_attackType == "BULLETS") then {
			_bullets set [ count _bullets, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "SHELLS") then {
			_shells set [ count _shells, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "GRENADES") then {
			_grenades set [ count _grenades, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "BOMBS") then {
			_bombs set [ count _bombs, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "ROCKETS") then {
				_rockets set [ count _rockets, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "GUIDEDMISSILE") then {
			_guidedMissiles set [ count _guidedMissiles, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "MINES") then {
			_mines set [ count _mines, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else { if(_attackType == "NONLETHAL") then {
			_nonlethal set [ count _nonlethal, [_currentAttack select 1, _currentAttack select 2, _currentAttack select 3, _currentAttack select 4, _currentAttack select 5]];
		} else {
			diag_log format ["VirtualJTAC :::: Ignoring unknown payloadCategory for: %1",  _currentAttack];
		};};};};};};};};
	};
	
	JtacMainMenu = [
		["EPD JTAC", true]
	];
	_keyNumber = 2;

	_bulletsCount = count _bullets;
	JtacBulletMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _bullets select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacBulletMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacBulletMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Bullets", [_keyNumber], "#USER:JtacBulletMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _shells;
	JtacShellMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _shells select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacShellMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacShellMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Shells", [_keyNumber], "#USER:JtacShellMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _grenades;
	JtacGrenadeMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _grenades select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacGrenadeMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacGrenadeMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Grenades", [_keyNumber], "#USER:JtacGrenadeMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _bombs;
	JtacBombsMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _bombs select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacBombsMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacBombsMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Bombs", [_keyNumber], "#USER:JtacBombsMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _rockets;
	JtacRocketsMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _rockets select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacRocketsMenu set [_bulletsI + 1,
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacRocketsMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Rocket Barrage", [_keyNumber], "#USER:JtacRocketsMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};
	
	_bulletsCount = count _guidedMissiles;
	JtacGuidedMissilesMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _guidedMissiles select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"_this select 0, " +
								format["""%1""", _currentBullet select 4 select 0] +
								format["] call %1;'], '%2'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3, _currentBullet select 4 select 1];
		JtacGuidedMissilesMenu set [_bulletsI + 1,
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacGuidedMissilesMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Guided Missiles", [_keyNumber], "#USER:JtacGuidedMissilesMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _mines;
	JtacMinesMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _mines select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacMinesMenu set [_bulletsI + 1,
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacMinesMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Mine Field", [_keyNumber], "#USER:JtacMinesMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};

	_bulletsCount = count _nonlethal;
	JtacNonLethalMenu = [["JTAC Bullets", true]];
	for "_bulletsI" from 0 to _bulletsCount -1 do {
		private ["_currentBullet", "_innerExpressionString"];
		_currentBullet = _nonlethal select _bulletsI;
		_innerExpressionString = format ["[[%1, %2,'[", _currentBullet select 1, _currentBullet select 2] +
								"%1, " +
								format["%1", _currentBullet select 4] +
								format["] call %1;'], 'average'] call CLIENT_REQUEST_PERMISSION_TO_FIRE;", _currentBullet select 3];
		JtacNonLethalMenu set [_bulletsI + 1, 
			[_currentBullet select 0, [_bulletsI + 2], "", -5, [["expression", _innerExpressionString]], "1", "1"]
		];
	};

	if (count JtacNonLethalMenu > 1) then {
		JtacMainMenu = JtacMainMenu + [["Non Lethal", [_keyNumber], "#USER:JtacNonLethalMenu", -5, [["expression", ""]], "1", "1"]];
		_keyNumber = _keyNumber + 1;
	};
};
