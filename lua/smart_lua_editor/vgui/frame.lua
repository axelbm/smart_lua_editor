local PANEL = {}

-- vgui/smart_lua_editor/close.png
-- vgui/smart_lua_editor/maximise.png
-- vgui/smart_lua_editor/unmaximise.png
-- vgui/smart_lua_editor/minimise.png
-- vgui/smart_lua_editor/resizer.png

function PANEL:Init()
	-- self:SetTitle("")
	self:SetVisible(true)
	self:SetDraggable(true)
	self:SetSizable(true)
	self:MakePopup(true)
	self:ShowCloseButton(false)
	self:DockPadding(0, 0, 0, 0)

	-- Title Bar
	self.TitleBar = SmartLuaEditor.CreateGUI("DPanel", self, "TitleBar")
	self.TitleBar:Dock(TOP)
	self.TitleBar:DockPadding(0, 0, 0, 0)
	self.TitleBar:SetTall(26)
	self.TitleBar.LastPress = CurTime()

	self.TitleBar.OnMousePressed = function(titlebar)
		if CurTime() - titlebar.LastPress < 0.25 then
			self:Maximise(not self.IsMaximised)
		end
		titlebar.LastPress = CurTime()

		if self.IsMaximised then return end
		self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}
		self:MouseCapture(true)
	end

	-- Close Button
	self.CloseButton = SmartLuaEditor.CreateGUI("DButton", self.TitleBar, "TitleButton")
	self.CloseButton:Dock(RIGHT)
	self.CloseButton:DockMargin(0, 1, 1, 1)
	self.CloseButton:SetWide(24)
	self.CloseButton:SetText("")
	self.CloseButton.Icon = Material("vgui/smart_lua_editor/close.png")
	self.CloseButton.DoClick = function(bun)
		self:Close()
	end

	-- Maximise Button
	self.MaximiseButton = SmartLuaEditor.CreateGUI("DButton", self.TitleBar, "TitleButton")
	self.MaximiseButton:Dock(RIGHT)
	self.MaximiseButton:DockMargin(0, 1, 1, 1)
	self.MaximiseButton:SetWide(24)
	self.MaximiseButton:SetText("")
	self.MaximiseButton.Icon = Material("vgui/smart_lua_editor/maximise.png")
	self.MaximiseButton.DoClick = function(but)
		self:Maximise(not self.IsMaximised)
	end

	-- Minimise Button
	self.MinimiseButton = SmartLuaEditor.CreateGUI("DButton", self.TitleBar, "TitleButton")
	self.MinimiseButton:Dock(RIGHT)
	self.MinimiseButton:DockMargin(0, 1, 1, 1)
	self.MinimiseButton:SetWide(24)
	self.MinimiseButton:SetText("")
	self.MinimiseButton.Icon = Material("vgui/smart_lua_editor/minimise.png")

	-- Title Label
	self.TitleLabel = SmartLuaEditor.CreateGUI("DLabel", self.TitleBar, "Title")
	print(self.TitleLabel)
	self.TitleLabel:Dock(FILL)
	self.TitleLabel:DockMargin(5, 0, 0, 0)
	self.TitleLabel:SetText("Smart Lua Editor")


	-- Statu
	self.Statu = SmartLuaEditor.CreateGUI("DPanel", self, "Statu")
	self.Statu:Dock(BOTTOM)
	self.Statu:SetTall(26)

	-- Resize Button
	self.ResizeButton = SmartLuaEditor.CreateGUI("DButton", self.Statu, "ResizeButton")
	self.ResizeButton:Dock(RIGHT)
	self.ResizeButton:SetWide(26)

	self.ResizeButton.OnMousePressed = function(but)
		if self.IsMaximised then return end
		self.Sizing = {gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall()}
		self:MouseCapture(true)
	end

	self:SetTitle()
end

function PANEL:Maximise(enable)
	if enable then
		self.IsMaximised = true
		self.UnmaximisedPos = {self:GetPos()}
		self.UnmaximisedSize = {self:GetSize()}

		self:SetPos(0, 0)
		self:SetSize(ScrW(), ScrH())

		self:SetDraggable(false)
		self:SetSizable(false)

		self.MaximiseButton.Icon = Material("vgui/smart_lua_editor/minimise.png")
		self.ResizeButton:SetVisible(false)
	else
		self.IsMaximised = false

		self:SetPos(unpack(self.UnmaximisedPos))
		self:SetSize(unpack(self.UnmaximisedSize))

		self:SetDraggable(true)
		self:SetSizable(true)

		self.MaximiseButton.Icon = Material("vgui/smart_lua_editor/maximise.png")
		self.ResizeButton:SetVisible(true)
	end
end

function PANEL:SetTitle(title, addprefix)
	self.Title = title

	if addprefix == false then
		self.TitleLabel:SetText(title)
	else
		self.TitleLabel:SetText(isstring(title) and "SmartLuaEditor - " .. title or "SmartLuaEditor")
	end
end

function PANEL:GetTitle()
	return self.Title
end

function PANEL:Close()
	print(self.OnClose)
	if not self.OnClose or self:OnClose() ~= false then
		self:Remove()
	end
end

SmartLuaEditor.RegisterGUI("Frame", PANEL, "DFrame")
