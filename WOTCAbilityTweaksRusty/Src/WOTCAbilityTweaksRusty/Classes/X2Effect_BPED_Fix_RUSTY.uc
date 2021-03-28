//*******************************************************************************************
//  FILE:   X2Effect_BPED_Fix_RUSTY                                  
//  
//	File created by RustyDios	06/08/19	01:30	
//	LAST UPDATED				20/10/20	20:30
//
//	FIX FOR BLAST DAMAGE ENV DAMAGE REDUCTION
//
//	FIXES BLAST PADDING TO HAVE THE SAME REDUCTION FOR ANY EXPLOSIVE DAMAGE SOURCE AND ENV DAMAGE
//
//*******************************************************************************************
// If ExplosiveDamageReduction is 1.0, you are immune. Thus, the entire IncomingDamage is negated (-Damage * 1).
// The returned DamageMod is what is removed from the initial damage, as a negative number (if the initial damage is 12, and you take 50% damage, the returned value is -6). 
// Higher negative means more damage reduction.
// DamageMod of 0 is the entire initial damage unchanged.
// Blast Padding regular functions the same way with grenade damage.
//*******************************************************************************************

class X2Effect_BPED_Fix_RUSTY extends X2Effect_Persistent config (RATConfig);

var float ExplosiveDamageReduction;

function int ModifyDamageFromDestructible(XComGameState_Destructible DestructibleState, int IncomingDamage, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{
	local int DamageMod;

	DamageMod = -int(float(IncomingDamage) * ExplosiveDamageReduction);

	return DamageMod;
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		WeaponTemplate;
	
	local int DamageMod;
	local bool bExplosives;

	//setup
	DamageMod = 0;
	bExplosives = false;

	//bail if the damage has already been reduced by blast padding's normal effect
	if (WeaponDamageEffect.bExplosiveDamage)
	{
		return DamageMod;
	}

	//grab the source weapon
	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	}

	//check these extra sources of explosive damage
	if (WeaponDamageEffect.EffectDamageValue.DamageType == 'Explosion')							{bExplosives = true;}
	if (WeaponDamageEffect.EffectDamageValue.DamageType == 'BlazingPinions')					{bExplosives = true;}
	if (WeaponDamageEffect.DamageTypes.Find('Explosion') != -1)									{bExplosives = true;}
	if (WeaponDamageEffect.DamageTypes.Find('BlazingPinions') != -1)							{bExplosives = true;}
	if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'Explosion')			{bExplosives = true;}
	if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'BlazingPinions')	{bExplosives = true;}

	//if a thing was true reduce damage
	if(bExplosives)
	{
		DamageMod = -int(float(CurrentDamage) * ExplosiveDamageReduction);
	}

	//return the damage modifier
	return DamageMod;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}

//*******************************************************************************************
//*******************************************************************************************
