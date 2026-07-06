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

local function SetFollowupMajorWarning(value)
    local enabled = value == "on"
    DDT.SetFollowupMajorWarningEnabled(enabled)
    DDT.Print("Follow-up major warnings " .. (enabled and "enabled." or "disabled."))
end

local function HandleSlashCommand(message)
    local command, option, value = message:lower():match("^(%S*)%s*(%S*)%s*(%S*)$")

    if command == "warning" and option == "followup" and (value == "on" or value == "off") then
        SetFollowupMajorWarning(value)
        return
    end

    if command == "warning" and (option == "on" or option == "off") and value == "" then
        SetMajorWarning(option)
        return
    end

    if command == "warning" then
        DDT.Print("Major warning is " .. (DDT.IsMajorWarningEnabled() and "enabled." or "disabled."))
        DDT.Print("Follow-up warnings are " .. (DDT.IsFollowupMajorWarningEnabled() and "enabled." or "disabled."))
        DDT.Print("Use /ddt warning on or /ddt warning off.")
        DDT.Print("Use /ddt warning followup on or /ddt warning followup off.")
        return
    end

    PrintCurrentDurability()
end

SLASH_DURABILITYDAMAGETAKEN1 = "/ddt"
SlashCmdList.DURABILITYDAMAGETAKEN = HandleSlashCommand
