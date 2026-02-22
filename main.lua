--// Dj Hub (Ultimate Version - Cleaned Custom Build)
--// Updated: ROR Reduce Lag+ (10m Loop) with exact Workspace & Lighting structure clean.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer

--=============================================================================
--// GUI LIBRARY & SETUP
--=============================================================================

local colors = {
	background = Color3.fromRGB(15, 15, 15),
	accent = Color3.fromRGB(255, 120, 30),
	text = Color3.fromRGB(240, 240, 240),
	subText = Color3.fromRGB(150, 150, 150),
	toggleOn = Color3.fromRGB(255, 120, 30),
	toggleOff = Color3.fromRGB(60, 60, 60),
	shortcutOn = Color3.fromRGB(0, 255, 128),
	shortcutOff = Color3.fromRGB(255, 50, 50)
}

local function pickGuiParent()
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui")
		if pg then return pg end
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end
	return nil
end

local parent = pickGuiParent()
if not parent then return end

pcall(function()
	if parent:FindFirstChild("DjHubRemastered") then
		parent.DjHubRemastered:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjHubRemastered"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- [FIX GUI] Auto Scale Logic
local uiScale = Instance.new("UIScale")
uiScale.Parent = ScreenGui

local function updateScale()
	local camera = workspace.CurrentCamera
	if camera then
		-- Jika layar kecil (Cloud Gaming/HP Low Res), kecilkan UI
		if camera.ViewportSize.Y < 500 then
			uiScale.Scale = 0.65 -- Kecilkan jadi 65%
		elseif camera.ViewportSize.Y < 720 then
			uiScale.Scale = 0.8 -- Kecilkan jadi 80%
		else
			uiScale.Scale = 1.0 -- Normal
		end
	end
end

-- Jalankan update scale saat start dan saat layar berubah
updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
-- [END FIX GUI]

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(0.05), {Position = newPos}):Play()
	end
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	handle.InputChanged:Connect(function(input)
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- [FIX SIZE] Menggunakan AnchorPoint agar posisi selalu di tengah (Responsive)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
MainFrame.Size = UDim2.new(0, 340, 0, 320) -- Sedikit diperkecil agar pas
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Posisi tepat di tengah layar
MainFrame.BackgroundColor3 = colors.background
MainFrame.BackgroundTransparency = 0.35 
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Tambahkan UIScale lokal ke MainFrame juga untuk kontrol ganda
local mainScale = Instance.new("UIScale", MainFrame)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0, 4, 1, 0)
AccentLine.BackgroundColor3 = colors.accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame
Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 40)
Header.Position = UDim2.new(0, 20, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Dj Hub <font color=\"rgb(255,120,30)\">Premium</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = colors.text
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = colors.text
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamMedium
MinBtn.TextSize = 24
MinBtn.TextColor3 = colors.text
MinBtn.BackgroundTransparency = 1
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Parent = Header

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 1, -50)
Container.Position = UDim2.new(0, 14, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = colors.accent
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

makeDraggable(MainFrame, Header)

local function CreateToggle(text, callback, parentOverride)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = parentOverride or Container
	
	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 13
	Label.TextColor3 = colors.text
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.BackgroundTransparency = 1
	Label.Parent = ToggleFrame
	
	local SwitchBg = Instance.new("Frame")
	SwitchBg.Size = UDim2.new(0, 44, 0, 22)
	SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
	SwitchBg.BackgroundColor3 = colors.toggleOff
	SwitchBg.Parent = ToggleFrame
	Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
	
	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = SwitchBg
	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
	
	local Trigger = Instance.new("TextButton")
	Trigger.Size = UDim2.new(1, 0, 1, 0)
	Trigger.BackgroundTransparency = 1
	Trigger.Text = ""
	Trigger.Parent = ToggleFrame
	
	local toggled = false
	
	Trigger.MouseButton1Click:Connect(function()
		toggled = not toggled
		local targetColor = toggled and colors.toggleOn or colors.toggleOff
		local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
		pcall(callback, toggled)
	end)
end

local function CreateButton(text, callback)
	local BtnFrame = Instance.new("Frame")
	BtnFrame.Size = UDim2.new(1, 0, 0, 36)
	BtnFrame.BackgroundTransparency = 1
	BtnFrame.Parent = Container
	
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 1, 0)
	Btn.Position = UDim2.new(0, 5, 0, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Btn.Text = text
	Btn.TextColor3 = colors.text
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 13
	Btn.Parent = BtnFrame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	
	Btn.MouseButton1Click:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
		task.delay(0.1, function()
			TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
		end)
		pcall(callback)
	end)
end

local function CreateSection(text)
	local Sec = Instance.new("TextLabel")
	Sec.Text = text
	Sec.Size = UDim2.new(1, 0, 0, 25)
	Sec.BackgroundTransparency = 1
	Sec.TextColor3 = colors.subText
	Sec.Font = Enum.Font.GothamBold
	Sec.TextSize = 12
	Sec.TextXAlignment = Enum.TextXAlignment.Left
	Sec.Position = UDim2.new(0, 10, 0, 0)
	Instance.new("UIPadding", Sec).PaddingLeft = UDim.new(0,10)
	Sec.Parent = Container
end

local minimized = false
local MinIcon = Instance.new("TextButton")
MinIcon.Name = "MiniIcon"
MinIcon.Size = UDim2.new(0, 50, 0, 50)
MinIcon.BackgroundColor3 = colors.background
MinIcon.BackgroundTransparency = 0.1
MinIcon.Text = "DJ"
MinIcon.TextColor3 = colors.accent
MinIcon.Font = Enum.Font.GothamBlack
MinIcon.TextSize = 18
MinIcon.Visible = false
MinIcon.Parent = ScreenGui
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MinIcon).Color = colors.accent
Instance.new("UIStroke", MinIcon).Thickness = 2
Instance.new("UIStroke", MinIcon).ApplyStrokeMode = Enum.ApplyStrokeMode.Border

makeDraggable(MinIcon)

MinBtn.MouseButton1Click:Connect(function()
	minimized = true
	MainFrame.Visible = false
	MinIcon.Visible = true
	MinIcon.Position = MainFrame.Position
end)

MinIcon.MouseButton1Click:Connect(function()
	minimized = false
	MinIcon.Visible = false
	MainFrame.Visible = true
	MainFrame.Position = MinIcon.Position
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--=============================================================================
--// FEATURE VARIABLES
--=============================================================================

local platformEnabled = false
local pPart, pConn, lastY = nil, nil, 0
local platformShortcutBtn = nil 

local noclipOn = false
local noclipConn = nil
local ESP = { enabled = {}, connections = {}, markers = {} }
local fastInteractEnabled = false 
local ftConnection = nil
local activeInteractConnections = {} 
local autoConsoleEnabled = false

-- [NEW] GLOBAL LOCK to prevent Slide features from clashing
local actionLock = false

-- [NEW] Underground Mode Variables
local autoClaimTicketEnabled = false 
local autoCoinValentineEnabled = false 

-- [NEW] Lucky Block Variables
local slideSettings = {
	Divine = false,
	Infinity = false,
	Celestial = false,
	Secret = false,
	Mythical = false
}

local undergroundPlatform = nil
local undergroundConnection = nil
local undergroundFixedY = nil 

local followTarget = nil
local followConnection = nil
local autoEquipEnabled = false
local antiAfkConnection = nil
local autoReduceLagEnabled = false

--=============================================================================
--// LOGIC FUNCTIONS
--=============================================================================

local function togglePlatformState(state)
	if state then
		if not pPart then
			pPart = Instance.new("Part", workspace)
			pPart.Name = "DjPlatform"
			pPart.Size = Vector3.new(15, 0.5, 15)
			pPart.Anchored = true
			pPart.Transparency = 0.5
			pPart.Material = Enum.Material.ForceField
			pPart.Color = Color3.fromRGB(0, 255, 255)
			
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2
			end
			
			pConn = RunService.PostSimulation:Connect(function()
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					local hum = lp.Character:FindFirstChild("Humanoid")
					if hum and hum.FloorMaterial == Enum.Material.Air then lastY = hrp.Position.Y - 3.2 end
					pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
				end
			end)
		end
	else
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end
	end
end

-- [NEW] Special Underground Platform Logic (-10 Studs)
local function toggleUndergroundPlatform(state)
	if state then
		if not undergroundPlatform then 
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				if not undergroundFixedY then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, -10, 0)
					undergroundFixedY = hrp.Position.Y 
				end
			end
			
			undergroundPlatform = Instance.new("Part", workspace)
			undergroundPlatform.Name = "DjUndergroundPlatform"
			undergroundPlatform.Size = Vector3.new(15, 1, 15)
			undergroundPlatform.Anchored = true
			undergroundPlatform.Transparency = 0.5
			undergroundPlatform.Material = Enum.Material.Neon
			undergroundPlatform.Color = Color3.fromRGB(150, 0, 0) 
			
			undergroundConnection = RunService.Heartbeat:Connect(function()
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and undergroundFixedY then
					local currentHRP = lp.Character.HumanoidRootPart
					undergroundPlatform.CFrame = CFrame.new(currentHRP.Position.X, undergroundFixedY - 3.5, currentHRP.Position.Z)
				end
			end)
		end
	else
		undergroundFixedY = nil
		if undergroundConnection then undergroundConnection:Disconnect() undergroundConnection = nil end
		if undergroundPlatform then undergroundPlatform:Destroy() undergroundPlatform = nil end
	end
end

-- [NEW] Helper Function: Safe Slide Movement
local function slideToPosition(targetPos)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
	local speed = 600 -- Studs per second
	local time = dist / speed
	
	-- LOCK Y to Underground
	local targetY = undergroundFixedY or targetPos.Y
	
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
	local targetCFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
	
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
	
	hrp.AssemblyLinearVelocity = Vector3.zero
end

local function isTargetItem(tool, keyword)
	if not tool:IsA("Tool") then return false end
	if tool.ToolTip and string.find(tool.ToolTip, keyword) then return true end
	if string.find(tool.Name, keyword) then return true end
	if tool:GetAttribute("DisplayName") and string.find(tool:GetAttribute("DisplayName"), keyword) then return true end
	return false
end

local function removeMarker(obj)
	local data = ESP.markers[obj]
	if data then
		pcall(function() 
			data.hl:Destroy() 
			data.bb:Destroy() 
			data.ac:Disconnect()
			if data.tc then data.tc:Disconnect() end
		end)
		ESP.markers[obj] = nil
	end
end

local function addMarker(obj, label)
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end
	local root = obj:FindFirstChild("Root") or obj:FindFirstChildWhichIsA("BasePart", true)
	if not root or ESP.markers[obj] then return end
	
	local highlightColor = Color3.fromRGB(255, 255, 255)
	local nameColorHex = ""
	
	if label == "Divine" then
		highlightColor = Color3.fromRGB(255, 215, 0)
		nameColorHex = "rgb(255,215,0)"
	elseif label == "Celestial" then
		highlightColor = Color3.fromRGB(255, 105, 180)
		nameColorHex = "rgb(255,105,180)"
	else
		highlightColor = Color3.fromRGB(0, 255, 0)
		nameColorHex = "rgb(0,255,0)"
	end

	local realName = "Unknown"
	for _, child in pairs(obj:GetChildren()) do
		if child:IsA("Model") and child.Name ~= "RenderedBrainrot" then
			realName = child.Name
			break
		end
	end

	local hl = Instance.new("Highlight", obj)
	hl.FillColor = highlightColor
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)

	local bb = Instance.new("BillboardGui", obj)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 4, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.RichText = true
	txt.TextSize = 13
	
	local timerLabel = nil
	pcall(function() timerLabel = obj.Root.TimerGui.TimeLeft.TimeLeft end)

	local function updateEspText()
		local timeLeftStr = timerLabel and timerLabel.Text or "0s"
		txt.Text = string.format('<font color="%s">%s</font> <font color="rgb(255,0,0)">(%s)</font>', nameColorHex, realName, timeLeftStr)
	end
	
	updateEspText()

	local timerConnection = nil
	if timerLabel then
		timerConnection = timerLabel:GetPropertyChangedSignal("Text"):Connect(updateEspText)
	end

	ESP.markers[obj] = { 
		hl = hl, 
		bb = bb, 
		ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end),
		tc = timerConnection
	}
end

local function toggleEspLogic(mode, folderName)
	ESP.enabled[mode] = not ESP.enabled[mode]
	local isOn = ESP.enabled[mode]
	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(folderName)
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end)
	else
		for obj, _ in pairs(ESP.markers) do if obj:IsDescendantOf(folder) then removeMarker(obj) end end
	end
end

local TargetLabel 

local function StopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	followTarget = nil
	if TargetLabel then TargetLabel.Text = "Target: None" end
end

local function StartFollowing(targetPlayer)
	StopFollowing()
	if not targetPlayer then return end
	
	followTarget = targetPlayer
	if TargetLabel then TargetLabel.Text = "Following: " .. targetPlayer.Name end
	
	followConnection = RunService.RenderStepped:Connect(function()
		if actionLock then return end

		if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			local tRoot = followTarget.Character.HumanoidRootPart
			local myRoot = lp.Character.HumanoidRootPart
			
			for _, part in pairs(lp.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
			
			myRoot.CFrame = tRoot.CFrame * CFrame.new(4, 0, 0)
			myRoot.AssemblyLinearVelocity = Vector3.zero
			myRoot.AssemblyAngularVelocity = Vector3.zero
		else
			if not followTarget or not followTarget.Parent then
				StopFollowing()
			end
		end
	end)
end

task.spawn(function()
	while true do
		task.wait(0.2) 
		if autoEquipEnabled and lp.Character and lp.Backpack then
			local humanoid = lp.Character:FindFirstChild("Humanoid")
			if humanoid then
				local currentTool = lp.Character:FindFirstChildOfClass("Tool")
				local holdingDivine = currentTool and isTargetItem(currentTool, "Divine Block")
				local holdingCelestial = currentTool and isTargetItem(currentTool, "Celestial Block")
				
				if not holdingDivine then
					local divineInBag = nil
					for _, item in pairs(lp.Backpack:GetChildren()) do
						if isTargetItem(item, "Divine Block") then divineInBag = item break end
					end
					
					if divineInBag then
						humanoid:EquipTool(divineInBag)
					else
						if not holdingCelestial then
							local celestialInBag = nil
							for _, item in pairs(lp.Backpack:GetChildren()) do
								if isTargetItem(item, "Celestial Block") then celestialInBag = item break end
							end
							if celestialInBag then humanoid:EquipTool(celestialInBag) end
						end
					end
				end
			end
		end
	end
end)

--=============================================================================
--// UI BUILD (SECTIONS & BUTTONS)
--=============================================================================

CreateSection("PLAYER")

CreateToggle("Platform Walk (w/ Shortcut)", function(toggled)
	if toggled then
		togglePlatformState(true)
		
		if not platformShortcutBtn then
			platformShortcutBtn = Instance.new("TextButton")
			platformShortcutBtn.Name = "PlatformShortcut"
			platformShortcutBtn.Size = UDim2.new(0, 50, 0, 50)
			platformShortcutBtn.Position = UDim2.new(0.8, 0, 0.7, 0)
			platformShortcutBtn.BackgroundColor3 = colors.shortcutOn
			platformShortcutBtn.Text = "P-Walk"
			platformShortcutBtn.TextColor3 = Color3.fromRGB(0,0,0)
			platformShortcutBtn.Font = Enum.Font.GothamBold
			platformShortcutBtn.TextSize = 10
			platformShortcutBtn.Parent = ScreenGui
			
			Instance.new("UICorner", platformShortcutBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", platformShortcutBtn).Thickness = 2
			
			makeDraggable(platformShortcutBtn)
			
			local shortcutActive = true
			platformShortcutBtn.MouseButton1Click:Connect(function()
				shortcutActive = not shortcutActive
				togglePlatformState(shortcutActive)
				
				if shortcutActive then
					platformShortcutBtn.BackgroundColor3 = colors.shortcutOn
					platformShortcutBtn.Transparency = 0
				else
					platformShortcutBtn.BackgroundColor3 = colors.shortcutOff
					platformShortcutBtn.Transparency = 0.5
				end
			end)
		end
	else
		togglePlatformState(false)
		if platformShortcutBtn then
			platformShortcutBtn:Destroy()
			platformShortcutBtn = nil
		end
	end
end)

CreateToggle("Noclip", function(toggled)
	noclipOn = toggled
	if noclipOn then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	end
end)

CreateSection("AUTO ITEMS")

CreateToggle("Auto Equip Best Block", function(toggled)
	autoEquipEnabled = toggled
end)

--=============================================================================
--// LUCKY BLOCK SECTION (DROPDOWN + SLIDE MODE IMPROVED)
--=============================================================================

local function CreateLuckyBlockDropdown()
	local DropdownBtn = Instance.new("TextButton")
	DropdownBtn.Name = "DropdownBtn"
	DropdownBtn.Size = UDim2.new(1, 0, 0, 36)
	DropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
	DropdownBtn.TextColor3 = colors.accent
	DropdownBtn.Font = Enum.Font.GothamBold
	DropdownBtn.TextSize = 13
	DropdownBtn.Parent = Container
	Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Name = "DropdownFrame"
	DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
	DropdownFrame.BackgroundTransparency = 1
	DropdownFrame.ClipsDescendants = true 
	DropdownFrame.Visible = false
	DropdownFrame.Parent = Container

	local DropList = Instance.new("UIListLayout")
	DropList.Parent = DropdownFrame
	DropList.Padding = UDim.new(0, 4)
	DropList.SortOrder = Enum.SortOrder.LayoutOrder

	local expanded = false
	DropdownBtn.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▲"
			DropdownFrame.Visible = true
			DropdownFrame.Size = UDim2.new(1, 0, 0, 185)
		else
			DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
			DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
			task.delay(0.2, function()
				if not expanded then DropdownFrame.Visible = false end
			end)
		end
	end)

	local function updateMasterSlide()
		local anyEnabled = false
		for _, v in pairs(slideSettings) do
			if v then anyEnabled = true break end
		end
		-- Check other features that use slide
		if anyEnabled or autoClaimTicketEnabled or autoCoinValentineEnabled then
			toggleUndergroundPlatform(true)
		else
			toggleUndergroundPlatform(false)
		end
	end

	CreateToggle("Auto Divine (Slide)", function(t) slideSettings.Divine = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Infinity (Slide)", function(t) slideSettings.Infinity = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Celestial (Slide)", function(t) slideSettings.Celestial = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Secret (Slide)", function(t) slideSettings.Secret = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Mythical (Slide)", function(t) slideSettings.Mythical = t; updateMasterSlide() end, DropdownFrame)
end

CreateLuckyBlockDropdown()

task.spawn(function()
	while true do
		task.wait(0.5) 

		if actionLock then continue end

		local activeTypes = {}
		if slideSettings.Divine then table.insert(activeTypes, "Divine") end
		if slideSettings.Infinity then table.insert(activeTypes, "Infinity") end
		if slideSettings.Celestial then table.insert(activeTypes, "Celestial") end
		if slideSettings.Secret then table.insert(activeTypes, "Secret") end
		if slideSettings.Mythical then table.insert(activeTypes, "Mythical") end

		if #activeTypes > 0 and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			local folder = workspace:FindFirstChild("ActiveLuckyBlocks")
			
			if folder then
				local collectedCount = 0
				local maxCollect = 3
				
				local function getClosestBlock()
					local closest = nil
					local minDist = 999999
					local myPos = lp.Character.HumanoidRootPart.Position
					
					for _, model in pairs(folder:GetChildren()) do
						local isValidType = false
						for _, typeName in pairs(activeTypes) do
							if string.find(model.Name, typeName) then isValidType = true break end
						end
						
						if isValidType and model:FindFirstChild("RootPart") then
							local root = model.RootPart
							local dist = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
							if dist < minDist then
								minDist = dist
								closest = model
							end
						end
					end
					return closest
				end
				
				while collectedCount < maxCollect do
					local targetModel = getClosestBlock()
					
					if targetModel then
						actionLock = true 
						local root = targetModel.RootPart
						
						local targetPos = Vector3.new(root.Position.X, root.Position.Y - 10, root.Position.Z)
						slideToPosition(targetPos) 
						
						local prompt = root:FindFirstChild("ProximityPrompt")
						if prompt then
							for i = 1, 10 do
								if not root.Parent or not prompt.Parent then break end
								fireproximityprompt(prompt)
								task.wait(0.05)
							end
						end
						
						collectedCount = collectedCount + 1
						task.wait(0.2)
					else
						break 
					end
				end
				
				if collectedCount > 0 then
					local base = workspace:FindFirstChild("SpawnLocation1")
					if base then
						local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
						slideToPosition(basePos)
					end
					actionLock = false 
					task.wait(1) 
				else
					actionLock = false
				end
			end
		end
	end
end)

CreateSection("OPTIMIZATION")

CreateToggle("Auto Reduce Lag+ (10m Loop)", function(toggled)
	autoReduceLagEnabled = toggled
	
	if autoReduceLagEnabled then
		task.spawn(function()
			while autoReduceLagEnabled do
				
				-- 1. Hapus Target Spesifik di Workspace
				local targetNames = {
					"ActiveBrainrots", "ActiveTsunamis", "BaseLocations", 
					"Bases", "Leaderboards", "GeyserVisualVFX", 
					"Misc", "SpawnMachines"
				}
				
				for _, name in pairs(targetNames) do
					local obj = workspace:FindFirstChild(name)
					if obj then
						pcall(function() obj:Destroy() end)
					end
				end
				
				-- 3. Hapus Semua Isi di Lighting
				for _, v in pairs(Lighting:GetChildren()) do
					pcall(function() v:Destroy() end)
				end
				
				-- Optimasi Properti Lighting Bawaan
				Lighting.GlobalShadows = false
				Lighting.FogEnd = 100000
				Lighting.Brightness = 2
				
				-- Kirim Notifikasi Sukses
				StarterGui:SetCore("SendNotification", {
					Title = "LAG REDUCED +",
					Text = "Workspace & Lighting dibersihkan (Loop 10 Menit berjalan).",
					Duration = 3
				})
				
				-- 4. Timer 10 Menit (600 Detik) dengan Pengecekan Keaktifan
				local timer = 0
				while autoReduceLagEnabled and timer < 600 do
					task.wait(1)
					timer = timer + 1
				end
			end
		end)
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Reduce Lag+",
			Text = "Auto Reduce Lag dihentikan.",
			Duration = 3
		})
	end
end)

CreateSection("PLAYER FOLLOWER")

TargetLabel = Instance.new("TextLabel")
TargetLabel.Text = "Target: None"
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextColor3 = colors.accent
TargetLabel.Font = Enum.Font.GothamSemibold
TargetLabel.TextSize = 13
TargetLabel.Parent = Container

CreateButton("Stop Following", function()
	StopFollowing()
end)

CreateButton("Refresh Player List", function()
	for _, gui in pairs(Container:GetChildren()) do
		if gui.Name == "PlayerButtonFrame" then gui:Destroy() end
	end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= lp then
			local BtnFrame = Instance.new("Frame")
			BtnFrame.Name = "PlayerButtonFrame"
			BtnFrame.Size = UDim2.new(1, 0, 0, 36)
			BtnFrame.BackgroundTransparency = 1
			BtnFrame.Parent = Container
			
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 1, 0)
			Btn.Position = UDim2.new(0, 5, 0, 0)
			Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Btn.Text = "Follow: " .. player.DisplayName
			Btn.TextColor3 = colors.subText
			Btn.Font = Enum.Font.GothamMedium
			Btn.TextSize = 12
			Btn.Parent = BtnFrame
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
			
			Btn.MouseButton1Click:Connect(function() StartFollowing(player) end)
		end
	end
end)

CreateSection("VISUALS (ESP)")

CreateToggle("ESP Divine", function() toggleEspLogic("Divine", "Divine") end)

CreateSection("ARCADE EVENT")

CreateToggle("Auto Game Console", function(toggled)
	autoConsoleEnabled = toggled
	if autoConsoleEnabled then
		task.spawn(function()
			while autoConsoleEnabled do
				task.wait(0.2)
				local folder = workspace:FindFirstChild("ArcadeEventConsoles")
				if folder and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					for _, model in pairs(folder:GetChildren()) do
						if model.Name == "Game Console" then
							local part = model:FindFirstChild("Game Console")
							if part and part:FindFirstChild("TouchInterest") then
								if firetouchinterest then
									firetouchinterest(hrp, part, 0)
									firetouchinterest(hrp, part, 1)
								else
									part.CFrame = hrp.CFrame
								end
							end
						end
					end
				end
			end
		end)
	end
end)

-- [NEW] FITUR AUTO TICKET YANG SUDAH DIPERBAIKI
CreateToggle("Auto Claim Ticket (Underground)", function(toggled)
	autoClaimTicketEnabled = toggled
	if toggled then 
		toggleUndergroundPlatform(true) 
	else
		local anyLuckyBlockOn = false
		for _, v in pairs(slideSettings) do if v then anyLuckyBlockOn = true break end end
		if not anyLuckyBlockOn and not autoCoinValentineEnabled then
			toggleUndergroundPlatform(false)
		end
	end
	
	if autoClaimTicketEnabled then
		task.spawn(function()
			while autoClaimTicketEnabled do
				task.wait(0.2) 
				
				if actionLock then continue end
				
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local collectedCount = 0
					local maxCollect = 10
					local hasCollectedAny = false
					
					local function getClosestTicket()
						local closest = nil
						local minDist = 999999
						local myPos = lp.Character.HumanoidRootPart.Position
						
						-- Cek di 2 folder berbeda
						local folders = {
							workspace:FindFirstChild("ArcadeEventTickets"),
							workspace:FindFirstChild("TicketBombTickets")
						}
						
						for _, folder in pairs(folders) do
							if folder then
								for _, model in pairs(folder:GetChildren()) do
									if model.Name == "Ticket" and model:FindFirstChild("Ticket") then
										local part = model.Ticket
										local dist = (Vector3.new(part.Position.X, 0, part.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
										if dist < minDist then
											minDist = dist
											closest = model
										end
									end
								end
							end
						end
						return closest
					end
					
					while collectedCount < maxCollect do
						local targetTicket = getClosestTicket()
						
						if targetTicket then
							actionLock = true 
							hasCollectedAny = true
							
							local part = targetTicket.Ticket
							local targetPos = Vector3.new(part.Position.X, part.Position.Y - 10, part.Position.Z)
							
							-- Slide ke target ticket
							slideToPosition(targetPos)
							
							local hrp = lp.Character.HumanoidRootPart
							if part:FindFirstChild("TouchInterest") then
								if firetouchinterest then
									firetouchinterest(hrp, part, 0)
									firetouchinterest(hrp, part, 1)
								else
									part.CFrame = hrp.CFrame
								end
							end
							
							collectedCount = collectedCount + 1
							
							-- Stop dulu (delay) setelah mengambil ticket, tidak langsung ke base
							task.wait(0.3) 
							
							-- Hilangkan ticket secara lokal agar loop selanjutnya tidak mengincar ticket yang sama
							pcall(function() targetTicket:Destroy() end)
						else
							break -- Kalau tidak ada ticket lagi, keluar dari loop
						end
					end
					
					-- Jika player tadi berhasil ngambil setidaknya 1 ticket, baru balik ke base
					if hasCollectedAny then
						local base = workspace:FindFirstChild("SpawnLocation1")
						if base then
							local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
							slideToPosition(basePos)
						end
						actionLock = false 
						task.wait(1) 
					else
						actionLock = false
					end
				end
			end
		end)
	end
end)

--=============================================================================
--// VALENTINE EVENT
--=============================================================================

CreateSection("VALENTINE EVENT")

-- [NEW LOGIC] Auto Coin Valentine (Underground + Magnet)
-- LOGIC: HANYA JALAN JIKA ADA FOLDER 'ValentinesCoinParts' DAN 'ValentinesCoin'
CreateToggle("Auto Coin Valentine (Underground)", function(toggled)
	autoCoinValentineEnabled = toggled
	
	-- Manage Platform State
	if toggled then 
		toggleUndergroundPlatform(true) 
	else
		-- Check other features to prevent platform loss
		local anyLuckyBlockOn = false
		for _, v in pairs(slideSettings) do if v then anyLuckyBlockOn = true break end end
		if not anyLuckyBlockOn and not autoClaimTicketEnabled then
			toggleUndergroundPlatform(false)
		end
	end

	-- 1. MAGNET LOOP (Parallel)
	-- collects coins within 280 studs while moving (ONLY IF COINS EXIST)
	task.spawn(function()
		while autoCoinValentineEnabled do
			task.wait(0.1) -- Fast loop
			local coinFolder = workspace:FindFirstChild("ValentinesCoinParts")
			
			if coinFolder and #coinFolder:GetChildren() > 0 then
				local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					for _, item in pairs(coinFolder:GetChildren()) do
						-- Specific name check based on prompt: ValentinesCoin
						if item.Name == "ValentinesCoin" then 
							local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
							if part then
								local dist = (part.Position - hrp.Position).Magnitude
								if dist <= 280 then
									if firetouchinterest then
										firetouchinterest(hrp, part, 0)
										firetouchinterest(hrp, part, 1)
									else
										part.CFrame = hrp.CFrame
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	-- 2. MOVEMENT LOOP (Event Detection Logic)
	task.spawn(function()
		while autoCoinValentineEnabled do
			task.wait(0.2)
			
			-- Wait for ActionLock (Combo with Lucky Block)
			if actionLock then continue end

			-- DETECT EVENT STATUS
			local coinFolder = workspace:FindFirstChild("ValentinesCoinParts")
			local isEventActive = false
			
			-- Cek apakah folder ada dan didalamnya ada "ValentinesCoin"
			if coinFolder and coinFolder:FindFirstChild("ValentinesCoin") then
				isEventActive = true
			end

			if isEventActive then
				-- >>> EVENT ACTIVE: RUN SLIDE LOGIC <<<
				
				-- Dynamic Search for Celestial Part
				local targetPart = nil
				for _, folder in pairs(workspace:GetChildren()) do
					if string.find(folder.Name, "_SharedInstances") then 
						local floors = folder:FindFirstChild("Floors")
						if floors then
							targetPart = floors:FindFirstChild("Celestial")
							if targetPart then break end
						end
					end
				end

				local base = workspace:FindFirstChild("SpawnLocation1")

				if targetPart and base and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					
					actionLock = true -- LOCK

					-- Slide to Celestial
					local targetPos = Vector3.new(targetPart.Position.X, targetPart.Position.Y - 10, targetPart.Position.Z)
					slideToPosition(targetPos)

					-- Wait 5 Seconds (Collecting happens in Magnet Loop)
					task.wait(5)

					-- Slide Back to Base
					local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
					slideToPosition(basePos)

					actionLock = false -- UNLOCK

					-- Wait 10 Seconds at Base
					task.wait(10)
					
				else
					-- Struktur map tidak ketemu, tunggu sebentar
					task.wait(2)
				end
			else
				-- >>> EVENT INACTIVE: STOP SLIDING & WAIT <<<
				-- Coin tidak ada, diam saja menunggu event mulai
				task.wait(1)
			end
		end
	end)
end)

CreateSection("MISC")

CreateButton("Delete Safe Walls", function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if walls then for _, v in pairs(walls:GetChildren()) do v:Destroy() end end
end)

--=============================================================================
--// SERVER FEATURES
--=============================================================================

CreateSection("SERVER")

CreateToggle("Anti AFK (20m Bypass)", function(toggled)
	if toggled then
		antiAfkConnection = lp.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		
		StarterGui:SetCore("SendNotification", {
			Title = "Anti AFK ON",
			Text = "You won't get kicked for idling.",
			Duration = 3
		})
	else
		if antiAfkConnection then
			antiAfkConnection:Disconnect()
			antiAfkConnection = nil
		end
		
		StarterGui:SetCore("SendNotification", {
			Title = "Anti AFK OFF",
			Text = "Idle kick is back to normal.",
			Duration = 3
		})
	end
end)

CreateToggle("Fast Interact (Global)", function(toggled)
	fastInteractEnabled = toggled
	
	local function makeInstant(prompt)
		prompt.HoldDuration = 0
		if not activeInteractConnections[prompt] then
			activeInteractConnections[prompt] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
				if fastInteractEnabled and prompt.HoldDuration > 0 then
					prompt.HoldDuration = 0 
				end
			end)
		end
	end

	if fastInteractEnabled then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				makeInstant(v)
			end
		end
		ftConnection = ProximityPromptService.PromptAdded:Connect(makeInstant)
	else
		if ftConnection then ftConnection:Disconnect() ftConnection = nil end
		for _, conn in pairs(activeInteractConnections) do
			conn:Disconnect()
		end
		activeInteractConnections = {}
	end
end)

CreateToggle("Unlimited Zoom + Camera Clip", function(toggled)
	if toggled then
		lp.CameraMaxZoomDistance = 100000 
		lp.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam 
	else
		lp.CameraMaxZoomDistance = 128 
		lp.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
	end
end)

print("✅ Dj Hub Remastered (Loop Fix) Loaded")		local pg = lp:FindFirstChildOfClass("PlayerGui")
		if pg then return pg end
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end
	return nil
end

local parent = pickGuiParent()
if not parent then return end

pcall(function()
	if parent:FindFirstChild("DjHubRemastered") then
		parent.DjHubRemastered:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjHubRemastered"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- [FIX GUI] Auto Scale Logic
local uiScale = Instance.new("UIScale")
uiScale.Parent = ScreenGui

local function updateScale()
	local camera = workspace.CurrentCamera
	if camera then
		if camera.ViewportSize.Y < 500 then
			uiScale.Scale = 0.65
		elseif camera.ViewportSize.Y < 720 then
			uiScale.Scale = 0.8
		else
			uiScale.Scale = 1.0
		end
	end
end

updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(0.05), {Position = newPos}):Play()
	end
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	handle.InputChanged:Connect(function(input)
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
MainFrame.Size = UDim2.new(0, 340, 0, 320)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BackgroundTransparency = 0.35 
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local mainScale = Instance.new("UIScale", MainFrame)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0, 4, 1, 0)
AccentLine.BackgroundColor3 = colors.accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame
Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 40)
Header.Position = UDim2.new(0, 20, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Dj Hub <font color=\"rgb(255,120,30)\">Premium</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = colors.text
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = colors.text
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamMedium
MinBtn.TextSize = 24
MinBtn.TextColor3 = colors.text
MinBtn.BackgroundTransparency = 1
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Parent = Header

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 1, -50)
Container.Position = UDim2.new(0, 14, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = colors.accent
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

makeDraggable(MainFrame, Header)

local function CreateToggle(text, callback, parentOverride)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = parentOverride or Container
	
	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 13
	Label.TextColor3 = colors.text
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.BackgroundTransparency = 1
	Label.Parent = ToggleFrame
	
	local SwitchBg = Instance.new("Frame")
	SwitchBg.Size = UDim2.new(0, 44, 0, 22)
	SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
	SwitchBg.BackgroundColor3 = colors.toggleOff
	SwitchBg.Parent = ToggleFrame
	Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
	
	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = SwitchBg
	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
	
	local Trigger = Instance.new("TextButton")
	Trigger.Size = UDim2.new(1, 0, 1, 0)
	Trigger.BackgroundTransparency = 1
	Trigger.Text = ""
	Trigger.Parent = ToggleFrame
	
	local toggled = false
	
	Trigger.MouseButton1Click:Connect(function()
		toggled = not toggled
		local targetColor = toggled and colors.toggleOn or colors.toggleOff
		local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
		pcall(callback, toggled)
	end)
end

local function CreateButton(text, callback)
	local BtnFrame = Instance.new("Frame")
	BtnFrame.Size = UDim2.new(1, 0, 0, 36)
	BtnFrame.BackgroundTransparency = 1
	BtnFrame.Parent = Container
	
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 1, 0)
	Btn.Position = UDim2.new(0, 5, 0, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Btn.Text = text
	Btn.TextColor3 = colors.text
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 13
	Btn.Parent = BtnFrame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	
	Btn.MouseButton1Click:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
		task.delay(0.1, function()
			TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
		end)
		pcall(callback)
	end)
end

local function CreateSection(text)
	local Sec = Instance.new("TextLabel")
	Sec.Text = text
	Sec.Size = UDim2.new(1, 0, 0, 25)
	Sec.BackgroundTransparency = 1
	Sec.TextColor3 = colors.subText
	Sec.Font = Enum.Font.GothamBold
	Sec.TextSize = 12
	Sec.TextXAlignment = Enum.TextXAlignment.Left
	Sec.Position = UDim2.new(0, 10, 0, 0)
	Instance.new("UIPadding", Sec).PaddingLeft = UDim.new(0,10)
	Sec.Parent = Container
end

local minimized = false
local MinIcon = Instance.new("TextButton")
MinIcon.Name = "MiniIcon"
MinIcon.Size = UDim2.new(0, 50, 0, 50)
MinIcon.BackgroundColor3 = colors.background
MinIcon.BackgroundTransparency = 0.1
MinIcon.Text = "DJ"
MinIcon.TextColor3 = colors.accent
MinIcon.Font = Enum.Font.GothamBlack
MinIcon.TextSize = 18
MinIcon.Visible = false
MinIcon.Parent = ScreenGui
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MinIcon).Color = colors.accent
Instance.new("UIStroke", MinIcon).Thickness = 2
Instance.new("UIStroke", MinIcon).ApplyStrokeMode = Enum.ApplyStrokeMode.Border

makeDraggable(MinIcon)

MinBtn.MouseButton1Click:Connect(function()
	minimized = true
	MainFrame.Visible = false
	MinIcon.Visible = true
	MinIcon.Position = MainFrame.Position
end)

MinIcon.MouseButton1Click:Connect(function()
	minimized = false
	MinIcon.Visible = false
	MainFrame.Visible = true
	MainFrame.Position = MinIcon.Position
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--=============================================================================
--// FEATURE VARIABLES
--=============================================================================

local platformEnabled = false
local pPart, pConn, lastY = nil, nil, 0
local platformShortcutBtn = nil 

local noclipOn = false
local noclipConn = nil
local ESP = { enabled = {}, connections = {}, markers = {} }
local fastInteractEnabled = false 
local ftConnection = nil
local activeInteractConnections = {} 
local autoConsoleEnabled = false

local actionLock = false

local autoClaimTicketEnabled = false 
local autoCoinValentineEnabled = false 
local autoSellEnabled = false 
local autoObbyMoneyEnabled = false -- [NEW] Auto Obby Money Variable

local slideSettings = {
	Divine = false,
	Infinity = false,
	Celestial = false,
	Secret = false,
	Mythical = false
}

local autoOpenSettings = {
	Money = false,
	Candy = false,
	Celestial = false
}

local undergroundPlatform = nil
local undergroundConnection = nil
local undergroundFixedY = nil 

local followTarget = nil
local followConnection = nil
local autoEquipEnabled = false
local antiAfkConnection = nil
local autoReduceLagEnabled = false

--=============================================================================
--// LOGIC FUNCTIONS
--=============================================================================

local function togglePlatformState(state)
	if state then
		if not pPart then
			pPart = Instance.new("Part", workspace)
			pPart.Name = "DjPlatform"
			pPart.Size = Vector3.new(15, 0.5, 15)
			pPart.Anchored = true
			pPart.Transparency = 0.5
			pPart.Material = Enum.Material.ForceField
			pPart.Color = Color3.fromRGB(0, 255, 255)
			
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2
			end
			
			pConn = RunService.PostSimulation:Connect(function()
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					local hum = lp.Character:FindFirstChild("Humanoid")
					if hum and hum.FloorMaterial == Enum.Material.Air then lastY = hrp.Position.Y - 3.2 end
					pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
				end
			end)
		end
	else
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end
	end
end

local function toggleUndergroundPlatform(state)
	if state then
		if not undergroundPlatform then 
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				if not undergroundFixedY then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, -10, 0)
					undergroundFixedY = hrp.Position.Y 
				end
			end
			
			undergroundPlatform = Instance.new("Part", workspace)
			undergroundPlatform.Name = "DjUndergroundPlatform"
			undergroundPlatform.Size = Vector3.new(15, 1, 15)
			undergroundPlatform.Anchored = true
			undergroundPlatform.Transparency = 0.5
			undergroundPlatform.Material = Enum.Material.Neon
			undergroundPlatform.Color = Color3.fromRGB(150, 0, 0) 
			
			undergroundConnection = RunService.Heartbeat:Connect(function()
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and undergroundFixedY then
					local currentHRP = lp.Character.HumanoidRootPart
					undergroundPlatform.CFrame = CFrame.new(currentHRP.Position.X, undergroundFixedY - 3.5, currentHRP.Position.Z)
				end
			end)
		end
	else
		undergroundFixedY = nil
		if undergroundConnection then undergroundConnection:Disconnect() undergroundConnection = nil end
		if undergroundPlatform then undergroundPlatform:Destroy() undergroundPlatform = nil end
	end
end

local function slideToPosition(targetPos)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
	local speed = 600
	local time = dist / speed
	
	local targetY = undergroundFixedY or targetPos.Y
	
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
	local targetCFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
	
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
	
	hrp.AssemblyLinearVelocity = Vector3.zero
end

local function isTargetItem(tool, keyword)
	if not tool:IsA("Tool") then return false end
	if tool.ToolTip and string.find(tool.ToolTip, keyword) then return true end
	if string.find(tool.Name, keyword) then return true end
	if tool:GetAttribute("DisplayName") and string.find(tool:GetAttribute("DisplayName"), keyword) then return true end
	return false
end

local function removeMarker(obj)
	local data = ESP.markers[obj]
	if data then
		pcall(function() 
			data.hl:Destroy() 
			data.bb:Destroy() 
			data.ac:Disconnect()
			if data.tc then data.tc:Disconnect() end
		end)
		ESP.markers[obj] = nil
	end
end

local function addMarker(obj, label)
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end
	local root = obj:FindFirstChild("Root") or obj:FindFirstChildWhichIsA("BasePart", true)
	if not root or ESP.markers[obj] then return end
	
	local highlightColor = Color3.fromRGB(255, 255, 255)
	local nameColorHex = ""
	
	if label == "Divine" then
		highlightColor = Color3.fromRGB(255, 215, 0)
		nameColorHex = "rgb(255,215,0)"
	elseif label == "Celestial" then
		highlightColor = Color3.fromRGB(255, 105, 180)
		nameColorHex = "rgb(255,105,180)"
	else
		highlightColor = Color3.fromRGB(0, 255, 0)
		nameColorHex = "rgb(0,255,0)"
	end

	local realName = "Unknown"
	for _, child in pairs(obj:GetChildren()) do
		if child:IsA("Model") and child.Name ~= "RenderedBrainrot" then
			realName = child.Name
			break
		end
	end

	local hl = Instance.new("Highlight", obj)
	hl.FillColor = highlightColor
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)

	local bb = Instance.new("BillboardGui", obj)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 4, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.RichText = true
	txt.TextSize = 13
	
	local timerLabel = nil
	pcall(function() timerLabel = obj.Root.TimerGui.TimeLeft.TimeLeft end)

	local function updateEspText()
		local timeLeftStr = timerLabel and timerLabel.Text or "0s"
		txt.Text = string.format('<font color="%s">%s</font> <font color="rgb(255,0,0)">(%s)</font>', nameColorHex, realName, timeLeftStr)
	end
	
	updateEspText()

	local timerConnection = nil
	if timerLabel then
		timerConnection = timerLabel:GetPropertyChangedSignal("Text"):Connect(updateEspText)
	end

	ESP.markers[obj] = { 
		hl = hl, 
		bb = bb, 
		ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end),
		tc = timerConnection
	}
end

local function toggleEspLogic(mode, folderName)
	ESP.enabled[mode] = not ESP.enabled[mode]
	local isOn = ESP.enabled[mode]
	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	
	local folder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild(folderName)
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addMarker(c, mode) end)
	else
		for obj, _ in pairs(ESP.markers) do if obj:IsDescendantOf(folder) then removeMarker(obj) end end
	end
end

local TargetLabel 

local function StopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	followTarget = nil
	if TargetLabel then TargetLabel.Text = "Target: None" end
end

local function StartFollowing(targetPlayer)
	StopFollowing()
	if not targetPlayer then return end
	
	followTarget = targetPlayer
	if TargetLabel then TargetLabel.Text = "Following: " .. targetPlayer.Name end
	
	followConnection = RunService.RenderStepped:Connect(function()
		if actionLock then return end

		if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			local tRoot = followTarget.Character.HumanoidRootPart
			local myRoot = lp.Character.HumanoidRootPart
			
			for _, part in pairs(lp.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
			
			myRoot.CFrame = tRoot.CFrame * CFrame.new(4, 0, 0)
			myRoot.AssemblyLinearVelocity = Vector3.zero
			myRoot.AssemblyAngularVelocity = Vector3.zero
		else
			if not followTarget or not followTarget.Parent then
				StopFollowing()
			end
		end
	end)
end

task.spawn(function()
	while true do
		task.wait(0.2) 
		if autoEquipEnabled and lp.Character and lp.Backpack then
			local humanoid = lp.Character:FindFirstChild("Humanoid")
			if humanoid then
				local currentTool = lp.Character:FindFirstChildOfClass("Tool")
				local holdingDivine = currentTool and isTargetItem(currentTool, "Divine Block")
				local holdingCelestial = currentTool and isTargetItem(currentTool, "Celestial Block")
				
				if not holdingDivine then
					local divineInBag = nil
					for _, item in pairs(lp.Backpack:GetChildren()) do
						if isTargetItem(item, "Divine Block") then divineInBag = item break end
					end
					
					if divineInBag then
						humanoid:EquipTool(divineInBag)
					else
						if not holdingCelestial then
							local celestialInBag = nil
							for _, item in pairs(lp.Backpack:GetChildren()) do
								if isTargetItem(item, "Celestial Block") then celestialInBag = item break end
							end
							if celestialInBag then humanoid:EquipTool(celestialInBag) end
						end
					end
				end
			end
		end
	end
end)

--=============================================================================
--// UI BUILD (SECTIONS & BUTTONS)
--=============================================================================

CreateSection("PLAYER")

CreateToggle("Platform Walk (w/ Shortcut)", function(toggled)
	if toggled then
		togglePlatformState(true)
		
		if not platformShortcutBtn then
			platformShortcutBtn = Instance.new("TextButton")
			platformShortcutBtn.Name = "PlatformShortcut"
			platformShortcutBtn.Size = UDim2.new(0, 50, 0, 50)
			platformShortcutBtn.Position = UDim2.new(0.8, 0, 0.7, 0)
			platformShortcutBtn.BackgroundColor3 = colors.shortcutOn
			platformShortcutBtn.Text = "P-Walk"
			platformShortcutBtn.TextColor3 = Color3.fromRGB(0,0,0)
			platformShortcutBtn.Font = Enum.Font.GothamBold
			platformShortcutBtn.TextSize = 10
			platformShortcutBtn.Parent = ScreenGui
			
			Instance.new("UICorner", platformShortcutBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", platformShortcutBtn).Thickness = 2
			
			makeDraggable(platformShortcutBtn)
			
			local shortcutActive = true
			platformShortcutBtn.MouseButton1Click:Connect(function()
				shortcutActive = not shortcutActive
				togglePlatformState(shortcutActive)
				
				if shortcutActive then
					platformShortcutBtn.BackgroundColor3 = colors.shortcutOn
					platformShortcutBtn.Transparency = 0
				else
					platformShortcutBtn.BackgroundColor3 = colors.shortcutOff
					platformShortcutBtn.Transparency = 0.5
				end
			end)
		end
	else
		togglePlatformState(false)
		if platformShortcutBtn then
			platformShortcutBtn:Destroy()
			platformShortcutBtn = nil
		end
	end
end)

CreateToggle("Noclip", function(toggled)
	noclipOn = toggled
	if noclipOn then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	end
end)

CreateSection("AUTO ITEMS")

CreateToggle("Auto Equip Best Block", function(toggled)
	autoEquipEnabled = toggled
end)

CreateToggle("Auto Sell Everything", function(toggled)
	autoSellEnabled = toggled
	if autoSellEnabled then
		task.spawn(function()
			while autoSellEnabled do
				task.wait(3) 
				local fired = false
				for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
					if obj:IsA("RemoteEvent") then
						local name = string.lower(obj.Name)
						if string.find(name, "sellall") or string.find(name, "selleverything") then
							pcall(function() obj:FireServer() end)
							fired = true
						end
					elseif obj:IsA("RemoteFunction") then
						local name = string.lower(obj.Name)
						if string.find(name, "sellall") or string.find(name, "selleverything") then
							task.spawn(function() pcall(function() obj:InvokeServer() end) end)
							fired = true
						end
					end
				end
				if not fired then
					for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
						if obj:IsA("RemoteEvent") and string.lower(obj.Name) == "sell" then
							pcall(function() obj:FireServer("All") end)
							pcall(function() obj:FireServer(true) end)
						end
					end
				end
			end
		end)
	end
end)

--=============================================================================
--// AUTO OPEN BLOCK SECTION (DROPDOWN) - [FIXED]
--=============================================================================

local function CreateAutoOpenBlockDropdown()
	local DropdownBtn = Instance.new("TextButton")
	DropdownBtn.Name = "DropdownBtnOpenBlock"
	DropdownBtn.Size = UDim2.new(1, 0, 0, 36)
	DropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	DropdownBtn.Text = "AUTO OPEN BLOCK ▼"
	DropdownBtn.TextColor3 = colors.accent
	DropdownBtn.Font = Enum.Font.GothamBold
	DropdownBtn.TextSize = 13
	DropdownBtn.Parent = Container
	Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Name = "DropdownFrameOpenBlock"
	DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
	DropdownFrame.BackgroundTransparency = 1
	DropdownFrame.ClipsDescendants = true 
	DropdownFrame.Visible = false
	DropdownFrame.Parent = Container

	local DropList = Instance.new("UIListLayout")
	DropList.Parent = DropdownFrame
	DropList.Padding = UDim.new(0, 4)
	DropList.SortOrder = Enum.SortOrder.LayoutOrder

	local expanded = false
	DropdownBtn.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			DropdownBtn.Text = "AUTO OPEN BLOCK ▲"
			DropdownFrame.Visible = true
			DropdownFrame.Size = UDim2.new(1, 0, 0, 115) 
		else
			DropdownBtn.Text = "AUTO OPEN BLOCK ▼"
			DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
			task.delay(0.2, function()
				if not expanded then DropdownFrame.Visible = false end
			end)
		end
	end)

	CreateToggle("Open Money Block", function(t) autoOpenSettings.Money = t end, DropdownFrame)
	CreateToggle("Open Candy Block", function(t) autoOpenSettings.Candy = t end, DropdownFrame)
	CreateToggle("Open Celestial Block", function(t) autoOpenSettings.Celestial = t end, DropdownFrame)
end

CreateAutoOpenBlockDropdown()

task.spawn(function()
	while true do
		task.wait(0.5) 
		
		local activeTypes = {}
		if autoOpenSettings.Money then table.insert(activeTypes, "Money Block") end
		if autoOpenSettings.Candy then table.insert(activeTypes, "Candy Block") end
		if autoOpenSettings.Celestial then table.insert(activeTypes, "Celestial Block") end

		if #activeTypes > 0 and lp.Character and lp.Character:FindFirstChild("Humanoid") then
			local humanoid = lp.Character.Humanoid
			local targetTool = nil
			
			local equippedTool = lp.Character:FindFirstChildOfClass("Tool")
			if equippedTool then
				for _, typeName in pairs(activeTypes) do
					if isTargetItem(equippedTool, typeName) then
						targetTool = equippedTool
						break
					end
				end
			end
			
			if not targetTool and lp.Backpack then
				for _, tool in pairs(lp.Backpack:GetChildren()) do
					if tool:IsA("Tool") then
						for _, typeName in pairs(activeTypes) do
							if isTargetItem(tool, typeName) then
								targetTool = tool
								break
							end
						end
					end
					if targetTool then break end 
				end
			end
			
			if targetTool and targetTool.Parent then 
				humanoid:EquipTool(targetTool)
				task.wait(0.3) 
				
				pcall(function() targetTool:Activate() end)
				
				pcall(function()
					VirtualInputManager:SendMouseButtonEvent(100, 100, 0, true, game, 0)
					task.wait(0.1)
					VirtualInputManager:SendMouseButtonEvent(100, 100, 0, false, game, 0)
				end)
				
				pcall(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton1(Vector2.new(100, 100))
				end)
				
				local waitTime = 0
				while targetTool.Parent and waitTime < 3 do
					task.wait(0.2)
					waitTime = waitTime + 0.2
				end
			end
		end
	end
end)

--=============================================================================
--// LUCKY BLOCK SECTION (DROPDOWN + SLIDE MODE IMPROVED)
--=============================================================================

local function CreateLuckyBlockDropdown()
	local DropdownBtn = Instance.new("TextButton")
	DropdownBtn.Name = "DropdownBtn"
	DropdownBtn.Size = UDim2.new(1, 0, 0, 36)
	DropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
	DropdownBtn.TextColor3 = colors.accent
	DropdownBtn.Font = Enum.Font.GothamBold
	DropdownBtn.TextSize = 13
	DropdownBtn.Parent = Container
	Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Name = "DropdownFrame"
	DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
	DropdownFrame.BackgroundTransparency = 1
	DropdownFrame.ClipsDescendants = true 
	DropdownFrame.Visible = false
	DropdownFrame.Parent = Container

	local DropList = Instance.new("UIListLayout")
	DropList.Parent = DropdownFrame
	DropList.Padding = UDim.new(0, 4)
	DropList.SortOrder = Enum.SortOrder.LayoutOrder

	local expanded = false
	DropdownBtn.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▲"
			DropdownFrame.Visible = true
			DropdownFrame.Size = UDim2.new(1, 0, 0, 185)
		else
			DropdownBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
			DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
			task.delay(0.2, function()
				if not expanded then DropdownFrame.Visible = false end
			end)
		end
	end)

	local function updateMasterSlide()
		local anyEnabled = false
		for _, v in pairs(slideSettings) do
			if v then anyEnabled = true break end
		end
		if anyEnabled or autoClaimTicketEnabled or autoCoinValentineEnabled or autoObbyMoneyEnabled then
			toggleUndergroundPlatform(true)
		else
			toggleUndergroundPlatform(false)
		end
	end

	CreateToggle("Auto Divine (Slide)", function(t) slideSettings.Divine = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Infinity (Slide)", function(t) slideSettings.Infinity = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Celestial (Slide)", function(t) slideSettings.Celestial = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Secret (Slide)", function(t) slideSettings.Secret = t; updateMasterSlide() end, DropdownFrame)
	CreateToggle("Auto Mythical (Slide)", function(t) slideSettings.Mythical = t; updateMasterSlide() end, DropdownFrame)
end

CreateLuckyBlockDropdown()

task.spawn(function()
	while true do
		task.wait(0.5) 

		if actionLock then continue end

		local activeTypes = {}
		if slideSettings.Divine then table.insert(activeTypes, "Divine") end
		if slideSettings.Infinity then table.insert(activeTypes, "Infinity") end
		if slideSettings.Celestial then table.insert(activeTypes, "Celestial") end
		if slideSettings.Secret then table.insert(activeTypes, "Secret") end
		if slideSettings.Mythical then table.insert(activeTypes, "Mythical") end

		if #activeTypes > 0 and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			local folder = workspace:FindFirstChild("ActiveLuckyBlocks")
			
			if folder then
				local collectedCount = 0
				local maxCollect = 3
				
				local function getClosestBlock()
					local closest = nil
					local minDist = 999999
					local myPos = lp.Character.HumanoidRootPart.Position
					
					for _, model in pairs(folder:GetChildren()) do
						local isValidType = false
						for _, typeName in pairs(activeTypes) do
							if string.find(model.Name, typeName) then isValidType = true break end
						end
						
						if isValidType and model:FindFirstChild("RootPart") then
							local root = model.RootPart
							local dist = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
							if dist < minDist then
								minDist = dist
								closest = model
							end
						end
					end
					return closest
				end
				
				while collectedCount < maxCollect do
					local targetModel = getClosestBlock()
					
					if targetModel then
						actionLock = true 
						local root = targetModel.RootPart
						
						local targetPos = Vector3.new(root.Position.X, root.Position.Y - 10, root.Position.Z)
						slideToPosition(targetPos) 
						
						local prompt = root:FindFirstChild("ProximityPrompt")
						if prompt then
							for i = 1, 10 do
								if not root.Parent or not prompt.Parent then break end
								fireproximityprompt(prompt)
								task.wait(0.05)
							end
						end
						
						collectedCount = collectedCount + 1
						task.wait(0.2)
					else
						break 
					end
				end
				
				if collectedCount > 0 then
					local base = workspace:FindFirstChild("SpawnLocation1")
					if base then
						local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
						slideToPosition(basePos)
					end
					actionLock = false 
					task.wait(1) 
				else
					actionLock = false
				end
			end
		end
	end
end)

CreateSection("OPTIMIZATION")

CreateToggle("Auto Reduce Lag+ (10m Loop)", function(toggled)
	autoReduceLagEnabled = toggled
	
	if autoReduceLagEnabled then
		task.spawn(function()
			while autoReduceLagEnabled do
				
				local targetNames = {
					"ActiveBrainrots", "ActiveTsunamis", "BaseLocations", 
					"Bases", "Leaderboards", "GeyserVisualVFX", 
					"Misc", "SpawnMachines"
				}
				
				for _, name in pairs(targetNames) do
					local obj = workspace:FindFirstChild(name)
					if obj then
						pcall(function() obj:Destroy() end)
					end
				end
				
				for _, v in pairs(Lighting:GetChildren()) do
					pcall(function() v:Destroy() end)
				end
				
				Lighting.GlobalShadows = false
				Lighting.FogEnd = 100000
				Lighting.Brightness = 2
				
				StarterGui:SetCore("SendNotification", {
					Title = "LAG REDUCED +",
					Text = "Workspace & Lighting dibersihkan (Loop 10 Menit berjalan).",
					Duration = 3
				})
				
				local timer = 0
				while autoReduceLagEnabled and timer < 600 do
					task.wait(1)
					timer = timer + 1
				end
			end
		end)
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Reduce Lag+",
			Text = "Auto Reduce Lag dihentikan.",
			Duration = 3
		})
	end
end)

CreateSection("PLAYER FOLLOWER")

TargetLabel = Instance.new("TextLabel")
TargetLabel.Text = "Target: None"
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextColor3 = colors.accent
TargetLabel.Font = Enum.Font.GothamSemibold
TargetLabel.TextSize = 13
TargetLabel.Parent = Container

CreateButton("Stop Following", function()
	StopFollowing()
end)

CreateButton("Refresh Player List", function()
	for _, gui in pairs(Container:GetChildren()) do
		if gui.Name == "PlayerButtonFrame" then gui:Destroy() end
	end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= lp then
			local BtnFrame = Instance.new("Frame")
			BtnFrame.Name = "PlayerButtonFrame"
			BtnFrame.Size = UDim2.new(1, 0, 0, 36)
			BtnFrame.BackgroundTransparency = 1
			BtnFrame.Parent = Container
			
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 1, 0)
			Btn.Position = UDim2.new(0, 5, 0, 0)
			Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Btn.Text = "Follow: " .. player.DisplayName
			Btn.TextColor3 = colors.subText
			Btn.Font = Enum.Font.GothamMedium
			Btn.TextSize = 12
			Btn.Parent = BtnFrame
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
			
			Btn.MouseButton1Click:Connect(function() StartFollowing(player) end)
		end
	end
end)

CreateSection("VISUALS (ESP)")

CreateToggle("ESP Divine", function() toggleEspLogic("Divine", "Divine") end)

CreateSection("ARCADE EVENT")

CreateToggle("Auto Game Console", function(toggled)
	autoConsoleEnabled = toggled
	if autoConsoleEnabled then
		task.spawn(function()
			while autoConsoleEnabled do
				task.wait(0.2)
				local folder = workspace:FindFirstChild("ArcadeEventConsoles")
				if folder and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					for _, model in pairs(folder:GetChildren()) do
						if model.Name == "Game Console" then
							local part = model:FindFirstChild("Game Console")
							if part and part:FindFirstChild("TouchInterest") then
								if firetouchinterest then
									firetouchinterest(hrp, part, 0)
									firetouchinterest(hrp, part, 1)
								else
									part.CFrame = hrp.CFrame
								end
							end
						end
					end
				end
			end
		end)
	end
end)

CreateToggle("Auto Claim Ticket (Underground)", function(toggled)
	autoClaimTicketEnabled = toggled
	if toggled then 
		toggleUndergroundPlatform(true) 
	else
		local anyLuckyBlockOn = false
		for _, v in pairs(slideSettings) do if v then anyLuckyBlockOn = true break end end
		if not anyLuckyBlockOn and not autoCoinValentineEnabled and not autoObbyMoneyEnabled then
			toggleUndergroundPlatform(false)
		end
	end
	
	if autoClaimTicketEnabled then
		task.spawn(function()
			while autoClaimTicketEnabled do
				task.wait(0.2) 
				
				if actionLock then continue end
				
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local collectedCount = 0
					local maxCollect = 10
					local hasCollectedAny = false
					
					local function getClosestTicket()
						local closest = nil
						local minDist = 999999
						local myPos = lp.Character.HumanoidRootPart.Position
						
						local folders = {
							workspace:FindFirstChild("ArcadeEventTickets"),
							workspace:FindFirstChild("TicketBombTickets")
						}
						
						for _, folder in pairs(folders) do
							if folder then
								for _, model in pairs(folder:GetChildren()) do
									if model.Name == "Ticket" and model:FindFirstChild("Ticket") then
										local part = model.Ticket
										local dist = (Vector3.new(part.Position.X, 0, part.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
										if dist < minDist then
											minDist = dist
											closest = model
										end
									end
								end
							end
						end
						return closest
					end
					
					while collectedCount < maxCollect do
						local targetTicket = getClosestTicket()
						
						if targetTicket then
							actionLock = true 
							hasCollectedAny = true
							
							local part = targetTicket.Ticket
							local targetPos = Vector3.new(part.Position.X, part.Position.Y - 10, part.Position.Z)
							
							slideToPosition(targetPos)
							
							local hrp = lp.Character.HumanoidRootPart
							if part:FindFirstChild("TouchInterest") then
								if firetouchinterest then
									firetouchinterest(hrp, part, 0)
									firetouchinterest(hrp, part, 1)
								else
									part.CFrame = hrp.CFrame
								end
							end
							
							collectedCount = collectedCount + 1
							task.wait(0.3) 
							pcall(function() targetTicket:Destroy() end)
						else
							break 
						end
					end
					
					if hasCollectedAny then
						local base = workspace:FindFirstChild("SpawnLocation1")
						if base then
							local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
							slideToPosition(basePos)
						end
						actionLock = false 
						task.wait(1) 
					else
						actionLock = false
					end
				end
			end
		end)
	end
end)

--=============================================================================
--// VALENTINE EVENT
--=============================================================================

CreateSection("VALENTINE EVENT")

CreateToggle("Auto Coin Valentine (Underground)", function(toggled)
	autoCoinValentineEnabled = toggled
	
	if toggled then 
		toggleUndergroundPlatform(true) 
	else
		local anyLuckyBlockOn = false
		for _, v in pairs(slideSettings) do if v then anyLuckyBlockOn = true break end end
		if not anyLuckyBlockOn and not autoClaimTicketEnabled and not autoObbyMoneyEnabled then
			toggleUndergroundPlatform(false)
		end
	end

	task.spawn(function()
		while autoCoinValentineEnabled do
			task.wait(0.1)
			local coinFolder = workspace:FindFirstChild("ValentinesCoinParts")
			
			if coinFolder and #coinFolder:GetChildren() > 0 then
				local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					for _, item in pairs(coinFolder:GetChildren()) do
						if item.Name == "ValentinesCoin" then 
							local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
							if part then
								local dist = (part.Position - hrp.Position).Magnitude
								if dist <= 280 then
									if firetouchinterest then
										firetouchinterest(hrp, part, 0)
										firetouchinterest(hrp, part, 1)
									else
										part.CFrame = hrp.CFrame
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	task.spawn(function()
		while autoCoinValentineEnabled do
			task.wait(0.2)
			
			if actionLock then continue end

			local coinFolder = workspace:FindFirstChild("ValentinesCoinParts")
			local isEventActive = false
			
			if coinFolder and coinFolder:FindFirstChild("ValentinesCoin") then
				isEventActive = true
			end

			if isEventActive then
				local targetPart = nil
				for _, folder in pairs(workspace:GetChildren()) do
					if string.find(folder.Name, "_SharedInstances") then 
						local floors = folder:FindFirstChild("Floors")
						if floors then
							targetPart = floors:FindFirstChild("Celestial")
							if targetPart then break end
						end
					end
				end

				local base = workspace:FindFirstChild("SpawnLocation1")

				if targetPart and base and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					
					actionLock = true 

					local targetPos = Vector3.new(targetPart.Position.X, targetPart.Position.Y - 10, targetPart.Position.Z)
					slideToPosition(targetPos)

					task.wait(5)

					local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
					slideToPosition(basePos)

					actionLock = false 

					task.wait(10)
					
				else
					task.wait(2)
				end
			else
				task.wait(1)
			end
		end
	end)
end)

--=============================================================================
--// MONEY EVENT
--=============================================================================

CreateSection("MONEY EVENT")

-- [NEW] FITUR AUTO OBBY MONEY (UNDERGROUND)
CreateToggle("Auto Obby Money (Underground)", function(toggled)
	autoObbyMoneyEnabled = toggled
	
	if toggled then 
		toggleUndergroundPlatform(true) 
	else
		local anyLuckyBlockOn = false
		for _, v in pairs(slideSettings) do if v then anyLuckyBlockOn = true break end end
		if not anyLuckyBlockOn and not autoClaimTicketEnabled and not autoCoinValentineEnabled then
			toggleUndergroundPlatform(false)
		end
	end

	if autoObbyMoneyEnabled then
		task.spawn(function()
			while autoObbyMoneyEnabled do
				task.wait(1)
				
				if actionLock then continue end

				-- Cek ketersediaan bagian akhir dari obby (Tanda event obby sedang berjalan)
				local end1, end2, end3
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") then
						if v.Name == "MoneyObby1End" then end1 = v
						elseif v.Name == "MoneyObby2End" then end2 = v
						elseif v.Name == "MoneyObby3End" then end3 = v
						end
					end
				end

				if end1 and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					actionLock = true 

					-- ACTION 1: Hapus Semua Lava secara langsung
					for _, v in pairs(workspace:GetDescendants()) do
						if v:IsA("BasePart") and v.Name == "Lava" then
							pcall(function() v:Destroy() end)
						end
					end

					local hrp = lp.Character.HumanoidRootPart

					-- Helper Logic: Meluncur ke target bawah tanah, lalu sentuh titiknya dengan CFrame / firetouch
					local function slideAndTouch(part)
						if part and part.Parent then
							-- Meluncur persis di bawah target (posisi aman underground)
							local targetPos = Vector3.new(part.Position.X, part.Position.Y - 10, part.Position.Z)
							slideToPosition(targetPos)
							
							-- Setelah sampai pas dibawahnya, sentuh target untuk nge-trigger checkpoint
							if firetouchinterest then
								firetouchinterest(hrp, part, 0)
								firetouchinterest(hrp, part, 1)
							else
								-- Jika tidak ada firetouchinterest, naikan sedikit untuk menyentuhnya manual
								hrp.CFrame = part.CFrame
							end
						end
					end

					-- ACTION 2: Eksekusi Slide Sequence
					
					-- Phase 1 (Obby 1)
					slideAndTouch(end1)
					task.wait(5) -- Jeda waktu respawn di MoneyCheckpoint1
					
					-- Phase 2 (Cari ulang end2 untuk jaga-jaga kalau partnya dimuat ulang game saat teleport)
					local currentEnd2
					for _, v in pairs(workspace:GetDescendants()) do
						if v:IsA("BasePart") and v.Name == "MoneyObby2End" then currentEnd2 = v break end
					end
					
					if currentEnd2 then
						slideAndTouch(currentEnd2)
						task.wait(5) -- Jeda waktu respawn di MoneyCheckpoint2
					end
					
					-- Phase 3 (Cari ulang end3)
					local currentEnd3
					for _, v in pairs(workspace:GetDescendants()) do
						if v:IsA("BasePart") and v.Name == "MoneyObby3End" then currentEnd3 = v break end
					end
					
					if currentEnd3 then
						slideAndTouch(currentEnd3)
						task.wait(2) -- Jeda penyelesaian obby 3
					end

					-- ACTION 3: Kembali meluncur ke Base dengan aman
					local base = workspace:FindFirstChild("SpawnLocation1")
					if base then
						local basePos = Vector3.new(base.Position.X, base.Position.Y - 10, base.Position.Z)
						slideToPosition(basePos)
					end
					
					-- Lepas kunci lock & diam agar tidak nge-loop terus-terusan selagi eventnya belum hilang total
					actionLock = false
					task.wait(10) 
				end
			end
		end)
	end
end)

CreateSection("MISC")

CreateButton("Delete Safe Walls", function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if walls then for _, v in pairs(walls:GetChildren()) do v:Destroy() end end
end)

--=============================================================================
--// SERVER FEATURES
--=============================================================================

CreateSection("SERVER")

CreateToggle("Anti AFK (20m Bypass)", function(toggled)
	if toggled then
		antiAfkConnection = lp.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		
		StarterGui:SetCore("SendNotification", {
			Title = "Anti AFK ON",
			Text = "You won't get kicked for idling.",
			Duration = 3
		})
	else
		if antiAfkConnection then
			antiAfkConnection:Disconnect()
			antiAfkConnection = nil
		end
		
		StarterGui:SetCore("SendNotification", {
			Title = "Anti AFK OFF",
			Text = "Idle kick is back to normal.",
			Duration = 3
		})
	end
end)

CreateToggle("Fast Interact (Global)", function(toggled)
	fastInteractEnabled = toggled
	
	local function makeInstant(prompt)
		prompt.HoldDuration = 0
		if not activeInteractConnections[prompt] then
			activeInteractConnections[prompt] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
				if fastInteractEnabled and prompt.HoldDuration > 0 then
					prompt.HoldDuration = 0 
				end
			end)
		end
	end

	if fastInteractEnabled then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				makeInstant(v)
			end
		end
		ftConnection = ProximityPromptService.PromptAdded:Connect(makeInstant)
	else
		if ftConnection then ftConnection:Disconnect() ftConnection = nil end
		for _, conn in pairs(activeInteractConnections) do
			conn:Disconnect()
		end
		activeInteractConnections = {}
	end
end)

CreateToggle("Unlimited Zoom + Camera Clip", function(toggled)
	if toggled then
		lp.CameraMaxZoomDistance = 100000 
		lp.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam 
	else
		lp.CameraMaxZoomDistance = 128 
		lp.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
	end
end)

print("✅ Dj Hub Remastered (Auto Obby Added) Loaded")
