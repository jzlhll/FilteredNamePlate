SLASH_FilteredNamePlate1 = "/fnp"
DEBUG_LOG = true
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitName, GetUnitName = UnitName, GetUnitName
--Fnp_Mode  仅显模式 true 过滤模式 false

function printInfo()
	print("-----------")
	print("\124cFF63B8FF[过滤姓名板]\124r")

	local isEnable = "不"
	if Fnp_Enable == true then
		isEnable = "是"
	end
	print("\124cFF63B8FF启用状态:\124r "..isEnable)
	
	local isTidyEnabled = "不"
	if Fnp_TidyEnabled == true then
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

function printLog(mylog)
	if DEBUG_LOG == true then
		print(mylog)
	end
end

function registerMyEvents(self)
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

	if Fnp_TidyEnabled == nil then
		Fnp_TidyEnabled = false
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
		-- self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
		self:RegisterEvent("NAME_PLATE_CREATED")
		IS_REGISGER = true
	end
end

function unRegisterMyEvents(self)
	if IS_REGISGER == true then
		IS_REGISGER = false
		-- self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
		self:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
		self:UnregisterEvent("NAME_PLATE_CREATED")
	end
end

function ChangeFrameVisibility()
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

		if Fnp_TidyEnabled == true then
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
		--print("\124cFF63B8FF过滤模式：基本都显示, 只有过滤列表中的不显示\124r")
		--print("\124cFF63B8FF仅显模式：都不显示, 只有仅显列表的才显示。如果周围不存在仅显列表的敌对单位,则全部显示\124r")
	end
end

function FilteredNamePlate_OnLoad(self)
	IS_REGISGER = false
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	-- self:RegisterEvent("CHALLENGE_MODE_START")
	-- self:RegisterEvent("CHALLENGE_MODE_RESET")
end

function ModeCheckButtonChecked(mode, checked)
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

function TidyEnableCheckButtonChecked(self, checked)
	if checked then
		Fnp_TidyEnabled = true
	else
		Fnp_TidyEnabled = false
	end
	printInfo()
end

function EnableButtonChecked(self, checked)
	if (checked) then
		Fnp_Enable = true;
		registerMyEvents(self)
	else
		Fnp_Enable = false;
		unRegisterMyEvents(self)
		AreaUnitList = {}
		IsCurrentAreaMatchedOnlyShow = false
	end
	printInfo()
end

function ModeEditBoxWritenEsc()
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

function ModeEditBoxWriten(mode, inputStr)
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
		ChangeFrameVisibility()
	elseif msg == "change" or msg == "ch" then
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false)
			EnableButtonChecked(FilteredNamePlate_Frame, false)
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true)
			EnableButtonChecked(FilteredNamePlate_Frame, true)
		end
	end
end

function isMatchFilteredNameList(tName)
	if Fnp_Enable == false or Fnp_Mode == true then
		return false
	end

	local isMatch = false
	for key, var in ipairs(Fnp_FNameList) do
		local _, ret = string.find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

function isMatchOnlyShowNameList(tName)
	if Fnp_Enable == false or Fnp_Mode == false then
		return false
	end

	local isMatch = false
	for key, var in ipairs(Fnp_ONameList) do
		local _, ret = string.find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

---- 如果存在就不写入, 不存在才写入
function insertATabValue(tab, value)
    local isExist = false;
    for pos, name in ipairs(tab) do
        if (name == value) then        
            isExist = true;
        end
    end
    if not isExist then table.insert(tab, value) end;
end
-----删除某个元素
function removeATabValue(tab, value)
    for pos, name in ipairs(tab) do
        if (name == value) then        
            table.remove(tab, pos)         
        end
    end
end

function hideSimpleUnitTidy(frame)
	local extended = frame.extended
	if (not extended) then
	else
		local carrier = frame.carrier
		carrier:Hide()
	end
end

function showSimpleUnitTidy(frame)
	local extended = frame.extended
	if (not extended) then
	else
		local carrier = frame.carrier
		carrier:Show()
	end
end

function euiActionUnitAddedOnlyShowMode(...)
	local unitid = ...
	local name = ""
	local matched = false
	-- 1. 当前Add的单位名,是否match
	local curName = UnitName(unitid)
	local curMatch = isMatchOnlyShowNameList(curName)
	if curMatch == true and IsCurrentAreaMatchedOnlyShow == true then
		-- 新增单位是需要仅显的,而此时已经有仅显的了,于是我们什么也不用干
	elseif curMatch == true and IsCurrentAreaMatchedOnlyShow == false then
		--新增单位是需要仅显的,而此时没有已经仅显的, 于是我们就将之前的都Hide,当前这个不用处理
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				name = GetUnitName(foundUnit)
				if name == curName then
				else
				    frame.UnitFrame:Hide()
				end
			end
		end
		IsCurrentAreaMatchedOnlyShow = true
	elseif curMatch == false and IsCurrentAreaMatchedOnlyShow == true then
		--新增单位不需要仅显,但是目前处于仅显情况下, 那么,就将当前这个Hide
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				name = GetUnitName(foundUnit)
				if name == curName then
					frame.UnitFrame:Hide()
				end
			end
		end
	end -- 新增单位不需要仅显, 此时也没有仅显, 就不管了. 
end

function actionUnitAddedOnlyShowMode(...)
	local unitid = ...
	local count = table.getn(Fnp_ONameList)
	if count == 0 then
		insertATabValue(AreaUnitList, unitid)
		return
	end
	-- 1. 当前Add的单位名,是否match
	local curMatch = isMatchOnlyShowNameList(UnitName(unitid))
	if curMatch == true and IsCurrentAreaMatchedOnlyShow == true then
		-- 新增单位是需要仅显的,而此时已经有仅显的了,于是我们什么也不用干
	elseif curMatch == true and IsCurrentAreaMatchedOnlyShow == false then
		--新增单位是需要仅显的,而此时没有已经仅显的, 于是我们就将之前的都Hide,当前这个不用处理
		for key, var in ipairs(AreaUnitList) do
			local plate = GetNamePlateForUnit(var);
			plate:GetChildren():Hide()
    	end
		IsCurrentAreaMatchedOnlyShow = true
	elseif curMatch == false and IsCurrentAreaMatchedOnlyShow == true then
		--新增单位不需要仅显,但是目前处于仅显情况下, 那么,就将当前这个Hide
		local plate = GetNamePlateForUnit(unitid);
		plate:GetChildren():Hide()
	end -- 新增单位不需要仅显, 此时也没有仅显, 就不管了. 
	insertATabValue(AreaUnitList, unitid)
	-- printAreaUnitListDebug(true)
end

function euiActionUnitAddedFilterMode(...)
	local unitid = ...
	local name = UnitName(unitid)
	local matched = isMatchFilteredNameList(name)
	if matched == true then
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				name = GetUnitName(foundUnit)
				if name == curName then
					frame.UnitFrame:Hide()
				end
			end
		end
	end
end

function actionUnitAddedFilterMode(...)
	local unitid = ...
	insertATabValue(AreaUnitList, unitid)
	-- printAreaUnitListDebug(true)
	local name = UnitName(unitid)
	local matched = isMatchFilteredNameList(name)
	if matched == true then
		local plate = GetNamePlateForUnit(unitid);
		plate:GetChildren():Hide()
	end
end

function euiActionUnitRemovedOnlyShowMode(...)
	if IsCurrentAreaMatchedOnlyShow == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	-- 已经在仅显情况下了
		-- 1. 当前移除的单位名,是否match
	local unitid = ...
	local curMatch = isMatchOnlyShowNameList(UnitName(unitid))
	if curMatch == true then
		-- 移除单位是需要仅显的,而此时已经仅显即IsCurrentAreaMatchedOnlyShow为true,
		--于是我们判断剩余的是否还含有,如果还有就什么也不动.如果没有了,就恢复显示,IsCurrentAreaMatchedOnlyShow改成false
		local matched = false
		local name = ""
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				name = GetUnitName(foundUnit)
				matched = isMatchOnlyShowNameList(name)
				if matched == true then
					return
				end
			end
		end
		--没有找到,说明我们该退出了就显示
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if frame ~= nil and frame.UnitFrame ~= nil then
				frame.UnitFrame:Show()
			end
		end
		IsCurrentAreaMatchedOnlyShow = false
	end
end

function actionUnitRemovedOnlyShowMode(...)
	local unitid = ...
	removeATabValue(AreaUnitList, unitid)
	--printAreaUnitListDebug(false)
	if IsCurrentAreaMatchedOnlyShow == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	-- 已经在仅显情况下了
		-- 1. 当前移除的单位名,是否match
	local curMatch = isMatchOnlyShowNameList(UnitName(unitid))
	if curMatch == true then
		-- 移除单位是需要仅显的,而此时已经有仅显的了,于是我们判断剩余的是否还含有,如果还有就什么也不动.如果没有了,就恢复显示,退出current模式
		local matched = false
		for key, var in ipairs(AreaUnitList) do
			matched = isMatchOnlyShowNameList(UnitName(var))
			if matched == true then
				return
			end
    	end
		--没有找到,说明我们该退出了就显示
		for key, var in ipairs(AreaUnitList) do
			local plate = GetNamePlateForUnit(var);
			plate:GetChildren():Show()
    	end
		IsCurrentAreaMatchedOnlyShow = false
	end
	--移除单位是不需要仅显的,而此时已经是仅显模式,说明杀了一个不是onlyShowList的怪. 所以不用处理 
end

--function euiActionUnitRemovedFilterMode(...)
	-- do nothing
--end

function actionUnitRemovedFilterMode(...)
	local unitid = ...
	removeATabValue(AreaUnitList, unitid)
	--printAreaUnitListDebug(false)
end

function FilteredNamePlate_OnEvent(self,event,...)
	if event == "NAME_PLATE_UNIT_ADDED" then  -- Added
		-- 关闭则直接return
		if Fnp_Enable == false then
			return
		end
		-- 如果OnlyShow列表为空return
		if Fnp_Mode == true then
			if Fnp_TidyEnabled == true then
				actionUnitAddedOnlyShowMode(...)
			else
				euiActionUnitAddedOnlyShowMode(...)
			end
		else
			if Fnp_TidyEnabled == true then
				actionUnitAddedFilterMode(...)
			else
				euiActionUnitAddedFilterMode(...)
			end
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED" then  -- Removed
		-- 关闭则直接return
		if Fnp_Enable == false then
			return
		end
		if Fnp_Mode == true then
			if Fnp_TidyEnabled == true then
				actionUnitRemovedOnlyShowMode(...)
			else
				euiActionUnitRemovedOnlyShowMode(...)
			end
		else
			if Fnp_TidyEnabled == true then
				actionUnitRemovedFilterMode(...)
			end
			-- euiActionUnitRemovedFilterMode(...)
		end
	elseif event == "NAME_PLATE_CREATED" then  -- Created
	elseif event == "PLAYER_ENTERING_WORLD" then
		registerMyEvents(self)
	end
end
