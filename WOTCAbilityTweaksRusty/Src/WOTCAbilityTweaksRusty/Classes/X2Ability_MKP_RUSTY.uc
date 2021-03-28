//*******************************************************************************************
//  FILE:   X2Ability_MKP_RUSTY                                  
//  
//	File created by RustyDios	06/08/19	01:30	
//	LAST UPDATED				08/09/19	17:30
//
//	NEW ABILITY FOR MINIKINETIC PLATING
//	A SMALLER VERSION OF CHOSEN KINETIC PLATING GRANTING UP TO 6 SHIELD
//
//*******************************************************************************************

class X2Ability_MKP_RUSTY extends X2Ability_Chosen config(RATConfig);

//grab values from the config file
var config int iRAT_MKP_MAXSHIELDS, iRAT_MKP_SHIELDSPERMISS;

//add the ability templates to the templates
static function array<X2DataTemplate> CreateTemplates()
{	
	local array<X2DataTemplate> Templates;

	Templates.AddItem(MKP_RUSTY());
	Templates.AddItem(MKP_Rusty_Passive());
	
	return Templates;
}

//create the new ability and passive icon marker
static function X2AbilityTemplate MKP_RUSTY()
{
	local X2AbilityTemplate			Template;
	local X2Effect_KineticPlating	PlatingEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MKP_RUSTY');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aethershift";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	//auto 100% hit on self at begin tactical
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//create the gradual shield on dodged shots effect
	PlatingEffect = new class'X2Effect_KineticPlating';
		PlatingEffect.AddPersistentStatChange(eStat_ShieldHP, default.iRAT_MKP_MAXSHIELDS);
		PlatingEffect.ShieldPerMiss = default.iRAT_MKP_SHIELDSPERMISS;
		PlatingEffect.BuildPersistentEffect(1, true, false, false);
		PlatingEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,true,,Template.AbilitySourceName);
		PlatingEffect.DuplicateResponse = eDupe_Refresh;// ... stops duplicate abilities (if there are any) from showing multiple times
	Template.AddTargetEffect(PlatingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate MKP_Rusty_Passive()
{
	local X2AbilityTemplate                 Template;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MKP_Rusty_Passive');

	Template = PurePassive('MKP_Rusty_Passive', "img:///UILibrary_PerkIcons.UIPerk_aethershift", true, 'eAbilitySource_Item');
	Template.bCrossClassEligible = false;
	Template.bDontDisplayInAbilitySummary = true;
	return Template;
}

//*******************************************************************************************
//*******************************************************************************************
