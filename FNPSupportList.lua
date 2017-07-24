local _
local _G = _G

FilteredNamePlate.UITypeCheckList = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
	[6] = false,
	[7] = false,
	[8] = false,
}

FilteredNamePlate.UITypeList = {
	[0] = FNP_LOCALE_TEXT.FNP_ORIG_TITLE,
	[1] = FNP_LOCALE_TEXT.FNP_ORIG_TITLE2,
	[2] = "TidyPlates",
	[3] = "Kui_NamePlates",
	[4] = "EUI/RayUI",
	[5] = "NDUI",
	[6] = FNP_LOCALE_TEXT.FNP_EKNUM_TITLE,
	[7] = "ShestackUI",
	[8] = "CblUI",
}

function FilteredNamePlate.GenCurNpFlags()
	local curNpFlag = 0 -- 上述UIType的下标
	if Fnp_OtherNPFlag == 0 or Fnp_OtherNPFlag == 1 then
		curNpFlag = 0
	elseif Fnp_OtherNPFlag == 6 then
		curNpFlag = 2
	elseif Fnp_OtherNPFlag == 7 then
		curNpFlag = 3
	elseif Fnp_OtherNPFlag == 8 then
		curNpFlag = 4
	else -- 最简模型
		curNpFlag = 1
	end
	--print("curNp"..curNpFlag.." FnpOther "..Fnp_OtherNPFlag)
	local curNpFlag1Type = "UnitFrame" --针对最简单模型的frameName
	if flag == 2 then
		curNpFlag1Type = "carrier"
	elseif flag == 3 then
		curNpFlag1Type = "kui"
	elseif flag == 4 or flag == 8 then
		curNpFlag1Type = "UnitFrame"
	elseif flag == 5 then
		curNpFlag1Type = "unitFrame"
	end
	return curNpFlag, curNpFlag1Type
end

function FilteredNamePlate.InitSavedScaleList()
    if Fnp_SavedScaleList == nil then
        Fnp_SavedScaleList = {
            normal = 1,
            small = 0.25,
            only = 1.4,
        }
    else -- V4 update to V5
        if Fnp_SavedScaleList.only == nil then Fnp_SavedScaleList.only = 1.4 end
    end
end

function FilteredNamePlate.ChangedSavedScaleList(flag)
     Fnp_SavedScaleList.only = 1.4
     Fnp_SavedScaleList.small = 0.25
     --配置不同UI下 small的默认比例
     if flag == 7 then
        Fnp_SavedScaleList.small = 0.5
        Fnp_SavedScaleList.only = 1.2
     elseif flag == 8 then
		Fnp_SavedScaleList.small = 0.2
		Fnp_SavedScaleList.only = 1.35
 	 end
end
