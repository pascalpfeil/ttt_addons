--Author information
SWEP.Author = "Killberty (original version by TFlippy)"
SWEP.Contact = "http://steamcommunity.com/id/killberty"

if SERVER then
	-- Adds the current file to the list of files to be downloaded by clients.
	AddCSLuaFile()
	-- Adds a workshop addon for the client to download before entering the server.
	resource.AddWorkshop("609007212")
elseif CLIENT then
	LANG.AddToLanguage("english", "antidote_name", "Antidote Vial")
	LANG.AddToLanguage("english", "antidote_desc", "An experimental cure for various poisons.\n\nMay cause severe dementia and stupid\nemotional outbursts.")
	
	SWEP.PrintName    			= "antidote_name"
	SWEP.Slot 					= 7		-- add 1 to get the slot number key
	SWEP.Icon 					= "tflippy/vgui/ttt/icon_antidote"
	SWEP.EquipMenuData 			= {type = "Utility", desc = "antidote_desc"}
end

SWEP.Base					= "weapon_tttbase"
SWEP.HoldType				= "normal"
SWEP.AutoSpawnable			= false
SWEP.AllowDrop				= true
SWEP.IsSilent				= false
SWEP.NoSights				= true
SWEP.Kind					= WEAPON_EQUIP2
SWEP.Primary.Recoil			= 3.75
SWEP.Primary.Automatic		= false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.ClipMax		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= "GaussEnergy"
SWEP.HeadshotMultiplier 	= 1.00
SWEP.CanBuy 				= { ROLE_DETECTIVE, ROLE_TRAITOR }
SWEP.LimitedStock			= false
SWEP.Primary.Damage			= 5
SWEP.Primary.Cone			= 0.005
SWEP.Primary.NumShots 		= 0
SWEP.HoldType 				= "slam"
SWEP.UseHands				= true
SWEP.ViewModelFlip 			= false
SWEP.ViewModelFOV 			= 54
SWEP.ViewModel 				= Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_medkit.mdl" )
SWEP.Primary.Delay			= 1.50
SWEP.Secondary.Delay 		= 1.50

local denySound 			= Sound("TFlippy_Medkit.Deny")
local injectSound 			= Sound("TFlippy_Medkit.Inject")
local wimpSound 			= Sound("TFlippy_Medkit.Wimp")
local dementiaSound 		= Sound("TFlippy_Antidote.Dementia")

-- Sentence generator phrases --
local phr_hey = {"", "", "", "", "", "", "ya ", "hey ", "lol ", "yolo", "my ", "bro ", "m8 ", "hey ", "ohooo ", "hohohohoo ", "hey ", "oh ", "rofl ", "hahah ", "woot ", "dafuq ", "ok"}
local phr_sub1_pre = {"", "", "", "", "", "dump", "dope", "tappa", "shit", "flap", "crap", "#", "#"}
local phr_sub1 = {"", "", "", "", "moran ", "gordan ", "bro ", "swagmate ", "pisser ", "crapper ", "duck ", "bum ", "hardman ", "fagli ", "vercunt ", "infart", "flipshit ", "jack ", "knob ", " dong ", "shrek "}
local phr_act1_pre = {"", "", "", "", "", "", "", "", " gonna ", " will ", " now ", "un", "de", "re", "under", "power", "im so", "i'm so"}
local phr_act1 = {"", "", "smoke", "play", "beat", "blaze", "drink", "piss", "spit", "shit", "shit", "fling" }
local phr_act1_div = {" ", " ", " ", " ", " some ", " at ", " out ", " up ", " off ", " #", "thats"}
local phr_sub2_pre = {"", "", "", "", "", "mega", "hot", "wet", "horny ", "super", "shit", "too ", "very ", "black", "gaba"}
local phr_sub2 = {"this", "shit", "weed", "zorg", "gangsta", "fungle", "honch", "swag", "corn", "hoodie", "hiphop", "hoodoo", "poo", "bean", "kek", "kek", "booze", "tflippy", "wang", "chav", "rap", "chemtrails", "gaba", "baba"}
local phr_sub2_post = {"", "", "", "", "", "", "", "ling", "ey", "ite", "tum", "tron", "o"}
local phr_end_pre = {"", "", "", "", "", "", "", " much", " so", " lotsa", " big", " top", " swaggy", " sick", "ok"}
local phr_end = {"", "", "", "", "", " lel", " XD", " xd", " xDD", " baahaaaa", " haaa", " hahahha", " lmao", " lmfao", "??", "!?", "!??", "?????", "kay", " kay????", "mkay"}

local function TalkShit(entity)
	local phrase = (table.Random(phr_hey) .. table.Random(phr_sub1_pre) .. table.Random(phr_sub1) .. table.Random(phr_act1_pre) .. table.Random(phr_act1) .. table.Random(phr_act1_div) .. table.Random(phr_sub2_pre) .. table.Random(phr_sub2) .. table.Random(phr_sub2_post) .. table.Random(phr_end_pre) .. table.Random(phr_end))

	entity:Say(phrase, false)
	DamageLog("DEMENTIA:\t " .. entity:Nick() .. " [" .. entity:GetRoleString() .. "]" .. " said: '" .. phrase .. "'.")
end

local function FlipShit(entity)
	entity:EmitSound(dementiaSound)
end
	
function SWEP:Deploy()
	-- self.Owner:DrawWorldModel(true)
	self.Owner:DrawViewModel(true)
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
		RunConsoleCommand("lastinv")
	end
end

function SWEP:Initialize()
	if CLIENT then
		self:AddHUDHelp("PrimaryAttack: Use on other player", "SecondaryAttack: Use on self", false)
	end
end

function SWEP:PrimaryAttack()

	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not IsValid(self.Owner) then return end
	
	self.Owner:LagCompensation(true)

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 50)

	local kmins = Vector(1,1,1) * -10
	local kmaxs = Vector(1,1,1) * 10
	
	local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

	if not IsValid(tr.Entity) then
			tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
	end
	
	local trEntity = tr.Entity
	
	if tr.Hit and tr.HitNonWorld and IsValid(trEntity) then
		if  trEntity:IsPlayer() then
	 
			local id = trEntity:UniqueID()
			
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:EmitSound(injectSound)
			self:EmitSound(wimpSound)
			
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr.HitPos)
			edata:SetNormal(tr.Normal)
			edata:SetEntity(trEntity)
			
			util.Effect("BloodImpact", edata)
			trEntity:SetColor(Color( 255, 255, 255, 255 ))
			
			if SERVER then
				self:Remove()
				-- trEntity:SetFOV(110, 60)
				timer.Destroy(id .. "hemotoxin")
				timer.Destroy(id .. "seizure")
				timer.Destroy(id .. "spazmax")
				trEntity:SetNWBool("WasAntidoted", true)
				
				timer.Create(id .. "dementia", math.random(10,20), 0, function()
					if trEntity:Alive() and IsValid(trEntity) then
						FlipShit(trEntity)
						
						if GetConVarNumber("ttt_toxin_pack_talkshit") == 1 then
							if math.random(0,3) == 0 then
								TalkShit(trEntity)
							end
						end
					else
						timer.Destroy(id .. "dementia")
					end
				end)
				
				DamageLog("ANTIDOTE:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " gave " .. (IsValid(trEntity) and trEntity:Nick() or "<disconnected>") .." [" .. trEntity:GetRoleString() .. "]" .. " an antidote and severe dementia.")
			end
		else
			self:EmitSound(denySound)
		end
	else
		self:EmitSound(denySound)
	end

	self.Owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not IsValid(self.Owner) then return end

	if IsValid(self.Owner) then
		if  self.Owner:IsPlayer() then
	 
			local id = self.Owner:UniqueID()
			
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:EmitSound(injectSound)
			self:EmitSound(wimpSound)
			
			self.Owner:SetColor(Color( 255, 255, 255, 255 ))

			local Owner = self.Owner
			if SERVER then
				self:Remove()
				-- Owner:SetFOV(110, 60)
				timer.Destroy(id .. "hemotoxin")
				timer.Destroy(id .. "seizure")
				timer.Destroy(id .. "spazmax")
				Owner:SetNWBool("WasAntidoted", true)
				
				timer.Create(id .. "dementia", math.random(10,20), 0, function()
					if Owner:Alive() and IsValid(Owner) then
						FlipShit(Owner)
						
						if GetConVarNumber("ttt_toxin_pack_talkshit") == 1 then
							if math.random(0,3) == 0 then
								TalkShit(Owner)
							end
						end
					else
						timer.Destroy(id .. "dementia")
					end
				end)
				
				DamageLog("ANTIDOTE:\t " .. self.Owner:Nick() .. " [" .. self.Owner:GetRoleString() .. "]" .. " gave himself an antidote and lost an IQ.")
				
			end
		else
			self:EmitSound(denySound)
		end
	else
		self:EmitSound(denySound)
	end
end

hook.Add("TTTEndRound", "TalkShitStop_end", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "dementia")
		v:SetNWBool("WasAntidoted", false)
	end
end)

hook.Add("TTTPrepareRound", "TalkShitStop_prep", function()
	for k,v in pairs(player.GetAll()) do
		timer.Destroy(v:UniqueID() .. "dementia")
		v:SetNWBool("WasAntidoted", false)
	end
end)