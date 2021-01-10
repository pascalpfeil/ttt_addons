-- -- INIT -- --
game.AddParticles("particles/tflippy_poison01.pcf")
PrecacheParticleSystem("tflippy_poison01")
game.AddParticles("particles/tflippy_poison02.pcf")
PrecacheParticleSystem("tflippy_poison02")

-- -- CONVARS -- --
CreateConVar( "ttt_toxin_pack_talkshit", 1, FCVAR_NOTIFY, "Enables or disables a TalkShit() function for the Antidote." )

-- -- SOUNDS -- --
-- Neurotoxin Gun --
sound.Add({
	name = 			"TFlippy_Neurotoxin.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		0.45,
	level = 		80,
	pitch =			{110, 115},
	sound = 			"^tflippy/neurotoxin/shoot.wav"
})

sound.Add({
	name = 			"TFlippy_Neurotoxin.Poisoned",
	channel = 		CHAN_VOICE,
	volume = 		0.85,
	level = 		100,
	pitch =			{100, 105},
	sound = 		{
		    		"ambient/voices/citizen_beaten1.wav",
					"ambient/voices/citizen_beaten2.wav",
					"ambient/voices/citizen_beaten5.wav",
		    		"vo/npc/male01/pain03.wav",
					"vo/npc/male01/ow01.wav",
					"vo/npc/male01/ow02.wav",
					"vo/npc/male01/startle01.wav"
					}
})

sound.Add({
	name = 			"TFlippy_Neurotoxin.Pain",
	channel = 		CHAN_VOICE,
	volume = 		0.85,
	level = 		60,
	pitch =			{100, 105},
	sound = 		{
		    		"vo/npc/male01/moan01.wav",
					"vo/npc/male01/moan02.wav",
					"vo/npc/male01/moan03.wav",
					"vo/npc/male01/moan04.wav"					
					}
})

-- Spazmax Gun --
sound.Add({
	name = 			"TFlippy_Spazmax.Scream",
	channel = 		CHAN_VOICE,
	volume = 		0.55,
	level = 		80,
	pitch =			{95, 100},
	sound = 		{
		    		"vo/npc/male01/pain01.wav",
					"vo/npc/male01/pain02.wav",
					"vo/npc/male01/pain03.wav",
					"vo/npc/male01/pain04.wav",
					"vo/npc/male01/pain05.wav",
					"vo/npc/male01/pain06.wav"
					}
})

-- Medkit Sounds --
sound.Add({
	name = 			"TFlippy_Medkit.Withdraw",
	channel = 		CHAN_WEAPON,
	volume = 		0.3,
	sound = 		"items/smallmedkit1.wav"
})

sound.Add({
	name = 			"TFlippy_Medkit.Inject",
	channel = 		CHAN_WEAPON,
	volume = 		0.3,
	sound = 		"items/medshot4.wav"
})

sound.Add({
	name = 			"TFlippy_Medkit.Deny",
	channel = 		CHAN_ITEM,
	volume = 		0.7,
	sound = 		"items/medshotno1.wav"
})

sound.Add({
	name = 			"TFlippy_Medkit.Wimp",
	channel = 		CHAN_VOICE,
	volume = 		0.5,
	level = 		80,
	sound = 		{
		    		"vo/npc/male01/hitingut01.wav",
		    		"vo/npc/male01/hitingut02.wav",
		    		"vo/npc/male01/no02.wav",
		    		"vo/npc/male01/ow01.wav",
		    		"vo/npc/male01/ow02.wav",
					"vo/npc/male01/pain01.wav",
					"vo/npc/male01/pain02.wav",
					"vo/npc/male01/pain03.wav",
					"vo/npc/male01/pain04.wav",
					"vo/npc/male01/pain05.wav",
					"vo/npc/male01/pain06.wav",
					"vo/npc/male01/pain07.wav",
					"vo/npc/male01/pain08.wav",
					"vo/npc/male01/pain09.wav",
		    		"vo/npc/male01/yeah02.wav"
					}
})

-- Antidote --
sound.Add({
	name = 			"TFlippy_Antidote.Dementia",
	channel = 		CHAN_VOICE,
	volume = 		0.55,
	level = 		90,
	pitch =			{70, 80},
	sound = 		{
		    		"vo/npc/male01/behindyou02.wav",
					"vo/npc/male01/fantastic02.wav",
					"vo/npc/male01/getdown02.wav",
					"vo/npc/male01/hacks02.wav",
					"vo/npc/male01/runforyourlife02.wav",
					"vo/npc/male01/strider_run.wav",
					"vo/k_lab/kl_fiddlesticks.wav",
					"vo/k_lab/kl_ahhhh.wav",
					"vo/k_lab/ba_guh.wav",
					"vo/k_lab/ba_getitoff01.wav",
					"vo/k_lab/kl_getoutrun03.wav",
					"vo/k_lab2/ba_getgoing.wav",
					"vo/k_lab2/ba_incoming.wav",
					"vo/npc/barneys/getdown04.wav",
					"vo/k_lab/kl_ahhhh.wav",
					"vo/k_lab/ba_guh.wav",
					"vo/k_lab2/ba_getgoing.wav",
					"vo/npc/barney/ba_duck.wav",
					"vo/streetwar/rubble/ba_tellbreen.wav",
					"needs/poofart3.wav",
					"vo/citadel/br_laugh01.wav",
					"vo/citadel/br_no.wav",
					"vo/citadel/br_playgame_a.wav",
					"vo/citadel/br_youfool.wav",
					"vo/citadel/br_youneedme.wav",
					"vo/citadel/br_justhurry.wav",
					"vo/citadel/br_gift_a.wav",
					"vo/citadel/br_gravgun.wav",
					"tflippy/hl1/waaahhhhh.wav",
					"tflippy/hl1/omgweredoomed.wav"
					}
})