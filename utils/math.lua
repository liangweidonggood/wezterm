-- 数学工具模块
-- 提供常用数学函数：clamp（数值限制）、round（四舍五入）等
local M = {}

-- 数值限制函数：将 x 限制在 [min, max] 范围内
M.clamp = function(x, min, max)
   return x < min and min or (x > max and max or x)
end

-- 四舍五入函数：支持按增量四舍五入
M.round = function(x, increment)
   if increment then
      return M.round(x / increment) * increment
   end
   return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

return M
