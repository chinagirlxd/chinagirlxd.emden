local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui

-- ============================================
-- ESP - UNTOUCHED
-- ============================================
_G.ESPWanted = true
_G.ESPCops = true
_G.ColorCop = Color3.new(0,0,1.228)
_G.ColorWanted = Color3.new(1,0,0)
local circles = {}

local function isWanted(player)
    local wantedlevel = player:GetAttribute("IsWanted")
    if wantedlevel == true then return true end
    return false
end

local function isCop(player)
    local job = player:GetAttribute("Job")
    if job == 1 or job == 8 then return true end
    return false
end

local function getHeadPos(player)
    local char = player.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    return head.Position + Vector3.new(0, -5, 0)
end

local function getDist(a, b)
    local dx = a.X - b.X
    local dy = a.Y - b.Y
    local dz = a.Z - b.Z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

spawn(function()
    while true do
        task.wait(1 / 30)
        local camera = Workspace.CurrentCamera
        if not camera then continue end
        for player, c in pairs(circles) do
            c:Remove()
            circles[player] = nil
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end
            local wanted = isWanted(player)
            local cop = isCop(player)
            local showPlayer = false
            if wanted and _G.ESPWanted then showPlayer = true
            elseif cop and _G.ESPCops then showPlayer = true end
            if not showPlayer then continue end
            local worldPos = getHeadPos(player)
            if not worldPos then continue end
            local screenPos, onScreen
            if type(WorldToScreen) == "function" then
                screenPos, onScreen = WorldToScreen(worldPos)
            else
                local vec, on = camera:WorldToViewportPoint(worldPos)
                screenPos = Vector2.new(vec.X, vec.Y)
                onScreen = on
            end
            if not onScreen then continue end
            local dist = getDist(worldPos, camera.Position)
            local radius = math.clamp(400 / dist, 3, 7)
            local c = Drawing.new("Circle")
            if wanted then c.Color = _G.ColorWanted else c.Color = _G.ColorCop end
            c.Filled = true
            c.Radius = radius
            c.NumSides = 32
            c.Thickness = 1
            c.Transparency = 1
            c.Position = screenPos
            c.Visible = true
            c.ZIndex = 5
            circles[player] = c
        end
    end
end)

-- ============================================
-- DOOR TP
-- ============================================
local doorIndex = 1
local allDoors = {}
local lastF1Press = false
local lastF2Press = false
local lastF3Press = false
local lastF4Press = false
local lastF5Press = false

local function getMyHRP()
    local char = localPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function loadAllDoors()
    local doors = {}
    local hrp = getMyHRP()
    for i, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "OnDrilled" then
            local door = v.Parent
            local ok, pos = pcall(function() return door.Position end)
            if ok and pos then
                local key = math.floor(pos.X) .. "_" .. math.floor(pos.Z)
                local dist = 999999
                if hrp then
                    local dx = hrp.Position.X - pos.X
                    local dz = hrp.Position.Z - pos.Z
                    dist = math.sqrt(dx*dx + dz*dz)
                end
                table.insert(doors, {pos = pos, dist = dist, key = key})
            end
        end
    end
    table.sort(doors, function(a, b) return a.dist < b.dist end)
    return doors
end

local function tpNextDoor()
    local hrp = getMyHRP()
    if not hrp then return end
    if #allDoors == 0 then
        allDoors = loadAllDoors()
        print("Portes chargées:", #allDoors)
    end
    if doorIndex > #allDoors then
        print("Toutes les portes visitées!")
        return
    end
    local door = allDoors[doorIndex]
    hrp.Position = Vector3.new(door.pos.X, door.pos.Y, door.pos.Z)
    print("Porte " .. doorIndex .. "/" .. #allDoors)
    doorIndex = doorIndex + 1
end

-- ============================================
-- WAYPOINT
-- ============================================
local savedWaypoint = nil

local function saveWaypoint()
    local hrp = getMyHRP()
    if not hrp then return end
    savedWaypoint = hrp.Position
    print("Waypoint saved:", savedWaypoint)
    if type(notify) == "function" then
        notify("Waypoint Saved!", "Press F3 to TP back", 2)
    end
end

local function tpToWaypoint()
    local hrp = getMyHRP()
    if not hrp then return end
    if not savedWaypoint then
        print("No waypoint saved! Press F1 first!")
        if type(notify) == "function" then
            notify("No Waypoint!", "Press F1 to save position", 2)
        end
        return
    end
    hrp.Position = savedWaypoint
    print("Teleported to waypoint!")
    if type(notify) == "function" then
        notify("Teleported!", "Back to waypoint", 2)
    end
end

local function clearWaypoint()
    savedWaypoint = nil
    print("Waypoint cleared!")
    if type(notify) == "function" then
        notify("Waypoint Cleared!", "Press F1 to save new position", 2)
    end
end

-- ============================================
-- DRAG
-- ============================================
local dragRunning = false
local slotIndex = 1
local slotNames = {
    "key_1", "key_2", "key_3",
    "key_4", "key_5", "key_6",
    "key_7", "key_8", "key_9"
}

local function getFirstItem()
    local result = nil
    local lowestX = 99999
    for i, v in ipairs(playerGui:GetDescendants()) do
        if v.Name == "Backpack_scroll" and v.AbsolutePosition.Y > 0 then
            for j, child in ipairs(v:GetChildren()) do
                if child:IsA("TextButton") then
                    local pos = child.AbsolutePosition
                    local size = child.AbsoluteSize
                    if pos and size and size.X > 0 then
                        if math.abs(pos.Y - 549.51) < 5 then
                            if pos.X < lowestX then
                                lowestX = pos.X
                                result = {
                                    x = pos.X + size.X / 2,
                                    y = pos.Y + size.Y / 2
                                }
                            end
                        end
                    end
                end
            end
            break
        end
    end
    return result
end

local function getSlot(name)
    for i, v in ipairs(playerGui:GetDescendants()) do
        if v.Name == name then
            local pos = v.AbsolutePosition
            local size = v.AbsoluteSize
            if pos and size then
                return pos.X + size.X / 2, pos.Y + size.Y / 2
            end
        end
    end
    return nil, nil
end

local function drag(fromX, fromY, toX, toY)
    mousemoveabs(fromX, fromY)
    task.wait(0.3)
    if not dragRunning then
        mousemoveabs(640, 360)
        return
    end
    mouse1press()
    task.wait(0.3)
    local steps = 15
    for s = 1, steps do
        if not dragRunning then
            mouse1release()
            mousemoveabs(640, 360)
            return
        end
        local t = s / steps
        mousemoveabs(
            fromX + (toX - fromX) * t,
            fromY + (toY - fromY) * t
        )
        task.wait(0.02)
    end
    if not dragRunning then
        mouse1release()
        mousemoveabs(640, 360)
        return
    end
    mousemoveabs(toX, toY)
    task.wait(0.15)
    mouse1release()
    mousemoveabs(640, 360)
    task.wait(0.3)
end

task.spawn(function()
    while true do
        if dragRunning then
            local item = getFirstItem()
            if not item then
                print("No item!")
                dragRunning = false
                UI.SetValue("dragitems", false)
                mousemoveabs(640, 360)
            else
                local toX, toY = getSlot(slotNames[slotIndex])
                if toX and dragRunning then
                    print("Item -> " .. slotNames[slotIndex])
                    drag(item.x, item.y, toX, toY)
                    if dragRunning then
                        slotIndex = slotIndex + 1
                        if slotIndex > 9 then
                            slotIndex = 1
                            print("Restart!")
                        end
                    end
                end
            end
        else
            slotIndex = 1
            task.wait(0.1)
        end
        task.wait(0.01)
    end
end)

-- ============================================
-- UI MENU
-- ============================================

UI.AddTab("EMDEN", function(tab)

    local espSec = tab:Section("ESP Settings", "Left")
    espSec:Toggle("copesp", "Cop ESP", true, function(state)
        _G.ESPCops = state
    end)
    espSec:ColorPicker("copcolor", 0, 0, 1, 1, function(color)
        _G.ColorCop = color
    end)
    espSec:Toggle("wantedesp", "Wanted ESP", true, function(state)
        _G.ESPWanted = state
    end)
    espSec:ColorPicker("Wantedcolor", 1, 0, 0, 1, function(color)
        _G.ColorWanted = color
    end)

    local doorSec = tab:Section("Door TP", "Left")
    doorSec:Button("nextdoor", "Next Door [F2]", function()
        tpNextDoor()
    end)

    local waypointSec = tab:Section("Waypoint", "Left")
    waypointSec:Button("savewaypoint", "Save Waypoint [F1]", function()
        saveWaypoint()
    end)
    waypointSec:Button("tpwaypoint", "TP to Waypoint [F3]", function()
        tpToWaypoint()
    end)
    waypointSec:Button("clearwaypoint", "Clear Waypoint [F5]", function()
        clearWaypoint()
    end)

    local dragSec = tab:Section("Inventory Drag", "Left")
    dragSec:Toggle("dragitems", "Auto Drag Items [F4]", false, function(state)
        dragRunning = state
        if not dragRunning then
            mouse1release()
            slotIndex = 1
            mousemoveabs(640, 360)
            print("Drag OFF")
        else
            print("Drag ON")
        end
    end)

    local infoSec = tab:Section("Info", "Right")
    infoSec:Text("=== ESP ===")
    infoSec:Text("Cop = Blue | Wanted = Red")
    infoSec:Spacing()
    infoSec:Text("=== Door TP ===")
    infoSec:Text("F2 = Next door")
    infoSec:Spacing()
    infoSec:Text("=== Waypoint ===")
    infoSec:Text("F1 = Save waypoint")
    infoSec:Text("F3 = TP to waypoint")
    infoSec:Text("F5 = Clear waypoint")
    infoSec:Spacing()
    infoSec:Text("=== Inventory Drag ===")
    infoSec:Text("F4 = Toggle drag items")

end)

if type(notify) == "function" then
    notify("Emden Cheat V2.0", "Running", 3)
end

-- ============================================
-- KEYBINDS
-- ============================================

while true do
    local f1Press = iskeypressed(0x70) -- F1 = Save waypoint
    local f2Press = iskeypressed(0x71) -- F2 = Next door
    local f3Press = iskeypressed(0x72) -- F3 = TP to waypoint
    local f4Press = iskeypressed(0x73) -- F4 = Drag toggle
    local f5Press = iskeypressed(0x74) -- F5 = Clear waypoint

    if f1Press and not lastF1Press then
        saveWaypoint()
    end

    if f2Press and not lastF2Press then
        tpNextDoor()
    end

    if f3Press and not lastF3Press then
        tpToWaypoint()
    end

    if f4Press and not lastF4Press then
        dragRunning = not dragRunning
        if not dragRunning then
            mouse1release()
            slotIndex = 1
            mousemoveabs(640, 360)
            print("Drag OFF")
        else
            print("Drag ON")
        end
        UI.SetValue("dragitems", dragRunning)
        task.wait(0.5)
    end

    if f5Press and not lastF5Press then
        clearWaypoint()
    end

    lastF1Press = f1Press
    lastF2Press = f2Press
    lastF3Press = f3Press
    lastF4Press = f4Press
    lastF5Press = f5Press
    task.wait(0.01)
end
