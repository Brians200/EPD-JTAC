if(isserver) then {
	//If true, allows you to skip the cool down.
	EPDJtacDebug = false;

	//The acquireRate for every fire mission will be multiplied by this much. Numbers bigger than 1 will increase it. Numbers between 0-1 will shorten it. Individual fire missions can be modified in the array below.
	EPDJtacAquisitionGlobalModifier = 1.0;

};

//The percent chance that a guided missile will fail and blow up in the air.
EPDJtacGuidedMissileExplosiveFailureChance = 5;

//The percent chance that a guided missile will lose tracking and just travel in a straight line.
EPDJtacGuidedMissileLostTrackingFailureChance = 5;

// [category, capacity, shortReloadTime, longReloadTime]
EPDJtacReloads = [
    ["BULLETS", 10, 30, 120],
    ["SHELLS", 10, 30, 225],
    ["STRAFINGRUN", 5, 30, 300],
    ["BOMBS", 4, 120, 300],
    ["ROCKETS", 3, 90, 300],
    ["GUIDEDMISSILE", 2, 60, 300],
    ["MINES", 5, 30, 600],
    ["NONLETHAL", 5, 30, 120]
];

/*
	["payloadCategory", "displayName", "acquireRate", "reloadTime", "projectileFiringMethod", [firing method parameters...]]
	
	payloadCategory - One of "BULLETS", "SHELLS", "GRENADES", "EXPLOSIVES", "CONCEALMENT". Determines which Jtac menu the payload will show up in.
	
	displayName - Name of the payload that will be presented to the operator.
	
	acquireRate - Seconds required to aquire a target.

	capacityUsed - The amount of the remaining capacity the attack will use. When the capacity is reached a long reload is triggered.
	
	projectileFiringMethod - One of "SHOOT_PROJECTILES", "DROP_BOMBS", "FIRE_ROCKETS", "EVEN_SPREAD_PROJECTILES", "STRAFING_RUN_ROCKET", "STRAFING_RUN_PROJECTILE", "LAY_MINE_FIELD". Determines which method will be used to send the payload to the target.
	
		SHOOT_PROJECTILES - Traditional technique of sending a projectile at a target. Projectile will be spawned about 2.2km away and flung towards the target.
			parameters - [_projectileClassName, _verticalOffset, _numberToSend, _spreadRadial, _spreadNormal, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many projectiles to shoot.
				_verticalOffset - How many meters to aim up over the top of the target so it can hit the target.
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_spreadNormal - Height of vertical inaccuracy. Think aiming too high or low. Turns the inaccuracy circle into an oval.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.

		DROP_BOMBS - Spawns the payload about 4.2km away. Sets the correct orientation and gives it a bit of velocity.
			parameters - [_projectileClassName, _numberToSend, _initialSpeed, _speedVariance, _spreadRadial, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many bombs to drop.
				_initialSpeed - How fast the bomb is going.
				_speedVariance - The speed of the bomb will be adjusted by up to this much. This will cause the bomb to undershoot or overshoot.
				_angleVariance - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.

		FIRE_ROCKETS - Spawns a missile. Sets the correct orientation and sets the correct model orientation.
			parameters - [_projectileClassName, _numberToSend, _horizontalDistance, _pitch, _pitchVariance, _yawVariance, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many rockets to fire.
				_horizontalDistance - How far away the missile spawns.
				_pitch - The pitch the model must be angled to to hit.
				_pitchVariance - How much the pitch can be varied, This will cause the missile to undershoot or overshoot.
				_yawVariance - How much the yaw can be varied, this will cause the missile to land to the left or right.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.

		STRAFING_RUN_ROCKET - Spawns a run of rockets.
			parameters - [_projectileClassName, _numberToSend, _horizontalDistance, _pitch, _pitchVariance, _yawVariance, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many rockets to fire.
				_distanceToStrafe - How far the run should go.
				_horizontalDistance - How far away the missile spawns.
				_pitch - The pitch the model must be angled to to hit.
				_spread - How many meters in each direction the rockets can land from their desired location.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.

		STRAFING_RUN_PROJECTILE - Spawns a run of projectiles.
			parameters - [_projectileClassName, _numberToSend, _horizontalDistance, _pitch, _pitchVariance, _yawVariance, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many rockets to fire.
				_verticalOffset - How many meters to aim up over the top of the target so it can hit the target.
				_distanceToStrafe - How far the run should go.
				_horizontalDistance - How far away the missile spawns.
				_spread - How many meters in each direction the rockets can land from their desired location.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.

		EVEN_SPREAD_PROJECTILES - Spawns 12 of the items randomly above the target and flings them down. Creates an evenly space inner triangle and an evenly space outer nonagon.
			parameters - [[_projectileClassName, _projectileClassName,_projectileClassName,...], _spreadRadial, _downwardSpeed, _spawnHeight]
				_projectileClassName - Classname of the projectile to use. 1 or more of these can be passed in.
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_downwardSpeed - Initial downward velocity before gravity kicks in.
				_spawnHeight - Height above the terran that the projectile will spawn.

		LAY_MINE_FIELD - Spawns a mine field.
			parameters - [[_mineClassName, _mineClassName,...], _numberToSend,  _spreadRadial]
				_projectileClassName - Classname of the projectile to use. 1 or more of these can be passed in.
				_numberToSend - How many mines to lay.
				_spreadRadial - How far the mines can spawn from the target.
*/

EPDJtacAvailableAttacks  = [
	["BULLETS", "20mm", 10, 2, "SHOOT_PROJECTILES", ["B_20mm", 20, 105.6, 4, 2, .05, .05]],
	["BULLETS", "20mm HE", 10, 2, "SHOOT_PROJECTILES", ["G_20mm_HE", 15, 177.1, 6, 5, .1, .1]],
	["BULLETS", "30mm HE", 12, 3, "SHOOT_PROJECTILES", ["B_30mm_HE", 15, 43.7, 8, 2, .2, .2]],
	["BULLETS", "40mm HEDP", 16, 4, "SHOOT_PROJECTILES", ["G_40mm_HEDP", 6, 177.1, 16, 5, .5, .6]],
	["BULLETS", "40mm HE", 16, 4, "SHOOT_PROJECTILES", ["G_40mm_HE", 6, 177.1, 18, 5, .5, .6]],

	["SHELLS", "82mm AMOS", 18, 3, "SHOOT_PROJECTILES", ["Sh_82mm_AMOS", 5, 23.9, 20, 5, 1, .5]],
	["SHELLS", "120mm HE", 20, 3, "SHOOT_PROJECTILES", ["Sh_120mm_HE", 3, 37.4, 25, 8, 1, 1]],
	["SHELLS", "155mm AMOS", 22, 7, "SHOOT_PROJECTILES", ["Sh_155mm_AMOS", 2, 23.9, 30, 10, 2, 1]],
	["SHELLS", "155mm CLUSTER", 24, 7, "SHOOT_PROJECTILES", ["Cluster_155mm_AMOS", 1, 23.9, 2, 2, 2, 1]],

	["STRAFINGRUN", "20mm - 50 meters", 12, 1, "STRAFING_RUN_PROJECTILE", ["B_20mm", 38, 105.6, 50, 4, .005, .005]],
	["STRAFINGRUN", "20mm - 100 meters", 15, 2, "STRAFING_RUN_PROJECTILE", ["B_20mm", 75, 105.6, 100, 4, .005, .005]],
	["STRAFINGRUN", "Dagger - 50 meters", 30, 2, "STRAFING_RUN_ROCKET", ["M_AT", 6, 50, 3000, -20.98, 6, .1, .2]],
	["STRAFINGRUN", "Dagger - 100 meters", 35, 3, "STRAFING_RUN_ROCKET", ["M_AT", 12, 100, 3000, -20.98, 6, .1, .2]],
	["STRAFINGRUN", "Shrieker HE - 50 meters", 30, 2, "STRAFING_RUN_ROCKET", ["Rocket_04_HE_F", 6, 50, 3000, -20.467, 6, .1, .2]],
	["STRAFINGRUN", "Shrieker HE - 100 meters", 35, 3, "STRAFING_RUN_ROCKET", ["Rocket_04_HE_F", 12, 100, 3000, -20.467, 6, .1, .2]],

	["BOMBS", "250lb SDB", 40, 1, "DROP_BOMBS", ["ammo_Bomb_SDB", 1, 250, 0.125, 2, 0, 0]],
	["BOMBS", "500lb GBU12", 44, 2, "DROP_BOMBS", ["Bomb_03_F", 1, 223.5, 1, 10, 0, 0]],
	["BOMBS", "580lb Cluster", 48, 4, "DROP_BOMBS", ["BombCluster_03_Ammo_F", 1, 212, 0.5, 10, 0, 0]],
	["BOMBS", "750lb Cluster", 52, 4, "DROP_BOMBS", ["BombCluster_01_Ammo_F", 1, 224, 0.5, 10, 0, 0]],
	["BOMBS", "1100lb Cluster", 56, 4, "DROP_BOMBS", ["BombCluster_02_Ammo_F", 1, 255, 0.5, 10, 0, 0]],
	["BOMBS", "Cruise Missile Cluster", 60, 4, "FIRE_ROCKETS", ["ammo_Missile_Cruise_01_Cluster", 1, 3911.5, -17.04, 0.1, 0.1, 0, 0]],

	["ROCKETS", "84mm MAAWS 44 HE", 30, 1, "DROP_BOMBS", ["R_MRAAWS_HE_F", 7, 295.7, 1, 15, 1, 1]],  //Special snowflake
	["ROCKETS", "Vorona 130mm HE", 40, 2, "FIRE_ROCKETS", ["M_Vorona_HE", 6, 1911.5, -28.99, 0.25, 0.25, 1, 2]],
	["ROCKETS", "230mm HE", 50, 3, "DROP_BOMBS", ["R_230mm_HE", 2, 240.55, 1, 25, .4, .2]],  //Special snowflake
	["ROCKETS", "Cruise Missile", 60, 3, "FIRE_ROCKETS", ["ammo_Missile_Cruise_01", 1, 3911.5, -17.04, 0.3, 0.3, 4, 1]],

	["GUIDEDMISSILE", "Titan AT", 15, 1, "FIRE_GUIDED_MISSILE", ["M_Titan_AT_long", "laser"]],
	["GUIDEDMISSILE", "Titan AT FnF", 15, 1, "FIRE_GUIDED_MISSILE", ["M_Titan_AT_long", "vehicle"]],

	["MINES", "APERS Mine", 30, 2, "LAY_MINE_FIELD", [["APERSMine"], 20, 20]],
	["MINES", "APERS Bounding Mine", 30, 2, "LAY_MINE_FIELD", [["APERSBoundingMine"], 20, 20]],
	["MINES", "APERS Mix", 40, 3, "LAY_MINE_FIELD", [["APERSMine", "APERSBoundingMine"], 20, 20]],
	["MINES", "Anti-Tank Mine", 30, 2, "LAY_MINE_FIELD", [["ATMine"], 20, 20]],
	["MINES", "SLAM Directional Mine", 30, 2, "LAY_MINE_FIELD", [["SLAMDirectionalMine"], 20, 20]],
	["MINES", "Anti-Vehicle Mix", 30, 3, "LAY_MINE_FIELD", [["ATMine", "SLAMDirectionalMine"], 20, 20]],
	["MINES", "Clear Mine Field", 30, 2, "EVEN_SPREAD_PROJECTILES", [["BombDemine_01_Ammo_F"], 20, -10, 200]],

	["NONLETHAL", "Red, White, and Blue", 10, 1, "EVEN_SPREAD_PROJECTILES", [["G_40mm_Smoke", "G_40mm_SmokeRed", "G_40mm_SmokeBlue"], 15, -0.1, 100]],
	["NONLETHAL", "White Wall Medium", 12, 1, "EVEN_SPREAD_PROJECTILES", [["Smoke_82mm_AMOS_White"], 15, -80, 1000]],
	["NONLETHAL", "White Wall Large", 14, 2, "EVEN_SPREAD_PROJECTILES", [["Smoke_120mm_AMOS_White"], 35, -80, 1000]],
	["NONLETHAL", "Flare Cloud", 10, 1, "EVEN_SPREAD_PROJECTILES", [["F_40mm_White", "F_40mm_Green", "F_40mm_Red", "F_40mm_Yellow"], 35, -0.1, 120]],
	["NONLETHAL", "Chem Lights", 10, 1, "EVEN_SPREAD_PROJECTILES", [["Chemlight_blue", "Chemlight_red", "Chemlight_yellow", "Chemlight_green"], 10, -0.1, 120]],
	["NONLETHAL", "Strobes", 10, 1, "EVEN_SPREAD_PROJECTILES", [["I_IRStrobe"], 15, -0.1, 120]],
	["NONLETHAL", "Night Signal", 10, 1, "EVEN_SPREAD_PROJECTILES", [["Chemlight_blue", "G_40mm_Smoke"], 8, -0.1, 120]]
];
