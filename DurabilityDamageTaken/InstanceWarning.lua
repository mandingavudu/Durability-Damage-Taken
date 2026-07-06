local _, DDT = ...

local GREEN_DURABILITY_THRESHOLD = 80
local wasInTrackedInstance = false

local function IsInTrackedInstance()
    local inInstance = IsInInstance()
    local inDelve = C_PartyInfo
        and C_PartyInfo.IsPartyWalkIn
        and C_PartyInfo.IsPartyWalkIn()

    return inInstance or inDelve
end

local function WarnIfDurabilityIsLow()
    if not IsInTrackedInstance() then
        return
    end

    local percentLeft = DDT.GetEquippedDurabilityPercent()

    if not percentLeft or percentLeft >= GREEN_DURABILITY_THRESHOLD then
        return
    end

    local message = string.format("LOW DURABILITY: %.1f%%", percentLeft)
    RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo.RAID_WARNING)
    PlaySound(SOUNDKIT.RAID_WARNING, "Master")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_MAP_CHANGED")
frame:RegisterEvent("WALK_IN_DATA_UPDATE")

frame:SetScript("OnEvent", function()
    local inTrackedInstance = IsInTrackedInstance()

    if inTrackedInstance and not wasInTrackedInstance then
        C_Timer.After(2, WarnIfDurabilityIsLow)
    end

    wasInTrackedInstance = inTrackedInstance
end)
