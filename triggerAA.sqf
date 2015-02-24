private ["tmpGroup", "_AA", "_this"];
_tmpGroup = createGroup resistance;
_AA = _tmpGroup createUnit ["I_Soldier_AA_F", [(getPosATL s_heli) select 0, (getPosATL s_heli) select 1, 0], [], 100, ""];
_AA addEventHandler ["Fired",{deleteVehicle (_this select 0)}];
_AA doTarget s_heli;
_AA doFire s_heli;