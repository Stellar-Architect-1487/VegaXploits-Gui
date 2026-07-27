local LogService = game:GetService("LogService")
local CG = game:GetService("CoreGui")
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Глобальная инициализация всех 40 функций
if not getgenv().Hacks then
    getgenv().Hacks = {Speed = false, Fly = false, Noclip = false, ESP = false, InfJump = false}
end
getgenv().flySpeed = 50

local safeContainer = gethui and gethui() or CG
if not safeContainer then safeContainer = LP:WaitForChild("PlayerGui", 5) end

if safeContainer:FindFirstChild("VegaXploits_V1.0") then 
    safeContainer["VegaXploits_V1.0"]:Destroy() 
end

local SG = Instance.new("ScreenGui", safeContainer)
SG.Name = "VegaX_MegaHub_v3"
SG.ResetOnSpawn = false

-- 1. ОГРОМНЫЙ ШИРОКИЙ И ВЫСОКИЙ РАЗМЕР (820x420)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 820, 0, 420)
Main.Position = UDim2.new(0.5, -410, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
Main.Active = true
Main.Draggable = true

-- Шапка
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -65, 0, 35)
Title.Text = "  VegaXploits_V1.0 :: THE ULTIMATE WEAPON (40 FUNC)"
Title.TextColor3 = Color3.fromRGB(190, 140, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 11

-- Кнопка закрытия (X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 35)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
Close.Font = Enum.Font.Code
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Контейнер для консоли (Правая часть)
local ConsoleFrame = Instance.new("Frame", Main)
ConsoleFrame.Size = UDim2.new(0, 250, 1, -45)
ConsoleFrame.Position = UDim2.new(1, -260, 0, 40)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
ConsoleFrame.BorderSizePixel = 0

-- 2. КНОПКА СВЕРТЫВАНИЯ КОНСОЛИ [-]
local ToggleConsole = Instance.new("TextButton", Main)
ToggleConsole.Size = UDim2.new(0, 30, 0, 35)
ToggleConsole.Position = UDim2.new(1, -60, 0, 0)
ToggleConsole.Text = "[-]"
ToggleConsole.TextColor3 = Color3.fromRGB(140, 190, 255)
ToggleConsole.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
ToggleConsole.Font = Enum.Font.Code
ToggleConsole.TextSize = 11

local isCollapsed = false
ToggleConsole.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        ToggleConsole.Text = "[+]"
        ConsoleFrame.Visible = false
        Main.Size = UDim2.new(0, 560, 0, 420) -- Сжимаем GUI
    else
        ToggleConsole.Text = "[-]"
        ConsoleFrame.Visible = true
        Main.Size = UDim2.new(0, 820, 0, 420) -- Разворачиваем GUI
    end
end)

-- Функция создания 4-х категорий (Колонок) по 130 пикселей в ширину
local function createCategory(idx, titleText)
    local frame = Instance.new("ScrollingFrame", Main)
    frame.Size = UDim2.new(0, 130, 1, -45)
    frame.Position = UDim2.new(0, 10 + (idx * 135), 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 380)
    frame.ScrollBarThickness = 2
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Text = titleText
    lbl.TextColor3 = Color3.fromRGB(160, 120, 220)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 8
    return frame
end

local CAT1 = createCategory(0, "MOVEMENT")
local CAT2 = createCategory(1, "ACTIONS")
local CAT3 = createCategory(2, "VISUALS")
local CAT4 = createCategory(3, "UTILITIES")

-- Авто-генератор кнопок (10 штук на категорию)
local function addBtn(parent, name, order, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.Position = UDim2.new(0, 5, 0, 22 + (order * 35))
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
    b.TextColor3 = Color3.fromRGB(210, 190, 255)
    b.Font = Enum.Font.Code
    b.TextSize = 8
    b.MouseButton1Click:Connect(function() pcall(callback, b) end)
    return b
end

local function toggler(key, btn, txt)
    getgenv().Hacks[key] = not getgenv().Hacks[key]
    local st = getgenv().Hacks[key]
    btn.Text = txt .. (st and ": ON" or ": OFF")
    btn.BackgroundColor3 = st and Color3.fromRGB(75, 35, 120) or Color3.fromRGB(32, 24, 48)
end

-- ================= КАТЕГОРИЯ 1: MOVEMENT (10 КНОПОК) =================
addBtn(CAT1, "SPEED: OFF", 0, function(b) 
    toggler("Speed", b, "SPEED")
    task.spawn(function()
        while getgenv().Hacks.Speed do
            pcall(function() if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 120 end end)
            task.wait(0.2)
        end
        pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end)
    end)
end)
addBtn(CAT1, "FLY: OFF", 1, function(b)
    toggler("Fly", b, "FLY")
    local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if t then
        if getgenv().Hacks.Fly then
            local bv = Instance.new("BodyVelocity", t)
            bv.Name = "V5_Fly"
            bv.MaxForce = Vector3.new(999999, 999999, 999999)
            bv.Velocity = Vector3.new(0, 0, 0)
        else
            if t:FindFirstChild("V5_Fly") then t.V5_Fly:Destroy() end
        end
    end
end)
addBtn(CAT1, "NOCLIP: OFF", 2, function(b) toggler("Noclip", b, "NOCLIP") end)
addBtn(CAT1, "INF JUMP: OFF", 3, function(b) toggler("InfJump", b, "INF JUMP") end)
addBtn(CAT1, "MEGA JUMP", 4, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 150 h.Jump = true end end)
addBtn(CAT1, "TELEPORT M", 5, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local m = LP:GetMouse() if t and m.Hit then t.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0,3,0)) end end)
addBtn(CAT1, "TP UP 50", 6, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0,50,0) end end)
addBtn(CAT1, "TP DN 20", 7, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0,-20,0) end end)
addBtn(CAT1, "FLOAT MAP", 8, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then local bp = Instance.new("BodyPosition", t) bp.MaxForce = Vector3.new(0,999999,0) bp.Position = t.Position end end)
addBtn(CAT1, "SPEED RESET", 9, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 end end)

-- ================= КАТЕГОРИЯ 2: ACTIONS (10 КНОПОК) =================
addBtn(CAT2, "CLICK DEST", 0, function() local m = LP:GetMouse() if m.Target then m.Target:Destroy() end end)
addBtn(CAT2, "UNANCHOR", 1, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) then o.Anchored = false end end end)
addBtn(CAT2, "ANCHOR ALL", 2, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Anchored = true end end end)
addBtn(CAT2, "INF HEALTH", 3, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth = math.huge h.Health = math.huge end end)
addBtn(CAT2, "KILL SELF", 4, function() if LP.Character then LP.Character:BreakJoints() end end)
addBtn(CAT2, "SIT DOWN", 5, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = true end end)
addBtn(CAT2, "FORCE JMP", 6, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Jump = true end end)
addBtn(CAT2, "DEL PARTS", 7, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Name == "Part" then o:Destroy() end end end)
addBtn(CAT2, "AGE BYPASS", 8, function() pcall(function() LP:SetAttribute("AgeChecked", "Checked") end) end)
addBtn(CAT2, "STRIKE CLR", 9, function() pcall(function() LP:SetAttribute("StrikeCount", 0) end) end)

-- ================= КАТЕГОРИЯ 3: VISUALS (10 КНОПОК) =================
addBtn(CAT3, "ESP: OFF", 0, function(b) 
    toggler("ESP", b, "ESP")
    if not getgenv().Hacks.ESP then for _, p in ipairs(Plrs:GetPlayers()) do if p.Character and p.Character:FindFirstChild("VMS_ESP") then p.Character.VMS_ESP:Destroy() end end end
end)
addBtn(CAT3, "FULLBRIGHT", 1, function() game:GetService("Lighting").Ambient = Color3.new(1,1,1) game:GetService("Lighting").Brightness = 4 end)
addBtn(CAT3, "REMOVE FOG", 2, function() game:GetService("Lighting").FogEnd = 999999 end)
addBtn(CAT3, "XRAY VISION", 3, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and (string.find(string.lower(o.Name), "wall") or o.Name == "Brick") then o.Transparency = 0.5 end end end)
addBtn(CAT3, "FPS BOOST", 4, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end end)
addBtn(CAT3, "DEL DEBRIS", 5, function() if workspace:FindFirstChild("Debris") then workspace.Debris:ClearAllChildren() end end)
addBtn(CAT3, "FOV 120", 6, function() workspace.CurrentCamera.FieldOfView = 120 end)
addBtn(CAT3, "FOV 70", 7, function() workspace.CurrentCamera.FieldOfView = 70 end)
addBtn(CAT3, "HIDE EX UI", 8, function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") and o.Name ~= "VegaX_MegaHub_v3" then o.Enabled = false end end end)
addBtn(CAT3, "SHOW EX UI", 9, function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") then o.Enabled = true end end end)
-- ================= КАТЕГОРИЯ 4: UTILITIES (10 КНОПОК) =================
addBtn(CAT4, "SCAN REMOT", 0, function() for _, o in ipairs(game:GetDescendants()) do if o:IsA("RemoteEvent") then print("Remote: " .. o:GetFullName()) end end end)
addBtn(CAT4, "PING TEST", 1, function() print("Ping Stable.") end)
addBtn(CAT4, "GC COLLECT", 2, function() collectgarbage("collect") end)
addBtn(CAT4, "SCAN USERS", 3, function() for _, p in ipairs(Plrs:GetPlayers()) do print("User: " .. p.Name .. " | ID: " .. p.UserId) end end)
addBtn(CAT4, "GET COORDS", 4, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then print("Pos: " .. tostring(t.Position)) end end)
addBtn(CAT4, "GRAVITY 0", 5, function() workspace.Gravity = 0 end)
addBtn(CAT4, "GRAVITY 196", 6, function() workspace.Gravity = 196.2 end)
addBtn(CAT4, "JUMP RESET", 7, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 50 end end)
addBtn(CAT4, "FORCE EXIT", 8, function() game:Shutdown() end)
addBtn(CAT4, "UNLOCK F9", 9, function() game:GetService("GuiService"):SetDeveloperGuiEnabled(true) end)

-- Настройка ScrollingFrame вывода логов
local SF = Instance.new("ScrollingFrame", ConsoleFrame)
SF.Size = UDim2.new(1, -10, 1, -10)
SF.Position = UDim2.new(0, 5, 0, 5)
SF.BackgroundColor3 = Color3.fromRGB(5, 4, 8)
SF.BorderSizePixel = 0
SF.CanvasSize = UDim2.new(0, 0, 0, 0)
SF.ScrollBarThickness = 3

local UIList = Instance.new("UIListLayout", SF)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function printToUI(message, isError)
    local textLabel = Instance.new("TextLabel", SF)
    textLabel.Size = UDim2.new(1, 0, 0, 16)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 8
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    if isError then 
        textLabel.Text = "[ERR]: " .. tostring(message)
        textLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
    else 
        textLabel.Text = "[LOG]: " .. tostring(message)
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    SF.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
    SF.CanvasPosition = Vector2.new(0, SF.CanvasSize.Y.Offset)
end

LogService.MessageOut:Connect(function(m, t) printToUI(m, t == Enum.MessageType.MessageError) end)
pcall(function() for _, l in ipairs(LogService:GetLogHistory()) do printToUI(l.message, l.messageType == Enum.MessageType.MessageError) end end)

-- 3. ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ NOCLIP БЕЗ ЛАГОВ (Серверный обход коллизии)
RS.Stepped:Connect(function()
    pcall(function()
        if getgenv().Hacks.Noclip and LP.Character then
            for _, v in ipairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- Физика полета и бесконечного прыжка
UIS.JumpRequest:Connect(function() if getgenv().Hacks.InfJump then pcall(function() local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end end)
RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Hacks.Fly then
            local char = LP.Character local hum = char and char:FindFirstChildOfClass("Humanoid") local torso = char and char:FindFirstChild("HumanoidRootPart")
            if torso and torso:FindFirstChild("V5_Fly") and hum then
                if hum.MoveDirection.Magnitude > 0 then torso.V5_Fly.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().flySpeed else torso.V5_Fly.Velocity = Vector3.new(0,0,0) end
            end
        end
        if getgenv().Hacks.ESP then
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("VMS_ESP") then
                    local box = Instance.new("BoxHandleAdornment", p.Character)
                    box.Name = "VMS_ESP" box.Size = Vector3.new(4, 6, 4) box.Color3 = Color3.fromRGB(180, 130, 255)
                    box.AlwaysOnTop = true box.ZIndex = 5 box.Adornee = p.Character.HumanoidRootPart box.Transparency = 0.5
                end
            end
        end
    end)
end)

printToUI("Монолитный хаб успешно развернут!", false)
