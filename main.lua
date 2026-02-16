--// Dj Hub (Ultimate Version - UI FIXED + Slide Combo)
--// Features: Realtime Follow + Smart Auto Equip + Arcade ESP + Reduce Lag + Valentine Auto Collect & Deposit
--// Fix: Menu Dropdown sekarang menggunakan Visibility Toggle (Pasti Muncul)

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
--// GUI SETUP
--=============================================================================

local colors = {
	background = Color3.fromRGB(15, 15, 15),
	accent = Color3.fromRGB(255, 120, 30),
	text = Color3.fromRGB(240, 240, 240),
	subText = Color3.fromRGB(150, 150, 150),
	toggleOn = Color3.fromRGB(255, 120, 30),
	toggleOff = Color3.fromRGB(60, 60, 60)
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

-- Draggable Function
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
			dragging = true; dragStart = input.Position; startPos = frame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	handle.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 500)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -200)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BackgroundTransparency = 0.35
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 40); Header.Position = UDim2.new(0, 20, 0, 0); Header.BackgroundTransparency = 1; Header.Parent = MainFrame
local Title = Instance.new("TextLabel"); Title.Text = "Dj Hub <font color=\"rgb(255,120,30)\">Premium</font>"; Title.RichText = true; Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextColor3 = colors.text; Title.Size = UDim2.new(1, -80, 1, 0); Title.BackgroundTransparency = 1; Title.Parent = Header
local CloseBtn = Instance.new("TextButton"); CloseBtn.Text = "×"; CloseBtn.Font = Enum.Font.GothamMedium; CloseBtn.TextSize = 24; CloseBtn.TextColor3 = colors.text; CloseBtn.BackgroundTransparency = 1; CloseBtn.Size = UDim2.new(0, 30, 1, 0); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.Parent = Header

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 1, -50); Container.Position = UDim2.new(0, 14, 0, 45); Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0; Container.ScrollBarThickness = 2; Container.ScrollBarImageColor3 = colors.accent; Container.AutomaticCanvasSize = Enum.AutomaticSize.Y; Container.Parent = MainFrame
local UIList = Instance.new("UIListLayout"); UIList.Parent = Container; UIList.Padding = UDim.new(0, 6); UIList.SortOrder = Enum.SortOrder.LayoutOrder

makeDraggable(MainFrame, Header)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- UI Helper Functions
local function CreateToggle(text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Text = text; Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 13; Label.TextColor3 = colors.text; Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.BackgroundTransparency = 1; Label.Parent = ToggleFrame
	
	local SwitchBg = Instance.new("Frame"); SwitchBg.Size = UDim2.new(0, 44, 0, 22); SwitchBg.Position = UDim2.new(1, -54, 0.5, -11); SwitchBg.BackgroundColor3 = colors.toggleOff; SwitchBg.Parent = ToggleFrame; Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
	local Circle = Instance.new("Frame"); Circle.Size = UDim2.new(0, 18, 0, 18); Circle.Position = UDim2.new(0, 2, 0.5, -9); Circle.BackgroundColor3 = Color3.fromRGB(255,255,255); Circle.Parent = SwitchBg; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
	local Trigger = Instance.new("TextButton"); Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.BackgroundTransparency = 1; Trigger.Text = ""; Trigger.Parent = ToggleFrame
	
	local toggled = false
	Trigger.MouseButton1Click:Connect(function()
		toggled = not toggled
		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = toggled and colors.toggleOn or colors.toggleOff}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
		pcall(callback, toggled)
	end)
	return ToggleFrame -- Return frame agar bisa di-hide/show
end

local function CreateButton(text, callback)
	local BtnFrame = Instance.new("Frame"); BtnFrame.Size = UDim2.new(1, 0, 0, 36); BtnFrame.BackgroundTransparency = 1; BtnFrame.Parent = Container
	local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1, -10, 1, 0); Btn.Position = UDim2.new(0, 5, 0, 0); Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Btn.Text = text; Btn.TextColor3 = colors.text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13; Btn.Parent = BtnFrame; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	Btn.MouseButton1Click:Connect(function() pcall(callback) end)
	return Btn
end

local function CreateSection(text)
	local Sec = Instance.new("TextLabel"); Sec.Text = text; Sec.Size = UDim2.new(1, 0, 0, 25); Sec.BackgroundTransparency = 1; Sec.TextColor3 = colors.subText; Sec.Font = Enum.Font.GothamBold; Sec.TextSize = 12; Sec.TextXAlignment = Enum.TextXAlignment.Left; Sec.Position = UDim2.new(0, 10, 0, 0); Instance.new("UIPadding", Sec).PaddingLeft = UDim.new(0,10); Sec.Parent = Container
end

--=============================================================================
--// VARIABLES & LOGIC
--=============================================================================

local slideModes = { Divine = false, Infinity = false, Celestial = false }
local masterSlideRunning = false
local undergroundPlatform = nil
local undergroundFixedY = nil
local undergroundConnection = nil

-- Logic Platform Underground (Anti-Double Dip)
local function setUndergroundState(isActive)
	if isActive then
		if not undergroundPlatform then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				-- Tentukan ketinggian AMAN (-12 studs dari posisi sekarang atau spawn)
				undergroundFixedY = hrp.Position.Y - 12
				
				-- Turunkan player sekali saja
				hrp.CFrame = CFrame.new(hrp.Position.X, undergroundFixedY, hrp.Position.Z)
				
				undergroundPlatform = Instance.new("Part", workspace)
				undergroundPlatform.Name = "DjUndergroundPlatform"
				undergroundPlatform.Size = Vector3.new(15, 1, 15)
				undergroundPlatform.Anchored = true
				undergroundPlatform.Transparency = 0.5
				undergroundPlatform.Material = Enum.Material.Neon
				undergroundPlatform.Color = Color3.fromRGB(255, 0, 0)
				
				undergroundConnection = RunService.Heartbeat:Connect(function()
					if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and undergroundFixedY then
						-- Platform mengikuti X/Z player, tapi Y tetap dikunci di undergroundFixedY
						local pos = lp.Character.HumanoidRootPart.Position
						undergroundPlatform.CFrame = CFrame.new(pos.X, undergroundFixedY - 3.5, pos.Z)
					end
				end)
			end
		end
	else
		-- Matikan HANYA jika semua mode slide mati
		if not (slideModes.Divine or slideModes.Infinity or slideModes.Celestial) then
			undergroundFixedY = nil
			if undergroundConnection then undergroundConnection:Disconnect(); undergroundConnection = nil end
			if undergroundPlatform then undergroundPlatform:Destroy(); undergroundPlatform = nil end
		end
	end
end

-- Fungsi Slide Halus
local function slideToPosition(targetPos)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not undergroundFixedY then return end
	
	local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
	local speed = 250 -- Kecepatan Slide
	local time = dist / speed
	
	-- Slide Horizontal (Y tetap di undergroundFixedY)
	local targetCFrame = CFrame.new(targetPos.X, undergroundFixedY, targetPos.Z)
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
	hrp.AssemblyLinearVelocity = Vector3.zero
end

-- Master Loop Slide
local function updateMasterSlideLogic()
	if masterSlideRunning then return end
	masterSlideRunning = true
	
	task.spawn(function()
		while slideModes.Divine or slideModes.Infinity or slideModes.Celestial do
			setUndergroundState(true) -- Pastikan platform ada
			
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			local folder = workspace:FindFirstChild("ActiveLuckyBlocks")
			
			if hrp and folder and undergroundFixedY then
				local targetBlock = nil
				
				-- Priority Check
				for _, model in pairs(folder:GetChildren()) do
					if slideModes.Divine and string.find(model.Name, "Divine") then targetBlock = model; break
					elseif slideModes.Infinity and string.find(model.Name, "Infinity") then targetBlock = model; break
					elseif slideModes.Celestial and string.find(model.Name, "Celestial") then targetBlock = model; break
					end
				end
				
				if targetBlock and targetBlock:FindFirstChild("RootPart") then
					local root = targetBlock.RootPart
					
					-- 1. Slide ke Target
					slideToPosition(root.Position)
					task.wait(0.1)
					
					-- 2. Ambil
					local prompt = root:FindFirstChild("ProximityPrompt")
					if prompt then
						for i = 1, 10 do
							if not root.Parent or not prompt.Parent then break end
							fireproximityprompt(prompt)
							task.wait(0.05)
						end
					end
					
					-- 3. Balik ke Base (SpawnLocation1)
					local base = workspace:FindFirstChild("SpawnLocation1")
					if base then slideToPosition(base.Position) end
					
					task.wait(1)
				else
					task.wait(0.5)
				end
			else
				task.wait(1)
			end
		end
		masterSlideRunning = false
		setUndergroundState(false) -- Bersihkan platform saat semua mati
	end)
end

--=============================================================================
--// UI IMPLEMENTATION
--=============================================================================

CreateSection("PLAYER")
CreateToggle("Noclip", function(t) 
	if t then 
		RunService:BindToRenderStep("Noclip", 100, function() 
			if lp.Character then for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end 
		end)
	else RunService:UnbindFromRenderStep("Noclip") end
end)

--=============================================================================
--// FIXED LUCKY BLOCK MENU (DROPDOWN)
--=============================================================================

CreateSection("LUCKY BLOCK MENU")

local dropdownItems = {} -- Menyimpan frame yang akan di-hide/show
local isDropdownOpen = false

-- 1. Buat Tombol Menu Utama
local menuBtn = CreateButton("LUCKY BLOCK (SLIDE MODE) ▼", function()
	isDropdownOpen = not isDropdownOpen
	
	-- Ubah Text Tombol
	if isDropdownOpen then
		-- Update text manual karena TextButton ada di dalam Frame yang direturn CreateButton
		-- Tapi di fungsi CreateButton di atas, saya return Btn object.
	end
	
	-- Toggle Visibility item-item di bawahnya
	for _, frame in pairs(dropdownItems) do
		frame.Visible = isDropdownOpen
	end
end)

-- 2. Helper untuk membuat Toggle yang Tersembunyi
local function CreateHiddenSlideToggle(text, key)
	local frame = CreateToggle(text, function(t)
		slideModes[key] = t
		if t then updateMasterSlideLogic() end
	end)
	
	-- Indentasi Visual (Biar terlihat seperti anak menu)
	local pad = Instance.new("UIPadding", frame)
	pad.PaddingLeft = UDim.new(0, 20)
	
	-- Sembunyikan secara default
	frame.Visible = false
	
	-- Masukkan ke tabel dropdownItems
	table.insert(dropdownItems, frame)
end

-- 3. Isi Menu (Ini yang akan muncul/hilang saat tombol ditekan)
CreateHiddenSlideToggle("- Auto Divine (Slide)", "Divine")
CreateHiddenSlideToggle("- Auto Infinity (Slide)", "Infinity")
CreateHiddenSlideToggle("- Auto Celestial (Slide)", "Celestial")

-- Update Text Tombol saat diklik
menuBtn.MouseButton1Click:Connect(function()
	if isDropdownOpen then
		menuBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▲"
	else
		menuBtn.Text = "LUCKY BLOCK (SLIDE MODE) ▼"
	end
end)


--=============================================================================
--// OTHER FEATURES (STANDAR)
--=============================================================================

CreateSection("OPTIMIZATION")
CreateButton("Reduce Lag", function()
	local t = {"ActiveBrainrots","ActiveLuckyBlocks","Misc","Bases"} 
	for _,n in pairs(t) do pcall(function() workspace[n]:Destroy() end) end
	Lighting.GlobalShadows=false
end)

CreateSection("VALENTINE")
CreateToggle("Auto Deposit (Smart)", function(t)
	if t then task.spawn(function()
		while t do task.wait(1)
			-- Logic deposit sederhana
			local pGui = lp:FindFirstChild("PlayerGui")
			local found = false
			if pGui then for _,v in pairs(pGui:GetDescendants()) do if v:IsA("TextLabel") and v.Visible and string.find(v.Text, "submit your current candies") then found=true break end end end
			
			if found then
				local map = workspace:FindFirstChild("ValentinesMap")
				if map and map:FindFirstChild("CandyGramStation") and lp.Character then
					local hrp = lp.Character.HumanoidRootPart
					local oldPos = hrp.CFrame
					hrp.CFrame = map.CandyGramStation.Main.CFrame * CFrame.new(0,4,0)
					task.wait(0.5)
					fireproximityprompt(map.CandyGramStation.Main.Prompts.ProximityPrompt)
					task.wait(1)
					hrp.CFrame = oldPos
				end
				task.wait(3)
			end
		end
	end) end
end)

print("✅ DJ Hub: Dropdown & Combo Fixed")
