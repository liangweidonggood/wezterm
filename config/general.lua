-- 常规行为配置
return {
   -- 行为选项
   automatically_reload_config = true,  -- 自动重新加载配置
   exit_behavior = 'CloseOnCleanExit', -- Shell程序成功退出时关闭窗口
   exit_behavior_messaging = 'Verbose', -- 详细的退出信息输出
   status_update_interval = 1000,      -- 状态更新间隔(ms)
   audible_bell = 'Disabled',         -- 禁用响铃

   scrollback_lines = 20000,          -- 滚动缓冲区行数

   -- 超链接匹配规则
   hyperlink_rules = {
      -- 匹配括号中的URL: (URL)
      {
         regex = '\\((\\w+://\\S+)\\)',
         format = '$1',
         highlight = 1,
      },
      -- 匹配方括号中的URL: [URL]
      {
         regex = '\\[(\\w+://\\S+)\\]',
         format = '$1',
         highlight = 1,
      },
      -- 匹配花括号中的URL: {URL}
      {
         regex = '\\{(\\w+://\\S+)\\}',
         format = '$1',
         highlight = 1,
      },
      -- 匹配尖括号中的URL: <URL>
      {
         regex = '<(\\w+://\\S+)>',
         format = '$1',
         highlight = 1,
      },
      -- 处理未被括号包裹的URL
      {
         regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
         format = '$0',
      },
      -- 隐式mailto链接
      {
         regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
         format = 'mailto:$0',
      },
   },
}
