-- 导入 Wezterm 模块
local wezterm = require('wezterm')

-- 配置类定义
---@class Config
---@field options table 配置选项表
local Config = {}
Config.__index = Config

---初始化配置对象
---@return Config 新建的配置对象
function Config:init()
   local config = setmetatable({ options = {} }, self)
   return config
end

---追加配置选项到当前配置
---@param new_options table 要追加的新配置选项
---@return Config 返回自身支持链式调用
function Config:append(new_options)
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         -- 检测到重复配置选项，输出警告
         wezterm.log_warn(
            'Duplicate config option detected: ',
            { old = self.options[k], new = new_options[k] }
         )
         goto continue
      end
      self.options[k] = v
      ::continue::
   end
   return self
end

return Config
