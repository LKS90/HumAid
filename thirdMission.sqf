private["_taskPos", "_taskRot", "_this", "_enemyGroup", "_soldierGroup", "_soldierList", "_count", "_lzSmoke"];
_taskPos = getMarkerPos (_this select 0);
_enemyPos = getMarkerPos "t3_enemyMarker";
_taskRot = markerDir (_this select 0);
_rating = 0;
s_scienceGuy sideChat "All right, break time is over, NATO asked for our help. They have a reckon team stranded somewhere south east of here and they want you to pick them up. The location is marked on your map, they will drop a smoke grenade when you arrive.";
playSound "t3_start";
t_task3 setTaskState "Assigned";
t_task3 setSimpleTaskDestination _taskPos;
player setCurrentTask t_task3;
_enemyGroup = createGroup opfor;

_soldierGroup = createGroup blufor;
_civGroup setGroupID ["Soldier"];
_soldierList = ["B_recon_JTAC_F", "B_spotter_F", "B_sniper_F", "B_recon_medic_F"];
_enemyList = ["O_G_engineer_F", "O_G_medic_F", "O_G_officer_F", "O_G_Soldier_F"];

[composition1] execVM "deleteComp.sqf";
[composition2] execVM "deleteComp.sqf";
{deleteVehicle _x;} forEach g_ambientSmoke_t2;

{
	private ["_temp", "_x"];
	_temp = _soldierGroup createUnit [_x, _taskPos, [], 0, "FORM"];
	g_soldObj pushBack _temp;
} forEach _soldierList;

_lzSmoke = "SmokeshellBlue" createVehicle _taskPos;


_count = 0;
{
	private ["_x"];
	_x assignAsCargoIndex [s_heli, _count];
	[_x] joinSilent _soldierGroup;
	_count = (_count + 1);
} forEach (units _soldierGroup);

{
	private ["_posTmp", "_explosion", "_smoke"];
	_posTmp = getPosATL _x;
	_explosion = "Bo_GBU12_LGB_MI10" createVehicle _posTmp;
	_explosion setPosATL [_posTmp select 0, _posTmp select 1, (_posTmp select 2) + 10];
	_explosion setVelocity [0, 0, -10];
	_smoke = "test_EmptyObjectForFireBig" createVehicle _posTmp;
	_smoke setPosATL _posTmp;

} forEach g_ambientSmoke_t3;

waitUntil{taskThreeActive};
_lzSmoke setDamage 1;
_ambientHeli = createVehicle [
								"B_Heli_Light_01_armed_F",																	// Vehicle
								[(getMarkerPos "a_heliSpawn") select 0, (getMarkerPos "a_heliSpawn") select 1, 2000],		// Position
								[],																			// marker
								0,																							// placement Radius
								"FLY"																						// Special
							  ];
createVehicleCrew _ambientHeli;
_ambientHeli flyInHeight 50;
_ambientHeli move (getPosATL a_heliPad);

sleep 1;

_ambientHeli spawn{
	private ["_this"];
	while { ( (alive _this) && !(unitReady _this) ) } do
	{
		sleep 1;
	};

	if (alive _this) then
	{
		_this land "LAND";
	};
};
waitUntil{(((getPosATL s_heli) vectorDistance _taskPos) <= 50) and (((getPosATL s_heli) vectorDistance _taskPos) <= 50) and ((getPosATL s_heli) select 2 < 2);};
(units _soldierGroup) orderGetIn true;
_enemyPos = [
				(_taskPos select 0) + ((floor random 60) + 141),
				(_taskPos select 1) - ((floor random 60) + 141),
				(_taskPos select 2)
			];

{
	private ["_temp", "_x"];
	_temp = _enemyGroup createUnit [_x, _enemyPos, [], 0, "FORM"];
	g_enemObj pushBack _temp;
	
} forEach _enemyList;

_enemyGroup move _taskPos;

waitUntil {count (crew s_heli) > count (units _soldierGroup)};
saveGame;
((units _soldierGroup) select 0) globalChat "We are all in. Contacts close, let's go!";
((units _soldierGroup) select 0) say "t3_ready";
(units _enemyGroup) doTarget s_heli;
(units _enemyGroup) doFire s_heli;
t_task3 setSimpleTaskDestination (getPosATL s_t3_heliPad);


waitUntil {(s_heli distance (getPosATL s_t3_heliPad) <= 8) and ((getPosATL s_t3_heliPad) select 2 < 20);};

sleep 1.5;
{_rating = _rating + 400} forEach (units _soldierGroup);
((units _soldierGroup) select 0) globalChat "Thanks!";
((units _soldierGroup) select 0) say "t3_finished";
_soldierGroup leaveVehicle s_heli;
{deleteVehicle _x} forEach (units _soldierGroup);
sleep 1.5;

["TaskSucceeded",["","Search and Rescue"]] call BIS_fnc_showNotification;
t_task3 setTaskState "Succeeded";
player addRating _rating;
"End3" call BIS_fnc_endMission;