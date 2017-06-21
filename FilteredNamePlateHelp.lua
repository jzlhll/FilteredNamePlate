function FilteredNamePlate.printCurrentScaleList(cl, col)
    print("CurrentList = {")
    print("SYSTEM = "..cl.SYSTEM..", normal = "..cl.normal..", small = "..cl.small..", mid = "..cl.middle)
    print("}")
    print("CurrentOrigList = { name = {")
    print("SYSTEM = "..col.SYSTEM..", normal = "..col.normal..", small = "..col.small..", mid = "..col.middle)
    print("}")
    print(", castbar = {")
    print("SYSTEM = "..col.castbar.SYSTEM..", normal = "..col.castbar.normal..", small = "..col.castbar.small..", mid = "..col.castbar.middle)
    print(", SYS_SL = "..col.castbar.SYSTEM_SCALE..", normalSl = "
            ..col.castbar.normalScale..", smallSl = "..col.castbar.smallScale..", midSl = "..col.castbar.middleScale)
    print("}")
    print(", healthbar = {")
    print("SYSTEM = "..col.healthbar.SYSTEM..", normal = "..col.healthbar.normal..", small = "..col.healthbar.small..", mid = "..col.healthbar.middle)
    print(", SYS_SL = "..col.healthbar.SYSTEM_SCALE..", normalSl = "
            ..col.healthbar.normalScale..", smallSl = "..col.healthbar.smallScale..", midSl = "..col.healthbar.middleScale)
    print("}")
end

function FilteredNamePlate.printSavedScaleList(sl)
    print("Saved other "..sl.other..(" only ")..sl.only..(" normal ")..sl.normal)
end

function FilteredNamePlate.printATab(atab, extStr)
	local str = ""
    for pos, name in ipairs(atab) do
        str = str..pos..(" ")..name..(", ")
    end
	print(extStr..str)
end

function FilteredNamePlate.getTableCount(atab)
	local count = 0
    for pos, name in ipairs(atab) do
        count = count + 1
    end
	return count
end

function FilteredNamePlate.insertATabValue(tab, value)
    local isExist = false;
    for pos, name in ipairs(tab) do
        if (name == value) then
            isExist = true;
        end
    end
    if not isExist then table.insert(tab, value) end;
end

function FilteredNamePlate.removeATabValue(tab, value)
    for pos, name in ipairs(tab) do
        if (name == value) then
            table.remove(tab, pos)
        end
    end
end