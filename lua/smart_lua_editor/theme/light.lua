SmartLuaEditor.RegisterTheme("Light", {
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
})
