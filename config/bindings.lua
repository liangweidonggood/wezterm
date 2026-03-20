local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

-- 修饰键配置
local mod = {}

-- 根据不同平台设置修饰键
if platform.is_mac then
   mod.SUPER = 'SUPER'          -- Mac平台使用Command键
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT'           -- Windows/Linux平台使用Alt键，避免与Windows快捷键冲突
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
-- 按键绑定配置
local keys = {
   -- 杂项/实用功能 --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },                -- 激活复制模式
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },        -- 激活命令面板
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },                   -- 显示启动器
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },  -- 显示标签页启动器
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),          -- 显示工作区启动器
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },          -- 切换全屏模式
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },          -- 显示调试叠加层
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) }, -- 打开搜索栏
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }), -- 快速选择并打开URL
   },

   -- 光标移动 --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\u{1b}OH' }, -- 移动到行首
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\u{1b}OF' }, -- 移动到行尾
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\u{15}' }, -- 删除到行首

   -- 复制/粘贴 --
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') }, -- 复制到剪贴板
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') }, -- 从剪贴板粘贴

   -- 标签页 --
   -- 标签页: 新建和关闭
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') }, -- 新建标签页
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) }, -- 新建WSL标签页
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) }, -- 关闭当前标签页

   -- 标签页: 导航
   { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) }, -- 激活上一个标签页
   { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) }, -- 激活下一个标签页
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) }, -- 向左移动标签页
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) }, -- 向右移动标签页

   -- 标签页: 标题
   { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') }, -- 手动更新标签页标题
   { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') }, -- 重置标签页标题

   -- 标签页: 隐藏标签栏
   { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), }, -- 切换标签栏显示

   -- 窗口 --
   -- 窗口: 新建窗口
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow }, -- 新建窗口

   -- 窗口: 调整窗口大小
   {
      key = '-',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         if dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width - 50
         local new_height = dimensions.pixel_height - 50
         window:set_inner_size(new_width, new_height)
      end) -- 缩小窗口
   },
   {
      key = '=',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         if dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width + 50
         local new_height = dimensions.pixel_height + 50
         window:set_inner_size(new_width, new_height)
      end) -- 放大窗口
   },
   {
      key = 'Enter',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         window:maximize()
      end) -- 最大化窗口
   },

   -- 背景控制 --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end), -- 随机切换背景
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end), -- 上一张背景
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end), -- 下一张背景
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'InputSelector: Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            if not idx then
               return
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }), -- 选择背景图片
   },
   {
      key = 'b',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:toggle_focus(window)
      end) -- 切换背景焦点效果
   },

   -- 窗格 --
   -- 窗格: 分割窗格
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }), -- 垂直分割窗格
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }), -- 水平分割窗格
   },

   -- 窗格: 缩放和关闭窗格
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState }, -- 切换窗格缩放状态
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) }, -- 关闭当前窗格

   -- 窗格: 导航
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') }, -- 切换到上方窗格
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') }, -- 切换到下方窗格
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') }, -- 切换到左侧窗格
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') }, -- 切换到右侧窗格
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }), -- 选择并交换窗格
   },

   -- 窗格: 滚动内容
   { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) }, -- 向上滚动5行
   { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) }, -- 向下滚动5行
   { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) }, -- 向上翻页
   { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) }, -- 向下翻页

   -- 按键表 --
   -- 调整字体大小
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timeout_milliseconds = 1000,
      }), -- 进入字体大小调整模式
   },
   -- 调整窗格大小
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timeout_milliseconds = 1000,
      }), -- 进入窗格大小调整模式
   },
}

-- stylua: ignore
-- 按键表定义
local key_tables = {
   -- 调整字体大小按键表
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize }, -- 增大字体
      { key = 'j',      action = act.DecreaseFontSize }, -- 减小字体
      { key = 'r',      action = act.ResetFontSize }, -- 重置字体大小
      { key = 'Escape', action = 'PopKeyTable' }, -- 退出按键表
      { key = 'q',      action = 'PopKeyTable' }, -- 退出按键表
   },
   -- 调整窗格大小按键表
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) }, -- 向上调整窗格
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) }, -- 向下调整窗格
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) }, -- 向左调整窗格
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) }, -- 向右调整窗格
      { key = 'Escape', action = 'PopKeyTable' }, -- 退出按键表
      { key = 'q',      action = 'PopKeyTable' }, -- 退出按键表
   },
}

local mouse_bindings = {
   -- 鼠标绑定
   -- Ctrl+左键点击将打开鼠标光标下的链接
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true, -- 禁用默认按键绑定
   -- disable_default_mouse_bindings = true, -- 禁用默认鼠标绑定
   leader = { key = 'Space', mods = mod.SUPER_REV }, -- 设置leader键
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
