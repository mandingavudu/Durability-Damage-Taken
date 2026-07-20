local addonName, DDT = ...

DDT.MessagePrefix = "|cff9d9d9d[" .. addonName .. "]|r "
DDT.GREEN_DURABILITY_THRESHOLD = 80
DDT.RED_DURABILITY_THRESHOLD = 50

local settings = _G.DurabilityDamageTakenDB or {}
_G.DurabilityDamageTakenDB = settings

if settings.majorWarningEnabled == nil then
    settings.majorWarningEnabled = true
end

if settings.followupMajorWarningEnabled == nil then
    settings.followupMajorWarningEnabled = true
end

if settings.portalMajorWarningEnabled == nil then
    settings.portalMajorWarningEnabled = true
end

function DDT.IsMajorWarningEnabled()
    return settings.majorWarningEnabled
end

function DDT.SetMajorWarningEnabled(enabled)
    settings.majorWarningEnabled = enabled
end

function DDT.IsFollowupMajorWarningEnabled()
    return settings.followupMajorWarningEnabled
end

function DDT.SetFollowupMajorWarningEnabled(enabled)
    settings.followupMajorWarningEnabled = enabled
end

function DDT.IsPortalMajorWarningEnabled()
    return settings.portalMajorWarningEnabled
end

function DDT.SetPortalMajorWarningEnabled(enabled)
    settings.portalMajorWarningEnabled = enabled
end

function DDT.GetEquippedDurabilityPercent()
    local currentTotal = 0
    local maximumTotal = 0

    for slotID = 1, 19 do
        local current, maximum = GetInventoryItemDurability(slotID)

        if current and maximum and maximum > 0 then
            currentTotal = currentTotal + current
            maximumTotal = maximumTotal + maximum
        end
    end

    if maximumTotal == 0 then
        return nil
    end

    return (currentTotal / maximumTotal) * 100
end

function DDT.GetDurabilityColor(percentLeft)
    if percentLeft >= DDT.GREEN_DURABILITY_THRESHOLD then
        return "ff00ff00"
    end

    if percentLeft <= DDT.RED_DURABILITY_THRESHOLD then
        return "ffff0000"
    end

    return "ffffff00"
end

function DDT.Print(message)
    DEFAULT_CHAT_FRAME:AddMessage(DDT.MessagePrefix .. message)
end

function DDT.FormatColoredDurability(percentLeft)
    return string.format("|c%s%.1f%%|r", DDT.GetDurabilityColor(percentLeft), percentLeft)
end

function DDT.PrintCurrentDurability(percentLeft)
    percentLeft = percentLeft or DDT.GetEquippedDurabilityPercent()

    if not percentLeft then
        DDT.Print(DDT.L.NO_DURABILITY)
        return
    end

    DDT.Print(string.format(DDT.L.CURRENT_DURABILITY, DDT.FormatColoredDurability(percentLeft)))
end
