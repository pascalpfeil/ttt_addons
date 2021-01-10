if CLIENT then
	SWEP.PrintName = "Spazmax Gun"
	SWEP.Author = "TFlippy"
	
	SWEP.Slot = 6 -- add 1 to get the slot number key
	SWEP.Icon = "tflippy/vgui/ttt/icon_spazmax"
	
	SWEP.ViewModelFOV  = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = true
	
	SWEP.EquipMenuData = {
	type = "Gun",
	desc = "A non-lethal poison that causes muscle spasms.\n\nVictims lose control of themselves, potentially\ncausing harm to themselves and the others."
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
SWEP.ViewModel  = Model("models/tflappy/cstrike/c_pist_usp.mdl")
SWEP.WorldModel = Model("models/tflappy/w_pist_usp_silencer.mdl")
SWEP.Primary.Sound = Sound( "TFlippy_Neurotoxin.Single" )
 
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
 
local function Seizure(entity)
	local rand = math.random(0,5)
	entity:ViewPunch( Angle(math.random(-20,20), math.random(-25,25), math.random(-30,30)) )
	entity:ConCommand("-right")
	entity:ConCommand("-left")
	
	if rand == 0 then
		entity:ConCommand("+jump")
		entity:ConCommand("-duck")
		timer.Simple( 1.5, function() entity:ConCommand("-jump") end )
	elseif rand == 1 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+right")
		entity:ConCommand("+moveleft")
		entity:ConCommand("+attack")
		timer.Simple( 1.0, function() entity:ConCommand("-right") entity:ConCommand("-moveleft") entity:ConCommand("-attack") end )
	elseif rand == 2 then
		entity:ConCommand("+left")
		entity:ConCommand("+moveright")
		timer.Simple( 1.0, function() entity:ConCommand("-left") entity:ConCommand("-moveright") end )
	elseif rand == 3 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+forward")
		entity:ConCommand("+attack")
		timer.Simple( 1.5, function() entity:ConCommand("-forward") entity:ConCommand("-attack") end )
	elseif rand == 4 then
		entity:ConCommand("+right")
		entity:ConCommand("+attack2")
		entity:ConCommand("+moveleft")
		timer.Simple( 1.5, function() entity:ConCommand("-right") entity:ConCommand("-attack2") entity:ConCommand("-moveleft") entity:ConCommand("-attack") end )
	elseif rand == 5 then
		entity:ConCommand("slot2")
		entity:ConCommand("slot3")
		entity:ConCommand("+attack")
		timer.Simple( 1.5, function() entity:ConCommand("-attack") end )
	end
end
 
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
	ParticleEffect("tflippy_poison02", self.Owner:GetEyeTrace().HitPos, trEntity:GetAngles())
	
	if SERVER then
		if self.Owner:GetEyeTrace().HitNonWorld and self.Owner:GetEyeTrace().Entity:IsPlayer() then	
			if trEntity:GetNWBool("WasAntidoted") == false then
				local id = trEntity:UniqueID()
				
				trEntity:EmitSound("TFlippy_Neurotoxin.Poisoned")
				DamageLog("SPAZMAX:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " poisoned " .. (IsValid(trEntity) and trEntity:Nick() or "<disconnected>") .." [" .. trEntity:GetRoleString() .. "]" .. " with a Spazmax Gun.")
				trEntity:SetColor(Color( 240, 220, 255, 255 ))
				
				if IsValid(trEntity) and trEntity:IsTerror() then
					timer.Create(trEntity:UniqueID() .. "spazmax", math.random(8,14), 0, function()
						timer.Create(trEntity:UniqueID() .. "seizure", 0.75, math.random(4,9), function()
							if IsValid(trEntity) and trEntity:Alive() then
								Seizure(trEntity)
								trEntity:EmitSound("TFlippy_Spazmax.Scream")
							else
								timer.Destroy(id .. "seizure")
							end
						end)
						
					end)
				end
			else
				trEntity:EmitSound("TFlippy_Neurotoxin.Poisoned")
				DamageLog("SPAZMAX:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " failed to poison " .. (IsValid(trEntity) and trEntity:Nick() or "<disconnected>") .." [" ..trEntity:GetRoleString() .. "]" .. " with a Spazmax Gun.")				
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

hook.Add("TTTEndRound", "KillSeizureTimer_End", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "seizure")
		timer.Destroy(v:UniqueID() .. "spazmax")
	end
end)

hook.Add("TTTPrepareRound", "KillSeizureTimer_Prep", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "seizure")
		timer.Destroy(v:UniqueID() .. "spazmax")
	end
end)