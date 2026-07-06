local addonName = ...

local settings = _G.DurabilityDamageTakenDB
local category = Settings.RegisterVerticalLayoutCategory("Durability Damage Taken")

local majorWarningSetting = Settings.RegisterAddOnSetting(
    category,
    addonName .. "_MAJOR_WARNING",
    "majorWarningEnabled",
    settings,
    Settings.VarType.Boolean,
    "Enable major warning",
    Settings.Default.True
)
local majorWarningInitializer = Settings.CreateCheckbox(
    category,
    majorWarningSetting,
    "Show large text and play a sound when entering an instance or delve below 80% durability."
)

local followupWarningSetting = Settings.RegisterAddOnSetting(
    category,
    addonName .. "_FOLLOWUP_MAJOR_WARNING",
    "followupMajorWarningEnabled",
    settings,
    Settings.VarType.Boolean,
    "Warn after durability loss",
    Settings.Default.True
)
local followupWarningInitializer = Settings.CreateCheckbox(
    category,
    followupWarningSetting,
    "Also warn after durability loss below 50% inside an instance or delve."
)
followupWarningInitializer:Indent()
followupWarningInitializer:SetParentInitializer(majorWarningInitializer, function()
    return settings.majorWarningEnabled
end)

Settings.RegisterAddOnCategory(category)
