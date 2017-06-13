SLASH_FilteredNamePlate1 = "/fnp";
DEBUG_LOG = true
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
--Fnp_Mode  仅显模式 true 过滤模式 false

function printInfo()
	print("-----------")
	print("\124cFFFF00FF[过滤姓名板]\124r")

	local isEnable = "不"
	if Fnp_Enable == true then
		isEnable = "是"
	end
	print("\124cFFFF00FF当前启用状态:\124r "..isEnable)	

	if Fnp_Mode ~= nil and Fnp_Mode == true then
		print("\124cFFFF00FF当前设置模式:\124r 仅显模式")
	else
		print("\124cFFFF00FF当前设置模式:\124r 过滤模式")
	end

	if Fnp_FNameList ~= nil and table.getn(Fnp_FNameList) > 0 then
		print("\124cFFFF00FF[设置的过滤列表]：\124r")
		print(table.concat(Fnp_FNameList, ";"))
	else
		print("\124cFFFF00FF[设置的过滤列表]\124r :空")
	end
	if Fnp_ONameList ~= nil and table.getn(Fnp_ONameList) > 0 then
		print("\124cFFFF00FF[设置的仅显列表]：\124r")
		print(table.concat(Fnp_ONameList, ";"))
	else
		print("\124cFFFF00FF[设置的仅显列表]\124r :空")
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
		Fnp_Mode = false
	end

	if AreaUnitList == nil then
		AreaUnitList = {}
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
	else
		FilteredNamePlate_Frame:Show()
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true);
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false);
		end
		if Fnp_Mode ~= nil and Fnp_Mode == true then
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(false);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(true);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(false);
		end
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
		print("如果设置不生效, 可以尝试, 按显示和隐藏敌方血条的快捷键, 快速让插件生效.")
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
	printInfo("a")
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
	printInfo("a")
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
	printInfo("a")
end

function ModeEditBoxWriten(mode, inputStr)
	if mode == "o" then
		Fnp_ONameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_ONameList, w) end )
	else
		Fnp_FNameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_FNameList, w) end )
	end
	printInfo("a")
end

function SlashCmdList.FilteredNamePlate(msg)
	local lastTarget = GetBindingKey("TARGETNEARESTENEMY");
	if msg == "" then
		print("\124cFFFF00FF[过滤姓名板]\124r")
		print("/fnp options 或者/fnp opt 打开菜单")
	elseif msg == "options" or msg == "opt" then
		ChangeFrameVisibility()
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

function printAreaUnitListDebug(Added)
	if Added then
		printLog("add-->")
	else
		printLog("remove-->")
	end
    local i = 0
    for key, var in ipairs(AreaUnitList) do
        i = i + 1
	    printLog(i..(", ")..var..(" name= ")..UnitName(var))
    end
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
		for key, var in ipairs(AreaUnitList) do
			local plate = GetNamePlateForUnit(var);
			plate:GetChildren():Show()
    	end
		IsCurrentAreaMatchedOnlyShow = false
	end
	--移除单位是不需要仅显的,而此时已经是仅显模式,说明杀了一个不是onlyShowList的怪. 所以不用处理 
end

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
			actionUnitAddedOnlyShowMode(...)
		else
			actionUnitAddedFilterMode(...)
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED" then  -- Removed
		-- 关闭则直接return
		if Fnp_Enable == false then
			return
		end
		if Fnp_Mode == true then
			actionUnitRemovedOnlyShowMode(...)
		else
			actionUnitRemovedFilterMode(...)
		end
	elseif event == "NAME_PLATE_CREATED" then  -- Created
	elseif event == "PLAYER_ENTERING_WORLD" then
		registerMyEvents(self)
	end
end
