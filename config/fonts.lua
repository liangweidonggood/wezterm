-- 导入 wezterm 配置模块
local wezterm = require('wezterm')
-- 导入平台检测工具
local platform = require('utils.platform')

-- 可选字体配置（已注释的备选字体）
-- local font_family = 'Maple Mono NF'
-- 主字体配置：使用 JetBrainsMono Nerd Font
local font_family = 'JetBrainsMono Nerd Font'
-- local font_family = 'CartographCF Nerd Font'

-- 字体大小：macOS 系统使用 12 号，其他系统使用 14 号
local font_size = platform.is_mac and 12 or 14

-- 返回字体配置表
return {
   -- 字体配置：设置字体家族和字重
   font = wezterm.font({
      family = font_family,
      weight = 'Medium',
   }),
   -- 字体大小
   font_size = font_size,

   -- FreeType 渲染配置参考：https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   -- FreeType 加载目标类型：Normal/Light/Mono/HorizontalLcd
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   -- FreeType 渲染目标类型：Normal/Light/Mono/HorizontalLcd
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
