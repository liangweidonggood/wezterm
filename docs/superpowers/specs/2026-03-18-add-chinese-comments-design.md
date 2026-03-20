# 添加中文注释 - 设计文档

## 项目背景
这是用户的 Wezterm 终端配置仓库，现有的 Lua 代码只有少量英文注释，需要添加中文注释帮助理解代码功能。

## 需求
为目录下所有 Lua 文件添加中文注释，使用中文沟通。

## 范围
总共需要处理 20 个 Lua 文件：
- `./colors/custom.lua`
- `./config/appearance.lua`
- `./config/bindings.lua`
- `./config/domains.lua`
- `./config/fonts.lua`
- `./config/general.lua`
- `./config/init.lua`
- `./config/launch.lua`
- `./events/gui-startup.lua`
- `./events/left-status.lua`
- `./events/new-tab-button.lua`
- `./events/right-status.lua`
- `./events/tab-title.lua`
- `./utils/backdrops.lua`
- `./utils/cells.lua`
- `./utils/gpu-adapter.lua`
- `./utils/math.lua`
- `./utils/opts-validator.lua`
- `./utils/platform.lua`
- `./wezterm.lua`

## 设计决策

### 注释风格
选择方案A：**简洁风格**
- 功能块上方添加中文注释说明作用
- 关键代码行右侧添加简短中文注释
- 自解释代码不添加冗余注释
- 原有英文注释如果内容重复则删除，如果有额外价值信息则整合到中文注释中保留

**注释示例：**
```lua
-- 基础行为配置
return {
   -- 自动重新加载配置
   automatically_reload_config = true,
   exit_behavior = 'CloseOnCleanExit',        -- shell成功退出时关闭
   exit_behavior_messaging = 'Verbose',       -- 详细退出信息输出
   status_update_interval = 1000,             -- 状态栏更新间隔(毫秒)
}
```

**说明：**
- 简单配置项如 `automatically_reload_config = true` 本身已自解释，只需要块注释说明整体作用
- 不常用的配置项如 `exit_behavior` 在右侧添加简短说明
- 目标读者是维护这个配置的开发者，注释粒度为功能块级别+关键配置说明

### 处理原则
- 保留原有代码逻辑完全不变
- 保持原有代码格式、缩进、空行不变
- 只添加注释，不修改代码功能

## 成功标准
- 所有 Lua 文件都添加了适当的中文注释
- 代码可以正常加载运行，无语法错误
- 注释清晰简洁，帮助理解代码功能

## 实现顺序
按目录顺序依次处理：
1. 主文件 `wezterm.lua`
2. `colors/` 目录
3. `config/` 目录
4. `events/` 目录
5. `utils/` 目录
