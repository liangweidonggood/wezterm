-- 单元格格式化工具模块
-- 提供创建和管理格式化单元格的辅助函数，用于构建状态栏等 UI 元素
-- 基于 wezterm.format API (ref: <https://wezfurlong.org/wezterm/config/lua/wezterm/format.html>)

--[[ 格式项类型定义: 开始 ]]
---@class FormatItem.Text
---@field Text string 文本内容

---@class FormatItem.Attribute.Intensity
---@field Intensity 'Bold'|'Half'|'Normal' 强度类型：粗体|半粗|正常

---@class FormatItem.Attribute.Italic
---@field Italic boolean 是否斜体

---@class FormatItem.Attribute.Underline
---@field Underline 'None'|'Single'|'Double'|'Curly' 下划线类型：无|单|双|卷曲

---@class FormatItem.Attribute
---@field Attribute FormatItem.Attribute.Intensity|FormatItem.Attribute.Italic|FormatItem.Attribute.Underline 属性项

---@class FormatItem.Foreground
---@field Foreground {Color: string} 前景颜色

---@class FormatItem.Background
---@field Background {Color: string} 背景颜色

---@alias FormatItem.Reset 'ResetAttributes' 重置属性指令

---@alias FormatItem FormatItem.Text|FormatItem.Attribute|FormatItem.Foreground|FormatItem.Background|FormatItem.Reset 格式项类型别名
--[[ 格式项类型定义: 结束 ]]

local attr = {}

-- 创建强度属性项
---@param type 'Bold'|'Half'|'Normal' 强度类型
---@return {Attribute: FormatItem.Attribute.Intensity} 强度属性项
attr.intensity = function(type)
   return { Attribute = { Intensity = type } }
end

-- 创建斜体属性项
---@return {Attribute: FormatItem.Attribute.Italic} 斜体属性项
attr.italic = function()
   return { Attribute = { Italic = true } }
end

-- 创建下划线属性项
---@param type 'None'|'Single'|'Double'|'Curly' 下划线类型
---@return {Attribute: FormatItem.Attribute.Underline} 下划线属性项
attr.underline = function(type)
   return { Attribute = { Underline = type } }
end

-- 段颜色类型定义
---@alias Cells.SegmentColors {bg?: string|'UNSET', fg?: string|'UNSET'} 段颜色配置：背景色|前景色，UNSET表示清除颜色

---@class FormatCells.Segment
---@field items FormatItem[] 格式项列表
---@field has_bg boolean 是否有背景色
---@field has_fg boolean 是否有前景色

-- 格式单元格生成器，用于构建 wezterm.format 可用的格式
---@class FormatCells
---@field segments table<string|number, FormatCells.Segment> 段集合
local Cells = {}
Cells.__index = Cells

-- 属性生成器，用于创建 wezterm.format 可用的属性
---@class Cells.Attributes
---@field intensity fun(type: 'Bold'|'Half'|'Normal'): {Attribute: FormatItem.Attribute.Intensity} 创建强度属性
---@field underline fun(type: 'None'|'Single'|'Double'|'Curly'): {Attribute: FormatItem.Attribute.Underline} 创建下划线属性
---@field italic fun(): {Attribute: FormatItem.Attribute.Italic} 创建斜体属性
---@overload fun(...: FormatItem.Attribute): FormatItem.Attribute[] 合并多个属性项
Cells.attr = setmetatable(attr, {
   __call = function(_, ...)
      return { ... }
   end,
})

-- 创建新的格式单元格实例
---@return FormatCells 格式单元格实例
function Cells:new()
   return setmetatable({
      segments = {},
   }, self)
end

-- 添加新的段到单元格
---@param segment_id string|number 段标识符（唯一）
---@param text string 段文本内容
---@param color? Cells.SegmentColors 段颜色配置（背景色和前景色）
---@param attributes? FormatItem.Attribute[] 文本属性（如粗体、斜体、下划线等）
function Cells:add_segment(segment_id, text, color, attributes)
   color = color or {}

   ---@type FormatItem[]
   local items = {}

   if color.bg then
      assert(color.bg ~= 'UNSET', '添加新段时不能使用 UNSET')
      table.insert(items, { Background = { Color = color.bg } })
   end
   if color.fg then
      assert(color.bg ~= 'UNSET', '添加新段时不能使用 UNSET')
      table.insert(items, { Foreground = { Color = color.fg } })
   end
   if attributes and #attributes > 0 then
      for _, attr_ in ipairs(attributes) do
         table.insert(items, attr_)
      end
   end
   table.insert(items, { Text = text })
   table.insert(items, 'ResetAttributes')

   ---@type FormatCells.Segment
   self.segments[segment_id] = {
      items = items,
      has_bg = color.bg ~= nil,
      has_fg = color.fg ~= nil,
   }

   return self
end

-- 检查段是否存在（私有方法）
---@private
---@param segment_id string|number 段标识符
function Cells:_check_segment(segment_id)
   if not self.segments[segment_id] then
      error('段 "' .. segment_id .. '" 未找到')
   end
end

-- 更新段的文本内容
---@param segment_id string|number 段标识符
---@param text string 新的文本内容
function Cells:update_segment_text(segment_id, text)
   self:_check_segment(segment_id)
   local idx = #self.segments[segment_id].items - 1
   self.segments[segment_id].items[idx] = { Text = text }
   return self
end

-- 更新段的颜色
---@param segment_id string|number 段标识符
---@param color Cells.SegmentColors 新的颜色配置
function Cells:update_segment_colors(segment_id, color)
   assert(type(color) == 'table', '颜色必须是一个表格')

   self:_check_segment(segment_id)

   local has_bg = self.segments[segment_id].has_bg
   local has_fg = self.segments[segment_id].has_fg

   -- 更新背景色
   if color.bg then
      if has_bg and color.bg == 'UNSET' then
         table.remove(self.segments[segment_id].items, 1)  -- 移除背景色配置
         has_bg = false
         goto bg_end
      end

      if has_bg then
         self.segments[segment_id].items[1] = { Background = { Color = color.bg } }  -- 更新背景色
      else
         table.insert(self.segments[segment_id].items, 1, { Background = { Color = color.bg } })  -- 添加背景色
         has_bg = true
      end
   end
   ::bg_end::

   -- 更新前景色
   if color.fg then
      local fg_idx = has_bg and 2 or 1
      if has_fg and color.fg == 'UNSET' then
         table.remove(self.segments[segment_id].items, fg_idx)  -- 移除前景色配置
         has_fg = false
         goto fg_end
      end

      if has_fg then
         self.segments[segment_id].items[fg_idx] = { Foreground = { Color = color.fg } }  -- 更新前景色
      else
         table.insert(
            self.segments[segment_id].items,
            fg_idx,
            { Foreground = { Color = color.fg } }
         )  -- 添加前景色
         has_fg = true
      end
   end
   ::fg_end::

   self.segments[segment_id].has_bg = has_bg
   self.segments[segment_id].has_fg = has_fg
   return self
end

-- 渲染指定的段到 wezterm.format 可用的格式
-- 段将按照 ids 表的顺序进行渲染
---@param ids table<string|number> 要渲染的段标识符列表
---@return FormatItem[] wezterm.format 可用的格式项列表
function Cells:render(ids)
   local cells = {}

   for _, id in ipairs(ids) do
      self:_check_segment(id)

      for _, item in pairs(self.segments[id].items) do
         table.insert(cells, item)
      end
   end
   return cells
end

-- 渲染所有段到 wezterm.format 可用的格式
-- 警告：如果 segment_id 是字符串类型，渲染顺序可能与添加顺序不同
---@return FormatItem[] wezterm.format 可用的格式项列表
function Cells:render_all()
   local cells = {}
   for _, segment in pairs(self.segments) do
      for _, item in pairs(segment.items) do
         table.insert(cells, item)
      end
   end
   return cells
end

-- 重置所有段（清空所有内容）
function Cells:reset()
   self.segments = {}
end

return Cells
