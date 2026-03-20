# Claude Code 项目约定

## 项目描述

这是一个 Wezterm 终端配置项目，使用 Lua 语言编写。

## 代码风格

- 使用 [stylua](https://github.com/JohnnyMorganz/StyLua) 格式化 Lua 代码
- 遵循 Lua 社区常见命名规范
- 添加中文注释，方便理解

## 权限

此项目已经配置 `.claude/settings.local.json`，允许所有 `git` 命令自动执行，不需要手动确认。

## 检查命令

修改后可以运行以下命令检查语法：

```bash
luac -p wezterm.lua
luac -p config/*.lua
```

## 提交

保持提交信息清晰，中文描述修改内容。
