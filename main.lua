-- ЭТОТ КОД ДОЛЖЕН ЛЕЖАТЬ НА GITHUB (main.lua)
local LogService = game:GetService("LogService")
local CG = game:GetService("CoreGui")
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

if not getgenv().Hacks then
    getgenv().Hacks = {Speed = false, Fly = false, Noclip = false, ESP = false, InfJump = false}
end
getgenv().flySpeed = 50

-- Защищенный контейнер (проверяем gethui и CoreGui)
local safeContainer = gethui and gethui() or CG
if not safeContainer then safeContainer = LP:WaitForChild("PlayerGui", 5) end

if safeContainer:FindFirstChild("VegaX_UltimateHub") then 
    safeContainer["VegaX_UltimateHub"]:Destroy() 
end

-- Создаем основу ScreenGui
local SG = Instance.new("ScreenGui", safeContainer)
SG.Name = "VegaX_UltimateHub"
SG.ResetOnSpawn = false

-- Главный фрейм (Крупный, красивый размер)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 600, 0, 280)
Main.Position = UDim2.new(0.5, -300, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
Main.Active = true
Main.Draggable = true

-- Шапка
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Text = "  VEGAXPLOITS v3.1 :: ULTIMATE MONOLITH HUB"
Title.TextColor3 = Color3.fromRGB(190, 140, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 10

-- Кнопка закрыть
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
Close.Font = Enum.Font.Code
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Левая панель с кнопками хаков
local ButtonFrame = Instance.new("ScrollingFrame", Main)
ButtonFrame.Size = UDim2.new(0, 220, 1, -40)
ButtonFrame.Position = UDim2.new(0, 10, 0, 35)
ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
ButtonFrame.BorderSizePixel = 0
ButtonFrame.CanvasSize = UDim2.new(0, 0, 0, 360)
ButtonFrame.ScrollBarThickness = 3

local function createBtn(name, y, callback)
    local b = Instance.new("TextButton", ButtonFrame)
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    b.TextColor3 = Color3.fromRGB(220, 200, 255)
    b.Font = Enum.Font.Code
    b.TextSize = 9
    b.MouseButton1Click:Connect(function() pcall(callback, b) end)
    return b
end

local function toggleState(hacksKey, button, baseText)
    getgenv().Hacks[hacksKey] = not getgenv().Hacks[hacksKey]
    local state = getgenv().Hacks[hacksKey]
    button.Text = baseText .. (state and ": ON" or ": OFF")
    button.BackgroundColor3 = state and Color3.fromRGB(75, 35, 120) or Color3.fromRGB(35, 25, 55)
end

-- Кнопки управления читами
createBtn("SPEEDHACK: OFF", 10, function(b) 
    toggleState("Speed", b, "SPEEDHACK") 
end)

createBtn("FLY: OFF", 47, function(b) 
    toggleState("Fly", b, "FLY")
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

createBtn("NOCLIP: OFF", 84, function(b) 
    toggleState("Noclip", b, "NOCLIP")
    task.spawn(function()
        while getgenv().Hacks.Noclip do
            pcall(function() 
                if LP.Character then 
                    for _, p in ipairs(LP.Character:GetDescendants()) do 
                        if p:IsA("BasePart") then p.CanCollide = false end 
                    end 
                end 
            end)
            task.wait(0.2)
        end
    end)
end)

createBtn("INF JUMP: OFF", 121, function(b) toggleState("InfJump", b, "INF JUMP") end)

createBtn("MEGA IMPULSE JUMP", 158, function() 
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity = Vector3.new(root.Velocity.X, 130, root.Velocity.Z) end
end)

createBtn("GRAVITY: 0", 195, function() workspace.Gravity = 0 end)
createBtn("GRAVITY: NORMAL", 232, function() workspace.Gravity = 196.2 end)

createBtn("UNANCHOR MAP", 269, function() 
    for _, o in ipairs(workspace:GetDescendants()) do 
        if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) then o.Anchored = false end 
    end 
end)

createBtn("KILL SELF (RESET)", 306, function() 
    workspace.Gravity = 196.2
    getgenv().Hacks.Speed = false
    getgenv().Hacks.Fly = false
    getgenv().Hacks.Noclip = false
    if LP.Character then LP.Character:BreakJoints() end 
end)

-- Правая панель консоли
local ConsoleFrame = Instance.new("Frame", Main)
ConsoleFrame.Size = UDim2.new(0, 350, 1, -40)
ConsoleFrame.Position = UDim2.new(0, 240, 0, 35)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
ConsoleFrame.BorderSizePixel = 0

local SF = Instance.new("ScrollingFrame", ConsoleFrame)
SF.Size = UDim2.new(1, -10, 1, -10)
SF.Position = UDim2.new(0, 5, 0, 5)
SF.BackgroundColor3 = Color3.fromRGB(5, 4, 8)
SF.BorderSizePixel = 0
SF.CanvasSize = UDim2.new(0, 0, 0, 0)
SF.ScrollBarThickness = 4

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

-- Слушатели событий логов
LogService.MessageOut:Connect(function(message, messageType) 
    local isErr = (messageType == Enum.MessageType.MessageError)
    printToUI(message, isErr)
end)

pcall(function() 
    for _, log in ipairs(LogService:GetLogHistory()) do 
        local isErr = (log.messageType == Enum.MessageType.MessageError)
        printToUI(log.message, isErr)
    end 
end)

-- Фоновая обработка бесконечного прыжка
UIS.JumpRequest:Connect(function() 
    if getgenv().Hacks.InfJump and LP.Character then 
        local h = LP.Character:FindFirstChildOfClass("Humanoid") 
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
    end 
end)

-- Сервисный поток физики (Обход скорости + Полет)
RS.Heartbeat:Connect(function() 
    pcall(function() 
        if LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid") 
            local torso = LP.Character:FindFirstChild("HumanoidRootPart") 
            
            -- Стабильное CFrame ускорение
            if getgenv().Hacks.Speed and hum and torso and hum.MoveDirection.Magnitude > 0 then 
                torso.CFrame = torso.CFrame + (hum.MoveDirection * 2.5) 
            end 
            
            -- Стабильный полет
            if getgenv().Hacks.Fly and torso and torso:FindFirstChild("V5_Fly") and hum then 
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then 
                    torso.V5_Fly.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().flySpeed 
                else 
                    torso.V5_Fly.Velocity = Vector3.new(0,0,0) 
                end 
            end
        end
    end) 
end)

printToUI("Гитхаб-скрипт VegaXploits v3.1 успешно загружен!", false)
