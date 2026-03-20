-- 导入配置模块
local Config = require('config')

-- 初始化背景效果
require('utils.backdrops')
   -- :set_focus('#000000')  -- 设置背景焦点颜色
   -- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')  -- 设置壁纸目录
   :set_images()  -- 加载背景图片
   :random()  -- 随机选择背景图片

-- 注册各个事件处理器
require('events.left-status').setup()  -- 注册左侧状态栏事件
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })  -- 注册右侧状态栏事件，设置日期格式
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })  -- 注册标签标题事件
require('events.new-tab-button').setup()  -- 注册新建标签按钮事件
require('events.gui-startup').setup()  -- 注册GUI启动事件

-- 构建并返回最终配置
return Config:init()
   :append(require('config.appearance'))  -- 追加外观配置
   :append(require('config.bindings'))  -- 追加按键绑定配置
   :append(require('config.domains'))  -- 追加域名配置
   :append(require('config.fonts'))  -- 追加字体配置
   :append(require('config.general'))  -- 追加通用配置
   :append(require('config.launch')).options  -- 追加启动配置
