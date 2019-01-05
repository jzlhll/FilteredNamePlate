local rgev = rgev
local BASE = nil

local isreg = false

local function MyonEvent(self, event, ...)
	local handler = FilteredNamePlate.AchievmentEventList[event]
	if handler then
	    handler(self, event, ...)
	end
end

function FilteredNamePlate:AchievementRegistEvent()
	if not isreg then
		isreg = true
		rgev(true)
		BASE = CreateFrame("Frame", nil, UIParent)
		BASE:SetScript("OnEvent", MyonEvent)
	end
end

function rgev(registed)
    if registed then
        for k, v in pairs(FilteredNamePlate.AchievmentEventList) do
            BASE:RegisterEvent(k,v)
        end
    else
        for k, v in pairs(FilteredNamePlate.AchievmentEventList) do
            BASE:UnregisterEvent(k,v)
        end
    end
end

local function actionEnterWorld()
end

FilteredNamePlate.AchievmentEventList = {
	["PLAYER_ENTERING_WORLD"]		  = actionEnterWorld,
}

