local _, DDT = ...

local function PrintCurrentDurability()
    DDT.PrintCurrentDurability()
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

local function SetPortalMajorWarning(value)
    local enabled = value == "on"
    DDT.SetPortalMajorWarningEnabled(enabled)
    DDT.Print("Seasonal dungeon portal warnings " .. (enabled and "enabled." or "disabled."))
end

local function HandleSlashCommand(message)
    local command, option, value = message:lower():match("^(%S*)%s*(%S*)%s*(%S*)$")

    if command == "warning" and option == "followup" and (value == "on" or value == "off") then
        SetFollowupMajorWarning(value)
        return
    end

    if command == "warning" and option == "portal" and (value == "on" or value == "off") then
        SetPortalMajorWarning(value)
        return
    end

    if command == "warning" and (option == "on" or option == "off") and value == "" then
        SetMajorWarning(option)
        return
    end

    if command == "warning" then
        local portalStatus = DDT.IsPortalMajorWarningEnabled() and "enabled." or "disabled."

        DDT.Print("Major warning is " .. (DDT.IsMajorWarningEnabled() and "enabled." or "disabled."))
        DDT.Print("Follow-up warnings are " .. (DDT.IsFollowupMajorWarningEnabled() and "enabled." or "disabled."))
        DDT.Print("Seasonal dungeon portal warnings are " .. portalStatus)
        DDT.Print("Use /ddt warning on or /ddt warning off.")
        DDT.Print("Use /ddt warning followup on or /ddt warning followup off.")
        DDT.Print("Use /ddt warning portal on or /ddt warning portal off.")
        return
    end

    PrintCurrentDurability()
end

SLASH_DURABILITYDAMAGETAKEN1 = "/ddt"
SlashCmdList.DURABILITYDAMAGETAKEN = HandleSlashCommand
