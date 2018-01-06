local _
local GetTime = GetTime
local string_format = string.format
local antoranBoomHeros = {}
local antoranBoomCache = {}
local spellID_Boom_AntoranBlast = 245121
local enterCombatTime = 0

local function actionCombatLogEventReset(_, event, ...)
	enterCombatTime = GetTime()
	print("M3踩雷已加载")
	antoranBoomHeros = {}
	antoranBoomCache = {}
end

local function actionCombatLogEvent(_, event, ...)
	local _, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = ...
	if eventType == "SPELL_DAMAGE" and spellID == spellID_Boom_AntoranBlast
			and not GetPlayerInfoByGUID(sourceGUID) and not antoranBoomCache[sourceGUID] then
		if not antoranBoomHeros[destName] then antoranBoomHeros[destName] = 0 end
		antoranBoomHeros[destName] = antoranBoomHeros[destName] + 1
		local origTime = string_format("%0.1f", (GetTime() - enterCombatTime))
		local str = "[FNP] "..destName.." 的脚滑了一下！第"..origTime.."秒 ("..antoranBoomHeros[destName].."次)"
		SendChatMessage(str, "RAID")
		--print(str)
		antoranBoomCache[sourceGUID] = true
	end
end

function FilteredNamePlate:RegisterBoomM3(enable)
	if enable then
		FilteredNamePlate_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", actionCombatLogEvent)
		FilteredNamePlate_Frame:RegisterEvent("PLAYER_REGEN_DISABLED", actionCombatLogEventReset)
	else
		FilteredNamePlate_Frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", actionCombatLogEvent)
		FilteredNamePlate_Frame:UnregisterEvent("PLAYER_REGEN_DISABLED", actionCombatLogEventReset)	
	end
end

function FilteredNamePlate:MsgPathInto()
	if FnpEnableKeys == nil then
		FnpEnableKeys = {
			killlineMod = false,
			enable_m3boom = false,
		}
	end

	if FnpEnableKeys.enable_m3boom then
		FnpEnableKeys.enable_m3boom = false
		print("已禁用M3踩雷")
	else
		FnpEnableKeys.enable_m3boom = true
		print("已开启M3踩雷")
	end
	FilteredNamePlate:RegisterBoomM3(FnpEnableKeys.enable_m3boom)
end

FilteredNamePlate.RaidCombatHelperRegs = {
	["COMBAT_LOG_EVENT_UNFILTERED"] = actionCombatLogEvent,
	["PLAYER_REGEN_DISABLED"]       = actionCombatLogEventReset,
}