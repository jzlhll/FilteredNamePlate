--大米成就
local L = _G.FNP_LOCALE_TEXT
local FilteredNamePlate = _G.FilteredNamePlate

function FilteredNamePlate:CallBMChallengesShow()
    local crits, numCrits = {}, GetAchievementNumCriteria(13079)
    table.wipe(crits)
    local ar10 = select(4, GetAchievementInfo(13079))
    local ar15 = select(4, GetAchievementInfo(13080))
    print(">>>>FNP成就>>>>>")
    for i=1, numCrits do
        local name, _, _, complete = GetAchievementCriteriaInfo(13080, i==10 and 11 or i)
        if complete == 1 then
            print(tostring(i)..". "..tostring(name)..L.ACHIEVER_15_OK)
        else
            name, _, _, complete = GetAchievementCriteriaInfo(13079, i)
            if complete == 1 then
                print(tostring(i)..". "..tostring(name)..L.ACHIEVER_10_OK)
            else
                print(tostring(i)..". "..tostring(name)..L.ACHIEVER_10_NOT_OK)
            end
        end
    end
end