local addonName, DDT = ...

local settings = _G.DurabilityDamageTakenDB
local category = Settings.RegisterVerticalLayoutCategory("Durability Damage Taken")

local majorWarningSetting = Settings.RegisterAddOnSetting(
    category,
    addonName .. "_MAJOR_WARNING",
    "majorWarningEnabled",
    settings,
    Settings.VarType.Boolean,
    DDT.L.OPTIONS_MAJOR,
    Settings.Default.True
)
local majorWarningInitializer = Settings.CreateCheckbox(
    category,
    majorWarningSetting,
    DDT.L.OPTIONS_MAJOR_TOOLTIP
)

local portalWarningSetting = Settings.RegisterAddOnSetting(
    category,
    addonName .. "_PORTAL_MAJOR_WARNING",
    "portalMajorWarningEnabled",
    settings,
    Settings.VarType.Boolean,
    DDT.L.OPTIONS_PORTAL,
    Settings.Default.True
)
local portalWarningInitializer = Settings.CreateCheckbox(
    category,
    portalWarningSetting,
    DDT.L.OPTIONS_PORTAL_TOOLTIP
)
portalWarningInitializer:Indent()
portalWarningInitializer:SetParentInitializer(majorWarningInitializer, function()
    return settings.majorWarningEnabled
end)

local followupWarningSetting = Settings.RegisterAddOnSetting(
    category,
    addonName .. "_FOLLOWUP_MAJOR_WARNING",
    "followupMajorWarningEnabled",
    settings,
    Settings.VarType.Boolean,
    DDT.L.OPTIONS_FOLLOWUP,
    Settings.Default.True
)
local followupWarningInitializer = Settings.CreateCheckbox(
    category,
    followupWarningSetting,
    DDT.L.OPTIONS_FOLLOWUP_TOOLTIP
)
followupWarningInitializer:Indent()
followupWarningInitializer:SetParentInitializer(majorWarningInitializer, function()
    return settings.majorWarningEnabled
end)

Settings.RegisterAddOnCategory(category)
