--大米成就
function FilteredNamePlate:CallBMChallengesShow()
    local crits, numCrits = {}, GetAchievementNumCriteria(13079)
    table.wipe(crits)
    local ar10 = select(4, GetAchievementInfo(13079))
    local ar15 = select(4, GetAchievementInfo(13080))
    print(">>>>FNP成就>>>>>")
    for i=1, numCrits do
        local name, _, _, complete = GetAchievementCriteriaInfo(13080, i==10 and 11 or i)
        if complete == 1 then
            print(tostring(i)..". "..tostring(name).." 限时15层！")
        else
            name, _, _, complete = GetAchievementCriteriaInfo(13079, i)
            if complete == 1 then
                print(tostring(i)..". "..tostring(name).." 限时10层！")
            else
                print(tostring(i)..". "..tostring(name).." 10层都没打限时！")
            end
        end
    end
end