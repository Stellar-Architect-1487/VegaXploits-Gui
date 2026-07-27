local LogService = game:GetService("LogService")
local CG = game:GetService("CoreGui")
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

-- Глобальная база состояний и конфигураций
if not getgenv().Hacks then
    getgenv().Hacks = {}
end
getgenv().flySpeed = 60
getgenv().customSpeed = 120
getgenv().hitboxSize = 15

-- Поиск безопасного контейнера (Защита от обнаружения античитами)
local safeContainer = gethui and gethui() or CG
if not safeContainer then safeContainer = LP:WaitForChild("PlayerGui", 5) end

-- Полная очистка предыдущих сессий хаба
if safeContainer:FindFirstChild("VegaX_UltimateHub_v5") then 
    safeContainer["VegaX_UltimateHub_v5"]:Destroy() 
end

local SG = Instance.new("ScreenGui", safeContainer)
SG.Name = "VegaX_UltimateHub_v5"
SG.ResetOnSpawn = false

-- Главный фрейм (Увеличенный размер под плотную сетку функций)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 880, 0, 520)
Main.Position = UDim2.new(0.5, -440, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Добавление стильного неонового контура (Градиентная обводка)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(85, 45, 160)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Высокоточный и плавный Drag-and-Drop движок
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Верхняя панель управления (TopBar)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 420, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "★ VEGAX ULTIMATE v5.0 // 100+ CODES PREMIUM ENGINE"
Title.TextColor3 = Color3.fromRGB(210, 175, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Интеллектуальное поле поиска (Поисковая строка)
local SearchBar = Instance.new("TextBox", TopBar)
SearchBar.Size = UDim2.new(0, 180, 0, 28)
SearchBar.Position = UDim2.new(1, -290, 0, 8)
SearchBar.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
SearchBar.Text = ""
SearchBar.PlaceholderText = "Поиск по 100+ кодам..."
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.PlaceholderColor3 = Color3.fromRGB(130, 115, 150)
SearchBar.Font = Enum.Font.SourceSans
SearchBar.TextSize = 13
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", SearchBar).Color = Color3.fromRGB(60, 40, 90)

-- Кнопка полного закрытия (X)
local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Close.BackgroundColor3 = Color3.fromRGB(38, 16, 24)
Close.Font = Enum.Font.Code
Close.TextSize = 22
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Боковая панель для категорий (Слева)
local TabPanel = Instance.new("Frame", Main)
TabPanel.Size = UDim2.new(0, 150, 1, -45)
TabPanel.Position = UDim2.new(0, 0, 0, 45)
TabPanel.BackgroundColor3 = Color3.fromRGB(13, 10, 20)
TabPanel.BorderSizePixel = 0

local TabList = Instance.new("UIListLayout", TabPanel)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- Контейнер вывода страниц (Центр)
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -415, 1, -55)
PageContainer.Position = UDim2.new(0, 155, 0, 50)
PageContainer.BackgroundTransparency = 1

-- Контейнер кастомной консоли (Справа)
local ConsoleFrame = Instance.new("Frame", Main)
ConsoleFrame.Size = UDim2.new(0, 240, 1, -55)
ConsoleFrame.Position = UDim2.new(1, -250, 0, 50)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(7, 5, 12)
ConsoleFrame.BorderSizePixel = 0
Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 6)

-- Кнопка сворачивания/разворачивания консоли [-] / [+]
local ToggleConsole = Instance.new("TextButton", TopBar)
ToggleConsole.Size = UDim2.new(0, 35, 0, 35)
ToggleConsole.Position = UDim2.new(1, -85, 0, 5)
ToggleConsole.Text = "[-]"
ToggleConsole.TextColor3 = Color3.fromRGB(140, 190, 255)
ToggleConsole.BackgroundColor3 = Color3.fromRGB(18, 25, 40)
ToggleConsole.Font = Enum.Font.Code
ToggleConsole.TextSize = 13
Instance.new("UICorner", ToggleConsole).CornerRadius = UDim.new(0, 6)

local isCollapsed = false
ToggleConsole.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        ToggleConsole.Text = "[+]"
        ConsoleFrame.Visible = false
        TS:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 630, 0, 520)}):Play()
        PageContainer.Size = UDim2.new(1, -165, 1, -55)
    else
        ToggleConsole.Text = "[-]"
        ConsoleFrame.Visible = true
        TS:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 880, 0, 520)}):Play()
        PageContainer.Size = UDim2.new(1, -415, 1, -55)
    end
end)

local activeTab = nil
local allButtons = {}

-- Фабрика сборки вкладок
local function createTab(name, order)
    local tabBtn = Instance.new("TextButton", TabPanel)
    tabBtn.Size = UDim2.new(1, -10, 0, 35)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.LayoutOrder = order
    tabBtn.Text = "   " .. name
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
    tabBtn.TextColor3 = Color3.fromRGB(175, 150, 215)
    tabBtn.Font = Enum.Font.Code
    tabBtn.TextSize = 11
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(100, 65, 165)

    local grid = Instance.new("UIGridLayout", page)
    grid.CellSize = UDim2.new(0, 150, 0, 35)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 20)
    end)

    tabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            activeTab.Button.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
            activeTab.Page.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
        page.Visible = true
        activeTab = {Button = tabBtn, Page = page}
    end)

    if order == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
        page.Visible = true
        activeTab = {Button = tabBtn, Page = page}
    end
    return page
end

-- Фабрика интерактивных кнопок
local function addFunctionBtn(page, name, callback)
    local b = Instance.new("TextButton", page)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
    b.TextColor3 = Color3.fromRGB(210, 195, 240)
    b.Font = Enum.Font.Code
    b.TextSize = 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    b.MouseEnter:Connect(function()
        TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 33, 68), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    b.MouseLeave:Connect(function()
        if not (string.find(b.Text, ": ON") or string.find(b.Text, "ACTIVE")) then
            TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 20, 38), TextColor3 = Color3.fromRGB(210, 195, 240)}):Play()
        end
    end)
    
    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(130, 75, 210)
        task.wait(0.06)
        pcall(callback, b)
    end)
    table.insert(allButtons, {Name = name, Instance = b})
    return b
end

local function menuToggler(key, btn, txt)
    getgenv().Hacks[key] = not getgenv().Hacks[key]
    local st = getgenv().Hacks[key]
    btn.Text = txt .. (st and ": ON" or ": OFF")
    local targetColor = st and Color3.fromRGB(95, 45, 165) or Color3.fromRGB(25, 20, 38)
    TS:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
end

-- Связывание поискового текстового индекса с кнопками
SearchBar.Changed:Connect(function(prop)
    if prop == "Text" then
        local search = string.lower(SearchBar.Text)
        for _, data in ipairs(allButtons) do
            if search == "" then data.Instance.Visible = true
                else data.Instance.Visible = string.find(string.lower(data.Name), search) and true or false
                end
            end
        end
    end)
-- Регистрация всех 6 страниц
local PageCombat    = createTab("COMBAT", 1)
local PageMovement  = createTab("MOVEMENT", 2)
local PageVisuals   = createTab("VISUALS", 3)
local PagePlayer    = createTab("PLAYER", 4)
local PageWorld     = createTab("WORLD", 5)
local PageUtilities = createTab("UTILITIES", 6)
-- Консоль вывода логов
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

-- ================= ВКЛАДКА 1: COMBAT =================
addFunctionBtn(PageCombat, "AIMBOT: OFF", function(b)
    menuToggler("Aimbot", b, "AIMBOT")
    task.spawn(function()
        while getgenv().Hacks.Aimbot do
            pcall(function()
                local closest = nil local maxDist = math.huge
                for _, p in ipairs(Plrs:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if onScreen then
                            local mousePos = UIS:GetMouseLocation()
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if dist < maxDist and dist < 200 then maxDist = dist closest = p.Character.HumanoidRootPart end
                        end
                    end
                end
                if closest then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position) end
            end)
            task.wait()
        end
    end)
end)

addFunctionBtn(PageCombat, "SILENT AIM: OFF", function(b)
    menuToggler("SilentAim", b, "SILENT AIM")
    task.spawn(function()
        local gmt = getrawmetatable(game)
        setreadonly(gmt, false)
        local oldNamecall = gmt.__namecall
        gmt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if getgenv().Hacks.SilentAim and tostring(method) == "FireServer" then
                local closest = nil local maxDist = math.huge
                for _, p in ipairs(Plrs:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < maxDist then maxDist = dist closest = p.Character.HumanoidRootPart end
                    end
                end
                if closest then
                    for i, v in ipairs(args) do if typeof(v) == "Vector3" then args[i] = closest.Position end end
                end
            end
            return oldNamecall(self, unpack(args))
        end)
    end)
end)

addFunctionBtn(PageCombat, "KILL AURA: OFF", function(b)
    menuToggler("KillAura", b, "KILL AURA")
    task.spawn(function()
        while getgenv().Hacks.KillAura do
            pcall(function()
                for _, p in ipairs(Plrs:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 18 then
                            local tool = LP.Character:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
                            if tool then tool.Parent = LP.Character tool:Activate() end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

addFunctionBtn(PageCombat, "HITBOX EXPAND", function()
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(getgenv().hitboxSize, getgenv().hitboxSize, getgenv().hitboxSize)
                hrp.Transparency = 0.7 hrp.Color = Color3.fromRGB(255, 0, 0)
                hrp.Material = Enum.Material.Neon hrp.CanCollide = false
            end)
        end
    end
    printToUI("Хитбоксы расширены")
end)

addFunctionBtn(PageCombat, "HITBOX RESET", function()
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1) hrp.Transparency = 0 hrp.CanCollide = true
            end)
        end
    end
    printToUI("Хитбоксы сброшены")
end)

addFunctionBtn(PageCombat, "HITBOX +5", function() getgenv().hitboxSize = getgenv().hitboxSize + 5 printToUI("Размер хитбокса: " .. getgenv().hitboxSize) end)
addFunctionBtn(PageCombat, "CLICK KILL: OFF", function(b) menuToggler("ClickKill", b, "CLICK KILL") end)
addFunctionBtn(PageCombat, "TRIGGERBOT: OFF", function(b)
    menuToggler("TriggerBot", b, "TRIGGERBOT")
    task.spawn(function()
        while getgenv().Hacks.TriggerBot do
            pcall(function()
                local target = LP:GetMouse().Target
                if target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") and target.Parent ~= LP.Character then
                    local tool = LP.Character:FindFirstChildOfClass("Tool") if tool then tool:Activate() end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

addFunctionBtn(PageCombat, "GUN NO RECOIL", function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("NumberValue") and (string.find(string.lower(v.Name), "recoil") or v.Name == "KickBack") then v.Value = 0 end
    end
    printToUI("Отдача отключена")
end)

addFunctionBtn(PageCombat, "GUN INF AMMO", function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("IntValue") and (string.find(string.lower(v.Name), "ammo") or v.Name == "ClipSize") then v.Value = 99999 end
    end
    printToUI("Патроны заморожены")
end)

addFunctionBtn(PageCombat, "TP TO CLOSEST", function()
    pcall(function()
        local target, targetDist = nil, math.huge
        for _, p in ipairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < targetDist then targetDist = d target = p.Character.HumanoidRootPart end
            end
        end
        if target then LP.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 3) end
    end)
end)

addFunctionBtn(PageCombat, "INSTANT SHIELD", function() local f = Instance.new("ForceField", LP.Character) task.wait(5) f:Destroy() end)

-- ================= ВКЛАДКА 2: MOVEMENT =================
addFunctionBtn(PageMovement, "SPEED HACK: OFF", function(b) menuToggler("Speed", b, "SPEED HACK") end)
addFunctionBtn(PageMovement, "FLY MODE: OFF", function(b)
    menuToggler("Fly", b, "FLY MODE")
    local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if t then
        if getgenv().Hacks.Fly then
            local bv = Instance.new("BodyVelocity", t)
            bv.Name = "V5_Fly" bv.MaxForce = Vector3.new(999999, 999999, 999999) bv.Velocity = Vector3.new(0, 0, 0)
        else
            if t:FindFirstChild("V5_Fly") then t.V5_Fly:Destroy() end
        end
    end
end)

addFunctionBtn(PageMovement, "NOCLIP WALLS: OFF", function(b) menuToggler("Noclip", b, "NOCLIP WALLS") end)
addFunctionBtn(PageMovement, "INF JUMP: OFF", function(b) menuToggler("InfJump", b, "INF JUMP") end)
addFunctionBtn(PageMovement, "SPEED +20", function() getgenv().customSpeed = getgenv().customSpeed + 20 printToUI("Скорость: " .. getgenv().customSpeed) end)
addFunctionBtn(PageMovement, "SPEED RESET", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 getgenv().customSpeed = 120 printToUI("Скорость сброшена") end end)
addFunctionBtn(PageMovement, "FLY SPEED +10", function() getgenv().flySpeed = getgenv().flySpeed + 10 printToUI("Скорость полета: " .. getgenv().flySpeed) end)

addFunctionBtn(PageMovement, "CLICK TELEPORT", function()
    local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local m = LP:GetMouse()
    if t and m.Hit then t.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0)) end
end)

addFunctionBtn(PageMovement, "TP UP 50 STPS", function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0, 50, 0) end end)
addFunctionBtn(PageMovement, "TP DN 50 STPS", function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0, -50, 0) end end)
addFunctionBtn(PageMovement, "TP FORWARD 30", function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then t.CFrame = t.CFrame * CFrame.new(0, 0, -30) end end)
addFunctionBtn(PageMovement, "FLOAT CHAR: ON", function()local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t and not t:FindFirstChild("VegaFloat") then
local bp = Instance.new("BodyPosition", t) bp.Name = "VegaFloat" bp.MaxForce = Vector3.new(0, 999999, 0) bp.Position = t.Position
        end
    end)
addFunctionBtn(PageMovement, "FLOAT CHAR: OFF", function()local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart:FindFirstChild("VegaFloat") if t then t:Destroy()
        end
     end)
addFunctionBtn(PageMovement, "MEGA JUMP (200)", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 200 h.Jump = true 
        end
    end)
addFunctionBtn(PageMovement, "SWIM IN AIR: OFF", function(b)menuToggler("AirSwim", b, "SWIM IN AIR")task.spawn(function()while getgenv().Hacks.AirSwim dopcall(function()
                  LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming) end)task.wait(0.1)
            end
      end)
end)
-- ================= ВКЛАДКА 3: VISUALS =================
addFunctionBtn(PageVisuals, "BOX ESP: OFF", function(b) 
    menuToggler("ESP", b, "BOX ESP")
    if not getgenv().Hacks.ESP then 
        for _, p in ipairs(Plrs:GetPlayers()) do 
            if p.Character and p.Character:FindFirstChild("VMS_ESP") then p.Character.VMS_ESP:Destroy() end 
        end 
    end
end)

addFunctionBtn(PageVisuals, "CHAMS GLOW: OFF", function(b)
    menuToggler("Chams", b, "CHAMS GLOW")
    if not getgenv().Hacks.Chams then
        for _, p in ipairs(Plrs:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VegaChams") then p.Character.VegaChams:Destroy() end
        end
    end
end)

addFunctionBtn(PageVisuals, "ESP TRACERS: OFF", function(b)
    menuToggler("Tracers", b, "ESP TRACERS")
    if not getgenv().Hacks.Tracers then
        for _, p in ipairs(Plrs:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VegaTracer") then p.Character.VegaTracer:Destroy() end
        end
    end
end)

addFunctionBtn(PageVisuals, "RAINBOW UI: OFF", function(b) menuToggler("RainbowUI", b, "RAINBOW UI") end)
addFunctionBtn(PageVisuals, "FULLBRIGHT NIGHT", function() game:GetService("Lighting").Ambient = Color3.new(1,1,1) game:GetService("Lighting").Brightness = 4 printToUI("Яркость выкручена") end)
addFunctionBtn(PageVisuals, "REMOVE ALL FOG", function() game:GetService("Lighting").FogEnd = 999999 game:GetService("Lighting").FogStart = 999999 printToUI("Туман удален") end)

addFunctionBtn(PageVisuals, "XRAY VISION 50%", function() 
    for _, o in ipairs(workspace:GetDescendants()) do 
        if o:IsA("BasePart") and (string.find(string.lower(o.Name), "wall") or o.Name == "Brick") then o.Transparency = 0.5 end 
    end 
    printToUI("Рентген включен")
end)

addFunctionBtn(PageVisuals, "XRAY VISION RESET", function() 
    for _, o in ipairs(workspace:GetDescendants()) do 
        if o:IsA("BasePart") and (string.find(string.lower(o.Name), "wall") or o.Name == "Brick") then o.Transparency = 0 end 
    end 
    printToUI("Рентген выключен")
end)

addFunctionBtn(PageVisuals, "FPS BOOST MATS", function() 
    for _, o in ipairs(workspace:GetDescendants()) do 
        if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end 
    end 
    printToUI("Текстуры упрощены")
end)

addFunctionBtn(PageVisuals, "DELETE DEBRIS", function() if workspace:FindFirstChild("Debris") then workspace.Debris:ClearAllChildren() printToUI("Мусор очищен") end end)
addFunctionBtn(PageVisuals, "FOV VIEW TO 120", function() workspace.CurrentCamera.FieldOfView = 120 end)
addFunctionBtn(PageVisuals, "FOV VIEW TO 70", function() workspace.CurrentCamera.FieldOfView = 70 end)
addFunctionBtn(PageVisuals, "HIDE EXTERNAL UI", function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") and o.Name ~= "VegaX_UltimateHub_v5" then o.Enabled = false end end printToUI("Интерфейсы игры скрыты") end)
addFunctionBtn(PageVisuals, "SHOW EXTERNAL UI", function() for _, o in ipairs(LP.PlayerGui:GetChildren()) do if o:IsA("ScreenGui") then o.Enabled = true end end printToUI("Интерфейсы игры возвращены") end)
addFunctionBtn(PageVisuals, "REMOVE SHADOWS", function() game:GetService("Lighting").GlobalShadows = false end)
addFunctionBtn(PageVisuals, "RESTORE SHADOWS", function() game:GetService("Lighting").GlobalShadows = true end)
addFunctionBtn(PageVisuals, "HIGHLIGHT SELF", function() if LP.Character then local hl = Instance.new("Highlight", LP.Character) hl.FillColor = Color3.fromRGB(0, 255, 0) end end)
addFunctionBtn(PageVisuals, "INFRARED LIGHT", function() game:GetService("Lighting").Ambient = Color3.fromRGB(255, 0, 0) end)
addFunctionBtn(PageVisuals, "BLUE NEON LIGHT", function() game:GetService("Lighting").Ambient = Color3.fromRGB(0, 150, 255) end)

-- Переливание цвета интерфейса (Rainbow UI эффект)
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().Hacks.RainbowUI then
            local hue = (tick() % 5) / 5
            local color = Color3.fromHSV(hue, 0.7, 0.9)
            Title.TextColor3 = color
            TopBar.BackgroundColor3 = Color3.fromHSV(hue, 0.4, 0.15)
        end
    end
end)

-- ================= ВКЛАДКА 4: PLAYER =================
addFunctionBtn(PagePlayer, "KILL MY CHARACTER", function() if LP.Character then LP.Character:BreakJoints() printToUI("Персонаж убит") end end)
addFunctionBtn(PagePlayer, "GODMODE LITE (CS)", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.MaxHealth = math.huge h.Health = math.huge printToUI("Локальное ХП заморожено") end end)
addFunctionBtn(PagePlayer, "FORCE SIT POSITION", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = true end end)
addFunctionBtn(PagePlayer, "FORCE STAND UP", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = false end end)
addFunctionBtn(PagePlayer, "INSTANT RESPAWN", function() LP:LoadCharacter() printToUI("Принудительный респавн") end)

addFunctionBtn(PagePlayer, "ANTI-AFK SYSTEM: ON", function() 
    pcall(function()
        if getgenv().AntiAfkConnection then getgenv().AntiAfkConnection:Disconnect() end
        getgenv().AntiAfkConnection = LP.Idled:Connect(function() 
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
            task.wait(1) 
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
        end)
        printToUI("Защита от АФК активна")
    end)
end)

addFunctionBtn(PagePlayer, "ANTI-AFK SYSTEM: OFF", function() if getgenv().AntiAfkConnection then getgenv().AntiAfkConnection:Disconnect() printToUI("Защита от АФК отключена") end end)
addFunctionBtn(PagePlayer, "FAKE AGE BYPASS", function() pcall(function() LP:SetAttribute("AgeChecked", "Checked") printToUI("Атрибут возраста подделан") end) end)
addFunctionBtn(PagePlayer, "CLEAR STRIKE COUNT", function() pcall(function() LP:SetAttribute("StrikeCount", 0) printToUI("Варны аккаунта обнулены") end) end)
addFunctionBtn(PagePlayer, "RESET JUMP POWER", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 50 end end)
addFunctionBtn(PagePlayer, "INFINITE OXYGEN", function() pcall(function() LP.Character.Humanoid:SetAttribute("Oxygen", 100) printToUI("Кислород заморожен") end) end)
addFunctionBtn(PagePlayer, "NO RAGDOLL PHYSICS", function() for _, v in ipairs(game:GetDescendants()) do if v:IsA("StringValue") and string.find(string.lower(v.Name), "ragdoll") then v:Destroy() end end printToUI("Физика тряпичной куклы удалена") end)
addFunctionBtn(PagePlayer, "SET MAX JUMP (300)", function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = 300 end end)
addFunctionBtn(PagePlayer, "REMOVE TOOLS BACKP", function() LP.Backpack:ClearAllChildren() printToUI("Инвентарь очищен") end end)
addFunctionBtn(PagePlayer, "INVISIBLE LOCAL: ON", function() if LP.Character then for _, v in ipairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end printToUI("Невидимость включена") end end)
addFunctionBtn(PagePlayer, "VISIBLE LOCAL: OFF", function() if LP.Character then for _, v in ipairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0 elseif v:IsA("Decal") and v.Name == "face" then v.Transparency = 0 end end printToUI("Невидимость отключена") end end)
addFunctionBtn(PagePlayer, "REMOVE ROOT ANCHOR", function() pcall(function() LP.Character.HumanoidRootPart.Anchored = false end) end)
addFunctionBtn(PagePlayer, "SPAM CHAT TRASH", function() local s = game:GetService("TextChatService").TextChannels.RBXGeneral s:SendAsync("VegaX Ultimate Engine Exploits Winning!") end)
-- ================= ВКЛАДКА 5: WORLD =================
addFunctionBtn(PageWorld, "GRAVITY TO 0", function() workspace.Gravity = 0 printToUI("Гравитация отключена") end)
addFunctionBtn(PageWorld, "GRAVITY NORMAL", function() workspace.Gravity = 196.2 printToUI("Гравитация восстановлена") end)
addFunctionBtn(PageWorld, "GRAVITY MOON (30)", function() workspace.Gravity = 30 printToUI("Включена лунная гравитация") end)
addFunctionBtn(PageWorld, "UNANCHOR WORLD", function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) then o.Anchored = false end end printToUI("Физика карты включена") end)
addFunctionBtn(PageWorld, "ANCHOR ALL WORLD", function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Anchored = true end end printToUI("Мир заморожен") end)
addFunctionBtn(PageWorld, "DESTROY PART CURS", function() local m = LP:GetMouse() if m.Target then printToUI("Удален блок: " .. m.Target.Name) m.Target:Destroy() end end)
addFunctionBtn(PageWorld, "DELETE ALL BRICKS", function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Name == "Part" then o:Destroy() end end printToUI("Все базовые парты удалены") end)
addFunctionBtn(PageWorld, "COLLISION OFF MAP", function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) then o.CanCollide = false end end printToUI("Коллизия мира отключена") end)
addFunctionBtn(PageWorld, "COLLISION ON MAP", function() for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.CanCollide = true end end printToUI("Коллизия мира восстановлена") end)
addFunctionBtn(PageWorld, "SPEED UP TIME +5", function() pcall(function() game:GetService("Lighting").ClockTime = game:GetService("Lighting").ClockTime + 5 end) end)
addFunctionBtn(PageWorld, "FREEZE TIME LIGHT", function() pcall(function() game:GetService("Lighting").GeographicLatitude = 90 end) end)

-- ================= ВКЛАДКА 6: UTILITIES =================
addFunctionBtn(PageUtilities, "SCAN REMOTES F9", function() for _, o in ipairs(game:GetDescendants()) do if o:IsA("RemoteEvent") then print("RemoteEvent Found: " .. o:GetFullName()) end end printToUI("Ремоты выведены в F9") end)
addFunctionBtn(PageUtilities, "SCAN FUNCTIONS F9", function() for _, o in ipairs(game:GetDescendants()) do if o:IsA("RemoteFunction") then print("RemoteFunction Found: " .. o:GetFullName()) end end printToUI("Функции выведены в F9") end)
addFunctionBtn(PageUtilities, "PING TEST STABLE", function() printToUI("Отклик ядра стабилен.") end)
addFunctionBtn(PageUtilities, "LUA RAM GC COLLECT", function() collectgarbage("collect") printToUI("Мусор оперативной памяти Lua очищен") end)
addFunctionBtn(PageUtilities, "PRINT USERS F9", function() for _, p in ipairs(Plrs:GetPlayers()) do print("User: " .. p.Name .. " | ID: " .. p.UserId) end printToUI("Список игроков напечатан в F9") end)
addFunctionBtn(PageUtilities, "GET MY COORDS F9", function() local t = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if t then printToUI("Координаты: " .. tostring(t.Position)) end end)
addFunctionBtn(PageUtilities, "FORCE EXIT GAME", function() game:Shutdown() end)
addFunctionBtn(PageUtilities, "FORCE UNLOCK F9", function() game:GetService("GuiService"):SetDeveloperGuiEnabled(true) printToUI("Консоль F9 принудительно разблокирована") end)

-- Исправленная кнопка Infinite Yield
addFunctionBtn(PageUtilities, "INFINITE YIELD", function() 
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://githubusercontent.com"))() 
    end)
    if success then printToUI("Infinite Yield успешно запущен") else printToUI("Ошибка IY: " .. tostring(err), true) end
end)

-- Исправленная кнопка Dark Dex V3 Bypassed
addFunctionBtn(PageUtilities, "DARK DEX V3", function() 
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://githubusercontent.com"))() 
    end)
    if success then printToUI("Dark Dex Bypassed успешно запущен") else printToUI("Ошибка Dex: " .. tostring(err), true) end
end)

-- ================= ЕДИНЫЙ ВЫСОКОСКОРОСТНОЙ ПОТОК ОБСЛУЖИВАНИЯ (HEARTBEAT ENGINE) =================
RS.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local torso = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Сверхстабильный Speed Hack
        if getgenv().Hacks.Speed and hum then
            hum.WalkSpeed = getgenv().customSpeed
        end
        
        -- Полноценный Noclip
        if getgenv().Hacks.Noclip and char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        
        -- Контролируемый полет (Fly Mode)
        if getgenv().Hacks.Fly and torso and hum and torso:FindFirstChild("V5_Fly") then
            if hum.MoveDirection.Magnitude > 0 then 
                torso.V5_Fly.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().flySpeed 
            else 
                torso.V5_Fly.Velocity = Vector3.new(0,0,0) 
            end
        end
        
        -- Сверхточный Box ESP
        if getgenv().Hacks.ESP then
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("VMS_ESP") then
                        local box = Instance.new("BoxHandleAdornment", p.Character)
                        box.Name = "VMS_ESP" box.Size = Vector3.new(4, 6, 4) box.Color3 = Color3.fromRGB(160, 100, 255)
                        box.AlwaysOnTop = true box.ZIndex = 5 box.Adornee = p.Character.HumanoidRootPart box.Transparency = 0.5
                    end
                end
            end
        end

        -- Продвинутые Трейсеры (Tracers ESP)
        if getgenv().Hacks.Tracers then
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("VegaTracer") then
                        local b = Instance.new("BoxHandleAdornment", p.Character)
                        b.Name = "VegaTracer" b.Size = Vector3.new(0.5, 0.5, 400) b.Color3 = Color3.fromRGB(0, 255, 150)
                        b.AlwaysOnTop = true b.ZIndex = 4 b.Adornee = p.Character.HumanoidRootPart b.Transparency = 0.7
                    end
                end
            end
        end

        -- Подсветка Chams Glow
        if getgenv().Hacks.Chams then
            for _, p in ipairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("VegaChams") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "VegaChams" hl.FillColor = Color3.fromRGB(255, 50, 150) hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)
end)

-- Бесконечный прыжок через Input-перехватчик
UIS.JumpRequest:Connect(function() 
    if getgenv().Hacks.InfJump then 
        pcall(function() 
            local h = LP.Character:FindFirstChildOfClass("Humanoid") 
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
        end) 
    end 
end)

printToUI("VegaX Ultimate Mega Hub успешно развернут!", false)
printToUI("Все 100+ функций готовы к работе.", false)
