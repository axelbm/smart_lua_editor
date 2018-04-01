SmartLuaEditor.RegisterTheme("Dark", {
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

	TitleButton = {
		Init = function(self)
			self:SetText("")
		end,
		Paint = function(self, w, h)
			surface.SetDrawColor(200, 200, 200, 255)
			surface.SetMaterial(self.Icon)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end
	},

	ResizeButton = {
		Init = function(self)
			self:SetText("")
			self:SetCursor("sizenwse")

			self.Icon = Material("vgui/smart_lua_editor/resizer.png")
		end,
		Paint = function(self, w, h)
			surface.SetDrawColor(80, 80, 80, 255)
			surface.SetMaterial(self.Icon)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end
	},

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
	end}
})
