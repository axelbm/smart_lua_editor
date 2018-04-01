local FastEditor = {}
SmartLuaEditor.FastEditor = FastEditor

FastEditor.MetaTable = {
	__index = function(tab, key)
		return FastEditor[key]
	end
}

local icon_close = Material("vgui/smart_lua_editor/close.png")
local icon_maximise = Material("vgui/smart_lua_editor/maximise.png")
local icon_unmaximise = Material("vgui/smart_lua_editor/unmaximise.png")
local icon_minimise = Material("vgui/smart_lua_editor/minimise.png")
local icon_resizer = Material("vgui/smart_lua_editor/resizer.png")
local icon_import = Material("vgui/smart_lua_editor/import.png")
local icon_export = Material("vgui/smart_lua_editor/export.png")
local icon_info = Material("vgui/smart_lua_editor/info.png")

surface.CreateFont("SmartLuaEditor.Title", {
	font = "Arial",
	size = 16,
	weight = 1000
})

surface.CreateFont("SmartLuaEditor.Statu", {
	font = "Arial",
	size = 14,
	weight = 100,
})

local Theme = {
	dark = {
		TitleBar = {Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(28, 28, 28))
		end},

		Title = {Init = function(self)
			self:SetColor(Color(240, 240, 240))
			self:SetFont("SmartLuaEditor.Title")
		end},

		Frame = {Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(32, 32, 32))
		end},

		CloseButton = {
			Init = function(self)
			self:SetFont("SmartLuaEditor.Title")
			end,
			Paint = function(self, w, h)
				local color = Color(234, 234, 234, 255)

				if self.Depressed or self:IsSelected() or self:GetToggle() then
					color = Color(224, 47, 30, 200)
				elseif self.Hovered then
					color = Color(255, 255, 255, 255)
				end

				surface.SetDrawColor(color)
				surface.DrawRect(0, 0, w, h)
			end
		},

		ResizeButton = {Paint = function(self, w, h)
			surface.SetDrawColor(80, 80, 80, 255)
			surface.SetMaterial(icon_resizer)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end},

		Statu = {Paint = function(self, w, h)

		end},

		CursorPosLabel = {Init = function(self)
			self:SetColor(Color(240, 240, 240))
			self:SetFont("SmartLuaEditor.Statu")
		end},

		Menu = {Paint = function(self, w, h)

		end},

		MenuButton = {Paint = function(self, w, h)
			local size = 16
			local color = Color(38, 38, 38, 0)

			if self.Depressed or self:IsSelected() or self:GetToggle() then
				color = Color(38, 174, 255, 150)
				size = 12
			elseif self.Hovered then
				color = Color(40, 40, 40, 255)
			end
			draw.RoundedBox(4, 0, 0, w, h, color)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.Icon)
			surface.DrawTexturedRect((w-size)/2, (h-size)/2, size, size)
		end},
	},
	light = {
		TitleBar = {Paint = function(self, w, h)
			-- draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240))
		end},

		Title = {Init = function(self)
			self:SetColor(Color(100, 100, 100))
			self:SetFont("SmartLuaEditor.Title")
		end},

		Frame = {Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240))
		end},

		CloseButton = {
			Init = function(self)
			self:SetFont("SmartLuaEditor.Title")
			end,
			Paint = function(self, w, h)
				local color = Color(234, 234, 234, 255)

				if self.Depressed or self:IsSelected() or self:GetToggle() then
					color = Color(224, 47, 30, 200)
				elseif self.Hovered then
					color = Color(255, 255, 255, 255)
				end

				surface.SetDrawColor(color)
				surface.DrawRect(0, 0, w, h)
			end
		},

		ResizeButton = {Paint = function(self, w, h)
			surface.SetDrawColor(150, 150, 150, 255)
			surface.SetMaterial(icon_resizer)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end},

		Statu = {Paint = function(self, w, h)

		end},

		CursorPosLabel = {Init = function(self)
			self:SetColor(Color(240, 240, 240))
			self:SetFont("SmartLuaEditor.Statu")
		end},

		Menu = {Paint = function(self, w, h)

		end},

		MenuButton = {Paint = function(self, w, h)
			local size = 16
			local color = Color(38, 38, 38, 0)

			if self.Depressed or self:IsSelected() or self:GetToggle() then
				color = Color(38, 174, 255, 200)
				size = 12
			elseif self.Hovered then
				color = Color(220, 220, 220, 255)
			end
			draw.RoundedBox(4, 0, 0, w, h, color)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.Icon)
			surface.DrawTexturedRect((w-size)/2, (h-size)/2, size, size)
		end}
	}
}

function FastEditor.New(title)
	local editor = setmetatable({}, FastEditor.MetaTable)

	editor.pnls = {}
	editor.Theme = "dark"

	editor:Build()

	editor:SetTitle(title)

	return editor
end

function FastEditor:Build()
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(600, 400)
	pnl:SetTitle("")
	pnl:SetVisible(true)
	pnl:SetDraggable(true)
	pnl:SetSizable(true)
	pnl:MakePopup(true)
	pnl:ShowCloseButton(false)
	pnl:DockPadding(0, 0, 0, 0)
	self:SetSkin(pnl, "Frame")

	self.Panel = pnl

	-- Title Bar
	local titleBar = vgui.Create("DPanel", pnl)
	titleBar:Dock(TOP)
	titleBar:DockPadding(0, 0, 0, 0)
	titleBar:SetTall(26)
	titleBar.LastPress = CurTime()
	self:SetSkin(titleBar, "TitleBar")

	titleBar.OnMousePressed = function()
		if CurTime() - titleBar.LastPress < 0.25 then
			self:Maximise(not self.IsMaximised)
		end
		titleBar.LastPress = CurTime()

		if self.IsMaximised then return end
		pnl.Dragging = {gui.MouseX() - pnl.x, gui.MouseY() - pnl.y}
		pnl:MouseCapture(true)
	end
	titleBar.OnMouseReleased = function()
		pnl.Dragging = nil
		pnl:MouseCapture(false)
	end

	-- Close Button
	local closeButton = vgui.Create("DButton", titleBar)
	closeButton:Dock(RIGHT)
	closeButton:DockMargin(0, 1, 1, 1)
	closeButton:SetWide(24)
	closeButton:SetText("")
	closeButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(icon_close)
		surface.DrawTexturedRect(0, 0, 32, 32)
	end
	closeButton.DoClick = function(bun)
		self:Close()
	end

	-- Maximise Button
	local maximiseButton = vgui.Create("DButton", titleBar)
	maximiseButton:Dock(RIGHT)
	maximiseButton:DockMargin(0, 1, 1, 1)
	maximiseButton:SetWide(24)
	maximiseButton:SetText("")
	maximiseButton.Icon = icon_maximise
	maximiseButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(self.IsMaximised and icon_unmaximise or icon_maximise)
		surface.DrawTexturedRect(0, 0, 32, 32)
	end
	maximiseButton.DoClick = function(but)
		self:Maximise(not self.IsMaximised)
	end

	pnl.MaximiseButton = maximiseButton

	-- Minimise Button
	local minimiseButton = vgui.Create("DButton", titleBar)
	minimiseButton:Dock(RIGHT)
	minimiseButton:DockMargin(0, 1, 1, 1)
	minimiseButton:SetWide(24)
	minimiseButton:SetText("")
	minimiseButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(icon_minimise)
		surface.DrawTexturedRect(0, 0, 32, 32)
	end

	-- Title Label
	local titleLabel = vgui.Create("DLabel", titleBar)
	titleLabel:Dock(FILL)
	titleLabel:DockMargin(5, 0, 0, 0)
	titleLabel:SetText("Smart Lua Editor")
	self:SetSkin(titleLabel, "Title")
	pnl.Title = titleLabel

	-- Menu
	local menu = vgui.Create("DPanel", pnl)
	menu:Dock(TOP)
	menu:DockPadding(3, 3, 3, 3)
	menu:SetTall(26)
	self:SetSkin(menu, "Menu")

	pnl.Menu = menu

	-- Info Button
	local infoButton = vgui.Create("DButton", menu)
	infoButton:Dock(LEFT)
	infoButton:DockMargin(1, 1, 0, 1)
	infoButton:SetWide(24)
	infoButton:SetText("")
	infoButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(icon_info)
		surface.DrawTexturedRect(-4, -4, 32, 32)
	end

	-- Import Button
	local importButton = vgui.Create("DButton", menu)
	importButton:Dock(LEFT)
	importButton:DockMargin(5, 1, 0, 1)
	importButton:SetWide(24)
	importButton:SetText("")
	importButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(icon_import)
		surface.DrawTexturedRect(-4, -4, 32, 32)
	end

	-- Export Button
	local exportButton = vgui.Create("DButton", menu)
	exportButton:Dock(LEFT)
	exportButton:DockMargin(1, 1, 0, 1)
	exportButton:SetWide(24)
	exportButton:SetText("")
	exportButton.Paint = function(but, w, h)
		surface.SetDrawColor(200, 200, 200, 255)
		surface.SetMaterial(icon_export)
		surface.DrawTexturedRect(-4, -4, 32, 32)
	end

	-- Statu
	local statu = vgui.Create("DPanel", pnl)
	statu:Dock(BOTTOM)
	statu:SetTall(26)
	self:SetSkin(statu, "Statu")

	pnl.Statu = statu

	-- Resize Button
	local resizeButton = vgui.Create("DButton", statu)
	resizeButton:Dock(RIGHT)
	resizeButton:SetWide(26)
	resizeButton:SetText("")
	resizeButton:SetCursor("sizenwse")
	self:SetSkin(resizeButton, "ResizeButton")

	resizeButton.OnMousePressed = function(but)
		if self.IsMaximised then return end
		pnl.Sizing = {gui.MouseX() - pnl:GetWide(), gui.MouseY() - pnl:GetTall()}
		pnl:MouseCapture(true)
	end
	resizeButton.OnMouseReleased = function(but)
		pnl.Sizing = nil
		pnl:MouseCapture(false)

	end

	pnl.ResizeButton = resizeButton

	-- Theme Label
	local cursorPos = vgui.Create("DLabel", statu)
	cursorPos:Dock(LEFT)
	cursorPos:DockMargin(16, 0, 0, 0)
	cursorPos:SetWide(50)
	cursorPos:SetText("monokai")
	self:SetSkin(cursorPos, "CursorPosLabel")

	-- Cursor Pos Label
	local cursorPos = vgui.Create("DLabel", statu)
	cursorPos:Dock(LEFT)
	cursorPos:DockMargin(6, 0, 0, 0)
	cursorPos:SetWide(100)
	self:SetSkin(cursorPos, "CursorPosLabel")
	function cursorPos:Update(row, column)
		self:SetText(string.format("%d:%d", row, column))
	end
	cursorPos:Update(0, 0)


	local editor = vgui.CreateFromTable(SmartLuaEditor.AcePanel, pnl)
	editor:Dock(FILL)
	editor:DockMargin(1, 0, 1, 0)

	editor.OnCursorChanged = function(editor, row, column)
		cursorPos:Update(row + 1, column + 1)
	end

	self.Editor = editor
end

function FastEditor:SetTitle(title)
	if isstring(title) then
		self.Panel.Title:SetText("Smart Lua Editor - " .. title)
	else
		self.Panel.Title:SetText("Smart Lua Editor")
	end
end

function FastEditor:Maximise(max)
	if max then
		self.IsMaximised = true
		self.UnmaximisedPos = {self.Panel:GetPos()}
		self.UnmaximisedSize = {self.Panel:GetSize()}

		self.Panel:SetPos(0, 0)
		self.Panel:SetSize(ScrW(), ScrH())

		self.Panel:SetDraggable(false)
		self.Panel:SetSizable(false)

		self.Panel.ResizeButton:SetVisible(false)
	else
		self.IsMaximised = false

		self.Panel:SetPos(unpack(self.UnmaximisedPos))
		self.Panel:SetSize(unpack(self.UnmaximisedSize))

		self.Panel:SetDraggable(true)
		self.Panel:SetSizable(true)

		self.Panel.ResizeButton:SetVisible(true)
	end
end

function FastEditor:SetTheme(theme)
	self.Theme = theme

	for pnl, type in pairs(self.pnls) do
		self:SetSkin(pnl, type)
	end
end

function FastEditor:SetSkin(pnl, type)
	if not Theme[self.Theme] or not Theme[self.Theme][type] then return end
	local theme = Theme[self.Theme][type]

	self.pnls[pnl] = type

	pnl.Paint = theme.Paint

	if theme.Init then
		theme.Init(pnl)
	end
end

function FastEditor:Close()
	self.Panel:Remove()
end

function FastEditor:GetValue()
	return self.Editor:GetValue()
end

function FastEditor:SetValue(value)
	self.Editor:SetValue(value)
end

function FastEditor:AddButton(icon, tooltip, callback)
	local button = vgui.Create("DButton", self.Panel.Menu)
	button:Dock(LEFT)
	button:DockMargin(0, 0, 3, 0)
	button.Icon = Material("icon16/" .. icon .. ".png")
	button:SetWide(20)
	button:SetText("")
	button:SetTooltip(tooltip)
	self:SetSkin(button, "MenuButton")

	button.DoClick = function(but)
		callback(self)
	end
end

function FastEditor:SetRun(callback)
	if not isfunction(callback) then
		callback = function()
			local old_editor = editor
			editor = self
			RunString(self:GetValue(), "SmartLuaEditor", true)
			editor = old_this
		end
	end

	self:AddButton("resultset_next", "Run", callback)
end

function FastEditor:SetSave(callback)
	self:AddButton("disk", "Save", callback)
end

local editor = FastEditor.New("Test")
editor:SetRun()
editor:SetSave(function(self)
	self:SetValue("coucouc les pds")
end)
