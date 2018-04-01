local PANEL = {}


function PANEL:Init()
	self:OpenURL("asset://garrysmod/html/smart_lua_editor/ace.html")

	self:AddFunction("SmartLuaEditor", "updateCursor", function(row, column)
		self:UpdateCursor(row, column)
	end)

	self:AddFunction("SmartLuaEditor", "updateDocument", function(value)
		self:UpdateValue(value)
	end)

	self.Value = ""
	self.Cursor = {0, 0}

	self:SetValue(self.Value)
end

function PANEL:UpdateCursor(row, column)
	self.Cursor = {row, column}

	if self.OnCursorChanged then
		self:OnCursorChanged(row, column)
	end
end

function PANEL:SetCursor(row, column)
	self:QueueJavascript(string.format("selection.selectTo(%d, %d)", row, column))
end

function PANEL:GetCursor()
	return unpack(self.Cursor)
end



function PANEL:SetValue(value)
	self:QueueJavascript("editor.setValue('".. string.Replace(value, "'", "\\'") .."', -1)")
	self:UpdateValue(value)
end

function PANEL:UpdateValue(value)
	self.Value = value

	if self.OnValueChanged then
		self:OnValueChanged(value)
	end
end

function PANEL:GetValue()
	return self.Value
end



SmartLuaEditor.AcePanel = vgui.RegisterTable(PANEL, "DHTML")
