local addonName, DDT = ...

DDT.MessagePrefix = "|cff9d9d9d[" .. addonName .. "]|r "

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
    if percentLeft >= 80 then
        return "ff00ff00"
    end

    if percentLeft <= 50 then
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
