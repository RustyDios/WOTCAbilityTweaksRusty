//*******************************************************************************************
//  FILE:   X2Ability_RustyBox                                 
//  
//	File created by RustyDios	22/02/2020	01:50	
//	LAST UPDATED				22/02/2020	01:50
//
//	Contains a suite of abilities for inflicting self harm
//
//*******************************************************************************************

class X2Ability_RustyBox extends X2Ability config (RATConfig);

//grab the config variables
var config bool bExcludeHostile;
var config bool bExcludeFriendly;

//add the new abilities
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(PurePassive('RPB_Passive',"img:///UILibrary_PerkIcons.UIPerk_clusterbomb",false,'eAbilitySource_Debuff',true));

	Templates.AddItem(CreateRPB_FullRestore());
	Templates.AddItem(CreateRPB_SBS());

	Templates.AddItem(CreateRPB_Disorient());
	Templates.AddItem(CreateRPB_Dazed());
	Templates.AddItem(CreateRPB_Stunned());
	Templates.AddItem(CreateRPB_Unconscious());
		Templates.AddItem(CreateRPB_Panicked());
		Templates.AddItem(CreateRPB_Obsessed());
		Templates.AddItem(CreateRPB_Berserk());
		Templates.AddItem(CreateRPB_Shattered());
	Templates.AddItem(CreateRPB_Harm());
	Templates.AddItem(CreateRPB_Heal());
	Templates.AddItem(CreateRPB_Rupture());
	Templates.AddItem(CreateRPB_BleedingOut());
		Templates.AddItem(CreateRPB_Poison());
		Templates.AddItem(CreateRPB_ChyrsPoison());
		Templates.AddItem(CreateRPB_Burn());
		Templates.AddItem(CreateRPB_AcidBurn());
		Templates.AddItem(CreateRPB_Bleeding());
		Templates.AddItem(CreateRPB_Frozen());
	Templates.AddItem(CreateRPB_Blind());

	return Templates;
}

//create the abilities
//master ability!!
static function X2AbilityTemplate CreatePandoraAbility(name TemplateName)
{
	local X2AbilityTemplate				Template;
	local X2Condition_UnitProperty      TargetProperty;
	local X2Condition_UnitStatCheck		UnitStatCheckCondition;
	local array<name>					SkipExclusions;

	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	//standard ability info stuffs
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_clusterbomb";
	Template.AbilitySourceName = 'eAbilitySource_Debuff';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 4269;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = true;

	//typical ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;

	//targeting and triggering, player activated, never miss, exclude dead
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
		//allow activation even if burning or disoriented
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = false;									//See comment below...
	TargetProperty.ExcludeHostileToSource = default.bExcludeHostile;	//true;
	TargetProperty.ExcludeFriendlyToSource = default.bExcludeFriendly;	//false;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead ... 
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	// ... or bleeding-out units.
	//UnitEffectsCondition = new class'X2Condition_UnitEffects';
	//UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	//Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);

	//costs, charges and cooldowns
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	return Template;
}

//the clones!
static function X2AbilityTemplate CreateRPB_Disorient()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	Effect;

	Template = CreatePandoraAbility('RPB_Disorient');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Dazed()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Dazed		Effect;

	Template = CreatePandoraAbility('RPB_Dazed');

	//on hit/activated effects
	Effect = class'X2StatusEffects_Xpack'.static.CreateDazedStatusEffect(2,100);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Stunned()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Stunned		Effect;

	Template = CreatePandoraAbility('RPB_Stunned');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2,100);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Unconscious()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	Effect;

	Template = CreatePandoraAbility('RPB_Unconscious');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Panicked()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Panicked		Effect;

	Template = CreatePandoraAbility('RPB_Panicked');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Obsessed()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Panicked		Effect;

	Template = CreatePandoraAbility('RPB_Obsessed');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateObsessedStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Berserk()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Panicked		Effect;

	Template = CreatePandoraAbility('RPB_Berserk');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateBerserkStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Shattered()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Panicked		Effect;

	Template = CreatePandoraAbility('RPB_Shattered');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateShatteredStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Harm()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ApplyMedikitHeal		Effect;

	Template = CreatePandoraAbility('RPB_Harm');

	//on hit/activated effects
	Effect = new class'X2Effect_ApplyMedikitHeal';
	Effect.PerUseHP = -1;
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Heal()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ApplyMedikitHeal		Effect;

	Template = CreatePandoraAbility('RPB_Heal');

	//on hit/activated effects
	Effect = new class'X2Effect_ApplyMedikitHeal';
	Effect.PerUseHP = 1;
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Rupture()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ApplyWeaponDamage	Effect;

	Template = CreatePandoraAbility('RPB_Rupture');

	//on hit/activated effects
	Effect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_BleedingOut()
{
	local X2AbilityTemplate		Template;
	local X2Effect_BleedingOut	Effect;

	Template = CreatePandoraAbility('RPB_BleedingOut');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateBleedingOutStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Poison()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		Effect;

	Template = CreatePandoraAbility('RPB_Poison');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_ChyrsPoison()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ParthenogenicPoison	Effect;

	Template = CreatePandoraAbility('RPB_ChyrsPoison');

	//on hit/activated effects
	Effect = new class'X2Effect_ParthenogenicPoison';
	Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetPoisonDamageDamage();
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Burn()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Burning		Effect;

	Template = CreatePandoraAbility('RPB_Burn');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateBurningStatusEffect(1,1);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_AcidBurn()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	Effect;

	Template = CreatePandoraAbility('RPB_AcidBurn');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(1,1);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Bleeding()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	Effect;

	Template = CreatePandoraAbility('RPB_Bleeding');

	//on hit/activated effects
	Effect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(2,1);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Frozen()
{
	local X2AbilityTemplate			Template;
	local X2Effect_DLC_Day60Freeze	Effect;

	Template = CreatePandoraAbility('RPB_Frozen');

	//on hit/activated effects
	Effect = class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeEffect(1,5);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_Blind()
{
	local X2AbilityTemplate			Template;
	local X2Effect_Blind			Effect;

	Template = CreatePandoraAbility('RPB_Blind');

	//on hit/activated effects
	Effect = class'X2Effect_Blind'.static.CreateBlindEffect(1,5);
	Template.AddTargetEffect(Effect);

	return Template;
}

static function X2AbilityTemplate CreateRPB_SBS()
{
	local X2AbilityTemplate				Template;
	local X2Condition_UnitProperty      TargetProperty;
	local X2Condition_UnitStatCheck		UnitStatCheckCondition;

	Template = CreatePandoraAbility('RPB_SBS');

	//change the icon so it's unique in the shot hud
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_observer";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	//reset the target conditions
	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityMultiTargetConditions.Length = 0;

	//reverse what they are set too
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = false;									//See comment below...
	TargetProperty.ExcludeHostileToSource = !default.bExcludeHostile;	//!true; = false
	TargetProperty.ExcludeFriendlyToSource = !default.bExcludeFriendly;	//!false; = true
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead ... 
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	return Template;
}

//create the one time cure everything ability!!
static function X2AbilityTemplate CreateRPB_FullRestore()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local X2Effect_ApplyMedikitHeal				MedikitHeal;

	Template = CreatePandoraAbility('RPB_FullRestore');

	//change the icon so it's unique in the shot hud
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_divinearmor";
	Template.AbilitySourceName = 'eAbilitySource_Commander';

	//ensure it can only target unconscious/panic/disoriented.. /stunned
	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_RevivalProtocol');
	//Template.bLimitTargetIcons = true;

	//do a full revive and medikit heal
	//Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist());
	
	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);				//in stabilize

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);		//in revival
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);			//in revival .. removed by	RM Mod
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);			//in revival .. added by	RM Mod
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);				//in revival

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);		//in revival
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ObsessedName);		//in revival .. removed by	RM Mod
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BerserkName);			//in revival .. removed by	RM Mod
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ShatteredName);		//in revival .. removed by	RM Mod

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BlindedName);			// new

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_DLC_Day60Freeze'.default.EffectName);			//dlc frozen/freeze

	//Medikit Heal Effect Types
	//foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	RemoveEffects.DamageTypesToRemove.AddItem('Fire');
	RemoveEffects.DamageTypesToRemove.AddItem('Poison');
	RemoveEffects.DamageTypesToRemove.AddItem('ParthenogenicPoison');//chyrssalid venom
	RemoveEffects.DamageTypesToRemove.AddItem('Acid');
	RemoveEffects.DamageTypesToRemove.AddItem('Bleeding');

	RemoveEffects.DamageTypesToRemove.AddItem('Mental');
	RemoveEffects.DamageTypesToRemove.AddItem('Ruptured');
	RemoveEffects.DamageTypesToRemove.AddItem('Frost');//dlc frozen/freeze

	Template.AddTargetEffect(RemoveEffects);

	//Healing effects follow...
	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = 100;
	Template.AddTargetEffect(MedikitHeal);	

	//with thanks to LWOTC guys for the correct anti-stun removal function
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

	//put the unit back to full actions
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints');     

	//reduce all cooldowns by one
	Template.AddTargetEffect(new class'X2Effect_ManualOverride');

	return Template;
}

//end of this crazy box of tricks