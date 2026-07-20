local _, DDT = ...

local function PrintCurrentDurability()
    DDT.PrintCurrentDurability()
end

local function SetMajorWarning(value)
    local enabled = value == "on"
    DDT.SetMajorWarningEnabled(enabled)
    DDT.Print(string.format(DDT.L.MAJOR_WARNING_CHANGED, enabled and DDT.L.ENABLED or DDT.L.DISABLED))
end

local function SetFollowupMajorWarning(value)
    local enabled = value == "on"
    DDT.SetFollowupMajorWarningEnabled(enabled)
    DDT.Print(string.format(DDT.L.FOLLOWUP_WARNING_CHANGED, enabled and DDT.L.ENABLED_PLURAL or DDT.L.DISABLED_PLURAL))
end

local function SetPortalMajorWarning(value)
    local enabled = value == "on"
    DDT.SetPortalMajorWarningEnabled(enabled)
    DDT.Print(string.format(DDT.L.PORTAL_WARNING_CHANGED, enabled and DDT.L.ENABLED_PLURAL or DDT.L.DISABLED_PLURAL))
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
        local enabled = DDT.L.ENABLED
        local disabled = DDT.L.DISABLED
        local enabledPlural = DDT.L.ENABLED_PLURAL
        local disabledPlural = DDT.L.DISABLED_PLURAL

        DDT.Print(string.format(DDT.L.MAJOR_WARNING_STATUS, DDT.IsMajorWarningEnabled() and enabled or disabled))
        DDT.Print(string.format(DDT.L.FOLLOWUP_WARNING_STATUS, DDT.IsFollowupMajorWarningEnabled() and enabledPlural or disabledPlural))
        DDT.Print(string.format(DDT.L.PORTAL_WARNING_STATUS, DDT.IsPortalMajorWarningEnabled() and enabledPlural or disabledPlural))
        DDT.Print(DDT.L.HELP_WARNING)
        DDT.Print(DDT.L.HELP_FOLLOWUP)
        DDT.Print(DDT.L.HELP_PORTAL)
        return
    end

    PrintCurrentDurability()
end

SLASH_DURABILITYDAMAGETAKEN1 = "/ddt"
SlashCmdList.DURABILITYDAMAGETAKEN = HandleSlashCommand
