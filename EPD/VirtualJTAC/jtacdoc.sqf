if(! (player diarySubjectExists "EPDJTAC")) then {
	player createDiarySubject ["EPDJTAC", "EPD JTAC"];
};

player createDiaryRecord ["EPDJTAC", ["JTAC Night", "
The JTAC operator can still be useful at night by illuminating targets with flares, chemlights, and IR strobes.<br/><br/>

Flare Cloud - Launches flares around the target.<br/>
Radial Spread: 35m<br/><br/>

Chem Lights - Launches chem lights around the target.<br/>
Radial Spread: 10m<br/><br/>

Stobes - Launches strobe lights around the target.<br/>
Radial Spread: 15m<br/><br/>

Night Signal - Creates a smoke signal that is visible at night.<br/>
Radial Spread: 8m<br/><br/>

"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Smoke", "
The JTAC operator can fire a wide variety of smoke for signaling and concealment.<br/><br/>

White Smoke - 2 white smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Blue Smoke - 2 blue smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Green Smoke - 2 green smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Orange Smoke - 2 range smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Purple Smoke - 2 purple smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Red Smoke - 2 red smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Yellow Smoke - 2 yellow smoke grenades (can bounce). <br/>
Radial Spread: 5m<br/>
Orthogonal Spread: 5m<br/><br/>

Small Cloud - Creates small, party sized smoke wall.<br/>
Radial Spread: 15m<br/><br/>

Medium Cloud - Creates medium sized smoke wall.<br/>
Radial Spread: 15m<br/><br/>

Large cloud - Creates large sized smoke wall.<br/>
Radial Spread: 35m<br/><br/>

"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Mines", "
The JTAC operator can lay a wide variety of mine fields.<br/><br/>

APERS Mine - A classic pressure-activated anti-personnel mine. These are anti-personnel mines which also do a good job of destroying the tires of wheeled vehicles which drive over them. They detonate once someone steps within half a meter of their position. Detonation is immediate and not always fatal. <br/>
Radial Spread: 20m<br/>
Number of Mines: 20<br/><br/>

APERS Bounding Mine - The anti-personnel bounding mine is best suitable for open areas. When triggered, there is a delay of ~1 second after which a charge launches the body of the mine one meter into the air. The explosion covers a close area with fragments, killing the whole group.<br/>
Radial Spread: 20m<br/>
Number of Mines: 20<br/><br/>

APERS Mix - Lays a random mixture of APERS and APERS Bounding mines.<br/>
Radial Spread: 20m<br/>
Number of Mines: 20<br/><br/>

Anti-Tank Mine - The design of anti-tank mines has not changed much during the last 50 years. An AT mine is the strongest ground mine manufactured today. They are triggered only by vehicles.<br/>
Radial Spread: 20m<br/>
Number of Mines: 20<br/><br/>

SLAM Directional Mine - The M6 SLAM mine is a next generation Selectable Lightweight Attack Munition. They are very effective against light armored vehicles, penetrating 40 mm armor from up to eight meters. Unlike dug-in mines, SLAM is placed on the ground and is easier to spot.<br/>
Radial Spread: 20m<br/>
Number of Mines: 20<br/><br/>

Anti-Vehicle Mix - Lays a random mixture of Anti-Tank Mine and SLAM mines.<br/>
Radial Spread: 20m<br/><br/>

Clear Mine Field - Attempts to clear out an area of mines by dropping 12 perfectly spaced demining charges on the area. 3 charges will form a triangle in the middle and 9 more charges will form a ring around it.<br/>
Radial Spread: 20m<br/><br/>
"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Guided Missiles", "
The JTAC operator can fire a wide variety of guided missiles.<br/><br/>

Titan AT<br/>
Calls in a Titan AT missile that will adjust its flight path to hit where ever you are currenting aiming the laser designator.<br/>
Number of Rounds: 1<br/>
Target Acquisition Time: 15 seconds<br/><br/>

Titan AT FnF<br/>
Calls in a Titan AT missile in a fire and forget mode. Missile will automatically track the vehicle that it was locked on.<br/>
Number of Rounds: 1<br/>
Target Acquisition Time: 15 seconds<br/><br/>

"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Rocket Barrage", "
The JTAC operator can fire a wide variety of rocket barrages.<br/><br/>

84mm MAAWS 44 HE<br/>
Number of Rounds: 7<br/>
Radial Spread: 15m<br/>
Target Acquisition Time: 30 seconds<br/><br/>

Vorona 130mm HE<br/>
Number of Rounds: 6<br/>
Radial Spread: 24<br/>
Target Acquisition Time: 40 seconds<br/><br/>

230mm HE<br/>
Number of Rounds: 2<br/>
Radial Spread: 25m<br/>
Target Acquisition Time: 50 seconds<br/><br/>

Cruise Missile<br/>
Number of Rounds: 1<br/>
Radial Spread: 35m<br/>
Target Acquisition Time: 60 seconds<br/><br/>

"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Bombs", "
The JTAC operator can fire a wide variety of bombs.<br/><br/>

250lb SDB<br/>
Number of Rounds: 1<br/>
Radial Spread: 7m<br/>
Target Acquisition Time: 40 seconds<br/><br/>

500lb GBU12<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 44 seconds<br/><br/>

580lb Cluster<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 48 seconds<br/><br/>

750lb Cluster<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 52 seconds<br/><br/>

1100lb Cluster<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 56 seconds<br/><br/>

Cruise Missile Cluster<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 60 seconds<br/><br/>

"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Strafing Run", "
The JTAC operator can fire a wide variety of strafing runs.<br/><br/>

20mm - 50 meters<br/>
Number of Rounds: 38<br/>
Run Distance: 50 meters<br/>
Target Acquisition Time: 12 seconds<br/><br/>

20mm - 100 meters<br/>
Number of Rounds: 75<br/>
Run Distance: 100 meters<br/>
Target Acquisition Time: 15 seconds<br/><br/>

Dagger - 50 meters<br/>
Number of Rockets: 6<br/>
Run Distance: 50 meters<br/>
Target Acquisition Time: 30 seconds<br/><br/>

Dagger - 100 meters<br/>
Number of Rockets: 12<br/>
Run Distance: 100 meters<br/>
Target Acquisition Time: 35 seconds<br/><br/>

Shrieker HE - 50 meters<br/>
Number of Rockets: 6<br/>
Run Distance: 50 meters<br/>
Target Acquisition Time: 30 seconds<br/><br/>

Shrieker HE - 100 meters<br/>
Number of Rockets: 12<br/>
Run Distance: 100 meters<br/>
Target Acquisition Time: 35 seconds<br/><br/>
"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Shells", "
The JTAC operator can fire a wide variety of shells.<br/><br/>
Radial spread is how far from the target the shells can land, forming a circle. <br/>
Orthogonal spread is how far the center of the circle can be moved in the direction the guns are firing from, forming an oval. <br/><br/>

82mm AMOS<br/>
Number of Rounds: 5<br/>
Radial Spread: 20m<br/>
Orthogonal Spread: 5m<br/>
Target Acquisition Time: 18 seconds<br/><br/>

120mm HE<br/>
Number of Rounds: 3<br/>
Radial Spread: 25m<br/>
Orthogonal Spread: 8m<br/>
Target Acquisition Time: 20 seconds<br/><br/>

155mm AMOS<br/>
Number of Rounds: 2<br/>
Radial Spread: 30m<br/>
Orthogonal Spread: 10m<br/>
Target Acquisition Time: 22 seconds<br/><br/>

155mm CLUSTER<br/>
Number of Rounds: 1<br/>
Radial Spread: 10m<br/>
Target Acquisition Time: 24 seconds<br/><br/>
"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Bullets", "
The JTAC operator can fire a wide variety of bullets.<br/><br/>
Radial spread is how far from the target the bullets can land, forming a circle. <br/>
Orthogonal spread is how far the center of the circle can be moved in the direction the guns are firing from, forming an oval. <br/><br/>

20mm<br/>
Number of Rounds: 20<br/>
Radial Spread: 4m<br/>
Orthogonal Spread: 2m<br/>
Target Acquisition Time: 10 seconds<br/><br/>

20mm HE<br/>
Number of Rounds: 15<br/>
Radial Spread: 6m<br/>
Orthogonal Spread: 5m<br/>
Target Acquisition Time: 10 seconds<br/><br/>

30mm HE<br/>
Number of Rounds: 15<br/>
Radial Spread: 8m<br/>
Orthogonal Spread: 2m<br/>
Target Acquisition Time: 12 seconds<br/><br/>

40mm HEDP<br/>
Number of Rounds: 6<br/>
Radial Spread: 16m<br/>
Orthogonal Spread: 5m<br/>
Target Acquisition Time: 16 seconds<br/><br/>

40mm HE<br/>
Number of Rounds: 6<br/>
Radial Spread: 18m<br/>
Orthogonal Spread: 5m<br/>
Target Acquisition Time: 16 seconds<br/><br/>
"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Reloading", "
The guns for each category will be able to fire a few times with a short reload in between before a long reload will occur while they gather more ammo. The stronger attacks you used, the quicker the guns will need to perform a long reload. Each attack category has its own reloading times. You can check the reload status of all the guns in the JTAC menu.<br/>
<br/>
The reload times for each category are:<br/>
Bullets<br/>
Short: 30 seconds<br/>
Long: 120 seconds<br/>
<br/>
Shells<br/>
Short: 30 seconds<br/>
Long: 225 seconds<br/>
<br/>
Strafing Run<br/>
Short: 30 seconds<br/>
Long: 300 seconds<br/>
<br/>
Bombs<br/>
Short: 120 seconds<br/>
Long: 300 seconds<br/>
<br/>
Rockets<br/>
Short: 90 seconds<br/>
Long: 120 seconds<br/>
<br/>
Guided Missile<br/>
Short: 60 seconds<br/>
Long: 120 seconds<br/>
<br/>
Mines<br/>
Short: 30 seconds<br/>
Long: 300s seconds<br/>
<br/>
Smoke<br/>
Short: 20 seconds<br/>
Long: 120 seconds<br/>
<br/>
Night<br/>
Short: 30 seconds<br/>
Long: 120 seconds<br/>
<br/>
"]];

player createDiaryRecord ["EPDJTAC", ["JTAC Operator", "
You are the Joint Terminal Attack Controller. It is your job to provide support to your team in the form of close air and artillery support. Make sure you bring a laser designator and batteries so you can call in support with the JTAC menu. Information about each attack capability is included in your diary. <br/><br/>
The location the guns will aim at is the average location of your laser pointer while it is acquiring a target, so be sure to hold the laser as close to the target as possible the entire time! <br/><br/>
Once the target location has been acquired, you will be notified that the rounds are inbound. It is safe to turn off your laser and run for cover at this point. <br/><br/>
After each attack, the guns will need time to reload. The time it takes to reload will depend on the size of the ammunition fired. <br/><br/>
The guns are shared between all JTAC operators and if another JTAC operator fires, you will have to wait for the guns to reload before you can fire. The more damage an attack does, the longer it will take for the target to be locked in. Be smart about what you are firing and when.
"]];