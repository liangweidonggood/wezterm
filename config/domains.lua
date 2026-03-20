local platform = require('utils.platform')

-- 域名配置选项
local options = {
   -- SSH 域名配置
   -- 参考: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {},

   -- Unix 域名配置
   -- 参考: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- WSL 域名配置
   -- 参考: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {},
}

if platform.is_win then
   -- 配置 SSH 域名（仅 Windows 平台）
   options.ssh_domains = {
      {
         name = 'ssh:wsl',          -- 连接名称
         remote_address = 'localhost', -- 远程地址
         multiplexing = 'None',     -- 禁用多路复用
         default_prog = { 'fish', '-l' }, -- 默认使用 fish shell
         assume_shell = 'Posix',    -- 假设使用 Posix  shell
      },
   }

   -- 配置 WSL 域名（仅 Windows 平台）
   options.wsl_domains = {
      {
         name = 'wsl:ubuntu-fish', -- 连接名称
         distribution = 'Ubuntu',  -- WSL 分发版名称
         username = 'kevin',       -- 用户名
         default_cwd = '/home/kevin', -- 默认工作目录
         default_prog = { 'fish', '-l' }, -- 默认使用 fish shell
      },
      {
         name = 'wsl:ubuntu-bash', -- 连接名称
         distribution = 'Ubuntu',  -- WSL 分发版名称
         username = 'kevin',       -- 用户名
         default_cwd = '/home/kevin', -- 默认工作目录
         default_prog = { 'bash', '-l' }, -- 默认使用 bash shell
      },
   }
end

return options
