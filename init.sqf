g_firstMission = compile preprocessFile "firstMission.sqf";
g_secondMission = compile preprocessFile "secondMission.sqf";
g_thirdMission = compile preprocessFile "thirdMission.sqf";
g_triggerAA = compile preprocessFile "triggerAA.sqf";
createCenter civilian;
createCenter opfor;
createCenter blufor;

_taskMarkers = ["s_target_0", "s_target_1", "s_target_2", "s_target_3", "s_target_4", "s_target_5","s_target_6", "s_target_7", "s_target_8"];

_taskOnePos = _taskMarkers select (floor (random 3));
_taskTwoPos = _taskMarkers select (floor (random 3) + 3);
_taskThreePos = _taskMarkers select (floor (random 3) + 6);

[s_mechanic, "REPAIR_VEH_KNEEL"] call BIS_fnc_ambientAnim;

_light1 = "#lightpoint" createVehicle (getPos s_light1);
_light1 setLightColor [255, 255, 255];
_light1 setLightBrightness 0.02125;
_light1 setLightAmbient [255, 255, 255];
_light1 setLightUseFlare true;
_light1 setLightFlareMaxDistance 1500;
_light1 setLightFlareSize 4;
_light1 lightAttachObject [s_light1, [0,0,0]];

t_task1 = player createSimpleTask ["Deliver Supplies"];
t_task1 setSimpleTaskDescription ["Sling the supplies with your helicopter to the designated drop zone.","Deliver Supplies","Drop Zone"];
t_task1 setTaskState "Assigned";
t_task1 setSimpleTaskDestination (getMarkerPos _taskOnePos);

t_task2 = player createSimpleTask ["Rescue Refugees"];
t_task2 setSimpleTaskDescription ["Pick up the Refugees and then bring them back to the hospital helipad.","Rescue Refugees","Refugees"];

player createDiaryRecord ["Diary", ["Diary","

17th December, 2034 <br/>
Finally got my CPL! I already have a job waiting for me on the scenic island of Altis. Playing shuttle service for some engineers who work on off-shore wind farms. Altis is a hotbed for renewable energy companies, so there should be plenty of work in the future. Living on a Mediterranean island was always a dream of mine.<br/>

<br/>19 January, 2035 <br/>
My second week on the island and my first week on the job. I feel welcome by everyone here, no matter if it's another expat like me or local inhabitants. Flying long stretches over water is boring, but the curious engineers keep me entertained on those boring legs.<br/>

<br/>5 February, 2035 <br/>
Not everything is as marvellous on this island as I had thought. The rural population seems to be discontent with the local governments social assistance. Their campaign promise was to attract foreign businesses and invest the additional tax income in some medical and social infrastructure. The only medical assistance available at the moment is at the hospital in Kavala, which is a good hour drive depending on where you live on the island. Higher education is not available at all, you have to go to another country to get a degree. People fear the young insular state and it's inhabitants won't be able to self-sustain or compete.<br/>

<br/>11 February, 2035 <br/>
Protests are growing increasingly violent. Accusations of inciting violence come from all sides, police, loyalists and protesters. My employer is a little worried and so am I, but we hope the situation will resolve soon.<br/>

<br/>2 March, 2035 <br/>
The violence has not stopped increasing since my last entry. The military vanished over night and police soon disappeared as well. All industries have come to a halt as many foreigners have fled the country and things are in disarray. My flight will leave in one week, no more seats available before that... This place was so nice, I wish things would have gone different.<br/>

<br/>10 March, 2035 <br/>
Seems like I am stuck on this island now... Three days ago the airport was attacked by some militants. Armed with the weapons the military left behind, they charged the terminal and blew up a cargo plane which was lined up on the runway. Any official structure is gone and chaos now rules this island.<br/>

<br/>17 March, 2035 <br/>
Things are starting to look better. After the economic and financial crisis of the 'Commonwealth of Independent Countries' started, the militias splintered into alienated cells which fight each other for control. The international community passed a mandate for a peacekeeping mission on the island, the first elements will arrive next Friday. I hope this ordeal has an end now.<br/>

<br/>23 March, 2035 <br/>
NATO and the 'International Red Cross' arrived! They secured Pyrgos, Kavala and the International Airport in no time and started repairing the runway. I offered my assistance and when the IRC deputy heard I have a pilot license, he hired me on the spot. Tomorrow morning I will start my new job as a rescue pilot. A little unconventional since I don't have the necessary qualifications and all that, but with the limited resources on this island, they probably need whoever they can get."]];

player createDiaryRecord ["Diary", ["Overview", "There are still a lot of militants with advanced anti-air weaponry around. Fly below 100 feet (91.44m) or you risk getting shot at. In case you do get locked on, you have flares as countermeasure.<br/><br/>Your first task is to sling the supplies to the drop zone. We will distribute the supplies from there to locals in need. The cargo weighs around 1.5 tonnes, so watch out on take off. Do not drop or otherwise damage the supplies. Damaging the supplies or the helicopter will result in your termination of employment and possibly legal action.<br/><br/>Afterwards you will pick up the last 6 people in a town further north of the drop zone. When they have boarded your helicopter, fly them back to the heli pad at the hospital in Kavala.<br/><br/>I will instruct you for the next task once you return."]];

s_heli setSlingLoad s_supplies;

clearItemCargo s_supplies;
clearWeaponCargo s_supplies;
clearBackpackCargo s_supplies;
clearMagazineCargo s_supplies;

clearMagazineCargo s_heli;
clearWeaponCargo s_heli;

s_supplies setMass 1500;

{
	private ["_x"];
	
	(format ["%1", _x]) setMarkerAlpha 0;
}
forEach _taskMarkers;

g_civObj = [];
g_soldObj = [];
g_enemObj = [];
g_ambientSmoke_t2 = [t2_ambient_1, t2_ambient_2, t2_ambient_3, t2_ambient_4, t2_ambient_5];
g_ambientSmoke_t3 = [t3_ambient_1, t3_ambient_2, t3_ambient_3, t3_ambient_4, t3_ambient_5];
taskOneActive = false;
taskThreeActive = false;
(group s_scienceGuy) setGroupID ["HQ"];

[composition1, getMarkerPos _taskOnePos, markerDir _taskOnePos] execVM "moveComp.sqf";
"s_dropZone_one" setMarkerPos (getMarkerPos _taskOnePos);
s_heli setObjectTexture [0, "Hellcat_rc.paa"];
s_heli setCollisionLight true;
[player,"rc_pilot"] call BIS_fnc_setUnitInsignia;

{
	private ["_posTmp", "_explosion", "_smoke"];
	_posTmp = getPosATL _x;
	_explosion = "Bo_GBU12_LGB_MI10" createVehicle _posTmp;
	_explosion setPosATL [_posTmp select 0, _posTmp select 1, (_posTmp select 2) + 10];
	_explosion setVelocity [0, 0, -10];
	_smoke = "test_EmptyObjectForFireBig" createVehicle _posTmp;
	_smoke setPosATL _posTmp;

} forEach g_ambientSmoke_t2;


player setCurrentTask t_task1;

waitUntil {isNull findDisplay 53;};
s_scienceGuy sideChat "The helicopter is all ready. The supplies are attached, just spool up and deliver them.";
s_scienceGuy say "intro";
[_taskOnePos, _taskTwoPos, _taskThreePos] call g_firstMission;