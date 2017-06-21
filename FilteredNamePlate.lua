FilteredNamePlate = {}
local FilteredNamePlate = FilteredNamePlate
SLASH_FilteredNamePlate1 = "/fnp"
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitName, GetUnitName = UnitName, GetUnitName
local string_find = string.find
local FilterNp_EventList = FilterNp_EventList

local IS_REGISGER, IsCurOnlyShowStat, currentNpFlag, isScaleListInited, isNullOnlyList, isNullFilterList

local CurrentScaleList, CurrentOrigScaleList

--Fnp_Mode  仅显模式 true 过滤模式 false 暂时去掉过滤模式，其实没什么用
--Fnp_OtherNPFlag 0是默认 1是TidyPlate模式 2是Kui 3是EUI

local function printInfo()
	print("\124cFFF58CBA>>>>>>[过滤姓名板]\124r")
	local showstr = ""
	local isEnable = "不"
	if Fnp_Enable == true then
		isEnable = "是"
	end
	showstr = "\124cFFF58CBA启用状态:\124r "..isEnable.."， "
	local supportUIName = "原生/EUI"
	if Fnp_OtherNPFlag == 1 then
		supportUIName = "TidyPlate"
	elseif Fnp_OtherNPFlag == 2 then
		supportUIName = "Kui_NamePlates"
	end
	showstr = showstr.."\124cFFF58CBAUI类型:\124r "..supportUIName
	print(showstr)
	showstr = ""
	if Fnp_ONameList ~= nil and FilteredNamePlate.getTableCount(Fnp_ONameList) > 0 then
		showstr = showstr.."\124cFFF58CBA仅显列表：\124r"..table.concat(Fnp_ONameList, ";")
	else
		showstr = showstr.."\124cFFF58CBA仅显列表：\124r空"
	end
	print(showstr)
	showstr = ""
	if Fnp_FNameList ~= nil and FilteredNamePlate.getTableCount(Fnp_FNameList) > 0 then
		showstr = showstr.."\124cFFF58CBA过滤列表：\124r"..table.concat(Fnp_FNameList, ";")
	else
		showstr = showstr.."\124cFFF58CBA过滤列表：\124r空"
	end
	print(showstr)
	print("\124cFFF58CBA默认比例:\124r "..Fnp_SavedScaleList.normal)
	print("\124cFFF58CBA非仅显单位比例:\124r "..Fnp_SavedScaleList.small)
	--FilteredNamePlate.printATab(Fnp_SavedScaleList)
end

local function registerMyEvents(self, event, ...)
	if IS_REGISGER == true then return end
	if Fnp_Enable == nil then
		Fnp_Enable = false
	end

	if Fnp_OtherNPFlag == nil then
		Fnp_OtherNPFlag = 0
	end

	currentNpFlag = Fnp_OtherNPFlag

	if Fnp_ONameList == nil then
		Fnp_ONameList = {}
		table.insert(Fnp_ONameList, "邪能炸药")
	end

	if Fnp_FNameList == nil then
		Fnp_FNameList = {}
	end

	if IsCurOnlyShowStat == nil then
		IsCurOnlyShowStat = false
	end

	if Fnp_SavedScaleList == nil then
		Fnp_SavedScaleList = {
			normal = 1,
			small = 0.25,
		}
	end

	isNullOnlyList = false
	isNullFilterList = false
	if FilteredNamePlate.getTableCount(Fnp_ONameList) == 0 then isNullOnlyList = true end
	if FilteredNamePlate.getTableCount(Fnp_FNameList) == 0 then isNullFilterList = true end

	isScaleListInited = false

	if Fnp_Enable == true then
		FilteredNamePlate.isSettingChanged = false
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
		Fnp_Enable = false
		for k, v in pairs(FilterNp_EventList) do
			if k ~= "PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent(k,v)
			end
        end
	end
end

local function isMatchedNameList(tabList, tName)
	if tName == nil then return false end

	local isMatch = false
	for key, var in ipairs(tabList) do
		local _, ret = string_find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

---------kkkkk---kkkkk---kkkkk-------------
local function reinitScaleValues()
	if isScaleListInited == false then return end
	CurrentScaleList.normal = CurrentScaleList.SYSTEM * Fnp_SavedScaleList.normal
	CurrentScaleList.small = CurrentScaleList.normal * Fnp_SavedScaleList.small
	CurrentScaleList.middle = CurrentScaleList.normal * 0.75

	CurrentOrigScaleList.name.normal = CurrentOrigScaleList.name.SYSTEM
	CurrentOrigScaleList.name.small = CurrentOrigScaleList.name.normal * Fnp_SavedScaleList.small
	CurrentOrigScaleList.name.middle = CurrentOrigScaleList.name.normal * 0.75

	CurrentOrigScaleList.castbar.normal = CurrentOrigScaleList.castbar.SYSTEM * Fnp_SavedScaleList.normal
	CurrentOrigScaleList.castbar.small = 50
	CurrentOrigScaleList.castbar.middle = 80
	CurrentOrigScaleList.castbar.normalScale = CurrentOrigScaleList.castbar.SYSTEM_SCALE * Fnp_SavedScaleList.normal
	CurrentOrigScaleList.castbar.smallScale = CurrentOrigScaleList.castbar.normalScale * Fnp_SavedScaleList.small
	CurrentOrigScaleList.castbar.middleScale = CurrentOrigScaleList.castbar.normalScale * 0.75

	CurrentOrigScaleList.healthbar.normal = CurrentOrigScaleList.healthbar.SYSTEM * Fnp_SavedScaleList.normal
	CurrentOrigScaleList.healthbar.small = 50
	CurrentOrigScaleList.healthbar.middle = 80
	CurrentOrigScaleList.healthbar.normalScale = CurrentOrigScaleList.healthbar.SYSTEM_SCALE * Fnp_SavedScaleList.normal
	CurrentOrigScaleList.healthbar.smallScale = CurrentOrigScaleList.healthbar.normalScale * Fnp_SavedScaleList.small
	CurrentOrigScaleList.healthbar.middleScale = CurrentOrigScaleList.healthbar.normalScale * 0.75
end


local function initScaleValues()
	local indx = currentNpFlag

	if isScaleListInited == true then
		reinitScaleValues()
		return
	end

	for _, frame in pairs(GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
		if foundUnit then
			CurrentScaleList = { -- 一种原始保存,三种不同状态下的scale value
			SYSTEM = 0.78,
			normal = 1.0,
			small = 0.25,
			middle = 0.6,
			};
			CurrentOrigScaleList = {
				name = {
					SYSTEM = 130,
					normal = 130,
					small = 40,
					middle = 80,
				},
				castbar = {
					SYSTEM = 130,
					SYSTEM_SCALE = 0.78,
					normal = 130,
					normalScale = 0.78,
					small = 80,
					smallScale = 0.5,
					middle = 100,
					middleScale = 0.75,
				},
				healthbar = {
					SYSTEM = 130,
					SYSTEM_SCALE = 0.78,
					normal = 130,
					normalScale = 0.78,
					small = 80,
					smallScale = 0.5,
					middle = 100,
					middleScale = 0.75,
				},
			}
			local sys = 0
			if indx == 3 then --EUI
				if frame.UnitFrame then
					sys = frame.UnitFrame:GetEffectiveScale()
				end
			elseif indx == 1 then --Tidy
				if frame.carrier then
					sys = frame.carrier:GetEffectiveScale()
				end
			elseif indx == 2 then -- Kui
				if frame.kui then
					sys = frame.kui:GetEffectiveScale()
				end
			elseif indx == 0 then --Orig
				if frame.UnitFrame then
					sys = 1
					CurrentOrigScaleList.name.SYSTEM = frame.UnitFrame:GetWidth()
					CurrentOrigScaleList.castbar.SYSTEM = frame.UnitFrame.castBar:GetWidth()
					CurrentOrigScaleList.healthbar.SYSTEM = frame.UnitFrame.healthBar:GetWidth()
					CurrentOrigScaleList.castbar.SYSTEM_SCALE = frame.UnitFrame.castBar:GetEffectiveScale()
					CurrentOrigScaleList.healthbar.SYSTEM_SCALE = frame.UnitFrame.healthBar:GetEffectiveScale()
				end
			end
			if sys > 0.01 then -- it's a real info
				CurrentScaleList.SYSTEM = sys
				reinitScaleValues()
				isScaleListInited = true
				print("inittt CurrentScaleLList>>>>")
				FilteredNamePlate.printCurrentScaleList(CurrentScaleList, CurrentOrigScaleList, currentNpFlag)
				break
			end
		end
	end
end

local hideSwitchSingleUnit = {
	[0] = function(frame)
		if frame == nil then return end
		if frame.UnitFrame then
			frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.small)
			-- frame.UnitFrame.healthBar:Hide()
			frame.UnitFrame.healthBar:SetWidth(CurrentOrigScaleList.healthbar.small)
			frame.UnitFrame.healthBar:SetScale(CurrentOrigScaleList.healthbar.smallScale)
			frame.UnitFrame.castBar:SetWidth(CurrentOrigScaleList.castbar.small)
			frame.UnitFrame.castBar:SetScale(CurrentOrigScaleList.castbar.smallScale)
		end
	end,
	[1] = function(frame)
		if frame == nil then return end
		if frame.carrier then
			frame.carrier:SetScale(CurrentScaleList.small)
		end
	end,
	[2] = function(frame)
		if frame == nil then return end
		if frame.kui then
			frame.kui:SetScale(CurrentScaleList.small)
		end
	end,
	[3] = function(frame)
		if frame == nil then return end
		if frame.UnitFrame then
			frame.UnitFrame:SetScale(CurrentScaleList.small)
		end
	end
}

local function showSingleUnit(frame, isOnlyShowSpellCast, restore)
	if frame == nil then return end
	if currentNpFlag == 0 and frame.UnitFrame then  -- ORig
		if restore == true then
			frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.SYSTEM)
			-- frame.UnitFrame.healthBar:Show()
			frame.UnitFrame.healthBar:SetWidth(CurrentOrigScaleList.healthbar.SYSTEM)
			frame.UnitFrame.healthBar:SetScale(CurrentOrigScaleList.healthbar.SYSTEM_SCALE)
			frame.UnitFrame.castBar:SetWidth(CurrentOrigScaleList.castbar.SYSTEM)
			frame.UnitFrame.castBar:SetScale(CurrentOrigScaleList.castbar.SYSTEM_SCALE)
		elseif isOnlyShowSpellCast == false then
			frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.normal)
			-- frame.UnitFrame.healthBar:Show()
			frame.UnitFrame.healthBar:SetWidth(CurrentOrigScaleList.healthbar.normal)
			frame.UnitFrame.healthBar:SetScale(CurrentOrigScaleList.healthbar.normalScale)
			frame.UnitFrame.castBar:SetWidth(CurrentOrigScaleList.castbar.normal)
			frame.UnitFrame.castBar:SetScale(CurrentOrigScaleList.castbar.normalScale)
		else
			frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.middle)
			-- frame.UnitFrame.healthBar:Show()
			frame.UnitFrame.healthBar:SetWidth(CurrentOrigScaleList.healthbar.middle)
			frame.UnitFrame.healthBar:SetScale(CurrentOrigScaleList.healthbar.middleScale)
			frame.UnitFrame.castBar:SetWidth(CurrentOrigScaleList.castbar.middle)
			frame.UnitFrame.castBar:SetScale(CurrentOrigScaleList.castbar.middleScale)
		end
		return
	end
	local frameImp
	if currentNpFlag == 1 and frame.carrier then -- Tidy
		frameImp = frame.carrier
	elseif currentNpFlag == 2 and frame.kui then -- kui
		frameImp = frame.kui
	elseif currentNpFlag == 3 and frame.UnitFrame then --EUI
		frameImp = frame.UnitFrame
	end

	if frameImp then
		if restore == true then
			frameImp:SetScale(CurrentScaleList.SYSTEM)
		elseif isOnlyShowSpellCast == false then
			frameImp:SetScale(CurrentScaleList.normal)
		else
			frameImp:SetScale(CurrentScaleList.middle)
		end
	end
end

function FilteredNamePlate.actionUnitStateAfterChanged()
	initScaleValues()
	local matched = false
	if Fnp_Enable == true then
		--仅显
		isNullOnlyList = false
		if FilteredNamePlate.getTableCount(Fnp_ONameList) == 0 then isNullOnlyList = true end
		for _, frame in pairs(GetNamePlates()) do
			if isNullOnlyList == true then
				showSingleUnit(frame, false, false)
			else
				local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == true then
					showSingleUnit(frame, false, false)
				else
					hideSwitchSingleUnit[currentNpFlag](frame)
				end
			end
		end
 		--过滤
		isNullFilterList = false
		if FilteredNamePlate.getTableCount(Fnp_FNameList) == 0 then isNullFilterList = true end
		for _, frame in pairs(GetNamePlates()) do
			if isNullFilterList == true then
				showSingleUnit(frame, false, false)
			else
				local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
				matched = isMatchedNameList(Fnp_FNameList, GetUnitName(foundUnit))
				if matched == true then
					hideSwitchSingleUnit[currentNpFlag](frame)
				else
					showSingleUnit(frame, false, false)
				end
			end
		end
		registerMyEvents(FilteredNamePlate_Frame, "", "")
	else -- 已经关闭功能就全部显示
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				showSingleUnit(frame, false, true)
				break
			end
		end
		unRegisterMyEvents(FilteredNamePlate_Frame)
	end
	print("\124cFFF58CBA如果效果不对，请尝试来回按隐藏和显示血条的快捷键，就能生效！\124r")
end

local function getNamePlateFromPlatesById(unitid)
	for _, frame in pairs(GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
		if foundUnit and (foundUnit == unitid) then
			return frame
		end
	end
	return nil
end

local function actionUnitAddedForce(unitid)
	local addedname = UnitName(unitid)
	-- 0. 当前Add的单位名,是否match filter
	local curFilterMatch = false
	if isNullFilterList == false then curFilterMatch = isMatchedNameList(Fnp_FNameList, addedname) end
	if curFilterMatch == true then
		local frame = GetNamePlateForUnit(unitid)
		hideSwitchSingleUnit[currentNpFlag](frame)
		return
	end
	-- 1. 当前add的单位名,是否match
	local curOnlyMatch = isMatchedNameList(Fnp_ONameList, addedname)
	if curOnlyMatch == false and IsCurOnlyShowStat == true then
		--新增单位不需要仅显,但是目前处于仅显情况下, 那么,就将当前这个Hide TODO 这里改成直接用自己,而不是用GetNamePlates
		-- local frame = getNamePlateFromPlatesById(unitid)
		local frame = GetNamePlateForUnit(unitid)
		hideSwitchSingleUnit[currentNpFlag](frame)
	elseif curOnlyMatch == false and IsCurOnlyShowStat == false then
		-- 新增单位不需要仅显, 此时也没有仅显, 就不管了.现在我们将当前的效果展示出来
		showSingleUnit(GetNamePlateForUnit(unitid), false, false)
	elseif curOnlyMatch == true and IsCurOnlyShowStat == true then
		-- 新增单位是需要仅显的,而此时已经有仅显的了,于是我们什么也不用干 -- 更新，怀疑在异步调用的时候莫名奇妙被hide了这里开出来确保
		showSingleUnit(GetNamePlateForUnit(unitid), false, false)
	elseif curOnlyMatch == true and IsCurOnlyShowStat == false then
		--新增单位是需要仅显的,而此时不是仅显, 于是我们就将之前的都Hide,当前这个不用处理
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				-- TODO 判断是否是正在读条
				if (unitid == foundUnit) then
					showSingleUnit(frame, false, false)
				else
					hideSwitchSingleUnit[currentNpFlag](frame)
				end
			end
		end
		IsCurOnlyShowStat = true
	end
end

local function actionUnitRemovedForce(unitid)
	-- 1. 当前移除的单位名,是否match
	local curOnlyMatch = isMatchedNameList(Fnp_ONameList, UnitName(unitid))
	if curOnlyMatch == true then
		-- 移除单位是需要仅显的,而此时肯定已经仅显即IsCurOnlyShowStat为true,
		--于是我们判断剩余的是否还含有,如果还有就什么也不动.如果没有了,就恢复显示,IsCurOnlyShowStat改成false
		local matched = false
		local name = ""
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == true then
					return --have & return
				end
			end
		end
		--没有找到,说明我们该退出了就显示
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == false then
					showSingleUnit(frame, false, false)
				end
			end
		end
		IsCurOnlyShowStat = false
	end
end
---------k k k---k k k---k k k-------------

local function actionUnitAdded(self, event, ...)
	if isScaleListInited == false then
		initScaleValues()
	end
	
	if isScaleListInited == false then
		print("\124cFFF58CBA[ /fnp ]错误！您设置的UI类型可能不匹配。请正确设置并重载界面！\124r")
		print("\124cFFF58CBA[ /fnp ]错误！您设置的UI类型可能不匹配。请正确设置并重载界面！\124r")
		print("\124cFFF58CBA[ /fnp ]错误！您设置的UI类型可能不匹配。请正确设置并重载界面！\124r")
		return
	end
	if isNullOnlyList == true and isNullFilterList == true then
		return
	end

	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	actionUnitAddedForce(unitid)
end

local function actionUnitRemoved(self, event, ...)
	--这里不需要判断是否为空
	-- if isNullOnlyList == true and isNullFilterList == true then
	--	return
	-- end
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	actionUnitRemovedForce(unitid)
end
--[[
local function actionTargetChanged(self, event, ...)
end
--]]

local function actionUnitSpellCastStartOnlyShowMode(...)
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchedNameList(Fnp_ONameList, curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。
	if curMatch == false then --false，而且是处于isCurrentOnlyShow
		local frame = GetNamePlateForUnit(unitid)
		showSingleUnit(frame, true, false)
	end
end

local function actionUnitSpellCastStopOnlyShowMode(...)
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchedNameList(Fnp_ONameList, curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。
	if curMatch == false then --false，而且是处于isCurrentOnlyShow
		local frame = GetNamePlateForUnit(unitid)
		-- hideSingleUnit(frame)
		hideSwitchSingleUnit[currentNpFlag](frame)
	end
end

local function actionUnitSpellCastStart(self, event, ...)
	actionUnitSpellCastStartOnlyShowMode(...)
end

local function actionUnitSpellCastStop(self, event, ...)
	actionUnitSpellCastStopOnlyShowMode(...)
end

local function actionAreaChanged(self, event)
	-- print("areaChanged> "..event)
end

FilterNp_EventList = {
	["NAME_PLATE_UNIT_ADDED"]         = actionUnitAdded,
	["NAME_PLATE_UNIT_REMOVED"]       = actionUnitRemoved,

	["UNIT_SPELLCAST_START"]          = actionUnitSpellCastStart,
	["UNIT_SPELLCAST_CHANNEL_START"]  = actionUnitSpellCastStart,
	["UNIT_SPELLCAST_STOP"]           = actionUnitSpellCastStop,
	["UNIT_SPELLCAST_CHANNEL_STOP"]   = actionUnitSpellCastStop,

	["PLAYER_ENTERING_WORLD"]         = registerMyEvents,
	-- ["PLAYER_TARGET_CHANGED"]		  = actionTargetChanged,
	-- ["ZONE_CHANGED_NEW_AREA"]         = actionAreaChanged,
};

function FilteredNamePlate_OnEvent(self, event, ...)
	local handler = FilterNp_EventList[event]
	if handler then
	    handler(self, event, ...)
	end
end

function FilteredNamePlate_OnLoad(self)
	IS_REGISGER = false
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FilteredNamePlate.FNP_UITypeChanged(checkbtn, checked, flag)
	if checked then
		Fnp_OtherNPFlag = flag
		if flag == 0 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(true)
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false)
		elseif flag == 1 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(true)
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false)
		elseif flag == 2 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(true)
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false)
		elseif flag == 3 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false)
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(true)
		end
	else
		checkbtn:SetChecked(true)
	end
	print("\124cFFF58CBA修改了插件类型，请重载/reload或者/rl !!!\124r")
end

function FilteredNamePlate.FNP_EnableButtonChecked(self, checked)
	if (checked) then
		Fnp_Enable = true;
	else
		Fnp_Enable = false;
		IsCurOnlyShowStat = false
	end
	FilteredNamePlate.actionUnitStateAfterChanged()
end

function FilteredNamePlate.FNP_ModeEditBoxWritenEsc()
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
end

function FilteredNamePlate.FNP_ModeEditBoxWriten(mode, inputStr)
	if mode == "o" then
		Fnp_ONameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_ONameList, w) end )
	else
		Fnp_FNameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_FNameList, w) end )
	end
end

function FilteredNamePlate.FNP_ChangeFrameVisibility(...)
	local advanced = ...
	if advanced then
		if FilteredNamePlate_AdvancedFrame:IsVisible() then
			FilteredNamePlate_AdvancedFrame:Hide()
		else
			FilteredNamePlate_AdvancedFrame:Show()
		end
		return
	end

	if FilteredNamePlate_Frame:IsVisible() then
		FilteredNamePlate_Frame:Hide()
		FilteredNamePlate_AdvancedFrame:Hide()
		--printInfo()
	else
		local oldChange = FilteredNamePlate.isSettingChanged
		FilteredNamePlate_Frame:Show()
		FilteredNamePlate_AdvancedFrame:Show()

		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true);
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 0 then
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false);
		end
		if Fnp_OtherNPFlag == 1 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 2 then
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 3 then
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false);
		end

		--[[
		if Fnp_Mode ~= nil and Fnp_Mode == true then
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(false);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(true);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(false);
		end --]]

		-- FilteredNamePlate_AdvancedFrame_OnlyShowScale:SetValue(Fnp_SavedScaleList.only * 100)
		FilteredNamePlate_AdvancedFrame_OnlyOtherShowScale:SetValue(Fnp_SavedScaleList.small * 100)
		FilteredNamePlate_AdvancedFrame_SystemScale:SetValue(Fnp_SavedScaleList.normal * 100)

		FilteredNamePlate_Frame_OnlyShowModeEditBox:SetText(table.concat(Fnp_ONameList, ";"));
		FilteredNamePlate_Frame_FilteredModeEditBox:SetText(table.concat(Fnp_FNameList, ";"));
		
		if oldChange == false then
			FilteredNamePlate_Frame_takeEffectBtn:Hide()
		end
	end
end

function SlashCmdList.FilteredNamePlate(msg)
	local lastTarget = GetBindingKey("TARGETNEARESTENEMY");
	if msg == "" then
		print("\124cFFF58CBA[过滤姓名板]\124r")
		print("\124cFFF58CBA/fnp options 或 /fnp opt \124r打开菜单")
		print("\124cFFF58CBA/fnp change 或 /fnp ch \124r快速切换开关")
		print("\124cFFF58CBA/fnp hideSpellCast 或 /fnp hsc \124r快速隐藏正在施法的怪")
	elseif msg == "options" or msg == "opt" then
		FilteredNamePlate.FNP_ChangeFrameVisibility()
	elseif msg == "change" or msg == "ch" then
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false)
			FilteredNamePlate.FNP_EnableButtonChecked(FilteredNamePlate_Frame, false)
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true)
			FilteredNamePlate.FNP_EnableButtonChecked(FilteredNamePlate_Frame, true)
		end
	elseif msg == "refresh" then
		FilteredNamePlate.actionUnitStateAfterChanged()
	end
end
