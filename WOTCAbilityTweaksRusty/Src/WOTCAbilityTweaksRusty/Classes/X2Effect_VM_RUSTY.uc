//*******************************************************************************************
//  FILE:   X2Effect_VM_RUSTY                                
//  
//	File created by RustyDios	06/08/19	01:30	
//	LAST UPDATED				08/09/19	17:30
//
//	Included changes copied from ADVENT Avengers "Ability Tweaks" Mod;;
//	ADD SCALING VOLATILE MIX DAMAGE
//
//	BASED ON TIER OF GRENADE 
//	0	FRAG, FLASHBANG, SMOKE, (GRENADE LAUNCHER)
//	1	IMPROVED SMOKE, GAS GRENADE, FIRE GRENADE, ACID GRENADE, EMP GRENADE, (ADV GRENADE LAUNCHER),
//	2	GAS BOMB, FIRE BOMB, ACID BOMB, EMP BOMB, PROX MINE, PLASMA(ALIEN GRENADE), 
//	3	((MOD ADDED GRENADES ??)) ((ROCKETS ETC ??)) ((BEAM GRENADE LAUNCHER))
//
//*******************************************************************************************

class X2Effect_VM_RUSTY extends X2Effect_VolatileMix config (RATConfig);

//Grab values from the config file
var config int iRAT_VOLMIXDAMAGE_TIER0;
var config int iRAT_VOLMIXDAMAGE_TIER1;
var config int iRAT_VOLMIXDAMAGE_TIER2;
var config int iRAT_VOLMIXDAMAGE_TIER3;
var config int iRAT_VOLMIXDAMAGE_TIERU;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local X2ItemTemplate SourceWeaponAmmoTemplate;
	local X2GrenadeTemplate CurrentGrenade;

	SourceWeapon = AbilityState.GetSourceWeapon();

	//ADD DAMAGE VALUE TO THROWN GRENADES FOR THE PERK ABILITY VOLATILE MIX
	if (SourceWeapon != none)
	{
		if (SourceWeapon.GetWeaponCategory() == 'grenade')
		{
		    CurrentGrenade = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
			//BASIC GRENADES AND LAUNCHER
			if ( CurrentGrenade.Tier <= 0 ) { return default.iRAT_VOLMIXDAMAGE_TIER0;	}

			//OFFENSIVE GRENADES AND LAUNCHER
			if ( CurrentGrenade.Tier == 1 ) { return default.iRAT_VOLMIXDAMAGE_TIER1;	}

			//ADVANCED EXPLOSIVES, MODDED GRENADES, BEAM LAUNCHER
			if ( CurrentGrenade.Tier == 2 ) { return default.iRAT_VOLMIXDAMAGE_TIER2;	}

			//NUCLEAR EXPLOSIVES, MODDED GRENADES, BEAM LAUNCHER
			if ( CurrentGrenade.Tier >= 3 ) { return default.iRAT_VOLMIXDAMAGE_TIER3;	}

			//UNCLEAR TIER ~ ASSUME ENEMY/MOD GRENADE, GIVE DEFAULT +2 DAMAGE
			return default.iRAT_VOLMIXDAMAGE_TIERU;
		}

		//REPEAT FOR 'GRENADE LAUNCHER LAUNCHED GRENADES'
		SourceWeaponAmmoTemplate = SourceWeapon.GetLoadedAmmoTemplate(AbilityState);
		if (SourceWeaponAmmoTemplate != none && X2WeaponTemplate(SourceWeaponAmmoTemplate) != none)
		{
			if (X2WeaponTemplate(SourceWeaponAmmoTemplate).WeaponCat == 'grenade')
			{
				if ( X2WeaponTemplate(SourceWeaponAmmoTemplate).Tier <= 0 ) { return default.iRAT_VOLMIXDAMAGE_TIER0;	}
				if ( X2WeaponTemplate(SourceWeaponAmmoTemplate).Tier == 1 ) { return default.iRAT_VOLMIXDAMAGE_TIER1;	}
				if ( X2WeaponTemplate(SourceWeaponAmmoTemplate).Tier == 2 ) { return default.iRAT_VOLMIXDAMAGE_TIER2;	}
				if ( X2WeaponTemplate(SourceWeaponAmmoTemplate).Tier >= 3 ) { return default.iRAT_VOLMIXDAMAGE_TIER3;	}
				return default.iRAT_VOLMIXDAMAGE_TIERU;
			}
		}
	}

	return 0;
}
//*******************************************************************************************
//*******************************************************************************************
