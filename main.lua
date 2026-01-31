--// Dj Hub (Remastered UI Version)
--// Mobile Friendly & Minimalist Design

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui") -- Added for Notifications
local SoundService = game:GetService("SoundService") -- Added for Sound

local lp = Players.LocalPlayer

--=============================================================================
--// GUI LIBRARY & SETUP (UI VISUALS)
--=============================================================================

local Library = {}
local colors = {
	background = Color3.fromRGB(15, 15, 15),
	accent = Color3.fromRGB(255, 120, 30), -- Warna Orange mirip Lynx
	text = Color3.fromRGB(240, 240, 240),
	subText = Color3.fromRGB(150, 150, 150),
	toggleOn = Color3.fromRGB(255, 120, 30),
	toggleOff = Color3.fromRGB(60, 60, 60)
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

-- 3. Dragging Function (Mobile Support)
local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(0.1), {Position = newPos}):Play()
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
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BackgroundTransparency = 0.15 -- Transparan dikit
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Side Accent Line (Style Lynx)
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0, 4, 1, 0)
AccentLine.BackgroundColor3 = colors.accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame
Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 8)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 40)
Header.Position = UDim2.new(0, 20, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Dj Hub <font color=\"rgb(255,120,30)\">Premium</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = colors.text
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Buttons (Close & Min)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = colors.text
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamMedium
MinBtn.TextSize = 24
MinBtn.TextColor3 = colors.text
MinBtn.BackgroundTransparency = 1
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.Parent = Header

-- Content Container
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

-- Apply Drag
makeDraggable(MainFrame, Header)

-- 5. Component Functions (Toggle & Button)

local function CreateToggle(text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 14
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
		
		-- Animation
		local targetColor = toggled and colors.toggleOn or colors.toggleOff
		local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
		
		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
		
		-- Logic Callback
		pcall(callback)
	end)
	
	return Trigger -- Return trigger if needed
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
	Btn.TextSize = 14
	Btn.Parent = BtnFrame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	
	Btn.MouseButton1Click:Connect(function()
		-- Click Effect
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

-- 6. Minimize Logic (Kotak Kecil)
local minimized = false
local restoreSize = MainFrame.Size
local restorePos = MainFrame.Position

-- Icon untuk mode minimize
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

-- Buat icon bisa didrag juga
makeDraggable(MinIcon)

MinBtn.MouseButton1Click:Connect(function()
	minimized = true
	restorePos = MainFrame.Position -- Save posisi terakhir
	MainFrame.Visible = false
	MinIcon.Visible = true
	MinIcon.Position = restorePos -- Muncul di posisi GUI terakhir
end)

MinIcon.MouseButton1Click:Connect(function()
	minimized = false
	MinIcon.Visible = false
	MainFrame.Visible = true
	MainFrame.Position = MinIcon.Position -- Restore di posisi icon terakhir
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--=============================================================================
--// FEATURE LOGIC INTEGRATION (Logic Asli + Feature Baru)
--=============================================================================

-- Variables Logic
local platformEnabled = false
local pPart, pConn, lastY = nil, nil, 0
local noclipOn = false
local noclipConn = nil
local ESP = { enabled = {}, connections = {}, markers = {} }
local fastTakeEnabled = false
local ftConnection = nil

-- Variables Notif Logic (FEATURE BARU)
local notifConfig = {
	Divine = false,
	Celestial = false
}
local notifListeners = {}

-- 1. Helper Logic Functions
local function removeMarker(obj)
	local data = ESP.markers[obj]
	if data then
		pcall(function() data.hl:Destroy() data.bb:Destroy() data.ac:Disconnect() end)
		ESP.markers[obj] = nil
	end
end

local function addMarker(obj, label)
	if not obj:IsA("Model") or obj.Name ~= "RenderedBrainrot" then return end
	local root = obj:FindFirstChild("Root") or obj:FindFirstChildWhichIsA("BasePart", true)
	if not root or ESP.markers[obj] then return end

	local hl = Instance.new("Highlight", obj)
	hl.FillColor = (label == "Divine" and Color3.fromRGB(255,215,0)) or (label == "Celestial" and Color3.fromRGB(0,255,255)) or Color3.fromRGB(200,200,200)

	local bb = Instance.new("BillboardGui", obj)
	bb.Adornee = root
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 3, 0)
	
	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.Text = label .. " Brainrot"

	ESP.markers[obj] = { hl = hl, bb = bb, ac = obj.AncestryChanged:Connect(function() if not obj.Parent then removeMarker(obj) end end) }
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

local function applyFastTake(prompt)
	if prompt:IsA("ProximityPrompt") and prompt.Name == "TakePrompt" then
		prompt.HoldDuration = 0
		prompt.MaxActivationDistance = 25
	end
end

-- FUNCTION NOTIF BARU (SOUND & TEXT)
local function playNotifSoundAndText(rarity)
	-- Play Sound (Generic Notification Sound)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://4590657391" -- Suara 'Ting' jelas
	sound.Volume = 6
	sound.Parent = SoundService
	sound:Play()
	
	-- Cleanup sound after playing
	game:GetService("Debris"):AddItem(sound, 3)

	-- Show Notification Text
	StarterGui:SetCore("SendNotification", {
		Title = rarity .. " BRAINROT!",
		Text = "TEXT (" .. rarity .. " BRAINROT MUNCUL!)",
		Duration = 5,
		Icon = "rbxassetid://6023426915" -- Icon seru (optional)
	})
end

-- SETUP LISTENER UNTUK NOTIF
local function setupNotifListener(category)
	if notifListeners[category] then return end -- Sudah ada listener
	
	-- Tunggu folder aman
	local activeFolder = workspace:FindFirstChild("ActiveBrainrots")
	if not activeFolder then return end
	
	local targetFolder = activeFolder:FindFirstChild(category)
	if targetFolder then
		notifListeners[category] = targetFolder.ChildAdded:Connect(function(child)
			if notifConfig[category] then
				playNotifSoundAndText(category:upper())
			end
		end)
	end
end

-- Initialize Listeners immediately (agar ready pas di toggle)
task.spawn(function()
	if not workspace:FindFirstChild("ActiveBrainrots") then
		workspace.ChildAdded:Wait()
	end
	setupNotifListener("Divine")
	setupNotifListener("Celestial")
    setupNotifListener("Common")
end)

--=============================================================================
--// UI ELEMENT CREATION (MAPPING LOGIC KE UI)
--=============================================================================

CreateSection("PLAYER")

CreateToggle("Platform Walk", function()
	platformEnabled = not platformEnabled
	if platformEnabled then
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
				if hum and hum.FloorMaterial == Enum.Material.Air then
					lastY = hrp.Position.Y - 3.2
				end
				pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
			end
		end)
	else
		if pConn then pConn:Disconnect() pConn = nil end
		if pPart then pPart:Destroy() pPart = nil end
	end
end)

CreateToggle("Noclip", function()
	noclipOn = not noclipOn
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

CreateSection("NOTIFICATIONS (BRAINROT)") -- BAGIAN UI BARU

CreateToggle("Notif DEVINE Brainrot", function()
	notifConfig["Divine"] = not notifConfig["Divine"]
	-- Listener sudah auto setup di background, tinggal ubah config true/false
end)

CreateToggle("Notif CELESTIAL Brainrot", function()
	notifConfig["Celestial"] = not notifConfig["Celestial"]
end)

CreateToggle("Notif COMMON Brainrot", function()
	notifConfig["Common"] = not notifConfig["Common"]
end)


CreateSection("VISUALS (ESP)")

CreateToggle("ESP Divine", function() toggleEspLogic("Divine", "Divine") end)
CreateToggle("ESP Celestial", function() toggleEspLogic("Celestial", "Celestial") end)
CreateToggle("ESP Common", function() toggleEspLogic("Common", "Common") end)

CreateSection("MISC")

CreateToggle("Fast Take", function()
	fastTakeEnabled = not fastTakeEnabled
	local activeFolder = workspace:FindFirstChild("ActiveBrainrots")
	if not activeFolder then return end

	if fastTakeEnabled then
		for _, descendant in pairs(activeFolder:GetDescendants()) do
			applyFastTake(descendant)
		end
		ftConnection = activeFolder.DescendantAdded:Connect(function(desc)
			if desc.Name == "TakePrompt" then
				task.wait(0.1)
				applyFastTake(desc)
			end
		end)
	else
		if ftConnection then ftConnection:Disconnect() ftConnection = nil end
	end
end)

CreateButton("Delete Safe Walls", function()
	local walls = workspace:FindFirstChild("VIPWalls") or workspace:FindFirstChild("Wallses")
	if walls then
		for _, v in pairs(walls:GetChildren()) do v:Destroy() end
	end
end)

-- Finish
print("✅ Dj Hub Remastered Loaded")
