local _, DDT = ...

local function PrintCurrentDurability()
    local percentLeft = DDT.GetEquippedDurabilityPercent()

    if not percentLeft then
        DDT.Print("No equipped items with durability found.")
        return
    end

    DDT.Print("Current durability: " .. DDT.FormatColoredDurability(percentLeft) .. ".")
end

local function SetMajorWarning(value)
    local enabled = value == "on"
    DDT.SetMajorWarningEnabled(enabled)
    DDT.Print("Major warning " .. (enabled and "enabled." or "disabled."))
end

local function HandleSlashCommand(message)
    local command, value = message:lower():match("^(%S*)%s*(%S*)$")

    if command == "warning" and (value == "on" or value == "off") then
        SetMajorWarning(value)
        return
    end

    if command == "warning" then
        DDT.Print("Major warning is " .. (DDT.IsMajorWarningEnabled() and "enabled." or "disabled."))
        DDT.Print("Use /ddt warning on or /ddt warning off.")
        return
    end

    PrintCurrentDurability()
end

SLASH_DURABILITYDAMAGETAKEN1 = "/ddt"
SlashCmdList.DURABILITYDAMAGETAKEN = HandleSlashCommand
