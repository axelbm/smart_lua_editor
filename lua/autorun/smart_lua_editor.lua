SmartLuaEditor = {}
SmartLuaEditor.Panels = {}
SmartLuaEditor.Themes = {}
SmartLuaEditor.CreatedPanels = {}

if SERVER then
	AddCSLuaFile("smart_lua_editor/editor/ace.lua")

	AddCSLuaFile("smart_lua_editor/vgui/frame.lua")
	AddCSLuaFile("smart_lua_editor/vgui/menu.lua")

	AddCSLuaFile("smart_lua_editor/theme/dark.lua")
	AddCSLuaFile("smart_lua_editor/theme/light.lua")

	AddCSLuaFile("smart_lua_editor/fast_editor.lua")
	AddCSLuaFile("smart_lua_editor/file_browser.lua")


else
	function SmartLuaEditor.RegisterGUI(name, panel, base)
		SmartLuaEditor.Panels[name] = vgui.RegisterTable(panel, base)
	end

	function SmartLuaEditor.CreateGUI(class, parent, role)
		local pnl
		if SmartLuaEditor.Panels[class] then
			pnl = vgui.CreateFromTable(SmartLuaEditor.Panels[class], parent, role or class)
		else
			pnl = vgui.Create(class, parent, role or class)
		end

		pnl.Role = role or class

		table.insert(SmartLuaEditor.CreatedPanels, pnl)

		SmartLuaEditor.ApplyTheme(pnl)

		return pnl
	end

	function SmartLuaEditor.ApplyTheme(pnl)
		local theme = SmartLuaEditor.Themes[SmartLuaEditor.AppliedTheme]
		print(pnl.Role or pnl:GetClassName())
		local role = theme[pnl.Role or pnl:GetClassName()]
		if not role then return end

		pnl.Paint = role.Paint

		if role.Init then
			role.Init(pnl)
		end
	end

	function SmartLuaEditor.SetTheme(theme)
		SmartLuaEditor.AppliedTheme = theme

		for _, pnl in pairs(SmartLuaEditor.CreatedPanels) do
			SmartLuaEditor.ApplyTheme(pnl)
		end
	end

	function SmartLuaEditor.RegisterTheme(name, theme)
		SmartLuaEditor.Themes[name] = theme

		if not SmartLuaEditor.AppliedTheme then
			SmartLuaEditor.AppliedTheme = name
		end
	end

	include("smart_lua_editor/editor/ace.lua")

	include("smart_lua_editor/vgui/frame.lua")
	include("smart_lua_editor/vgui/menu.lua")

	include("smart_lua_editor/theme/dark.lua")
	include("smart_lua_editor/theme/light.lua")

	include("smart_lua_editor/fast_editor.lua")
	include("smart_lua_editor/file_browser.lua")
end
