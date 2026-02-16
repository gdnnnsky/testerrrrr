--// Dj Hub (Ultimate Version - Slide Mode Fix + Dropdown Menu)
--// Features: Realtime Follow + Smart Auto Equip + Arcade ESP + Reduce Lag + Valentine Auto Collect & Deposit
--// Update: rooLucky Block Slide Mode (Combo Fix & UI Dropdown)

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
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 550) -- Sedikit lebih panjang
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

-- UI Helpers
local function CreateToggle(text, callback, parentFrame)
	local targetParent = parentFrame or Container
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = targetParent
	
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
	return ToggleFrame
end

local function CreateButton(text, callback, parentFrame)
	local targetParent = parentFrame or Container
	local BtnFrame = Instance.new("Frame")
	BtnFrame.Size = UDim2.new(1, 0, 0, 36)
	BtnFrame.BackgroundTransparency = 1
	BtnFrame.Parent = targetParent
	
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
	return BtnFrame, Btn
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

-- Min/Close Logic
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
makeDraggable(MinIcon)

MinBtn.MouseButton1Click:Connect(function() minimized = true; MainFrame.Visible = false; MinIcon.Visible = true; MinIcon.Position = MainFrame.Position end)
MinIcon.MouseButton1Click:Connect(function() minimized = false; MinIcon.Visible = false; MainFrame.Visible = true; MainFrame.Position = MinIcon.Position end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

--=============================================================================
--// VARIABLES
--=============================================================================

local pPart, pConn, lastY = nil, nil, 0
local platformShortcutBtn = nil
local noclipOn, noclipConn = false, nil
local ESP = { enabled = {}, connections = {}, markers = {} }
local autoEquipEnabled = false
local autoConsoleEnabled, autoTicketEnabled, autoClaimTicketEnabled = false, false, false
local autoValentineEnabled, autoDepositEnabled, isDepositing = false, false, false

-- [SLIDE MODE VARIABLES]
local slideModes = { Divine = false, Infinity = false, Celestial = false }
local masterSlideRunning = false
local undergroundPlatform = nil
local undergroundConnection = nil
local undergroundFixedY = nil 

--=============================================================================
--// LOGIC FUNCTIONS
--=============================================================================

-- 1. Standard Platform
local function togglePlatformState(state)
	if state then
		if not pPart then
			pPart = Instance.new("Part", workspace)
			pPart.Name = "DjPlatform"
			pPart.Size = Vector3.new(15, 0.5, 15)
			pPart.Anchored = true; pPart.Transparency = 0.5; pPart.Material = Enum.Material.ForceField; pPart.Color = Color3.fromRGB(0, 255, 255)
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lastY = lp.Character.HumanoidRootPart.Position.Y - 3.2 end
			pConn = RunService.PostSimulation:Connect(function()
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = lp.Character.HumanoidRootPart
					pPart.CFrame = CFrame.new(hrp.Position.X, lastY, hrp.Position.Z)
				end
			end)
		end
	else
		if pConn then pConn:Disconnect(); pConn = nil end
		if pPart then pPart:Destroy(); pPart = nil end
	end
end

-- 2. Underground Platform (Single Instance for Combo)
local function setUndergroundState(isActive)
	if isActive then
		-- HANYA jika belum ada platform, kita buat
		if not undergroundPlatform then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				-- Tentukan ketinggian dasar (Base Y)
				-- Kita ambil SpawnLocation1 sebagai referensi dasar tanah agar konsisten
				local baseSpawn = workspace:FindFirstChild("SpawnLocation1")
				local safeY = 0
				if baseSpawn then
					safeY = baseSpawn.Position.Y - 12 -- 12 Studs di bawah spawn
				else
					safeY = hrp.Position.Y - 12 -- Fallback
				end
				
				undergroundFixedY = safeY -- Kunci Y disini
				
				-- Teleport awal ke bawah (Hanya sekali)
				if math.abs(hrp.Position.Y - undergroundFixedY) > 5 then
					hrp.CFrame = CFrame.new(hrp.Position.X, undergroundFixedY, hrp.Position.Z)
				end
				
				undergroundPlatform = Instance.new("Part", workspace)
				undergroundPlatform.Name = "DjUndergroundPlatform"
				undergroundPlatform.Size = Vector3.new(15, 1, 15)
				undergroundPlatform.Anchored = true
				undergroundPlatform.Transparency = 0.5
				undergroundPlatform.Material = Enum.Material.Neon
				undergroundPlatform.Color = Color3.fromRGB(255, 0, 0)
				
				undergroundConnection = RunService.Heartbeat:Connect(function()
					if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and undergroundFixedY then
						local currentHRP = lp.Character.HumanoidRootPart
						-- Platform stay di undergroundFixedY, ikut X/Z player
						undergroundPlatform.CFrame = CFrame.new(currentHRP.Position.X, undergroundFixedY - 3.5, currentHRP.Position.Z)
					end
				end)
			end
		end
	else
		-- Jika semua mode mati, baru hancurkan
		local anyModeOn = slideModes.Divine or slideModes.Infinity or slideModes.Celestial
		if not anyModeOn then
			undergroundFixedY = nil
			if undergroundConnection then undergroundConnection:Disconnect(); undergroundConnection = nil end
			if undergroundPlatform then undergroundPlatform:Destroy(); undergroundPlatform = nil end
		end
	end
end

local function slideToPosition(targetPos)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not undergroundFixedY then return end
	
	local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
	local speed = 250 -- Kecepatan Slide
	local time = dist / speed
	
	-- Pastikan Y tetap di undergroundFixedY (Jangan naik ke permukaan)
	local targetCFrame = CFrame.new(targetPos.X, undergroundFixedY, targetPos.Z)
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
	hrp.AssemblyLinearVelocity = Vector3.zero
end

-- 3. Master Slide Loop (Handles Logic for Divine, Infinity, Celestial)
local function updateMasterSlideLogic()
	if masterSlideRunning then return end -- Sudah jalan, jangan double
	masterSlideRunning = true
	
	task.spawn(function()
		while slideModes.Divine or slideModes.Infinity or slideModes.Celestial do
			-- Pastikan platform & posisi aman
			setUndergroundState(true)
			
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			local folder = workspace:FindFirstChild("ActiveLuckyBlocks")
			
			if hrp and folder and undergroundFixedY then
				local targetBlock = nil
				
				-- Cari block sesuai prioritas / yang aktif
				for _, model in pairs(folder:GetChildren()) do
					if slideModes.Divine and string.find(model.Name, "Divine") then
						targetBlock = model; break
					elseif slideModes.Infinity and string.find(model.Name, "Infinity") then
						targetBlock = model; break
					elseif slideModes.Celestial and string.find(model.Name, "Celestial") then
						targetBlock = model; break
					end
				end
				
				if targetBlock then
					local root = targetBlock:FindFirstChild("RootPart")
					if root then
						-- 1. Slide ke Target (Tetap di bawah tanah)
						slideToPosition(root.Position)
						task.wait(0.1)
						
						-- 2. Ambil (Spam Prompt)
						local prompt = root:FindFirstChild("ProximityPrompt")
						if prompt then
							for i = 1, 10 do
								if not root.Parent or not prompt.Parent then break end
								fireproximityprompt(prompt)
								task.wait(0.05)
							end
						end
						
						-- 3. Slide Balik ke Base (PENTING: Jangan naik ke atas)
						local base = workspace:FindFirstChild("SpawnLocation1")
						if base then
							slideToPosition(base.Position)
						end
						
						task.wait(1) -- Cooldown dikit sebelum cari lagi
					end
				else
					task.wait(0.5) -- Gak ada block, tunggu sebentar
				end
			else
				task.wait(1)
			end
			task.wait(0.1)
		end
		
		-- Loop berhenti karena semua false
		masterSlideRunning = false
		setUndergroundState(false) -- Matikan platform
	end)
end

--=============================================================================
--// UI CONSTRUCTION
--=============================================================================

CreateSection("PLAYER")
CreateToggle("Platform Walk (w/ Shortcut)", function(t) togglePlatformState(t) end)
CreateToggle("Noclip", function(t) 
	noclipOn = t 
	if t then 
		noclipConn = RunService.Stepped:Connect(function() 
			if lp.Character then for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end 
		end) 
	else 
		if noclipConn then noclipConn:Disconnect() end 
	end 
end)

CreateSection("AUTO ITEMS")
CreateToggle("Auto Equip Best Block", function(t) autoEquipEnabled = t end)

--=============================================================================
--// NEW: LUCKY BLOCK SLIDE MODE (DROPDOWN)
--=============================================================================

CreateSection("LUCKY BLOCK MENU")

-- Container untuk dropdown items
local SlideMenuContainer = Instance.new("Frame")
SlideMenuContainer.Name = "SlideMenuContainer"
SlideMenuContainer.Size = UDim2.new(1, 0, 0, 0) -- Mulai dari 0 (tertutup)
SlideMenuContainer.BackgroundTransparency = 1
SlideMenuContainer.ClipsDescendants = true -- Agar item tidak bocor saat tertutup
SlideMenuContainer.AutomaticSize = Enum.AutomaticSize.Y -- Otomatis membesar
SlideMenuContainer.Visible = false
SlideMenuContainer.Parent = Container

local SlideList = Instance.new("UIListLayout")
SlideList.Parent = SlideMenuContainer
SlideList.Padding = UDim.new(0, 4)
SlideList.SortOrder = Enum.SortOrder.LayoutOrder

-- Tombol Utama untuk Membuka Menu
local menuOpen = false
local _, MenuBtn = CreateButton("LUCKY BLOCK (SLIDE MODE) ▼", function()
	menuOpen = not menuOpen
	if menuOpen then
		MenuBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▲"
		SlideMenuContainer.Visible = true
	else
		MenuBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
		SlideMenuContainer.Visible = false
	end
end)

-- Styling Dropdown agar sedikit menjorok ke dalam
local function CreateSlideToggle(name, key)
	local frame = CreateToggle(name, function(t)
		slideModes[key] = t
		if t then
			updateMasterSlideLogic() -- Jalankan Master Loop
		else
			-- Cek apakah semua mati, logic ada di dalam loop master
		end
	end, SlideMenuContainer)
	
	-- Visual indent
	local pad = Instance.new("UIPadding", frame)
	pad.PaddingLeft = UDim.new(0, 20) 
end

-- Isi Dropdown
CreateSlideToggle("- Auto Divine (Slide)", "Divine")
CreateSlideToggle("- Auto Infinity (Slide)", "Infinity")
CreateSlideToggle("- Auto Celestial (Slide)", "Celestial")


--=============================================================================
--// OTHER FEATURES
--=============================================================================

CreateSection("OPTIMIZATION")
CreateButton("Reduce Lag+ (Delete Maps)", function()
	local targets = {"ActiveBrainrots", "ActiveLuckyBlocks", "ActiveTsunamis", "Bases", "Leaderboards", "Misc", "SellPoint", "SpawnMachines", "ArcadeWheel", "EventTimers", "LimitedShop", "UpgradeShop", "WaveMachine"}
	for _, name in pairs(targets) do pcall(function() workspace[name]:Destroy() end) end
	Lighting.GlobalShadows = false; Lighting.FogEnd = 100000; Lighting.Brightness = 2
end)

CreateSection("PLAYER FOLLOWER")
local TargetLabel = Instance.new("TextLabel", Container)
TargetLabel.Text = "Target: None"; TargetLabel.Size = UDim2.new(1,0,0,20); TargetLabel.BackgroundTransparency=1; TargetLabel.TextColor3=colors.accent

local followTarget, followConnection = nil, nil
local function StopFollowing() if followConnection then followConnection:Disconnect() end; followTarget=nil; TargetLabel.Text="Target: None" end
local function StartFollowing(plr)
	StopFollowing(); followTarget = plr; TargetLabel.Text = "Following: "..plr.Name
	followConnection = RunService.RenderStepped:Connect(function()
		if isDepositing then return end
		if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character.HumanoidRootPart.CFrame = followTarget.Character.HumanoidRootPart.CFrame * CFrame.new(4,0,0)
			lp.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		else StopFollowing() end
	end)
end

CreateButton("Stop Following", StopFollowing)
CreateButton("Refresh Player List", function()
	for _,v in pairs(Container:GetChildren()) do if v.Name=="PlayerButtonFrame" then v:Destroy() end end
	for _,p in pairs(Players:GetPlayers()) do
		if p~=lp then
			local _, b = CreateButton("Follow: "..p.DisplayName, function() StartFollowing(p) end)
			b.Parent.Name = "PlayerButtonFrame"
		end
	end
end)

CreateSection("ARCADE EVENT")
CreateToggle("Auto Game Console", function(t) 
	autoConsoleEnabled = t
	if t then task.spawn(function()
		while autoConsoleEnabled do task.wait(0.2)
			local f = workspace:FindFirstChild("ArcadeEventConsoles")
			if f and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				for _,m in pairs(f:GetChildren()) do 
					if m.Name=="Game Console" and m:FindFirstChild("Game Console") then 
						firetouchinterest(lp.Character.HumanoidRootPart, m["Game Console"], 0)
						firetouchinterest(lp.Character.HumanoidRootPart, m["Game Console"], 1)
					end 
				end
			end
		end
	end) end
end)

CreateToggle("Auto Claim Ticket (Underground)", function(t)
	autoClaimTicketEnabled = t
	setUndergroundState(t) -- Pakai logic underground yang sama
	if t then task.spawn(function()
		while autoClaimTicketEnabled do task.wait(0.1)
			local f = workspace:FindFirstChild("ArcadeEventTickets")
			if f and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and undergroundFixedY then
				for _,m in pairs(f:GetChildren()) do
					if m.Name=="Ticket" and m:FindFirstChild("Ticket") then
						local tPos = m.Ticket.Position
						lp.Character.HumanoidRootPart.CFrame = CFrame.new(tPos.X, undergroundFixedY, tPos.Z)
						firetouchinterest(lp.Character.HumanoidRootPart, m.Ticket, 0)
						firetouchinterest(lp.Character.HumanoidRootPart, m.Ticket, 1)
					end
				end
			end
		end
		-- Clean up jika slide mode juga mati
		if not (slideModes.Divine or slideModes.Infinity or slideModes.Celestial) then
			setUndergroundState(false)
		end
	end) end
end)

CreateSection("VALENTINE")
CreateToggle("Auto Deposit (Smart)", function(t)
	autoDepositEnabled = t
	if t then task.spawn(function()
		while autoDepositEnabled do
			task.wait(0.5)
			-- Simple check for UI notification text
			local pGui = lp:FindFirstChild("PlayerGui")
			local found = false
			if pGui then for _,v in pairs(pGui:GetDescendants()) do if v:IsA("TextLabel") and v.Visible and string.find(v.Text, "submit your current candies") then found=true break end end end
			
			if found and not isDepositing then
				isDepositing = true
				local map = workspace:FindFirstChild("ValentinesMap")
				if map and map:FindFirstChild("CandyGramStation") and lp.Character then
					local hrp = lp.Character.HumanoidRootPart
					local oldPos = hrp.CFrame
					local main = map.CandyGramStation.Main
					hrp.CFrame = main.CFrame * CFrame.new(0,4,0)
					task.wait(0.5)
					local prompt = main.Prompts.ProximityPrompt
					fireproximityprompt(prompt)
					task.wait(1.5)
					hrp.CFrame = oldPos
				end
				isDepositing = false
				task.wait(2)
			end
		end
	end) end
end)

CreateSection("MISC")
CreateToggle("Fast Interact", function(t)
	if t then 
		ProximityPromptService.PromptAdded:Connect(function(p) p.HoldDuration=0 end)
		for _,p in pairs(workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration=0 end end
	end
end)

print("✅ DJ Hub Updated: Slide Menu Fixed + Combo Logic")
