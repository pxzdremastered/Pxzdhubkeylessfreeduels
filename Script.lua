--=============================================================
--  PXZD HUB - AVS v13
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
    toolVisual = nil,
    toolOrigOculto = nil,
    transparencias = {},
    listaActual = {},
    efectoSeleccionado = nil,
}--=============================================================
--  PARTE 2/5: GUI
--=============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PXZD_AVS_"..HttpService:GenerateGUID(false):sub(1,6)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
if gethui then screenGui.Parent = gethui()
elseif CoreGui then screenGui.Parent = CoreGui
else screenGui.Parent = player:WaitForChild("PlayerGui") end

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
--  PARTE 3/5: Helpers
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
endlocal function equiparItem(datos, categoria)
    local char = player.Character
    if not char then infoLabel.Text = "⚠ Sin personaje"; return end

    -- 1. Limpiar visual anterior
    limpiarToolVisual()

    -- 2. Encontrar el arma original
    local armaOrig = nil
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") and not obj:GetAttribute("PXZD_Visual") then
            armaOrig = obj
            break
        end
    end

    if not armaOrig then
        infoLabel.Text = "⚠ No hay arma original"
        return
    end

    -- 3. Encontrar el Handle del arma original
    local handleOrig = armaOrig:FindFirstChild("Handle") or armaOrig:FindFirstChildWhichIsA("BasePart")
    if not handleOrig then
        infoLabel.Text = "⚠ Arma sin Handle"
        return
    end

    -- 4. 🔑 ENCONTRAR EL WELD EXACTO
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

    -- 5. 🔑 GUARDAR LOS DATOS EXACTOS
    local part0 = weldOrig.Part0
    local c0 = weldOrig.C0 or CFrame.new(0,0,0)
    local c1 = weldOrig.C1 or CFrame.new(0,0,0)
    local tipoWeld = weldOrig.ClassName

    print("[PXZD] Weld capturado: Part0="..tostring(part0).." C0="..tostring(c0))

    -- 6. 🔑 CALCULAR LA POSICIÓN MUNDIAL EXACTA DEL HANDLE
    local cframeExacto = part0.CFrame * c0 * c1:Inverse()

    -- 7. Ocultar el arma original
    ocultarToolOriginal()

    -- 8. Obtener el modelo de la nueva arma
    local modeloArma
    if datos.objeto then
        local ok, c = pcall(function() return datos.objeto:Clone() end)
        if ok and c then modeloArma = c end
    end
    if not modeloArma then
        modeloArma = crearPlaceholder(datos.nombre, categoria)
    end

    -- 9. Buscar el Handle del nuevo modelo
    local handleNuevo
    if modeloArma:IsA("BasePart") then
        handleNuevo = modeloArma
        handleNuevo.Name = "Handle"
    else
        for _, p in ipairs(modeloArma:GetDescendants()) do
            if p:IsA("BasePart") and string.lower(p.Name) == "handle" then
                handleNuevo = p
                break
            end
        end
        if not handleNuevo then
            for _, p in ipairs(modeloArma:GetDescendants()) do
                if p:IsA("BasePart") then handleNuevo = p; break end
            end
        end
    end
    if not handleNuevo then
        infoLabel.Text = "⚠ Arma sin handle"
        return
    end

    -- 10. Recoger todas las partes y posiciones relativas al handle
    local partes = {}
    for _, p in ipairs(modeloArma:GetDescendants()) do
        if p:IsA("BasePart") then table.insert(partes, p) end
    end
    if not table.find(partes, handleNuevo) then table.insert(partes, handleNuevo) end

    local relativas = {}
    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            relativas[p] = handleNuevo.CFrame:ToObjectSpace(p.CFrame)
        end
    end

    -- 11. Preparar partes
    for _, p in ipairs(partes) do
        p.Anchored = true
        p.CanCollide = false
        p.Massless = true
        p:SetAttribute("PXZD_Visual", true)
    end

    -- 12. Meter al Character (NO con EquipTool, solo parenting)
    handleNuevo.CFrame = cframeExacto
    handleNuevo.Parent = char
    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            p.CFrame = handleNuevo.CFrame * relativas[p]
            p.Parent = char
        end
    end

    -- 13. 🔥🔥🔥 CREAR EL WELD CON LOS MISMOS VALORES
    -- Esto hace que la nueva arma quede EXACTAMENTE donde estaba la original
    local weldNuevo
    if tipoWeld == "Weld" then
        weldNuevo = Instance.new("Weld")
    elseif tipoWeld == "Motor6D" then
        weldNuevo = Instance.new("Motor6D")
    else
        weldNuevo = Instance.new("Weld")
    end
    
    weldNuevo.Part0 = part0
    weldNuevo.Part1 = handleNuevo
    if weldNuevo:IsA("Weld") or weldNuevo:IsA("Motor6D") then
        weldNuevo.C0 = c0
        weldNuevo.C1 = c1
    end
    weldNuevo.Parent = handleNuevo

    -- 14. Soldar las demás partes al Handle
    for _, p in ipairs(partes) do
        if p ~= handleNuevo then
            local w = Instance.new("Weld")
            w.Part0 = handleNuevo
            w.Part1 = p
            w.C0 = relativas[p]
            w.C1 = CFrame.new(0,0,0)
            w.Parent = p
            p.Anchored = false
        end
    end
    handleNuevo.Anchored = false

    ESTADO.toolVisual = modeloArma
    infoLabel.Text = "✦ "..datos.nombre.." ✓"
    print("[PXZD] ✓ "..datos.nombre.." en la posición exacta del arma original")
    end--=============================================================
--  PARTE 5/5: Lista y conexiones finales
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

-- Loop: mantener oculto el Tool original
RunService.RenderStepped:Connect(function()
    if ESTADO.toolOrigOculto and ESTADO.toolOrigOculto.Parent then
        for _, d in ipairs(ESTADO.toolOrigOculto:GetDescendants()) do
            pcall(function()
                if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                    if d.Transparency < 1 then d.Transparency = 1 end
                elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then
                    if d.Enabled then d.Enabled = false end
                end
            end)
        end
    end
end)

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

-- Auto re-equipar cuando el juego da un Tool
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

print("⚔️ PXZD HUB v13 cargado")
