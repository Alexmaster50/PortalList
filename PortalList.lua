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
    --btn:SetPoint("LEFT", "Button For: " .. GetSpellInfo(SpellID), );
    btn:SetSize(36, 36)
    btn:SetNormalTexture(GetSpellTexture(SpellID))
    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", SpellID)

    return btn
end

function PortalList:CreatePortalText(attach, portalLocName)
    local Port =
        PL_ListFrame_ScrollingFrame_ViewerFrame:CreateFontString(
        "$parentPortal_" .. string.gsub(string.sub(portalLocName, "1", "16"), " ", "_"),
        self.portal,
        "InterUIBlack_large"
    )
    Port:SetPoint("LEFT", PL_ListFrame_ScrollingFrame_ViewerFrame.portal, "RIGHT", 5, 0)
    Port:SetText(portalLocName)
end

--Sets scrolling to be in much smaller increments
local function ScrollFrame_OnMouseWheel(self, delta)
    local newScrollValue = self:GetVerticalScroll() - (delta * 20)

    if (newScrollValue < 0) then
        newScrollValue = 0
    elseif (newScrollValue > self:GetVerticalScrollRange()) then
        newScrollValue = self:GetVerticalScrollRange()
    end
    self:SetVerticalScroll(newScrollValue)
end

--Sets up the interface
function PortalList:CreateMenu()
    --Sets up the Frame
    PortalListFrame = CreateFrame("Frame", "PL_ListFrame", UIParent, "BasicFrameTemplate")
    --PortalListFrame = CreateFrame("Frame", "PL_ListFrame", UIParent, "UIPanelDialogTemplate")
    PortalListFrame:SetSize(300, 390)
    PortalListFrame:SetFrameStrata("DIALOG")
    PortalListFrame:SetPoint("LEFT", UIParent, "CENTER", -800, 250)

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
    PortalListFrame.ScrollFrame =
        CreateFrame("ScrollFrame", "$parent_ScrollingFrame", PortalListFrame, "UIPanelScrollFrameTemplate")
    PortalListFrame.ScrollFrame:SetPoint("TOPLEFT", PortalListFrame, "TOPLEFT", 2, -20)
    PortalListFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", PortalListFrame, "BOTTOMRIGHT", -2, 2)
    PortalListFrame.ScrollFrame:SetClipsChildren(true)

    local viewFrame = CreateFrame("Frame", "$parent_ViewerFrame", PortalListFrame.ScrollFrame)
    viewFrame:SetSize(300, 525)

    -- DEBUG: To see where the Rendering Frame is
    --viewFrame.bg = viewFrame:CreateTexture(nil, "BACKGROUND")
    --viewFrame.bg:SetAllPoints(true)
    --viewFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.8)
    print("attempting script")
    PortalListFrame.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
    print("script success")
    PortalListFrame.ScrollFrame:SetScrollChild(viewFrame)

    PortalListFrame.ScrollFrame.ScrollBar:ClearAllPoints()
    PortalListFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", PortalListFrame.ScrollFrame, "TOPRIGHT", -12, -18)
    PortalListFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", PortalListFrame.ScrollFrame, "BOTTOMRIGHT", -12, 16)

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

    local portalPlacementYOfs = -5

    --PortalListFrame.portal = PortalList:CreatePortalIcon("TOPLEFT", viewFrame, "TOPLEFT", portalPlacementYOfs, portarray[1][1], portarray[1][3]);
    --PortalListFrame.text = PortalList:CreatePortalText(PortalListFrame.portal, portarray[1][3]);

    --Runs through all 23 portals, starts displaying the relevant ones to the player's faction
    for i = 1, 23 do
        if (portarray[i][6] == playerFaction or portarray[i][6] == "Both") then
            --print("testing - " .. i)
            PL_ListFrame_ScrollingFrame_ViewerFrame.portal =
                PortalList:CreatePortalIcon(
                "TOPLEFT",
                PL_ListFrame_ScrollingFrame_ViewerFrame,
                "TOPLEFT",
                portalPlacementYOfs,
                portarray[i][1],
                portarray[i][3]
            )
            PortalListFrame.text =
                PortalList:CreatePortalText(PL_ListFrame_ScrollingFrame_ViewerFrame.portal, portarray[i][3])

            portalPlacementYOfs = portalPlacementYOfs - 40
        end
    end

    return PortalList
end

--Debug: Posts when the load was sucessful.
print("PortalList: Sucessful Init Load")
