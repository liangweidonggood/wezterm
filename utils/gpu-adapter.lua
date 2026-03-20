-- 引入 wezterm 模块和平台检测工具
local wezterm = require('wezterm')
local platform = require('utils.platform')

-- GPU 后端类型别名：Vulkan、Metal、OpenGL、DirectX 12
---@alias WeztermGPUBackend 'Vulkan'|'Metal'|'Gl'|'Dx12'
-- GPU 设备类型别名：独立显卡、集成显卡、CPU、其他
---@alias WeztermGPUDeviceType 'DiscreteGpu'|'IntegratedGpu'|'Cpu'|'Other'

-- GPU 适配器类定义
---@class WeztermGPUAdapter
---@field name string 适配器名称
---@field backend WeztermGPUBackend 使用的后端 API
---@field device number 设备 ID
---@field device_type WeztermGPUDeviceType 设备类型
---@field driver? string 驱动程序名称
---@field driver_info? string 驱动程序信息
---@field vendor string 厂商信息

-- 适配器映射表类型：按后端 API 映射的适配器
---@alias AdapterMap { [WeztermGPUBackend]: WeztermGPUAdapter|nil }|nil

-- GPU 适配器集合类定义
---@class GpuAdapters
---@field __backends WeztermGPUBackend[] 当前平台可用的后端列表
---@field __preferred_backend WeztermGPUBackend 当前首选后端 API
---@field DiscreteGpu AdapterMap 独立显卡适配器映射
---@field IntegratedGpu AdapterMap 集成显卡适配器映射
---@field Cpu AdapterMap CPU 适配器映射
---@field Other AdapterMap 其他类型适配器映射
local GpuAdapters = {}
GpuAdapters.__index = GpuAdapters

-- 各平台可用的后端 API 列表
-- 参考：https://github.com/gfx-rs/wgpu#supported-platforms
GpuAdapters.AVAILABLE_BACKENDS = {
   windows = { 'Dx12', 'Vulkan', 'Gl' },  -- Windows 平台优先使用 Dx12 > Vulkan > OpenGL
   linux = { 'Vulkan', 'Gl' },           -- Linux 平台优先使用 Vulkan > OpenGL
   mac = { 'Metal' },                    -- macOS 平台仅支持 Metal
}

-- 枚举系统中所有可用的 GPU 适配器
---@type WeztermGPUAdapter[]
GpuAdapters.ENUMERATED_GPUS = wezterm.gui.enumerate_gpus()

-- 初始化 GpuAdapters 类实例
---@return GpuAdapters
---@private
function GpuAdapters:init()
   local initial = {
      __backends = self.AVAILABLE_BACKENDS[platform.os],
      __preferred_backend = self.AVAILABLE_BACKENDS[platform.os][1],  -- 首选后端是各平台列表的第一个
      DiscreteGpu = nil,
      IntegratedGpu = nil,
      Cpu = nil,
      Other = nil,
   }

   -- 遍历枚举的 GPU 并创建按设备类型和后端分类的查找表 (`AdapterMap`)
   for _, adapter in ipairs(self.ENUMERATED_GPUS) do
      if not initial[adapter.device_type] then
         initial[adapter.device_type] = {}
      end
      initial[adapter.device_type][adapter.backend] = adapter
   end

   local gpu_adapters = setmetatable(initial, self)

   return gpu_adapters
end

-- 自动选择最佳 GPU 适配器的策略函数
-- 选择标准：
-- 1. 首选显卡性能：独立显卡 > 集成显卡 > 其他类型 > CPU 渲染
-- 2. 首选图形 API：基于平台最佳选择（Windows:Dx12>Vulkan>OpenGL；Linux:Vulkan>OpenGL；macOS:Metal）
-- 如果未找到理想的适配器组合，返回 nil 让 Wezterm 自动决定
-- 注意：这些是个人偏好，可通过修改 GpuAdapters.AVAILABLE_BACKENDS 调整优先级
---@return WeztermGPUAdapter|nil
function GpuAdapters:pick_best()
   local adapters_options = self.DiscreteGpu  -- 首先尝试使用独立显卡
   local preferred_backend = self.__preferred_backend

   if not adapters_options then
      adapters_options = self.IntegratedGpu  -- 未找到独立显卡时尝试集成显卡
   end

   if not adapters_options then
      adapters_options = self.Other  -- 未找到集成显卡时尝试其他类型
      preferred_backend = 'Gl'  -- 其他类型设备默认使用 OpenGL 后端
   end

   if not adapters_options then
      adapters_options = self.Cpu  -- 最后尝试 CPU 渲染
   end

   if not adapters_options then
      wezterm.log_error('No GPU adapters found. Using Default Adapter.')  -- 未找到任何适配器
      return nil
   end

   local adapter_choice = adapters_options[preferred_backend]

   if not adapter_choice then
      wezterm.log_error('Preferred backend not available. Using Default Adapter.')  -- 首选后端不可用
      return nil
   end

   return adapter_choice
end

-- 手动选择指定后端和设备类型的 GPU 适配器
-- 如果找不到指定的适配器，返回 nil 让 Wezterm 自动决定
---@param backend WeztermGPUBackend 要使用的图形后端 API
---@param device_type WeztermGPUDeviceType 设备类型
---@return WeztermGPUAdapter|nil
function GpuAdapters:pick_manual(backend, device_type)
   local adapters_options = self[device_type]

   if not adapters_options then
      wezterm.log_error('No GPU adapters found. Using Default Adapter.')
      return nil
   end

   local adapter_choice = adapters_options[backend]

   if not adapter_choice then
      wezterm.log_error('Preferred backend not available. Using Default Adapter.')
      return nil
   end

   return adapter_choice
end

-- 初始化并返回 GpuAdapters 实例
return GpuAdapters:init()
