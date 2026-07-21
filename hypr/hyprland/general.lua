hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 2,

		col = {
			active_border = "rgba(595959aa)",
			inactive_border = "#2D2C2B",
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 30,
		rounding_power = 2,

		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 2,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		background_color = "#000000",
	},
})
