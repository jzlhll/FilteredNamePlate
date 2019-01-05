--大米成就
function FilteredNamePlate:CallBMChallengesChanged()
    if not FnpEnableKeys["BMChallengesEnable"] then
        FnpEnableKeys["BMChallengesEnable"] = true
    else
        FnpEnableKeys["BMChallengesEnable"] = false
    end
end

function FilteredNamePlate:CallBMChallenges()
    if not FnpEnableKeys["BMChallengesEnable"] then
        return
    end

    CoreDependCall("Blizzard_ChallengesUI", function()
        local crits, numCrits = {}, GetAchievementNumCriteria(13079)
        hooksecurefunc("ChallengesFrame_Update", function(self)
            table.wipe(crits)
            local ar10 = select(4, GetAchievementInfo(13079))
            local ar15 = select(4, GetAchievementInfo(13080))
            for i=1, numCrits do
                local name, _, _, complete = GetAchievementCriteriaInfo(13080, i==10 and 11 or i)
                if complete == 1 then
                    crits[name] = 15
                else
                    name, _, _, complete = GetAchievementCriteriaInfo(13079, i)
                    if complete == 1 then crits[name] = 10 end
                end
            end

            for i, icon in pairs(ChallengesFrame.DungeonIcons) do
                local name = C_ChallengeMode.GetMapUIInfo(icon.mapID)
                if not icon.tex then
                    WW(icon):CreateTexture():SetSize(22,22):BOTTOM(0, 20):Key("tex"):up():un()
                    SetOrHookScript(icon, "OnEnter", function()
                        GameTooltip_AddBlankLineToTooltip(GameTooltip);
                        GameTooltip:AddLine("Fnp提示：")
                        GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:575:607:205:237\124t 已限时10层")
                        GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:575:607:239:271\124t 已限时15层")
                        GameTooltip:Show()
                    end)
                end
                icon.tex:Show()
                if ar15 or crits[name] == 15 then
                    icon.tex:SetAtlas("VignetteKillElite")
                elseif ar10 or crits[name] == 10 then
                    icon.tex:SetAtlas("VignetteKill")
                else
                    icon.tex:Hide()
                end
            end
        end)
    end)

end