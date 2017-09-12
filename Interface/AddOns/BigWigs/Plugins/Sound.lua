
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsSound")
--~~ local dewdrop = DewdropLib:GetInstance("1.0")

local sounds = {
	Long = "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3",
	Info = "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3",
	Alert = "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3",
	Alarm = "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3",
	Victory = "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3",
	
	OneCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\1.ogg",
	TwoCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\2.ogg",
	ThreeCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\3.ogg",
	FourCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\4.ogg",
	FiveCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\5.ogg",
	SixCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\6.ogg",
	SevenCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\7.ogg",
	EightCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\8.ogg",
	NineCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\9.ogg",
	TenCorsica = "Interface\\AddOns\\BigWigs\\Sounds\\Corsica\\10.ogg",
}


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Sounds"] = true,
	["sounds"] = true,
	["Options for sounds."] = true,

	["toggle"] = true,
	["Use sounds"] = true,
	["Toggle sounds on or off."] = true,
	["default"] = true,
	["Default only"] = true,
	["Use only the default sound."] = true,
	
	["bosscountdownvoice"] = true,
	["Countdown Voice"] = true,
	["Play countdown sounds for important boss timers"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["Options for sounds."] = "효과음 옵션.",

	["Use sounds"] = "효과음 사용",
	["Toggle sounds on or off."] = "효과음을 켜거나 끔.",
	["Default only"] = "기본음",
	["Use only the default sound."] = "기본음만 사용.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Sounds"] = "声音",
	["sounds"] = "声音",
	["Options for sounds."] = "声音的选项",

	["toggle"] = "选择",
	["Use sounds"] = "使用声音",
	["Toggle sounds on or off."] = "切换是否使用声音。",
	["default"] = "默认",
	["Default only"] = "只用默认",
	["Use only the default sound."] = "只用默认声音",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Sounds"] = "聲音",
	["sounds"] = "聲音",
	["Options for sounds."] = "聲音的選項",

	["toggle"] = "選擇",
	["Use sounds"] = "使用聲音",
	["Toggle sounds on or off."] = "切換是否使用聲音。",
	["default"] = "預設",
	["Default only"] = "只用預設",
	["Use only the default sound."] = "只用預設聲音",
} end)

L:RegisterTranslations("deDE", function() return {
	["Sounds"] = "Sound",
	--["sounds"] = "sound",
	["Options for sounds."] = "Optionen f\195\188r Sound.",

	--["toggle"] = true,
	["Use sounds"] = "Sound nutzen",
	["Toggle sounds on or off."] = "Sound aktivieren/deaktivieren.",
	--["default"] = "true",
	["Default only"] = "Nur Standard",
	["Use only the default sound."] = "Nur Standard Sound.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Sounds"] = "Sons",
	["Options for sounds."] = "Options concernant les sons.",

	["Use sounds"] = "Utiliser les sons",
	["Toggle sounds on or off."] = "Joue ou non les sons.",
	["Default only"] = "Son par défaut uniquement",
	["Use only the default sound."] = "Utilise uniquement le son par défaut.",	
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSound = BigWigs:NewModule(L["Sounds"])
BigWigsSound.defaults = {
	defaultonly = false,
	sound = true,
	countdown = true,
}
BigWigsSound.consoleCmd = L["sounds"]
BigWigsSound.consoleOptions = {
	type = "group",
	name = L["Sounds"],
	desc = L["Options for sounds."],
	args = {
		[L["toggle"]] = {
			type = "toggle",
			name = L["Sounds"],
			desc = L["Toggle sounds on or off."],
			get = function() return BigWigsSound.db.profile.sound end,
			set = function(v)
				BigWigsSound.db.profile.sound = v
				BigWigs:ToggleModuleActive(L["Sounds"], v)
			end,
		},
		[L["default"]] = {
			type = "toggle",
			name = L["Default only"],
			desc = L["Use only the default sound."],
			get = function() return BigWigsSound.db.profile.defaultonly end,
			set = function(v) BigWigsSound.db.profile.defaultonly = v end,
		},
		[L["bosscountdownvoice"]] = {
			type = "toggle",
			name = L["Countdown Voice"],
			desc = L["Play countdown sounds for important boss timers"],
			get = function() return BigWigsSound.db.profile.countdown end,
			set = function(v) BigWigsSound.db.profile.countdown = v end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsSound:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_Sound")
	self:RegisterEvent("BigWigs_CountdownSound")
end

function BigWigsSound:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if not text or sound == false or broadcastonly then return end

	if sounds[sound] and not self.db.profile.defaultonly then PlaySoundFile(sounds[sound])
	else PlaySound("RaidWarning") end
end

function BigWigsSound:BigWigs_Sound( sound )
	if sounds[sound] and not self.db.profile.defaultonly then PlaySoundFile(sounds[sound])
	else PlaySound("RaidWarning") end
end

	--[[BigWigs_CountdownSound should only be used for big ability timers, so players can choose to disable
		those if the sounds clutter sound channel too much.
		
		BigWigs_Sound is still used for PullTimer's countdown, as I feel that is vital enough not to be
		disable-able unless the player wants to disable all BigWig sounds.
	--]]
	
function BigWigsSound:BigWigs_CountdownSound( sound )
	if sounds[sound] and self.db.profile.countdown then
		PlaySoundFile(sounds[sound])
	end
end
