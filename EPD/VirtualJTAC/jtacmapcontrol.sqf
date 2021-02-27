JTAC_GET_MAP_POSITIONS = {
	jtacIngressSet = false;
	jtacIngressPosition = [-1,-1,-1];
	jtacTargetSet = false;
	jtacTarget = [-1,-1,-1];
	jtacPollingMap = false;
	
	deleteMarkerLocal "jtacIngressMarker";
	deleteMarkerLocal "jtacTargetMarker";
	openMap true;
	
	while {(visibleMap) and not (jtacIngressSet and jtacTargetSet)} do 
	{
		if ((not jtacPollingMap) and (not jtacIngressSet)) then {
			jtacPollingMap = true;
			hint "Click to set ingress point";
			onMapSingleClick "jtacIngressPosition = _pos; jtacIngressSet = true; jtacPollingMap = false; createMarkerLocal['jtacIngressMarker', _pos]; 'jtacIngressMarker' setMarkerTextLocal 'Ingress'; 'jtacIngressMarker' setMarkerTypeLocal 'mil_dot'";
		};
		
		if ((not jtacPollingMap) and (not jtacTargetSet)) then {
			jtacPollingMap = true;
			hint "Click to set Target location";
			onMapSingleClick "jtacTarget = _pos; jtacTargetSet = true; jtacPollingMap = false; createMarkerLocal['jtacTargetMarker', _pos]; 'jtacTargetMarker' setMarkerTextLocal 'Target'; 'jtacTargetMarker' setMarkerTypeLocal 'mil_dot'";
		};
		sleep .1;
	};
	
	// Clear event handlers
	onMapSingleClick "";
	
	if (jtacIngressSet and jtacTargetSet) then {
		private _posDiff = jtacIngressPosition vectorDiff jtacTarget;
		private _dX = _posDiff select 0;
        private _dY = _posDiff select 1;
		private _ingressDirection = _dX atan2 _dY;
		_ingressDirection = (_ingressDirection + 360) % 360;
		JtacIncomingAngle = _ingressDirection;
	};
	

	
	if (not (jtacIngressSet and jtacTargetSet)) then {
		deleteMarkerLocal "jtacIngressMarker";
		deleteMarkerLocal "jtacTargetMarker";
		[false];
	} else {
		0 = [] spawn {
			sleep 30;
			deleteMarkerLocal "jtacIngressMarker";
			deleteMarkerLocal "jtacTargetMarker";
		};
		[true, [jtacTarget select 0, jtacTarget select 1, getTerrainHeightASL jtacTarget]];
	};
	
};