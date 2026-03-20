-- 加载wezterm模块
local wezterm = require('wezterm')

-- 字符串匹配辅助函数
local function is_found(str, pattern)
   return string.find(str, pattern) ~= nil
end

---@alias PlatformType 'windows' | 'linux' | 'mac'
--- 平台类型别名定义

---@return {os: PlatformType, is_win: boolean, is_linux: boolean, is_mac: boolean}
--- 获取当前运行平台信息
local function platform()
   local is_win = is_found(wezterm.target_triple, 'windows')  -- 检测是否为Windows平台
   local is_linux = is_found(wezterm.target_triple, 'linux')  -- 检测是否为Linux平台
   local is_mac = is_found(wezterm.target_triple, 'apple')    -- 检测是否为macOS平台
   local os

   if is_win then
      os = 'windows'                                      -- 设置操作系统为Windows
   elseif is_linux then
      os = 'linux'                                        -- 设置操作系统为Linux
   elseif is_mac then
      os = 'mac'                                          -- 设置操作系统为macOS
   else
      error('Unknown platform')                           -- 未知平台抛出错误
   end

   return {
      os = os,                                            -- 操作系统名称
      is_win = is_win,                                    -- 是否为Windows平台
      is_linux = is_linux,                                -- 是否为Linux平台
      is_mac = is_mac,                                    -- 是否为macOS平台
   }
end

-- 获取并缓存当前平台信息
local _platform = platform()

-- 返回平台信息表
return _platform
