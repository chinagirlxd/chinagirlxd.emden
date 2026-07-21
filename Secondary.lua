local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui

-- ============================================
-- STAFF / MOD DETECTOR
-- ============================================
local moderatorNames = {
    -- Emden Staff
    ["neddLeduck"] = "Founder",
    ["ChickenBagelz"] = "Co-Founder",
    ["Warm_Vibes"] = "Lead Developer",
    ["AsianAbrex"] = "Lead Developer",
    ["Abrex"] = "Lead Developer",
    ["Pharao13"] = "Game Moderator",
    ["IruiRen"] = "Game Moderator",
    ["prodbyxvr"] = "Game Moderator",
    ["Ferdi_1011"] = "Game Moderator",
    ["SteveWulli"] = "Game Moderator",
    -- Void Falls Staff Team
    ["partygirlx33"] = "VF Owner",
    ["9234843943284325"] = "VF Head Admin",
    ["realnevw"] = "VF Head Admin",
    ["doulloureux"] = "VF Head Admin",
    ["realdrekoo"] = "VF Manager",
    ["KfcLovings"] = "VF Manager",
    ["yo6"] = "VF Manager",
    ["LouieGotAim"] = "VF Manager",
    ["byeIover"] = "VF Admin",
    ["lonelystar189432"] = "VF Admin",
    ["howBADlala72"] = "VF Admin",
    ["tywaisacutie"] = "VF Admin",
    ["internetcelebrity333"] = "VF Admin",
    ["Pro_GamerBoy10101"] = "VF Admin",
    ["tracesofyesterday"] = "VF Admin",
    ["readyforpeace"] = "VF Moderator",
    ["superstar74747"] = "VF Moderator",
    ["lllllIIllIlIlIIIIIl"] = "VF Moderator",
    ["nmb1"] = "VF Moderator",
    ["dynastyschild"] = "VF Admin",
    ["patience101101"] = "VF Admin",
    ["vi5uaI"] = "VF Moderator",
    ["reportmetovfkid"] = "VF Moderator",
    ["workingonsurviving"] = "VF Admin",
    ["eeexpn"] = "VF Moderator",
    ["h6axu"] = "VF Admin",
    ["X6H"] = "VF Moderator",
    ["lIllllIlIllllIIIIlll"] = "VF Moderator",
    ["t2008e2008_x"] = "VF Moderator",
    ["u1s34"] = "VF Moderator",
    ["mvl"] = "VF Moderator",
    ["ykdbleed"] = "VF Moderator",
    ["EchoBuilderKnight22"] = "VF Developer",
    ["Fastw4098"] = "VF Developer",
}

local moderatorIds = {
    -- Emden Staff IDs
    [16681869] = "Founder",
    [47983795] = "Co-Founder",
    [25548179] = "Lead Developer",
    [163101315] = "Lead Developer",
    [174212818] = "Contribution",
    [81993536] = "Game Moderator",
    [51281722] = "Game Moderator",
    [71787500309] = "Game Moderator",
    [113179883] = "Game Moderator",
    [3122439095] = "Game Moderator",
    [991290934] = "Game Moderator",
    [39688854760] = "Game Moderator",
    [1114812725] = "Game Moderator",
    [819933536] = "Game Moderator",
    [1004214871] = "Game Moderator",
    [9148476100] = "Game Moderator",
    [30349301770] = "Game Moderator",
    [1622256215] = "Game Moderator",
    [1116486172] = "Game Moderator",
    [425285304] = "Game Moderator",
    [23649501721] = "Game Moderator",
    [15283468443] = "Game Moderator",
    [165053216] = "Game Moderator",
    [9024231578] = "Game Moderator",
    [11279540045] = "Game Moderator",
    [3640120679] = "Game Moderator",
    [6020009251] = "Game Moderator",
    [3727911011] = "Game Moderator",
    [13781691111] = "Game Moderator",
    [3020799797] = "Game Moderator",
    [372528624] = "Game Moderator",
    [2567998467] = "Game Moderator",
    [4243907215] = "Game Moderator",
    [813030262] = "Game Moderator",
    [353983652] = "Game Moderator",
    [1406181681] = "Game Moderator",
    [2229169589] = "Game Moderator",
    [30934698] = "Game Moderator",
    [3004009465] = "Game Moderator",
    [8393333692] = "Game Moderator",
    [979624578] = "Game Moderator",
    [1478885961] = "Game Moderator",
    [4767504693] = "Staff",
    [750714593] = "Staff",
    [1586207495] = "Staff",
    [3264824275] = "Staff",
    [16611397749] = "Staff",
    [46198000148] = "Staff",
    [4132395] = "Staff",
    [29245496271] = "Staff",
    [110706049] = "Staff",
    [1916113547] = "Staff",
    [3487604697] = "Staff",
    [26647700969] = "Staff",
    [1072151937] = "Staff",
    [16162925260] = "Staff",
    [19922294235] = "Staff",
    [8865445466] = "Staff",
    [3508020028] = "Staff",
    [31224390095] = "Staff",
    [3034556584] = "Staff",
    [661625254] = "Staff",
    [1771300283] = "Staff",
    [4748895864] = "Staff",
    [1062456150] = "Staff",
    [1267154789] = "Staff",
    [52120772] = "Staff",
    [3576575263] = "Staff",
    [920463550] = "Staff",
    [12494786071] = "Staff",
    -- Emden Staff by ID only
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
    -- Void Falls Staff Team IDs
    [8974019762] = "VF Owner",         -- partygirlx33
    [10428537936] = "VF Head Admin",   -- 9234843943284325
    [4307662781] = "VF Head Admin",    -- realnevw
    [8880391170] = "VF Head Admin",    -- doulloureux
    [438058911] = "VF Manager",        -- realdrekoo
    [10535776571] = "VF Manager",      -- KfcLovings
    [932544] = "VF Manager",           -- yo6
    [245268896] = "VF Manager",        -- LouieGotAim
    [3909295243] = "VF Admin",         -- byeIover
    [3103057356] = "VF Admin",         -- lonelystar189432
    [4559062275] = "VF Admin",         -- howBADlala72
    [4138598689] = "VF Admin",         -- tywaisacutie
    [1236712946] = "VF Admin",         -- internetcelebrity333
    [582045008] = "VF Admin",          -- Pro_GamerBoy10101
    [679493787] = "VF Admin",          -- tracesofyesterday
    [8024390582] = "VF Moderator",     -- readyforpeace
    [2357314326] = "VF Moderator",     -- superstar74747
    [2851199655] = "VF Moderator",     -- lllllIIllIlIlIIIIIl
    [6848172] = "VF Moderator",        -- nmb1
    [1518920775] = "VF Admin",         -- dynastyschild
    [2465455931] = "VF Admin",         -- patience101101
    [1897714749] = "VF Moderator",     -- vi5uaI
    [7712451162] = "VF Moderator",     -- reportmetovfkid
    [11219101867] = "VF Admin",        -- workingonsurviving
    [4782538199] = "VF Moderator",     -- eeexpn
    [4321232351] = "VF Admin",         -- h6axu
    [61933812] = "VF Moderator",       -- X6H
    [10356013196] = "VF Moderator",    -- lIllllIlIllllIIIIlll
    [2238525232] = "VF Moderator",     -- t2008e2008_x
    [10208181409] = "VF Moderator",    -- u1s34
    [5688933] = "VF Moderator",        -- mvl
    [943632452] = "VF Moderator",      -- ykdbleed
    [11040398616] = "VF Developer",    -- EchoBuilderKnight22
    [9909945423] = "VF Developer",     -- Fastw4098
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
                        local roleColor = "⚪"
                        if reason == "Founder" or reason == "Co-Founder" then roleColor = "🔴"
                        elseif reason == "Lead Developer" then roleColor = "🟠"
                        elseif reason:find("VF") then roleColor = "🔵"
                        elseif reason == "Game Moderator" or reason == "Staff" then roleColor = "🟡"
                        elseif reason == "WATCHLIST" then roleColor = "🟣"
                        end
                        notify(roleColor .. " STAFF: " .. p.Name, reason .. " joined!", 8)
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
        if not dragRunning then mouse1release() mousemoveabs(640, 360) return end
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
-- DRAWING HELPERS
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
    local w = 300
    local lineH = 18

    local staffList = {}
    for name, data in pairs(staffPersistence) do
        table.insert(staffList, {name = name, reason = data.Reason})
    end

    local watchList = {}
    for name, _ in pairs(customWatchlist) do
        table.insert(watchList, name)
    end

    local totalLines = 2 + #staffList + 2 + #watchList + 1
    if #staffList == 0 then totalLines = totalLines + 1 end
    if #watchList == 0 then totalLines = totalLines + 1 end
    local panelH = 30 + (totalLines * lineH) + 10

    makeBox(staffDrawings, x, y, w, panelH, Color3.new(0.08, 0.08, 0.1), true)
    makeBox(staffDrawings, x, y, w, panelH, Color3.new(0.25, 0.25, 0.35), false)
    makeBox(staffDrawings, x, y, w, 22, Color3.new(0.15, 0.1, 0.25), true)
    makeBox(staffDrawings, x, y, w, 22, Color3.new(0.4, 0.2, 0.6), false)
    makeBox(staffDrawings, x, y + 22, w, 2, Color3.new(0.5, 0.3, 0.8), true)

    local totalStaff = 0
    for _ in pairs(staffPersistence) do totalStaff = totalStaff + 1 end
    makeText(staffDrawings, x + 8, y + 5, "STAFF DETECTOR", Color3.new(0.8, 0.5, 1), 13)
    makeText(staffDrawings, x + w - 65, y + 5, totalStaff .. " found", totalStaff > 0 and Color3.new(1, 0.3, 0.3) or Color3.new(0.5, 0.5, 0.5), 11)

    local curY = y + 28

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
            elseif s.reason == "VF Owner" then
                roleColor = Color3.new(1, 0.2, 0.8)
            elseif s.reason == "VF Head Admin" or s.reason == "VF Manager" then
                roleColor = Color3.new(0.8, 0.4, 1)
            elseif s.reason:find("VF") then
                roleColor = Color3.new(0.5, 0.6, 1)
            elseif s.reason == "WATCHLIST" then
                roleColor = Color3.new(0.3, 0.7, 1)
            elseif s.reason == "Keyword Match" then
                roleColor = Color3.new(0.7, 0.7, 0.7)
            end
            makeBox(staffDrawings, x + 4, curY - 1, w - 8, lineH - 2, Color3.new(0.15, 0.08, 0.08), true)
            makeText(staffDrawings, x + 8, curY, s.name, Color3.new(1, 1, 1), 12)
            makeText(staffDrawings, x + w - 140, curY, "[" .. s.reason .. "]", roleColor, 11)
            curY = curY + lineH
        end
    end

    makeBox(staffDrawings, x + 4, curY, w - 8, 1, Color3.new(0.3, 0.3, 0.3), true)
    curY = curY + 6

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

    local isStaff, staffRole = checkIfStaff(target)

    local backpackItems = {}
    local bp = target:FindFirstChild("Backpack")
    if bp then
        for i, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then table.insert(backpackItems, item.Name) end
        end
    end

    local equippedItems = {}
    local char = target.Character
    if char then
        for i, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then table.insert(equippedItems, item.Name) end
        end
    end

    local lines = {}
    local function add(text, color, size)
        table.insert(lines, {text = text, color = color, size = size or 12})
    end

    local statusText = "Normal"
    local statusColor = Color3.new(0.6, 0.6, 0.6)
    if target == localPlayer then
        statusText = "YOU"
        statusColor = Color3.new(0.4, 1, 0.4)
    elseif isStaff then
        statusText = staffRole
        statusColor = Color3.new(1, 0.5, 0.1)
    end

    add("Status: " .. statusText, statusColor, 13)
    add("UserId: " .. tostring(target.UserId), Color3.new(0.5, 0.5, 0.5), 11)
    add(" ", Color3.new(1,1,1), 4)
    add("EQUIPPED (" .. #equippedItems .. "):", Color3.new(0.5, 1, 0.5), 13)
    if #equippedItems == 0 then
        add("  Nothing equipped", Color3.new(0.4, 0.4, 0.4))
    else
        for i = 1, #equippedItems do add("  " .. equippedItems[i], Color3.new(0.7, 1, 0.7)) end
    end
    add(" ", Color3.new(1,1,1), 4)
    add("BACKPACK (" .. #backpackItems .. "):", Color3.new(1, 0.8, 0.3), 13)
    if #backpackItems == 0 then
        add("  Empty", Color3.new(0.4, 0.4, 0.4))
    else
        for i = 1, #backpackItems do add("  " .. backpackItems[i], Color3.new(1, 0.9, 0.6)) end
    end

    local panelH = 32 + (#lines * lineH) + 10

    makeBox(invDrawings, x, y, w, panelH, Color3.new(0.08, 0.08, 0.1), true)
    makeBox(invDrawings, x, y, w, panelH, Color3.new(0.25, 0.25, 0.35), false)
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
    for i = 1, #list do table.insert(names, list[i].Name) end
    return names
end

UI.AddTab("send ur butt", function(tab)

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
            if type(notify) == "function" then notify("Added to Watchlist!", name, 3) end
        end
    end)
    staffSec:Button("clearwatch", "Clear Watchlist", function()
        customWatchlist = {}
        if type(notify) == "function" then notify("Watchlist Cleared!", "All removed", 2) end
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
        if type(notify) == "function" then notify("Scan Complete!", found .. " staff found", 3) end
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
        if type(notify) == "function" then notify("Selected!", name, 1) end
    end)
    invSec:Button("refreshplayers", "Refresh Player List", function()
        if type(notify) == "function" then
            notify("Refreshed!", #Players:GetPlayers() .. " players", 2)
        end
    end)

    -- INFO
    local infoSec = tab:Section("Info", "Right")
    infoSec:Text("=== Inventory Drag ===")
    infoSec:Text("F4 = Toggle drag")
    infoSec:Spacing()
    infoSec:Text("=== Staff Detector ===")
    infoSec:Text("TAB = Staff panel")
    infoSec:Text("Emden + Void Falls staff")
    infoSec:Text("Keyword detection included")
    infoSec:Spacing()
    infoSec:Text("=== Inventory ===")
    infoSec:Text("Select player -> Check!")
    infoSec:Text("Updates every 2 seconds")

end)

if type(notify) == "function" then
    notify("send ur butt", "Loaded!", 3)
end

-- ============================================
-- KEYBINDS
-- ============================================
local lastTABPress = false
local lastF4Press = false

while true do
    local f4Press = iskeypressed(0x73)
    local tabPress = iskeypressed(0x09)

    if f4Press and not lastF4Press then
        dragRunning = not dragRunning
        if not dragRunning then mouse1release() slotIndex = 1 mousemoveabs(640, 360) end
        UI.SetValue("dragitems", dragRunning)
        task.wait(0.5)
    end

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

    lastF4Press = f4Press
    lastTABPress = tabPress
    task.wait(0.01)
end
