--------------------------------------------
--  NAMESPACES                            --
--------------------------------------------
local _, PL_Core = ...
PL_Core.PortalList = {}

local PortalList = PL_Core.PortalList
local PortalListFrame

--------------------------------------------
--  DEFAULTS                              --
--------------------------------------------
local defaults = {
    mainTheme = {
        r = 0.2,
        g = 0.85,
        b = 0.85,
        hex = "2cd9d9"
    }
}

--------------------------------------------
--  Portal List FUNCTIONS & SET-UP        --
--------------------------------------------
--Loads the interface when requested
function PortalList:Toggle()
    local menu = PortalListFrame or PortalList:CreateMenu()
    menu:SetShown(not menu:IsShown())
end

function PL_Core:GetColor()
    local colors = defaults.mainTheme
    return c.r, c.g, c.b, c.hex
end

--Sets up the Portal listing buttons
function PortalList:CreatePortalIcon(point, relativeFrame, relativePoint, yOffset, SpellID, portalLocName)
    local btn = CreateFrame("Button", "Button For: " .. portalLocName, relativeFrame, "SecureActionButtonTemplate")
    btn:SetPoint(point, relativeFrame, relativePoint, 5, yOffset)
    --btn:SetPoint("LEFT", "Button For: " .. GetSpellInfo(SpellID), )
    btn:SetSize(36, 36)
    btn:SetNormalTexture(GetSpellTexture(SpellID))

    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", SpellID)
    return btn
end

function PortalList:CreatePortalText(attach, portalLocName)
    local Port = PL_ListFrame:CreateFontString("$parentPort1", "OVERLAY", "InterUIBlack_large")
    Port:SetPoint("LEFT", attach, "RIGHT", 5, 0)
    Port:SetText(portalLocName)
end

--
--local fntPortList = PortalList:CreateFontString("Button For: ".. PortalList:NameFixer(SpellID), PortalListFrame)
--fntPortList:SetText("mememememememmememememememem")
--fntPortList:SetPoint(point, relativeFrame, relativePoint, 35, yOffset)
--

--function PortalList:CreatePortalText(point, relativeFrame, relativePoint, yOffset, portalLocName)
--    local fontInst = FontInstance:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
--    local fntPortList = PortalList:CreateFontString("Portal_Fonts", "ARTWORK", fontInst)
--    fntPortList:SetText(portalLocName)
--end

--Sets up the interface
function PortalList:CreateMenu()
    --Sets up the Frame
    PortalListFrame = CreateFrame("Frame", "PL_ListFrame", UIParent, "BasicFrameTemplate")
    PortalListFrame:SetSize(300, 390)
    PortalListFrame:SetFrameStrata("DIALOG")
    PortalListFrame:SetPoint("LEFT", UIParent, "CENTER", 200, 0)

    --Title Setup
    PortalListFrame.title = PortalListFrame:CreateFontString(nil, "OVERLAY")
    local fontLoadSucess = PortalListFrame.title:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
    if (not fontLoadSucess) then
        print("Failed to load Title Font!")
        PortalListFrame.title:SetFontObject("GameFontHighlight")
    end

    PortalListFrame.title:SetPoint("CENTER", PortalListFrame.TitleBg, "CENTER", 5, 0)
    PortalListFrame.title:SetText("Portal List")

    --Sets the window to moveable
    PortalListFrame:EnableMouse(true)
    PortalListFrame:SetMovable(true)
    PortalListFrame:RegisterForDrag("LeftButton")
    PortalListFrame:SetClampedToScreen(true)

    PortalListFrame:SetScript(
        "OnDragStart",
        function(self)
            self:StartMoving()
        end
    )

    PortalListFrame:SetScript(
        "OnDragStop",
        function(self)
            self:StopMovingOrSizing()
        end
    )

    --Sets the window's background to Black
    PortalListFrame.background = PortalListFrame:CreateTexture(nil, "BACKGROUND")
    PortalListFrame.background:SetAllPoints(PortalListFrame)
    PortalListFrame.background:SetColorTexture(0, 0, 0, 1)

    local portarray = PL_Core:fetchArrayPortals()

    local playerFaction = UnitFactionGroup("player")

    --TODO:
    --Find out how to make this into a fucking function later, otherwise this will be so fucking line inefficient, my god:

    if (portarray[1][6] == playerFaction or portarray[1][6] == "Both") then
        PortalListFrame.portal1 =
            PortalList:CreatePortalIcon("TOPLEFT", PortalListFrame, "TOPLEFT", -25, portarray[1][1], portarray[1][3])
        PortalListFrame.text1 = PortalList:CreatePortalText(PortalListFrame.portal1, portarray[1][3])
    end
    if (portarray[2][6] == playerFaction or portarray[2][6] == "Both") then
        PortalListFrame.portal2 =
            PortalList:CreatePortalIcon("TOPLEFT", PortalListFrame, "TOPLEFT", -25, portarray[2][1], portarray[2][3])
        PortalListFrame.text2 = PortalList:CreatePortalText(PortalListFrame.portal2, portarray[2][3])
    end
    if (portarray[3][6] == playerFaction or portarray[3][6] == "Both") then
        PortalListFrame.portal3 =
            PortalList:CreatePortalIcon("TOPLEFT", PortalListFrame, "TOPLEFT", -65, portarray[3][1], portarray[3][3])
        PortalListFrame.text3 = PortalList:CreatePortalText(PortalListFrame.portal3, portarray[3][3])
    end
    if (portarray[4][6] == playerFaction or portarray[4][6] == "Both") then
        PortalListFrame.portal4 =
            PortalList:CreatePortalIcon("TOPLEFT", PortalListFrame, "TOPLEFT", -105, portarray[4][1], portarray[4][3])
        PortalListFrame.text3 = PortalList:CreatePortalText(PortalListFrame.portal4, portarray[4][3])
    end
    if (portarray[5][6] == playerFaction or portarray[5][6] == "Both") then
        PortalListFrame.portal5 =
            PortalList:CreatePortalIcon("TOPLEFT", PortalListFrame, "TOPLEFT", -105, portarray[5][1], portarray[5][3])
        PortalListFrame.text5 = PortalList:CreatePortalText(PortalListFrame.portal5, portarray[5][3])
    end

    return PortalList
end

print("PortalList: Sucessful Init Load")

