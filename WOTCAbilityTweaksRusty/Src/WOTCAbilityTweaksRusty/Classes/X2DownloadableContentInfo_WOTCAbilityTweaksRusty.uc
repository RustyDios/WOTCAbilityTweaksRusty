//*******************************************************************************************
//  FILE:   XComDownloadableContentInfo_WOTCAbilityTweaksRusty.uc                                    
//  
//	File created by RustyDios	06/08/19	01:30	
//	LAST UPDATED				10/12/20	10:00
//
//	Included changes copied from ADVENT Avengers "Ability Tweaks" Mod		Added a bunch of tweaks for other mods 
//	FOR FULL LIST (INCLUDING OTHER .INI CHANGES) SEE THE README.TXT
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTCAbilityTweaksRusty extends X2DownloadableContentInfo config (RATConfig);

// Grab variables from the config
var config bool bEnableLogging, bLogCCAbilities, bLogAllTechs;

var config bool bRAT_NCB_ULTRASONICLURE, bRAT_NCB_HUNTERPROTOCOL;

var config bool bRAT_ARMOUR_WARSUIT_SWAPSHIELDWALLFORMKP, bRAT_ARMOUR_FIX_BLASTPADDING_ENV, bRAT_ARMOUR_RAGESUIT_TECHFIX;

var config bool bRAT_WEAPON_FIX_TIERS, bRAT_BLUESCREENTODECK, bRAT_GRENADE_SCALEVOLMIX, bRAT_GRENADE_PLASMA_IMAGE, bRAT_INSIGHT_IMAGE;
var config bool bRAT_WEAPON_FIX_PSIOP_PHASEDRONEPANEL, bRAT_PCS_FIX_IMAGESHIVE, bRAT_VEST_FROSTSCALESLOT;

var config bool bRAT_ABILITIES_IGNORESHIELDS_INSANITY, bRAT_ABILITIES_IGNORESHIELDS_VOIDINSANITY, bRAT_ABILITIES_IGNORESHIELDS_VOLT, bRAT_ABILITIES_IGNORESHIELDS_HORROR;
var config bool bRAT_ABILITIES_DEADEYE_ADDBLEEDDISORIENT, bRAT_ABILITIES_RETRIBUTION_COOLDOWN,bRAT_ABILITIES_PROFICIENCYSSI;
var config bool bRAT_ABILITIES_COMPRESENCE_NCB_FREE, bRAT_ABILITIES_INSPIRE_NCB_FREE, bRAT_ABILITIES_TEAMWORK_NCB_FREE;
var config bool bRAT_ABILITIES_SNIPERSHOTSSTICKY, bRAT_ABILITIES_SHIFTPOSITIONS_NONCOMBATIVES;

var config bool bRAT_ABILITIES_REMOTESTART_GIVES_MZDETONATIONSHOT;
	var config AdditionalCooldownInfo ccRemoteFuseShared_Start;
	var config AdditionalCooldownInfo ccRemoteFuseShared_Detonation;

var config bool bRAT_ABILITIES_SCANNINGPROTOCOL;
var config int iSCANNINGPROTOCOL_BONUS_CHARGES_CV, iSCANNINGPROTOCOL_BONUS_CHARGES_MG, iSCANNINGPROTOCOL_BONUS_CHARGES_BM, iSCANNINGPROTOCOL_BONUS_CHARGES_MP, iSCANNINGPROTOCOL_BONUS_CHARGES_SHEN;

var config bool bRAT_STRATELEM_GTSSPARK, bRAT_STRATELEM_MOFSPARKS, bRAT_STRATELEM_HIVE, bRAT_STRATELEM_SSUPGRADE;

var config bool bRAT_CA_TWEAKS;

var config bool bRAT_CXHIVE_SUMMONTWEAKS, bRAT_ICONFIXUP_RULERESCAPE, bRAT_ICONFIXUP_RULERZERKER;

//grab these settings from the correct config
var config(SPARKUpgradesSettings) int CorpseCost;
var config(SPARKUpgradesSettings) int MedSuppliesCost;

//setup new loot tables
var config array<LootTable> LootTables, LootEntry;

//enable second wave options if they are accidently off
//var config array<name> AutoEnableSecondWaveIDs;

//*******************************************************************************************
//*******************************************************************************************

/// Called on new campaign while this DLC / Mod is installed
static event InstallNewCampaign(XComGameState StartState)
{
	//LoadPreSetSecondwave();
}

//	AUTO-ENABLES SECONDWAVE OPTIONS FROM THE CONFIG, DEFAULT FOR DOUBLE PROJECT AND TIMERS
//	MADE WITH HELP FROM KINETOS
/*static function LoadPreSetSecondwave()
{
	local XComGameState_CampaignSettings CampaignSettings;
	local name SecondWaveID;

	//find the current campaign settings
	foreach StartState.IterateByClassType(class'XComGameState_CampaignSettings', CampaignSettings)
	{
		break;
	}

	//we got no campaign.. bail
	if (CampaignSettings == none)
	{
		`LOG("NewCampaign Settings could not be found", default.bEnableLogging,'WOTC_RAT');
		return;
	}

	//for each one in the configs, that isn't enabled, set it enabled
	foreach default.AutoEnableSecondWaveIDs(SecondWaveID)
	{
		if (!CampaignSettings.IsSecondWaveOptionEnabled(SecondWaveID))
		{
			CampaignSettings.AddSecondWaveOption(SecondWaveID);
			`Log("Added Second Wave Option with ID:" @ SecondWaveID, default.bEnableLogging,'WOTC_RAT');
		}
	}
}*/

/// Called on first time load game if not already installed	
static event OnLoadedSavedGame(){}								//empty_func

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToTactical(){}					//empty_func

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToStrategy()
{
	PutBluescreensInDeck();
}					

//*******************************************************************************************
// ADD/CHANGES AFTER TEMPLATES LOAD ~ OPTC ~
//*******************************************************************************************

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager				AllAbilities;		//holder for all abilities
	local X2ItemTemplateManager					AllItems;			//holder for all items
	local X2StrategyElementTemplateManager		AllStratElems;		//holder for all strat elements
	local X2CharacterTemplateManager			CharacterTemplateMgr;

	local X2AbilityTemplate						CurrentAbility;		//current things to focus on
	//local X2EquipmentTemplate					CurrentEquip;
	local X2ArmorTemplate						CurrentArmor;
	//local X2WeaponTemplate					CurrentWeapon;
	//local X2PairedWeaponTemplate				CurrentShard;
	//local X2GrenadeLauncherTemplate			CurrentLauncher;
	local X2GrenadeTemplate						CurrentGrenade;
	//local X2AmmoTemplate						CurrentAmmo;
	//local X2ItemTemplate						CurrentItem;
	//local X2GremlinTemplate					CurrentGremlin;

	local X2StrategyElementTemplate				CurrentStrat;
	//local X2CovertActionTemplate				CurrentCA;
	local X2SoldierUnlockTemplate				CurrentSUT;
	//local X2SoldierAbilityUnlockTemplate		CurrentSAUT;
	local X2TechTemplate						CurrentTech;

	//local X2Effect							TempEffect;			//placeholder for searching

	local X2Effect_Persistent					BleedingEffect;		//Added to Deadeye
	local X2Effect_PersistentStatChange			DisorientedEffect;	//Added to Deadeye
	local X2Effect_VM_RUSTY						VolMixEffect;		//new scaling Volatile Mix Effect
	local X2Effect_BPED_Fix_RUSTY				PaddingEffect;		//new Blast Padding Env Dam Effect

	//local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;	//used to apply damage

	local X2Condition_UnitProperty				UnitCondition;		//used for ~inspire~ target fixes

	local X2DataTemplate						DifficultyTemplate;	//used for armour varients
	local array<X2DataTemplate>					DifficultyTemplates;

	local StrategyRequirement 					AltReq;				//used for adjustments to MOF PG Projects
	local ArtifactCost 							Resources;

	local X2AbilityCost_ActionPoints			APCost;				//placeholder for new APcosts
	//local X2AbilityCost_Charges				ChargeCost;			//placeholder for new ChargeCosts
	local X2AbilityCooldown						Cooldown;			//placeholder for new Cooldowns

	//KAREN !! Get all the (template) managers !!
	AllAbilities			= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AllItems				= class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	AllStratElems			= class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	CharacterTemplateMgr	= class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	LogCrossClassAbilities(AllAbilities);
	LogCurrentGamesTechs(AllStratElems);

	PatchBluescreenTech(AllStratElems);
	UpdateBombardActionPointCosts();	//bombard has a weird no-point free action point cost, this removes it

	AddLootTables();

	//////////////////////////////////////////////////////////////////////////////////////////
	// SCANNING PROTOCOL:	FIX GREMLINS TO GIVE BONUS CHARGES
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_SCANNINGPROTOCOL)
	{
		PatchGremlinBonuses(AllItems.FindItemTemplate('Gremlin_CV'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_CV);
		PatchGremlinBonuses(AllItems.FindItemTemplate('Gremlin_MG'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_MG);
		PatchGremlinBonuses(AllItems.FindItemTemplate('Gremlin_BM'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_BM);

		PatchGremlinBonuses(AllItems.FindItemTemplate('Gremlin_MP'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_MP);
		PatchGremlinBonuses(AllItems.FindItemTemplate('Gremlin_Shen'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_SHEN);

		PatchGremlinBonuses(AllItems.FindItemTemplate('SparkBit_CV'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_CV,2,40,0);
		PatchGremlinBonuses(AllItems.FindItemTemplate('SparkBit_MG'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_MG,2,40,1);
		PatchGremlinBonuses(AllItems.FindItemTemplate('SparkBit_BM'), default.iSCANNINGPROTOCOL_BONUS_CHARGES_BM,2,40,2);

		PatchBitAnimSets(CharacterTemplateMgr.FindCharacterTemplate('SparkBitMk1') );
		PatchBitAnimSets(CharacterTemplateMgr.FindCharacterTemplate('SparkBitMk2') );
		PatchBitAnimSets(CharacterTemplateMgr.FindCharacterTemplate('SparkBitMk3') );

		`LOG("Patched :: ScanningProtocol Changes on Gremlins and Bits",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// ULTRASONIC LURE:	NO LONGER BREAKS CONCEALMENT
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_NCB_ULTRASONICLURE)
	{
		CurrentGrenade = X2GrenadeTemplate(AllItems.FindItemTemplate('UltrasonicLure'));
		if (CurrentGrenade != none)
		{
			CurrentGrenade.bOverrideConcealmentRule = true;
			CurrentGrenade.OverrideConcealmentRule = eConceal_Always;
		}

		`LOG("Patched :: Ultra Sonic Lure NCB",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// FROSTSCALE VEST:	LIMIT TO VEST SLOT
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_VEST_FROSTSCALESLOT)
	{
		CurrentGrenade = X2GrenadeTemplate(AllItems.FindItemTemplate('FrostScaleVest'));
		if (CurrentGrenade != none)
		{
			CurrentGrenade.InventorySlot = eInvSlot_Vest;
		}

		`LOG("Patched :: FrostScale Vest to Vest slot",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// SPARKS HUNTER PROTOCOL:	NO LONGER BREAKS CONCEALMENT, NO HAIR TRIGGER
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_NCB_HUNTERPROTOCOL)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('HunterProtocolTrigger');
		if (CurrentAbility != none)
		{
			UnitCondition = new class'X2Condition_UnitProperty';
			UnitCondition.ExcludeConcealed = true;
			CurrentAbility.AbilityShooterConditions.AddItem(UnitCondition);
		}

		CurrentAbility = AllAbilities.FindAbilityTemplate('HunterProtocolShot');
		if (CurrentAbility != none)
		{
			UnitCondition = new class'X2Condition_UnitProperty';
			UnitCondition.ExcludeConcealed = true;
			CurrentAbility.AbilityShooterConditions.AddItem(UnitCondition);

			CurrentAbility.bAllowFreeFireWeaponUpgrade = false; 
		}

		`LOG("Patched :: Hunter Protocol NCB",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// WAR SUIT NO LONGER HAS SHIELD WALL (BUGGED) 
	//	REPLACED BY NEW MINI KINETIC PLATING (X2Ability_MKP_RUSTY)
	//	GETS NEW PASSIVE ICON, MISSED SHOTS CREATE SHIELDS 2 PER MISS TO 6 MAX
	//////////////////////////////////////////////////////////////////////////////////////////

	// NO PASSIVE ICON FOR	::	SHIELDWALL		GRANTED STUFF	:: USELESS BUGGED ABILITY	AB_TEMPLATE_NAME	::	HighCoverGenerator

	// REMOVE SHIELDWALL AND ADD MKP ABILITY TO WARSUIT ARMOUR
	if (default.bRAT_ARMOUR_WARSUIT_SWAPSHIELDWALLFORMKP)
	{
		CurrentArmor = X2ArmorTemplate(AllItems.FindItemTemplate('HeavyPoweredArmor'));
		if ( CurrentArmor != none )
		{
			if ( CurrentArmor.bShouldCreateDifficultyVariants == true )
			{
				AllItems.FindDataTemplateAllDifficulties('HeavyPoweredArmor', DifficultyTemplates);
				foreach DifficultyTemplates(DifficultyTemplate)
				{
					CurrentArmor = X2ArmorTemplate(DifficultyTemplate);
					CurrentArmor.Abilities.RemoveItem('HighCoverGenerator');
					CurrentArmor.Abilities.AddItem('MKP_RUSTY');
				}
			}
			else
			{
				// Same as above but only for one difficulty
				CurrentArmor.Abilities.RemoveItem('HighCoverGenerator');
				CurrentArmor.Abilities.AddItem('MKP_RUSTY');
			}
		}

		`LOG("Patched :: WAR Suit Shieldwall to MKP",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// RAGE SUIT TECH FIX
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ARMOUR_RAGESUIT_TECHFIX)
	{
		CurrentArmor = X2ArmorTemplate(AllItems.FindItemTemplate('HeavyAlienArmorMk2'));
		if ( CurrentArmor != none )
		{
			if ( CurrentArmor.bShouldCreateDifficultyVariants == true )
			{
				AllItems.FindDataTemplateAllDifficulties('HeavyAlienArmorMk2', DifficultyTemplates);
				foreach DifficultyTemplates(DifficultyTemplate)
				{
					CurrentArmor = X2ArmorTemplate(DifficultyTemplate);
					CurrentArmor.ArmorTechCat = 'powered';
				}
			}
			else
			{
				// Same as above but only for one difficulty
				CurrentArmor.ArmorTechCat = 'powered';
			}
		}

		`LOG("Patched :: WAR Suit Shieldwall to MKP",default.bEnableLogging,'WOTC_RAT');
	}

	/////////////////////////////////////////////////////////////////
	// Fix the PROFICIENCY IMAGE
	/////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_PROFICIENCYSSI)
	{
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('WOTC_APA_SixthSense'), 		"UILibrary_RATImages.UIPerk_SixthSense");

	}

	/////////////////////////////////////////////////////////////////
	// Fix the 'insights' imagery
	/////////////////////////////////////////////////////////////////

	if (default.bRAT_INSIGHT_IMAGE)
	{
		PatchImages_Item(AllItems.FindItemTemplate('Insight'), "UILibrary_RATImages.Inv_XCOM_Datapad");
	}

	/////////////////////////////////////////////////////////////////
	// Fix the plasma grenade image
	/////////////////////////////////////////////////////////////////

	if (default.bRAT_GRENADE_PLASMA_IMAGE)
	{
		PatchImages_Item(AllItems.FindItemTemplate('AlienGrenade'), "UILibrary_RATImages.Inv_Plasma_GrenadeFIX");
	}

	/////////////////////////////////////////////////////////////////
	// ADD NEW SCALING VOLATILE MIX
	/////////////////////////////////////////////////////////////////

	if (default.bRAT_GRENADE_SCALEVOLMIX)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('VolatileMix');
		if (CurrentAbility != none)
		{
			VolMixEffect = new class'X2Effect_VM_Rusty';
			VolMixEffect.BuildPersistentEffect(1, true, true, true);
			VolMixEffect.SetDisplayInfo(ePerkBuff_Passive, CurrentAbility.LocFriendlyName, CurrentAbility.GetMyLongDescription(), CurrentAbility.IconImage,true,,CurrentAbility.AbilitySourceName);
			CurrentAbility.AddTargetEffect(VolMixEffect);

			`LOG("Patched :: Volatile Mix to Scaling",default.bEnableLogging,'WOTC_RAT');
		}
	}

	/////////////////////////////////////////////////////////////////
	// FIX BLAST PADDING EXPLOSIVE ENV DAMAGE IF NOT ALREADY PATCHED
	//		Detects if you have RealityMachina's fix already.
	/////////////////////////////////////////////////////////////////
	
	if (default.bRAT_ARMOUR_FIX_BLASTPADDING_ENV)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('BlastPadding');
		if ( CurrentAbility.AbilityTargetEffects.Length == 1 )
		{ 
			PaddingEffect = new class'X2Effect_BPED_Fix_RUSTY';
			PaddingEffect.ExplosiveDamageReduction = class'X2Ability_GrenadierAbilitySet'.default.BLAST_PADDING_DMG_ADJUST;
				//blast padding already adds a passive, but this allows the flyover text to appear for the additional effects
			PaddingEffect.SetDisplayInfo(ePerkBuff_Bonus, CurrentAbility.LocFriendlyName, CurrentAbility.GetMyHelpText(), CurrentAbility.IconImage, false,, CurrentAbility.AbilitySourceName);
			PaddingEffect.BuildPersistentEffect(1, true, false);
			CurrentAbility.AddTargetEffect(PaddingEffect);
		}

		`LOG("Patched :: Blast Padding Explosive DR",default.bEnableLogging,'WOTC_RAT');
	}
	
	/////////////////////////////////////////////////////////////////
	// FIX WEAPON TIERS OF SOME WEAPONS
	/////////////////////////////////////////////////////////////////

	if (default.bRAT_WEAPON_FIX_TIERS)
	{
		//base game grenade launchers
		PatchWeaponTiers(AllItems.FindItemTemplate('GrenadeLauncher_CV'), 	'conventional');
		PatchWeaponTiers(AllItems.FindItemTemplate('GrenadeLauncher_MG'), 	'magnetic');

		//modded grenade launcher
		PatchWeaponTiers(AllItems.FindItemTemplate('GrenadeLauncher_BM'), 	'beam');			

		//medikits & nano medikits
		PatchWeaponTiers(AllItems.FindItemTemplate('Medikit'), 				'conventional');
		PatchWeaponTiers(AllItems.FindItemTemplate('NanoMedikit'), 			'alien');
		
		//Reaper Claymore
		PatchWeaponTiers(AllItems.FindItemTemplate('Reaper_Claymore'), 		'conventional');

		//heavy weapons
		PatchWeaponTiers(AllItems.FindItemTemplate('RocketLauncher'), 		'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('ShredderGun'), 			'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('ShredstormCannon'), 	'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('Flamethrower'), 		'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('FlamethrowerMk2'), 		'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('BlasterLauncher'), 		'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('PlasmaBlaster'), 		'heavy');

		//mod added heavy weapon... CX Hive
		PatchWeaponTiers(AllItems.FindItemTemplate('BroodGauntlet'), 		'heavy');

		//mod added heavy weapon... CX Bio DIvision
		PatchWeaponTiers(AllItems.FindItemTemplate('BioBlasterLauncherXCom'),'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('Weapon_BioRocket'), 	'heavy');

		//mod added heavy weapon... Bitterfrost Protocol
		PatchWeaponTiers(AllItems.FindItemTemplate('MZCryoLauncher'), 		'heavy');
		PatchWeaponTiers(AllItems.FindItemTemplate('MZCryoLauncherMk2'), 	'heavy');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// SCHISM (INSANITY DAMAGE AND VOID RIFT INSANITY DAMAGE)
	// TEMPLAR VOLT BYPASS SHIELDS
	// SPECTRE HORROR BYPASSES SHIELDS (LIKELY OVERWRITTEN BY CX SPECTRE REVAMP)
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_IGNORESHIELDS_INSANITY)		{	PatchAbility_ShieldsBypass(AllAbilities.FindAbilityTemplate('Insanity'));			}
	if (default.bRAT_ABILITIES_IGNORESHIELDS_VOIDINSANITY)	{	PatchAbility_ShieldsBypass(AllAbilities.FindAbilityTemplate('VoidRiftInsanity'));	}
	if (default.bRAT_ABILITIES_IGNORESHIELDS_VOLT)			{	PatchAbility_ShieldsBypass(AllAbilities.FindAbilityTemplate('Volt'));				}
	if (default.bRAT_ABILITIES_IGNORESHIELDS_HORROR)		{	PatchAbility_ShieldsBypass(AllAbilities.FindAbilityTemplate('Horror'));				}

	//////////////////////////////////////////////////////////////////////////////////////////
	// DEADEYE PERK CAUSES BLEEDING AND DISORIENTATION
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_DEADEYE_ADDBLEEDDISORIENT)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('Deadeye');
		//Bleeding Status effect (iNumTurns, iDamagePerTick)
		BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(3, 1);
		CurrentAbility.AddTargetEffect(BleedingEffect);

		//Disoriented Status Effect (ob ExcludeFriendlyToSource=false, fDelayVis=0.0f, obIsMental=true)
		DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true,0.0f,false);
		DisorientedEffect.iNumTurns = 2;
		CurrentAbility.AddTargetEffect(DisorientedEffect);

		`LOG("Patched :: Deadeye to apply Bleeding and Disorient",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// REMOTESTART PERK GIVES MZ DETONATION SHOT (SHOT + FUSE)
	//struct AdditionalCooldownInfo
	//{
	//	var() name AbilityName;					""
	//	var() int NumTurns;						0
	//	var() bool bUseAbilityCooldownNumTurns;	false
	//	var() name ApplyCooldownType;			"AdditionalCooldown_ApplyLarger"
	//}	
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_REMOTESTART_GIVES_MZDETONATIONSHOT)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('RemoteStart');

			Cooldown = new class'X2AbilityCooldown';
			Cooldown.iNumTurns = class'X2Ability_ReaperAbilitySet'.default.RemoteStartCooldown;
			//Cooldown.AditionalAbilityCooldowns.AddItem(AbilityName='MZDetonationShot', NumTurns=1, bUseAbilityCooldownNumTurns=true);
			Cooldown.AditionalAbilityCooldowns.AddItem(default.ccRemoteFuseShared_Start);
			CurrentAbility.AbilityCooldown = Cooldown;
			
			CurrentAbility.ShotHUDPriority = 320; //corporal level
			CurrentAbility.IconImage = "img:///UILibrary_RATImages.UIPerk.UIPerk_TargetBarrel";

			CurrentAbility.AdditionalAbilities.AddItem('MZDetonationShot');

		CurrentAbility = AllAbilities.FindAbilityTemplate('MZDetonationShot');

			Cooldown = new class'X2AbilityCooldown';
			Cooldown.iNumTurns = class'X2Ability_ReaperAbilitySet'.default.RemoteStartCooldown;
			//Cooldown.AditionalAbilityCooldowns.AddItem(AbilityName='RemoteStart', NumTurns=1, bUseAbilityCooldownNumTurns=true);
			Cooldown.AditionalAbilityCooldowns.AddItem(default.ccRemoteFuseShared_Detonation);
			CurrentAbility.AbilityCooldown = Cooldown;

			CurrentAbility.bDontDisplayInAbilitySummary = false;

			CurrentAbility.ShotHUDPriority = 325; //next to remote start
			CurrentAbility.ActivationSpeech = 'RemoteStart';

			CurrentAbility.SuperConcealmentLoss = 0;

		`LOG("Patched :: Remote Start can with Remote Finish Detonation Shot. Shared Cooldown.",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// SKIRMISHER MELEE NO COOLDOWN, MAKES NO SENSE
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_RETRIBUTION_COOLDOWN)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('SkirmisherMelee');
		CurrentAbility.AbilityCooldown = none;

		`LOG("Patched :: Ripjack Melee no cooldowns",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// COMBAT PRESENCE : FREE ACTION
	//		NO LONGER BREAKS CONCEALMENT
	//		ADD INSPIRE TARGETING FIXES, SAME COOLDOWN AS INSPIRE ABILITY
	//		COMBAT PRESCENCE CAN WORK ON SPARKS/TURRETS/BOTS
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_COMPRESENCE_NCB_FREE)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('CombatPresence');

		CurrentAbility.ConcealmentRule = eConceal_Always;

		CurrentAbility.AbilityCosts.Length = 0;
		APCost = new class'X2AbilityCost_ActionPoints';
			APCost.iNumPoints = 1;
			APCost.bFreeCost = true;
			APCost.bConsumeAllPoints = false;
			APCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
		CurrentAbility.AbilityCosts.AddItem(APCost);
	
		CurrentAbility.AbilityCooldown = CreateCooldown(class'X2Ability_PsiOperativeAbilitySet'.default.INSPIRE_COOLDOWN);

		UnitCondition = new class 'X2Condition_UnitProperty';
			UnitCondition.ExcludeDazed = true;
			UnitCondition.ExcludeStunned = true;
			UnitCondition.ExcludePanicked = true;
			UnitCondition.ExcludeInStasis = true;
			UnitCondition.ExcludeDead = true;
			//UnitCondition.ExcludeTurret = true;
			//UnitCondition.ExcludeRobotic = true;
			UnitCondition.ExcludeFriendlyToSource = false;
			UnitCondition.ExcludeHostileToSource = true;
		CurrentAbility.AbilityTargetConditions.AddItem(UnitCondition);

		`LOG("Patched :: Combat Prescence Targets NCB FREE",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// INSPIRE : FREE ACTION
	//		NO LONGER BREAKS CONCEALMENT
	//		LOTS OF TARGETTING FIXES
	//		INSPIRE CAN NOT WORK ON SPARKS/TURRETS/BOTS (NO MIND ~ PSI)
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_INSPIRE_NCB_FREE)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('Inspire');

		CurrentAbility.ConcealmentRule = eConceal_Always;

		CurrentAbility.AbilityCosts.Length = 0;

		CurrentAbility.AbilityCosts.AddItem(CreateAPCost(1,true,false));

		UnitCondition = new class 'X2Condition_UnitProperty';
			UnitCondition.ExcludeDazed = true;
			UnitCondition.ExcludeStunned = true;
			UnitCondition.ExcludePanicked = true;
			UnitCondition.ExcludeInStasis = true;
			UnitCondition.ExcludeDead = true;
			UnitCondition.ExcludeTurret = true;
			UnitCondition.ExcludeRobotic = true;
			UnitCondition.ExcludeFriendlyToSource = false;
			UnitCondition.ExcludeHostileToSource = true;
		CurrentAbility.AbilityTargetConditions.AddItem(UnitCondition);

		`LOG("Patched :: Inspire Targets NCB FREE",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// BONDMATE TEAMWORKS : FREE ACTION
	//		STILL USES A SHARED CHARGE
	//		NO LONGER BREAKS CONCEALMENT
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_TEAMWORK_NCB_FREE)
	{
		PatchAbility_BondMate(AllAbilities.FindAbilityTemplate('BondmateTeamwork'));
		PatchAbility_BondMate(AllAbilities.FindAbilityTemplate('BondmateTeamwork_Improved'));
		PatchAbility_BondMate(AllAbilities.FindAbilityTemplate('BondmateTeamwork_Spark'));
		PatchAbility_BondMate(AllAbilities.FindAbilityTemplate('BondmateTeamwork_Improved_Spark'));

		`LOG("Patched :: Teamwork NCB FREE",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Makes Sniper rifle shot, SniperRifle Overwatch and Sniper Rifle Longwatch
	//	not vanish from the shot hud bar
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_SNIPERSHOTSSTICKY)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('SniperStandardFire'); 	CurrentAbility.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
		CurrentAbility = AllAbilities.FindAbilityTemplate('SniperRifleOverwatch'); 	CurrentAbility.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
		CurrentAbility = AllAbilities.FindAbilityTemplate('LongWatch'); 			CurrentAbility.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

		`LOG("Patched :: Snipershots HUD Stickified",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	/* MOVE NON-COMBAT && ALL/OBJECTIVE ICONS TO THE END OF THE ABILITY BAR		UIUtilities_Tactical
		Puts Pistol Shot and Pistol OW next to Standard Shot and OW
		Moves Hunker and Loot to before interactives
	
	PARRY_PRIORITY				= 50;	REND_PRIORITY					= 60;	SHOULD_HUNKER_PRIORITY 	= 69;	MUST_RELOAD_PRIORITY		= 70;
	STANDARD_SHOT_PRIORITY		= 100;	STANDARD_PISTOL_SHOT_PRIORITY 	= 210;	OVERWATCH_PRIORITY		= 200;	PISTOL_OVERWATCH_PRIORITY	= 220;
	OBJECTIVE_INTERACT_PRIORITY	= 230;	EVAC_PRIORITY					= 240;
	CLASS_SQUADDIE_PRIORITY		= 310;	CLASS_CORPORAL_PRIORITY			= 320;	CLASS_SERGEANT_PRIORITY	= 330;	CLASS_LIEUTENANT_PRIORITY	= 340;	CLASS_CAPTAIN_PRIORITY	= 350;
	CLASS_MAJOR_PRIORITY		= 360;	CLASS_COLONEL_PRIORITY			= 370;	HUNKER_DOWN_PRIORITY	= 400;	INTERACT_PRIORITY 			= 500;	HACK_PRIORITY			= 600;
	LOOT_PRIORITY				= 700;	RELOAD_PRIORITY 				= 800;
	STABILIZE_PRIORITY			= 900;	MEDIKIT_HEAL_PRIORITY			= 1000;	COMBAT_STIMS_PRIORITY	= 1100;
	UNSPECIFIED_PRIORITY		= 1200;
	STANDARD_GRENADE_PRIORITY	= 1300;	ALIEN_GRENADE_PRIORITY			= 1400;	FLASH_BANG_PRIORITY		= 1500;	FIREBOMB_PRIORITY			= 1600;
	STASIS_LANCE_PRIORITY		= 1700;	ARMOR_ACTIVE_PRIORITY			= 1800;	
	
	// commander abilities must be placed after normal ability priorities << wtf does this mean? it means everything else needs to be before 1999
	PLACE_EVAC_PRIORITY		= 2000;

	*/
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ABILITIES_SHIFTPOSITIONS_NONCOMBATIVES)
	{
		// ===== PISTOL SHOT ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('StandardPistolShot'); 				CurrentAbility.ShotHUDPriority = 101;

		// ===== OVERWATCHES ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('OverwatchAll'); 						CurrentAbility.ShotHUDPriority = 201;
		CurrentAbility = AllAbilities.FindAbilityTemplate('OverwatchOthers');					CurrentAbility.ShotHUDPriority = 202;
		CurrentAbility = AllAbilities.FindAbilityTemplate('PistolOverwatch');					CurrentAbility.ShotHUDPriority = 203;

		// ===== HUNKER AND LOOT ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('HunkerDown'); 						CurrentAbility.ShotHUDPriority = 1810;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Loot'); 								CurrentAbility.ShotHUDPriority = 1815;
		CurrentAbility = AllAbilities.FindAbilityTemplate('CarryUnit'); 						CurrentAbility.ShotHUDPriority = 1820;
		CurrentAbility = AllAbilities.FindAbilityTemplate('PutDownUnit'); 						CurrentAbility.ShotHUDPriority = 1825;

		// ===== INTERACTS ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_OpenDoor');					CurrentAbility.ShotHUDPriority = 1830;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_OpenChest');				CurrentAbility.ShotHUDPriority = 1835;
		CurrentAbility = AllAbilities.FindAbilityTemplate('GatherEvidence');					CurrentAbility.ShotHUDPriority = 1840;
		CurrentAbility = AllAbilities.FindAbilityTemplate('PlantExplosiveMissionDevice'); 		CurrentAbility.ShotHUDPriority = 1845;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact');							CurrentAbility.ShotHUDPriority = 1850;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_PlantBomb');				CurrentAbility.ShotHUDPriority = 1855;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_TakeVial');					CurrentAbility.ShotHUDPriority = 1860;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_StasisTube');				CurrentAbility.ShotHUDPriority = 1865;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_SweaterTube');				CurrentAbility.ShotHUDPriority = 1870;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_MarkSupplyCrate');			CurrentAbility.ShotHUDPriority = 1875;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Interact_ActivateAscensionGate');	CurrentAbility.ShotHUDPriority = 1880;

		// ===== HACKS ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('Hack');								CurrentAbility.ShotHUDPriority = 1885;
		CurrentAbility = AllAbilities.FindAbilityTemplate('ChallengeMode_Hack');				CurrentAbility.ShotHUDPriority = 1890;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Hack_Chest');						CurrentAbility.ShotHUDPriority = 1895;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Hack_ObjectiveChest');				CurrentAbility.ShotHUDPriority = 1900;
		CurrentAbility = AllAbilities.FindAbilityTemplate('ChallengeMode_Hack_ObjectiveChest');	CurrentAbility.ShotHUDPriority = 1905;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Hack_Workstation');					CurrentAbility.ShotHUDPriority = 1910;
		CurrentAbility = AllAbilities.FindAbilityTemplate('ChallengeMode_Hack_Workstation');	CurrentAbility.ShotHUDPriority = 1915;
		CurrentAbility = AllAbilities.FindAbilityTemplate('Hack_Scan');							CurrentAbility.ShotHUDPriority = 1920;

		// ===== EVACS ===== \\
		CurrentAbility = AllAbilities.FindAbilityTemplate('Evac');								CurrentAbility.ShotHUDPriority = 1950;		CurrentAbility.HideErrors.AddItem('AA_NotInsideEvacZone');
		CurrentAbility = AllAbilities.FindAbilityTemplate('EvacAll');							CurrentAbility.ShotHUDPriority = 1955;		CurrentAbility.HideErrors.AddItem('AA_NotInsideEvacZone');

		`LOG("Patched :: Interactive Abilities HUD Priorities",default.bEnableLogging,'WOTC_RAT');
	}


	//////////////////////////////////////////////////////////////////////////////////////////
	// Swap Icon slides for modded GTS skills to newly created ones
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_STRATELEM_GTSSPARK)
	{
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('SparkRegeneration'), 		"UILibrary_RATImages.GTS_SPARK_REGEN");
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('SparkCPUAcceleration'), 	"UILibrary_RATImages.GTS_SPARK_HACK");
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('SparkDefensiveStance'), 	"UILibrary_RATImages.GTS_SPARK_DEF");

		PatchImages_Ability(AllAbilities.FindAbilityTemplate('SparkRegeneration'), 		"UILibrary_RATImages.UIPerk.perk_regeneration");
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('SparkDefensiveStance'), 	"UILibrary_RATImages.UIPerk.perk_defensivestance");
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('SparkCPUAcceleration'), 	"UILibrary_RATImages.UIPerk.perk_acceleration");

		`LOG("Patched :: GTS SPARK Slides and icons swapped",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Swap Icon slides for proving ground techs to newly created ones
	// Incorporated into base mod
	//////////////////////////////////////////////////////////////////////////////////////////
	
	if (default.bRAT_STRATELEM_HIVE)
	{
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('HiveQueenArmorTech'), 	"UILibrary_RATImages.TEC_N_HiveArmor");
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('HiveWingTech'), 		"UILibrary_RATImages.TEC_N_HiveWings");
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('HiveCannonTech'), 		"UILibrary_RATImages.TEC_N_HiveCannon");
		PatchImages_Techs(AllStratElems.FindStrategyElementTemplate('HiveGauntletTech'), 	"UILibrary_RATImages.TEC_N_HiveGauntlet");

		`LOG("Patched :: HIVE Proving Ground Slides icons swapped",default.bEnableLogging,'WOTC_RAT');
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// MOF TECH REQUIREMENTS CHANGES
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_STRATELEM_MOFSPARKS)
	{
		CurrentStrat = AllStratElems.FindStrategyElementTemplate('SPARKMayhem');
		if (X2TechTemplate (CurrentStrat) != none)
		{
			CurrentTech = X2TechTemplate (CurrentStrat);
			CurrentTech.Requirements.RequiredTechs.AddItem('SPARKSuppression');

			CurrentTech.AlternateRequirements.Length = 0;
				AltReq.RequiredTechs.AddItem('MechanizedWarfare');
				AltReq.RequiredTechs.AddItem('AutopsyAdventMEC');
				AltReq.RequiredTechs.AddItem('SPARKSuppression');
				CurrentTech.AlternateRequirements.AddItem(AltReq);
		}

		CurrentStrat = AllStratElems.FindStrategyElementTemplate('SPARKNanomachines');
		if (X2TechTemplate (CurrentStrat) != none)
		{
			CurrentTech = X2TechTemplate (CurrentStrat);
			CurrentTech.Requirements.RequiredTechs.Length = 0;
				CurrentTech.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
				CurrentTech.Requirements.RequiredTechs.AddItem('AutopsySpectre');

			CurrentTech.AlternateRequirements.Length = 0;
				AltReq.RequiredTechs.AddItem('MechanizedWarfare');
				AltReq.RequiredTechs.AddItem('AutopsySpectre');
				CurrentTech.AlternateRequirements.AddItem(AltReq);

			CurrentTech.Cost.ResourceCosts.Length = 0;

			//resource cost
			Resources.ItemTemplateName = 'CorpseSpectre';
			Resources.Quantity = default.CorpseCost;
			CurrentTech.Cost.ResourceCosts.AddItem(Resources);

			Resources.ItemTemplateName = 'Supplies';
			Resources.Quantity = default.MedSuppliesCost;
			CurrentTech.Cost.ResourceCosts.AddItem(Resources);
		}

		`LOG("Patched :: Metal Over Flesh :: Mayhem requires suppression, Nanomachines requires Spectre autopsy",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// SQUAD SIZE TECH REQUIREMENTS CHANGES
	//	 DESIGNED FOR SQUADSIZE 6 START USING RJSS, 7TH IS SPARK, 8TH IS NULL
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_STRATELEM_SSUPGRADE)
	{
		CurrentStrat = AllStratElems.FindStrategyElementTemplate('SquadSizeIIUnlock');
		if (X2SoldierUnlockTemplate (CurrentStrat) != none)
		{
			CurrentSUT = X2SoldierUnlockTemplate (CurrentStrat);
			CurrentSUT.bAllClasses = true;
			
			CurrentSUT.Requirements.RequiredHighestSoldierRank = 9;
			CurrentSUT.Requirements.bVisibleIfSoldierRankGatesNotMet = false;
		}

		CurrentStrat = AllStratElems.FindStrategyElementTemplate('SquadSizeIUnlock');
		if (X2SoldierUnlockTemplate (CurrentStrat) != none)
		{
			CurrentSUT = X2SoldierUnlockTemplate (CurrentStrat);
			CurrentSUT.bAllClasses = true;

			CurrentSUT.Requirements.RequiredHighestSoldierRank = 0;
			CurrentSUT.Requirements.RequiredSoldierClass = 'SPARK';
			CurrentSUT.Requirements.RequiredSoldierRankClassCombo = true;
			CurrentSUT.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// COVERT ACTION CHANGES
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_CA_TWEAKS)
	{
		PatchCovertActions(AllStratElems.FindStrategyElementTemplate('CovertAction_PrepareRescue'), true );
		PatchCovertActions(AllStratElems.FindStrategyElementTemplate('CovertAction_RescueSoldier') );

		PatchCovertActions(AllStratElems.FindStrategyElementTemplate('CovertAction_PrepareGOp') );
		PatchCovertActions(AllStratElems.FindStrategyElementTemplate('CovertAction_PrepareRaid') );
		PatchCovertActions(AllStratElems.FindStrategyElementTemplate('CovertAction_PrepareResOp') );

		`LOG("Patched :: CA :: Removed Ambush risks, forced to show as available",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CX HIVE PCS INVENTORY IMAGES
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_PCS_FIX_IMAGESHIVE)
	{
		PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalCoverage'), "UILibrary_RATImages.INV_PCS_HIVE_SPAWN");
		PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalWithdraw'), "UILibrary_RATImages.INV_PCS_HIVE_SPAWN");
		PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalSensesOffense'), "UILibrary_RATImages.INV_PCS_HIVE_RUSH");
		PatchImages_Item(AllItems.FindItemTemplate('PCSTacticalSensesDefense'), "UILibrary_RATImages.INV_PCS_HIVE_RUSH");

		`LOG("Patched :: Fixed HIVE PCS panel image",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CX Psi OPS Phase Drone Weapon Icon Fix (For RoboJumpers Squad Select UI++)
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_WEAPON_FIX_PSIOP_PHASEDRONEPANEL)
	{
		PatchImages_Item(AllItems.FindItemTemplate('PsiDroneBeamM1_WPN'), "UILibrary_RATImages.Inv_Phasedrone_WPN");
		PatchImages_Item(AllItems.FindItemTemplate('PsiDroneBeamM2_WPN'), "UILibrary_RATImages.Inv_Phasedrone_WPN");
		PatchImages_Item(AllItems.FindItemTemplate('PsiDroneBeamM3_WPN'), "UILibrary_RATImages.Inv_Phasedrone_WPN");

		`LOG("Patched :: Psi Drone weapon panel image",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Fix up the CX HIVE Summon Abilities Costs
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_CXHIVE_SUMMONTWEAKS)
	{
		CurrentAbility = AllAbilities.FindAbilityTemplate('CallXComRippers');
		if (CurrentAbility != none)
		{
			CurrentAbility.AbilityCosts.Length = 0;

			CurrentAbility.AbilityCosts.AddItem(CreateAPCost(1,true,false));	
			CurrentAbility.AbilityCosts.AddItem(CreateChargeCost(1));
			CurrentAbility.AbilityCooldown = CreateCooldown(1);
		}

		CurrentAbility = AllAbilities.FindAbilityTemplate('CallRandomHiveMember');
		if (CurrentAbility != none)
		{
			CurrentAbility.AbilityCosts.Length = 0;

			CurrentAbility.AbilityCosts.AddItem(CreateAPCost(1,true,false));	
			CurrentAbility.AbilityCosts.AddItem(CreateChargeCost(1));
			CurrentAbility.AbilityCooldown = CreateCooldown(1);
		}

		`LOG("Patched :: HIVE Summons cooldowns and costs",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Fix up the Icon used for the rulers escape ability and Zerker Queen abilities!
	//		Includes mod support for the CX HIVE
	//////////////////////////////////////////////////////////////////////////////////////////

	if (default.bRAT_ICONFIXUP_RULERESCAPE)
	{
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('AlienRulerCallForEscape'), "UILibrary_PerkIcons.UIPerk_psi_rift");
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('HiveQueenCallForEscape'), "UILibrary_PerkIcons.UIPerk_psi_rift");
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('ChildrenCallForEscape'), "UILibrary_PerkIcons.UIPerk_psi_rift");

		`LOG("Patched :: Alien Escape icon",default.bEnableLogging,'WOTC_RAT');
	}

	if (default.bRAT_ICONFIXUP_RULERZERKER)
	{
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('Faithbreaker'), "UILibrary_DLC2Images.PerkIcons.UIPerk_beserker_faithbreaker");
		PatchImages_Ability(AllAbilities.FindAbilityTemplate('Quake'), "UILibrary_DLC2Images.PerkIcons.UIPerk_beserker_quake");

		`LOG("Patched :: ZerkerQueen icons",default.bEnableLogging,'WOTC_RAT');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////

} //END static event OnPostTemplatesCreated()

//*******************************************************************************************
// HELPER FUNCTIONS
//*******************************************************************************************

//*******************************************************************************************
// Tag Expansion Handler - this creates the custom string fields for localisation file
//*******************************************************************************************
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);
	switch (TagText)
	{
		case 'iRAT_MKP_SHIELDSPERMISS':	OutString = string(class'X2Ability_MKP_RUSTY'.default.iRAT_MKP_SHIELDSPERMISS);				return true;
		case 'iRAT_MKP_MAXSHIELDS':		OutString = string(class'X2Ability_MKP_RUSTY'.default.iRAT_MKP_MAXSHIELDS);					return true;
		case 'ACTIVECAMOCOOLDOWN':		OutString = string(class'X2Ability_SPARKBitPerks'.default.SPARK_CONCEAL_COOLDOWN);			return true;
		case 'SPARKMEDICCHARGES':		OutString = string(class'X2Ability_SPARKBitPerks'.default.SPARK_MEDICAL_INITIAL_CHARGES);	return true;
		case 'PSIPCS_BONUS_COMMON':		OutString = string(class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_COMMON);					return true;
		case 'PSIPCS_BONUS_RARE':		OutString = string(class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_RARE);						return true;
		case 'PSIPCS_BONUS_EPIC':		OutString = string(class'X2Ability_PsiPCS'.default.PSIPCS_BONUS_EPIC);						return true;
		default:	return false;
    }  
}

	/////////////////////////////////////////////////////////////////
	// Patch images
	/////////////////////////////////////////////////////////////////

static function PatchImages_Ability(X2AbilityTemplate Template, string ImagePath)
{
	if (Template != none)
	{
		Template.IconImage = "img:///" $ImagePath;
		`LOG("Patched Image Ability Icon :: " @Template.LocFriendlyName ,default.bEnableLogging,'WOTC_RAT');
	}
}

static function PatchImages_Item (X2ItemTemplate Template, string ImagePath)
{
	if (Template != none)
	{
		Template.strImage = "img:///" $ImagePath;
		`LOG("Patched Image Item :: " @Template.GetItemFriendlyName() ,default.bEnableLogging,'WOTC_RAT');
	}
}

static function PatchImages_Techs (X2StrategyElementTemplate Template, string ImagePath)
{
	local X2SoldierAbilityUnlockTemplate SAUT;
	local X2TechTemplate Tech;

	if (X2SoldierAbilityUnlockTemplate(Template) != none)
	{
		SAUT = X2SoldierAbilityUnlockTemplate (Template);
		SAUT.strImage = "img:///" $ImagePath;
	}

	if (X2TechTemplate(Template) != none)
	{
		Tech = X2TechTemplate(Template);
		Tech.strImage = "img:///" $ImagePath;
	}
}

	/////////////////////////////////////////////////////////////////
	// Patch Abilities
	/////////////////////////////////////////////////////////////////

static function PatchAbility_BondMate(X2AbilityTemplate Template)
{
	if (Template != none)
	{
		Template.ConcealmentRule = eConceal_Always;
		Template.AbilityCosts.Length = 0;

		Template.AbilityCosts.AddItem(CreateAPCost(1, true, false));
		Template.AbilityCosts.AddItem(CreateChargeCost(1, true));
	}
}

static function PatchAbility_ShieldsBypass(X2AbilityTemplate Template)
{
	local X2Effect						TempEffect;
	local X2Effect_ApplyWeaponDamage 	WeaponDamageEffect;

	if (Template != none)
	{
		foreach Template.AbilityTargetEffects( TempEffect )
		{
			if ( X2Effect_ApplyWeaponDamage(TempEffect) != none )
			{
				WeaponDamageEffect = X2Effect_ApplyWeaponDamage(TempEffect);
				WeaponDamageEffect.bBypassShields = true;
			}
		}

		`LOG("Patched :: "@Template.LocFriendlyName @" to ignore shields",default.bEnableLogging,'WOTC_RAT');
	}
}

	/////////////////////////////////////////////////////////////////
	// Patch Covert Actions
	/////////////////////////////////////////////////////////////////

static function PatchCovertActions (X2StrategyElementTemplate Template, bool bForce = false)
{
	local X2CovertActionTemplate CurrentCA;

	if (X2CovertActionTemplate (Template) != none)
	{
		CurrentCA = X2CovertActionTemplate (Template);
		CurrentCA.Risks.Length = 0;
		CurrentCA.Risks.AddItem('CovertActionRisk_SoldierWounded');

		CurrentCA.bForceCreation = bForce;
	}

}

	/////////////////////////////////////////////////////////////////
	// Patch Gremlins
	/////////////////////////////////////////////////////////////////

static function PatchGremlinBonuses (X2ItemTemplate Template, int SCB = -1, int Range = -1, int Radius = -1, int Heal = -1)
{
	local X2GremlinTemplate CurrentGremlin;

	CurrentGremlin = X2GremlinTemplate(Template);

	if (CurrentGremlin != none)
	{
		if (SCB >= 0)		{ CurrentGremlin.ScanningChargesBonus = SCB;}
		if (Range >= 0) 	{ CurrentGremlin.iRange = Range;}
		if (Radius >= 0) 	{ CurrentGremlin.iRadius = Radius;}
		if (Heal >= 0) 		{ CurrentGremlin.HealingBonus = Heal;}

		`LOG("Patched Gremlin Template :: " @CurrentGremlin.GetItemFriendlyName() 
				@"\n :: Scan   :: " 	@CurrentGremlin.ScanningChargesBonus 
				@"\n :: Range  :: " 	@CurrentGremlin.iRange
				@"\n :: Radius :: " 	@CurrentGremlin.iRadius
				@"\n :: Heal   :: " 	@CurrentGremlin.HealingBonus
				, default.bEnableLogging,'WOTC_RAT');
	}
}

	/////////////////////////////////////////////////////////////////
	// Patch Weapon Tiers
	/////////////////////////////////////////////////////////////////

static function PatchWeaponTiers (X2ItemTemplate Template, name NewTier)
{
	local X2GrenadeLauncherTemplate CurrentLauncher;
	local X2WeaponTemplate CurrentWeapon;

	CurrentLauncher = X2GrenadeLauncherTemplate (Template);
	if ( CurrentLauncher != none )
	{
		CurrentLauncher.WeaponTech = NewTier;
	}

	CurrentWeapon = X2WeaponTemplate (Template);
	if ( CurrentWeapon != none )
	{
		CurrentWeapon.WeaponTech = NewTier;
	}

	`LOG("Patched :: "@Template.GetItemFriendlyName() @" :: NewTier :: "@NewTier ,default.bEnableLogging,'WOTC_RAT');
}

	/////////////////////////////////////////////////////////////////
	// Makes Bluescreen rounds into the experimental deck
	/////////////////////////////////////////////////////////////////

static function PutBluescreensInDeck()
{
	local X2ItemTemplateManager		ItemMgr;

	//Karen, call the manager !!
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	RemoveFromDecks(ItemMgr.FindItemTemplate('BluescreenRounds'));
	RemoveFromDecks(ItemMgr.FindItemTemplate('EMPGrenade'));
	//RemoveFromDecks(ItemMgr.FindItemTemplate('EMPGrenadeMk2'));	//code handles this already

	//if tech done place them in the deck
	if (default.bRAT_BLUESCREENTODECK && HasCompletedTechByTemplateName('Bluescreen')) //`XCOMHQ.TechsResearched.Find('Bluescreen') != INDEX_NONE)
	{
		AddToDecks(ItemMgr.FindItemTemplate('BluescreenRounds'),'ExperimentalAmmoRewards');
		AddToDecks(ItemMgr.FindItemTemplate('EMPGrenade'), 		'ExperimentalGrenadeRewards');
		//AddToDecks(ItemMgr.FindItemTemplate('EMPGrenadeMk2'), 		'ExperimentalGrenadeRewards');	//code handles this already
	}
}

static function PutBluescreensInDeckReward(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local X2ItemTemplateManager		ItemMgr;

	//Karen, call the manager !!
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//RemoveFromDecks(ItemMgr.FindItemTemplate('BluescreenRounds'));
	//RemoveFromDecks(ItemMgr.FindItemTemplate('EMPGrenade'));
	//RemoveFromDecks(ItemMgr.FindItemTemplate('EMPGrenadeMk2'));	//code handles this already

	//if tech done place them in the deck
	if (default.bRAT_BLUESCREENTODECK)// && HasCompletedTechByTemplateName('Bluescreen')) //`XCOMHQ.TechsResearched.Find('Bluescreen') != INDEX_NONE)
	{
		AddToDecks(ItemMgr.FindItemTemplate('BluescreenRounds'),'ExperimentalAmmoRewards');
		AddToDecks(ItemMgr.FindItemTemplate('EMPGrenade'), 		'ExperimentalGrenadeRewards');
		//AddToDecks(ItemMgr.FindItemTemplate('EMPGrenadeMk2'), 		'ExperimentalGrenadeRewards');	//code handles this already
	}
}

static function bool HasCompletedTechByTemplateName(name TemplateName)
{
	local XComGameState_Tech TechState;
	local int i;

	for (i = 0 ; i < `XCOMHQ.TechsResearched.length ; i++)
	{
		TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.TechsResearched[i].ObjectID));

		//Outdated savegames may contain completed techs that have since been removed. Don't bother checking them.
		if (TechState.GetMyTemplate() == None)				continue;

		//if tech name matches our query 
		if (TechState.GetMyTemplateName() == TemplateName)	return true;
	}

	//for no matches found
	return false;
}

static function RemoveFromDecks (X2ItemTemplate Template)
{
	if (Template != none)
	{
		Template.CanBeBuilt = true;
		Template.RewardDecks.length = 0;
		`LOG("Patched :: "@Template.GetItemFriendlyName() @" :: Moved OUT of Experimental Deck",default.bEnableLogging,'WOTC_RAT');
	}
}

static function AddToDecks (X2ItemTemplate Template, name RewardDeckName)
{
	if (Template != none)
	{
		if (!IsDLCInstalled('WOTC_PGOverhaul'))
		{
			Template.CanBeBuilt = false;
		}

		Template.RewardDecks.AddItem(RewardDeckName);

		`LOG("Patched :: "@Template.GetItemFriendlyName() @" :: Moved IN to Experimental Deck",default.bEnableLogging,'WOTC_RAT');
	}
}

static function PatchBluescreenTech(X2StrategyElementTemplateManager StratMgr)
{
	local X2TechTemplate						TechTemplate;
	local X2StrategyElementTemplate				Template;

	Template = StratMgr.FindStrategyElementTemplate('Bluescreen');
	if (default.bRAT_BLUESCREENTODECK && X2TechTemplate(Template) != none)
	{
		TechTemplate = X2TechTemplate(Template);
		TechTemplate.ResearchCompletedFn = PutBluescreensInDeckReward;

		`LOG("Patched :: Bluescreen Template to flip deck items",default.bEnableLogging,'WOTC_RAT');
	}
}

	////////////////////////////////////////////////////////////////////////
	//	FUNCTION TO ADD LOOT TABLES
	////////////////////////////////////////////////////////////////////////

static function AddLootTables()
{
	local X2LootTableManager	LootManager;
	local LootTable				LootBag;
	local LootTableEntry		Entry;
	
	LootManager = X2LootTableManager(class'Engine'.static.FindClassDefaultObject("X2LootTableManager"));

	foreach default.LootEntry(LootBag)
	{
		if ( LootManager.default.LootTables.Find('TableName', LootBag.TableName) != INDEX_NONE )
		{
			foreach LootBag.Loots(Entry)
			{
				class'X2LootTableManager'.static.AddEntryStatic(LootBag.TableName, Entry, false);
			}
		}	
	}
}

	/////////////////////////////////////////////////////////////////
	// Remove the extra FreeCost ActionPointCost in Bombard
	/////////////////////////////////////////////////////////////////

static function UpdateBombardActionPointCosts()
{
	local X2AbilityTemplateManager				AbilityTemplateMgr;
	local array<X2AbilityTemplate>				AbilityTemplateArray;
	local X2AbilityTemplate						AbilityTemplate;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local int									i;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplateMgr.FindAbilityTemplateAllDifficulties('Bombard', AbilityTemplateArray);
	foreach AbilityTemplateArray(AbilityTemplate)
	{
		for (i = 0; i < AbilityTemplate.AbilityCosts.Length; ++i)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]);
			if (ActionPointCost != none)
			{
				if (ActionPointCost.bFreeCost)
				{
					AbilityTemplate.AbilityCosts.RemoveItem(ActionPointCost);
				}
			}
		}
	}
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// PATCH BIT ANIMSETS
	//////////////////////////////////////////////////////////////////////////////////////////

static function PatchBitAnimSets(X2CharacterTemplate CharacterTemplate)
{
	if (CharacterTemplate != none)
	{
		CharacterTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Rusty_SPARK_BitPerks.Anims.AS_Bit_Scanning")));
	}
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CHECK FOR DLC/MODS
	//////////////////////////////////////////////////////////////////////////////////////////

static function bool IsDLCInstalled(name DLCName)
{
    local XComOnlineEventMgr        EventMgr;
    local int                        i;

    // Return true if no DLC required
    if (DLCName == '')
    {
        return true;
    }

    // Access Online Event Manager
    EventMgr = `ONLINEEVENTMGR;

    // Return true if required DLC is installed
    for (i = 0; i < EventMgr.GetNumDLC(); ++i)
    {
        if (EventMgr.GetDLCNames(i) == DLCName)
        {
            return true;
        }
    }

    return false;
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CREATE COSTS
	//////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityCost_ActionPoints CreateAPCost(int iAP, bool bFree, bool bConsume)
{
	local X2AbilityCost_ActionPoints APCost;
	
	APCost = new class'X2AbilityCost_ActionPoints';
	APCost.iNumPoints = iAP;
	APCost.bFreeCost = bFree;
	APCost.bConsumeAllPoints = bConsume;

	//Template.AbilityCosts.AddItem(APCost);

	return APCost;
}

static function X2AbilityCooldown CreateCooldown(int iNewCooldown)
{
	local X2AbilityCooldown Cooldown;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = iNewCooldown;

	//Template.AbilityCooldown = Cooldown;

	return Cooldown;
}

static function X2AbilityCharges CreateCharges (int iNewCharges)
{
	local X2AbilityCharges Charges;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = iNewCharges;

	//Template.AbilityCharges = Charges;

	return Charges;
}

static function X2AbilityCost_Charges CreateChargeCost (int iNewCharges, bool bBond = false)
{
	local X2AbilityCost_Charges ChargeCost;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = iNewCharges;
	ChargeCost.bAlsoExpendChargesOnSharedBondmateAbility = bBond;

	//Template.AbilityCosts.AddItem(ChargeCost);

	return ChargeCost;
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// LOGS CROSS CLASS ABILITIES
	//////////////////////////////////////////////////////////////////////////////////////////

static function LogCrossClassAbilities(X2AbilityTemplateManager TemplateManager)
{
	local X2AbilityTemplate		Template;
	local array<name>			TemplateNames;
	local name					TemplateName;
	
	TemplateManager.GetTemplateNames(TemplateNames);
	foreach TemplateNames(TemplateName)
	{
		Template = TemplateManager.FindAbilityTemplate(TemplateName);
		if (Template.bCrossClassEligible)
		{
			`Log("AWC CC Abilities ::" @ TemplateName,default.bLogCCAbilities, 'WOTC_RAT');
		}
	}
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// LOGS ALL CURRENT GAME TECHS
	//////////////////////////////////////////////////////////////////////////////////////////

static function LogCurrentGamesTechs(X2StrategyElementTemplateManager StratMgr)
{
	local X2TechTemplate	Template;
	local array<name>		TemplateNames;
	local name				TemplateName;
	local bool				bColoured;

	StratMgr.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		Template = X2TechTemplate(StratMgr.FindStrategyElementTemplate(TemplateName));
		if (Template != none)
		{
			if (InStr(Template.DisplayName, "</font>") != INDEX_NONE)
			{
				bColoured = true;
			}

			`LOG("================================"
				@"\n =TemplateName=" @TemplateName
				@"\n :: COLOURS :: " @bColoured
				@"\n :: PG      :: " @Template.bProvingGround 
				@"\n :: Shadow  :: " @Template.bShadowProject
				@"\n :: Break   :: " @Template.bBreakthrough
				@"\n :: Autopsy :: " @Template.bAutopsy
				@"\n :: Armor   :: " @Template.bArmor
				@"\n :: Ammo    :: " @Template.bRandomAmmo
				@"\n :: Grenade :: " @Template.bRandomGrenade
				@"\n :: Heavy   :: " @Template.bRandomHeavyWeapon
				@"\n :: WeaponT :: " @Template.bWeaponTech
				@"\n :: ArmourT :: " @Template.bArmorTech
				@"\n ==============================="

				,default.bLogAllTechs, 'WOTC_RAT');

			bColoured = false;
		}
	}
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CONSOLE COMMANDS :: ADD AN ITEM TO THE HQ INVENTORY
	//////////////////////////////////////////////////////////////////////////////////////////

exec function RustyFix_AddItem(string strItemTemplate, optional int Quantity = 1, optional bool bLoot = false)
{
	local X2ItemTemplateManager ItemManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState NewGameState;
	local XComGameState_Item ItemState;
	local XComGameState_HeadquartersXCom HQState;
	local XComGameStateHistory History;
	local bool bWasInfinite;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemManager.FindItemTemplate(name(strItemTemplate));

	if (ItemTemplate == none)
	{
		`log("No item template named" @ strItemTemplate @ "was found.",, 'WOTC_RAT');
		return;
	}

	if (ItemTemplate.bInfiniteItem)
	{
		bWasInfinite = true;
		ItemTemplate.bInfiniteItem = false;
	}

	History = `XCOMHISTORY;
	HQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	`assert(HQState != none);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Create Item");
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.Quantity = Quantity;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Complete");
	HQState = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(HQState.Class, HQState.ObjectID));
	HQState.PutItemInInventory(NewGameState, ItemState, bLoot);

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	`log("Added item" @ strItemTemplate @ "object id" @ ItemState.ObjectID,,'WOTC_RAT');

	if (bWasInfinite)
	{
		ItemTemplate.bInfiniteItem = true;
	}
}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CONSOLE COMMANDS :: SWAP AN ICON IN INVENTORY
	//////////////////////////////////////////////////////////////////////////////////////////

exec function RustyFix_SwapItemIcon(string strItemTemplate, string newIMGPath)
{
	local X2ItemTemplateManager		ItemManager;
	local X2ItemTemplate			ItemTemplate;
	local XComGameState				NewGameState;
	local string					oldIMGPath;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemManager.FindItemTemplate(name(strItemTemplate));

	if (ItemTemplate == none)
	{
		`log("No item template named" @ strItemTemplate @ "was found.",, 'WOTC_RAT');
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Swap ICON Cheat");

	oldIMGPath = ItemTemplate.strImage;

	ItemTemplate.strImage = newIMGPath;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	`log("Item Icon Swapped" @ strItemTemplate @ oldIMGPath @ newIMGPath,,'WOTC_RAT' );

}

	//////////////////////////////////////////////////////////////////////////////////////////
	// CONSOLE COMMANDS :: GIVE A UNIT THAT IS NOT A STANDARD CHARACTER TEMPLATE
	//////////////////////////////////////////////////////////////////////////////////////////

exec function RustyFix_GiveUnit(name TemplateName)
{
    local XComGameState NewGameState;
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameStateHistory History;
    local XComGameState_Unit UnitState;
    local CharacterPoolManager CharMgr;

    History = `XCOMHISTORY;
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Give Unit Cheat");

    CharMgr = `CHARACTERPOOLMGR;

    UnitState = CharMgr.CreateCharacter(NewGameState, eCPSM_Mixed, TemplateName);

    XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    XComHQ.AddToCrew(NewGameState, UnitState);
    XComHQ.HandlePowerOrStaffingChange(NewGameState);

    if(NewGameState.GetNumGameStateObjects() > 0)
    {
        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    }
    else
    {
        History.CleanupPendingGameState(NewGameState);
    }

    `HQPRES.UINewStaffAvailable(UnitState.GetReference());
}
//*******************************************************************************************