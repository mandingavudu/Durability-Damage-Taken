local _, DDT = ...

local lastTrackedLocation
local warningSequence = 0

local SEASONAL_DUNGEON_PORTAL_SPELLS = {
    [159898] = true,  -- Skyreach
    [393273] = true,  -- Algeth'ar Academy
    [1254400] = true, -- Windrunner Spire
    [1254551] = true, -- Seat of the Triumvirate
    [1254555] = true, -- Pit of Saron
    [1254559] = true, -- Maisara Caverns
    [1254563] = true, -- Nexus-Point Xenas
    [1254572] = true, -- Magisters' Terrace
}

local warningFrame = CreateFrame("Frame", nil, UIParent)
warningFrame:SetAllPoints(UIParent)
warningFrame:Hide()

local warningText = warningFrame:CreateFontString(nil, "OVERLAY")
local fontPath, fontSize, fontFlags = GameFontNormalHuge:GetFont()
warningText:SetFont(fontPath, fontSize * 3, fontFlags)
warningText:SetPoint("TOP", UIParent, "TOP", 0, -360)
warningText:SetTextColor(1, 0.1, 0.1)
warningText:SetShadowColor(0, 0, 0, 1)
warningText:SetShadowOffset(3, -3)

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

    return "delve"
end

function DDT.IsInTrackedInstance()
    return GetTrackedLocation() ~= nil
end

function DDT.WarnIfDurabilityIsLow()
    if not DDT.IsMajorWarningEnabled() then
        return true
    end

    local percentLeft = DDT.GetEquippedDurabilityPercent()

    if not percentLeft then
        return false
    end

    if percentLeft >= DDT.GREEN_DURABILITY_THRESHOLD then
        return true
    end

    local message = string.format(DDT.L.LOW_DURABILITY, percentLeft)
    DDT.PrintCurrentDurability(percentLeft)
    warningSequence = warningSequence + 1
    local sequence = warningSequence

    C_Timer.After(1, function()
        if sequence ~= warningSequence then
            return
        end

        warningText:SetText(message)
        warningFrame:Show()
        PlaySound(SOUNDKIT.RAID_WARNING, "Master")

        C_Timer.After(5, function()
            if sequence == warningSequence then
                warningFrame:Hide()
            end
        end)
    end)
    return true
end

local function CheckLocation(allowDelveEntry)
    local location = GetTrackedLocation()

    if not location then
        lastTrackedLocation = nil
        return
    end

    if location == lastTrackedLocation then
        return
    end

    if location == "delve" and not allowDelveEntry then
        return
    end

    if DDT.WarnIfDurabilityIsLow() then
        lastTrackedLocation = location
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_MAP_CHANGED")
frame:RegisterEvent("WALK_IN_DATA_UPDATE")
frame:RegisterEvent("UNIT_SPELLCAST_START")

frame:SetScript("OnEvent", function(_, event, ...)
    if event == "UNIT_SPELLCAST_START" then
        local unit, _, spellID = ...

        if unit == "player"
            and SEASONAL_DUNGEON_PORTAL_SPELLS[spellID]
            and DDT.IsPortalMajorWarningEnabled()
        then
            DDT.WarnIfDurabilityIsLow()
        end
        return
    end

    if event == "WALK_IN_DATA_UPDATE" then
        C_Timer.After(1, function()
            CheckLocation(true)
        end)
        return
    end

    CheckLocation(false)
    C_Timer.After(2, function()
        CheckLocation(false)
    end)
    C_Timer.After(5, function()
        CheckLocation(false)
    end)
end)
