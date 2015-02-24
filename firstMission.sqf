private["_taskPos", "_ambientPos", "_this"];
target_1 setPosATL (getPos s_ammo);
_taskPos = getMarkerPos (_this select 0);
_ambientPos = getPosATL target_1;
_rating = 1000;

[s_boss, "BRIEFING"] call BIS_fnc_ambientAnim;
[s_journalist, "STAND_U3"] call BIS_fnc_ambientAnim;
[s_worker, "LISTEN_BRIEFING"] call BIS_fnc_ambientAnim;

waitUntil{taskOneActive};

s_scienceGuy sideChat "Watch out for the active CAS run marked on the map.";
playSound "cas";

[] spawn { [target_1, player, true] call BIS_fnc_moduleCAS; };

_ambientPos spawn
{
	private ["_this", "_smoke", "_explosion"];
	sleep 20;

	_explosion = "Bo_GBU12_LGB_MI10" createVehicle _this;
	_explosion setPosATL [_this select 0, _this select 1, (_this select 2) + 10];
	_explosion setVelocity [0, 0, -10];

	_smoke = "test_EmptyObjectForFireBig" createVehicle _this;
	_smoke setPosATL _this;
};

waitUntil{(s_supplies distance _taskPos <= 8)};
{private ["_x"]; ropeDestroy _x;} forEach ropes vehicle player;
s_scienceGuy sideChat "Good job. Now pick up the refugees and drop them off at the Hospital.";
playSound "t1_finished";
["TaskSucceeded",["","Deliver Supplies"]] call BIS_fnc_showNotification;
t_task1 setTaskState "Succeeded";
player addRating _rating;
[_this select 1, _this select 2] call g_secondMission;