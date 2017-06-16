SLASH_FilteredNamePlate1 = "/fnp"
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitName, GetUnitName = UnitName, GetUnitName
local string_find = string.find
local FilterNp_EventList = FilterNp_EventList

local DEBUG_V = false
local DEBUG_D = false
local DEBUG_NP = false

--Fnp_Mode  仅显模式 true 过滤模式 false
--Fnp_OtherNPFlag 0是默认和EUI模式 1是TidyPlate模式 2是Kui

local function logd(str)
	if DEBUG_D then
		print(str)
	end
end

local function logv(str)
	if DEBUG_V then
		print(str)
	end
end

local function lognp(str)
	if DEBUG_NP then
		print(str)
	end
end

--[[-- 如果存在就不写入, 不存在才写入
local function insertATabValue(tab, value)
    local isExist = false;
    for pos, name in ipairs(tab) do
        if (name == value) then        
            isExist = true;
        end
    end
    if not isExist then table.insert(tab, value) end;
end
-----删除某个元素
local function removeATabValue(tab, value)
    for pos, name in ipairs(tab) do
        if (name == value) then        
            table.remove(tab, pos)         
        end
    end
end
--]]

local function printInfo()
	print("\124cFF63B8FF[过滤姓名板]\124r")

	local isEnable = "不"
	if Fnp_Enable == true then
		isEnable = "是"
	end
	print("\124cFF63B8FF启用状态:\124r "..isEnable)
	
	local isTidyEnabled = "不"
	if Fnp_OtherNPFlag == 1 then
		isTidyEnabled = "是"
	end
	print("\124cFF63B8FF支持TidyPlate:\124r "..isTidyEnabled)

	if Fnp_Mode ~= nil and Fnp_Mode == true then
		print("\124cFF63B8FF设置模式:\124r 仅显模式")
		if Fnp_ONameList ~= nil and table.getn(Fnp_ONameList) > 0 then
			print("\124cFF63B8FF[设置的仅显列表]：\124r")
			print(table.concat(Fnp_ONameList, ";"))
		else
			print("\124cFF63B8FF[设置的仅显列表]\124r :空")
		end
	else
		print("\124cFF63B8FF设置模式:\124r 过滤模式")
		if Fnp_FNameList ~= nil and table.getn(Fnp_FNameList) > 0 then
			print("\124cFF63B8FF[设置的过滤列表]：\124r")
			print(table.concat(Fnp_FNameList, ";"))
		else
			print("\124cFF63B8FF[设置的过滤列表]\124r :空")
		end
	end
	print("-----------")
end

local function registerMyEvents(self, event, ...)
	if Added_Count == nil then
		Added_Count = 0
	end

	if IS_REGISGER == nil then
		IS_REGISGER = false
	end
	if Fnp_Enable == nil then
		Fnp_Enable = false
	end
	if Fnp_Mode == nil then
		Fnp_Mode = true
	end

	if Fnp_OtherNPFlag == nil then
		Fnp_OtherNPFlag = 0
	end

	if AreaUnitList == nil then
		AreaUnitList = {}
	end
	
	if Fnp_ONameList == nil then
		Fnp_ONameList = {}
		table.insert(Fnp_ONameList, "邪能炸药")
	end
	
	if Fnp_FNameList == nil then
		Fnp_FNameList = {}
	end

	if IsCurrentAreaMatchedOnlyShow == nil then
		IsCurrentAreaMatchedOnlyShow = false
	end

	if IS_REGISGER == false then
		for k, v in pairs(FilterNp_EventList) do
			if k ~= "PLAYER_ENTERING_WORLD" then
				self:RegisterEvent(k,v)
			end
        end
		IS_REGISGER = true
	end
end

local function unRegisterMyEvents(self)
	if IS_REGISGER == true then
		IS_REGISGER = false
		for k, v in pairs(FilterNp_EventList) do
			if k ~= "PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent(k,v)
			end
        end
	end
end

function FNP_ChangeFrameVisibility()
	if FilteredNamePlate_Frame:IsVisible() then
		FilteredNamePlate_Frame:Hide()
		print("\124cFF63B8FF来回切换显示和隐藏敌方血条快捷键, 快速让插件生效.\124r")
	else
		FilteredNamePlate_Frame:Show()
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true);
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 1 then
			FilteredNamePlate_Frame_TidyEnableCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_TidyEnableCheckBtn:SetChecked(false);
		end

		if Fnp_Mode ~= nil and Fnp_Mode == true then
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(false);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(true);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(false);
		end

		FilteredNamePlate_Frame_OnlyShowModeEditBox:SetText(table.concat(Fnp_ONameList, ";"));
		FilteredNamePlate_Frame_FilteredModeEditBox:SetText(table.concat(Fnp_FNameList, ";"));
	end
end

function FilteredNamePlate_OnLoad(self)
	IS_REGISGER = false
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FNP_ModeCheckButtonChecked(mode, checked)
	if mode == "o" then
		if checked == true then
			Fnp_Mode = true
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(false);
		else
			Fnp_Mode = false
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(true);
		end
	else
		if checked == true then
			Fnp_Mode = false
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(false);
		else
			Fnp_Mode = true
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(true);
		end
	end
	printInfo()
end

function FNP_TidyEnableCheckButtonChecked(self, checked)
	if checked then
		Fnp_OtherNPFlag = 1
	else
		Fnp_OtherNPFlag = 0 -- TODO 如果超过TidyPlate就要处理
	end
	printInfo()
end

function FNP_EnableButtonChecked(self, checked)
	if (checked) then
		Fnp_Enable = true;
		registerMyEvents(self, "", "")
	else
		Fnp_Enable = false;
		unRegisterMyEvents(self)
		AreaUnitList = {}
		IsCurrentAreaMatchedOnlyShow = false
	end
	printInfo()
end

function FNP_ModeEditBoxWritenEsc()
	local names = ""
	local first = true
	for key, var in ipairs(Fnp_ONameList) do
		if first then 
			names = var
			first = false
		else
			names = names..";"..var
		end
	end
	FilteredNamePlate_Frame_OnlyShowModeEditBox:SetText(names);

	names = ""
	first = true
	for key, var in ipairs(Fnp_FNameList) do
		if first then 
			names = var
			first = false
		else
			names = names..";"..var
		end
	end
	FilteredNamePlate_Frame_FilteredModeEditBox:SetText(names);
	printInfo()
end

function FNP_ModeEditBoxWriten(mode, inputStr)
	if mode == "o" then
		Fnp_ONameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_ONameList, w) end )
	else
		Fnp_FNameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_FNameList, w) end )
	end
	printInfo()
end

function SlashCmdList.FilteredNamePlate(msg)
	local lastTarget = GetBindingKey("TARGETNEARESTENEMY");
	if msg == "" then
		print("\124cFF63B8FF[过滤姓名板]\124r")
		print("\124cFF63B8FF/fnp options 或 /fnp opt \124r打开菜单")
		print("\124cFF63B8FF/fnp change 或 /fnp ch \124r快速切换开关")
	elseif msg == "options" or msg == "opt" then
		FNP_ChangeFrameVisibility()
	elseif msg == "change" or msg == "ch" then
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false)
			FNP_EnableButtonChecked(FilteredNamePlate_Frame, false)
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true)
			FNP_EnableButtonChecked(FilteredNamePlate_Frame, true)
		end
	end
end

local function isMatchFilteredNameList(tName)
	if tName == nil then return false end

	if Fnp_Enable == false or Fnp_Mode == true then
		return false
	end

	local isMatch = false
	for key, var in ipairs(Fnp_FNameList) do
		local _, ret = string_find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

local function isMatchOnlyShowNameList(tName)
	if tName == nil then return false end

	if Fnp_Enable == false or Fnp_Mode == false then
		return false
	end

	local isMatch = false
	for key, var in ipairs(Fnp_ONameList) do
		local _, ret = string_find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

local function hideSingleUnitTidy(frame)
	if frame == nil then return end
	if Fnp_OtherNPFlag == 1 then
		--if frame.carrier then frame.carrier:Hide() end
		if frame.extended then frame.extended.visual.healthbar:Hide() end
	else
		if frame.UnitFrame then
			frame.UnitFrame.healthBar:Hide()
			--frame.UnitFrame:Hide()
		end
	end
end

local function showSingleUnitTidy(frame)
	if frame == nil then return end
	if Fnp_OtherNPFlag == 1 then
		--if frame.carrier then frame.carrier:Show() end
		if frame.extended then frame.extended.visual.healthbar:Show() end
	else
		if frame.UnitFrame then
			frame.UnitFrame.healthBar:Show()
			--frame.UnitFrame:Show()
		end
	end
end

---------kkkkk---kkkkk---kkkkk-------------
local function actionUnitAddedOnlyShowMode(...)
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local matched = false
	-- 1. 当前Add的单位名,是否match
	local curMatch = isMatchOnlyShowNameList(UnitName(unitid))
	if curMatch == false and IsCurrentAreaMatchedOnlyShow == true then
		--新增单位不需要仅显,但是目前处于仅显情况下, 那么,就将当前这个Hide
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit and (foundUnit == unitid) then
				hideSingleUnitTidy(frame)
				break
			end
		end
	elseif curMatch == false and IsCurrentAreaMatchedOnlyShow == false then 
	 -- 新增单位不需要仅显, 此时也没有仅显, 就不管了. 	
	elseif curMatch == true and IsCurrentAreaMatchedOnlyShow == true then
		-- 新增单位是需要仅显的,而此时已经有仅显的了,于是我们什么也不用干 -- 更新，怀疑在异步调用的时候莫名奇妙被hide了这里开出来确保
		showSingleUnitTidy(GetNamePlateForUnit(unitid))
	elseif curMatch == true and IsCurrentAreaMatchedOnlyShow == false then
		--新增单位是需要仅显的,而此时没有已经仅显的, 于是我们就将之前的都Hide,当前这个不用处理
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit and (unitid ~= foundUnit) then
				hideSingleUnitTidy(frame)
			end
		end
		IsCurrentAreaMatchedOnlyShow = true
	end
end

local function actionUnitAddedFilterMode(...)
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local matched = isMatchFilteredNameList(UnitName(unitid))
	if matched == true then
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit and (foundUnit == unitid) then
				hideSingleUnitTidy(frame)
				break
			end
		end
	end
end

local function actionUnitRemovedOnlyShowMode(...)
	if IsCurrentAreaMatchedOnlyShow == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	-- 已经在仅显情况下了
		-- 1. 当前移除的单位名,是否match
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curMatch = isMatchOnlyShowNameList(UnitName(unitid))
	if curMatch == true then
		-- 移除单位是需要仅显的,而此时已经仅显即IsCurrentAreaMatchedOnlyShow为true,
		--于是我们判断剩余的是否还含有,如果还有就什么也不动.如果没有了,就恢复显示,IsCurrentAreaMatchedOnlyShow改成false
		local matched = false
		local name = ""
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit then
				matched = isMatchOnlyShowNameList(GetUnitName(foundUnit))
				if matched == true then
					return
				end
			end
		end
		--没有找到,说明我们该退出了就显示
		for _, frame in pairs(GetNamePlates()) do
			showSingleUnitTidy(frame)
		end
		IsCurrentAreaMatchedOnlyShow = false
	end
end
---------k k k---k k k---k k k-------------

local function actionUnitAdded(self, event, ...)
	-- 关闭则直接return
	if Fnp_Enable == false then
		return
	end
	-- 如果OnlyShow列表为空return
	if Fnp_Mode == true then
		actionUnitAddedOnlyShowMode(...)
	else
		actionUnitAddedFilterMode(...)
	end
end

local function actionUnitRemoved(self, event, ...)
	-- 关闭则直接return
	if Fnp_Enable == false then
		return
	end
	if Fnp_Mode == true then
		actionUnitRemovedOnlyShowMode(...)
	end
end

--local function actionUnitRemovedFilterMode(...)
	-- do nothing
--end

--[[
local function actionUnitSpellCastStartOnlyShowMode(...)
	if IsCurrentAreaMatchedOnlyShow == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchOnlyShowNameList(curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。
	if curMatch == false then --false，而且是处于isCurrentOnlyShow
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit and (foundUnit == unitid) then
				showSingleUnitTidy(frame)
			end
		end
	end
end

local function actionUnitSpellCastStopOnlyShowMode(...)
	if IsCurrentAreaMatchedOnlyShow == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchOnlyShowNameList(curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。
	if curMatch == false then --false，而且是处于isCurrentOnlyShow
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken
			if foundUnit and (foundUnit == unitid) then
				hideSingleUnitTidy(frame)
			end
		end
	end
end

local function actionUnitSpellCastStart(self, event, ...)
	if Fnp_Enable == false then
		return
	end
	if Fnp_Mode == true then
		actionUnitSpellCastStartOnlyShowMode(...)
	end -- filter mode no need to do
end

local function actionUnitSpellCastStop(self, event, ...)
	if Fnp_Enable == false then
		return
	end
	if Fnp_Mode == true then
		actionUnitSpellCastStopOnlyShowMode(...)
	end -- filter mode no need to do
end
--]]

FilterNp_EventList = {
	["NAME_PLATE_UNIT_ADDED"]         = actionUnitAdded,
	["NAME_PLATE_UNIT_REMOVED"]       = actionUnitRemoved,
	-- ["UNIT_SPELLCAST_START"]          = actionUnitSpellCastStart,
	-- ["UNIT_SPELLCAST_CHANNEL_START"]  = actionUnitSpellCastStart,
	-- ["UNIT_SPELLCAST_STOP"]           = actionUnitSpellCastStop,
	-- ["UNIT_SPELLCAST_SUCCEEDED"]      = actionUnitSpellCastStop,
	-- ["UNIT_SPELLCAST_CHANNEL_STOP"]   = actionUnitSpellCastStop,
	-- ["UNIT_SPELLCAST_CHANNEL_UPDATE"] = actionUnitSpellCastUpdate,
	["PLAYER_ENTERING_WORLD"]         = registerMyEvents,
};

function FilteredNamePlate_OnEvent(self, event, ...)
	local handler = FilterNp_EventList[event]
	if handler then
	    handler(self, event, ...)
	end
end
