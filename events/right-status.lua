-- 导入wezterm模块
local wezterm = require('wezterm')
-- 导入数学工具库
local umath = require('utils.math')
-- 导入单元格渲染工具
local Cells = require('utils.cells')
-- 导入选项验证工具
local OptsValidator = require('utils.opts-validator')

---@alias Event.RightStatusOptions { date_format?: string }
-- 右侧状态栏配置选项类型定义

---右侧状态栏配置
local EVENT_OPTS = {}

---@type OptsSchema
-- 配置验证模式
EVENT_OPTS.schema = {
   {
      name = 'date_format',      -- 日期时间格式
      type = 'string',          -- 字符串类型
      default = '%a %H:%M:%S',  -- 默认格式: 星期几 时:分:秒
   },
}
-- 创建验证器实例
EVENT_OPTS.validator = OptsValidator:new(EVENT_OPTS.schema)

-- 简写nerdfonts访问
local nf = wezterm.nerdfonts
-- 简写单元格属性访问
local attr = Cells.attr

-- 模块导出对象
local M = {}

-- 分隔符图标
local ICON_SEPARATOR = nf.oct_dash
-- 日期图标
local ICON_DATE = nf.fa_calendar

---@type string[]
-- 放电状态电池图标数组（从10%到100%）
local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery,
}
---@type string[]
-- 充电状态电池图标数组（从10%到100%）
local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_charging,
}

---@type table<string, Cells.SegmentColors>
-- 颜色配置表
-- stylua: ignore
local colors = {
   date      = { fg = '#fab387', bg = 'rgba(0, 0, 0, 0.4)' },  -- 日期文字颜色
   battery   = { fg = '#f9e2af', bg = 'rgba(0, 0, 0, 0.4)' },  -- 电池文字颜色
   separator = { fg = '#74c7ec', bg = 'rgba(0, 0, 0, 0.4)' }   -- 分隔符颜色
}

-- 创建单元格实例
local cells = Cells:new()

-- 配置右侧状态栏各区域
cells
   :add_segment('date_icon', ICON_DATE .. '  ', colors.date, attr(attr.intensity('Bold')))  -- 日期图标
   :add_segment('date_text', '', colors.date, attr(attr.intensity('Bold')))             -- 日期文本
   :add_segment('separator', ' ' .. ICON_SEPARATOR .. '  ', colors.separator)           -- 分隔符
   :add_segment('battery_icon', '', colors.battery)                                       -- 电池图标
   :add_segment('battery_text', '', colors.battery, attr(attr.intensity('Bold')))        -- 电池文本

-- 获取电池信息（电量百分比和图标）
---@return string, string
local function battery_info()
   -- 参考: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''  -- 电量百分比字符串
   local icon = ''   -- 电池图标

   -- 遍历所有电池（通常只有一个）
   for _, b in ipairs(wezterm.battery_info()) do
      -- 计算电池图标索引（1-10）
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      -- 格式化电量百分比
      charge = string.format('%.0f%%', b.state_of_charge * 100)

      -- 根据充电状态选择对应图标
      if b.state == 'Charging' then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
      end
   end

   -- 返回电量和带空格的电池图标
   return charge, icon .. ' '
end

-- 配置右侧状态栏
---@param opts? Event.RightStatusOptions Default: {date_format = '%a %H:%M:%S'}
M.setup = function(opts)
   -- 验证配置参数
   local valid_opts, err = EVENT_OPTS.validator:validate(opts or {})

   if err then
      wezterm.log_error(err)
   end

   -- 监听更新右侧状态栏事件
   wezterm.on('update-right-status', function(window, _pane)
      -- 获取电池信息
      local battery_text, battery_icon = battery_info()

      -- 更新各区域内容
      cells
         :update_segment_text('date_text', wezterm.strftime(valid_opts.date_format)) -- 更新日期
         :update_segment_text('battery_icon', battery_icon)                          -- 更新电池图标
         :update_segment_text('battery_text', battery_text)                          -- 更新电池电量

      -- 渲染并设置右侧状态栏
      window:set_right_status(
         wezterm.format(
            cells:render({ 'date_icon', 'date_text', 'separator', 'battery_icon', 'battery_text' })
         )
      )
   end)
end

-- 导出模块
return M
