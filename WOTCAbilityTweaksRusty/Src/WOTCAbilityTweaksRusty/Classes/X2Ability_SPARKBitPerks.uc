//*******************************************************************************************
//  FILE:   X2Ability_SPARKBitPerks                                 
//  
//	File created by RustyDios	21/04/20	03:00	
//	LAST UPDATED				22/04/20	16:00
//
//	ADDS some cloned perks for sparks to use the 'gremlin' abilities
//
//*******************************************************************************************

class X2Ability_SPARKBitPerks extends X2Ability_SparkAbilitySet config(RATConfig);

//grab values from the config file
var config int SPARK_MEDICAL_INITIAL_CHARGES;
var config int SPARK_CONCEAL_COOLDOWN;

//add the ability templates to the templates
static function array<X2DataTemplate> CreateTemplates()
{	
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_Medical_Protocol_Bit());
		Templates.AddItem(Create_Medical_Protocol_Bit_Heal());
		Templates.AddItem(Create_Medical_Protocol_Bit_Stabilise());
		Templates.AddItem(Create_Medical_Protocol_Bit_Revive());
	Templates.AddItem(Create_Scanning_Protocol_Bit());
	Templates.AddItem(Create_Conceal_Protocol_Bit());

	//for compatibility with SPARK Arsenal
	Templates.Additem(Create_IntrusionProtocol_Bit());
	Templates.AddItem(class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('IntrusionProtocol_Chest_Bit', 'Hack_Chest'));
	Templates.AddItem(class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('IntrusionProtocol_Workstation_Bit', 'Hack_Workstation'));
	Templates.AddItem(class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('IntrusionProtocol_ObjectiveChest_Bit', 'Hack_ObjectiveChest'));
	Templates.AddItem(class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('IntrusionProtocol_Scan_Bit', 'Hack_Scan'));
	Templates.AddItem(Create_HaywireProtocol_Bit());

	return Templates;
}

//create the new ability and passive icon marker
static function X2AbilityTemplate Create_Medical_Protocol_Bit()
{
	local X2AbilityTemplate             Template;

	Template = PurePassive('Medical_Protocol_Bit',  "img:///UILibrary_PerkIcons.UIPerk_medicalprotocol", , 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('Medical_Protocol_Bit_Heal');
	Template.AdditionalAbilities.AddItem('Medical_Protocol_Bit_Stabilise');
	Template.AdditionalAbilities.AddItem('Medical_Protocol_Bit_Revive');

	return Template;
}

//clone gremlin heal, change custom fire anim
static function X2AbilityTemplate Create_Medical_Protocol_Bit_Heal()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCharges_GremlinHeal		Charges;
	local X2AbilityCost_Charges             ChargeCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2Effect_ApplyMedikitHeal         MedikitHeal;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Medical_Protocol_Bit_Heal');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;	
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges_GremlinHeal';
	Charges.InitialCharges = default.SPARK_MEDICAL_INITIAL_CHARGES; // Initial charges can be changed in the config now.
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Stabilise');
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Revive');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = class'X2Ability_DefaultAbilitySet'.default.MEDIKIT_PERUSEHP;
	MedikitHeal.IncreasedHealProject = 'BattlefieldMedicine';
	MedikitHeal.IncreasedPerUseHP = class'X2Ability_DefaultAbilitySet'.default.NANOMEDIKIT_PERUSEHP;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType());

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_medicalprotocol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY+1;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.ActivationSpeech = 'MedicalProtocol';

	Template.OverrideAbilities.AddItem('MedikitHeal');
	Template.OverrideAbilities.AddItem('NanoMedikitHeal');
	Template.bOverrideWeapon = true;
	Template.CustomSelfFireAnim = 'NO_Repair';

	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	return Template;
}

static function X2AbilityTemplate Create_Medical_Protocol_Bit_Stabilise()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCharges_GremlinHeal		Charges;
	local X2AbilityCost_Charges             ChargeCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Effect_RemoveEffects            RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Medical_Protocol_Bit_Stabilise');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges_GremlinHeal';
	Charges.InitialCharges = default.SPARK_MEDICAL_INITIAL_CHARGES; // Initial charges can be changed in the config now.
	Charges.bStabilize = true;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Heal');
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Revive');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.IsBleedingOut = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true));

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gremlinheal";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY+2;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.ActivationSpeech = 'MedicalProtocol';

	Template.OverrideAbilities.AddItem( 'MedikitStabilize' );
	Template.bOverrideWeapon = true;
	Template.CustomSelfFireAnim = 'NO_Repair';

	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	return Template;
}

static function X2AbilityTemplate Create_Medical_Protocol_Bit_Revive()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges_GremlinHeal		Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Medical_Protocol_Bit_Revive');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges_GremlinHeal';
	Charges.InitialCharges = default.SPARK_MEDICAL_INITIAL_CHARGES; // Initial charges can be changed in the config now.
	Charges.bStabilize = true;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Heal');
	ChargeCost.SharedAbilityCharges.AddItem('Medical_Protocol_Bit_Stabilise');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_RevivalProtocol');

	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist());
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints');      //  put the unit back to full actions

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_revivalprotocol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY+3;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.CustomSelfFireAnim = 'NO_Repair';

	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	return Template;
}

//clone scanning protocol, use new anim
static function X2AbilityTemplate Create_Scanning_Protocol_Bit()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2Effect_PersistentSquadViewer    ViewerEffect;
	local X2Effect_ScanningProtocol     ScanningEffect;
	local X2AbilityCost_Charges         ChargeCost;
	local X2Condition_UnitProperty      CivilianProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Scanning_Protocol_Bit');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sensorsweep";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Template.AbilityCharges = new class'X2AbilityCharges_ScanningProtocol';

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = class'X2Ability_SpecialistAbilitySet'.default.SCANNING_PROTOCOL_CHARGES;
	Template.AbilityCosts.Additem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true; // skip the cover checks, the squad viewer will handle this once selected
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	ScanningEffect.TargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	CivilianProperty = new class'X2Condition_UnitProperty';
	CivilianProperty.ExcludeNonCivilian = true;
	CivilianProperty.ExcludeHostileToSource = false;
	CivilianProperty.ExcludeFriendlyToSource = false;
	ScanningEffect.TargetConditions.AddItem(CivilianProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	ViewerEffect = new class'X2Effect_PersistentSquadViewer';
	ViewerEffect.bUseSourceLocation = true;
	ViewerEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddShooterEffect(ViewerEffect);

	Template.bStationaryWeapon = true;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bSkipPerkActivationActions = true;

	Template.ActivationSpeech = 'ScanningProtocol';
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = GremlinScanningProtocol_Bit_BuildVisualization; // see below :)
	//TypicalAbility_BuildVisualization; //;class'X2Ability_SpecialistAbilitySet'.static.GremlinScanningProtocol_BuildVisualization;
	//class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.CinescriptCameraType = "Specialist_ScanningProtocol";
	
	Template.CustomSelfFireAnim = 'NO_BITScanningProtocol'; // AnimSet'Rusty_SPARK_BitPerks.Anims.AS_Bit_Scanning'
	Template.CustomFireAnim = 'NO_BITScanningProtocol';

	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	return Template;
}

//clone of scanning protocol vis with changed anim name
simulated function GremlinScanningProtocol_Bit_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local StateObjectReference          InteractingUnitRef;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState, ShooterState;
	local XComGameState_Ability         AbilityState;
	local array<PathPoint> Path;

	local VisualizationActionMetadata	EmptyTrack, ActionMetadata;
	local X2Action_WaitForAbilityEffect DelayAction;

	local int EffectIndex, MultiTargetIndex;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_RevealArea			RevealAreaAction;
	local TTile TargetTile;
	local vector TargetPos;

	local X2Action_PlayAnimation		PlayAnimation;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, , VisualizeGameState.HistoryIndex));
	AbilityTemplate = AbilityState.GetMyTemplate();

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID, , VisualizeGameState.HistoryIndex - 1));

	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	ShooterState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	//Configure the visualization track for the gremlin
	//****************************************************************************************
	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	// Given the target location, we want to generate the movement data.  
	TargetTile = ShooterState.TileLocation;
	TargetPos = `XWORLD.GetPositionFromTileCoordinates(TargetTile);

	class'X2PathSolver'.static.BuildPath(GremlinUnitState, GremlinUnitState.TileLocation, TargetTile, PathData.MovementTiles);
	class'X2PathSolver'.static.GetPathPointsFromPath(GremlinUnitState, PathData.MovementTiles, Path);
	class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);
	PathData.MovingUnitRef = GremlinUnitState.GetReference();
	PathData.MovementData = Path;
	Context.InputContext.MovementPaths.AddItem(PathData);
	class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID,	PathData.MovementTiles,	ResultData.PathTileData);
	Context.ResultContext.PathResults.AddItem(ResultData);
	class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);
	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	RevealAreaAction.TargetLocation = TargetPos;
	RevealAreaAction.ScanningRadius = GremlinItem.GetItemRadius(AbilityState) * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER / class'XComWorldData'.const.WORLD_StepSize;
	
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		//Animation name changed here //
	PlayAnimation.Params.AnimName = 'NO_BITScanningProtocol';
	
	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_PERK_EFFECT_WINDOW);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	//****************************************************************************************

	//Configure the visualization track for the target
	//****************************************************************************************
	for (MultiTargetIndex = 0; MultiTargetIndex < Context.InputContext.MultiTargets.Length; ++MultiTargetIndex)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[MultiTargetIndex];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindMultiTargetEffectApplyResult(AbilityTemplate.AbilityMultiTargetEffects[EffectIndex], MultiTargetIndex));
		}

	}
	//****************************************************************************************
}

//clone mash up of ranger reconceal and active camo
static function X2AbilityTemplate Create_Conceal_Protocol_Bit()
{
	local X2AbilityTemplate				Template;

	local X2Effect_RangerStealth		StealthEffect;
	local X2Effect_Persistent			CamoEffect;
	local X2Condition_UnitProperty		ConcealedCondition;

	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCooldown				Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Conceal_Protocol_Bit');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SPARK_CONCEAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	Template.AddShooterEffectExclusions();

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;

	CamoEffect = new class'X2Effect_Persistent';
	CamoEffect.BuildPersistentEffect(1, true, false);
	CamoEffect.TargetConditions.AddItem(ConcealedCondition);
	CamoEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(CamoEffect);

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'NO_Camouflage';

	return Template;
}

//for compatibility with SPARK Arsenal
static function X2AbilityTemplate Create_IntrusionProtocol_Bit()
{
	local X2AbilityTemplate             Template;

	Template = class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('IntrusionProtocol_Bit');

	// add the intrusion protocol variants as well
	Template.AdditionalAbilities.AddItem('IntrusionProtocol_Chest_Bit');
	Template.AdditionalAbilities.AddItem('IntrusionProtocol_Workstation_Bit');
	Template.AdditionalAbilities.AddItem('IntrusionProtocol_ObjectiveChest_Bit');
	Template.AdditionalAbilities.AddItem('IntrusionProtocol_Scan_Bit');

	Template.bDontDisplayInAbilitySummary = false;

	return Template;
}

static function X2AbilityTemplate Create_HaywireProtocol_Bit()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCooldown             Cooldown;

	Template = class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('HaywireProtocol_Bit', , true);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_haywireprotocol";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = class'X2Ability_SpecialistAbilitySet'.default.HAYWIRE_PROTOCOL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.CancelAbilityName = 'CancelHaywire';
	Template.AdditionalAbilities.AddItem('CancelHaywire');
	Template.FinalizeAbilityName = 'FinalizeHaywire';
	Template.AdditionalAbilities.AddItem('FinalizeHaywire');

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.ActivationSpeech = 'HaywireProtocol';
	Template.bDontDisplayInAbilitySummary = false;

	return Template;
}
