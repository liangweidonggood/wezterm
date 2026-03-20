# Wezterm 配置

个人的 [Wezterm](https://wezfurlong.org/wezterm/) 终端配置，采用模块化结构，带有美观的背景图片和完整的快捷键支持。

## 特性

- 🎨 **模块化设计** - 按功能拆分配置文件，易于维护
- 🖼️ **随机背景** - 支持多张背景图片随机切换
- ⌨️ **自定义快捷键** - 完整的vim风格按键绑定
- 🌍 **跨平台支持** - 自动适配 macOS / Windows / Linux 不同平台
- ✨ **GPU加速** - 启用GPU渲染，流畅丝滑

## 新增快捷键

| 快捷键          | 功能                     |
|-----------------|--------------------------|
| `Shift + Enter` | 在 shell 中插入换行      |
| `Shift + Insert`| 从剪贴板粘贴             |

更多快捷键请参见 [config/bindings.lua](./config/bindings.lua)

## 安装

```bash
# 备份原有配置
mv ~/.config/wezterm ~/.config/wezterm.bak

# 克隆本仓库
git clone https://github.com/liangweidonggood/wezterm.git ~/.config/wezterm

# 重启 Wezterm
```

## 目录结构

```
.
├── backdrops/          # 背景图片
├── colors/             # 颜色配置
├── config/             # 配置模块
│   ├── appearance.lua  # 外观配置
│   ├── bindings.lua    # 按键绑定
│   ├── domains.lua     # 域配置(WSL等)
│   ├── fonts.lua       # 字体配置
│   ├── general.lua     # 通用配置
│   ├── init.lua        # 配置入口
│   └── launch.lua      # 启动配置
├── events/             # 事件回调
├── utils/              # 工具函数
└── wezterm.lua         # 主入口
```

## 依赖

- [Wezterm](https://wezfurlong.org/wezterm/) >= 20240203

## 许可证

MIT License
