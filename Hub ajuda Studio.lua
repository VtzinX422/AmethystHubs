local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Limpeza total
for _, v in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
    if v.Name == "VoidAmethyst_Final_Vtzin" then v:Destroy() end
end

local pontoA, cuboPreview, conexaoUpdate, flyAtivo, bv, bg
local velocidadeFly = 95
local corAcento = Color3.fromRGB(138, 43, 226)

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "VoidAmethyst_Final_Vtzin"; screenGui.ResetOnSpawn = false; screenGui.DisplayOrder = 100000

-- Função para pegar a posição dos pés
local function getFeetPos()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        -- Ajuste médio de 3 studs para baixo do centro do root (pés)
        return root.Position - Vector3.new(0, 3, 0)
    end
    return Vector3.new(0, 0, 0)
end

-- ==========================================
-- 1. INTERFACE DE COORDENADAS FIXA (MUITO MAIS PARA CIMA)
-- ==========================================
local realTimeFrame = Instance.new("Frame", screenGui)
realTimeFrame.Size = UDim2.new(0, 180, 0, 45)
realTimeFrame.Position = UDim2.new(0.5, -90, 0, -15) -- Subiu muito
realTimeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
realTimeFrame.BorderSizePixel = 0
Instance.new("UICorner", realTimeFrame).CornerRadius = UDim.new(0, 8)
local rtStroke = Instance.new("UIStroke", realTimeFrame); rtStroke.Color = corAcento; rtStroke.Thickness = 1.5

local rtLabel = Instance.new("TextLabel", realTimeFrame)
rtLabel.Size = UDim2.new(1, 0, 1, 0); rtLabel.BackgroundTransparency = 1
rtLabel.TextColor3 = Color3.new(1, 1, 1); rtLabel.Font = Enum.Font.Code; rtLabel.TextSize = 12; rtLabel.RichText = true
rtLabel.Text = "X: 0 | Y: 0 | Z: 0"

RunService.RenderStepped:Connect(function()
    local pos = getFeetPos()
    rtLabel.Text = string.format("<font color='#FF4B4B'>X: %.1f</font>  <font color='#4BFF4B'>Y: %.1f</font>  <font color='#4B4BFF'>Z: %.1f</font>", pos.X, pos.Y, pos.Z)
end)

-- ==========================================
-- 2. INTERFACE PRINCIPAL (MAIS PARA CIMA)
-- ==========================================
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 380, 0, 200)
mainFrame.Position = UDim2.new(0.5, -190, 0, 30) -- Subiu para 30
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame); mainStroke.Color = corAcento; mainStroke.Thickness = 2

-- TITLE BAR
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 35); titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30); titleBar.ZIndex = 5
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleTxt = Instance.new("TextLabel", titleBar)
titleTxt.Name = "TitleText"
titleTxt.Text = "  VoidAmethyst Hub Studio 1"; titleTxt.Size = UDim2.new(0.6, 0, 1, 0)
titleTxt.Position = UDim2.new(0, 0, 0, 0)
titleTxt.TextColor3 = Color3.new(1,1,1); titleTxt.BackgroundTransparency = 1; titleTxt.Font = Enum.Font.SourceSansBold; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 6
titleTxt.TextSize = 17 -- Ajustado conforme pedido para ficar menor

local devTxt = Instance.new("TextLabel", titleBar)
devTxt.Name = "DevText"
devTxt.Text = "⚙️ Dev Vtzin x | ©VTG solutions"
devTxt.Size = UDim2.new(0.4, 0, 0.8, 0)
devTxt.AnchorPoint = Vector2.new(0.5, 0.5); devTxt.Position = UDim2.new(0.55, 0, 0.5, 0)
devTxt.TextColor3 = Color3.fromRGB(60, 60, 80)
devTxt.TextTransparency = 0.5 
devTxt.BackgroundTransparency = 1; devTxt.Font = Enum.Font.SourceSansItalic; devTxt.TextSize = 10; devTxt.ZIndex = 6

local btnClose = Instance.new("TextButton", titleBar)
btnClose.Text = "X"; btnClose.Size = UDim2.new(0, 30, 0, 30); btnClose.Position = UDim2.new(1, -35, 0, 2.5)
btnClose.TextColor3 = Color3.new(1,1,1); btnClose.BackgroundTransparency = 1; btnClose.TextSize = 18; btnClose.Font = Enum.Font.SourceSansBold; btnClose.ZIndex = 7

local btnMin = Instance.new("TextButton", titleBar)
btnMin.Text = "-"; btnMin.Size = UDim2.new(0, 30, 0, 30); btnMin.Position = UDim2.new(1, -65, 0, 2.5)
btnMin.TextColor3 = Color3.new(1,1,1); btnMin.BackgroundTransparency = 1; btnMin.TextSize = 25; btnMin.Font = Enum.Font.SourceSansBold; btnMin.ZIndex = 7

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

-- PAINEL DE SALVAMENTO
local saveFrame = Instance.new("Frame", mainFrame)
saveFrame.Size = UDim2.new(1, 0, 1, -35); saveFrame.Position = UDim2.new(0, 0, 0, 35)
saveFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15); saveFrame.Visible = false; saveFrame.ZIndex = 100
Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 12)

local lblAviso = Instance.new("TextLabel", saveFrame)
lblAviso.Text = "Escreva seu título"; lblAviso.Size = UDim2.new(1, 0, 0, 30); lblAviso.Position = UDim2.new(0, 0, 0.1, 0); lblAviso.TextColor3 = Color3.new(1, 1, 1); lblAviso.BackgroundTransparency = 1; lblAviso.Font = Enum.Font.SourceSansBold; lblAviso.ZIndex = 101

local txtInput = Instance.new("TextBox", saveFrame)
txtInput.Size = UDim2.new(0.7, 0, 0, 30); txtInput.Position = UDim2.new(0.15, 0, 0.35, 0); txtInput.Text = ""; txtInput.PlaceholderText = "Digita aqui..."; txtInput.TextColor3 = Color3.new(1,1,1); txtInput.BackgroundTransparency = 1; txtInput.Font = Enum.Font.SourceSans; txtInput.TextSize = 18; txtInput.ZIndex = 101

local linha = Instance.new("Frame", txtInput); linha.Size = UDim2.new(1, 0, 0, 2); linha.Position = UDim2.new(0, 0, 1, 0); linha.BackgroundColor3 = corAcento; linha.BorderSizePixel = 0; linha.ZIndex = 101

local btnCopyFinal = Instance.new("TextButton", saveFrame)
btnCopyFinal.Size = UDim2.new(0.6, 0, 0, 40); btnCopyFinal.Position = UDim2.new(0.2, 0, 0.65, 0); btnCopyFinal.Text = "COPIAR COORDENADAS"; btnCopyFinal.BackgroundColor3 = corAcento; btnCopyFinal.TextColor3 = Color3.new(1,1,1); btnCopyFinal.Font = Enum.Font.SourceSansBold; btnCopyFinal.ZIndex = 101
Instance.new("UICorner", btnCopyFinal).CornerRadius = UDim.new(0, 8)

local btnVoltarSave = Instance.new("TextButton", saveFrame)
btnVoltarSave.Text = "X"; btnVoltarSave.Size = UDim2.new(0, 30, 0, 30); btnVoltarSave.Position = UDim2.new(1, -35, 0, 5); btnVoltarSave.TextColor3 = Color3.fromRGB(255, 50, 50); btnVoltarSave.BackgroundTransparency = 1; btnVoltarSave.TextSize = 22; btnVoltarSave.ZIndex = 102

-- BOTÕES DE AÇÃO
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, 0, 0, 50); container.Position = UDim2.new(0, 0, 1, -55); container.BackgroundTransparency = 1

local function criarBtn(txt, pos, cor)
    local b = Instance.new("TextButton", container); b.Text = txt
    b.Size = UDim2.new(0.18, 0, 0, 35); b.Position = pos; b.BackgroundColor3 = cor
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end
local btnM = criarBtn("MARCAR", UDim2.new(0.02, 0, 0, 0), Color3.fromRGB(46, 204, 113))
local btnF = criarBtn("FECHAR", UDim2.new(0.21, 0, 0, 0), Color3.fromRGB(52, 152, 219))
local btnS = criarBtn("SALVAR", UDim2.new(0.40, 0, 0, 0), corAcento)
local btnL = criarBtn("LIMPAR", UDim2.new(0.59, 0, 0, 0), Color3.fromRGB(231, 76, 60))
local btnFly = criarBtn("FLY: OFF", UDim2.new(0.78, 0, 0, 0), Color3.fromRGB(40,40,40))

-- FLY (LÓGICA MOBILE)
RunService.RenderStepped:Connect(function()
    if flyAtivo and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local relativeDir = camera.CFrame:VectorToObjectSpace(moveDir)
            bv.Velocity = (camera.CFrame.LookVector * -relativeDir.Z + camera.CFrame.RightVector * relativeDir.X).Unit * velocidadeFly
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
        bg.CFrame = camera.CFrame
    end
end)

-- LOGICA INTERFACE
btnS.MouseButton1Click:Connect(function() saveFrame.Visible = true end)
btnVoltarSave.MouseButton1Click:Connect(function() saveFrame.Visible = false end)

btnCopyFinal.MouseButton1Click:Connect(function()
    local titulo = txtInput.Text ~= "" and txtInput.Text or "Sem Título"
    local function clean(t) return t:gsub("<[^>]+>", ""):gsub("INÍCIO\n", ""):gsub("MEIO\n", ""):gsub("FIM\n", "") end
    local final = "Título: "..titulo.."\n\nPrimeiro pixel:\n"..clean(lblI.Text).."\nCentro da bloco:\n"..clean(lblM.Text).."\nÚltimo pixel:\n"..clean(lblF.Text).."\n\nCopiado do Hub VoidAmethyst Studio"
    if setclipboard then setclipboard(final) end
    saveFrame.Visible = false
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
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
    end
end)

local function format(v) return string.format("<font color='#FF4B4B'>X: %.1f</font>\n<font color='#4BFF4B'>Y: %.1f</font>\n<font color='#4B4BFF'>Z: %.1f</font>", v.X, v.Y, v.Z) end

btnM.MouseButton1Click:Connect(function()
    pontoA = getFeetPos()
    lblI.Text = "<b>INÍCIO</b>\n"..format(pontoA)
    if conexaoUpdate then conexaoUpdate:Disconnect() end
    conexaoUpdate = RunService.RenderStepped:Connect(function()
        if not pontoA then return end
        local pB = getFeetPos()
        local centro = pontoA:Lerp(pB, 0.5)
        if not cuboPreview then 
            cuboPreview = Instance.new("Part", workspace); cuboPreview.Anchored = true; cuboPreview.CanCollide = false
            cuboPreview.Material = Enum.Material.ForceField; cuboPreview.Color = corAcento; cuboPreview.Transparency = 0.5
            local out = Instance.new("SelectionBox", cuboPreview); out.Adornee = cuboPreview; out.Color3 = corAcento; out.LineThickness = 0.15
        end
        cuboPreview.Size = Vector3.new(math.abs(pontoA.X-pB.X), math.abs(pontoA.Y-pB.Y), math.abs(pontoA.Z-pB.Z))
        cuboPreview.CFrame = CFrame.new(centro); lblM.Text = "<b>MEIO</b>\n"..format(centro)
    end)
end)

btnF.MouseButton1Click:Connect(function() if conexaoUpdate then conexaoUpdate:Disconnect() end; lblF.Text = "<b>FIM</b>\n"..format(getFeetPos()) end)

btnL.MouseButton1Click:Connect(function()
    if cuboPreview then cuboPreview:Destroy(); cuboPreview = nil end; pontoA = nil
    local r = "<b>...</b>\n<font color='#FF4B4B'>X: 0.0</font>\n<font color='#4BFF4B'>Y: 0.0</font>\n<font color='#4B4BFF'>Z: 0.0</font>"
    lblI.Text="<b>INÍCIO</b>\n"..r; lblM.Text="<b>MEIO</b>\n"..r; lblF.Text="<b>FIM</b>\n"..r
end)

-- DIAMANTE 💎
local btnExt = Instance.new("TextButton", screenGui)
btnExt.Size = UDim2.new(0, 50, 0, 50); btnExt.Position = UDim2.new(1, -60, 0.05, 0); btnExt.BackgroundColor3 = Color3.fromRGB(15,15,20); btnExt.Text = "💎"; btnExt.TextSize = 25; btnExt.ZIndex = 100000
Instance.new("UICorner", btnExt).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", btnExt).Color = corAcento
btnExt.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

btnMin.MouseButton1Click:Connect(function()
    local abrindo = (btnMin.Text == "+")
    btnMin.Text = abrindo and "-" or "+"
    mainFrame:TweenSize(abrindo and UDim2.new(0, 380, 0, 200) or UDim2.new(0, 380, 0, 35), "Out", "Quart", 0.3, true)
    container.Visible = abrindo; lblI.Visible = abrindo; lblM.Visible = abrindo; lblF.Visible = abrindo; devTxt.Visible = abrindo
end)
btnClose.MouseButton1Click:Connect(function() screenGui:Destroy() end)
