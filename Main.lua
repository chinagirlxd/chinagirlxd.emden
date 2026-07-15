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
-- STAFF / MOD DETECTOR
-- ============================================
local moderatorNames = {
    ["1Floppo1"] = "Game Moderator",
    ["Pharao13"] = "Game Moderator",
    ["1Oida1"] = "Game Moderator",
    ["L4KSh6699"] = "Game Moderator",
    ["aggoune6"] = "Game Moderator",
    ["SteveWulli"] = "Game Moderator",
    ["Jonschiii123"] = "Game Moderator",
    ["kevini44"] = "Game Moderator",
    ["PassiGames"] = "Game Moderator",
    ["Mudwzy"] = "Game Moderator",
    ["IruiRen"] = "Game Moderator",
    ["prodbyxvr"] = "Game Moderator",
    ["lazyzleo"] = "Game Moderator",
    ["Ferdi_1011"] = "Game Moderator",
    ["SuperToastt"] = "Game Moderator",
    ["WolfV1suals"] = "Game Moderator",
}

local moderatorIds = {
    [5352357] = "Game Moderator",      -- PassiGames
    [10749712] = "Game Moderator",     -- kevini44
    [4689144952] = "Game Moderator",   -- Jonschiii123
    [1439745778] = "Game Moderator",   -- 1Floppo1
    [171667858] = "Game Moderator",    -- Mudwzy
    [992311928] = "Game Moderator",    -- aggoune6
    [5243639493] = "Game Moderator",   -- 1Oida1
    [350959852] = "Game Moderator",    -- WolfV1suals
    [1376504063] = "Game Moderator",   -- Super_Toastt
    [7543442489] = "Game Moderator",   -- L4KSh_6699
    [10174679771] = "Game Moderator",  -- lazyzleo
}

local customWatchlist = {}
local staffPersistence = {}
local staffAlerts = true

local function checkIfStaff(player)
    local isStaff = false
    local staffReason = "Unknown"

    local ok, pId = pcall(function() return tonumber(player.UserId) end)
    local userId = ok and pId or 0

    if moderatorIds[userId] then
        isStaff = true
        staffReason = moderatorIds[userId]
    end

    if moderatorNames[player.Name] then
        isStaff = true
        staffReason = moderatorNames[player.Name]
    end

    if player.DisplayName and moderatorNames[player.DisplayName] then
        isStaff = true
        staffReason = moderatorNames[player.DisplayName]
    end

    if customWatchlist[player.Name] then
        isStaff = true
        staffReason = "WATCHLIST"
    end

    if not isStaff then
        local ln = (player.Name or ""):lower()
        local ld = (player.DisplayName or ""):lower()
        if ln:find("mod") or ln:find("admin") or ln:find("staff") or
           ld:find("mod") or ld:find("admin") or ld:find("staff") then
            isStaff = true
            staffReason = "Keyword Match"
        end
    end

    return isStaff, staffReason
end

-- Staff detection loop
task.spawn(function()
    while true do
        task.wait(2)
        local currentFound = {}
        local playerList = Players:GetPlayers()

        for i = 1, #playerList do
            local p = playerList[i]
            if p == localPlayer then continue end

            local isStaff, reason = checkIfStaff(p)

            if isStaff then
                currentFound[p.Name] = true

                if not staffPersistence[p.Name] then
                    staffPersistence[p.Name] = {Reason = reason, JoinTime = tick()}

                    if staffAlerts and type(notify) == "function" then
                        local roleColor = reason == "Founder" and "🔴" or
                                         reason == "Co-Founder" and "🔴" or
                                         reason == "Lead Developer" and "🟠" or
                                         reason == "Game Moderator" and "🟡" or
                                         reason == "Staff" and "🟢" or
                                         reason == "WATCHLIST" and "🔵" or "⚪"
                        notify(roleColor .. " STAFF DETECTED: " .. p.Name, reason .. " joined the server!", 8)
                    end
                end
            end
        end

        for name, data in pairs(staffPersistence) do
            if not currentFound[name] then
                staffPersistence[name] = nil
                if staffAlerts and type(notify) == "function" then
                    notify("Staff Left: " .. name, "No longer in server", 4)
                end
            end
        end
    end
end)

-- ============================================
-- DOOR TP
-- ============================================
local doorIndex = 1
local allDoors = {}
local lastF2Press = false
local lastF3Press = false
local lastF4Press = false
local lastF5Press = false
local lastF6Press = false

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
    if type(notify) == "function" then notify("Waypoint Saved!", "Press F3 to TP back", 2) end
end

local function tpToWaypoint()
    local hrp = getMyHRP()
    if not hrp then return end
    if not savedWaypoint then
        if type(notify) == "function" then notify("No Waypoint!", "Press F6 to save position", 2) end
        return
    end
    hrp.Position = savedWaypoint
    if type(notify) == "function" then notify("Teleported!", "Back to waypoint", 2) end
end

local function clearWaypoint()
    savedWaypoint = nil
    if type(notify) == "function" then notify("Waypoint Cleared!", "Press F6 to save new position", 2) end
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
                                result = { x = pos.X + size.X / 2, y = pos.Y + size.Y / 2 }
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
            if pos and size then return pos.X + size.X / 2, pos.Y + size.Y / 2 end
        end
    end
    return nil, nil
end

local function drag(fromX, fromY, toX, toY)
    mousemoveabs(fromX, fromY)
    task.wait(0.3)
    if not dragRunning then mousemoveabs(640, 360) return end
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
        mousemoveabs(fromX + (toX - fromX) * t, fromY + (toY - fromY) * t)
        task.wait(0.02)
    end
    if not dragRunning then mouse1release() mousemoveabs(640, 360) return end
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
                dragRunning = false
                UI.SetValue("dragitems", false)
                mousemoveabs(640, 360)
            else
                local toX, toY = getSlot(slotNames[slotIndex])
                if toX and dragRunning then
                    drag(item.x, item.y, toX, toY)
                    if dragRunning then
                        slotIndex = slotIndex + 1
                        if slotIndex > 9 then slotIndex = 1 end
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
-- DRAWING PANEL HELPERS
-- ============================================
local staffDrawings = {}
local invDrawings = {}
local staffPanelVisible = false
local invPanelVisible = false
local selectedInvPlayer = nil

local function clearDrawings(t)
    for i = 1, #t do
        if t[i] then t[i].Visible = false end
    end
    for k in pairs(t) do t[k] = nil end
end

local function makeBox(t, x, y, w, h, color, filled)
    local box = Drawing.new("Square")
    box.Position = Vector2.new(x, y)
    box.Size = Vector2.new(w, h)
    box.Color = color
    box.Filled = filled ~= false
    box.Transparency = 1
    box.Visible = true
    box.ZIndex = 50
    table.insert(t, box)
    return box
end

local function makeText(t, x, y, text, color, size)
    local label = Drawing.new("Text")
    label.Position = Vector2.new(x, y)
    label.Text = text
    label.Color = color
    label.Size = size or 12
    label.Visible = true
    label.ZIndex = 51
    table.insert(t, label)
    return label
end

-- ============================================
-- STAFF PANEL
-- ============================================
local function drawStaffPanel()
    clearDrawings(staffDrawings)
    if not staffPanelVisible then return end

    local x = 360
    local y = 30
    local w = 280
    local lineH = 18

    -- Count staff
    local staffList = {}
    for name, data in pairs(staffPersistence) do
        table.insert(staffList, {name = name, reason = data.Reason, time = data.JoinTime})
    end

    -- Count watchlist
    local watchList = {}
    for name, _ in pairs(customWatchlist) do
        table.insert(watchList, name)
    end

    local totalLines = 2 + #staffList + 2 + #watchList + 3
    if #staffList == 0 then totalLines = totalLines + 1 end
    if #watchList == 0 then totalLines = totalLines + 1 end

    local panelH = 30 + (totalLines * lineH) + 10

    -- Background
    makeBox(staffDrawings, x, y, w, panelH, Color3.new(0.08, 0.08, 0.1), true)
    makeBox(staffDrawings, x, y, w, panelH, Color3.new(0.25, 0.25, 0.35), false)

    -- Title bar
    makeBox(staffDrawings, x, y, w, 22, Color3.new(0.15, 0.1, 0.25), true)
    makeBox(staffDrawings, x, y, w, 22, Color3.new(0.4, 0.2, 0.6), false)
    makeBox(staffDrawings, x, y + 22, w, 2, Color3.new(0.5, 0.3, 0.8), true)
    makeText(staffDrawings, x + 8, y + 5, "STAFF DETECTOR", Color3.new(0.8, 0.5, 1), 13)

    local totalStaff = 0
    for _ in pairs(staffPersistence) do totalStaff = totalStaff + 1 end
    makeText(staffDrawings, x + w - 60, y + 5, totalStaff .. " found", totalStaff > 0 and Color3.new(1, 0.3, 0.3) or Color3.new(0.5, 0.5, 0.5), 11)

    local curY = y + 28

    -- Active Staff section
    makeText(staffDrawings, x + 8, curY, "ACTIVE STAFF/MODS:", Color3.new(1, 0.4, 0.4), 13)
    curY = curY + lineH

    if #staffList == 0 then
        makeText(staffDrawings, x + 12, curY, "No staff detected", Color3.new(0.4, 0.4, 0.4), 12)
        curY = curY + lineH
    else
        for i = 1, #staffList do
            local s = staffList[i]
            local roleColor = Color3.new(1, 0.8, 0.3)
            if s.reason == "Founder" or s.reason == "Co-Founder" then
                roleColor = Color3.new(1, 0.3, 0.3)
            elseif s.reason == "Lead Developer" then
                roleColor = Color3.new(1, 0.6, 0.1)
            elseif s.reason == "WATCHLIST" then
                roleColor = Color3.new(0.3, 0.7, 1)
            elseif s.reason == "Keyword Match" then
                roleColor = Color3.new(0.7, 0.7, 0.7)
            end

            -- Row bg
            makeBox(staffDrawings, x + 4, curY - 1, w - 8, lineH - 2, Color3.new(0.15, 0.08, 0.08), true)
            makeText(staffDrawings, x + 8, curY, s.name, Color3.new(1, 1, 1), 12)
            makeText(staffDrawings, x + w - 130, curY, "[" .. s.reason .. "]", roleColor, 11)
            curY = curY + lineH
        end
    end

    -- Separator
    makeBox(staffDrawings, x + 4, curY, w - 8, 1, Color3.new(0.3, 0.3, 0.3), true)
    curY = curY + 6

    -- Watchlist section
    makeText(staffDrawings, x + 8, curY, "WATCHLIST (" .. #watchList .. "):", Color3.new(0.3, 0.7, 1), 13)
    curY = curY + lineH

    if #watchList == 0 then
        makeText(staffDrawings, x + 12, curY, "No players watched", Color3.new(0.4, 0.4, 0.4), 12)
        curY = curY + lineH
    else
        for i = 1, #watchList do
            makeText(staffDrawings, x + 12, curY, watchList[i], Color3.new(0.5, 0.8, 1), 12)
            curY = curY + lineH
        end
    end

    -- Footer
    makeBox(staffDrawings, x, y + panelH - 18, w, 18, Color3.new(0.05, 0.05, 0.08), true)
    makeText(staffDrawings, x + 6, y + panelH - 14, "Updates every 2s | TAB = toggle", Color3.new(0.35, 0.35, 0.45), 10)
end

-- ============================================
-- INVENTORY PANEL
-- ============================================
local function drawInvPanel()
    clearDrawings(invDrawings)
    if not invPanelVisible or not selectedInvPlayer then return end

    local target = Players:FindFirstChild(selectedInvPlayer)
    if not target then return end

    local x = 360
    local y = 30
    local w = 260
    local lineH = 17

    -- Get data
    local wanted = isWanted(target)
    local cop = isCop(target)
    local job = target:GetAttribute("Job") or "None"
    local isStaff, staffRole = checkIfStaff(target)

    local hrp = getMyHRP()
    local char = target.Character
    local pHRP = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local dist = "?"
    if hrp and pHRP then
        local ok, pos = pcall(function() return pHRP.Position end)
        if ok and pos then dist = math.floor(getDist(hrp.Position, pos)) .. "m" end
    end

    local backpackItems = {}
    local bp = target:FindFirstChild("Backpack")
    if bp then
        for i, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then table.insert(backpackItems, item.Name) end
        end
    end

    local equippedItems = {}
    if char then
        for i, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then table.insert(equippedItems, item.Name) end
        end
    end

    local lines = {}
    local function add(text, color, size)
        table.insert(lines, {text = text, color = color, size = size or 12})
    end

    local statusText = "Civilian"
    local statusColor = Color3.new(0.6, 0.6, 0.6)
    if target == localPlayer then
        statusText = "YOU"
        statusColor = Color3.new(0.4, 1, 0.4)
    elseif isStaff then
        statusText = staffRole
        statusColor = Color3.new(1, 0.5, 0.1)
    elseif wanted then
        statusText = "WANTED"
        statusColor = Color3.new(1, 0.3, 0.3)
    elseif cop then
        statusText = "COP (Job: " .. tostring(job) .. ")"
        statusColor = Color3.new(0.4, 0.6, 1)
    end

    add("Status: " .. statusText, statusColor, 13)
    add("Distance: " .. dist, Color3.new(0.6, 0.6, 0.6))
    add("UserId: " .. tostring(target.UserId), Color3.new(0.5, 0.5, 0.5), 11)
    add(" ", Color3.new(1,1,1), 4)

    add("EQUIPPED (" .. #equippedItems .. "):", Color3.new(0.5, 1, 0.5), 13)
    if #equippedItems == 0 then
        add("  Nothing equipped", Color3.new(0.4, 0.4, 0.4))
    else
        for i = 1, #equippedItems do
            add("  " .. equippedItems[i], Color3.new(0.7, 1, 0.7))
        end
    end

    add(" ", Color3.new(1,1,1), 4)
    add("BACKPACK (" .. #backpackItems .. "):", Color3.new(1, 0.8, 0.3), 13)
    if #backpackItems == 0 then
        add("  Empty", Color3.new(0.4, 0.4, 0.4))
    else
        for i = 1, #backpackItems do
            add("  " .. backpackItems[i], Color3.new(1, 0.9, 0.6))
        end
    end

    local panelH = 32 + (#lines * lineH) + 10

    -- Background
    makeBox(invDrawings, x, y, w, panelH, Color3.new(0.08, 0.08, 0.1), true)
    makeBox(invDrawings, x, y, w, panelH, Color3.new(0.25, 0.25, 0.35), false)

    -- Title bar
    makeBox(invDrawings, x, y, w, 22, Color3.new(0.1, 0.12, 0.2), true)
    makeBox(invDrawings, x, y, w, 22, Color3.new(0.25, 0.35, 0.55), false)
    makeBox(invDrawings, x, y + 22, w, 2, Color3.new(0.3, 0.5, 0.8), true)
    makeText(invDrawings, x + 8, y + 5, target.Name .. " - Inventory", Color3.new(0.6, 0.8, 1), 13)

    for i = 1, #lines do
        local line = lines[i]
        if line.text ~= " " then
            makeText(invDrawings, x + 10, y + 28 + (i - 1) * lineH, line.text, line.color, line.size)
        end
    end

    makeBox(invDrawings, x, y + panelH - 18, w, 18, Color3.new(0.05, 0.05, 0.08), true)
    makeText(invDrawings, x + 6, y + panelH - 14, "Updates every 2s", Color3.new(0.35, 0.35, 0.45), 10)
end

-- Auto refresh panels
task.spawn(function()
    while true do
        task.wait(2)
        if staffPanelVisible then drawStaffPanel() end
        if invPanelVisible then drawInvPanel() end
    end
end)

-- ============================================
-- UI MENU
-- ============================================

local function getPlayerNames()
    local names = {}
    local list = Players:GetPlayers()
    for i = 1, #list do
        table.insert(names, list[i].Name)
    end
    return names
end

UI.AddTab("EMDEN", function(tab)

    -- ESP
    local espSec = tab:Section("ESP Settings", "Left")
    espSec:Toggle("copesp", "Cop ESP", true, function(state) _G.ESPCops = state end)
    espSec:ColorPicker("copcolor", 0, 0, 1, 1, function(color) _G.ColorCop = color end)
    espSec:Toggle("wantedesp", "Wanted ESP", true, function(state) _G.ESPWanted = state end)
    espSec:ColorPicker("Wantedcolor", 1, 0, 0, 1, function(color) _G.ColorWanted = color end)

    -- DOOR TP
    local doorSec = tab:Section("Door TP", "Left")
    doorSec:Button("nextdoor", "Next Door [F2]", function() tpNextDoor() end)

    -- WAYPOINT
    local waypointSec = tab:Section("Waypoint", "Left")
    waypointSec:Button("savewaypoint", "Save Waypoint [F6]", function() saveWaypoint() end)
    waypointSec:Button("tpwaypoint", "TP to Waypoint [F3]", function() tpToWaypoint() end)
    waypointSec:Button("clearwaypoint", "Clear Waypoint [F5]", function() clearWaypoint() end)

    -- DRAG
    local dragSec = tab:Section("Inventory Drag", "Left")
    dragSec:Toggle("dragitems", "Auto Drag Items [F4]", false, function(state)
        dragRunning = state
        if not dragRunning then mouse1release() slotIndex = 1 mousemoveabs(640, 360) end
    end)

    -- STAFF DETECTOR
    local staffSec = tab:Section("Staff Detector", "Left")

    staffSec:Toggle("staffalerts", "Staff Join Alerts", true, function(state)
        staffAlerts = state
    end)

    staffSec:Toggle("showstaff", "Show Staff Panel [TAB]", false, function(state)
        staffPanelVisible = state
        invPanelVisible = false
        UI.SetValue("showinv", false)
        if state then
            clearDrawings(invDrawings)
            drawStaffPanel()
        else
            clearDrawings(staffDrawings)
        end
    end)

    staffSec:Textbox("addwatch", "Add to Watchlist", "Enter username...", function(name)
        if name and name ~= "" then
            customWatchlist[name] = true
            if type(notify) == "function" then
                notify("Added to Watchlist!", name, 3)
            end
        end
    end)

    staffSec:Button("clearwatch", "Clear Watchlist", function()
        customWatchlist = {}
        if type(notify) == "function" then
            notify("Watchlist Cleared!", "All players removed", 2)
        end
        if staffPanelVisible then drawStaffPanel() end
    end)

    staffSec:Button("checkstaff", "Scan Server Now", function()
        local found = 0
        local list = Players:GetPlayers()
        for i = 1, #list do
            local p = list[i]
            if p ~= localPlayer then
                local isStaff, reason = checkIfStaff(p)
                if isStaff then
                    found = found + 1
                    print("STAFF: " .. p.Name .. " [" .. reason .. "]")
                end
            end
        end
        if type(notify) == "function" then
            notify("Scan Complete!", found .. " staff found in server", 3)
        end
        if staffPanelVisible then drawStaffPanel() end
    end)

    -- INVENTORY CHECKER
    local invSec = tab:Section("Inventory Checker", "Left")

    invSec:Toggle("showinv", "Show Inventory Panel", false, function(state)
        invPanelVisible = state
        staffPanelVisible = false
        UI.SetValue("showstaff", false)
        if state then
            clearDrawings(staffDrawings)
            drawInvPanel()
        else
            clearDrawings(invDrawings)
        end
    end)

    invSec:Dropdown("playerselect", "Select Player", getPlayerNames(), function(name)
        selectedInvPlayer = name
        if invPanelVisible then drawInvPanel() end
        if type(notify) == "function" then
            notify("Player Selected!", name, 1)
        end
    end)

    invSec:Button("refreshplayers", "Refresh Player List", function()
        if type(notify) == "function" then
            notify("Refreshed!", #Players:GetPlayers() .. " players", 2)
        end
    end)

    invSec:Button("tpselected", "TP to Selected Player", function()
        if not selectedInvPlayer then
            if type(notify) == "function" then notify("No player selected!", "Pick one", 2) end
            return
        end
        local target = Players:FindFirstChild(selectedInvPlayer)
        local hrp = getMyHRP()
        if target and hrp then
            local char = target.Character
            local pHRP = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if pHRP then
                hrp.Position = Vector3.new(pHRP.Position.X, pHRP.Position.Y + 3, pHRP.Position.Z)
                if type(notify) == "function" then notify("Teleported!", "To " .. selectedInvPlayer, 2) end
            end
        end
    end)

    -- INFO
    local infoSec = tab:Section("Info", "Right")
    infoSec:Text("=== ESP ===")
    infoSec:Text("Cop = Blue | Wanted = Red")
    infoSec:Spacing()
    infoSec:Text("=== Door TP ===")
    infoSec:Text("F2 = Next door")
    infoSec:Spacing()
    infoSec:Text("=== Waypoint ===")
    infoSec:Text("F6 = Save | F3 = TP | F5 = Clear")
    infoSec:Spacing()
    infoSec:Text("=== Drag ===")
    infoSec:Text("F4 = Toggle drag")
    infoSec:Spacing()
    infoSec:Text("=== Staff Detector ===")
    infoSec:Text("TAB = Staff panel")
    infoSec:Text("Checks names + IDs + keywords")
    infoSec:Text("Add custom watchlist names")
    infoSec:Spacing()
    infoSec:Text("=== Inventory ===")
    infoSec:Text("Enable panel + select player")
    infoSec:Text("Shows equipped + backpack")
    infoSec:Text("Updates every 2 seconds")

end)

if type(notify) == "function" then
    notify("Emden Cheat V3.0", "Staff Detector + Inventory Ready!", 3)
end

-- ============================================
-- KEYBINDS
-- ============================================
local lastTABPress = false

while true do
    local f2Press = iskeypressed(0x71)
    local f3Press = iskeypressed(0x72)
    local f4Press = iskeypressed(0x73)
    local f5Press = iskeypressed(0x74)
    local f6Press = iskeypressed(0x75)
    local tabPress = iskeypressed(0x09)

    if f2Press and not lastF2Press then tpNextDoor() end
    if f3Press and not lastF3Press then tpToWaypoint() end

    if f4Press and not lastF4Press then
        dragRunning = not dragRunning
        if not dragRunning then mouse1release() slotIndex = 1 mousemoveabs(640, 360) end
        UI.SetValue("dragitems", dragRunning)
        task.wait(0.5)
    end

    if f5Press and not lastF5Press then clearWaypoint() end
    if f6Press and not lastF6Press then saveWaypoint() end

    if tabPress and not lastTABPress then
        staffPanelVisible = not staffPanelVisible
        invPanelVisible = false
        UI.SetValue("showstaff", staffPanelVisible)
        UI.SetValue("showinv", false)
        if staffPanelVisible then
            clearDrawings(invDrawings)
            drawStaffPanel()
        else
            clearDrawings(staffDrawings)
        end
        task.wait(0.3)
    end

    lastF2Press = f2Press
    lastF3Press = f3Press
    lastF4Press = f4Press
    lastF5Press = f5Press
    lastF6Press = f6Press
    lastTABPress = tabPress
    task.wait(0.01)
end
