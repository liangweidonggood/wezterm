-- 左侧状态栏模块 - 显示键表状态和leader键激活状态
local wezterm = require('wezterm')
local Cells = require('utils.cells')

local nf = wezterm.nerdfonts
local attr = Cells.attr

local M = {}

-- 定义Nerd Font图标
local GLYPH_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[ '' 左半圆装饰 ]]
local GLYPH_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[ '' 右半圆装饰 ]]
local GLYPH_KEY_TABLE = nf.md_table_key --[[ '󱏅' 键表图标 ]]
local GLYPH_KEY = nf.md_key --[[ '󰌆' 键图标 ]]

---@type table<string, Cells.SegmentColors>
local colors = {
   default = { bg = '#fab387', fg = '#1c1b19' },    -- 默认背景和前景色
   scircle = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#fab387' }, -- 半圆装饰颜色
}

-- 初始化Cells实例
local cells = Cells:new()

-- 构建状态栏左侧的基础布局
cells
   :add_segment(1, GLYPH_SEMI_CIRCLE_LEFT, colors.scircle, attr(attr.intensity('Bold')))
   :add_segment(2, ' ', colors.default, attr(attr.intensity('Bold')))
   :add_segment(3, ' ', colors.default, attr(attr.intensity('Bold')))
   :add_segment(4, GLYPH_SEMI_CIRCLE_RIGHT, colors.scircle, attr(attr.intensity('Bold')))

-- 配置左侧状态栏
M.setup = function()
   -- 监听状态栏更新事件
   wezterm.on('update-right-status', function(window, _pane)
      local name = window:active_key_table()
      local res = {}

      -- 如果当前激活了键表，显示键表名称
      if name then
         cells
            :update_segment_text(2, GLYPH_KEY_TABLE)
            :update_segment_text(3, ' ' .. string.upper(name))
         res = cells:render_all()
      end

      -- 如果leader键被激活，显示leader键状态
      if window:leader_is_active() then
         cells:update_segment_text(2, GLYPH_KEY):update_segment_text(3, ' ')
         res = cells:render_all()
      end

      -- 更新左侧状态栏
      window:set_left_status(wezterm.format(res))
   end)
end

return M
