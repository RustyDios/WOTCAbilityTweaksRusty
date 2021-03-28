class X2Effect_SpawnMimic_DontCountAsCasualty extends X2Effect_SpawnMimicBeacon;

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit MimicBeaconGameState, SourceUnitGameState;
	local array<XComGameState_Item> SourceInventory;
	local XComGameState_Item InventoryItem, CopiedInventoryItem;
	local X2ItemTemplate ItemTemplate;

	MimicBeaconGameState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
	`assert(MimicBeaconGameState != none);

	SourceUnitGameState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( SourceUnitGameState == none)
	{
		SourceUnitGameState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID, eReturnType_Reference));
	}
	`assert(SourceUnitGameState != none);

	SourceInventory = SourceUnitGameState.GetAllInventoryItems(, true);
	foreach SourceInventory(InventoryItem)
	{
		if (InventoryItem.bMergedOut)
		{
			continue;
		}
		
		ItemTemplate = InventoryItem.GetMyTemplate();
		CopiedInventoryItem = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		MimicBeaconGameState.AddItemToInventory(CopiedInventoryItem, InventoryItem.InventorySlot, NewGameState);
	}


	// Make sure the mimic doesn't spawn with any action points this turn
	MimicBeaconGameState.ActionPoints.Length = 0;
	MimicBeaconGameState.SetUnitFloatValue('NewSpawnedUnit', 1, eCleanup_BeginTactical);
    MimicBeaconGameState.kAppearance.bGhostPawn = true;

	// UI update happens in quite a strange order when squad concealment is broken.
	// The unit which threw the mimic beacon will be revealed, which should reveal the rest of the squad.
	// The mimic beacon won't be revealed properly unless it's considered to be concealed in the first place.
	if (SourceUnitGameState.IsSquadConcealed())
		MimicBeaconGameState.SetIndividualConcealment(true, NewGameState); //Don't allow the mimic beacon to be non-concealed in a concealed squad.
}

