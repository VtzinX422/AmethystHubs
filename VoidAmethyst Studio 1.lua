local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Limpeza de versões anteriores
local CoreGui = game:GetService("CoreGui")
local targetGui = player:WaitForChild("PlayerGui")
for _, v in pairs(targetGui:GetChildren()) do
    if v.Name == "VoidAmethyst_Final_Vtzin" then v:Destroy() end
end

local pontoA, pontoMeio, pontoB, cuboSize, cuboPreview, conexaoUpdate, flyAtivo, bv, bg
local velocidadeFly = 95
local corAcento = Color3.fromRGB(138, 43, 226) -- Roxo Ametista

local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "VoidAmethyst_Final_Vtzin"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100000

-- FUNÇÃO DE ARRASTE (Trazida do Studio 2 - Anti-Pulo Mobile)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- Função para pegar a posição dos pés
local function getFeetPos()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        return root.Position - Vector3.new(0, 3, 0)
    end
    return Vector3.new(0, 0, 0)
end

-- ==========================================
-- 1. INTERFACE DE COORDENADAS FIXA (TOPO)
-- ==========================================
local realTimeFrame = Instance.new("Frame", screenGui)
realTimeFrame.Size = UDim2.new(0, 180, 0, 45); realTimeFrame.Position = UDim2.new(0.5, -90, 0, 15) 
realTimeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15); realTimeFrame.BorderSizePixel = 0
Instance.new("UICorner", realTimeFrame).CornerRadius = UDim.new(0, 8)
local rtStroke = Instance.new("UIStroke", realTimeFrame); rtStroke.Color = corAcento; rtStroke.Thickness = 1.5
makeDraggable(realTimeFrame)

local rtLabel = Instance.new("TextLabel", realTimeFrame)
rtLabel.Size = UDim2.new(1, 0, 1, 0); rtLabel.BackgroundTransparency = 1; rtLabel.TextColor3 = Color3.new(1, 1, 1)
rtLabel.Font = Enum.Font.Code; rtLabel.TextSize = 12; rtLabel.RichText = true; rtLabel.Text = "X: 0 | Y: 0 | Z: 0"

local btnCopyRT = Instance.new("TextButton", realTimeFrame)
btnCopyRT.Size = UDim2.new(0, 50, 0, 20); btnCopyRT.Position = UDim2.new(1, -55, 1, -20)
btnCopyRT.BackgroundTransparency = 1; btnCopyRT.Text = "copiar"; btnCopyRT.TextColor3 = Color3.fromRGB(0, 120, 255)
btnCopyRT.TextSize = 11; btnCopyRT.Font = Enum.Font.SourceSansBold

btnCopyRT.MouseButton1Click:Connect(function()
    local pos = getFeetPos()
    local text = string.format("Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
    if setclipboard then setclipboard(text) end
    btnCopyRT.Text = "copiado"; task.wait(3); btnCopyRT.Text = "copiar"
end)

RunService.RenderStepped:Connect(function()
    local pos = getFeetPos()
    rtLabel.Text = string.format("<font color='#FF4B4B'>X: %.1f</font>  <font color='#4BFF4B'>Y: %.1f</font>  <font color='#4B4BFF'>Z: %.1f</font>", pos.X, pos.Y, pos.Z)
end)

-- ==========================================
-- 2. INTERFACE PRINCIPAL
-- ==========================================
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 380, 0, 200); mainFrame.Position = UDim2.new(0.5, -190, 0, 80) 
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18); mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame); mainStroke.Color = corAcento; mainStroke.Thickness = 2
makeDraggable(mainFrame) -- Adicionado para não atrapalhar no mobile!

-- TITLE BAR
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 35); titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30); titleBar.ZIndex = 5
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleTxt = Instance.new("TextLabel", titleBar)
titleTxt.Text = "  VoidAmethyst Hub | Studio 1"; titleTxt.Size = UDim2.new(0.4, 0, 1, 0); titleTxt.TextColor3 = Color3.new(1,1,1)
titleTxt.BackgroundTransparency = 1; titleTxt.Font = Enum.Font.SourceSansBold; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 6; titleTxt.TextSize = 16

local devTxt = Instance.new("TextLabel", titleBar)
devTxt.Text = "⚙️ Dev Vtzin x | ©VTG solutions"; devTxt.Size = UDim2.new(0.4, 0, 1, 0); devTxt.Position = UDim2.new(0.35, 0, 0, 0) 
devTxt.TextColor3 = Color3.fromRGB(60, 60, 80); devTxt.TextTransparency = 0.5; devTxt.BackgroundTransparency = 1; devTxt.Font = Enum.Font.SourceSansItalic; devTxt.TextSize = 10; devTxt.ZIndex = 6

local btnClose = Instance.new("TextButton", titleBar)
btnClose.Text = "X"; btnClose.Size = UDim2.new(0, 30, 0, 30); btnClose.Position = UDim2.new(1, -35, 0, 2.5); btnClose.TextColor3 = Color3.new(1,1,1); btnClose.BackgroundTransparency = 1; btnClose.TextSize = 18; btnClose.Font = Enum.Font.SourceSansBold; btnClose.ZIndex = 7

local btnMin = Instance.new("TextButton", titleBar)
btnMin.Text = "-"; btnMin.Size = UDim2.new(0, 30, 0, 30); btnMin.Position = UDim2.new(1, -65, 0, 2.5); btnMin.TextColor3 = Color3.new(1,1,1); btnMin.BackgroundTransparency = 1; btnMin.TextSize = 25; btnMin.Font = Enum.Font.SourceSansBold; btnMin.ZIndex = 7

-- LABELS COORDENADAS
local function criarLabel(txt, pos)
    local l = Instance.new("TextLabel", mainFrame)
    l.Size = UDim2.new(0.3, 0, 0, 90); l.Position = pos; l.TextColor3 = Color3.new(1, 1, 1); l.RichText = true; l.TextSize = 12; l.BackgroundTransparency = 1; l.Font = Enum.Font.Code
    l.Text = "<b>"..txt.."</b>\n<font color='#FF4B4B'>X: 0.0</font>\n<font color='#4BFF4B'>Y: 0.0</font>\n<font color='#4B4BFF'>Z: 0.0</font>"
    return l
end
local lblI = criarLabel("INÍCIO", UDim2.new(0.05, 0, 0, 45))
local lblM = criarLabel("MEIO", UDim2.new(0.38, 0, 0, 45))
local lblF = criarLabel("FIM", UDim2.new(0.7, 0, 0, 45))

-- BOTÕES DE AÇÃO
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, 0, 0, 50); container.Position = UDim2.new(0, 0, 1, -55); container.BackgroundTransparency = 1

local function criarBtn(txt, pos, cor)
    local b = Instance.new("TextButton", container); b.Text = txt; b.Size = UDim2.new(0.18, 0, 0, 35); b.Position = pos; b.BackgroundColor3 = cor; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 10; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); return b
end

local btnMarcar = criarBtn("MARCAR", UDim2.new(0.02, 0, 0, 0), Color3.fromRGB(46, 204, 113))
local btnFechar = criarBtn("FECHAR", UDim2.new(0.21, 0, 0, 0), Color3.fromRGB(52, 152, 219))
local btnCopiarMain = criarBtn("COPIAR", UDim2.new(0.40, 0, 0, 0), corAcento)
local btnLimpar = criarBtn("LIMPAR", UDim2.new(0.59, 0, 0, 0), Color3.fromRGB(231, 76, 60))
local btnFly = criarBtn("FLY: OFF", UDim2.new(0.78, 0, 0, 0), Color3.fromRGB(40,40,40))

-- COPIAR PRO (FORMATO DE SCRIPT)
btnCopiarMain.MouseButton1Click:Connect(function()
    if not pontoA or not pontoB or not pontoMeio then return end
    
    local exportTxt = string.format(
        "-- [[ VoidAmethyst World Data ]]\nlocal PosInicial = Vector3.new(%.2f, %.2f, %.2f)\nlocal PosFinal = Vector3.new(%.2f, %.2f, %.2f)\nlocal CaixaSize = Vector3.new(%.2f, %.2f, %.2f)\nlocal CaixaCFrame = CFrame.new(%.2f, %.2f, %.2f)",
        pontoA.X, pontoA.Y, pontoA.Z,
        pontoB.X, pontoB.Y, pontoB.Z,
        cuboSize.X, cuboSize.Y, cuboSize.Z,
        pontoMeio.X, pontoMeio.Y, pontoMeio.Z
    )
    
    if setclipboard then setclipboard(exportTxt) end
    btnCopiarMain.Text = "COPIADO"; task.wait(3); btnCopiarMain.Text = "COPIAR"
end)

-- MARCAÇÃO (ROXO AMETISTA SÓLIDO)
local function formatUI(v) return string.format("<font color='#FF4B4B'>X: %.1f</font>\n<font color='#4BFF4B'>Y: %.1f</font>\n<font color='#4B4BFF'>Z: %.1f</font>", v.X, v.Y, v.Z) end

btnMarcar.MouseButton1Click:Connect(function()
    pontoA = getFeetPos()
    lblI.Text = "<b>INÍCIO</b>\n"..formatUI(pontoA)
    if conexaoUpdate then conexaoUpdate:Disconnect() end
    
    conexaoUpdate = RunService.RenderStepped:Connect(function()
        if not pontoA then return end
        local pAtual = getFeetPos()
        pontoMeio = pontoA:Lerp(pAtual, 0.5)
        cuboSize = Vector3.new(math.abs(pontoA.X-pAtual.X), math.abs(pontoA.Y-pAtual.Y), math.abs(pontoA.Z-pAtual.Z))
        
        if not cuboPreview then 
            cuboPreview = Instance.new("Part", workspace); cuboPreview.Anchored = true; cuboPreview.CanCollide = false; cuboPreview.Material = Enum.Material.ForceField; cuboPreview.Color = corAcento; cuboPreview.Transparency = 0.5
            local out = Instance.new("SelectionBox", cuboPreview); out.Adornee = cuboPreview; out.Color3 = corAcento; out.LineThickness = 0.15
        end
        
        cuboPreview.Size = cuboSize
        cuboPreview.CFrame = CFrame.new(pontoMeio)
        lblM.Text = "<b>MEIO</b>\n"..formatUI(pontoMeio)
    end)
end)

btnFechar.MouseButton1Click:Connect(function() 
    if conexaoUpdate then conexaoUpdate:Disconnect() end
    pontoB = getFeetPos()
    lblF.Text = "<b>FIM</b>\n"..formatUI(pontoB) 
end)

btnLimpar.MouseButton1Click:Connect(function() 
    if cuboPreview then cuboPreview:Destroy(); cuboPreview = nil end
    pontoA = nil; pontoB = nil; pontoMeio = nil; cuboSize = nil
    lblI.Text = "<b>INÍCIO</b>\n<font color='#FF4B4B'>X: 0.0</font>\n<font color='#4BFF4B'>Y: 0.0</font>\n<font color='#4B4BFF'>Z: 0.0</font>"
    lblM.Text = "<b>MEIO</b>\n<font color='#FF4B4B'>X: 0.0</font>\n<font color='#4BFF4B'>Y: 0.0</font>\n<font color='#4B4BFF'>Z: 0.0</font>"
    lblF.Text = "<b>FIM</b>\n<font color='#FF4B4B'>X: 0.0</font>\n<font color='#4BFF4B'>Y: 0.0</font>\n<font color='#4B4BFF'>Z: 0.0</font>"
end)

-- FLY LÓGICA
RunService.RenderStepped:Connect(function()
    if flyAtivo and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local moveDir = player.Character.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local rel = camera.CFrame:VectorToObjectSpace(moveDir)
            bv.Velocity = (camera.CFrame.LookVector * -rel.Z + camera.CFrame.RightVector * rel.X).Unit * velocidadeFly
        else bv.Velocity = Vector3.new(0,0,0) end
        bg.CFrame = camera.CFrame
    end
end)

btnFly.MouseButton1Click:Connect(function()
    flyAtivo = not flyAtivo
    if flyAtivo then
        btnFly.Text = "FLY: ON"; btnFly.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        bg = Instance.new("BodyGyro", player.Character.HumanoidRootPart); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.P = 15000
        player.Character.Humanoid.PlatformStand = true
    else
        btnFly.Text = "FLY: OFF"; btnFly.BackgroundColor3 = Color3.fromRGB(40,40,40)
        if bv then bv:Destroy() end; if bg then bg:Destroy() end
        player.Character.Humanoid.PlatformStand = false
    end
end)

-- MINIMIZAR / FECHAR
local btnExt = Instance.new("TextButton", screenGui); btnExt.Size = UDim2.new(0, 50, 0, 50); btnExt.Position = UDim2.new(1, -60, 0.05, 0); btnExt.BackgroundColor3 = Color3.fromRGB(15,15,20); btnExt.Text = "💎"; btnExt.ZIndex = 100000; Instance.new("UICorner", btnExt).CornerRadius = UDim.new(1, 0); makeDraggable(btnExt)
btnExt.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
btnMin.MouseButton1Click:Connect(function() local a = (btnMin.Text == "+"); btnMin.Text = a and "-" or "+"; mainFrame:TweenSize(a and UDim2.new(0, 380, 0, 200) or UDim2.new(0, 380, 0, 35), "Out", "Quart", 0.3, true); container.Visible = a; lblI.Visible = a; lblM.Visible = a; lblF.Visible = a; devTxt.Visible = a end)
btnClose.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ==========================================
-- CRÉDITOS E MENSAGENS FINAIS
-- ==========================================
-- Vlw pela atenção! Caso esteja lendo esse código, ele foi feito para ajudar o Vtzin x a mapear o MM2 e trazer os melhores scripts com mais precisão 🫶🏽
-- Dia 11 de dezembro de 2025 foi o dia que a paixão pela programação acendeu e os projetos malucos nasceram 💖
-- #vtzin_x #©VTG solutions #VoidAmethyst Hub
