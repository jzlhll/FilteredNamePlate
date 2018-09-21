local BASE = CreateFrame("Frame", "AllanFnpBaseFrame", UIParent)
BASE:SetIgnoreParentScale(true)

function FilteredNamePlate:OneIconCreate(unitid, classType)
    local texture = BASE:CreateTexture("AllanCustIcon"..tostring(unitid), "OVERLAY")
    texture:SetTexture(136051) --TODO
    texture:SetSize(20, 20)
    return texture
end

function FilteredNamePlate:OneIconStatus(texture, nameplate, has)
    texture:ClearAllPoints()
    if nameplate and has then
        texture:Show()
        texture:SetPoint("BOTTOM", nameplate, "TOP", 0, 5)
    else
        texture:Hide()
    end
end


