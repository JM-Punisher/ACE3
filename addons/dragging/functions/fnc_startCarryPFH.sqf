// by commy2
#include "script_component.hpp"

#ifdef DEBUG_ENABLED_DRAGGING
    systemChat format ["%1 startCarryPFH running", time];
#endif

private ["_unit", "_target", "_timeOut"];

_unit = _this select 0 select 0;
_target = _this select 0 select 1;
_timeOut = _this select 0 select 2;

// handle aborting carry
if !(_unit getVariable [QGVAR(isCarrying), false]) exitWith {
    [_this select 1] call CBA_fnc_removePerFrameHandler;
};

// same as dragObjectPFH, checks if object is deleted or dead.
if !([_target] call EFUNC(common,isAlive)) then {
    [_unit, _target] call FUNC(dropObject);
    [_this select 1] call CBA_fnc_removePerFrameHandler;
};

// handle persons vs objects
if (_target isKindOf "CAManBase") then {
    if (time > _timeOut) exitWith {
        [_unit, _target] call FUNC(carryObject);

        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };
} else {
    if (time > _timeOut) exitWith {
        [_this select 1] call CBA_fnc_removePerFrameHandler;

        // drop if in timeout
        private "_draggedObject";
        _draggedObject = _unit getVariable [QGVAR(draggedObject), objNull];
        [_unit, _draggedObject] call FUNC(dropObject);
    };

    // wait for the unit to stand up
    if (stance _unit == "STAND") exitWith {
        [_unit, _target] call FUNC(carryObject);

        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };

};
