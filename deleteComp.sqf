private ["_comp", "_refPos", "_objects"];
_comp = _this select 0;

_refPos = getPosATL _comp;
_refX = _refPos select 0;
_refY = _refPos select 1;
_objects = nearestObjects [_refPos, [], 50];

_comp setVariable ["objects", _objects];

{deleteVehicle _x;} forEach (_comp getVariable "objects");