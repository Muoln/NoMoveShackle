local DEBUFF_TEXTURE = "Interface\\Icons\\INV_Belt_18" -- Texture for "Shackles of the Legion"
local NoMoveFrame = CreateFrame("Frame")

local ZONES_WHITELIST = {
    ["Hand of Mephistroth"] = true,
    -- Add more zones here
}

local keysDisabled = false

local function IsInAllowedZone()
    local zone = GetSubZoneText()
    return ZONES_WHITELIST[zone] == true
end

local function DisableMovementKeys()
    SetBinding("BUTTON1", "NONE");
    SetBinding("W", "NONE")
    SetBinding("A", "NONE")
    SetBinding("S", "NONE")
    SetBinding("D", "NONE")
    SetBinding("Q", "NONE")
    SetBinding("E", "NONE")
    SetBinding("UP", "NONE")
    SetBinding("DOWN", "NONE")
    SetBinding("LEFT", "NONE")
    SetBinding("RIGHT", "NONE")

    keysDisabled = true
    DEFAULT_CHAT_FRAME:AddMessage("NoMove: Movement keys disabled!")
end

local function RestoreMovementKeys()
    SetBinding("BUTTON1","CAMERAORSELECTORMOVE");
    SetBinding("W", "MOVEFORWARD")
    SetBinding("A", "TURNLEFT")
    SetBinding("S", "MOVEBACKWARD")
    SetBinding("D", "TURNRIGHT")
    SetBinding("Q", "STRAFELEFT")
    SetBinding("E", "STRAFERIGHT")
    SetBinding("UP", "MOVEFORWARD")
    SetBinding("DOWN", "MOVEBACKWARD")
    SetBinding("LEFT", "TURNLEFT")
    SetBinding("RIGHT", "TURNRIGHT")

    keysDisabled = false
    DEFAULT_CHAT_FRAME:AddMessage("NoMove: Movement keys restored!")
end

local function CheckDebuff()
    if not IsInAllowedZone() then return end

    local hasDebuff = false
    for i = 1, 16 do
        local texture = UnitDebuff("player", i)
        if texture == DEBUFF_TEXTURE then
            hasDebuff = true
            break
        end
    end

    if hasDebuff and not keysDisabled then
        DisableMovementKeys()
    elseif not hasDebuff and keysDisabled then
        RestoreMovementKeys()
    end
end

NoMoveFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
NoMoveFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
NoMoveFrame:SetScript("OnEvent", function()
    CheckDebuff()
end)