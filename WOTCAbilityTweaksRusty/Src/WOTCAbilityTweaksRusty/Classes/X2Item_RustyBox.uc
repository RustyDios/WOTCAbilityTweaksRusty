//*******************************************************************************************
//  FILE:   X2Item_RustyBox

//	File created by RustyDios	22/02/2020	01:00
//	LAST UPDATED				22/02/2020	01:00
//
//	Adds a secret item that allows a user to self-harm with status effects
//	A useful aid for debugging heals and revive effects
//
//*******************************************************************************************

class X2Item_RustyBox extends X2Item config (RATConfig);
//Grab config values
var config WeaponDamageValue PANDORASBOX_BASEDAMAGE;

//add the items
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> DebugItems;

	DebugItems.AddItem(CreateRustyBox());
	
	return DebugItems;
}

//create the items
static function X2DataTemplate CreateRustyBox()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RustyBox');

	//default item stuffs
	Template.ItemCat = 'heal';
	Template.WeaponCat = 'utility';
	Template.WeaponTech = 'alien';

	//ui visuals
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///UILibrary_RATImages.Inv_RustyPandoraBox";
	Template.EquipSound = "Gremlin_Equip";

	//tactical visuals ... This all the resources; sounds, animations, models, physics, the works.
	//arcon pinions creates the user to put their head streched, arms up and let out a roar..lol
	Template.GameArchetype = "WP_Archon_Blazing_Pinions.WP_Blazing_Pinions_CV";//WP_Medikit.WP_Medikit_Lv2

	//default weapon stuffs
	Template.iClipSize = 99;
	Template.InfiniteAmmo = true;
	Template.iRange = 25;
	Template.bMergeAmmo = true;

	Template.BaseDamage = default.PANDORASBOX_BASEDAMAGE;

	//icon for display in armory etc, sweetens up the localization
	Template.Abilities.AddItem('RPB_Passive');

	// 'heal anything and everything' ability
	Template.Abilities.AddItem('RPB_FullRestore');
	Template.Abilities.AddItem('RPB_SBS');

	//full suite of insta hit, any target effects that cause a 'status' condition
	Template.Abilities.AddItem('RPB_Disorient');
	Template.Abilities.AddItem('RPB_Dazed');
	Template.Abilities.AddItem('RPB_Stunned');
	Template.Abilities.AddItem('RPB_Unconscious');
		Template.Abilities.AddItem('RPB_Panicked');
		Template.Abilities.AddItem('RPB_Obsessed');
		Template.Abilities.AddItem('RPB_Berserk');
		Template.Abilities.AddItem('RPB_Shattered');
	Template.Abilities.AddItem('RPB_Harm');
	Template.Abilities.AddItem('RPB_Heal');
	Template.Abilities.AddItem('RPB_Rupture');
	Template.Abilities.AddItem('RPB_BleedingOut');
		Template.Abilities.AddItem('RPB_Poison');
		Template.Abilities.AddItem('RPB_ChyrsPoison');
		Template.Abilities.AddItem('RPB_Burn');
		Template.Abilities.AddItem('RPB_AcidBurn');
		Template.Abilities.AddItem('RPB_Bleeding');
		Template.Abilities.AddItem('RPB_Frozen');

	Template.Abilities.AddItem('RPB_Blind');

	//cannot be built ... given in game by rustyfix_additem :)
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.Tier = 5;

	return Template;
}
