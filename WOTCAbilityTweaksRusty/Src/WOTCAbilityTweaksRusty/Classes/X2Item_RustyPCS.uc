//*******************************************************************************************
//  FILE:   X2Item_RustyPCS                                 
//  
//	File created by RustyDios	19/09/19	15:00
//	LAST UPDATED				19/09/19	15:00
//
//	Adds a Psi Offense and Hacking PCS
//		see config ini's GameCore and Game Data for loot tables and stat ranges
//
//*******************************************************************************************

class X2Item_RustyPCS extends X2Item config (RATConfig);
//Grab config values

//add the items
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreatePCS_Psi('CommonPCSPsi',	15, 0, 'PsiPCS_BonusStats_Common', class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_COMMON));
	Resources.AddItem(CreatePCS_Psi('RarePCSPsi',	20, 1, 'PsiPCS_BonusStats_Common', class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_RARE));
	Resources.AddItem(CreatePCS_Psi('EpicPCSPsi',	30, 2, 'PsiPCS_BonusStats_Common', class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_EPIC));

	Resources.AddItem(CreatePCS_Hack('CommonPCSHack',	15, 0, 1));
	Resources.AddItem(CreatePCS_Hack('RarePCSHack',		20, 1, 2));
	Resources.AddItem(CreatePCS_Hack('EpicPCSHack',		30, 2, 3));

	return Resources;
}

//create the items
static function X2DataTemplate CreatePCS_Psi(name TemplateName, int SellValue, int Tier, name AbilityName, int LabelValue)
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, TemplateName);

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_CombatSim_Psi";
	Template.ItemCat = 'combatsim';
	Template.TradingPostValue = SellValue;
	Template.bAlwaysUnique = false;
	Template.Tier = Tier;

	//dirty workaround to avoid the PCS getting locked behind the PsiOperative only for PsiOffense thing
	Template.Abilities.AddItem(AbilityName);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, LabelValue);

	//Template.StatBoostPowerLevel = LabelValue;
	//Template.StatsToBoost.AddItem(eStat_PsiOffense);
	//Template.bUseBoostIncrement = false;	//percent bonus

	Template.InventorySlot = eInvSlot_CombatSim;

	//adapted from PexM code
	CreateNameForPCS(Template, LabelValue);

	Template.BlackMarketTexts = class'X2Item_DefaultResources'.default.PCSBlackMarketTexts;

	return Template;
}

static function X2DataTemplate CreatePCS_Hack(name TemplateName, int SellValue, int Tier, int LabelValue)
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, TemplateName);

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
	Template.strImage = "img:///UILibrary_RATImages.Inv_CombatSim_Hack";
	Template.ItemCat = 'combatsim';
	Template.TradingPostValue = SellValue;
	Template.bAlwaysUnique = false;
	Template.Tier = Tier;

	Template.StatBoostPowerLevel = Tier + 1;
	Template.StatsToBoost.AddItem(eStat_Hacking);

	Template.bUseBoostIncrement = false;	//percent bonus
	Template.InventorySlot = eInvSlot_CombatSim;

	Template.BlackMarketTexts = class'X2Item_DefaultResources'.default.PCSBlackMarketTexts;

	return Template;
}

//create the dynamic appendage to the name for the bonus value
static function CreateNameForPCS(out X2EquipmentTemplate Template, int LabelValue)
{
	Template.FriendlyName ="<font color = '#b6b3e3'>" $Template.FriendlyName $"</font> (+" $LabelValue @" Psi Offense)";
	Template.FriendlyNamePlural ="<font color = '#b6b3e3'>"$Template.FriendlyName $"</font> (+" $LabelValue @" Psi Offense)";
	Template.LootTooltip = Template.FriendlyName;
}
