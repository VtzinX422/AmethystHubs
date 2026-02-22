local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Limpeza de segurança
if CoreGui:FindFirstChild("VoidAmethyst_V12") then CoreGui.VoidAmethyst_V12:Destroy() end

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "VoidAmethyst_V12"
MainGui.Parent = CoreGui
MainGui.IgnoreGuiInset = true 
MainGui.DisplayOrder = 999

-- 1. FUNDO PRETO
local Blackout = Instance.new("Frame")
Blackout.Size = UDim2.new(1, 0, 1, 0)
Blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Blackout.Active = true
Blackout.ZIndex = 1
Blackout.Parent = MainGui

local RoxoStudio = Color3.fromRGB(150, 0, 255)
local CorRed = Color3.fromRGB(255, 50, 50)
local CorBlue = Color3.fromRGB(50, 100, 255)

-- 2. TEXTOS CENTRAIS
local function createCenterText(text, pos, size)
    local l = Instance.new("TextLabel", Blackout)
    l.Text = text; l.Position = pos; l.Size = UDim2.new(0, 400, 0, 30)
    l.TextColor3 = RoxoStudio; l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold; l.TextSize = size; l.ZIndex = 2
    return l
end
createCenterText("VoidAmethyst Studio 2", UDim2.new(0.5, -200, 0.38, 0), 28)
createCenterText("Button placement & size", UDim2.new(0.5, -200, 0.45, 0), 16)

-- 3. STATUS LABELS
local function createInfo(text, pos, color)
    local l = Instance.new("TextLabel", Blackout)
    l.Text = text; l.Position = pos; l.Size = UDim2.new(0, 200, 0, 22)
    l.TextColor3 = color; l.BackgroundTransparency = 1; l.Font = Enum.Font.Code; l.TextSize = 18; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 2
    return l
end
createInfo("Cord posicionamento:", UDim2.new(0.05, 0, 0.05, 0), Color3.new(1,1,1))
local LX = createInfo("X: 0", UDim2.new(0.05, 0, 0.10, 0), CorRed)
local LY = createInfo("Y: 0", UDim2.new(0.05, 0, 0.14, 0), CorBlue)
createInfo("Tamanho do botão:", UDim2.new(0.05, 0, 0.78, 0), Color3.new(1,1,1))
local LW = createInfo("Largura: 0", UDim2.new(0.05, 0, 0.83, 0), CorRed)
local LH = createInfo("Altura: 0", UDim2.new(0.05, 0, 0.87, 0), CorBlue)

-- NOTIFICAÇÃO "COPIADO!"
local Notify = Instance.new("TextLabel", Blackout)
Notify.Text = "copiado!"
Notify.Size = UDim2.new(0, 100, 0, 30)
Notify.Position = UDim2.new(0.5, -50, 0.9, 0)
Notify.TextColor3 = Color3.new(1, 1, 1)
Notify.BackgroundTransparency = 1
Notify.Font = Enum.Font.GothamBold
Notify.TextSize = 20
Notify.Visible = false
Notify.ZIndex = 5

-- 4. FUNÇÃO DE ARRASTE (VERSÃO PRO PARA MOBILE)
local function makeDraggable(obj)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- 5. BOTÃO PRINCIPAL
local SelectedObject = nil 
local clones = {}

local MainBtn = Instance.new("TextButton", MainGui)
MainBtn.Size = UDim2.new(0, 180, 0, 80); MainBtn.Position = UDim2.new(0.5, -90, 0.6, 0)
MainBtn.BackgroundColor3 = RoxoStudio; MainBtn.BackgroundTransparency = 0.1; MainBtn.Text = ""; MainBtn.ZIndex = 10
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 15)
makeDraggable(MainBtn)

local InnerText = Instance.new("TextLabel", MainBtn)
InnerText.Text = "Script para visualizar e ajustar\na posição dos botões na tela"
InnerText.Size = UDim2.new(0.9, 0, 0.9, 0); InnerText.Position = UDim2.new(0.05, 0, 0.05, 0)
InnerText.TextColor3 = Color3.fromRGB(220, 220, 220); InnerText.BackgroundTransparency = 1; InnerText.TextSize = 11; InnerText.TextWrapped = true; InnerText.ZIndex = 11

SelectedObject = MainBtn

-- 📄 COPIAR INTERNO
local CopyBtn = Instance.new("TextButton", MainBtn)
CopyBtn.Text = "📄"; CopyBtn.Size = UDim2.new(0, 12, 0, 12); CopyBtn.Position = UDim2.new(1, -18, 0.1, 0)
CopyBtn.BackgroundTransparency = 1; CopyBtn.TextColor3 = Color3.new(1,1,1); CopyBtn.TextSize = 10; CopyBtn.ZIndex = 15

-- 6. ÍCONES DO TOPO
local function createTopBtn(text, pos)
    local b = Instance.new("TextButton", Blackout)
    b.Text = text; b.Position = pos; b.Size = UDim2.new(0, 22, 0, 22); b.BackgroundTransparency = 1; b.TextColor3 = Color3.new(1,1,1); b.TextSize = 18; b.ZIndex = 10
    return b
end

local Toggle = createTopBtn("🔮", UDim2.new(0.96, 0, 0.02, 0))
local Min = createTopBtn("-", UDim2.new(0.93, 0, 0.02, 0))
local DelBtn = createTopBtn("❌", UDim2.new(0.89, 0, 0.02, 0))
local ReportBtn = createTopBtn("📄", UDim2.new(0.85, 0, 0.02, 0))
local EditBtn = createTopBtn("✏️", UDim2.new(0.81, 0, 0.02, 0))

local FeedbackImg = Instance.new("ImageLabel", ReportBtn)
FeedbackImg.Size = UDim2.new(1, 0, 1, 0); FeedbackImg.BackgroundTransparency = 1; FeedbackImg.Image = "rbxassetid://95904604481619"; FeedbackImg.Visible = false; FeedbackImg.ZIndex = 11

DelBtn.Visible = false; EditBtn.Visible = false; ReportBtn.Visible = false

-- 7. BOTÃO MAXIMIZAR
local MaxBtn = Instance.new("TextButton", MainGui)
MaxBtn.Text = "+"; MaxBtn.Size = UDim2.new(0, 35, 0, 35); MaxBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
MaxBtn.BackgroundColor3 = RoxoStudio; MaxBtn.TextColor3 = Color3.new(1,1,1); MaxBtn.Visible = false; MaxBtn.ZIndex = 50
Instance.new("UICorner", MaxBtn).CornerRadius = UDim.new(1,0)
makeDraggable(MaxBtn)

-- LÓGICA DE MINIMIZAR/MAXIMIZAR
Min.MouseButton1Click:Connect(function()
    Blackout.Visible = false; MainBtn.Visible = false; MaxBtn.Visible = true
end)

MaxBtn.MouseButton1Click:Connect(function()
    Blackout.Visible = true; MainBtn.Visible = true; MaxBtn.Visible = false
end)

-- 8. INPUT DE NOME
local NameInput = Instance.new("Frame", MainGui)
NameInput.Size = UDim2.new(0, 200, 0, 70); NameInput.Position = UDim2.new(0.5, -100, 0.2, 0); NameInput.BackgroundColor3 = Color3.fromRGB(30,30,30); NameInput.Visible = false; NameInput.ZIndex = 100
Instance.new("UICorner", NameInput)
local TextBox = Instance.new("TextBox", NameInput); TextBox.Size = UDim2.new(0.8, 0, 0, 25); TextBox.Position = UDim2.new(0.1, 0, 0.5, 0); TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50); TextBox.TextColor3 = Color3.new(1,1,1); TextBox.Text = ""

-- RESIZE HANDLE
local HandleBR = Instance.new("TextButton", MainBtn)
HandleBR.Text = "↘"; HandleBR.Size = UDim2.new(0, 25, 0, 25); HandleBR.Position = UDim2.new(1, -25, 1, -25); HandleBR.BackgroundTransparency = 1; HandleBR.TextColor3 = Color3.new(1,1,1); HandleBR.TextSize = 22; HandleBR.ZIndex = 12

HandleBR.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then resizing = true end end)
UIS.InputEnded:Connect(function(i) resizing = false end)
UIS.InputChanged:Connect(function(i)
    if resizing and i.UserInputType == Enum.UserInputType.Touch then
        MainBtn.Size = UDim2.new(0, math.max(60, i.Position.X - MainBtn.AbsolutePosition.X), 0, math.max(40, i.Position.Y - MainBtn.AbsolutePosition.Y))
    end
end)

-- LÓGICA COPIAR NO BOTÃO PRINCIPAL
CopyBtn.MouseButton1Click:Connect(function()
    local Clone = MainBtn:Clone(); Clone.Parent = MainGui; Clone.ZIndex = 5; Clone.Draggable = false; Clone.BackgroundTransparency = 0.7
    Clone:ClearAllChildren(); Instance.new("UICorner", Clone).CornerRadius = MainBtn.UICorner.CornerRadius
    Clone.Text = "Botão cópia "..(#clones + 1); Clone.TextColor3 = Color3.new(1,1,1); Clone.Font = Enum.Font.GothamBold; Clone.TextSize = 10
    Clone.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(100,255))
    table.insert(clones, Clone)
    Clone.MouseButton1Click:Connect(function() SelectedObject = Clone; DelBtn.Visible = true; EditBtn.Visible = true; ReportBtn.Visible = true end)
end)

-- LÓGICA EXPORTAR (COM A MATEMÁTICA CORRETA)
ReportBtn.MouseButton1Click:Connect(function()
    if SelectedObject and SelectedObject ~= MainBtn then
        local pX = SelectedObject.AbsolutePosition.X / MainGui.AbsoluteSize.X
        local pY = SelectedObject.AbsolutePosition.Y / MainGui.AbsoluteSize.Y
        local sX = SelectedObject.AbsoluteSize.X / MainGui.AbsoluteSize.X
        local sY = SelectedObject.AbsoluteSize.Y / MainGui.AbsoluteSize.Y
        
        local txtPos = string.format("UDim2.new(%.3f, 0, %.3f, 0)", pX, pY)
        local txtSize = string.format("UDim2.new(%.3f, 0, %.3f, 0)", sX, sY)
        local txtCompleto = string.format("Nome: %s\nPos: %s\nSize: %s", SelectedObject.Text, txtPos, txtSize)
        
        setclipboard(txtCompleto)
        
        ReportBtn.Text = ""; FeedbackImg.Visible = true; Notify.Visible = true
        task.delay(3, function() ReportBtn.Text = "📄"; FeedbackImg.Visible = false; Notify.Visible = false end)
    end
end)

-- LÓGICA ❌ E ✏️
DelBtn.MouseButton1Click:Connect(function()
    if SelectedObject and SelectedObject ~= MainBtn then
        for i, v in ipairs(clones) do if v == SelectedObject then table.remove(clones, i) break end end
        SelectedObject:Destroy(); SelectedObject = MainBtn; DelBtn.Visible = false; EditBtn.Visible = false; ReportBtn.Visible = false
    end
end)

EditBtn.MouseButton1Click:Connect(function() if SelectedObject ~= MainBtn then NameInput.Visible = true; TextBox:CaptureFocus() end end)
TextBox.FocusLost:Connect(function(enter) if enter and SelectedObject then SelectedObject.Text = TextBox.Text end; NameInput.Visible = false; TextBox.Text = "" end)

-- LOOP DE ATUALIZAÇÃO
RunService.RenderStepped:Connect(function()
    if SelectedObject then
        LX.Text = "X: "..math.floor(SelectedObject.AbsolutePosition.X); LY.Text = "Y: "..math.floor(SelectedObject.AbsolutePosition.Y)
        LW.Text = "Largura: "..math.floor(SelectedObject.AbsoluteSize.X); LH.Text = "Altura: "..math.floor(SelectedObject.AbsoluteSize.Y)
        if SelectedObject == MainBtn then DelBtn.Visible = false; EditBtn.Visible = false; ReportBtn.Visible = false end
    end
end)

Toggle.MouseButton1Click:Connect(function() local t = (Blackout.BackgroundTransparency == 0) and 0.3 or 0; Blackout.BackgroundTransparency = t end)

-- CRÉDITOS
local function createCredit(text, pos)
    local l = Instance.new("TextLabel", Blackout); l.Text = text; l.Position = pos; l.Size = UDim2.new(0, 220, 0, 15); l.TextColor3 = Color3.fromRGB(110, 110, 110); l.BackgroundTransparency = 1; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Right; return l
end
createCredit("Dev: Vtzin x", UDim2.new(1, -230, 0.88, 0))
createCredit("Support: ©VTG solutions", UDim2.new(1, -230, 0.91, 0))
createCredit("Project name: VoidAmethyst Studio", UDim2.new(1, -230, 0.94, 0))

-- vlw pela atençao caso ta vendo esse script feito para ajudar o Vtzin x a trazer outros scripts mais facil 🫶🏽
-- dia 11 de dezembro de 2025 foi o dia q eu comecri a gostar da programação e com os meus projetos malucos 💖
-- #vtzin_x #©VTG solutions #VoidAmethyst Hub
