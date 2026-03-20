-- 导入模块
local wezterm = require('wezterm')
local colors = require('colors.custom')

-- 初始化随机数生成器
-- Lua math库的已知问题，通过多次调用math.random()来改善随机性
-- 参考: https://stackoverflow.com/questions/20154991/generating-uniform-random-numbers-in-lua
math.randomseed(os.time())
math.random()
math.random()
math.random()

-- 支持的图片文件格式
local GLOB_PATTERN = '*.{jpg,jpeg,png,gif,bmp,ico,tiff,pnm,dds,tga}'

---@class BackDrops
---@field current_idx number 当前图片索引
---@field images string[] 背景图片路径数组
---@field images_dir string 图片目录，默认为 `wezterm.config_dir .. '/backdrops/'`
---@field focus_color string 专注模式下的背景色，默认为 `colors.custom.background`
---@field focus_on boolean 专注模式开关状态
local BackDrops = {}
BackDrops.__index = BackDrops

--- 初始化背景控制器
---@private
function BackDrops:init()
   local inital = {
      current_idx = 1,  -- 默认显示第一张图片
      images = {},  -- 存储图片路径数组
      images_dir = wezterm.config_dir .. '/backdrops/',  -- 默认图片目录
      focus_color = colors.background,  -- 默认专注模式背景色
      focus_on = false,  -- 专注模式默认关闭
   }
   local backdrops = setmetatable(inital, self)
   return backdrops
end

--- 设置图片目录（覆盖默认值）
--- 默认图片目录为 `wezterm.config_dir .. '/backdrops/'`
---
--- 注意:
---  此函数必须在 `set_images()` 之前调用
---
---@param path string 背景图片目录路径
function BackDrops:set_images_dir(path)
   self.images_dir = path
   if not path:match('/$') then  -- 确保路径以斜杠结尾
      self.images_dir = path .. '/'
   end
   return self  -- 支持链式调用
end

--- 加载图片列表（初始化后必须先调用此函数）
--- 在配置首次加载时，此函数只能在 wezterm.lua 中调用
--- WezTerm的fs.glob函数通过子进程运行，在其他文件中调用会抛出协程错误
function BackDrops:set_images()
   self.images = wezterm.glob(self.images_dir .. GLOB_PATTERN)  -- 匹配目录下所有支持的图片文件
   return self  -- 支持链式调用
end

--- 设置专注模式背景色（覆盖默认值）
--- 默认专注模式背景色为 `colors.custom.background`
---@param focus_color string 专注模式背景色
function BackDrops:set_focus(focus_color)
   self.focus_color = focus_color
   return self  -- 支持链式调用
end

--- 创建当前图片的背景配置
---@private
---@return table 背景配置选项
function BackDrops:_create_opts()
   return {
      {
         source = { File = self.images[self.current_idx] },  -- 当前图片作为背景源
         horizontal_align = 'Center',  -- 水平居中对齐
      },
      {
         source = { Color = colors.background },  -- 覆盖半透明背景色
         height = '120%',  -- 高度120%以覆盖整个窗口
         width = '120%',  -- 宽度120%以覆盖整个窗口
         vertical_offset = '-10%',  -- 垂直偏移-10%实现居中
         horizontal_offset = '-10%',  -- 水平偏移-10%实现居中
         opacity = 0.96,  -- 不透明度96%
      },
   }
end

--- 创建专注模式的背景配置
---@private
---@return table 专注模式背景配置
function BackDrops:_create_focus_opts()
   return {
      {
         source = { Color = self.focus_color },  -- 专注模式背景色
         height = '120%',  -- 高度120%以覆盖整个窗口
         width = '120%',  -- 宽度120%以覆盖整个窗口
         vertical_offset = '-10%',  -- 垂直偏移-10%实现居中
         horizontal_offset = '-10%',  -- 水平偏移-10%实现居中
         opacity = 1,  -- 完全不透明
      },
   }
end

--- 设置初始背景配置
---@param focus_on boolean? 专注模式开关（可选，默认false）
function BackDrops:initial_options(focus_on)
   focus_on = focus_on or false  -- 默认关闭专注模式
   assert(type(focus_on) == 'boolean', 'BackDrops:initial_options - 必须传入布尔值')

   self.focus_on = focus_on
   if focus_on then
      return self:_create_focus_opts()  -- 专注模式配置
   end

   return self:_create_opts()  -- 正常模式配置
end

--- 应用背景配置到窗口（私有方法）
---@private
---@param window any WezTerm窗口对象
---@param background_opts table 背景配置选项
function BackDrops:_set_opt(window, background_opts)
   window:set_config_overrides({
      background = background_opts,
      enable_tab_bar = window:effective_config().enable_tab_bar,  -- 保持标签栏状态不变
   })
end

--- 应用专注模式背景配置到窗口（私有方法）
---@private
---@param window any WezTerm窗口对象
function BackDrops:_set_focus_opt(window)
   local opts = {
      background = {
         {
            source = { Color = self.focus_color },  -- 专注模式背景色
            height = '120%',
            width = '120%',
            vertical_offset = '-10%',
            horizontal_offset = '-10%',
            opacity = 1,
         },
      },
      enable_tab_bar = window:effective_config().enable_tab_bar,
   }
   window:set_config_overrides(opts)
end

--- 将图片列表转换为InputSelector可使用的选择项
--- 用于在终端中显示可选择的图片列表
---@return table InputSelector选择项数组
function BackDrops:choices()
   local choices = {}
   for idx, file in ipairs(self.images) do
      table.insert(choices, {
         id = tostring(idx),  -- 选择项ID（字符串类型）
         label = file:match('([^/]+)$'),  -- 显示文件名（不含路径）
      })
   end
   return choices
end

--- 随机选择一张背景图片
--- 传入Window对象可实时更新当前窗口的背景
---@param window any? WezTerm窗口对象（可选）
function BackDrops:random(window)
   self.current_idx = math.random(#self.images)  -- 生成随机索引

   if window ~= nil then  -- 如果提供了窗口对象，则更新背景
      self:_set_opt(window, self:_create_opts())
   end
end

--- 循环切换到下一张背景图片
---@param window any WezTerm窗口对象
function BackDrops:cycle_forward(window)
   if self.current_idx == #self.images then  -- 最后一张后回到第一张
      self.current_idx = 1
   else
      self.current_idx = self.current_idx + 1
   end
   self:_set_opt(window, self:_create_opts())  -- 更新窗口背景
end

--- 循环切换到上一张背景图片
---@param window any WezTerm窗口对象
function BackDrops:cycle_back(window)
   if self.current_idx == 1 then  -- 第一张前回到最后一张
      self.current_idx = #self.images
   else
      self.current_idx = self.current_idx - 1
   end
   self:_set_opt(window, self:_create_opts())  -- 更新窗口背景
end

--- 设置特定索引的背景图片
---@param window any WezTerm窗口对象
---@param idx number 图片索引
function BackDrops:set_img(window, idx)
   if idx > #self.images or idx < 0 then  -- 索引越界检查
      wezterm.log_error('Index out of range')  -- 记录错误日志
      return
   end

   self.current_idx = idx
   self:_set_opt(window, self:_create_opts())  -- 更新窗口背景
end

--- 切换专注模式（在图片背景和纯色背景间切换）
---@param window any WezTerm窗口对象
function BackDrops:toggle_focus(window)
   local background_opts

   if self.focus_on then  -- 从专注模式切换到正常模式
      background_opts = self:_create_opts()
      self.focus_on = false
   else  -- 从正常模式切换到专注模式
      background_opts = self:_create_focus_opts()
      self.focus_on = true
   end

   self:_set_opt(window, background_opts)  -- 应用配置
end

-- 导出单例实例
return BackDrops:init()
