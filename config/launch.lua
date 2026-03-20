-- 加载平台检测工具
local platform = require('utils.platform')

-- 初始化启动配置选项
local options = {
   default_prog = {},  -- 默认启动程序
   launch_menu = {},   -- 启动菜单条目
}

-- Windows 平台配置
if platform.is_win then
   -- 默认启动 PowerShell Desktop
   -- options.default_domain = 'wsl:kali-linux'
   options.default_prog = { 'pwsh', '-NoLogo', '-NoExit', '-Command', 'Screenfetch' }
   options.launch_menu = {
      { label = 'PowerShell Core', args = { 'pwsh', '-NoLogo' } },  -- PowerShell Core
      { label = 'PowerShell Desktop', args = { 'powershell' } },    -- PowerShell 桌面版
      { label = 'Command Prompt', args = { 'cmd' } },               -- 命令提示符
      { label = 'Nushell', args = { 'nu' } },                -- Nushell shell
      { label = 'Msys2', args = { 'ucrt64.cmd' } },                -- Msys2 环境
      {
         label = 'Git Bash',
         args = { 'D:\\soft\\dev\\Git\\bin\\bash.exe' },  -- Git Bash
      },
      {
         label = 'WSL: Kali Linux (zsh)',
         domain = { DomainName = 'wsl:kali-linux' },
      },
   }
-- macOS 平台配置
elseif platform.is_mac then
   options.default_prog = { '/opt/homebrew/bin/fish', '-l' }  -- 默认使用 Fish shell
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },    -- Bash shell
      { label = 'Fish', args = { '/opt/homebrew/bin/fish', '-l' } },  -- Fish shell
      { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },  -- Nushell shell
      { label = 'Zsh', args = { 'zsh', '-l' } },      -- Zsh shell
   }
-- Linux 平台配置
elseif platform.is_linux then
   options.default_prog = { 'fish', '-l' }  -- 默认使用 Fish shell
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },    -- Bash shell
      { label = 'Fish', args = { 'fish', '-l' } },    -- Fish shell
      { label = 'Zsh', args = { 'zsh', '-l' } },      -- Zsh shell
   }
end

-- 返回启动配置
return options
