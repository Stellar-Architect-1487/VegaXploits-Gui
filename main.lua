local LogService = game:GetService("LogService")
local CG = game:GetService("CoreGui")
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

-- Глобальные настройки
if not getgenv().Hacks then
    getgenv().Hacks = {Speed = false, Fly = false, Noclip = false, ESP = false, InfJump = false, ClickKill = false, RainbowUI = false}
end
getgenv().flySpeed = 60
getgenv().customSpeed = 120

local safeContainer = gethui and gethui() or CG
if not safeContainer then safeContainer = LP:WaitForChild("PlayerGui", 5) end

if safeContainer:FindFirstChild("VegaX_EliteHub_v4") then 
    safeContainer["VegaX_EliteHub_v4"]:Destroy() 
end

local SG = Instance.new("ScreenGui", safeContainer)
SG.Name = "VegaX_EliteHub_v4"
SG.ResetOnSpawn = false

-- Главный фрейм (Современный темный неоновый дизайн)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 840, 0, 440)
Main.Position = UDim2.new(0.5, -420, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(11, 9, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", Main)
mainCorner.CornerRadius = UDim.new(0, 8)

-- Плавное перетаскивание (Drag) без лагов
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    TS:Create(Main, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Шапка верхняя
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "VEGAX ELITE v4.0 // THE ULTIMATE EXECUTOR EXECUTION PACH"
Title.TextColor3 = Color3.fromRGB(195, 150, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закрытия
local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 2)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Close.BackgroundColor3 = Color3.fromRGB(30, 18, 25)
Close.Font = Enum.Font.Code
Close.TextSize = 18
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

Close.MouseButton1Click:Connect(function()
    TS:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 840, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.25)
    SG:Destroy()
end)

-- Консоль вывода (Правая сторона)
local ConsoleFrame = Instance.new("Frame", Main)
ConsoleFrame.Size = UDim2.new(0, 240, 1, -50)
ConsoleFrame.Position = UDim2.new(1, -250, 0, 45)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(7, 5, 12)
ConsoleFrame.BorderSizePixel = 0
Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 6)

-- Кнопка свертывания консоли [-]
local ToggleConsole = Instance.new("TextButton", TitleBar)
ToggleConsole.Size = UDim2.new(0, 35, 0, 35)
ToggleConsole.Position = UDim2.new(1, -80, 0, 2)
ToggleConsole.Text = "[-]"
ToggleConsole.TextColor3 = Color3.fromRGB(150, 200, 255)
ToggleConsole.BackgroundColor3 = Color3.fromRGB(18, 26, 42)
ToggleConsole.Font = Enum.Font.Code
ToggleConsole.TextSize = 12
Instance.new("UICorner", ToggleConsole).CornerRadius = UDim.new(0, 6)

local isCollapsed = false
ToggleConsole.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        ToggleConsole.Text = "[+]"
        ConsoleFrame.Visible = false
        TS:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 590, 0, 440)}):Play()
    else
        ToggleConsole.Text = "[-]"
        ConsoleFrame.Visible = true
        TS:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 840, 0, 440)}):Play()
    end
end)
-- Создание категорий списков (Авто-сетка кнопок)
local function createCategory(idx, titleText)
    local frame = Instance.new("ScrollingFrame", Main)
    frame.Size = UDim2.new(0, 135, 1, -55)
    frame.Position = UDim2.new(0, 10 + (idx * 142), 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(16, 13, 26)
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Color3.fromRGB(75, 45, 120)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.Text = "  " .. titleText
    lbl.TextColor3 = Color3.fromRGB(175, 135, 240)
    lbl.BackgroundColor3 = Color3.fromRGB(24, 19, 38)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)
    
    local list = Instance.new("UIListLayout", frame)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 5)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 25)
    end)
    
    return frame
end

local CAT1 = createCategory(0, "MOVEMENT")
local CAT2 = createCategory(1, "ACTIONS")
local CAT3 = createCategory(2, "VISUALS")
local CAT4 = createCategory(3, "UTILITIES")

-- Генератор кнопок с Hover-анимациями (Плавное наведение)
local function addBtn(parent, name, order, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.LayoutOrder = order + 1
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(26, 21, 40)
    b.TextColor3 = Color3.fromRGB(215, 200, 255)
    b.Font = Enum.Font.Code
    b.TextSize = 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    b.MouseEnter:Connect(function()
        TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(42, 33, 64), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    b.MouseLeave:Connect(function()
        if not (string.find(b.Text, ": ON") or string.find(b.Text, "ACTIVE")) then
            TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 21, 40), TextColor3 = Color3.fromRGB(215, 200, 255)}):Play()
        end
    end)
    
    b.MouseButton1Click:Connect(function() 
        local origColor = b.BackgroundColor3
        b.BackgroundColor3 = Color3.fromRGB(110, 60, 180)
        task.wait(0.06)
        pcall(callback, b) 
    end)
    return b
end

local function toggler(key, btn, txt)
    getgenv().Hacks[key] = not getgenv().Hacks[key]
    local st = getgenv().Hacks[key]
    btn.Text = txt .. (st and ": ON" or ": OFF")
    local targetColor = st and Color3.fromRGB(85, 40, 140) or Color3.fromRGB(26, 21, 40)
    TS:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
end

-- Консоль логов внутри интерфейса
local SF = Instance.new("ScrollingFrame", ConsoleFrame)
SF.Size = UDim2.new(1, -12, 1, -12)
SF.Position = UDim2.new(0, 6, 0, 6)
SF.BackgroundTransparency = 1
SF.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", SF)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function printToUI(message, isError)
    local textLabel = Instance.new("TextLabel", SF)
    textLabel.Size = UDim2.new(1, 0, 0, 18)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 8
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    
    if isError then 
        textLabel.Text = "≫ [ERR]: " .. tostring(message)
        textLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
    else 
        textLabel.Text = "≫ [LOG]: " .. tostring(message)
        textLabel.TextColor3 = Color3.fromRGB(190, 180, 210)
    end
    SF.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
    SF.CanvasPosition = Vector2.new(0, SF.CanvasSize.Y.Offset)
end

LogService.MessageOut:Connect(function(m, t) printToUI(m, t == Enum.MessageType.MessageError) end)

-- ================= КАТЕГОРИЯ 1: MOVEMENT =================
addBtn(CAT1, "SPEED: OFF", 0, function(b) toggler("Speed", b, "SPEED") end)
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
addBtn(CAT1, "TELEPORT MOUSE", 5, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local m = LP:GetMouse() if t and m.Hit then t.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0,3,0)) printToUI("Телепортация по курсору") end end)
addBtn(CAT1, "TP UP 50 STPS", 6, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0,50,0) end end)
addBtn(CAT1, "TP DN 20 STPS", 7, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0,-20,0) end end)
addBtn(CAT1, "FLOAT CHAR (BP)", 8, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then local bp = Instance.new("BodyPosition", t) bp.Name = "VegaFloat" bp.MaxForce = Vector3.new(0,999999,0) bp.Position = t.Position printToUI("Персонаж зафиксирован в воздухе") end end)
addBtn(CAT1, "UNFLOAT CHAR", 9, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t and t:FindFirstChild("VegaFloat") then t.VegaFloat:Destroy() printToUI("Фиксация высоты отключена") end end)
addBtn(CAT1, "SPEED +20", 10, function() getgenv().customSpeed = getgenv().customSpeed + 20 printToUI("Скорость увеличена: " .. getgenv().customSpeed) end)
addBtn(CAT1, "SPEED RESET", 11, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 getgenv().customSpeed = 120 printToUI("Скорость сброшена") end end)

-- ================= КАТЕГОРИЯ 2: ACTIONS =================
addBtn(CAT2, "CLICK DESTROY", 0, function() local m = LP:GetMouse() if m.Target then printToUI("Удален парт: " .. m.Target.Name) m.Target:Destroy() end end)
addBtn(CAT2, "UNANCHOR MAP", 1, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) then o.Anchored = false end end printToUI("Физика мира включена") end)
addBtn(CAT2, "ANCHOR ALL MAP", 2, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Anchored = true end end printToUI("Мир заморожен") end)
addBtn(CAT2, "INF HEALTH (CS)", 3, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth = math.huge h.Health = math.huge printToUI("Бесконечное ХП выдано (Локально)") end end)
addBtn(CAT2, "CLICK KILL: OFF", 4, function(b) toggler("ClickKill", b, "CLICK KILL") end)
addBtn(CAT2, "KILL SELF", 5, function() if LP.Character then LP.Character:BreakJoints() printToUI("Суицид выполнен") end end)
addBtn(CAT2, "SIT DOWN", 6, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = true end end)
addBtn(CAT2, "FORCE JUMPST", 7, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Jump = true end end)
addBtn(CAT2, "DELETE ALL PTS", 8, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Name == "Part" then o:Destroy() end end printToUI("Удалены все стандартные Part") end)
addBtn(CAT2, "AGE BYPASS AT", 9, function() pcall(function() LP:SetAttribute("AgeChecked", "Checked") printToUI("Атрибут возраста подделан") end) end)
addBtn(CAT2, "STRIKE CLEAR", 10, function() pcall(function() LP:SetAttribute("StrikeCount", 0) printToUI("Варны обнулены") end) end)

LP:GetMouse().Button1Down:Connect(function()
    if getgenv().Hacks.ClickKill then
        local target = LP:GetMouse().Target
        if target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") then
            local targetChar = target.Parent
            if targetChar ~= LP.Character then
                targetChar:BreakJoints()
                printToUI("Убит через клик: " .. targetChar.Name)
            end
        end
    end
end)
-- ================= КАТЕГОРИЯ 3: VISUALS =================
addBtn(CAT3, "ESP: OFF", 0, function(b) 
    toggler("ESP", b, "ESP")
    if not getgenv().Hacks.ESP then 
        for _, p in ipairs(Plrs:GetPlayers()) do 
            if p.Character and p.Character:FindFirstChild("VMS_ESP") then p.Character.VMS_ESP:Destroy() end 
        end 
    end
end)
addBtn(CAT3, "RAINBOW UI: OFF", 1, function(b) toggler("RainbowUI", b, "RAINBOW UI") end)
addBtn(CAT3, "FULLBRIGHT", 2, function() game:GetService("Lighting").Ambient = Color3.new(1,1,1) game:GetService("Lighting").Brightness = 4 printToUI("Яркость выкручена") end)
addBtn(CAT3, "REMOVE ALL FOG", 3, function() game:GetService("Lighting").FogEnd = 999999 printToUI("Туман убран") end)
addBtn(CAT3, "XRAY VISION 50%", 4, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and (string.find(string.lower(o.Name), "wall") or o.Name == "Brick" or o.Name == "Railing") then o.Transparency = 0.5 end end printToUI("Рентген активирован") end)
addBtn(CAT3, "FPS BOOST MAT", 5, function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end printToUI("Материалы оптимизированы") end)
addBtn(CAT3, "DELETE DEBRIS", 6, function() if workspace:FindFirstChild("Debris") then workspace.Debris:ClearAllChildren() printToUI("Мусор очищен") end end)
addBtn(CAT3, "FOV TO 120", 7, function() workspace.CurrentCamera.FieldOfView = 120 end)
addBtn(CAT3, "FOV TO 70", 8, function() workspace.CurrentCamera.FieldOfView = 70 end)
addBtn(CAT3, "HIDE EXTER UI", 9, function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") and o.Name ~= "VegaX_EliteHub_v4" then o.Enabled = false end end printToUI("Интерфейсы скрыты") end)
addBtn(CAT3, "SHOW EXTER UI", 10, function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") then o.Enabled = true end end printToUI("Интерфейсы восстановлены") end)

-- Переливание цвета интерфейса (Rainbow UI)
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().Hacks.RainbowUI then
            local hue = (tick() % 5) / 5
            local color = Color3.fromHSV(hue, 0.7, 0.9)
            Title.TextColor3 = color
            TitleBar.BackgroundColor3 = Color3.fromHSV(hue, 0.4, 0.15)
        end
    end
end)

-- ================= КАТЕГОРИЯ 4: UTILITIES =================
addBtn(CAT4, "SCAN REMOTES", 0, function() for _, o in ipairs(game:GetDescendants()) do if o:IsA("RemoteEvent") then print("RemoteEvent Found: " .. o:GetFullName()) end end printToUI("Ремоты выведены в F9") end)
addBtn(CAT4, "PING ACC TEST", 1, function() printToUI("Стабильный отклик ядра") end)
addBtn(CAT4, "GC GARBAGE CL", 2, function() collectgarbage("collect") printToUI("Память Lua очищена") end)
addBtn(CAT4, "SCAN ALL USERS", 3, function() for _, p in ipairs(Plrs:GetPlayers()) do print("User: " .. p.Name .. " | ID: " .. p.UserId) end printToUI("Список игроков напечатан в F9") end)
addBtn(CAT4, "GET CORRDINATS", 4, function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then printToUI("Координаты: " .. tostring(t.Position)) end end)
addBtn(CAT4, "GRAVITY TO 0", 5, function() workspace.Gravity = 0 printToUI("Гравитация отключена") end)
addBtn(CAT4, "GRAVITY NORMAL", 6, function() workspace.Gravity = 196.2 printToUI("Гравитация восстановлена") end)
addBtn(CAT4, "JUMP POWER RST", 7, function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 50 printToUI("Прыжок сброшен") end end)
addBtn(CAT4, "FORCE EXIT GM", 8, function() game:Shutdown() end)
addBtn(CAT4, "UNLOCK CON F9", 9, function() game:GetService("GuiService"):SetDeveloperGuiEnabled(true) printToUI("Консоль F9 разблокирована") end)
addBtn(CAT4, "INFINITE YIELD", 10, function() loadstring(game:HttpGet("https://githubusercontent.com"))() printToUI("Infinite Yield запущен") end)
addBtn(CAT4, "DARK DEX V3", 11, function() loadstring(game:HttpGet("https://githubusercontent.com"))() printToUI("Dark Dex запущен") end)

-- Единый сверхстабильный цикл обслуживания (Защита от фризов и лагов)
RS.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local torso = char and char:FindFirstChild("HumanoidRootPart")
        
        if getgenv().Hacks.Speed and hum then
            hum.WalkSpeed = getgenv().customSpeed
        end
        
        if getgenv().Hacks.Noclip and char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        
        if getgenv().Hacks.Fly and torso and hum and torso:FindFirstChild("V5_Fly") then
            if hum.MoveDirection.Magnitude > 0 then 
                torso.V5_Fly.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().flySpeed 
            else 
                torso.V5_Fly.Velocity = Vector3.new(0,0,0) end
        end
        
        if getgenv().Hacks.ESP then
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("VMS_ESP") then
                        local box = Instance.new("BoxHandleAdornment", p.Character)
                        box.Name = "VMS_ESP" 
                        box.Size = Vector3.new(4, 6, 4) 
                        box.Color3 = Color3.fromRGB(160, 100, 255)
                        box.AlwaysOnTop = true 
                        box.ZIndex = 5 
                        box.Adornee = p.Character.HumanoidRootPart 
                        box.Transparency = 0.5
                    end
                end
            end
        end
    end)
end)

-- Бесконечный прыжок
UIS.JumpRequest:Connect(function() 
    if getgenv().Hacks.InfJump then 
        pcall(function() 
            local h = LP.Character:FindFirstChildOfClass("Humanoid") 
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
        end) 
    end 
end)

printToUI("Elite-хаб успешно развернут!", false)
printToUI("Создано для VegaXploits.", false)
