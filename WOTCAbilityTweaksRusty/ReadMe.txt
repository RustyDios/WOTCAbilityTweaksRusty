You created an XCOM 2 Mod Project! With help from Iridar and RoboJumper and the XCOM2 Modding Discord!

XCOM2 MOD PROJECT THAT REQUIRES;
	XCOM2: WOTC (TLP)
		DLC: ALIEN HUNTERS
		DLC: SHENS LAST GIFT
	XCOM2 MODS: XCOM2_COMMUNITY_HIGHLANDER

! ANYWHERE DENOTES SOMETHING THAT GOT A LOCALIZATION ENTRY/CHANGE
#ADDED CONFIG FILE TO TURN ON/OFF MOST THINGS IN MOD

BASED ON THE ABILITY TWEAKS MOD FROM ADVENT AVENGER FOUND HERE;
https://steamcommunity.com/sharedfiles/filedetails/?id=1133528728 WOTC ABILITY TWEAKS

/////////////////////////////////////////////////////////////
--- CLASSES IN THE MOD ---
/////////////////////////////////////////////////////////////

AbilityTweaksRusty.uc (X2 DLC INFO)		File created by RustyDios	Included changes copied from ADVENT Avengers "Ability Tweaks" Mod;;

	ULTRASONIC LURE	NO CONCEALMENT BREAK
	SPARK HUNTER PROTOCOL DOES NOT TRIGGER IF CONCEALED, NO HAIR TRIGGER ON REACTION SHOTS

	FIXES SCANNING PROTOCOL CHARGES PER TIER

!	WAR SUIT NO LONGER HAS SHIELD WALL (BUGGED) REPLACED BY MINI KINETIC PLATING

	FIXUP WEAPON TIERS
		GRENADE LAUNCHERS
		HEAVY WEAPONS
		CLAYMORES
		MEDIKITS

	MOVE BLUESCREEN ROUNDS INTO THE RANDOM AMMO DECK, NO LONGER BUILT

	SCHISM (INSANITY DAMAGE AND VOID RIFT INSANITY DAMAGE) BYPASS SHIELDS
	VOLT BYPASS SHIELDS
	HORROR BYPASSES SHIELDS

!	DEADEYE CAUSES BLEEDING AND DISORIENTATION
	SKIRMISHER MELEE NO COOLDOWN, MAKES NO SENSE

	COMBAT PRESENCE		: FREE ACTION, DOESNT END TURN, SAME COOLDOWN AS INSPIRE ABILITY,	NO CONCEALMENT BREAK
	INSPIRE				: FREE ACTION, DOESNT END TURN,	LOTS OF INSPIRE TARGETING FIXES,	NO CONCEALMENT BREAK
	BONDMATE TEAMWORKS	: FREE ACTION, DOESNT END TURN,	STILL USES SHARED CHARGES,			NO CONCEALMENT BREAK

	STICKIFY SNIPER SHOT ABILITIES

	MOVE HUNKER TO LAST ON BAR BEFORE INTERACTIVES
	MOVE OVERWATCH ICONS TO BE GROUPED
	MOVE LOOT TO FIRST INTERACTIVE
	MOVE EVAC/OBJECTIVE/INTERACTABLE ICONS TO END OF ABILITY BAR

	FIX UP SOME GTS SLIDES FOR SPARK GTS
	FIX UP THE REQUIREMENTS FOR MOF
		MAYHEM SUPPRESSION REQUIRES SPARK SUPPRESSION
		NANOMACHINES REQUIRES SPECTRE AUTOPSY

	CHANGE SQUAD SIZE UPGRADES I AND II
		I  REQUIRES A SQUIRE SPARK OR HIGHER
		II IS UNBUYABLE

	CHANGES TO SOME COVERT ACTIONS TO MAKE THEM NON-AMBUSHABLE AND FORCE RESCUE IF AVAILABLE

	PHASE DRONE WEAPON PANEL ICON FIX
	CX HIVE SUMMONS (RIPPERS AND RANDOM) ABILITY COSTS FIX : FREE ACTION, DOESNT END TURN, 1 TURN COOLDOWN, 1 CHARGE WITH 2 USES

	RULER ESCAPE ICON FIX
	RULER ZERKER QUEEN ICONS FIX

	exec function RustyFix_AddItem(string strItemTemplate, optional int Quantity = 1, optional bool bLoot = false)X2Ability_MKP_RUSTY
	exec function RustyFix_SwapItemIcon(string strItemTemplate, string newIMGPath)
	exec function RustyFix_GiveUnit(string strCharacterTemplate)

	log function  LogCCAbilities		logs all CC enabled abilities
	log function  LogAllTechTemplates	logs all tech details
	.... and likely some stuff I forgot
	
X2Ability_MKP_RUSTY
!	MINI KINETIC PLATING CLASS DEFINE
!	MINI KINETIC PLATING PASSIVE ABILITY FOR SHOW

X2Ability_SPARKBitPerks
!	A LIST OF CLONED GREMLIN ABILITIES FOR USE WITH SPARK BITS

X2Effect_BPED_Fix_RUSTY
	BLAST PADDING ENV DAMAGE FIX

X2Effect_VM_RUSTY
	VOLATILE MIX SCALING DAMAGE

X2Item_RustyPCS && X2Ability_PsiPCS
!	ADDS THE MISSING PSI AND HACK PCS
	ADDS WORKAROUND ABILITIES FOR PSI PCS' BEING LOCKED TO PSI OPERATIVES

X2Item_RustyBox && X2Ability_RustyBox
	ADDS AN ITEM THAT CAN BE GRANTED BY CONSOLE THAT BESTOWS ABILITIES TO INFLICT EVERY TYPE OF STATUS AILMENT ON SOMEONE

X2Effect_SpawnMimic_DontCountAsCasualty
	ADDS TO THE SPAWN COMPLETE FUNCTION THAT ANY MIMIC BEACONS ARE kAppearance.bGhostPawn = true WHICH MEANS THEY DONT COUNT WHEN THEY ARE KILLED

/////////////////////////////////////////////////////////////
---OTHER FILES IN THE MOD (.ini's) AND CHANGES CONTAINED---
/////////////////////////////////////////////////////////////

XComAI.ini
	Frenzy Trigger Chance Change

XComEditor, XComEngine, XComGame .inis
	+ModPackage
	+CHH Helpers

XComGameCore
	MAX EVAC PER TURN INCREASED TO 50
	MARKED, HOLO or COMBAT TARGETTED UNITS CANT VANISH
	BURNING, ACID AND POSION IGNORE SHIELDS
	ALIEN SUPPRESSION IS -50
	FEEDBACK DAMAGE IS 2-5, PSI

	BESERKER SUIT +8/10HP ARMOUR 2/4
	//NANOFIBRE VEST +2HP
	PLATED VEST +3HP, MED PLATED +5, MED POWERED +7, HEAVY POWERED +8
	SPARK PLATED +6HP +1ARM, POWERED +9HP +2ARM

	STILLETTOROUNDS PIERCE 99

	GRAPPLE DISTANCE DEFAULT (POWERED OR HUNTER +4TILES)

	SKULLJACK HACK BONUS +40

	ADJUSTS LOOT TABLES FOR PCS'

XComGameData
!	NEEDLE (REAPER ABILITY) GRANTS AMMO POCKET
	SPARK STRIKE DAMAGE 5/7/9 SPREAD 1 RUPTURE 1/1/2
	SPARK INTIMIDATE VALUES
	ADDS NEW CATEGORY FOR 'HEAVY' WEAPONS
	MOVES AMMO AND GRENADES TO UNDER THE WEAPONS TAB IN ENGINEERING
	INCLUDES STAT BOOST TABLES FOR NEW PSI AND HACK PCS
	FREE DEBUG MODE STUFF

XComGameData_SoldierSkills
!	FORTRESS GRANTS ELECTRIC AND FROST IMMUNITY
!	NEEDLE IS +99 PIERCE
	VIPER KING CAN RUPTURE ON BIND
	ENERGY SHIELDS RANGE IS 12, 5 TURN GLOBAL COOLDOWN
	FRENZY ACTIVATION AT 33%, 3TURNS
	CHRYSSALID COCOON SPAWN TIME DOUBLED
	INSANITY 3 TURN COOLDOWN
	SCHISM(INSANITY DAMAGE) ARMOUR PIERCING AND RUPTURES
	GUARDIAN SET TO 66% ACTIVATION RATE
	TEMPLAR OVERCHARGE 50, AMPLIFY +50%, STUNSTRIKEHIT 60% + FOCUS 10%
	TEMPLAR GHOST CAN PICK UP LOOT/PSILOOT
	BLAST PADDING NERFED TO 50%
!	DEADEYE 5 TURN COOLDOWN, +10% AIM, (+50% DAMAGE) (+DISORIENT AND BLEEDING)
	REAPER (RANGER BLADE SKILL) NO TRAIL OFF DAMAGE
	ENV DAMAGE NERF FOR ANDROMEDON, FACELESS, TELEPORT
	WRATH AIM BONUS +30
	BESERKER QUEEN QUAKE 2-4 DAMAGE, MELEE

XComGameData_WeaponData
	GREMLIN ELECTRIC DAMAGE 2/4/6 HACK BONUS 10/20/30
	SPARK BIT HACK 50/50/50 (THEY ARE JUILIANS ACCESS CODES)// NOW CHANGED VIA SPARK ARSENAL
	SHEN ROVER HACK 75 (SHES A GENIUS AND ROVER IS SPECIAL/PART CODEX)
	ENV DAMAGE NERF FOR ALL WEAPONS BAR LMG'S/SPARKS (TLP WEAPONS OR MOD ADDED)
	BULLPUP 4/6/8 DMAGE
	VEKTOR CRIT 10/10/10
	WRISTBLADE CRIT 10/10/10
	WRITBLADE DAMAGE AS SWORDS (4/5/7) SHREDS 1
	SHARDGAUNTLETS DAMAGE AS SWORDS (4/5/7) IGNORES ARMOUR
	WARLOCK RIFILE +5AIM, ASSASIN SHOTGUN 20 CRIT, HUNTER LANCE 50CRIT, HUNTER CLAW 5AIM/CRIT
	PURIFIER ENV DAMAGE 10, 66% AREA FILL
	SPECTRE HORROR DAMAGE 2/3 RUPTURE 1/2, PSI
	FROSTBOMB BASE DAMAGE 1 RUPTURE 1 FROST, ENV DAMAGE ADDED 5
	BOLTCASTER DAMAGE 7/9/11 RUPTURE 1/1/2, CRIT 10/10/10
	VIPER KING BOLTCASTER DAMAGE 5 PIERCE 1 RUPTURE 2
	AXE DAMAGE 5/6/8 RUPTURE 1/1/2, AIM +15, CRIT 20/25/30
	RAGESUIT DAMAGE 7 CRIT 3 RUPTURE 2
	ENV DAMAGE ADDED FIREBOMB 5, FLASHBANGS 1, ACID GRENADES 5 (FROST GRENADES 5)

XComPromotionUIMod
	Config edits 

XComClassData
	Major shuffling to skills in trees and Hero Random Decks
	Added Hidden Potential to all classes in addition to their normal stat growth
		RANGER
			0-2 Aim, 0-1 HP, 0-1 Will
			Sqd -- added deep cover
			Ltn -- replaced Run n Gun with Soul Harvest
			Cap -- replaced Bladestorm with Run n Gun, swapped the trees
			Maj -- replaced Deep Cover with Bladestorm, swapped the trees
		SHARPSHOOTER
			0-5 Aim, 0-1 HP, 0-1 Will
			Cpl -- replaced Return Fire with Quickdraw
			Sgt -- replaced Deadeye with Aim and Lightning Hands with Return Fire
			Ltn -- replaced Quickdraw with Lightning Hands
			Cap -- replaced Killzone with Deadeye and Faceoff with SteadyHands
			Maj -- replaced SteadyHands with KillZone and Aim with FaceOff
		GRENADIER
			0-2 Aim, 0-2 HP, 0-1 Will
			Sqd -- added Shredder
			Cpl -- replaced Shredder with Aim
			Cap -- replaced ChainShot with Rupture
			Maj -- replaced Hail with ChainShot
			Col -- replaced Rupture with Hail
		SPECIALIST
			0-3 Aim, 0-1 HP, 0-3 Hack, 0-1 Will
			WOW No other changes to the class
		PSIONIC (Standard PsiOp is abolished)
			Complete new random deck and tree incorporating [iridars more psi abilties]
			NEW EXTERNAL MOD ... 
		SPARK
			0-2 Aim, 0-1 HP, 0-5 Hack
			Granted AWC Abilities and PCS
			New Custom AWC Deck and 'Bit Core' Tree/Deck
			Mechatronic Warfare Perk pack integrated
			Sqd/Sqr -- added Shredder to XCOM ROW, Moved Immunities to WAR MACHINE
			Bit Core Deck -- Intrusion, Haywire, Scanning, Revival, and Medical Protocol
			Bit Core Deck has 1 random space and is randomised
		TEMPLAR
			0-2 Aim, 0-1 HP, 0-1 Mobility, 0-4 Will
			Added FanFire and PhaseWalk to random deck
			Completely mixed up the tree incorporating Supreme Focus
			Sqd -- Rend			Volt			Focus		Momentum
			Cpl -- Parry		Reverberation	Pillar
			Sgt -- Deflect		Scorch			DeepFocus
			Ltn -- Reflect		Amplify			StunStrike
			Cap -- Overcharge	Invert			Channel
			Maj -- ArcWave		Exchange		Ghost
			Col -- IonicStorm	VoidConduit		SupremeFocus
		SKIRMISHER
			0-2 Aim, 0-2 HP, 0-4 Will
			Added DFA, untouchable, implacable, shredder, nullward to random deck
			Completely mixed up the tree
			Sqd -- Marauder		Judgement			Grapple
			Cpl -- Reflex		RipjackStrike		TotalCombat
			Sgt -- --			Justice				Zero-in
			Ltn -- FullThrottle	Whiplash			--
			Cap -- Interupt		Vengence			CombatPrescience
			Maj -- Waylay		RipJackBladestorm	--
			Col -- Battlelord	--					ManualOveride
		REAPER
			0-3 Aim, 0-1 HP, 0-3 Hack, 0-4 Will
			Added aim, deep cover, shadowstrike, steady hands to random deck
			Slightly Mixed up the tree
			Sqd -- added SilentKiller
			Sgt -- swapped Highlands and Shrapnel, added Needle, removed Target Def
			Ltn -- added Target Def, removed Silent Killer and Needle
			Maj -- swapped Shrapnel and Highlands

XCom RAT Config
	TOGGLES & OPTIONS FOR MOST THINGS ADDED IN DLC INFO

XComStrategyTuning
	WORKSHOP COSTS CHANGED (NO POWER) ITS STILL AN UNATTRACTIVE OPTION IN WOTC!

XComNew2020Icons
	Config Options

XComWeaponSkinReplacer
	GIVES ALL 'ARMORED' ADVENT REGENERATING VESTS (BUBBLEWEAVE FROM MZ)
	GIVES DEADPUTS MILITIA LWPLATING VESTS

XComPGOverhaulExperimentalItems
	Config for the Bluescreens stuff to become buildable again

XComGame.int_OTHER LOCALISED TEXTS
	VARIOUS LOCALISATION EDITS FOR BASE GAME AND MODS
	WHIPLASH ELECTRIC DAMAGE TEXTS
	BULLPUP NAME CHANGES (CONVENTIONAL, RAIL, ENERGY)
	TLP SWORDS TEXTS CHANGED (LASER BLADES, PLASMA BLADES, DESC TEXTS)
	((VARIOUS ITEM DESC CHANGES & FIXES))
	((MINOR OVERHAUL TO SPARK CLASS))

UILIBRARY_RATIMAGES
	IMAGE FILES FOR PCS ICONS, GTS SLIDES, WEAPON PANEL SWAPS, ETC

RUSTY_SPARK_BITPERKS
	PERK CONTENT PACKAGE FOR NEW SPARK-GREMLIN PERKS

 // END OF CHANGES

//List of Images in the RAT pack
	Texture2D'UILibrary_RATImages.BT_Chemthrower'
	Texture2D'UILibrary_RATImages.BT_Chemthrower2'
Texture2D'UILibrary_RATImages.GTS_PSIONIC'
Texture2D'UILibrary_RATImages.GTS_SPARK_DEF'
Texture2D'UILibrary_RATImages.GTS_SPARK_HACK'
Texture2D'UILibrary_RATImages.GTS_SPARK_REGEN'
Texture2D'UILibrary_RATImages.Inv_CombatSim_Hack'
Texture2D'UILibrary_RATImages.Inv_Phasedrone_WPN'
Texture2D'UILibrary_RATImages.Inv_RustyPandoraBox'
	Texture2D'UILibrary_RATImages.TEC_N_HiveArmor'
	Texture2D'UILibrary_RATImages.TEC_N_HiveCannon'
	Texture2D'UILibrary_RATImages.TEC_N_HiveGauntlet'
	Texture2D'UILibrary_RATImages.TEC_N_HiveWings'
	Texture2D'UILibrary_RATImages.Tech_ModularChems'
	Texture2D'UILibrary_RATImages.INV_PCS_HIVE_RUSH'
	Texture2D'UILibrary_RATImages.INV_PCS_HIVE_SPAWN'
Texture2D'UILibrary_RATImages.UIPerk.perk_acceleration'
Texture2D'UILibrary_RATImages.UIPerk.perk_defensivestance'
Texture2D'UILibrary_RATImages.UIPerk.perk_regeneration'	
Texture2D'UILibrary_RATImages.Inv_Plasma_GrenadeFIX'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Aim'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Defense'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Dodge'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Hacking'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Health'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Mobility'
	Texture2D'UILibrary_RATImages.StatIcons.Image_Will'
Texture2D'UILibrary_RATImages.Inv_XCOM_Datapad'

Texture2D'UILibrary_RATImages.ClassIcons.AkimboClass'
