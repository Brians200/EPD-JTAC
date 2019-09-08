FIRE_GUIDED_MISSILE = {
    private["_target", "_ammoClass", "_missilePosition", "_targetPosition", "_incomingAngle", "_sourceHeight", "_source2dDistance", "_sourceLocation", "_roll", "_missile", "_posDiff", "_dX", "_dY", "_dZ", "_yaw", "_pitch", "_oldYaw", "_oldPitch", "_missileWillExplode", "_missileExplosionDistance", "_guidanceWillFail", "_guidanceFailureDistance"];
    _target = _this select 0;
    _incomingAngle = _this select 1;
    _ammoClass = _this select 2;

    _sourceHeight = 600;
    _source2dDistance = 1000;

	_targetPosition = eyePos _target;

	_sourceLocation = _targetPosition getPos[_source2dDistance, _incomingAngle];
	_sourceLocation set [2, _sourceHeight + (_targetPosition select 2)];

    _missile = createVehicle[_ammoClass, _sourceLocation, [], 0, "NONE"];
    //player attachTo[_missile, [2,-6,-1]];
    _missilePosition = visiblePositionASL _missile;

    _posDiff = _targetPosition vectorDiff _missilePosition;
    _dX = _posDiff select 0;
    _dY = _posDiff select 1;
    _dZ = _posDiff select 2;

    _yaw = _dX atan2 _dY;
	_yaw = (_yaw + 360) % 360;
	 _oldYaw = _yaw;

    _pitch = 90 - (sqrt(_dX * _dX + _dY * _dY) atan2 _dZ);
	_oldPitch = _pitch;

	_roll = 0;

	_missile setDir(_yaw);
    [_missile, _pitch, _roll] call BIS_fnc_setPitchBank;

    sleep 0.01;

	_missileWillExplode = false;
	_missileExplosionDistance = 0;
	if (EPDJtacGuidedMissileExplosiveFailureChance > random 100) then {
		_missileWillExplode = true;
		_missileExplosionDistance = 200 + random 50;
	};

	_guidanceWillFail = false;
	_guidanceFailureDistance = 0;

	if (not _missileWillExplode and EPDJtacGuidedMissileLostTrackingFailureChance > random 100) then {
		_guidanceWillFail = true;
		_guidanceFailureDistance = 150 + random 400;
	};

    while { not(isNull _missile) } do {
        private["_yawDiff", "_pitchDiff", "_missileVelocity", "_currentPositionDiff"];

		if (isNull _target) exitWith { hint "Target Lost. Guidance turned off"};

        _missilePosition = visiblePositionASL _missile;
        _targetPosition = eyePos _target;

		_currentPositionDiff = _missilePosition vectorDistance _targetPosition;

		if (_missileWillExplode and _currentPositionDiff < _missileExplosionDistance) exitWith {
			private ["_bomb"];
			_bomb = "IEDUrbanSmall_Remote_Ammo" createVehicle getPos _missile;
			_bomb setDamage 1;
			sleep .1;
			"HelicopterExploBig" createVehicle (getpos _missile);
			sleep .2;
			"HelicopterExploSmall" createVehicle (getpos _missile);
			sleep .1;
			"HelicopterExploBig" createVehicle (getpos _missile);
			sleep .05;
			"HelicopterExploSmall" createVehicle (getpos _missile);
			sleep .03;
			"HelicopterExploBig" createVehicle (getpos _missile);
			sleep .01;
			"HelicopterExploBig" createVehicle (getpos _missile);
			_bomb = "IEDUrbanBig_Remote_Ammo" createVehicle getPos _missile;
			deleteVehicle _missile;
			_bomb setDamage 1;

			hint "The missile malfunctioned!"
		};

		if (_guidanceWillFail and _currentPositionDiff < _guidanceFailureDistance) exitWith {
			hint "The missile's guidance failed!"
		};

        if (speed _target > 0) then {
            private["_targetPositionMultiplier", "_velocity"];
            // Rough first order integration to predict where the target is going to be when the missile hits.
            // This allows the missile to attempt to meet the target at that point, rather than trying to play catch up.
            _velocity = velocity _target;
            _targetPositionMultiplier = 0.95 * _currentPositionDiff / vectorMagnitude(velocity _missile vectorDiff _velocity);
            _targetPosition = _targetPosition vectorAdd(_velocity vectorMultiply _targetPositionMultiplier);
        };

        _posDiff = _targetPosition vectorDiff _missilePosition;
        _dX = _posDiff select 0;
        _dY = _posDiff select 1;
        _dZ = _posDiff select 2;

        _yaw = _dX atan2 _dY;
		_yaw = (_yaw + 360) % 360;

		_yawDiff = ( _yaw - _oldyaw + 180 ) % 360 - 180;
		if (_yawDiff < -180) then {
			_yawDiff = _yawDiff + 360;
		};

        if (_yawDiff * _yawDiff > 4.0) then {
            //hint "Yaw limiter active";
            if (_yawDiff > 0) then {
                _yaw = _oldYaw + 2.0;
            } else {
                _yaw = _oldYaw - 2.0;
            };
        };

		_pitch = 90 - (sqrt(_dX * _dX + _dY * _dY) atan2 _dZ);
        _pitchDiff = _pitch - _oldPitch;

        if (_pitchDiff * _pitchDiff > 4.0) then {
            if (_pitchDiff > 0) then {
                _pitch = _oldPitch + 2.0;
            } else {
                _pitch = _oldPitch - 2.0;
            };
        };

        _missile setDir(_yaw);
        [_missile, _pitch, 0] call BIS_fnc_setPitchBank;

        _oldPitch = _pitch;
        _oldYaw = _yaw;

        sleep 0.1;
    };
	
};