-- GUI 启动事件处理模块
-- 在 Wezterm GUI 启动时执行自定义操作
local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

-- 初始化GUI启动事件处理
M.setup = function()
   -- 监听GUI启动事件
   wezterm.on('gui-startup', function(cmd)
      -- 生成新窗口，使用传入的命令参数或默认配置
      local _, _, window = mux.spawn_window(cmd or {})
      -- 将窗口最大化
      window:gui_window():maximize()
   end)
end

return M
