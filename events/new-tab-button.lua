-- 导入 wezterm 模块
local wezterm = require('wezterm')
-- 导入启动菜单配置
local launch_menu = require('config.launch').launch_menu
-- 导入域名配置
local domains = require('config.domains')
-- 导入单元格工具模块
local Cells = require('utils.cells')

-- 别名定义：nerdfonts
local nf = wezterm.nerdfonts
-- 别名定义：wezterm 动作
local act = wezterm.action
-- 别名定义：单元格属性工具
local attr = Cells.attr

-- 模块定义
local M = {}

-- 颜色配置表
---@type table<string, Cells.SegmentColors>
-- stylua: ignore
local colors = {
   label_text   = { fg = '#CDD6F4' },  -- 标签文本颜色
   icon_default = { fg = '#89B4FA' }, -- 默认图标颜色
   icon_wsl     = { fg = '#FAB387' }, -- WSL 图标颜色
   icon_ssh     = { fg = '#F38BA8' }, -- SSH 图标颜色
   icon_unix    = { fg = '#CBA6F7' }, -- Unix 图标颜色
}

-- 创建单元格显示样式
local cells = Cells:new()
   :add_segment('icon_default', ' ' .. nf.oct_terminal .. ' ', colors.icon_default)  -- 默认终端图标
   :add_segment('icon_wsl', ' ' .. nf.cod_terminal_linux .. ' ', colors.icon_wsl)  -- WSL 图标
   :add_segment('icon_ssh', ' ' .. nf.md_ssh .. ' ', colors.icon_ssh)  -- SSH 图标
   :add_segment('icon_unix', ' ' .. nf.dev_gnu .. ' ', colors.icon_unix)  -- Unix 图标
   :add_segment('label_text', '', colors.label_text, attr(attr.intensity('Bold')))  -- 标签文本

-- 构建标签页选择项
local function build_choices()
   local choices = {}
   local choices_data = {}
   local idx = 1

   -- 添加启动菜单选项 (DefaultDomain)
   for _, v in ipairs(launch_menu) do
      cells:update_segment_text('label_text', v.label)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_default', 'label_text' })),
      })
      table.insert(choices_data, {
         args = v.args,
         domain = 'DefaultDomain',
      })
      idx = idx + 1
   end

   -- 添加 WSL 域选项
   for _, v in ipairs(domains.wsl_domains) do
      cells:update_segment_text('label_text', v.name)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_wsl', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- 添加 SSH 域选项
   for _, v in ipairs(domains.ssh_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_ssh', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- 添加 Unix 域选项
   for _, v in ipairs(domains.unix_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_unix', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   return choices, choices_data
end

-- 预构建选择项
local choices, choices_data = build_choices()

-- 设置模块
M.setup = function()
   -- 监听新建标签页按钮点击事件
   wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
      -- 左键点击：执行默认动作
      if default_action and button == 'Left' then
         window:perform_action(default_action, pane)
      end

      -- 右键点击：显示启动菜单选择器
      if default_action and button == 'Right' then
         window:perform_action(
            act.InputSelector({
               title = 'InputSelector: Launch Menu',
               choices = choices,
               fuzzy = true,
               fuzzy_description = nf.md_rocket .. ' Select a lauch item: ',
               action = wezterm.action_callback(function(_window, _pane, id, label)
                  -- 未选择任何项则返回
                  if not id and not label then
                     return
                  else
                     -- 记录选中的项
                     wezterm.log_info('you selected ', id, label)
                     wezterm.log_info(choices_data[tonumber(id)])
                     -- 在新标签页中执行选中的命令
                     window:perform_action(
                        act.SpawnCommandInNewTab(choices_data[tonumber(id)]),
                        pane
                     )
                  end
               end),
            }),
            pane
         )
      end
      -- 返回 false 表示不阻止默认行为
      return false
   end)
end

-- 导出模块
return M
