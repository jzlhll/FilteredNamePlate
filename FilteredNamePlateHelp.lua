function FilteredNamePlate.printCurrentScaleList(cl, col, flag)
    if flag ~= 0 then
        print("CurrentList = {")
        print("SYSTEM = "..cl.SYSTEM..", normal = "..cl.normal..", small = "..cl.small..", mid = "..cl.middle)
        print("}")
        return
    end
    print("CurrentOrigList = {")
	print("name = {")
    print("SYSTEM = "..col.name.SYSTEM..", normal = "..col.name.normal..", small = "..col.name.small..", mid = "..col.name.middle)
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
    print("Saved normal "..sl.normal..(" small ")..sl.small)
end

function FilteredNamePlate.printTable(table , level, key)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end
  if key and key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
		print("key>>"..key)
        -- FilteredNamePlate.printTable(v, level + 1, key)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)
      end
  end
  print(indent .. "}")
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
