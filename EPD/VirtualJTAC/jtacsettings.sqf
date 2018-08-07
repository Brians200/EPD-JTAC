EPDJtacDebug = false;

/*
	["payloadCategory", "displayName", "acquireRate", "reloadTime", "projectileFiringMethod", [firing method parameters...]]
	
	payloadCategory - One of "BULLETS", "SHELLS", "GRENADES", "EXPLOSIVES", "CONCEALMENT". Determines which Jtac menu the payload will show up in.
	
	displayName - Name of the payload that will be presented to the operator.
	
	acquireRate - Speed at which the target is acquired. Smaller = faster

	reloadTime - Time until the guns can fire again.
	
	projectileFiringMethod - One of "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", "INITIATE_AND_DROP_PROJECTILE_PAYLOAD", "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", "INITIATE_AND_DROP_EVEN_PAYLOAD". Determines which method will be used to send the payload to the target.
	
		INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD - Traditional technique of sending a projectile at a target. Projectile will be spawned about 1.5km away and flung towards the target.
			parameters - [_projectileClassName, _verticalOffset, _numberToSend, _spreadRadial, _spreadNormal, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_verticalOffset - How many meters to aim up over the top of the target so it can hit the target.
				_numberToSend - How many projectiles to shoot.
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_spreadNormal - Height of vertical inaccuracy. Think aiming too high or low. Turns the inaccuracy circle into an oval.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.
				
		INITIATE_AND_DROP_PROJECTILE_PAYLOAD - Spawns the payload about 1km above the target and flings it down straight down.
			parameters - [_projectileClassName, _numberToSend, _spreadRadial, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many projectiles to shoot.
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.
			
		INITIATE_MISSILES_AND_BOMBS_PAYLOAD - Spawns the payload about 1km above the target and sets the orientation of the projectile to point straight down. Bombs and missiles have a tendendy to fly towards the direction they are facing otherwise.
			parameters - [_projectileClassName, _numberToSend, _spreadRadial, _minTimeBetween, _maxRandomTime]
				_projectileClassName - Classname of the projectile to use.
				_numberToSend - How many projectiles to shoot.
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_minTimeBetween - Minimum time between shots.
				_maxRandomTime  = A random value of up to this value is added to the _minTimeBetween variable to provide some variable time between shots.
				
		INITIATE_AND_DROP_EVEN_PAYLOAD - Similar to INITIATE_AND_DROP_PROJECTILE_PAYLOAD, except the number of items dropped is always 12. Create an evenly space inner triangle and an evenly space outer nonagon, randomly picking from the array of passed in classnames
			parameters - [[_projectileClassName, _projectileClassName,_projectileClassName,...], _spreadRadial, _downwardSpeed, _spawnHeight]
				_projectileClassName - Classname of the projectile to use. 1 or more of these can be passed in
				_spreadRadial - Radius of the horizontal inaccuracy. Projectiles can land anywhere in a circle of this radius around the target.
				_downwardSpeed - Initial downward velocity before gravity kicks in
				_spawnHeight - Height above the terran that the projectile will spawn
*/

availableJtacAttacks  = [
		["BULLETS", "20mm", .10, 60, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["B_20mm", 22, 20, 4, 2, .05, .05]],
		["BULLETS", "30mm HE", .12, 90, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["B_30mm_HE", 13.5, 15, 8, 2, .2, .2]],
		["BULLETS", "35mm AA", .14, 120, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["B_35mm_AA", 15.8, 10, 16, 5, .4, .4]],
		["BULLETS", "40mm GPR", .16, 150, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["B_40mm_GPR", 17.8, 6, 16, 5, .6, .6]],
		
		["SHELLS", "82mm AMOS", .18, 180, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["Sh_82mm_AMOS", 9.4, 5, 20, 5, 1, .5]],
		["SHELLS", "120mm HE", .20, 210, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["Sh_120mm_HE", 12.4, 3, 25, 8, 1, 1]],
		["SHELLS", "155mm AMOS", .22, 240, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["Sh_155mm_AMOS", 9.3, 2, 30, 10, 2, 1]],
		["SHELLS", "155mm CLUSTER", .24, 270, "INITIATE_AND_DROP_PROJECTILE_PAYLOAD", ["Cluster_155mm_AMOS", 1, 10, 0, 0]],
		
		["GRENADES", "20mm HE", .10, 60, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["G_20mm_HE", 29.8, 10, 16, 5, .5, .5]],
		["GRENADES", "40mm HE", .16, 150, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["G_40mm_HE", 29.8, 6, 18, 8, .5, 1]],
		["GRENADES", "40mm HEDP", .16, 150, "INITIATE_AND_SHOOT_PROJECTILE_PAYLOAD", ["G_40mm_HEDP", 29.8, 6, 18, 8, .5, 1]],
		
		["BOMBS", "250lb SDB", .40, 300, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["ammo_Bomb_SDB", 1, 7, 0, 0]],
		["BOMBS", "500lb GBU12", .44, 360, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["Bomb_03_F", 1, 10, 0, 0]],
		["BOMBS", "580lb Cluster", .48, 420, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["BombCluster_03_Ammo_F", 1, 10, 0, 0]],
		["BOMBS", "750lb Cluster", .52, 480, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["BombCluster_01_Ammo_F", 1, 10, 0, 0]], 
		["BOMBS", "1100lb Cluster", .56, 540, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["BombCluster_02_Ammo_F", 1, 10, 0, 0]],
		["BOMBS", "Cruise Missile Cluster", .60, 600, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["ammo_Missile_Cruise_01_Cluster", 1, 10, 0, 0]],
		
		["MISSILES", "Vorona 130mm HEAT", .40, 300, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["M_Vorona_HEAT", 6, 5, 2, 1]],
		["MISSILES", "RPG-42 75mm HE", .30, 420, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["R_TBG32V_F", 7, 15, 1, 1]],
		["MISSILES", "Vorona 130mm HE", .40, 480, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["M_Vorona_HE", 5, 24, 1, 2]],
		["MISSILES", "230mm HE", .50, 540, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["R_230mm_HE", 2, 27, 4, 2]],
		["MISSILES", "Cruise Missile", .60, 600, "INITIATE_MISSILES_AND_BOMBS_PAYLOAD", ["ammo_Missile_Cruise_01", 3, 35, 4, 1]],
		
		["NONLETHAL", "Red, White, and Blue", .10, 30, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["G_40mm_Smoke", "G_40mm_SmokeRed", "G_40mm_SmokeBlue"], 15, -0.1, 100]],
		["NONLETHAL", "White Wall Medium", .12, 60, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["Smoke_82mm_AMOS_White"], 15, -80, 1000]],
		["NONLETHAL", "White Wall Large", .14, 60, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["Smoke_120mm_AMOS_White"], 35, -80, 1000]],
		["NONLETHAL", "Flare Cloud", .10, 30, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["F_40mm_White", "F_40mm_Green", "F_40mm_Red", "F_40mm_Yellow"], 35, -0.1, 120]],
		["NONLETHAL", "Chem Lights", .10, 30, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["Chemlight_blue", "Chemlight_red", "Chemlight_yellow", "Chemlight_green"], 10, -0.1, 120]],
		["NONLETHAL", "Strobes", .10, 30, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["I_IRStrobe"], 15, -0.1, 120]],
		["NONLETHAL", "Night Signal", .10, 30, "INITIATE_AND_DROP_EVEN_PAYLOAD", [["Chemlight_blue", "G_40mm_Smoke"], 8, -0.1, 120]]
	];
	
	
	/** TODO: Mine fields? **/
