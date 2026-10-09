--=============================================================
--  PXZD HUB - AVS v12
--  PARTE 1/5: Configuración
--=============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local CONFIG = {
    IMAGE_ID = "rbxassetid://108485396062507",
    COLOR_FONDO = Color3.fromRGB(12, 12, 20),
    COLOR_BORDE = Color3.fromRGB(255, 215, 100),
    COLOR_TEXTO = Color3.fromRGB(245, 240, 230),
    COLOR_GRIS  = Color3.fromRGB(95, 95, 115),
    COLOR_ACENTO = Color3.fromRGB(200, 130, 255),
    FUENTE_TITULO  = Enum.Font.Fantasy,
    FUENTE_BOTONES = Enum.Font.Fondamento,
    FUENTE_NOMBRES = Enum.Font.Garamond,
}

local KEYWORDS = {
    Cuchillos = {"knife","dagger","blade","sword","shiv","karambit","cleaver",
        "machete","katana","scythe","cuchillo","daga","navaja","bayonet",
        "falchion","kukri","sickle","reaper","tanto","stiletto","butterfly",
        "balisong","kris","wakizashi","gladius","sabre","saber","rapier",
        "scimitar","axe","hatchet","tomahawk","claw","talon","fang"},
    Pistolas = {"gun","pistol","revolver","rifle","smg","shotgun","sniper",
        "pistola","handgun","magnum","deagle","launcher","bazooka",
        "firearm","handcannon","dual","uzi","glock","beretta","colt",
        "luger","m4","ak47","awp","mp5","p90","carbine","musket"},
    Efectos = {"effect","particle","aura","trail","vfx","beam","glow",
        "burst","sparkle","blood","fire","frost","ice","flame","lightning",
        "thunder","nebula","galaxy","cosmic","rainbow","snow","star",
        "void","shadow","plasma","poison","toxic","inferno","lava","magic",
        "mystic","phantom","spectre","soul","storm","sunset","ember"},
}

local EXCLUIR = {
    Cuchillos = {"gun","pistol","rifle","smg","shotgun","sniper","effect","particle","aura"},
    Pistolas = {"knife","dagger","blade","sword","effect","particle","aura"},
    Efectos = {"gun","pistol","revolver","rifle","knife","dagger","blade","sword"},
}

local ESTADO = {
    categoria = "Cuchillos",
    itemSeleccionado = nil,
    filtroBusqueda = "",
    guiAbierta = true,
    ocultos = {},
    visualActual = nil,
    listaActual = {},
    efectoSeleccionado = nil,
    weldInfo = nil,
}--=============================================================
--  PARTE 2/5: GUI completa
--=============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PXZD_AVS_"..HttpService:GenerateGUID(false):sub(1,6)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
if gethui then screenGui.Parent = gethui()
elseif CoreGui then screenGui.Parent = CoreGui
else screenGui.Parent = player:WaitForChild("PlayerGui") end

-- Loading
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 320, 0, 120)
loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -60)
loadingFrame.BackgroundColor3 = CONFIG.COLOR_FONDO
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 999
loadingFrame.Parent = screenGui
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)

local loadBorder = Instance.new("Frame")
loadBorder.Size = UDim2.new(1, 4, 1, 4)
loadBorder.Position = UDim2.new(0, -2, 0, -2)
loadBorder.BackgroundColor3 = Color3.new(1,1,1)
loadBorder.BorderSizePixel = 0
loadBorder.ZIndex = 998
loadBorder.Parent = loadingFrame
Instance.new("UICorner", loadBorder).CornerRadius = UDim.new(0, 14)

local loadGradient = Instance.new("UIGradient")
loadGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLOR_BORDE),
    ColorSequenceKeypoint.new(0.5, CONFIG.COLOR_ACENTO),
    ColorSequenceKeypoint.new(1, CONFIG.COLOR_BORDE),
})
loadGradient.Parent = loadBorder

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, -20, 0, 30)
loadTitle.Position = UDim2.new(0, 10, 0, 12)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "⚔️ PXZD HUB"
loadTitle.TextColor3 = CONFIG.COLOR_BORDE
loadTitle.Font = CONFIG.FUENTE_TITULO
loadTitle.TextSize = 20
loadTitle.ZIndex = 1000
loadTitle.Parent = loadingFrame

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(1, -20, 0, 22)
loadText.Position = UDim2.new(0, 10, 0, 46)
loadText.BackgroundTransparency = 1
loadText.Text = "Cargando..."
loadText.TextColor3 = CONFIG.COLOR_TEXTO
loadText.Font = CONFIG.FUENTE_BOTONES
loadText.TextSize = 13
loadText.ZIndex = 1000
loadText.Parent = loadingFrame

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(1, -40, 0, 10)
loadBarBg.Position = UDim2.new(0, 20, 1, -34)
loadBarBg.BackgroundColor3 = Color3.fromRGB(30,30,45)
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 1000
loadBarBg.Parent = loadingFrame
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(0, 5)

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = CONFIG.COLOR_BORDE
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 1001
loadBarFill.Parent = loadBarBg
Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(0, 5)

task.spawn(function()
    while loadingFrame.Parent do
        pcall(function()
            loadGradient.Rotation = (loadGradient.Rotation + 60 * task.wait(0.03)) % 360
        end)
    end
end)

-- Botón flotante
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 55, 0, 55)
floatBtn.Position = UDim2.new(0, 20, 0.5, -27)
floatBtn.BackgroundColor3 = CONFIG.COLOR_FONDO
floatBtn.Text = ""
floatBtn.AutoButtonColor = false
floatBtn.Draggable = true
floatBtn.Visible = false
floatBtn.ZIndex = 100
floatBtn.Parent = screenGui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)

local floatImg = Instance.new("ImageLabel")
floatImg.Size = UDim2.new(1, -6, 1, -6)
floatImg.Position = UDim2.new(0, 3, 0, 3)
floatImg.BackgroundTransparency = 1
floatImg.Image = CONFIG.IMAGE_ID
floatImg.ScaleType = Enum.ScaleType.Crop
floatImg.ImageTransparency = 0.3
floatImg.ZIndex = 101
floatImg.Parent = floatBtn
Instance.new("UICorner", floatImg).CornerRadius = UDim.new(1, 0)

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = CONFIG.COLOR_BORDE
floatStroke.Thickness = 2
floatStroke.Parent = floatBtn

local floatIcon = Instance.new("TextLabel")
floatIcon.Size = UDim2.new(1, 0, 1, 0)
floatIcon.BackgroundTransparency = 1
floatIcon.Text = "⚔️"
floatIcon.TextColor3 = Color3.new(1,1,1)
floatIcon.Font = Enum.Font.GothamBold
floatIcon.TextSize = 26
floatIcon.TextStrokeTransparency = 0.2
floatIcon.TextStrokeColor3 = Color3.new(0,0,0)
floatIcon.ZIndex = 102
floatIcon.Parent = floatBtn

task.spawn(function()
    while floatBtn.Parent do
        pcall(function()
            floatStroke.Color = Color3.fromHSV((tick()*0.3)%1, 0.7, 1)
            task.wait(0.03)
        end)
    end
end)

-- Ventana principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 440, 0, 400)
mainFrame.Position = UDim2.new(0, 90, 0.5, -200)
mainFrame.BackgroundColor3 = CONFIG.COLOR_FONDO
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local borderFrame = Instance.new("Frame")
borderFrame.Size = UDim2.new(1, 4, 1, 4)
borderFrame.Position = UDim2.new(0, -2, 0, -2)
borderFrame.BackgroundColor3 = Color3.new(1,1,1)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Parent = mainFrame
Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(0, 14)

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, CONFIG.COLOR_BORDE),
    ColorSequenceKeypoint.new(0.33, CONFIG.COLOR_ACENTO),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(180,180,200)),
    ColorSequenceKeypoint.new(1.00, CONFIG.COLOR_BORDE),
})
borderGradient.Parent = borderFrame

task.spawn(function()
    while borderFrame.Parent do
        pcall(function()
            borderGradient.Rotation = (borderGradient.Rotation + 40 * task.wait(0.04)) % 360
        end)
    end
end)

local innerMask = Instance.new("Frame")
innerMask.Size = UDim2.new(1, -4, 1, -4)
innerMask.Position = UDim2.new(0, 2, 0, 2)
innerMask.BackgroundColor3 = CONFIG.COLOR_FONDO
innerMask.BorderSizePixel = 0
innerMask.ZIndex = 1
innerMask.Parent = mainFrame
Instance.new("UICorner", innerMask).CornerRadius = UDim.new(0, 10)

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, -6, 1, -6)
bgImage.Position = UDim2.new(0, 3, 0, 3)
bgImage.BackgroundTransparency = 1
bgImage.Image = CONFIG.IMAGE_ID
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.85
bgImage.ZIndex = 2
bgImage.Parent = mainFrame
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 10)

local darkOverlay = Instance.new("Frame")
darkOverlay.Size = UDim2.new(1,0,1,0)
darkOverlay.BackgroundColor3 = Color3.new(0,0,0)
darkOverlay.BackgroundTransparency = 0.6
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 3
darkOverlay.Parent = bgImage
Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 32)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "⚔️ PXZD HUB · AVS"
title.TextColor3 = CONFIG.COLOR_BORDE
title.Font = CONFIG.FUENTE_TITULO
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(60,30,100)
title.ZIndex = 5
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 11)
closeBtn.BackgroundColor3 = Color3.fromRGB(60,20,20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,200,200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.ZIndex = 6
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, -24, 0, 32)
tabsFrame.Position = UDim2.new(0, 12, 0, 46)
tabsFrame.BackgroundTransparency = 1
tabsFrame.ZIndex = 5
tabsFrame.Parent = mainFrame

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 6)
tabsLayout.Parent = tabsFrame

local botonesTabs = {}
local function crearTab(nombre)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 128, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,38)
    btn.Text = nombre
    btn.TextColor3 = CONFIG.COLOR_TEXTO
    btn.Font = CONFIG.FUENTE_BOTONES
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.ZIndex = 6
    btn.Parent = tabsFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = CONFIG.COLOR_GRIS
    stroke.Thickness = 1
    return btn, stroke
end

local tabCuchillos, strokeCuchillos = crearTab("🔪 Cuchillos")
local tabPistolas, strokePistolas = crearTab("🔫 Pistolas")
local tabEfectos, strokeEfectos = crearTab("✨ Efectos")

botonesTabs = {
    Cuchillos = {btn = tabCuchillos, stroke = strokeCuchillos},
    Pistolas = {btn = tabPistolas, stroke = strokePistolas},
    Efectos = {btn = tabEfectos, stroke = strokeEfectos},
}

-- Buscador
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -24, 0, 32)
searchFrame.Position = UDim2.new(0, 12, 0, 84)
searchFrame.BackgroundColor3 = Color3.fromRGB(25,25,38)
searchFrame.BorderSizePixel = 0
searchFrame.ZIndex = 5
searchFrame.Parent = mainFrame
Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)

local searchIcon = Instance.new("TextLabel")
searchIcon.Size = UDim2.new(0, 26, 1, 0)
searchIcon.Position = UDim2.new(0, 4, 0, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextSize = 14
searchIcon.ZIndex = 6
searchIcon.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -38, 1, 0)
searchBox.Position = UDim2.new(0, 34, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Buscar..."
searchBox.PlaceholderColor3 = CONFIG.COLOR_GRIS
searchBox.TextColor3 = CONFIG.COLOR_TEXTO
searchBox.Font = CONFIG.FUENTE_NOMBRES
searchBox.TextSize = 13
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 6
searchBox.Parent = searchFrame

-- Cuadrícula
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -24, 1, -180)
scrollFrame.Position = UDim2.new(0, 12, 0, 124)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20,20,32)
scrollFrame.BackgroundTransparency = 0.4
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = CONFIG.COLOR_BORDE
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ZIndex = 4
scrollFrame.Parent = mainFrame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 90, 0, 98)
gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
gridLayout.Parent = scrollFrame

local gridPadding = Instance.new("UIPadding")
gridPadding.PaddingTop = UDim.new(0, 8)
gridPadding.PaddingLeft = UDim.new(0, 8)
gridPadding.PaddingRight = UDim.new(0, 8)
gridPadding.PaddingBottom = UDim.new(0, 8)
gridPadding.Parent = scrollFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -24, 0, 26)
infoLabel.Position = UDim2.new(0, 12, 1, -32)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "✦ Selecciona un ítem"
infoLabel.TextColor3 = CONFIG.COLOR_TEXTO
infoLabel.Font = CONFIG.FUENTE_BOTONES
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.ZIndex = 5
infoLabel.Parent = mainFrame--=============================================================
--  PARTE 3/5: Helpers y detección
--=============================================================
local function colorDeNombre(nombre)
    local h = 0
    for i = 1, #nombre do h = (h + string.byte(nombre, i) * i) % 360 end
    return Color3.fromHSV(h/360, 0.65, 0.95)
end

local function coincideCategoria(nombre, categoria)
    local n = string.lower(tostring(nombre))
    for _, excl in ipairs(EXCLUIR[categoria] or {}) do
        if string.find(n, excl, 1, true) then return false end
    end
    for _, kw in ipairs(KEYWORDS[categoria] or {}) do
        if string.find(n, kw, 1, true) then return true end
    end
    return false
end

local function escanear(cont, categoria, encontrados, prof)
    if prof > 8 or not cont then return end
    for _, item in ipairs(cont:GetChildren()) do
        pcall(function()
            if (item:IsA("Tool") or item:IsA("Model") or item:IsA("Folder") or item:IsA("MeshPart")) then
                if coincideCategoria(item.Name, categoria) and not encontrados[item.Name] then
                    encontrados[item.Name] = {objeto = item, tipo = item.ClassName}
                end
                if item:IsA("Folder") or item:IsA("Model") then
                    escanear(item, categoria, encontrados, prof + 1)
                end
            end
        end)
    end
end

local function detectarCategoria(categoria)
    local e = {}
    pcall(function() escanear(ReplicatedStorage, categoria, e, 0) end)
    pcall(function() escanear(Workspace, categoria, e, 0) end)
    pcall(function() escanear(game:GetService("StarterPack"), categoria, e, 0) end)
    pcall(function() escanear(game:GetService("Lighting"), categoria, e, 0) end)
    if player.Backpack then pcall(function() escanear(player.Backpack, categoria, e, 0) end) end
    if player.Character then pcall(function() escanear(player.Character, categoria, e, 0) end) end
    return e
end

local function construirLista(categoria)
    local detectados = detectarCategoria(categoria)
    local lista = {}
    for nombre, datos in pairs(detectados) do
        datos.nombre = nombre
        table.insert(lista, datos)
    end
    table.sort(lista, function(a,b) return a.nombre < b.nombre end)
    return lista
end

local function crearPlaceholder(nombre, categoria)
    local m = Instance.new("Model")
    m.Name = nombre
    if categoria == "Cuchillos" then
        local h = Instance.new("Part"); h.Name = "Handle"
        h.Size = Vector3.new(0.15, 0.8, 0.15); h.Color = Color3.fromRGB(50, 30, 20)
        h.Material = Enum.Material.Wood; h.CanCollide = false; h.CFrame = CFrame.new(0, 0, 0)
        h.Parent = m; m.PrimaryPart = h
        local b = Instance.new("Part"); b.Name = "Blade"
        b.Size = Vector3.new(0.1, 1.8, 0.25); b.Color = colorDeNombre(nombre)
        b.Material = Enum.Material.Metal; b.CanCollide = false; b.CFrame = CFrame.new(0, 1.3, 0); b.Parent = m
        local g = Instance.new("Part"); g.Name = "Guard"
        g.Size = Vector3.new(0.8, 0.08, 0.2); g.Color = Color3.fromRGB(255, 210, 90)
        g.Material = Enum.Material.Metal; g.CanCollide = false; g.CFrame = CFrame.new(0, 0.4, 0); g.Parent = m
    elseif categoria == "Pistolas" then
        local h = Instance.new("Part"); h.Name = "Handle"
        h.Size = Vector3.new(0.25, 0.7, 0.25); h.Color = Color3.fromRGB(40, 40, 50)
        h.Material = Enum.Material.Metal; h.CanCollide = false; h.CFrame = CFrame.new(0, -0.4, 0)
        h.Parent = m; m.PrimaryPart = h
        local b = Instance.new("Part"); b.Name = "Body"
        b.Size = Vector3.new(0.3, 0.3, 1.5); b.Color = Color3.fromRGB(60, 60, 70)
        b.Material = Enum.Material.Metal; b.CanCollide = false; b.CFrame = CFrame.new(0, 0, -0.5); b.Parent = m
        local ba = Instance.new("Part"); ba.Name = "Barrel"
        ba.Size = Vector3.new(0.15, 0.15, 0.8); ba.Color = Color3.fromRGB(30, 30, 35)
        ba.Material = Enum.Material.Metal; ba.CanCollide = false; ba.CFrame = CFrame.new(0, 0.1, -1.5); ba.Parent = m
    else
        local c = Instance.new("Part"); c.Name = "Handle"
        c.Size = Vector3.new(0.3, 0.3, 0.3); c.Color = colorDeNombre(nombre)
        c.Material = Enum.Material.Neon; c.CanCollide = false; c.CFrame = CFrame.new(0, 0, 0)
        c.Parent = m; m.PrimaryPart = c
        for i = 1, 3 do
            local a = Instance.new("Part"); a.Name = "Ring"..i
            a.Shape = Enum.PartType.Cylinder; a.Size = Vector3.new(0.08, 0.8 + i*0.2, 0.8 + i*0.2)
            a.Color = colorDeNombre(nombre..i); a.Material = Enum.Material.Neon
            a.Transparency = 0.3; a.CanCollide = false
            a.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(i*30), 0, math.rad(i*45))
            a.Parent = m
        end
    end
    return m
end

local function ocultarObjeto(obj)
    if not obj then return end
    local info = {obj = obj}
    pcall(function()
        if obj:IsA("BasePart") then
            info.transp = obj.Transparency; info.visible = obj.Visible; info.collide = obj.CanCollide
            obj.Transparency = 1; obj.Visible = false; obj.CanCollide = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            info.transp = obj.Transparency; info.visible = obj.Visible
            obj.Transparency = 1; obj.Visible = false
        elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("GuiObject") then
            info.enabled = obj.Enabled; info.visible = obj.Visible
            obj.Enabled = false; obj.Visible = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            info.enabled = obj.Enabled; obj.Enabled = false
        end
    end)
    table.insert(ESTADO.ocultos, info)
end

local function restaurarOcultos()
    for _, info in ipairs(ESTADO.ocultos) do
        pcall(function()
            if info.obj and info.obj.Parent then
                if info.transp ~= nil then info.obj.Transparency = info.transp end
                if info.visible ~= nil then info.obj.Visible = info.visible end
                if info.collide ~= nil then info.obj.CanCollide = info.collide end
                if info.enabled ~= nil then info.obj.Enabled = info.enabled end
            end
        end)
    end
    ESTADO.ocultos = {}
end

local function limpiarVisual()
    if ESTADO.visualActual and ESTADO.visualActual.Parent then
        pcall(function() ESTADO.visualActual:Destroy() end)
    end
    ESTADO.visualActual = nil
end--=============================================================
--  PARTE 4/5: EQUIPAR (posición EXACTA)
--=============================================================
local function equiparItem(datos, categoria)
    local char = player.Character
    if not char then return end

    limpiarVisual()
    restaurarOcultos()

    -- 🔑 1. Buscar Tool equipado
    local armaOrig = nil
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") and not obj:GetAttribute("PXZD_Visual") then
            armaOrig = obj
            break
        end
    end

    if not armaOrig then
        infoLabel.Text = "⚠ No hay arma equipada"
        return
    end

    -- 🔑 2. Buscar Handle
    local handleOrig = armaOrig:FindFirstChild("Handle") or armaOrig:FindFirstChildWhichIsA("BasePart")
    if not handleOrig then
        infoLabel.Text = "⚠ Arma sin Handle"
        return
    end

    -- 🔑 3. Buscar el weld original
    local weldOrig = nil
    for _, w in ipairs(handleOrig:GetChildren()) do
        if w:IsA("Weld") or w:IsA("Motor6D") or w:IsA("WeldConstraint") then
            weldOrig = w
            break
        end
    end

    if not weldOrig then
        infoLabel.Text = "⚠ Arma sin Weld"
        return
    end

    -- 🔑 4. Capturar datos EXACTOS del weld
    local part0 = weldOrig.Part0
    local c0 = weldOrig.C0 or CFrame.new(0,0,0)
    local c1 = weldOrig.C1 or CFrame.new(0,0,0)
    local tipoWeld = weldOrig.ClassName

    ESTADO.weldInfo = {part0 = part0, c0 = c0, c1 = c1, tipoWeld = tipoWeld}

    print("[PXZD] 🔍 Weld capturado:")
    print("  Part0: "..tostring(part0))
    print("  C0: "..tostring(c0))

    -- 🔑 5. Ocultar arma original
    ocultarObjeto(armaOrig)
    for _, d in ipairs(armaOrig:GetDescendants()) do
        ocultarObjeto(d)
    end

    -- 🔑 6. Crear la nueva
    local clon
    if datos.objeto then
        local ok, c = pcall(function() return datos.objeto:Clone() end)
        if ok and c then clon = c end
    end
    if not clon then
        clon = crearPlaceholder(datos.nombre, categoria)
    end

    local partes = {}
    for _, p in ipairs(clon:GetDescendants()) do
        if p:IsA("BasePart") then table.insert(partes, p) end
    end
    if clon:IsA("BasePart") then table.insert(partes, clon) end
    if #partes == 0 then return end

    -- 🔑 7. Handle de la nueva
    local handleNuevo
    for _, p in ipairs(partes) do
        local ln = string.lower(p.Name)
        if ln == "handle" or ln == "grip" then handleNuevo = p; break end
    end
    if not handleNuevo then
        table.sort(partes, function(a,b) return a.Size.Magnitude < b.Size.Magnitude end)
        handleNuevo = partes[1]
    end

    local relativas = {}
    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            relativas[p] = handleNuevo.CFrame:ToObjectSpace(p.CFrame)
        end
    end

    clon.Parent = char
    for _, p in ipairs(partes) do
        p.Anchored = true; p.CanCollide = false; p.Massless = true
        p:SetAttribute("PXZD_Visual", true)
    end

    -- 🔑 8. 🔥 APLICAR MISMO WELD EXACTO
    -- Fórmula: handleNuevo.CFrame = part0.CFrame * c0 * c1:Inverse()
    local destinoCF = part0.CFrame * c0 * c1:Inverse()
    handleNuevo.CFrame = destinoCF

    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            p.CFrame = handleNuevo.CFrame * relativas[p]
        end
    end

    -- 🔑 9. Crear Weld con los MISMOS valores
    local wNuevo
    if tipoWeld == "Weld" then
        wNuevo = Instance.new("Weld")
        wNuevo.Part0 = part0
        wNuevo.Part1 = handleNuevo
        wNuevo.C0 = c0
        wNuevo.C1 = c1
    elseif tipoWeld == "Motor6D" then
        wNuevo = Instance.new("Motor6D")
        wNuevo.Part0 = part0
        wNuevo.Part1 = handleNuevo
        wNuevo.C0 = c0
        wNuevo.C1 = c1
    else
        wNuevo = Instance.new("WeldConstraint")
        wNuevo.Part0 = part0
        wNuevo.Part1 = handleNuevo
    end
    wNuevo.Parent = handleNuevo

    -- 🔑 10. Soldar el resto al handle
    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            local w = Instance.new("WeldConstraint")
            w.Part0 = handleNuevo
            w.Part1 = p
            w.Parent = p
            p.Anchored = false
        end
    end
    handleNuevo.Anchored = false

    ESTADO.visualActual = clon
    infoLabel.Text = "✦ "..datos.nombre.." ✓"
end

--=============================================================
--  EFECTOS AL MATAR
--=============================================================
local function seleccionarEfecto(datos)
    ESTADO.efectoSeleccionado = datos
    infoLabel.Text = "✨ "..datos.nombre.." activo al matar"
end

local function aplicarEfectoAlMuerto(victima)
    if not ESTADO.efectoSeleccionado then return end
    local datos = ESTADO.efectoSeleccionado
    local char = victima
    if not char or not char.Parent then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return end

    local aplicado = false
    if datos.objeto then
        for _, d in ipairs(datos.objeto:GetDescendants()) do
            if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
               or d:IsA("PointLight") or d:IsA("SpotLight") then
                local ok, clon = pcall(function() return d:Clone() end)
                if ok and clon then
                    clon.Parent = hrp; aplicado = true
                    task.delay(5, function() if clon then clon:Destroy() end end)
                end
            end
        end
    end

    if not aplicado then
        local color = colorDeNombre(datos.nombre)
        if string.find(string.lower(datos.nombre), "blood", 1, true) then
            color = Color3.fromRGB(180, 10, 10)
        end
        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://243660364"; pe.LightEmission = 1
        pe.Color = ColorSequence.new(color)
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        pe.Lifetime = NumberRange.new(0.8, 1.5); pe.Rate = 60
        pe.Speed = NumberRange.new(3, 6); pe.SpreadAngle = Vector2.new(180, 180)
        pe.Parent = hrp
        task.delay(5, function() if pe then pe:Destroy() end end)

        local pl = Instance.new("PointLight")
        pl.Color = color; pl.Brightness = 5; pl.Range = 15
        pl.Parent = hrp
        task.delay(5, function() if pl then pl:Destroy() end end)
    end
end

local function conectarHumanoid(hum, char)
    if not hum or not char then return end
    hum.Died:Connect(function()
        if char == player.Character then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local hrpV = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrpV and (hrp.Position - hrpV.Position).Magnitude < 100 then
            task.wait(0.1)
            aplicarEfectoAlMuerto(char)
        end
    end)
end

local function vigilar(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then conectarHumanoid(hum, char) end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then
        if p.Character then vigilar(p.Character) end
        p.CharacterAdded:Connect(vigilar)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        p.CharacterAdded:Connect(vigilar)
        if p.Character then vigilar(p.Character) end
    end
end)--=============================================================
--  PARTE 5/5: Lista, conexiones y carga
--=============================================================
local function crearVistaPrevia(item, contenedor, nombre, categoria)
    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1, -4, 1, -20)
    viewport.Position = UDim2.new(0, 2, 0, 2)
    viewport.BackgroundTransparency = 1; viewport.ZIndex = 5; viewport.Parent = contenedor
    Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 6)

    local cam = Instance.new("Camera"); cam.Parent = viewport; viewport.CurrentCamera = cam

    local mostrar
    if item and item.objeto then
        local ok, clon = pcall(function() return item.objeto:Clone() end)
        if ok and clon then clon.Parent = viewport; mostrar = clon end
    end
    if not mostrar then
        mostrar = crearPlaceholder(nombre, categoria); mostrar.Parent = viewport
    end

    for _, p in ipairs(mostrar:GetDescendants()) do
        if p:IsA("BasePart") then p.Anchored = true; p.CanCollide = false end
    end
    if mostrar:IsA("BasePart") then mostrar.Anchored = true; mostrar.CanCollide = false end

    pcall(function()
        if mostrar:IsA("Model") then mostrar:PivotTo(CFrame.new(0, -0.3, 0))
        elseif mostrar:IsA("BasePart") then mostrar.CFrame = CFrame.new(0, 0, 0) end
    end)
    cam.CFrame = CFrame.new(Vector3.new(0, 0.5, 4), Vector3.new(0, 0, 0))
end

local function mostrarLista()
    for _, h in ipairs(scrollFrame:GetChildren()) do
        if h:IsA("TextButton") then h:Destroy() end
    end

    local categoria = ESTADO.categoria
    local lista = ESTADO.listaActual

    local filtro = string.lower(ESTADO.filtroBusqueda)
    if filtro ~= "" then
        local filtrada = {}
        for _, d in ipairs(lista) do
            if string.find(string.lower(d.nombre), filtro, 1, true) then
                table.insert(filtrada, d)
            end
        end
        lista = filtrada
    end

    if #lista == 0 then
        infoLabel.Text = "⚠ No hay ítems de "..categoria
        return
    end

    for i, datos in ipairs(lista) do
        local boton = Instance.new("TextButton")
        boton.Name = datos.nombre
        boton.Size = UDim2.new(0, 90, 0, 98)
        boton.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        boton.Text = ""; boton.AutoButtonColor = false
        boton.LayoutOrder = i; boton.ZIndex = 5; boton.Parent = scrollFrame
        Instance.new("UICorner", boton).CornerRadius = UDim.new(0, 8)

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = CONFIG.COLOR_GRIS; btnStroke.Thickness = 1; btnStroke.Parent = boton

        if ESTADO.itemSeleccionado and ESTADO.itemSeleccionado.nombre == datos.nombre 
           and ESTADO.itemSeleccionado.categoria == categoria and categoria ~= "Efectos" then
            btnStroke.Color = CONFIG.COLOR_BORDE; btnStroke.Thickness = 2
            boton.BackgroundColor3 = Color3.fromRGB(50, 42, 18)
        end
        if categoria == "Efectos" and ESTADO.efectoSeleccionado 
           and ESTADO.efectoSeleccionado.nombre == datos.nombre then
            btnStroke.Color = CONFIG.COLOR_BORDE; btnStroke.Thickness = 2
            boton.BackgroundColor3 = Color3.fromRGB(50, 42, 18)
        end

        pcall(function() crearVistaPrevia(datos, boton, datos.nombre, categoria) end)

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -4, 0, 18); nl.Position = UDim2.new(0, 2, 1, -20)
        nl.BackgroundTransparency = 1; nl.Text = datos.nombre
        nl.TextColor3 = CONFIG.COLOR_TEXTO; nl.Font = CONFIG.FUENTE_NOMBRES
        nl.TextSize = 10; nl.TextTruncate = Enum.TextTruncate.AtEnd
        nl.ZIndex = 7; nl.Parent = boton

        boton.MouseButton1Click:Connect(function()
            if categoria == "Efectos" then
                seleccionarEfecto(datos)
            else
                ESTADO.itemSeleccionado = {nombre = datos.nombre, categoria = categoria, objeto = datos.objeto}
                pcall(function() equiparItem(datos, categoria) end)
            end
            mostrarLista()
        end)
    end

    local filas = math.ceil(#lista / 4)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, filas * 106 + 20)
    infoLabel.Text = "✦ "..#lista.." ítems en "..categoria
end

local function cambiarCategoria(categoria)
    ESTADO.categoria = categoria
    ESTADO.filtroBusqueda = ""
    searchBox.Text = ""
    for cat, tab in pairs(botonesTabs) do
        if cat == categoria then
            tab.btn.BackgroundColor3 = Color3.fromRGB(50, 42, 18)
            tab.stroke.Color = CONFIG.COLOR_BORDE; tab.stroke.Thickness = 2
        else
            tab.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
            tab.stroke.Color = CONFIG.COLOR_GRIS; tab.stroke.Thickness = 1
        end
    end
    ESTADO.listaActual = construirLista(categoria)
    mostrarLista()
end

-- 🔥 Loop agresivo: forzar ocultado cada frame
RunService.RenderStepped:Connect(function()
    if #ESTADO.ocultos == 0 then return end
    for _, info in ipairs(ESTADO.ocultos) do
        pcall(function()
            if info.obj and info.obj.Parent then
                if info.transp ~= nil and (info.obj:IsA("BasePart") or info.obj:IsA("Decal") or info.obj:IsA("Texture")) then
                    if info.obj.Transparency < 1 then info.obj.Transparency = 1 end
                end
                if info.visible ~= nil and (info.obj:IsA("BasePart") or info.obj:IsA("Decal") or info.obj:IsA("Texture") or info.obj:IsA("GuiObject")) then
                    if info.obj.Visible ~= false then info.obj.Visible = false end
                end
                if info.enabled ~= nil then
                    if info.obj.Enabled then info.obj.Enabled = false end
                end
            end
        end)
    end
end)

-- Conexiones
tabCuchillos.MouseButton1Click:Connect(function() pcall(function() cambiarCategoria("Cuchillos") end) end)
tabPistolas.MouseButton1Click:Connect(function() pcall(function() cambiarCategoria("Pistolas") end) end)
tabEfectos.MouseButton1Click:Connect(function() pcall(function() cambiarCategoria("Efectos") end) end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    ESTADO.filtroBusqueda = searchBox.Text or ""
    pcall(function() mostrarLista() end)
end)

closeBtn.MouseButton1Click:Connect(function()
    ESTADO.guiAbierta = false
    mainFrame.Visible = false
end)

floatBtn.MouseButton1Click:Connect(function()
    ESTADO.guiAbierta = not ESTADO.guiAbierta
    mainFrame.Visible = ESTADO.guiAbierta
end)

-- Auto re-equipar cuando el juego te da Tool
local function vigilarCharacter(char)
    if not char then return end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and not child:GetAttribute("PXZD_Visual") then
            task.wait(0.5)
            if ESTADO.itemSeleccionado and ESTADO.itemSeleccionado.categoria ~= "Efectos" then
                pcall(function() equiparItem(ESTADO.itemSeleccionado, ESTADO.itemSeleccionado.categoria) end)
            end
        end
    end)
    char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and not child:GetAttribute("PXZD_Visual") then
            task.wait(0.3)
            pcall(function() restaurarOcultos() end)
            if ESTADO.itemSeleccionado and ESTADO.itemSeleccionado.categoria ~= "Efectos" then
                pcall(function() equiparItem(ESTADO.itemSeleccionado, ESTADO.itemSeleccionado.categoria) end)
            end
        end
    end)
end

if player.Character then vigilarCharacter(player.Character) end
player.CharacterAdded:Connect(function(char)
    task.wait(2)
    vigilarCharacter(char)
    if ESTADO.itemSeleccionado and ESTADO.itemSeleccionado.categoria ~= "Efectos" then
        pcall(function() equiparItem(ESTADO.itemSeleccionado, ESTADO.itemSeleccionado.categoria) end)
    end
end)

-- Carga inicial
task.spawn(function()
    pcall(function() loadText.Text = "Esperando personaje..."; loadBarFill.Size = UDim2.new(0.15, 0, 1, 0) end)
    task.wait(0.8)
    pcall(function() loadText.Text = "Escaneando..."; loadBarFill.Size = UDim2.new(0.5, 0, 1, 0) end)
    pcall(function() ESTADO.listaActual = construirLista("Cuchillos") end)
    task.wait(0.5)
    pcall(function() loadText.Text = "¡Listo!"; loadBarFill.Size = UDim2.new(1, 0, 1, 0) end)
    task.wait(0.3)
    pcall(function()
        TweenService:Create(loadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        for _, d in ipairs(loadingFrame:GetDescendants()) do
            if d:IsA("TextLabel") then TweenService:Create(d, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            elseif d:IsA("Frame") then TweenService:Create(d, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            elseif d:IsA("UIStroke") then TweenService:Create(d, TweenInfo.new(0.4), {Transparency = 1}):Play()
            end
        end
    end)
    task.wait(0.5)
    pcall(function() loadingFrame:Destroy() end)
    pcall(function() floatBtn.Visible = true end)
    pcall(function() mainFrame.Visible = true end)
    pcall(function() cambiarCategoria("Cuchillos") end)
end)

print("⚔️ PXZD HUB v12 cargado")
