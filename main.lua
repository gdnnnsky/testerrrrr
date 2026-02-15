--// Dj Hub (Ultimate Version - Lag Reducer Added)
--// Features: Realtime Follow + Smart Auto Equip + Arcade ESP + Reduce Lag + Valentine Auto Collect & Deposit
--// Update: Smart Fast Interact (Anti-Reset) & Fixed Deposit

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")

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

-- 1. Setup Parent
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

-- Cleanup Old GUI
pcall(function()
	if parent:FindFirstChild("DjHubRemastered") then
		parent.DjHubRemastered:Destroy()
	end
end)

-- 2. Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DjHubRemastered"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- 3. Dragging Function
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

-- 4. Main Window Construction
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 400) 
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -200)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BackgroundTransparency = 0.35 
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

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

-- 5. Component Functions

local function CreateToggle(text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = Container
	
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

-- 6. Minimize Logic
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
local activeInteractConnections = {} -- [NEW] To track listeners
local autoConsoleEnabled = false
local autoTicketEnabled = false
local autoValentineEnabled = false 
local autoDepositEnabled = false
local notifConfig = { Divine = false, Celestial = false, Common = false }
local notifListeners = {}

-- Variables for FOLLOW PLAYER
local followTarget = nil
local followConnection = nil

-- Variables for AUTO EQUIP
local autoEquipEnabled = false

--=============================================================================
--// LOGIC FUNCTIONS
--=============================================================================

-- 1. Platform Logic 
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

-- 2. Helper Logic: Check Item Name
local function isTargetItem(tool, keyword)
	if not tool:IsA("Tool") then return false end
	if tool.ToolTip and string.find(tool.ToolTip, keyword) then return true end
	if string.find(tool.Name, keyword) then return true end
	if tool:GetAttribute("DisplayName") and string.find(tool:GetAttribute("DisplayName"), keyword) then return true end
	return false
end

-- 3. ESP & Visuals
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

local function addItemMarker(obj, type)
	if ESP.markers[obj] then return end
	local root = obj:FindFirstChildWhichIsA("BasePart")
	if not root then return end
	
	local color = (type == "Ticket") and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(170, 0, 255)
	local labelText = (type == "Ticket") and "🎟 Ticket" or "🎮 Console"
	
	local hl = Instance.new("Highlight", obj)
	hl.FillColor = color
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.5
	
	local bb = Instance.new("BillboardGui", obj)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 2, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextStrokeTransparency = 0
	txt.TextColor3 = color
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 13
	txt.Text = labelText
	
	ESP.markers[obj] = {
		hl = hl,
		bb = bb,
		ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end)
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

local function toggleItemEsp(mode, folderName)
	ESP.enabled[mode] = not ESP.enabled[mode]
	local isOn = ESP.enabled[mode]
	if ESP.connections[mode] then ESP.connections[mode]:Disconnect() end
	local folder = workspace:FindFirstChild(folderName)
	if isOn and folder then
		for _, v in pairs(folder:GetChildren()) do addItemMarker(v, mode) end
		ESP.connections[mode] = folder.ChildAdded:Connect(function(c) addItemMarker(c, mode) end)
	else
		for obj, _ in pairs(ESP.markers) do 
			if obj:IsDescendantOf(folder) then removeMarker(obj) end 
		end
	end
end

-- 4. Follow Player Logic
local TargetLabel -- Forward declaration

local function StopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	followTarget = nil
	if TargetLabel then TargetLabel.Text = "Target: None" end
end

local function StartFollowing(targetPlayer)
	StopFollowing() -- Clean old connection
	if not targetPlayer then return end
	
	followTarget = targetPlayer
	if TargetLabel then TargetLabel.Text = "Following: " .. targetPlayer.Name end
	
	followConnection = RunService.RenderStepped:Connect(function()
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

-- 5. Auto Equip Logic
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

-- 6. Notification Logic
local function playNotifSoundAndText(rarity)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://8486683243"
	sound.Volume = 7
	sound.Parent = SoundService
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 3)
	
	StarterGui:SetCore("SendNotification", {
		Title = rarity .. " BRAINROT!",
		Text = "TEXT (" .. rarity .. " BRAINROT MUNCUL!)",
		Duration = 7
	})
end

local function setupNotifListener(category)
	if notifListeners[category] then return end
	local activeFolder = workspace:FindFirstChild("ActiveBrainrots")
	if not activeFolder then return end
	local targetFolder = activeFolder:FindFirstChild(category)
	if targetFolder then
		notifListeners[category] = targetFolder.ChildAdded:Connect(function(child)
			if notifConfig[category] then playNotifSoundAndText(category:upper()) end
		end)
	end
end

task.spawn(function()
	if not workspace:FindFirstChild("ActiveBrainrots") then workspace.ChildAdded:Wait() end
	setupNotifListener("Divine")
	setupNotifListener("Celestial")
	setupNotifListener("Common")
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

CreateSection("OPTIMIZATION")

CreateButton("Reduce Lag+ (Delete Maps)", function()
	local targets = {
		"ActiveBrainrots", "ActiveLuckyBlocks", "ActiveTsunamis", "Bases",
		"Leaderboards", "Misc", "SellPoint", "SpawnMachines",
		"ArcadeWheel", "EventTimers", "LimitedShop", "UpgradeShop", "WaveMachine"
	}
	
	-- Delete Workspace Targets
	for _, name in pairs(targets) do
		local obj = workspace:FindFirstChild(name)
		if obj then 
			pcall(function() obj:Destroy() end)
		end
	end
	
	-- Clear Lighting
	for _, v in pairs(Lighting:GetChildren()) do
		if not v:IsA("Script") then
			pcall(function() v:Destroy() end)
		end
	end
	
	-- Reset basic lighting settings for better FPS
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
	
	StarterGui:SetCore("SendNotification", {
		Title = "LAG REDUCED",
		Text = "Maps & Lighting deleted for FPS Boost!",
		Duration = 3
	})
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

CreateSection("NOTIFICATIONS")

CreateToggle("Notif DEVINE", function(t) notifConfig["Divine"] = t end)
CreateToggle("Notif CELESTIAL", function(t) notifConfig["Celestial"] = t end)
CreateToggle("Notif COMMON", function(t) notifConfig["Common"] = t end)

CreateSection("VISUALS (ESP)")

CreateToggle("ESP Divine", function() toggleEspLogic("Divine", "Divine") end)
CreateToggle("ESP Celestial", function() toggleEspLogic("Celestial", "Celestial") end)
CreateToggle("ESP Common", function() toggleEspLogic("Common", "Common") end)

CreateSection("ARCADE EVENT")

CreateToggle("ESP Game Console", function() toggleItemEsp("Console", "ArcadeEventConsoles") end)
CreateToggle("ESP Ticket", function() toggleItemEsp("Ticket", "ArcadeEventTickets") end)

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

CreateToggle("Auto Tickets", function(toggled)
	autoTicketEnabled = toggled
	if autoTicketEnabled then
		task.spawn(function()
			while autoTicketEnabled do
				task.wait(0.2)
				local folder = workspace:FindFirstChild("ArcadeEventTickets")
				if folder and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					for _, model in pairs(folder:GetChildren()) do
						if model.Name == "Ticket" then
							local part = model:FindFirstChild("Ticket")
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

--=============================================================================
--// VALENTINE EVENT
--=============================================================================

CreateSection("VALENTINE EVENT")

CreateToggle("Auto Collect Valentine", function(toggled)
	autoValentineEnabled = toggled
	if autoValentineEnabled then
		task.spawn(function()
			while autoValentineEnabled do
				task.wait(0.2)
				local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
				
				if hrp then
					local function collectPart(part)
						if not part then return end
						if firetouchinterest then
							firetouchinterest(hrp, part, 0)
							firetouchinterest(hrp, part, 1)
						else
							part.CFrame = hrp.CFrame
						end
					end

					local candyFolder = workspace:FindFirstChild("CandyEventParts")
					if candyFolder then
						for _, item in pairs(candyFolder:GetChildren()) do
							if string.match(item.Name, "Candy%d") then 
								local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
								collectPart(part)
							end
						end
					end

					local coinFolder = workspace:FindFirstChild("ValentinesCoinParts")
					if coinFolder then
						for _, item in pairs(coinFolder:GetChildren()) do
							if string.find(item.Name, "ValentinesCoin") then
								local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
								collectPart(part)
							end
						end
					end
				end
			end
		end)
	end
end)

CreateToggle("Auto Deposit Candy (4s)", function(toggled)
	autoDepositEnabled = toggled
	if autoDepositEnabled then
		task.spawn(function()
			while autoDepositEnabled do
				task.wait(4)
				pcall(function()
					-- Path: ValentinesMap -> CandyGramStation -> Main -> Attachment -> ProximityPrompt
					local map = workspace:FindFirstChild("ValentinesMap")
					if map then
						local station = map:FindFirstChild("CandyGramStation")
						if station then
							local main = station:FindFirstChild("Main")
							if main then
								-- [IMPROVED] Teleport & Distance Bypass
								if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
									lp.Character.HumanoidRootPart.CFrame = main.CFrame * CFrame.new(0, 3, 0)
								end
								
								local att = main:FindFirstChild("Attachment")
								if att then
									local prompt = att:FindFirstChild("ProximityPrompt")
									if prompt then
										prompt.MaxActivationDistance = 99999 -- [IMPROVED] Bypass Distance
										prompt.HoldDuration = 0
										prompt.RequiresLineOfSight = false
										
										if fireproximityprompt then
											fireproximityprompt(prompt)
										else
											-- Fallback if exploit weak
											prompt:InputHoldBegin()
											task.wait()
											prompt:InputHoldEnd()
										end
									end
								end
							end
						end
					end
				end)
			end
		end)
	end
end)

CreateSection("MISC")

CreateToggle("Fast Interact (Global)", function(toggled)
	fastInteractEnabled = toggled
	
	if fastInteractEnabled then
		-- Logic: Apply Instant & Listener to enforce it
		local function enforceInstant(prompt)
			-- Set initial
			prompt.HoldDuration = 0
			
			-- Listen if game changes it back
			if not activeInteractConnections[prompt] then
				activeInteractConnections[prompt] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
					if fastInteractEnabled and prompt.HoldDuration > 0 then
						prompt.HoldDuration = 0
					end
				end)
			end
		end

		-- 1. Apply to all existing
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				enforceInstant(v)
			end
		end
		
		-- 2. Listen for new prompts
		ftConnection = ProximityPromptService.PromptAdded:Connect(enforceInstant)
	else
		-- Cleanup
		if ftConnection then ftConnection:Disconnect() ftConnection = nil end
		for _, conn in pairs(activeInteractConnections) do
			conn:Disconnect()
		end
		activeInteractConnections = {}
	end
end)

CreateButton("Delete Safe Walls", function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if walls then for _, v in pairs(walls:GetChildren()) do v:Destroy() end end
end)

print("✅ Dj Hub Remastered (Smart Anti-Reset Fast Interact) Loaded")
