SLASH_FilteredNamePlate1 = "/fnp";
DEBUG_LOG = true
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

function printInfo()
	print("-----------")
	print("\124cFFFF00FF插件： [ 仅显示过滤姓名板 /fnp ]\124r")

	local isEnable = "不"
	if Fnp_Enable == true then
		isEnable = "是"
	end
	print("\124cFFFF00FF当前启用状态:\124r "..isEnable)	

	if Fnp_Reverse ~= nil and Fnp_Reverse == true then
		print("\124cFFFF00FF当前设置模式:\124r （仅设置的名字列表不显示）")
	else
		print("\124cFFFF00FF当前设置模式:\124r （仅显示设置的名字列表）")
	end

	if Fnp_NameList ~= nil then
		print("\124cFFFF00FF[设置的名字列表]：\124r")
		local i = 0
		for key, var in ipairs(Fnp_NameList) do
			i = i + 1
			print(""..i..", "..var)
		end
	else
		print("\124cFFFF00FF[设置的名字列表]\124r :空")
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
	if Fnp_Reverse == nil then
		Fnp_Reverse = false
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

function FilteredNamePlate_OnLoad(self)
	IS_REGISGER = false
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	-- self:RegisterEvent("CHALLENGE_MODE_START")
	-- self:RegisterEvent("CHALLENGE_MODE_RESET")
end



function SlashCmdList.FilteredNamePlate(msg)
	local lastTarget = GetBindingKey("TARGETNEARESTENEMY");
	if msg == "" then
		print("------")
		print("\124cFFFF00FF/fnp enable1\124r  开启功能（仅显示设置的名字列表）")
		print("\124cFFFF00FF/fnp enable2\124r  开启功能（仅设置的名字列表不显示）")
		print("\124cFFFF00FF/fnp disable\124r  关闭功能")
		print("\124cFFFF00FF/fnp names=AAA;BBB;CCC\124r     请注意等号前后没有空格;分号是英文符号;不断的追加分号和额外的名字即可")
		print("\124cFFFF00FF/fnp clearns\124r  清理名字列表")
		print("------")
		printInfo("a")
	elseif msg == "enable1" then
		Fnp_Enable = true
		Fnp_Reverse = false
		printInfo()
		print("\124cFFFF00FF变动生效，需要按下关闭和显示敌对快捷键即可出现！\124r")
	elseif msg == "enable2" then
		Fnp_Enable = true
		Fnp_Reverse = true
		printInfo()
		print("\124cFFFF00FF变动生效，需要按下关闭和显示敌对快捷键即可出现！\124r")
	elseif msg == "disable" then
		Fnp_Enable = false
		printInfo()
		print("\124cFFFF00FF变动生效，需要按下关闭和显示敌对快捷键即可出现！\124r")
	elseif msg == "clearns" then
		Fnp_NameList = {}
		printInfo("a")
		print("\124cFFFF00FF变动生效，需要按下关闭和显示敌对快捷键即可出现！\124r")
	else
		local _, num = string.find(msg, 'names=')
		if num == 6 then
			local str = string.gsub(msg, "names=", "") 
			Fnp_NameList = {}  
			string.gsub(str, '[^;]+', function(w) table.insert(Fnp_NameList, w) end )
		end
		printInfo("a")
		print(" ")
		print("\124cFFFF00FF变动生效，需要按下关闭和显示敌对快捷键即可出现！\124r")
		print("如果不正确，请重新设置。实在不行，可以/fnp clearns 清理。")
	end
end

function isMatchMyNameList(tName)
	if Fnp_Enable == false then
		return false
	end

	local isMatch = false
	for key, var in ipairs(Fnp_NameList) do
		local _, ret = string.find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

function FilteredNamePlate_OnEvent(self,event,...)
	if event == "CHALLENGE_MODE_COMPLETED" then
		Fnp_Enable = false
		unRegisterMyEvents(self)
		printInfo()
	elseif event == "CHALLENGE_MODE_START" or event == "CHALLENGE_MODE_RESET" then
		Fnp_Enable = true
		printInfo()
	elseif event == "PLAYER_ENTERING_WORLD" then
		printInfo()
		registerMyEvents(self)
	elseif event == "NAME_PLATE_UNIT_ADDED" then  -- Added
		local unitid = ...
		-- Personal Display
		local name = UnitName(unitid)
		-- printLog("NAME_PLATE_UNIT_ADDED"..name)
		local matched = isMatchMyNameList(name)
		if Fnp_Reverse ~= nil and Fnp_Reverse == true then -- 都显示，除了不显示列表中
			-- printLog("aaaaaaaa")
			if matched == true then
				-- printLog("bbbbbbbb")
				local plate = GetNamePlateForUnit(unitid);
				plate:GetChildren():Hide()
			end
		else  -- 默认模式，只显示过滤名单
			-- printLog("ccccc")
			if matched == false then
				-- printLog("ddddd")
				local plate = GetNamePlateForUnit(unitid);
				plate:GetChildren():Hide()
			end
		end

	elseif event == "NAME_PLATE_UNIT_REMOVED" then  -- Removed
		--printLog("NAME_PLATE_UNIT_REMOVED")
	elseif event == "NAME_PLATE_CREATED" then  -- Created
		--printLog("NAME_PLATE_CREATED")
	end
end
