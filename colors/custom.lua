-- 基于 catppucchin mocha 稍作修改的配色方案
-- stylua: ignore
local mocha = {
   rosewater = '#f5e0dc',  -- 玫瑰水色
   flamingo  = '#f2cdcd',  -- 火烈鸟色
   pink      = '#f5c2e7',  -- 粉色
   mauve     = '#cba6f7',  -- 淡紫色
   red       = '#f38ba8',  -- 红色
   maroon    = '#eba0ac',  -- 褐红色
   peach     = '#fab387',  -- 桃色
   yellow    = '#f9e2af',  -- 黄色
   green     = '#a6e3a1',  -- 绿色
   teal      = '#94e2d5',  -- 蓝绿色
   sky       = '#89dceb',  -- 天空色
   sapphire  = '#74c7ec',  -- 蓝宝石色
   blue      = '#89b4fa',  -- 蓝色
   lavender  = '#b4befe',  -- 薰衣草色
   text      = '#cdd6f4',  -- 主文本色
   subtext1  = '#bac2de',  -- 次要文本色1
   subtext0  = '#a6adc8',  -- 次要文本色0
   overlay2  = '#9399b2',  -- 覆盖层2
   overlay1  = '#7f849c',  -- 覆盖层1
   overlay0  = '#6c7086',  -- 覆盖层0
   surface2  = '#585b70',  -- 表面色2
   surface1  = '#45475a',  -- 表面色1
   surface0  = '#313244',  -- 表面色0
   base      = '#1f1f28',  -- 基础背景色
   mantle    = '#181825',  -- 罩层色
   crust     = '#11111b',  -- 外壳色
}

local colorscheme = {
   foreground = mocha.text,  -- 前景色（主文本色）
   background = mocha.base,  -- 背景色
   cursor_bg = mocha.rosewater,  -- 光标背景色
   cursor_border = mocha.rosewater,  -- 光标边框色
   cursor_fg = mocha.crust,  -- 光标前景色
   selection_bg = mocha.surface2,  -- 选中区域背景色
   selection_fg = mocha.text,  -- 选中区域文本色
   ansi = {
      '#0C0C0C', -- 黑色
      '#C50F1F', -- 红色
      '#13A10E', -- 绿色
      '#C19C00', -- 黄色
      '#0037DA', -- 蓝色
      '#881798', -- 品红/紫色
      '#3A96DD', -- 青色
      '#CCCCCC', -- 白色
   },
   brights = {
      '#767676', -- 亮黑色
      '#E74856', -- 亮红色
      '#16C60C', -- 亮绿色
      '#F9F1A5', -- 亮黄色
      '#3B78FF', -- 亮蓝色
      '#B4009E', -- 亮品红/紫色
      '#61D6D6', -- 亮青色
      '#F2F2F2', -- 亮白色
   },
   tab_bar = {
      background = 'rgba(0, 0, 0, 0.4)',  -- 标签栏背景色（半透明黑色）
      active_tab = {
         bg_color = mocha.surface2,  -- 活动标签背景色
         fg_color = mocha.text,  -- 活动标签文本色
      },
      inactive_tab = {
         bg_color = mocha.surface0,  -- 非活动标签背景色
         fg_color = mocha.subtext1,  -- 非活动标签文本色
      },
      inactive_tab_hover = {
         bg_color = mocha.surface0,  -- 非活动标签悬停背景色
         fg_color = mocha.text,  -- 非活动标签悬停文本色
      },
      new_tab = {
         bg_color = mocha.base,  -- 新建标签背景色
         fg_color = mocha.text,  -- 新建标签文本色
      },
      new_tab_hover = {
         bg_color = mocha.mantle,  -- 新建标签悬停背景色
         fg_color = mocha.text,  -- 新建标签悬停文本色
         italic = true,  -- 新建标签悬停时使用斜体
      },
   },
   visual_bell = mocha.red,  -- 视觉提醒颜色
   indexed = {
      [16] = mocha.peach,  -- 索引颜色16
      [17] = mocha.rosewater,  -- 索引颜色17
   },
   scrollbar_thumb = mocha.surface2,  -- 滚动条滑块颜色
   split = mocha.overlay0,  -- 分割线颜色
   compose_cursor = mocha.flamingo,  -- 组合光标颜色
}

return colorscheme
