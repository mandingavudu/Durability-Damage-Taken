local _, DDT = ...

local pendingDeathLoss = false
local durabilityBeforeDeath
local deathCheckStartedAt
local lastKnownDurability
local lastReportTime = 0
local DEATH_CHECK_TIMEOUT_SECONDS = 15

local function PrintDurabilityLoss(percentLost, percentLeft)
    local message = string.format(
        "You lost |cffffffff%.1f%%|r durability from dying. Durability left: %s.",
        percentLost,
        DDT.FormatColoredDurability(percentLeft)
    )

    DDT.Print(message)
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

    if now - lastReportTime < 2 then
        return
    end

    pendingDeathLoss = false
    lastKnownDurability = durabilityAfterDeath
    lastReportTime = now

    PrintDurabilityLoss(percentLost, durabilityAfterDeath)
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
        C_Timer.After(1, TryReportDeathDurabilityLoss)
        return
    end

    if event == "UPDATE_INVENTORY_DURABILITY" then
        if pendingDeathLoss then
            C_Timer.After(0.5, TryReportDeathDurabilityLoss)
        else
            lastKnownDurability = DDT.GetEquippedDurabilityPercent()
        end

        return
    end

    if event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        C_Timer.After(0.5, TryReportDeathDurabilityLoss)
    end
end)
