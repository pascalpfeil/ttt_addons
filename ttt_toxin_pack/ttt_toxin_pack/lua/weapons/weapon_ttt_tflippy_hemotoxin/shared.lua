if CLIENT then
	SWEP.PrintName = "Hemotoxin Gun"
	SWEP.Author = "TFlippy"
	
	SWEP.Slot = 6 -- add 1 to get the slot number key
	SWEP.Icon = "tflippy/vgui/ttt/icon_hemotoxin"
	
	SWEP.ViewModelFOV  = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = true
	
	SWEP.EquipMenuData = {
	type = "Gun",
	desc = "A gas pistol utilizing a hemotoxic agent.\n\nCauses tissue damage and results in a painful\ndeath if not treated quickly."
	};
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "revolver"
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = false
SWEP.Kind = WEAPON_EQUIP1

SWEP.Primary.Delay = 1.00
SWEP.Primary.Recoil = 1.50
SWEP.Primary.Automatic = false
SWEP.Primary.SoundLevel = 30

SWEP.Primary.ClipSize = 2
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Ammo = "AR2AltFire"
SWEP.HeadshotMultiplier = 5

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.Primary.Damage = 5
SWEP.Primary.Cone = 0.00025
SWEP.Primary.NumShots = 0

SWEP.IronSightsPos = Vector( -5.91, -4, 2.84 )
SWEP.IronSightsAng = Vector(-0.5, 0, 0)

SWEP.UseHands	= true
SWEP.ViewModel  = Model("models/tflippy/cstrike/c_pist_usp.mdl")
SWEP.WorldModel = Model("models/tflippy/w_pist_usp_silencer.mdl")
SWEP.Primary.Sound = Sound( "TFlippy_Neurotoxin.Single" )
 
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
 
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	return true
end
  
function SWEP:Shoot()
	local cone = self.Primary.Cone
	local bullet = {}
	bullet.Num		 = self.Primary.NumShots
	bullet.Src		 = self.Owner:GetShootPos()
	bullet.Dir		 = self.Owner:GetAimVector()
	bullet.Tracer	 = 0
	bullet.Force	 = 1
	bullet.Damage	 = self.Primary.Damage
	--bullet.TracerName = "AntlionGib"

	self.Owner:FireBullets( bullet )
end
  
function SWEP:PrimaryAttack(worldsnd)
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
	if not self:CanPrimaryAttack() then return end
	self.Owner:LagCompensation(true)
	
	self.Weapon:EmitSound( self.Primary.Sound )
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)

	self:Shoot()
	
	local trEntity = self.Owner:GetEyeTrace().Entity
	ParticleEffect("tflippy_poison01", self.Owner:GetEyeTrace().HitPos, trEntity:GetAngles())
	
	if SERVER then
		if self.Owner:GetEyeTrace().HitNonWorld and self.Owner:GetEyeTrace().Entity:IsPlayer() then	
			local id = trEntity:UniqueID()
			trEntity:EmitSound("TFlippy_Neurotoxin.Poisoned")
			
			if trEntity:GetNWBool("WasAntidoted") == false then
				DamageLog("POISON:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " poisoned " .. (IsValid(trEntity) and trEntity:Nick() or "<disconnected>") .." [" .. trEntity:GetRoleString() .. "]" .. " with a Hemotoxin Gun.")
				trEntity:SetColor(Color( 230, 255, 210, 255 ))

				trEntity:SetNWString("PoisonID", self.Owner:UniqueID())
				
				timer.Create(trEntity:UniqueID() .. "hemotoxin", 5, 0, function()
					if IsValid(trEntity) and trEntity:IsTerror() then
						if IsValid(self.Owner) then
							trEntity:TakeDamage(math.random(3, 8), player.GetByUniqueID(trEntity:GetNWString("PoisonID")), self.Weapon)
							local jitter = VectorRand() * 30
							jitter.z = 20
							
							util.PaintDown(trEntity:GetPos() + jitter, "Blood", trEntity)
							trEntity:ViewPunch( Angle( -0.75, 0, 0 ) )
							
							if math.random(0,2) == 0 then
								trEntity:EmitSound("TFlippy_Neurotoxin.Pain")
							end
						else
							trEntity:TakeDamage(math.random(3, 8), player.GetByUniqueID(trEntity:GetNWString("PoisonID")), self.Weapon)
						end
					else
						timer.Destroy(id .. "hemotoxin")
					end
				end) 
			else
				DamageLog("POISON:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " failed to poison " .. (IsValid(trEntity) and trEntity:Nick() or "<disconnected>") .." [" .. trEntity:GetRoleString() .. "]" .. " with a Hemotoxin Gun.")
			end
		end
	end
	
	self:TakePrimaryAmmo( 1 )
	 
	if IsValid(self.Owner) then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		self.Owner:ViewPunch( Angle( math.Rand(-0.8,-0.8) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	end
	self.Owner:LagCompensation(false)
 
end

function SWEP:WasBought(buyer)
	if IsValid(buyer) then
		buyer:GiveAmmo( 0, "AR2AltFire" )
	end
end

hook.Add("TTTEndRound", "KillPoisonTimer_End", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "hemotoxin")
	end
end)

hook.Add("TTTPrepareRound", "KillPoisonTimer_Prep", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "hemotoxin")
	end
end)