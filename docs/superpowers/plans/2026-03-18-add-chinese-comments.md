# 添加中文注释 实现计划

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 Wezterm 配置仓库中所有 20 个 Lua 文件添加清晰简洁的中文注释，不修改原有代码逻辑。

**Architecture:** 按目录顺序依次处理每个文件，只添加注释，保持原有代码结构、格式和逻辑完全不变。遵循设计文档中定义的简洁注释风格。

**Tech Stack:** Lua (Wezterm 配置)

---

## 文件清单

需要修改以下文件（均为已有文件，仅添加注释）：
1. `wezterm.lua` - 主入口文件
2. `colors/custom.lua` - 自定义颜色配置
3. `config/appearance.lua` - 外观配置
4. `config/bindings.lua` - 按键绑定配置
5. `config/domains.lua` - 域名配置
6. `config/fonts.lua` - 字体配置
7. `config/general.lua` - 一般行为配置
8. `config/init.lua` - 配置模块初始化
9. `config/launch.lua` - 启动菜单配置
10. `events/gui-startup.lua` - GUI 启动事件处理
11. `events/left-status.lua` - 左侧状态栏处理
12. `events/new-tab-button.lua` - 新建标签页按钮处理
13. `events/right-status.lua` - 右侧状态栏处理
14. `events/tab-title.lua` - 标签页标题处理
15. `utils/backdrops.lua` - 背景工具模块
16. `utils/cells.lua` - 单元格工具模块
17. `utils/gpu-adapter.lua` - GPU 适配工具
18. `utils/math.lua` - 数学工具函数
19. `utils/opts-validator.lua` - 选项验证工具
20. `utils/platform.lua` - 平台检测工具

---

### Task 1: 处理主入口文件

**Files:**
- Modify: `wezterm.lua`

- [ ] **Step 1: 读取文件内容**

- [ ] **Step 2: 添加中文注释**

```lua
-- 导入配置模块
local Config = require('config')

-- 初始化背景效果
require('utils.backdrops')
   -- :set_focus('#000000')
   -- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')
   :set_images()
   :random()

-- 注册各个事件处理器
require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

-- 构建并返回最终配置
return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
```

- [ ] **Step 3: 验证 Lua 语法正确**

Run: `luac -p wezterm.lua`
Expected: 无输出 → 语法正确

- [ ] **Step 4: 提交更改**

```bash
git add wezterm.lua
git commit -m "docs: add chinese comments - wezterm.lua"
```

---

### Task 2: 处理颜色配置

**Files:**
- Modify: `colors/custom.lua`

- [ ] **Step 1: 读取文件内容**

- [ ] **Step 2: 添加中文注释**

- [ ] **Step 3: 验证语法**

Run: `luac -p colors/custom.lua`
Expected: 无输出 → 语法正确

- [ ] **Step 4: 提交更改**

```bash
git add colors/custom.lua
git commit -m "docs: add chinese comments - colors/custom.lua"
```

---

### Task 3: 处理 config/init.lua

**Files:**
- Modify: `config/init.lua`

- [ ] **Step 1: 读取文件内容**

- [ ] **Step 2: 添加中文注释**

```lua
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
```

- [ ] **Step 3: 验证语法**

Run: `luac -p config/init.lua`
Expected: 无输出 → 语法正确

- [ ] **Step 4: 提交更改**

```bash
git add config/init.lua
git commit -m "docs: add chinese comments - config/init.lua"
```

---

### Task 4: 处理 config/general.lua

**Files:**
- Modify: `config/general.lua`

- [ ] **Step 1: 读取文件内容**

- [ ] **Step 2: 添加中文注释**

- [ ] **Step 3: 验证语法**

Run: `luac -p config/general.lua`
Expected: 无输出 → 语法正确

- [ ] **Step 4: 提交更改**

---

### Task 5: 处理 config/appearance.lua

**Files:**
- Modify: `config/appearance.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 6: 处理 config/bindings.lua

**Files:**
- Modify: `config/bindings.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 7: 处理 config/domains.lua

**Files:**
- Modify: `config/domains.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 8: 处理 config/fonts.lua

**Files:**
- Modify: `config/fonts.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 9: 处理 config/launch.lua

**Files:**
- Modify: `config/launch.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 10: 处理 events/gui-startup.lua

**Files:**
- Modify: `events/gui-startup.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 11: 处理 events/left-status.lua

**Files:**
- Modify: `events/left-status.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 12: 处理 events/new-tab-button.lua

**Files:**
- Modify: `events/new-tab-button.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 13: 处理 events/right-status.lua

**Files:**
- Modify: `events/right-status.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 14: 处理 events/tab-title.lua

**Files:**
- Modify: `events/tab-title.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 15: 处理 utils/backdrops.lua

**Files:**
- Modify: `utils/backdrops.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 16: 处理 utils/cells.lua

**Files:**
- Modify: `utils/cells.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 17: 处理 utils/gpu-adapter.lua

**Files:**
- Modify: `utils/gpu-adapter.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 18: 处理 utils/math.lua

**Files:**
- Modify: `utils/math.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 19: 处理 utils/opts-validator.lua

**Files:**
- Modify: `utils/opts-validator.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

### Task 20: 处理 utils/platform.lua

**Files:**
- Modify: `utils/platform.lua`

- [ ] **Step 1-4: 读取 → 添加注释 → 验证 → 提交**

---

## 验证整体正确性

- [ ] **最终验证：检查所有文件语法**

Run: `find . -name "*.lua" -type f -exec luac -p {} \;`
Expected: 无任何输出 → 所有文件语法正确

- [ ] **提交最终检查**

## 处理原则

1. **只添加注释，不修改代码** - 原有代码逻辑保持完全不变
2. **遵循简洁风格** - 功能块加注释，关键行右侧加注释，自解释代码不加注释
3. **整合原有注释** - 原有英文注释有价值信息保留在中文注释中，重复注释删除
4. **保持格式** - 原有缩进、空行保持不变
