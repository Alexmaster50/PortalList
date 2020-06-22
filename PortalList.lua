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
    local btn = CreateFrame("Button", "Button For: " .. portalLocName, PL_ListFrame, "SecureActionButtonTemplate")
    btn:SetPoint(point, PL_ListFrame, relativePoint, 5, yOffset)
    --btn:SetPoint("LEFT", "Button For: " .. GetSpellInfo(SpellID), );
    btn:SetSize(36, 36)
    btn:SetNormalTexture(GetSpellTexture(SpellID))
    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", SpellID)

    return btn
end

function PortalList:CreatePortalText(attach, portalLocName)
    local Port =
        PL_ListFrame:CreateFontString(
        "$parentPortal_" .. string.gsub(string.sub(portalLocName, "1", "16"), " ", "_"),
        "OVERLAY",
        "InterUIBlack_large"
    )
    Port:SetPoint("LEFT", attach, "RIGHT", 5, 0)
    Port:SetText(portalLocName)
end

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

    --ScrollFrame
    PortalListFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, PortalListFrame, "UIPanelScrollFrameTemplate")
    PortalListFrame.ScrollFrame:SetPoint("TOPLEFT", PortalListFrame.Bg, "TOPLEFT", 2, -2)
    PortalListFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", PortalListFrame.Bg, "BOTTOMRIGHT", 0, 2)

    PortalListFrame.ScrollFrame.ScrollBar:ClearAllPoints()
    PortalListFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", PortalListFrame.ScrollFrame, "TOPRIGHT", -12, -18)
    PortalListFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", PortalListFrame.ScrollFrame, "BOTTOMRIGHT", -12, 16)

    local viewFrame = CreateFrame("Frame", "ViewingFrame", PortalListFrame.ScrollFrame)
    viewFrame:SetSize(300, 540)
    PortalListFrame.ScrollFrame:SetScrollChild(viewFrame)

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

    -- NOTE: Saving Reskinning for a later build.
    --Sets the window's background to Black
    --PortalListFrame.background = PortalListFrame:CreateTexture(nil, "BACKGROUND")
    --PortalListFrame.background:SetAllPoints(PortalListFrame)
    --PortalListFrame.background:SetColorTexture(0, 0, 0, 1)

    local portarray = PL_Core:fetchArrayPortals()

    local playerFaction = UnitFactionGroup("player")

    local portalPlacementYOfs = -25

    --PortalListFrame.portal = PortalList:CreatePortalIcon("TOPLEFT", viewFrame, "TOPLEFT", portalPlacementYOfs, portarray[1][1], portarray[1][3]);
    --PortalListFrame.text = PortalList:CreatePortalText(PortalListFrame.portal, portarray[1][3]);

    --Runs through all 23 portals, starts displaying the relevant ones to the player's faction
    for i = 1, 23 do
        if (portarray[i][6] == playerFaction or portarray[i][6] == "Both") then
            --print("testing - " .. i)

            PortalListFrame.portal =
                PortalList:CreatePortalIcon(
                "TOPLEFT",
                PortalListFrame,
                "TOPLEFT",
                portalPlacementYOfs,
                portarray[i][1],
                portarray[i][3]
            )
            PortalListFrame.text = PortalList:CreatePortalText(PortalListFrame.portal, portarray[i][3])

            portalPlacementYOfs = portalPlacementYOfs - 40
        end
    end

    return PortalList
end

--Debug: Posts when the load was sucessful.
print("PortalList: Sucessful Init Load")
