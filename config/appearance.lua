-- 导入依赖模块
local gpu_adapters = require('utils.gpu-adapter')
local backdrops = require('utils.backdrops')
local colors = require('colors.custom')

-- 外观配置返回表
return {
   max_fps = 120,  -- 最大帧率
   front_end = 'WebGpu', ---@type 'WebGpu' | 'OpenGL' | 'Software'  -- 前端渲染引擎
   webgpu_power_preference = 'HighPerformance',  -- WebGPU电源偏好设置
   webgpu_preferred_adapter = gpu_adapters:pick_best(),  -- 自动选择最佳GPU适配器
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),  -- 手动选择集成GPU
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),  -- 手动选择其他GPU
   underline_thickness = '1.5pt',  -- 下划线厚度

   -- 光标配置
   animation_fps = 120,  -- 动画帧率
   cursor_blink_ease_in = 'EaseOut',  -- 光标闪烁淡入效果
   cursor_blink_ease_out = 'EaseOut',  -- 光标闪烁淡出效果
   default_cursor_style = 'BlinkingBlock',  -- 默认光标样式为闪烁方块
   cursor_blink_rate = 650,  -- 光标闪烁频率（毫秒）

   -- 颜色方案配置
   colors = colors,  -- 使用自定义颜色方案

   -- 背景配置
   -- 传入 `true` 可让wezterm启动时进入专注模式（无背景图片）
   background = backdrops:initial_options(false),

   -- 滚动条配置
   enable_scroll_bar = true,  -- 启用滚动条

   -- 标签栏配置
   enable_tab_bar = true,  -- 启用标签栏
   hide_tab_bar_if_only_one_tab = false,  -- 即使只有一个标签也不隐藏标签栏
   use_fancy_tab_bar = false,  -- 不使用花哨的标签栏样式
   tab_max_width = 25,  -- 标签最大宽度
   show_tab_index_in_tab_bar = false,  -- 标签栏不显示标签索引
   switch_to_last_active_tab_when_closing_tab = true,  -- 关闭标签时切换到最后一个活动标签

   -- 命令面板配置
   command_palette_fg_color = '#b4befe',  -- 命令面板前景色
   command_palette_bg_color = '#11111b',  -- 命令面板背景色
   command_palette_font_size = 12,  -- 命令面板字体大小
   command_palette_rows = 25,  -- 命令面板显示行数

   -- 窗口配置
   window_padding = {  -- 窗口内边距
      left = 0,
      right = 0,
      top = 10,
      bottom = 7.5,
   },
   adjust_window_size_when_changing_font_size = false,  -- 改变字体大小时不调整窗口大小
   window_close_confirmation = 'NeverPrompt',  -- 关闭窗口时从不提示
   window_frame = {  -- 窗口框架配置
      active_titlebar_bg = '#090909',  -- 活动窗口标题栏背景色
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   -- 非活动窗格HSB调整（注释掉的版本）
   -- inactive_pane_hsb = {
   --    saturation = 0.9,
   --    brightness = 0.65,
   -- },
   -- 非活动窗格HSB调整（当前生效版本）
   inactive_pane_hsb = {
      saturation = 1,  -- 饱和度
      brightness = 1,  -- 亮度
   },

   -- 视觉提示音（Visual Bell）配置
   visual_bell = {
      fade_in_function = 'EaseIn',  -- 淡入动画函数
      fade_in_duration_ms = 250,  -- 淡入持续时间
      fade_out_function = 'EaseOut',  -- 淡出动画函数
      fade_out_duration_ms = 250,  -- 淡出持续时间
      target = 'CursorColor',  -- 动画目标为光标颜色
   },
}
