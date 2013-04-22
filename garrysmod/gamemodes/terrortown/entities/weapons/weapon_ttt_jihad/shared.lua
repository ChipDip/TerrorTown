-- traitor equipment: c4 bomb

if SERVER then
  AddCSLuaFile( "shared.lua" );
  resource.AddFile("sound/siege/jihad.wav");
  resource.AddFile("sound/siege/big_explosion.wav");
end
 
SWEP.HoldType                   = "slam"
 
if CLIENT then
  SWEP.PrintName                       = "Jihad bomb"
  SWEP.Slot                            = 6
 
  SWEP.EquipMenuData = {
    type  = "Weapon",
    name  = "Jihad bomb",
    desc  = "Sacrifice yourself for Allah.\nLeft Click to make yourself EXPLODE.\nRight click to taunt."
  };
 
  SWEP.Icon = "VGUI/ttt/icon_c4"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.WeaponID = AMMO_C4

SWEP.ViewModel  = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo     = "none"

SWEP.NoSights = true

----------------------
--  Weapon its self --
----------------------

-- Reload does nothing
function SWEP:Reload()
end   

function SWEP:Initialize()
  util.PrecacheSound("siege/big_explosion.wav")
  util.PrecacheSound("siege/jihad.wav")
end


-- Think does nothing
function SWEP:Think()	
end


-- PrimaryAttack
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 3)

	local effectdata = EffectData()
    effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	self.BaseClass.ShootEffects( self )
	
	-- The rest is only done on the server
	if (SERVER) then
		timer.Simple(2, function() self:Asplode() end )
		self.Owner:EmitSound( "siege/jihad.wav" )
	end

end

-- The asplode function
function SWEP:Asplode()
local k, v
	
	-- Make an explosion at your position
  local ent = ents.Create( "env_explosion" )
    ent:SetPos( self.Owner:GetPos() )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "125" )
		ent:Fire( "Explode", 0, 0 )
		ent:EmitSound( "siege/big_explosion.wav", 500, 500 )
	
		self.Owner:Kill( )
		self.Owner:AddFrags( -1 )
 
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play siege/big_explosion.wav\n" )
		end

end


-- SecondaryAttack
function SWEP:SecondaryAttack()	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	local TauntSound = Sound( "vo/npc/male01/overhere01.wav" )
	self.Weapon:EmitSound( TauntSound )

	-- The rest is only done on the server
	if (!SERVER) then return end
	self.Weapon:EmitSound( TauntSound )
end

-- Bewm
function SWEP:WorldBoom()
	surface.EmitSound( "siege/big_explosion.wav" )
end