local _, DDT = ...

local pendingDeathLoss = false
local durabilityBeforeDeath
local deathCheckStartedAt
local lastKnownDurability
local DEATH_CHECK_TIMEOUT_SECONDS = 15

local function PrintDurabilityLoss(percentLost, percentLeft)
    local message = string.format(
        "You lost |cffffffff%.1f%%|r durability. Durability left: %s.",
        percentLost,
        DDT.FormatColoredDurability(percentLeft)
    )

    DDT.Print(message)
end

local function ShowCriticalWarningIfNeeded(percentLeft)
    if DDT.IsFollowupMajorWarningEnabled()
        and percentLeft < DDT.RED_DURABILITY_THRESHOLD
        and DDT.IsInTrackedInstance()
    then
        DDT.WarnIfDurabilityIsLow()
    end
end

local function TryReportDeathDurabilityLoss()
    if not pendingDeathLoss or not durabilityBeforeDeath then
        return
    end

    local durabilityAfterDeath = DDT.GetEquippedDurabilityPercent()

    if not durabilityAfterDeath then
        return
    end

    local now = GetTime()

    if deathCheckStartedAt and now - deathCheckStartedAt > DEATH_CHECK_TIMEOUT_SECONDS then
        pendingDeathLoss = false
        lastKnownDurability = durabilityAfterDeath
        return
    end

    local percentLost = durabilityBeforeDeath - durabilityAfterDeath

    if percentLost <= 0 then
        return
    end

    pendingDeathLoss = false
    lastKnownDurability = durabilityAfterDeath

    PrintDurabilityLoss(percentLost, durabilityAfterDeath)
    ShowCriticalWarningIfNeeded(durabilityAfterDeath)
end

local function ScheduleDeathCheck(delay)
    C_Timer.After(delay, function()
        TryReportDeathDurabilityLoss()
    end)
end

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        lastKnownDurability = DDT.GetEquippedDurabilityPercent()
        return
    end

    if event == "PLAYER_DEAD" then
        durabilityBeforeDeath = lastKnownDurability or DDT.GetEquippedDurabilityPercent()
        pendingDeathLoss = durabilityBeforeDeath ~= nil
        deathCheckStartedAt = GetTime()
        ScheduleDeathCheck(1)
        ScheduleDeathCheck(3)
        ScheduleDeathCheck(6)
        ScheduleDeathCheck(16)
        return
    end

    if event == "UPDATE_INVENTORY_DURABILITY" then
        if pendingDeathLoss then
            ScheduleDeathCheck(0.5)
        else
            local previousDurability = lastKnownDurability
            local currentDurability = DDT.GetEquippedDurabilityPercent()

            lastKnownDurability = currentDurability

            if previousDurability
                and currentDurability
                and currentDurability < previousDurability
                and not UnitAffectingCombat("player")
            then
                PrintDurabilityLoss(previousDurability - currentDurability, currentDurability)
                ShowCriticalWarningIfNeeded(currentDurability)
            end
        end

        return
    end

    if event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        ScheduleDeathCheck(0.5)
        ScheduleDeathCheck(2)
        ScheduleDeathCheck(5)
    end
end)
