private ["_comp", "_destPos", "_destRot", "_refPos", "_objects", "_destX", "_destY"];
_comp = _this select 0;
_destPos = _this select 1;
_destRot = _this select 2;
_destX = _destPos select 0;
_destY = _destPos select 1;

_refPos = getPosATL _comp;
_refX = _refPos select 0;
_refY = _refPos select 1;
_objects = nearestObjects [_refPos, [], 50];

_comp setVariable ["objects", _objects];

{
	private ["_x", "_relPos", "_newPos", "_posX", "_posY"];
	_posX = ((getPosATL _x) select 0);
	_posY = ((getPosATL _x) select 1);
	
	_relPos = [_refX - _posX, _refY - _posY, 0];
	_newPos = [_destX + (_relPos select 0), _destY + (_relPos select 1), 0];
	_x setPosATL _newPos;
} forEach (_comp getVariable "objects");