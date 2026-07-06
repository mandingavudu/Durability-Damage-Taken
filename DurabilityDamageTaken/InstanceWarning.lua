local _, DDT = ...

local GREEN_DURABILITY_THRESHOLD = 80
local wasInInstance = false

local function WarnIfDurabilityIsLow()
    local inInstance = IsInInstance()

    if not inInstance then
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

frame:SetScript("OnEvent", function()
    local inInstance = IsInInstance()

    if inInstance and not wasInInstance then
        C_Timer.After(2, WarnIfDurabilityIsLow)
    end

    wasInInstance = inInstance
end)
