local DEBUFF_TEXTURE = "Interface\\Icons\\INV_Belt_18" -- Texture for "Shackles of the Legion"
local NoMoveFrame = CreateFrame("Frame")

local ZONES_WHITELIST = {
    ["Hand of Mephistroth"] = true,
    -- Add more zones here
}

local keysDisabled = false
local savedBindings = {}

local movementBindings = {
    "MOVEFORWARD",
    "MOVEBACKWARD",
    "STRAFELEFT",
    "STRAFERIGHT",
    "TOGGLEAUTORUN",
    "CAMERAORSELECTORMOVE"
}

local function IsInAllowedZone()
    local zone = GetSubZoneText()
    return ZONES_WHITELIST[zone] == true
end

local function DisableMovementKeys()
    savedBindings = {}

    for _, action in ipairs(movementBindings) do
        local key1, key2 = GetBindingKey(action)
        savedBindings[action] = {key1, key2}
        if key1 then SetBinding(key1, "NONE") end
        if key2 then SetBinding(key2, "NONE") end
    end

    keysDisabled = true
    DEFAULT_CHAT_FRAME:AddMessage("NoMove: Movement keys disabled!")
end

local function RestoreMovementKeys()
    for action, keys in pairs(savedBindings) do
        if keys[1] then SetBinding(keys[1], action) end
        if keys[2] then SetBinding(keys[2], action) end
    end

    savedBindings = {}
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

NoMoveFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
NoMoveFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
NoMoveFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
NoMoveFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
NoMoveFrame:SetScript("OnEvent", function()
    if event == "PLAYER_AURAS_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
        CheckDebuff()

    elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_MONSTER_EMOTE" then
        if arg1 and string.find(string.lower(arg1), "shackles of the legion") then
            DEFAULT_CHAT_FRAME:AddMessage("NoMove: Please release left mouse button and other movement keys.")
        end
    end
end)
