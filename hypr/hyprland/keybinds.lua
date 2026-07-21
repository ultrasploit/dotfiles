-- Application Keybinds
hl.bind(SUPER .. " + T", hl.dsp.exec_cmd(TERMINAL))
hl.bind(SUPER .. " + E", hl.dsp.exec_cmd(FILE_MANAGER))
hl.bind(SUPER .. " + W", hl.dsp.exec_cmd(BORWSER))
hl.bind(SUPER .. " + R", hl.dsp.exec_cmd(MENU))

-- Special App binds
hl.bind("F12", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))

-- Utils
hl.bind(SUPER .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Window Keybinds
hl.bind(SUPER .. " + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind(SUPER .. " + Q", hl.dsp.window.close())
hl.bind(SUPER .. " + P", hl.dsp.window.pseudo())
hl.bind(SUPER .. " + O", hl.dsp.layout("togglesplit"))
hl.bind(SUPER .. " + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind(SUPER .. " + bracketleft", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(SUPER .. " + bracketright", hl.dsp.layout("splitratio +0.1"), { repeating = true })

hl.bind(SUPER .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(SUPER .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Movement binds
hl.bind(SUPER .. " + l", hl.dsp.focus({ direction = "left" }))
hl.bind(SUPER .. " + h", hl.dsp.focus({ direction = "right" }))
hl.bind(SUPER .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(SUPER .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(SUPER .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(SUPER .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(SUPER .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(SUPER .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- My UI
hl.bind(SUPER .. " + SUPER_L", hl.dsp.exec_cmd("qs ipc call shell toggleLauncher"))
hl.bind(SUPER .. " + A", hl.dsp.exec_cmd("qs ipc call shell toggleLauncher"))
hl.bind(SUPER .. " + B", hl.dsp.exec_cmd("qs ipc call shell toggleBar"))
hl.bind(SUPER .. " + I", hl.dsp.exec_cmd("qs -p /home/ultra/.config/quickshell/settings.qml"))

-- Workspace Keybinds
for i = 1, 10 do
	local key = i % 10
	hl.bind(SUPER .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(SUPER .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(SUPER .. " + S", hl.dsp.workspace.toggle_special("spw1"))

hl.bind(SUPER .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:spw1" }))
hl.bind(SUPER .. " + ALT + S", hl.dsp.window.move({ workspace = "special:spw2" }))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(
	SUPER .. " + SHIFT + DELETE",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
