--------------------------------------------
--  NAMESPACES                            --
--------------------------------------------

local _, PL_Core = ...

--------------------------------------------
--  COMMAND HANDLING                      --
--------------------------------------------

PL_Core.commands = {
    ["help"] = function()
        print(" ")
        PL_Core:Print("Commands List:")
        PL_Core:Print("/pl help - Displays the Help information")
        PL_Core:Print("/pl config - TODO")
    end
}

local function CommandsHandler(str)
    if (#str == 0) then
        -- User has input only /pl
        PL_Core.PortalList:Toggle()
        return
    end
end

--------------------------------------------
--  Portal List 2D Array                  --
--------------------------------------------

--PortalSpellID, TeleportSpellID, Destination, LevelRequiredPortal, LevelRequiredTeleport, Alliance/Horde/Both

local arrayPortals = {
    {281400, 281403, "Boralus", 111, 111, "Alliance"},
    {281402, 281404, "Dazar'Alor", 111, 111, "Horde"},
    {224871, 224869, "Dalaran - Broken Isles", 110, 105, "Both"},
    {176246, 176248, "Stormshield", 92, 92, "Alliance"},
    {176244, 176242, "Warspear", 92, 92, "Horde"},
    {132620, 132621, "Vale of Eternal Blossoms", 90, 90, "Alliance"},
    {132626, 132627, "Vale of Eternal Blossoms", 90, 90, "Horde"},
    {88345, 88342, "Tol Barad", 85, 85, "Alliance"},
    {88346, 88344, "Tol Barad", 85, 85, "Horde"},
    {120146, 120145, "Ancient: Dalaran", 90, 90, "Both"},
    {53142, 53140, "Dalaran - Northrend", 74, 71, "Both"},
    {33691, 33690, "Shattrath", 66, 62, "Alliance"},
    {35717, 35715, "Shattrath", 66, 62, "Horde"},
    --Classic Alliance
    {49360, 49359, "Theramore", 42, 17, "Alliance"},
    {32266, 32271, "Exodar", 42, 17, "Alliance"},
    {11419, 3565, "Darnassus", 42, 17, "Alliance"},
    {11416, 3562, "Ironforge", 42, 17, "Alliance"},
    {10059, 3561, "Stormwind", 42, 17, "Alliance"},
    --Classic Horde
    {49361, 49358, "Stonard", 52, 52, "Horde"},
    {11418, 3563, "Undercity", 42, 17, "Horde"},
    {11420, 3566, "Thunderbluff", 42, 17, "Horde"},
    {33267, 32272, "Silvermoon", 42, 17, "Horde"},
    {11417, 3567, "Orgrimmar", 42, 17, "Horde"}
}

function PL_Core:fetchArrayPortals()
    local storedArrayPortals = arrayPortals
    return storedArrayPortals
end

--------------------------------------------
--  REGISTERING SLASH COMMANDS            --
--------------------------------------------

function PL_Core:init(event, name) --
    --[[
    if (name ~= "PortalList") then return end
    SHASH_RELOADUI1 = "/rl"
    SlashCmdList.RELOADUI = ReloadUI;

    SLASH_FRAMESTK1 = "/fs"
    SlashCmdList.FRAMESTK = function()
        LoadAddOn("Blizzard_DebugTools")
        FrameStackTooltip_Toggle()
    end

    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
    end
]]
    SLASH_PortalList1 = "/pl"
    --SLASH_PortalList2 = "/prt"
    --SLASH_PortalList3 = "/portal"
    --SLASH_PortalList4 = "/portallist"
    SlashCmdList.PortalList = CommandsHandler
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", PL_Core.init)
