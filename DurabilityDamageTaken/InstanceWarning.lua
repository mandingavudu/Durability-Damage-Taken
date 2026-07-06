local _, DDT = ...

local GREEN_DURABILITY_THRESHOLD = 80
local lastTrackedLocation

local function GetTrackedLocation()
    local inInstance = IsInInstance()
    local inDelve = C_PartyInfo
        and C_PartyInfo.IsPartyWalkIn
        and C_PartyInfo.IsPartyWalkIn()

    if not inInstance and not inDelve then
        return nil
    end

    if inInstance then
        local instanceID = select(8, GetInstanceInfo()) or 0
        return "instance:" .. tostring(instanceID)
    end

    local mapID = C_Map.GetBestMapForUnit("player") or 0
    return "delve:" .. tostring(mapID)
end

local function WarnIfDurabilityIsLow()
    local percentLeft = DDT.GetEquippedDurabilityPercent()

    if not percentLeft then
        return false
    end

    if percentLeft >= GREEN_DURABILITY_THRESHOLD then
        return true
    end

    local message = string.format("LOW DURABILITY: %.1f%%", percentLeft)
    RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo.RAID_WARNING)
    PlaySound(SOUNDKIT.RAID_WARNING, "Master")
    return true
end

local function CheckLocation()
    local location = GetTrackedLocation()

    if not location then
        lastTrackedLocation = nil
        return
    end

    if location == lastTrackedLocation then
        return
    end

    if WarnIfDurabilityIsLow() then
        lastTrackedLocation = location
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_MAP_CHANGED")
frame:RegisterEvent("WALK_IN_DATA_UPDATE")

frame:SetScript("OnEvent", function()
    CheckLocation()
    C_Timer.After(2, CheckLocation)
    C_Timer.After(5, CheckLocation)
end)
