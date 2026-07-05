local _, DDT = ...

local function PrintCurrentDurability()
    local percentLeft = DDT.GetEquippedDurabilityPercent()

    if not percentLeft then
        DDT.Print("No equipped items with durability found.")
        return
    end

    DDT.Print("Current durability: " .. DDT.FormatColoredDurability(percentLeft) .. ".")
end

SLASH_DURABILITYDAMAGETAKEN1 = "/ddt"
SlashCmdList.DURABILITYDAMAGETAKEN = PrintCurrentDurability
