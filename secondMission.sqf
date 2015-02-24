private["_taskPos", "_taskRot", "_this", "_ambientSmoke", "_civGroup", "_civList", "_count"];
_taskPos = getMarkerPos (_this select 0);
_taskRot = markerDir (_this select 0);
_rating = 0;

saveGame;
t_task2 setTaskState "Assigned";
t_task2 setSimpleTaskDestination _taskPos;
player setCurrentTask t_task2;
[composition2, _taskPos, _taskRot] execVM "moveComp.sqf";

_civGroup = createGroup civilian;
_civGroup setGroupID ["Refugee"];
_civList = ["C_Orestes", "C_Nikos", "C_man_shorts_4_F_euro", "C_man_p_beggar_F", "C_man_polo_5_F_euro", "C_man_polo_6_F"];

{
	private ["_temp", "_x"];
	_temp = _civGroup createUnit [_x, _taskPos, [], 0, "NONE"];
	[_temp] join _civGroup;
	g_civObj pushBack _temp;
} forEach _civList;

_count = 0;
{
	private ["_x"];
	_x assignAsCargoIndex [s_heli, _count];
	_count = (_count + 1);
} forEach (units _civGroup);

// Wait for the player to arrive
	waitUntil{((s_heli distance _taskPos) <= 50) and ((getPosATL s_heli) select 2 < 2);};

sleep 4;

(units _civGroup) orderGetIn true;

waitUntil {count (crew s_heli) > count (units _civGroup)};
saveGame;
((units _civGroup) select 0) sideChat "Okay, I think that's all of us.";
((units _civGroup) select 0) say "t2_ready";
t_task2 setSimpleTaskDestination (getPosATL s_heliPad);
	
waitUntil {(s_heli distance (getPosATL s_heliPad) <= 8) and ((getPosATL s_heli) select 2 < 20);};

sleep 1.5;
{_rating = _rating + 240} forEach (units _civGroup);
((units _civGroup) select 0) sideChat "Thanks man!";
((units _civGroup) select 0) say "t2_finished";
_civGroup leaveVehicle s_heli;
{deleteVehicle _x} forEach (units _civGroup);

["TaskSucceeded",["","Rescue Refugees"]] call BIS_fnc_showNotification;
t_task2 setTaskState "Succeeded";
player addRating _rating;
titleCut ["", "BLACK OUT", 3];
cutText ["7:10 - NATO requests help", "BLACK FADED"];
sleep 3;
skipTime (6.166666 - daytime + 24 ) % 24;
titleCut ["", "BLACK IN", 5];
saveGame;
t_task3 = player createSimpleTask ["Search and Rescue"];
t_task3 setSimpleTaskDescription ["NATO troops need an urgent pick up.  We normally do not transport soldiers with this helicopter, but NATO needs the assistance and they don't have any transport helicopters available right now, so it's your job now.", "Search and Rescue","SAR"];
[_this select 1] call g_thirdMission;