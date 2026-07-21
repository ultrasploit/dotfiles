hl.on("hyprland.start", function()
	hl.exec_cmd("qs -p /home/ultra/.config/quickshell/")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

	-- hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	-- hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
end)
