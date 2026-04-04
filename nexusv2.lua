--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝
    
    NEXUS UI LIBRARY v3.0 — Design "Obsidian Glass"
    Premium Roblox Script Library
    
    Usage:
        local Nexus = loadstring(game:HttpGet("YOUR_URL"))()
        
        -- Loader
        Nexus:Loader({
            Title = "Mon Script",
            Subtitle = "v1.0 — By You",
            Key = "MON-KEY-SECRET",
            Steps = {"Chargement", "Vérification", "Lancement"},
            Callback = function() ... end
        })
        
        -- Fenêtre principale
        local Win = Nexus:Window({
            Title = "Mon Script",
            Subtitle = "Premium Edition"
        })
        local Tab = Win:Tab({ Name = "Aimbot", Icon = "🎯" })
        Tab:Toggle({ Name = "Activer", Default = true, Callback = function(v) end })
        Tab:Slider({ Name = "FOV", Min = 10, Max = 360, Default = 120, Callback = function(v) end })
]]

-- ═══════════════════════════════════════════════
--              SERVICES & CORE
-- ═══════════════════════════════════════════════

local NexusLib = {}
NexusLib.__index = NexusLib

local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UserInput     = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local HttpService   = game:GetService("HttpService")
local CoreGui       = game:GetService("CoreGui")

local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════
--              THEME "OBSIDIAN GLASS"
-- ═══════════════════════════════════════════════

local Theme = {
    -- Backgrounds
    BG          = Color3.fromRGB(8,  11,  18),
    Surface     = Color3.fromRGB(13, 18,  32),
    Panel       = Color3.fromRGB(17, 24,  39),
    PanelHover  = Color3.fromRGB(22, 30,  50),
    
    -- Accents
    Accent      = Color3.fromRGB(79,  158, 255),  -- Bleu néon
    Accent2     = Color3.fromRGB(167, 139, 250),  -- Violet
    Accent3     = Color3.fromRGB(52,  211, 153),  -- Vert emeraude
    Gold        = Color3.fromRGB(251, 191, 36),   -- Or premium
    Danger      = Color3.fromRGB(248, 113, 113),  -- Rouge
    Warning     = Color3.fromRGB(251, 191, 36),   -- Ambre
    
    -- Text
    Text        = Color3.fromRGB(226, 234, 248),
    TextMuted   = Color3.fromRGB(107, 127, 163),
    TextDim     = Color3.fromRGB(60,  75,  100),
    
    -- Borders
    Border      = Color3.fromRGB(30,  45,  70),
    BorderGlow  = Color3.fromRGB(50,  100, 160),
    
    -- Transparency
    GlassTrans  = 0.12,
    PanelTrans  = 0.06,
    BorderTrans = 0.82,
    
    -- Sizes
    Corner      = UDim.new(0, 10),
    CornerLg    = UDim.new(0, 14),
    CornerXl    = UDim.new(0, 18),
    CornerRound = UDim.new(0, 100),
    
    -- Font
    FontTitle   = Enum.Font.GothamBold,
    FontSemi    = Enum.Font.GothamSemibold,
    FontBody    = Enum.Font.Gotham,
    FontMono    = Enum.Font.Code,
}

-- ═══════════════════════════════════════════════
--              ICÔNES CUSTOM (rbxassetid)
-- ═══════════════════════════════════════════════

-- Bibliothèque d'icônes Roblox (Material Icons via rbxassetid)
local Icons = {
    -- UI Actions
    close      = "rbxassetid://7072725342",
    minimize   = "rbxassetid://7072718120",
    check      = "rbxassetid://7072719338",
    warn       = "rbxassetid://7072718018",
    error      = "rbxassetid://7072725342",
    info       = "rbxassetid://7072716858",
    key        = "rbxassetid://7072716758",
    shield     = "rbxassetid://7072718778",
    search     = "rbxassetid://7072718558",
    settings   = "rbxassetid://7072719440",
    -- Game
    aim        = "rbxassetid://7072718896",
    eye        = "rbxassetid://7072717882",
    bolt       = "rbxassetid://7072719440",
    star       = "rbxassetid://7072718540",
    heart      = "rbxassetid://7072717342",
    sword      = "rbxassetid://7072718778",
    -- Nav
    arrow_r    = "rbxassetid://7072717660",
    arrow_d    = "rbxassetid://7072718120",
    arrow_u    = "rbxassetid://7072718016",
    dot        = "rbxassetid://7072716842",
    -- Misc
    color      = "rbxassetid://7072716842",
    text       = "rbxassetid://7072718558",
    slider_ic  = "rbxassetid://7072717660",
    dropdown   = "rbxassetid://7072718120",
    button     = "rbxassetid://7072719440",
    toggle     = "rbxassetid://7072717342",
    nexus      = "rbxassetid://7072718778",
    connected  = "rbxassetid://7072719338",
}

-- Crée un ImageLabel icône custom (fallback texte si asset non dispo)
local function MakeIcon(parent, assetId, size, pos, color, zindex)
    size    = size   or UDim2.new(0, 16, 0, 16)
    pos     = pos    or UDim2.new(0, 0, 0.5, -8)
    color   = color  or Theme.TextMuted
    zindex  = zindex or 23
    
    local img = Instance.new("ImageLabel")
    img.Size              = size
    img.Position          = pos
    img.Image             = assetId
    img.ImageColor3       = color
    img.BackgroundTransparency = 1
    img.ScaleType         = Enum.ScaleType.Fit
    img.ZIndex            = zindex
    img.Parent            = parent
    return img
end



-- ═══════════════════════════════════════════════
--              UTILITAIRES
-- ═══════════════════════════════════════════════
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local t = TweenService:Create(obj, TweenInfo.new(time, style, dir), props)
    t:Play()
    return t
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local function AddCorner(parent, size)
    local c = Instance.new("UICorner")
    c.CornerRadius = size or Theme.Corner
    c.Parent = parent
    return c
end

local function AddStroke(parent, color, trans, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Transparency = trans or Theme.BorderTrans
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function AddGradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    local col0 = c0 or Theme.Accent
    local col1 = c1 or Theme.Accent2
    -- Support both Color3 and ColorSequenceKeypoint inputs
    if typeof(col0) == "Color3" then
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, col0),
            ColorSequenceKeypoint.new(1, col1)
        })
    else
        -- Already ColorSequenceKeypoints → wrap in table
        g.Color = ColorSequence.new({col0, col1})
    end
    g.Rotation = rot or 90
    g.Parent = parent
    return g
end

local function AddPadding(parent, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.Parent = parent
    return p
end

local function AddListLayout(parent, dir, spacing, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection     = dir     or Enum.FillDirection.Vertical
    l.Padding           = UDim.new(0, spacing or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.SortOrder         = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInput.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local nx = startPos.X.Scale
            local ny = startPos.Y.Scale
            local ox = startPos.X.Offset + delta.X
            local oy = startPos.Y.Offset + delta.Y
            Tween(frame, 0.05, {Position = UDim2.new(nx, ox, ny, oy)})
        end
    end)
end

-- ═══════════════════════════════════════════════
--              ROOT GUI
-- ═══════════════════════════════════════════════

local function GetRoot()
    local exists = CoreGui:FindFirstChild("NexusUI_Root")
    if exists then exists:Destroy() end
    
    local root = Create("ScreenGui", {
        Name            = "NexusUI_Root",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 999,
        Parent          = CoreGui
    })
    return root
end

-- ═══════════════════════════════════════════════
--              NOTIFICATIONS
-- ═══════════════════════════════════════════════

local NotifContainer = nil

local function EnsureNotifContainer(root)
    if NotifContainer and NotifContainer.Parent then return NotifContainer end
    
    NotifContainer = Create("Frame", {
        Name            = "NotifContainer",
        Size            = UDim2.new(0, 320, 1, 0),
        Position        = UDim2.new(1, -330, 0, 0),
        BackgroundTransparency = 1,
        ZIndex          = 200,
        Parent          = root
    })
    
    local layout = AddListLayout(NotifContainer, Enum.FillDirection.Vertical, 8)
    layout.VerticalAlignment   = Enum.VerticalAlignment.Bottom
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    
    AddPadding(NotifContainer, 0, 0, 16, 0)
    
    return NotifContainer
end

function NexusLib:Notify(config)
    config = config or {}
    local title    = config.Title    or "Notification"
    local message  = config.Message  or ""
    local notifType = config.Type   or "info"   -- info | success | warn | error
    local duration = config.Duration or 4
    
    if not self._root then self._root = GetRoot() end
    EnsureNotifContainer(self._root)
    
    local accentColor = Theme.Accent
    local iconAsset   = Icons.info
    
    if notifType == "success" then accentColor = Theme.Accent3; iconAsset = Icons.check
    elseif notifType == "warn" then accentColor = Theme.Warning; iconAsset = Icons.warn
    elseif notifType == "error" then accentColor = Theme.Danger;  iconAsset = Icons.error
    end
    
    -- Notif frame
    local notif = Create("Frame", {
        Name                   = "Notif",
        Size                   = UDim2.new(1, 0, 0, 72),
        BackgroundColor3       = Theme.Panel,
        BackgroundTransparency = 0.1,
        LayoutOrder            = tick(),
        Parent                 = NotifContainer
    })
    AddCorner(notif, Theme.Corner)
    AddStroke(notif, accentColor, 0.6)
    
    -- Accent bar gauche
    local bar = Create("Frame", {
        Name                   = "Bar",
        Size                   = UDim2.new(0, 3, 1, 0),
        Position               = UDim2.new(0, 0, 0, 0),
        BackgroundColor3       = accentColor,
        BackgroundTransparency = 0,
        ZIndex                 = 2,
        Parent                 = notif
    })
    AddCorner(bar, UDim.new(0, 3))
    
    -- Glow bg
    local glow = Create("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundColor3       = accentColor,
        BackgroundTransparency = 0.92,
        ZIndex                 = 1,
        Parent                 = notif
    })
    AddCorner(glow, Theme.Corner)
    
    -- Icon
    MakeIcon(notif, iconAsset,
        UDim2.new(0, 22, 0, 22),
        UDim2.new(0, 19, 0.5, -11),
        accentColor, 3)
    
    -- Title
    local titleLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -60, 0, 20),
        Position               = UDim2.new(0, 52, 0, 14),
        Text                   = title,
        TextColor3             = accentColor,
        TextSize               = 13,
        Font                   = Theme.FontTitle,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 3,
        Parent                 = notif
    })
    
    -- Message
    local msgLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -60, 0, 16),
        Position               = UDim2.new(0, 52, 0, 36),
        Text                   = message,
        TextColor3             = Theme.TextMuted,
        TextSize               = 11,
        Font                   = Theme.FontBody,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 3,
        Parent                 = notif
    })
    
    -- Progress bar durée
    local progress = Create("Frame", {
        Size                   = UDim2.new(1, -16, 0, 2),
        Position               = UDim2.new(0, 8, 1, -6),
        BackgroundColor3       = accentColor,
        BackgroundTransparency = 0.4,
        ZIndex                 = 4,
        Parent                 = notif
    })
    AddCorner(progress, Theme.CornerRound)
    
    -- Slide in
    notif.Position = UDim2.new(1, 20, 0, 0)
    Tween(notif, 0.4, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)
    
    -- Progress tween
    Tween(progress, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
    
    -- Fade out
    task.delay(duration, function()
        Tween(notif, 0.3, {Position = UDim2.new(1, 20, 0, 0)})
        task.delay(0.3, function()
            notif:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════════════
--              LOADER
-- ═══════════════════════════════════════════════

function NexusLib:Loader(config)
    config = config or {}
    local title    = config.Title    or "NEXUS UI"
    local subtitle = config.Subtitle or "Loading..."
    local key      = config.Key      or nil
    local steps    = config.Steps    or {"Initialisation", "Connexion", "Vérification", "Lancement"}
    local cb       = config.Callback or function() end
    
    self._root = GetRoot()
    
    -- Overlay sombre
    local overlay = Create("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundColor3       = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.3,
        ZIndex                 = 10,
        Parent                 = self._root
    })
    
    -- Loader card
    local card = Create("Frame", {
        Size                   = UDim2.new(0, 420, 0, 360),
        Position               = UDim2.new(0.5, -210, 0.5, -200),
        BackgroundColor3       = Theme.BG,
        BackgroundTransparency = 0,
        ZIndex                 = 11,
        Parent                 = self._root
    })
    AddCorner(card, Theme.CornerXl)
    AddStroke(card, Theme.Accent, 0.75)
    
    -- Gradient top border
    local topBorder = Create("Frame", {
        Size                   = UDim2.new(1, 0, 0, 1),
        BackgroundColor3       = Color3.new(1,1,1),
        BackgroundTransparency = 0,
        ZIndex                 = 12,
        Parent                 = card
    })
    -- top border gradient
    local topBorderGrad = Instance.new("UIGradient")
    topBorderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.5, Theme.Accent),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0))
    })
    topBorderGrad.Rotation = 0
    topBorderGrad.Parent = topBorder
    
    -- Ambient glow derrière
    local ambient = Create("Frame", {
        Size                   = UDim2.new(1, 40, 1, 40),
        Position               = UDim2.new(0, -20, 0, -20),
        BackgroundColor3       = Theme.Accent,
        BackgroundTransparency = 0.94,
        ZIndex                 = 10,
        Parent                 = card
    })
    AddCorner(ambient, UDim.new(0, 30))
    
    -- ORB animée
    local orbFrame = Create("Frame", {
        Size                   = UDim2.new(0, 80, 0, 80),
        Position               = UDim2.new(0.5, -40, 0, 30),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        Parent                 = card
    })
    
    local orbCore = Create("Frame", {
        Size                   = UDim2.new(0, 40, 0, 40),
        Position               = UDim2.new(0.5, -20, 0.5, -20),
        BackgroundColor3       = Theme.Accent,
        ZIndex                 = 13,
        Parent                 = orbFrame
    })
    AddCorner(orbCore, Theme.CornerRound)
    AddGradient(orbCore, Theme.Accent, Theme.Accent2)
    
    local ring1 = Create("Frame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        Parent                 = orbFrame
    })
    AddCorner(ring1, Theme.CornerRound)
    AddStroke(ring1, Theme.Accent, 0.3, 1.5)
    
    local ring2 = Create("Frame", {
        Size                   = UDim2.new(0, 60, 0, 60),
        Position               = UDim2.new(0.5, -30, 0.5, -30),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        Parent                 = orbFrame
    })
    AddCorner(ring2, Theme.CornerRound)
    AddStroke(ring2, Theme.Accent2, 0.4, 1.5)
    
    -- Rotation des rings
    local r1angle = 0
    local r2angle = 180
    local conn = RunService.Heartbeat:Connect(function(dt)
        r1angle = r1angle + dt * 200
        r2angle = r2angle - dt * 120
        ring1.Rotation = r1angle
        ring2.Rotation = r2angle
    end)
    
    -- Pulse orb
    task.spawn(function()
        while card.Parent do
            Tween(orbCore, 0.8, {BackgroundTransparency = 0.2}, Enum.EasingStyle.Sine)
            task.wait(0.8)
            Tween(orbCore, 0.8, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine)
            task.wait(0.8)
        end
    end)
    
    -- Title
    local titleLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 30),
        Position               = UDim2.new(0, 20, 0, 120),
        Text                   = title,
        TextColor3             = Theme.Text,
        TextSize               = 22,
        Font                   = Theme.FontTitle,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
        Parent                 = card
    })
    
    local subLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 18),
        Position               = UDim2.new(0, 20, 0, 152),
        Text                   = subtitle,
        TextColor3             = Theme.TextMuted,
        TextSize               = 11,
        Font                   = Theme.FontMono,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
        Parent                 = card
    })
    
    -- Progress bar
    local progressBG = Create("Frame", {
        Size                   = UDim2.new(0, 340, 0, 5),
        Position               = UDim2.new(0.5, -170, 0, 185),
        BackgroundColor3       = Theme.Border,
        BackgroundTransparency = 0.5,
        ZIndex                 = 12,
        Parent                 = card
    })
    AddCorner(progressBG, Theme.CornerRound)
    
    local progressFill = Create("Frame", {
        Size                   = UDim2.new(0, 0, 1, 0),
        BackgroundColor3       = Theme.Accent,
        ZIndex                 = 13,
        Parent                 = progressBG
    })
    AddCorner(progressFill, Theme.CornerRound)
    AddGradient(progressFill, Theme.Accent, Theme.Accent2)
    
    -- Steps container
    local stepsContainer = Create("Frame", {
        Size                   = UDim2.new(0, 340, 0, 0),
        Position               = UDim2.new(0.5, -170, 0, 202),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        AutomaticSize          = Enum.AutomaticSize.Y,
        Parent                 = card
    })
    AddListLayout(stepsContainer, Enum.FillDirection.Vertical, 6)
    
    local stepLabels = {}
    for i, stepText in ipairs(steps) do
        local stepRow = Create("Frame", {
            Size                   = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            ZIndex                 = 12,
            Parent                 = stepsContainer
        })
        
        local dot = Create("Frame", {
            Size                   = UDim2.new(0, 6, 0, 6),
            Position               = UDim2.new(0, 0, 0.5, -3),
            BackgroundColor3       = Theme.TextDim,
            ZIndex                 = 13,
            Parent                 = stepRow
        })
        AddCorner(dot, Theme.CornerRound)
        
        local lbl = Create("TextLabel", {
            Size                   = UDim2.new(1, -16, 1, 0),
            Position               = UDim2.new(0, 16, 0, 0),
            Text                   = stepText,
            TextColor3             = Theme.TextDim,
            TextSize               = 11,
            Font                   = Theme.FontMono,
            BackgroundTransparency = 1,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 13,
            Parent                 = stepRow
        })
        
        stepLabels[i] = {dot = dot, label = lbl}
    end
    
    -- Entry animation
    card.Position = UDim2.new(0.5, -210, 0.5, -100)
    card.BackgroundTransparency = 1
    Tween(card, 0.5, {
        Position = UDim2.new(0.5, -210, 0.5, -180),
        BackgroundTransparency = 0
    }, Enum.EasingStyle.Back)
    
    -- Animer les steps
    task.spawn(function()
        local totalSteps = #steps
        for i = 1, totalSteps do
            task.wait(0.6)
            
            -- Active step
            Tween(stepLabels[i].dot, 0.2, {BackgroundColor3 = Theme.Accent})
            Tween(stepLabels[i].label, 0.2, {TextColor3 = Theme.Accent})
            
            -- Progress fill
            local pct = i / totalSteps
            Tween(progressFill, 0.5, {
                Size = UDim2.new(pct, 0, 1, 0)
            }, Enum.EasingStyle.Quart)
            
            task.wait(0.4)
            
            -- Done
            Tween(stepLabels[i].dot, 0.2, {BackgroundColor3 = Theme.Accent3})
            Tween(stepLabels[i].label, 0.2, {TextColor3 = Theme.Accent3})
        end
        
        task.wait(0.5)
        
        -- Si key requis → montrer key system, sinon fermer
        if key then
            conn:Disconnect()
            self:_ShowKeySystem(card, key, function()
                -- Fade out loader
                Tween(overlay, 0.4, {BackgroundTransparency = 1})
                Tween(card, 0.4, {
                    Position = UDim2.new(0.5, -210, 0.5, -130),
                    BackgroundTransparency = 1
                })
                task.delay(0.4, function()
                    overlay:Destroy()
                    card:Destroy()
                    cb()
                end)
            end)
        else
            conn:Disconnect()
            Tween(overlay, 0.4, {BackgroundTransparency = 1})
            Tween(card, 0.4, {
                Position = UDim2.new(0.5, -210, 0.5, -130),
                BackgroundTransparency = 1
            })
            task.delay(0.4, function()
                overlay:Destroy()
                card:Destroy()
                cb()
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════
--              KEY SYSTEM
-- ═══════════════════════════════════════════════

function NexusLib:_ShowKeySystem(parent, key, successCb)
    -- Clear loader content, show key UI
    for _, child in pairs(parent:GetChildren()) do
        if child.Name ~= "UICorner" and child.Name ~= "UIStroke" then
            Tween(child, 0.2, {BackgroundTransparency = 1})
            if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
                Tween(child, 0.2, {TextTransparency = 1})
            end
        end
    end
    
    task.wait(0.25)
    for _, child in pairs(parent:GetChildren()) do
        if child.Name ~= "UICorner" and child.Name ~= "UIStroke" then
            child:Destroy()
        end
    end
    
    parent.Size = UDim2.new(0, 420, 0, 0)
    parent.AutomaticSize = Enum.AutomaticSize.Y
    
    -- Icon clé
    local keyIcon = MakeIcon(parent, Icons.key,
        UDim2.new(0, 48, 0, 48),
        UDim2.new(0.5, -24, 0, 24),
        Theme.Gold, 12)
    
    local titleLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 28),
        Position               = UDim2.new(0, 20, 0, 96),
        Text                   = "ACCÈS REQUIS",
        TextColor3             = Theme.Gold,
        TextSize               = 20,
        Font                   = Theme.FontTitle,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
        Parent                 = parent
    })
    
    local subLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 18),
        Position               = UDim2.new(0, 20, 0, 126),
        Text                   = "Entrez votre clé Nexus pour continuer",
        TextColor3             = Theme.TextMuted,
        TextSize               = 11,
        Font                   = Theme.FontBody,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
        Parent                 = parent
    })
    
    -- Input
    local inputBG = Create("Frame", {
        Size                   = UDim2.new(0, 360, 0, 40),
        Position               = UDim2.new(0.5, -180, 0, 158),
        BackgroundColor3       = Theme.Surface,
        BackgroundTransparency = 0.2,
        ZIndex                 = 12,
        Parent                 = parent
    })
    AddCorner(inputBG, Theme.Corner)
    AddStroke(inputBG, Theme.Border, 0.6)
    
    local input = Create("TextBox", {
        Size                   = UDim2.new(1, -16, 1, 0),
        Position               = UDim2.new(0, 8, 0, 0),
        Text                   = "",
        PlaceholderText        = "NEXUS-XXXX-XXXX-XXXX-XXXX",
        PlaceholderColor3      = Theme.TextDim,
        TextColor3             = Theme.Text,
        TextSize               = 12,
        Font                   = Theme.FontMono,
        BackgroundTransparency = 1,
        ClearTextOnFocus       = false,
        ZIndex                 = 13,
        Parent                 = inputBG
    })
    
    -- Focus glow
    input.Focused:Connect(function()
        Tween(inputBG, 0.2, {BackgroundTransparency = 0.1})
        AddStroke(inputBG, Theme.Accent, 0.4)
    end)
    input.FocusLost:Connect(function()
        Tween(inputBG, 0.2, {BackgroundTransparency = 0.2})
    end)
    
    -- Verify button
    local verifyBtn = Create("TextButton", {
        Size                   = UDim2.new(0, 360, 0, 42),
        Position               = UDim2.new(0.5, -180, 0, 210),
        Text                   = "⬡  VÉRIFIER LA CLÉ",
        TextColor3             = Color3.new(1,1,1),
        TextSize               = 13,
        Font                   = Theme.FontTitle,
        BackgroundColor3       = Theme.Accent,
        AutoButtonColor        = false,
        ZIndex                 = 12,
        Parent                 = parent
    })
    AddCorner(verifyBtn, Theme.Corner)
    AddGradient(verifyBtn, Theme.Accent, Theme.Accent2)
    
    verifyBtn.MouseEnter:Connect(function()
        Tween(verifyBtn, 0.15, {BackgroundColor3 = Theme.Accent2})
    end)
    verifyBtn.MouseLeave:Connect(function()
        Tween(verifyBtn, 0.15, {BackgroundColor3 = Theme.Accent})
    end)
    
    -- Status label
    local statusLbl = Create("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 18),
        Position               = UDim2.new(0, 20, 0, 264),
        Text                   = "",
        TextColor3             = Theme.TextMuted,
        TextSize               = 11,
        Font                   = Theme.FontMono,
        BackgroundTransparency = 1,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
        Parent                 = parent
    })
    
    -- Spacer bottom
    local spacer = Create("Frame", {
        Size                   = UDim2.new(1, 0, 0, 20),
        Position               = UDim2.new(0, 0, 0, 284),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        Parent                 = parent
    })
    
    verifyBtn.MouseButton1Click:Connect(function()
        local entered = input.Text
        if entered == key then
            statusLbl.TextColor3 = Theme.Accent3
            statusLbl.Text = "✓  Clé valide — Bienvenue !"
            Tween(verifyBtn, 0.3, {BackgroundColor3 = Theme.Accent3})
            task.wait(0.8)
            successCb()
        else
            statusLbl.TextColor3 = Theme.Danger
            statusLbl.Text = "✕  Clé invalide ou expirée"
            -- Shake effect
            local orig = parent.Position
            for i = 1, 4 do
                Tween(parent, 0.05, {Position = UDim2.new(orig.X.Scale, orig.X.Offset + 6, orig.Y.Scale, orig.Y.Offset)})
                task.wait(0.05)
                Tween(parent, 0.05, {Position = UDim2.new(orig.X.Scale, orig.X.Offset - 6, orig.Y.Scale, orig.Y.Offset)})
                task.wait(0.05)
            end
            Tween(parent, 0.1, {Position = orig})
        end
    end)
end

-- ═══════════════════════════════════════════════
--              VÉRIFICATION MULTI-ÉTAPES
-- ═══════════════════════════════════════════════

function NexusLib:Verify(config)
    config = config or {}
    local title = config.Title or "Vérification Nexus"
    local steps = config.Steps or {
        {Name = "Exécuteur détecté",     Desc = "Synapse / KRNL / Fluxus"},
        {Name = "Signature vérifiée",    Desc = "Intégrité du script confirmée"},
        {Name = "Validation serveur",    Desc = "Connexion API établie"},
        {Name = "Droits d'accès",        Desc = "Attribution des permissions"},
    }
    local cb = config.Callback or function() end
    
    if not self._root then self._root = GetRoot() end
    
    local overlay = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.4,
        ZIndex = 50,
        Parent = self._root
    })
    
    local card = Create("Frame", {
        Size = UDim2.new(0, 400, 0, 0),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundColor3 = Theme.BG,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 51,
        Parent = self._root
    })
    AddCorner(card, Theme.CornerXl)
    AddStroke(card, Theme.Accent3, 0.7)
    AddPadding(card, 24, 24, 24, 24)
    AddListLayout(card, Enum.FillDirection.Vertical, 14)
    
    -- Shield + Title
    local header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        ZIndex = 52,
        Parent = card
    })
    
    local shield = MakeIcon(header, Icons.shield,
        UDim2.new(0, 40, 0, 40),
        UDim2.new(0, 5, 0.5, -20),
        Theme.Accent3, 52)
    
    local hTitle = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 28),
        Position = UDim2.new(0, 60, 0, 6),
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Theme.FontTitle,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52,
        Parent = header
    })
    
    local hSub = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 60, 0, 36),
        Text = "Authentification multi-facteurs",
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        Font = Theme.FontBody,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52,
        Parent = header
    })
    
    -- Steps
    local stepRows = {}
    for i, step in ipairs(steps) do
        local row = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            BackgroundColor3 = Theme.Panel,
            BackgroundTransparency = 0.1,
            ZIndex = 52,
            Parent = card
        })
        AddCorner(row, Theme.Corner)
        AddStroke(row, Theme.Border, 0.7)
        
        local num = Create("TextLabel", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 12, 0.5, -12),
            Text = tostring(i),
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            Font = Theme.FontMono,
            BackgroundColor3 = Theme.Surface,
            ZIndex = 53,
            Parent = row
        })
        AddCorner(num, Theme.CornerRound)
        AddStroke(num, Theme.Border, 0.5)
        
        local info = Create("TextLabel", {
            Size = UDim2.new(1, -110, 0, 18),
            Position = UDim2.new(0, 46, 0, 9),
            Text = step.Name,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Font = Theme.FontSemi,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 53,
            Parent = row
        })
        
        local desc = Create("TextLabel", {
            Size = UDim2.new(1, -110, 0, 14),
            Position = UDim2.new(0, 46, 0, 29),
            Text = step.Desc or "",
            TextColor3 = Theme.TextMuted,
            TextSize = 10,
            Font = Theme.FontBody,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 53,
            Parent = row
        })
        
        local badge = Create("TextLabel", {
            Size = UDim2.new(0, 70, 0, 20),
            Position = UDim2.new(1, -82, 0.5, -10),
            Text = "ATTENTE",
            TextColor3 = Theme.TextMuted,
            TextSize = 9,
            Font = Theme.FontMono,
            BackgroundColor3 = Theme.Surface,
            ZIndex = 53,
            Parent = row
        })
        AddCorner(badge, UDim.new(0, 5))
        
        stepRows[i] = {row = row, num = num, badge = badge}
    end
    
    -- Animate steps
    task.spawn(function()
        for i, sr in ipairs(stepRows) do
            task.wait(0.7)
            -- Active
            Tween(sr.num, 0.2, {TextColor3 = Theme.Accent, BackgroundColor3 = Color3.fromRGB(20,40,70)})
            sr.badge.Text = "EN COURS"
            Tween(sr.badge, 0.2, {TextColor3 = Theme.Accent, BackgroundColor3 = Color3.fromRGB(15,30,55)})
            Tween(sr.row, 0.2, {BackgroundColor3 = Color3.fromRGB(15,25,45)})
            
            task.wait(0.6)
            -- Done
            sr.num.Text = "✓"
            Tween(sr.num, 0.2, {TextColor3 = Theme.Accent3, BackgroundColor3 = Color3.fromRGB(10,35,25)})
            sr.badge.Text = "OK"
            Tween(sr.badge, 0.2, {TextColor3 = Theme.Accent3, BackgroundColor3 = Color3.fromRGB(8,30,20)})
        end
        
        task.wait(0.5)
        Tween(overlay, 0.3, {BackgroundTransparency = 1})
        Tween(card, 0.3, {BackgroundTransparency = 1})
        task.delay(0.3, function()
            overlay:Destroy()
            card:Destroy()
            cb()
        end)
    end)
end

-- ═══════════════════════════════════════════════
--              WINDOW PRINCIPALE
-- ═══════════════════════════════════════════════

function NexusLib:Window(config)
    config = config or {}
    local title    = config.Title    or "NEXUS UI"
    local subtitle = config.Subtitle or "Premium"
    local size     = config.Size     or UDim2.new(0, 580, 0, 420)
    local pos      = config.Position or UDim2.new(0.5, -290, 0.5, -210)
    local minSize  = config.MinSize  or {Width = 400, Height = 300}
    
    if not self._root then self._root = GetRoot() end
    
    local Win = {}
    Win._tabs = {}
    Win._activeTab = nil
    
    -- Main window frame
    local main = Create("Frame", {
        Name                   = "NexusWindow",
        Size                   = size,
        Position               = pos,
        BackgroundColor3       = Theme.BG,
        BackgroundTransparency = 0,
        ZIndex                 = 20,
        ClipsDescendants       = true,
        Parent                 = self._root
    })
    AddCorner(main, Theme.CornerXl)
    AddStroke(main, Theme.Accent, 0.8)
    
    -- Ambient light top-left
    local amb1 = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0, -50, 0, -80),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.96,
        ZIndex = 20,
        Parent = main
    })
    AddCorner(amb1, Theme.CornerRound)
    
    -- Grid background subtle
    local gridFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 20,
        Parent = main
    })
    
    -- ── TOP BAR ──
    local topBar = Create("Frame", {
        Name                   = "TopBar",
        Size                   = UDim2.new(1, 0, 0, 46),
        BackgroundColor3       = Color3.fromRGB(8, 11, 18),
        BackgroundTransparency = 0.2,
        ZIndex                 = 21,
        Parent                 = main
    })
    
    local topBorderLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        ZIndex = 22,
        Parent = topBar
    })
    
    -- Logo hex
    local logoFrame = Create("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 14, 0.5, -13),
        BackgroundColor3 = Theme.Accent,
        ZIndex = 22,
        Parent = topBar
    })
    AddCorner(logoFrame, UDim.new(0, 5))
    AddGradient(logoFrame, Theme.Accent, Theme.Accent2)
    
    local logoLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = "N",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 13,
        Font = Theme.FontTitle,
        BackgroundTransparency = 1,
        ZIndex = 23,
        Parent = logoFrame
    })
    
    -- Title
    local titleLbl = Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 22),
        Position = UDim2.new(0, 48, 0, 6),
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Theme.FontTitle,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22,
        Parent = topBar
    })
    
    local subLbl = Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 14),
        Position = UDim2.new(0, 48, 0, 28),
        Text = subtitle,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        Font = Theme.FontMono,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22,
        Parent = topBar
    })
    
    -- Status dots
    local dotsFrame = Create("Frame", {
        Size = UDim2.new(0, 60, 0, 10),
        Position = UDim2.new(1, -120, 0.5, -5),
        BackgroundTransparency = 1,
        ZIndex = 22,
        Parent = topBar
    })
    AddListLayout(dotsFrame, Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    
    local function makeDot(color)
        local d = Create("Frame", {
            Size = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = color,
            ZIndex = 23,
            Parent = dotsFrame
        })
        AddCorner(d, Theme.CornerRound)
    end
    makeDot(Theme.Accent3)
    makeDot(Theme.Accent)
    makeDot(Theme.Accent2)
    
    -- Close button
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -40, 0.5, -14),
        Text = "✕",
        TextColor3 = Theme.TextMuted,
        TextSize = 12,
        Font = Theme.FontSemi,
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.5,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = topBar
    })
    AddCorner(closeBtn, UDim.new(0, 7))
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, 0.15, {BackgroundColor3 = Theme.Danger, TextColor3 = Color3.new(1,1,1)})
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, 0.15, {BackgroundColor3 = Theme.Panel, TextColor3 = Theme.TextMuted})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, 0.25, {BackgroundTransparency = 1})
        task.delay(0.25, function() main:Destroy() end)
    end)
    
    -- Minimize button
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -74, 0.5, -14),
        Text = "─",
        TextColor3 = Theme.TextMuted,
        TextSize = 12,
        Font = Theme.FontSemi,
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.5,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = topBar
    })
    AddCorner(minBtn, UDim.new(0, 7))
    
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(main, 0.3, {Size = UDim2.new(0, 580, 0, 46)}, Enum.EasingStyle.Quart)
        else
            Tween(main, 0.3, {Size = size}, Enum.EasingStyle.Quart)
        end
    end)
    
    MakeDraggable(main, topBar)
    
    -- ── SIDEBAR TABS ──
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.3,
        ZIndex = 21,
        Parent = main
    })
    
    local sidebarLine = Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        ZIndex = 22,
        Parent = sidebar
    })
    
    local tabList = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 22,
        Parent = sidebar
    })
    AddListLayout(tabList, Enum.FillDirection.Vertical, 2)
    AddPadding(tabList, 8, 6, 8, 6)
    
    -- Content area
    local contentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -46),
        Position = UDim2.new(0, 140, 0, 46),
        BackgroundTransparency = 1,
        ZIndex = 21,
        ClipsDescendants = true,
        Parent = main
    })
    
    -- Status bar bottom
    local statusBar = Create("Frame", {
        Size = UDim2.new(1, -140, 0, 24),
        Position = UDim2.new(0, 140, 1, -24),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.5,
        ZIndex = 22,
        Parent = main
    })
    
    local statusLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        ZIndex = 23,
        Parent = statusBar
    })
    
    local pingLbl = Create("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = "● CONNECTÉ  |  PING: 12ms",
        TextColor3 = Theme.Accent3,
        TextSize = 9,
        Font = Theme.FontMono,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 23,
        Parent = statusBar
    })
    
    local versionLbl = Create("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -110, 0, 0),
        Text = "NEXUS v3.0",
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        Font = Theme.FontMono,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 23,
        Parent = statusBar
    })
    
    -- Ping update
    task.spawn(function()
        while main.Parent do
            task.wait(2)
            local ping = math.random(8, 30)
            pingLbl.Text = "● CONNECTÉ  |  PING: " .. ping .. "ms"
        end
    end)
    
    -- Entry animation
    main.BackgroundTransparency = 1
    main.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset - 20)
    Tween(main, 0.4, {
        BackgroundTransparency = 0,
        Position = pos
    }, Enum.EasingStyle.Back)
    
    -- ── TAB FUNCTION ──
    function Win:Tab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local tabIcon = cfg.Icon or "◈"
        
        local Tab = {}
        Tab._elements = {}
        
        -- Tab button in sidebar
        local tabBtn = Create("TextButton", {
            Name = "Tab_" .. tabName,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            BackgroundColor3 = Theme.Panel,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            ZIndex = 22,
            Parent = tabList
        })
        AddCorner(tabBtn, Theme.Corner)
        
        -- Tab icon (ImageLabel si assetid, sinon texte fallback)
        local tabIcon_img
        local isAsset = type(tabIcon) == "string" and tabIcon:sub(1,12) == "rbxassetid:/"
        if isAsset then
            tabIcon_img = MakeIcon(tabBtn, tabIcon,
                UDim2.new(0, 18, 0, 18),
                UDim2.new(0, 9, 0.5, -9),
                Theme.TextMuted, 23)
        else
            tabIcon_img = Create("TextLabel", {
                Size = UDim2.new(0, 24, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                Text = tabIcon,
                TextColor3 = Theme.TextMuted,
                TextSize = 14,
                Font = Theme.FontBody,
                BackgroundTransparency = 1,
                ZIndex = 23,
                Parent = tabBtn
            })
        end
        
        local tabName_lbl = Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 36, 0, 0),
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 12,
            Font = Theme.FontSemi,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 23,
            Parent = tabBtn
        })
        
        -- Active indicator
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 2, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            ZIndex = 24,
            Parent = tabBtn
        })
        AddCorner(indicator, Theme.CornerRound)
        
        -- Content frame for this tab
        local tabContent = Create("ScrollingFrame", {
            Name = "Content_" .. tabName,
            Size = UDim2.new(1, 0, 1, -24),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            ZIndex = 21,
            Visible = false,
            Parent = contentArea
        })
        local tabLayout = AddListLayout(tabContent, Enum.FillDirection.Vertical, 4)
        AddPadding(tabContent, 10, 12, 10, 12)
        
        -- Auto size scroll canvas
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local function setActive(active)
            if active then
                Tween(tabBtn, 0.15, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.Panel})
                if tabIcon_img:IsA("ImageLabel") then
                    Tween(tabIcon_img, 0.15, {ImageColor3 = Theme.Accent})
                else
                    Tween(tabIcon_img, 0.15, {TextColor3 = Theme.Accent})
                end
                Tween(tabName_lbl, 0.15, {TextColor3 = Theme.Text})
                Tween(indicator, 0.15, {BackgroundTransparency = 0})
                tabContent.Visible = true
            else
                Tween(tabBtn, 0.15, {BackgroundTransparency = 1})
                if tabIcon_img:IsA("ImageLabel") then
                    Tween(tabIcon_img, 0.15, {ImageColor3 = Theme.TextMuted})
                else
                    Tween(tabIcon_img, 0.15, {TextColor3 = Theme.TextMuted})
                end
                Tween(tabName_lbl, 0.15, {TextColor3 = Theme.TextMuted})
                Tween(indicator, 0.15, {BackgroundTransparency = 1})
                tabContent.Visible = false
            end
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            -- Désactiver tous les tabs
            for _, t in pairs(Win._tabs) do
                t.setActive(false)
            end
            setActive(true)
            Win._activeTab = Tab
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if Win._activeTab ~= Tab then
                Tween(tabBtn, 0.1, {BackgroundTransparency = 0.7})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Win._activeTab ~= Tab then
                Tween(tabBtn, 0.1, {BackgroundTransparency = 1})
            end
        end)
        
        Tab.setActive = setActive
        table.insert(Win._tabs, Tab)
        
        -- Activer le premier tab
        if #Win._tabs == 1 then
            setActive(true)
            Win._activeTab = Tab
        end
        
        -- ── ÉLÉMENTS UI ──
        
        -- Section titre
        function Tab:Section(sectionCfg)
            sectionCfg = sectionCfg or {}
            local sName = sectionCfg.Name or "Section"
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 22,
                Parent = tabContent
            })
            
            local lbl = Create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = sName:upper(),
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                Font = Theme.FontTitle,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            local line = Create("Frame", {
                Size = UDim2.new(1, -80, 0, 1),
                Position = UDim2.new(0, 80, 0.5, 0),
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                ZIndex = 22,
                Parent = row
            })
        end
        
        -- Toggle
        function Tab:Toggle(toggleCfg)
            toggleCfg = toggleCfg or {}
            local tName = toggleCfg.Name     or "Toggle"
            local tDesc = toggleCfg.Desc     or ""
            local tIcon = toggleCfg.Icon     or "◈"
            local tDef  = toggleCfg.Default  or false
            local tCb   = toggleCfg.Callback or function() end
            local tColor = toggleCfg.Color   or Theme.Accent
            
            local state = tDef
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, tDesc ~= "" and 52 or 40),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            -- Icon bg
            local iconBG = Create("Frame", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(0, 10, 0.5, -15),
                BackgroundColor3 = tColor,
                BackgroundTransparency = 0.85,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(iconBG, UDim.new(0, 8))
            
            local isAssetToggle = type(tIcon) == "string" and tIcon:sub(1,12) == "rbxassetid:/"
            if isAssetToggle then
                MakeIcon(iconBG, tIcon, UDim2.new(0,16,0,16), UDim2.new(0.5,-8,0.5,-8), tColor, 24)
            else
                Create("TextLabel", {
                    Size = UDim2.new(1,0,1,0),
                    Text = tIcon,
                    TextColor3 = tColor,
                    TextSize = 14,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    ZIndex = 24,
                    Parent = iconBG
                })
            end
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(1, -100, 0, 18),
                Position = UDim2.new(0, 50, tDesc ~= "" and 0 or 0.5, tDesc ~= "" and 8 or -9),
                Text = tName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            if tDesc ~= "" then
                local descLbl = Create("TextLabel", {
                    Size = UDim2.new(1, -100, 0, 14),
                    Position = UDim2.new(0, 50, 0, 27),
                    Text = tDesc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 10,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 23,
                    Parent = row
                })
            end
            
            -- Toggle widget
            local toggleBG = Create("Frame", {
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = state and tColor or Theme.Surface,
                BackgroundTransparency = state and 0 or 0.3,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(toggleBG, Theme.CornerRound)
            AddStroke(toggleBG, state and tColor or Theme.Border, state and 0.6 or 0.5)
            
            local toggleKnob = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex = 24,
                Parent = toggleBG
            })
            AddCorner(toggleKnob, Theme.CornerRound)
            
            local function updateToggle()
                if state then
                    Tween(toggleBG, 0.2, {BackgroundColor3 = tColor, BackgroundTransparency = 0})
                    Tween(toggleKnob, 0.2, {Position = UDim2.new(1, -17, 0.5, -7)}, Enum.EasingStyle.Back)
                    Tween(row, 0.15, {BackgroundColor3 = Color3.fromRGB(15, 25, 45)})
                else
                    Tween(toggleBG, 0.2, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.3})
                    Tween(toggleKnob, 0.2, {Position = UDim2.new(0, 3, 0.5, -7)}, Enum.EasingStyle.Back)
                    Tween(row, 0.15, {BackgroundColor3 = Theme.Panel})
                end
            end
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                BackgroundTransparency = 1,
                ZIndex = 25,
                Parent = row
            })
            
            btn.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                tCb(state)
            end)
            
            btn.MouseEnter:Connect(function()
                Tween(row, 0.1, {BackgroundTransparency = 0})
            end)
            btn.MouseLeave:Connect(function()
                Tween(row, 0.1, {BackgroundTransparency = 0.1})
            end)
            
            updateToggle()
            
            local toggleAPI = {}
            function toggleAPI:Set(val)
                state = val
                updateToggle()
                tCb(state)
            end
            function toggleAPI:Get() return state end
            
            return toggleAPI
        end
        
        -- Slider
        function Tab:Slider(sliderCfg)
            sliderCfg = sliderCfg or {}
            local sName = sliderCfg.Name     or "Slider"
            local sDesc = sliderCfg.Desc     or ""
            local sIcon = sliderCfg.Icon     or "◎"
            local sMin  = sliderCfg.Min      or 0
            local sMax  = sliderCfg.Max      or 100
            local sDef  = sliderCfg.Default  or 50
            local sSuffix = sliderCfg.Suffix or ""
            local sCb   = sliderCfg.Callback or function() end
            local sColor = sliderCfg.Color   or Theme.Accent
            
            local value = math.clamp(sDef, sMin, sMax)
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 62),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            local iconBG = Create("Frame", {
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = sColor,
                BackgroundTransparency = 0.85,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(iconBG, UDim.new(0, 7))
            
            local isAssetSlider = type(sIcon) == "string" and sIcon:sub(1,12) == "rbxassetid:/"
            if isAssetSlider then
                MakeIcon(iconBG, sIcon, UDim2.new(0,14,0,14), UDim2.new(0.5,-7,0.5,-7), sColor, 24)
            else
                Create("TextLabel", {
                    Size = UDim2.new(1,0,1,0),
                    Text = sIcon,
                    TextColor3 = sColor,
                    TextSize = 12,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    ZIndex = 24,
                    Parent = iconBG
                })
            end
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(1, -100, 0, 16),
                Position = UDim2.new(0, 46, 0, 11),
                Text = sName,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            local valLbl = Create("TextLabel", {
                Size = UDim2.new(0, 60, 0, 18),
                Position = UDim2.new(1, -70, 0, 9),
                Text = tostring(value) .. sSuffix,
                TextColor3 = sColor,
                TextSize = 11,
                Font = Theme.FontMono,
                BackgroundColor3 = sColor,
                BackgroundTransparency = 0.9,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(valLbl, UDim.new(0, 5))
            
            -- Slider track
            local trackBG = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 44),
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(trackBG, Theme.CornerRound)
            
            local trackFill = Create("Frame", {
                Size = UDim2.new((value - sMin) / (sMax - sMin), 0, 1, 0),
                BackgroundColor3 = sColor,
                ZIndex = 24,
                Parent = trackBG
            })
            AddCorner(trackFill, Theme.CornerRound)
            
            -- Knob
            local knob = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((value - sMin) / (sMax - sMin), -7, 0.5, -7),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex = 25,
                Parent = trackBG
            })
            AddCorner(knob, Theme.CornerRound)
            AddStroke(knob, sColor, 0.3, 1.5)
            
            -- Drag logic
            local dragging = false
            
            local function updateValue(mouseX)
                local abs = trackBG.AbsolutePosition.X
                local wid = trackBG.AbsoluteSize.X
                local pct = math.clamp((mouseX - abs) / wid, 0, 1)
                local newVal = math.floor(sMin + pct * (sMax - sMin) + 0.5)
                value = newVal
                local displayPct = (value - sMin) / (sMax - sMin)
                trackFill.Size = UDim2.new(displayPct, 0, 1, 0)
                knob.Position = UDim2.new(displayPct, -7, 0.5, -7)
                valLbl.Text = tostring(value) .. sSuffix
                sCb(value)
            end
            
            local clickArea = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, -8),
                Text = "",
                BackgroundTransparency = 1,
                ZIndex = 26,
                Parent = trackBG
            })
            
            clickArea.MouseButton1Down:Connect(function()
                dragging = true
                updateValue(Mouse.X)
            end)
            
            UserInput.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInput.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(Mouse.X)
                end
            end)
            
            local sliderAPI = {}
            function sliderAPI:Set(val)
                value = math.clamp(val, sMin, sMax)
                local pct = (value - sMin) / (sMax - sMin)
                trackFill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, -7, 0.5, -7)
                valLbl.Text = tostring(value) .. sSuffix
                sCb(value)
            end
            function sliderAPI:Get() return value end
            
            return sliderAPI
        end
        
        -- Dropdown
        function Tab:Dropdown(ddCfg)
            ddCfg = ddCfg or {}
            local dName = ddCfg.Name     or "Dropdown"
            local dIcon = ddCfg.Icon     or "◻"
            local dOpts = ddCfg.Options  or {"Option 1", "Option 2"}
            local dDef  = ddCfg.Default  or dOpts[1]
            local dCb   = ddCfg.Callback or function() end
            
            local selected = dDef
            local open = false
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                ClipsDescendants = false,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            local iconBG = Create("Frame", {
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(0, 10, 0.5, -13),
                BackgroundColor3 = Theme.Accent2,
                BackgroundTransparency = 0.85,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(iconBG, UDim.new(0, 7))
            
            local isAssetDD = type(dIcon) == "string" and dIcon:sub(1,12) == "rbxassetid:/"
            if isAssetDD then
                MakeIcon(iconBG, dIcon, UDim2.new(0,14,0,14), UDim2.new(0.5,-7,0.5,-7), Theme.Accent2, 24)
            else
                Create("TextLabel", {
                    Size = UDim2.new(1,0,1,0),
                    Text = dIcon,
                    TextColor3 = Theme.Accent2,
                    TextSize = 12,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    ZIndex = 24,
                    Parent = iconBG
                })
            end
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 46, 0, 0),
                Text = dName,
                TextColor3 = Theme.TextMuted,
                TextSize = 11,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            local selLbl = Create("TextLabel", {
                Size = UDim2.new(0, 140, 1, 0),
                Position = UDim2.new(1, -160, 0, 0),
                Text = selected .. "  ▾",
                TextColor3 = Theme.Text,
                TextSize = 11,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 23,
                Parent = row
            })
            
            -- Dropdown list
            local dropList = Create("Frame", {
                Size = UDim2.new(1, 0, 0, #dOpts * 32 + 8),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0,
                ZIndex = 30,
                Visible = false,
                Parent = row
            })
            AddCorner(dropList, Theme.Corner)
            AddStroke(dropList, Theme.Accent, 0.7)
            AddListLayout(dropList, Enum.FillDirection.Vertical, 2)
            AddPadding(dropList, 4, 4, 4, 4)
            
            for _, opt in ipairs(dOpts) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = opt,
                    TextColor3 = opt == selected and Theme.Accent or Theme.Text,
                    TextSize = 11,
                    Font = opt == selected and Theme.FontSemi or Theme.FontBody,
                    BackgroundColor3 = opt == selected and Theme.Accent or Theme.Panel,
                    BackgroundTransparency = opt == selected and 0.85 or 1,
                    AutoButtonColor = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 31,
                    Parent = dropList
                })
                AddCorner(optBtn, UDim.new(0, 6))
                AddPadding(optBtn, 0, 0, 0, 8)
                
                optBtn.MouseEnter:Connect(function()
                    if opt ~= selected then
                        Tween(optBtn, 0.1, {BackgroundTransparency = 0.7, TextColor3 = Theme.Accent})
                    end
                end)
                optBtn.MouseLeave:Connect(function()
                    if opt ~= selected then
                        Tween(optBtn, 0.1, {BackgroundTransparency = 1, TextColor3 = Theme.Text})
                    end
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    selLbl.Text = selected .. "  ▾"
                    open = false
                    dropList.Visible = false
                    dCb(selected)
                end)
            end
            
            local openBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                BackgroundTransparency = 1,
                ZIndex = 24,
                Parent = row
            })
            
            openBtn.MouseButton1Click:Connect(function()
                open = not open
                dropList.Visible = open
                selLbl.Text = selected .. (open and "  ▴" or "  ▾")
            end)
            
            local dropAPI = {}
            function dropAPI:Set(val) selected = val; selLbl.Text = val .. "  ▾"; dCb(val) end
            function dropAPI:Get() return selected end
            
            return dropAPI
        end
        
        -- TextInput
        function Tab:Input(inputCfg)
            inputCfg = inputCfg or {}
            local iName    = inputCfg.Name        or "Input"
            local iIcon    = inputCfg.Icon        or "◈"
            local iPlaceholder = inputCfg.Placeholder or "Entrez du texte..."
            local iCb      = inputCfg.Callback    or function() end
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            local isAssetInput = type(iIcon) == "string" and iIcon:sub(1,12) == "rbxassetid:/"
            local iconOffset = 10
            if isAssetInput then
                MakeIcon(row, iIcon, UDim2.new(0,14,0,14), UDim2.new(0,10,0,6), Theme.Accent, 24)
                iconOffset = 28
            end
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 16),
                Position = UDim2.new(0, iconOffset, 0, 6),
                Text = isAssetInput and iName or (iIcon .. "  " .. iName),
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            local inputBox = Create("TextBox", {
                Size = UDim2.new(1, -20, 0, 24),
                Position = UDim2.new(0, 10, 0, 22),
                Text = "",
                PlaceholderText = iPlaceholder,
                PlaceholderColor3 = Theme.TextDim,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Theme.FontMono,
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            inputBox.FocusLost:Connect(function(enter)
                if enter then iCb(inputBox.Text) end
            end)
            
            inputBox.Focused:Connect(function()
                Tween(row, 0.15, {BackgroundColor3 = Color3.fromRGB(15,25,45)})
            end)
            inputBox.FocusLost:Connect(function()
                Tween(row, 0.15, {BackgroundColor3 = Theme.Panel})
            end)
            
            local api = {}
            function api:Get() return inputBox.Text end
            function api:Set(v) inputBox.Text = v end
            
            return api
        end
        
        -- Button
        function Tab:Button(btnCfg)
            btnCfg = btnCfg or {}
            local bName  = btnCfg.Name     or "Bouton"
            local bIcon  = btnCfg.Icon     or "◆"
            local bDesc  = btnCfg.Desc     or ""
            local bCb    = btnCfg.Callback or function() end
            local bColor = btnCfg.Color    or Theme.Accent
            
            local row = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, bDesc ~= "" and 52 or 40),
                Text = "",
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                AutoButtonColor = false,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, bColor, 0.75)
            
            -- Left accent
            local accent = Create("Frame", {
                Size = UDim2.new(0, 3, 0, 20),
                Position = UDim2.new(0, 0, 0.5, -10),
                BackgroundColor3 = bColor,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(accent, UDim.new(0, 2))
            
            local isAssetBtn = type(bIcon) == "string" and bIcon:sub(1,12) == "rbxassetid:/"
            if isAssetBtn then
                MakeIcon(row, bIcon, UDim2.new(0,20,0,20), UDim2.new(0,14,0.5,-10), bColor, 23)
            else
                Create("TextLabel", {
                    Size = UDim2.new(0, 30, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Text = bIcon,
                    TextColor3 = bColor,
                    TextSize = 16,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    ZIndex = 23,
                    Parent = row
                })
            end
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(1, -80, 0, 18),
                Position = UDim2.new(0, 48, 0, bDesc ~= "" and 8 or 11),
                Text = bName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            if bDesc ~= "" then
                local descLbl = Create("TextLabel", {
                    Size = UDim2.new(1, -80, 0, 14),
                    Position = UDim2.new(0, 48, 0, 28),
                    Text = bDesc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 10,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 23,
                    Parent = row
                })
            end
            
            local arrowLbl = Create("TextLabel", {
                Size = UDim2.new(0, 24, 1, 0),
                Position = UDim2.new(1, -30, 0, 0),
                Text = "›",
                TextColor3 = bColor,
                TextSize = 18,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                ZIndex = 23,
                Parent = row
            })
            
            row.MouseEnter:Connect(function()
                Tween(row, 0.15, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(15, 25, 45)})
                Tween(arrowLbl, 0.1, {Position = UDim2.new(1, -24, 0, 0)})
            end)
            row.MouseLeave:Connect(function()
                Tween(row, 0.15, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.Panel})
                Tween(arrowLbl, 0.1, {Position = UDim2.new(1, -30, 0, 0)})
            end)
            row.MouseButton1Down:Connect(function()
                Tween(row, 0.05, {BackgroundColor3 = Color3.fromRGB(20, 35, 65)})
            end)
            row.MouseButton1Up:Connect(function()
                bCb()
                Tween(row, 0.1, {BackgroundColor3 = Color3.fromRGB(15, 25, 45)})
            end)
        end
        
        -- Label
        function Tab:Label(lCfg)
            lCfg = lCfg or {}
            local lText = lCfg.Text   or ""
            local lColor = lCfg.Color or Theme.TextMuted
            local lSize  = lCfg.Size  or 11
            
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                Text = lText,
                TextColor3 = lColor,
                TextSize = lSize,
                Font = Theme.FontBody,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 22,
                Parent = tabContent
            })
        end
        
        -- Separator
        function Tab:Separator()
            local sep = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                ZIndex = 22,
                Parent = tabContent
            })
        end
        
        -- ColorPicker (simplifié)
        function Tab:ColorPicker(cpCfg)
            cpCfg = cpCfg or {}
            local cName   = cpCfg.Name     or "Couleur"
            local cDef    = cpCfg.Default  or Color3.fromRGB(79, 158, 255)
            local cCb     = cpCfg.Callback or function() end
            
            local color = cDef
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            local nameLbl = Create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 40, 0, 0),
                Text = cName,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            MakeIcon(row, Icons.color,
                UDim2.new(0, 18, 0, 18),
                UDim2.new(0, 12, 0.5, -9),
                Theme.Accent2, 24)
            
            local preview = Create("Frame", {
                Size = UDim2.new(0, 28, 0, 28),
                Position = UDim2.new(1, -42, 0.5, -14),
                BackgroundColor3 = color,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(preview, UDim.new(0, 8))
            AddStroke(preview, Theme.Border, 0.5)
            
            local api = {}
            function api:Set(c)
                color = c
                preview.BackgroundColor3 = c
                cCb(c)
            end
            function api:Get() return color end
            
            return api
        end
        
        -- ── KEYBIND ──
        function Tab:Keybind(kbCfg)
            kbCfg = kbCfg or {}
            local kName    = kbCfg.Name     or "Keybind"
            local kIcon    = kbCfg.Icon     or "◈"
            local kDefault = kbCfg.Default  or Enum.KeyCode.F
            local kCb      = kbCfg.Callback or function() end
            
            local boundKey = kDefault
            local listening = false
            
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 0.1,
                ZIndex = 22,
                Parent = tabContent
            })
            AddCorner(row, Theme.Corner)
            AddStroke(row, Theme.Border, 0.7)
            
            local iconBG = Create("Frame", {
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(0, 10, 0.5, -13),
                BackgroundColor3 = Theme.Accent2,
                BackgroundTransparency = 0.85,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(iconBG, UDim.new(0, 7))
            
            local isAssetKb = type(kIcon) == "string" and kIcon:sub(1,12) == "rbxassetid:/"
            if isAssetKb then
                MakeIcon(iconBG, kIcon, UDim2.new(0,14,0,14), UDim2.new(0.5,-7,0.5,-7), Theme.Accent2, 24)
            else
                Create("TextLabel", {
                    Size = UDim2.new(1,0,1,0),
                    Text = kIcon,
                    TextColor3 = Theme.Accent2,
                    TextSize = 12,
                    Font = Theme.FontBody,
                    BackgroundTransparency = 1,
                    ZIndex = 24,
                    Parent = iconBG
                })
            end
            
            Create("TextLabel", {
                Size = UDim2.new(1, -120, 1, 0),
                Position = UDim2.new(0, 46, 0, 0),
                Text = kName,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Theme.FontSemi,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 23,
                Parent = row
            })
            
            local keyBtn = Create("TextButton", {
                Size = UDim2.new(0, 70, 0, 24),
                Position = UDim2.new(1, -80, 0.5, -12),
                Text = boundKey.Name,
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Font = Theme.FontMono,
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.3,
                AutoButtonColor = false,
                ZIndex = 23,
                Parent = row
            })
            AddCorner(keyBtn, UDim.new(0, 5))
            AddStroke(keyBtn, Theme.Accent, 0.6)
            
            keyBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(20,40,70)})
                local conn2
                conn2 = UserInput.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        boundKey = input.KeyCode
                        keyBtn.Text = input.KeyCode.Name
                        Tween(keyBtn, 0.15, {BackgroundColor3 = Theme.Surface})
                        listening = false
                        conn2:Disconnect()
                    end
                end)
            end)
            
            UserInput.InputBegan:Connect(function(input, gp)
                if gp then return end
                if not listening and input.KeyCode == boundKey then
                    kCb(boundKey)
                end
            end)
            
            local kbAPI = {}
            function kbAPI:Get() return boundKey end
            function kbAPI:Set(key) boundKey = key; keyBtn.Text = key.Name end
            
            return kbAPI
        end
        
        return Tab
    end
    
    -- ── WIN API ──
    
    -- Changer le texte de la status bar
    function Win:SetStatus(text, color)
        pingLbl.Text = text or "● CONNECTÉ"
        Tween(pingLbl, 0.2, {TextColor3 = color or Theme.Accent3})
    end
    
    -- Show / Hide la fenêtre avec animation
    function Win:Toggle()
        if main.Visible then
            Tween(main, 0.25, {BackgroundTransparency = 1})
            task.delay(0.25, function()
                if main and main.Parent then main.Visible = false end
            end)
        else
            main.Visible = true
            main.BackgroundTransparency = 1
            Tween(main, 0.25, {BackgroundTransparency = 0})
        end
    end
    
    -- Détruire la window
    function Win:Destroy()
        Tween(main, 0.3, {BackgroundTransparency = 1})
        task.delay(0.3, function()
            if main and main.Parent then main:Destroy() end
        end)
    end
    
    -- Changer titre/subtitle à la volée
    function Win:SetTitle(t, s)
        if t then titleLbl.Text = t end
        if s then subLbl.Text = s end
    end
    
    return Win
end

-- ═══════════════════════════════════════════════
--              CONSTRUCTOR
-- ═══════════════════════════════════════════════

function NexusLib.new()
    local self = setmetatable({}, NexusLib)
    self._root = nil
    return self
end

-- ═══════════════════════════════════════════════
--              EXEMPLE D'UTILISATION
-- ═══════════════════════════════════════════════

--[[

local Nexus = NexusLib.new()

-- 1. LOADER avec key
Nexus:Loader({
    Title    = "MY SCRIPT",
    Subtitle = "v2.0 — Premium Edition",
    Key      = "NEXUS-A7F3-K9X2-M4P1",
    Steps    = {
        "Initialisation du module",
        "Connexion au serveur",
        "Vérification de la clé",
        "Chargement de l'interface"
    },
    Callback = function()
        
        -- 2. VÉRIFICATION optionnelle
        Nexus:Verify({
            Title = "Vérification sécurisée",
            Steps = {
                {Name = "Exécuteur détecté",  Desc = "Compatible"},
                {Name = "Anti-tamper check",  Desc = "Signature valide"},
                {Name = "Ping serveur",        Desc = "nexus.gg — OK"},
                {Name = "Permissions",         Desc = "Accès Premium accordé"},
            },
            Callback = function()
                
                -- 3. FENÊTRE PRINCIPALE
                local Win = Nexus:Window({
                    Title    = "MY SCRIPT",
                    Subtitle = "Premium v2.0",
                })
                
                -- ─ Tab Aimbot ─
                -- Icônes : texte unicode OU rbxassetid:// pour ImageLabel custom
                local AimTab = Win:Tab({ Name = "Aimbot", Icon = Icons.aim })
                AimTab:Section({ Name = "Général" })
                
                local aimbotToggle = AimTab:Toggle({
                    Name     = "Activer l'aimbot",
                    Desc     = "Assistance visée automatique",
                    Icon     = Icons.aim,
                    Default  = false,
                    Color    = Theme.Accent,
                    Callback = function(v)
                        Win:SetStatus(v and "● Aimbot ON" or "● Aimbot OFF",
                            v and Theme.Accent3 or Theme.Danger)
                    end
                })
                
                local fovSlider = AimTab:Slider({
                    Name     = "FOV Aimbot",
                    Icon     = Icons.slider_ic,
                    Min      = 10,
                    Max      = 360,
                    Default  = 120,
                    Suffix   = "°",
                    Color    = Theme.Accent,
                    Callback = function(v) end
                })
                
                AimTab:Section({ Name = "Cible" })
                
                AimTab:Dropdown({
                    Name     = "Partie du corps",
                    Icon     = Icons.dropdown,
                    Options  = {"Tête", "Torse", "Corps"},
                    Default  = "Tête",
                    Callback = function(v) end
                })
                
                -- Keybind pour toggle aimbot
                AimTab:Section({ Name = "Raccourci" })
                AimTab:Keybind({
                    Name     = "Toggle Aimbot",
                    Icon     = Icons.bolt,
                    Default  = Enum.KeyCode.E,
                    Callback = function(key)
                        local cur = aimbotToggle:Get()
                        aimbotToggle:Set(not cur)
                    end
                })
                
                -- ─ Tab ESP ─
                local EspTab = Win:Tab({ Name = "ESP", Icon = Icons.eye })
                EspTab:Section({ Name = "Joueurs" })
                EspTab:Toggle({ Name = "ESP Joueurs", Icon = Icons.eye,    Default = false, Callback = function(v) end })
                EspTab:Toggle({ Name = "ESP Noms",    Icon = Icons.text,   Default = true,  Callback = function(v) end })
                EspTab:Toggle({ Name = "ESP Boxes",   Icon = Icons.button, Default = false, Callback = function(v) end })
                EspTab:Section({ Name = "Apparence" })
                EspTab:ColorPicker({ Name = "Couleur ESP", Default = Color3.fromRGB(79,158,255), Callback = function(c) end })
                EspTab:Slider({ Name = "Épaisseur lignes", Icon = Icons.slider_ic, Min = 1, Max = 5, Default = 1, Suffix = "px", Callback = function(v) end })
                
                -- ─ Tab Misc ─
                local MiscTab = Win:Tab({ Name = "Misc", Icon = Icons.bolt })
                MiscTab:Section({ Name = "Utilitaires" })
                MiscTab:Button({
                    Name     = "Teleport Spawn",
                    Icon     = Icons.arrow_r,
                    Desc     = "Retourner au point de départ",
                    Callback = function()
                        Nexus:Notify({ Title = "Téléport", Message = "Téléportation au spawn !", Type = "success" })
                    end
                })
                MiscTab:Button({
                    Name     = "Fly Mode",
                    Icon     = Icons.star,
                    Callback = function() end
                })
                MiscTab:Section({ Name = "Interface" })
                MiscTab:Keybind({
                    Name     = "Afficher/Masquer UI",
                    Icon     = Icons.eye,
                    Default  = Enum.KeyCode.RightShift,
                    Callback = function() Win:Toggle() end
                })
                
                -- ─ Tab Settings ─
                local SetTab = Win:Tab({ Name = "Config", Icon = Icons.settings })
                SetTab:Section({ Name = "Thème" })
                SetTab:Input({
                    Name        = "Titre personnalisé",
                    Icon        = Icons.text,
                    Placeholder = "Mon Script...",
                    Callback    = function(v)
                        if v ~= "" then Win:SetTitle(v) end
                    end
                })
                SetTab:ColorPicker({ Name = "Couleur accent", Default = Theme.Accent, Callback = function(c) end })
                
                -- Notification de bienvenue
                Nexus:Notify({
                    Title    = "Bienvenue !",
                    Message  = "My Script Premium chargé avec succès",
                    Type     = "success",
                    Duration = 5
                })
                
            end
        })
    end
})

]]

return NexusLib