-- 配置选项验证工具模块
-- 提供类型化的配置选项验证功能

-- 布尔类型选项定义
---@class Opt.boolean
---@field name string          -- 选项名称
---@field type 'boolean'       -- 选项类型
---@field default boolean      -- 默认值
---@field required? boolean    -- 是否必填（可选）

-- 数字类型选项定义
---@class Opt.number
---@field name string          -- 选项名称
---@field type 'number'        -- 选项类型
---@field default number       -- 默认值
---@field required? boolean    -- 是否必填（可选）
---@field enum? number[]       -- 可选值枚举（可选）

-- 字符串类型选项定义
---@class Opt.string
---@field name string          -- 选项名称
---@field type 'string'        -- 选项类型
---@field default string       -- 默认值
---@field required? boolean    -- 是否必填（可选）
---@field enum? string[]       -- 可选值枚举（可选）

-- 表格类型选项定义
---@class Opt.table
---@field name string                -- 选项名称
---@field type 'table'               -- 选项类型
---@field table_of 'string' | 'number' | 'boolean'  -- 表格元素类型
---@field default table              -- 默认值
---@field required? boolean          -- 是否必填（可选）

-- 选项 schema 类型定义
---@alias OptsSchema (Opt.boolean | Opt.number | Opt.string | Opt.table)[]

-- 检查表格是否包含指定值
---@param tbl table  -- 要检查的表格
---@param value any  -- 要查找的值
---@return boolean   -- 如果找到值则返回 true，否则返回 false
local function tbl_contains(tbl, value)
   for _, v in ipairs(tbl) do
      if v == value then
         return true
      end
   end
   return false
end

-- 验证选项 schema 的合法性
---@param schema OptsSchema  -- 要验证的选项 schema
local function validate_opts_schema(schema)
   local field_names = {}

   -- 遍历 schema 中的每个选项
   for _, opt in ipairs(schema) do
      -- 验证选项名称必须是字符串
      assert(type(opt.name) == 'string', 'name must be a string')
      -- 验证选项名称必须唯一
      assert(not tbl_contains(field_names, opt.name), 'name must be unique')
      -- 验证 required 字段必须是布尔值或 nil
      assert(
         type(opt.required) == 'boolean' or type(opt.required) == 'nil',
         'required must be a boolean'
      )
      -- 验证类型必须是支持的类型之一
      assert(
         opt.type == 'boolean'
            or opt.type == 'number'
            or opt.type == 'string'
            or opt.type == 'table',
         'type must be one of boolean, number, string, table'
      )
      -- 验证类型字段必须是字符串
      assert(type(opt.type) == 'string', 'type must be a string')
      -- 验证默认值类型与选项类型一致
      assert(type(opt.default) == opt.type, 'default must be a ' .. opt.type)

      -- 如果是表格类型选项，额外验证 table_of 字段
      if opt.type == 'table' then
         assert(type(opt.table_of) == 'string', 'table_of must be a string')
         assert(
            opt.table_of == 'string' or opt.table_of == 'number' or opt.table_of == 'boolean',
            'table_of must be one of string, number, boolean'
         )
         -- 验证默认表格中的所有值都符合 table_of 类型
         for _, v in ipairs(opt.default) do
            assert(type(v) == opt.table_of, 'table values must be ' .. opt.table_of)
         end
      end

      -- 如果有枚举值限制，验证枚举值
      if opt.enum then
         assert(type(opt.enum) == 'table', 'enum must be a table')
         -- 验证每个枚举值的类型都与选项类型一致
         for _, v in ipairs(opt.enum) do
            assert(type(v) == opt.type, 'enum values must be ' .. opt.type)
         end
      end
   end
end

-- 选项验证器类定义
---@class OptsValidator
---@field schema OptsSchema  -- 验证使用的 schema
local OptsValidator = {}
OptsValidator.__index = OptsValidator

-- 创建一个新的选项验证器实例
---@param schema OptsSchema  -- 验证使用的 schema
---@return OptsValidator
function OptsValidator:new(schema)
   validate_opts_schema(schema)
   local event_opts = { schema = schema }
   return setmetatable(event_opts, self)
end

-- 根据 schema 验证选项
-- 如果选项有效，返回验证后的选项和 nil
-- 如果字段无效，返回默认值和错误信息
---@generic T
---@param opts T  -- 要验证的选项
---@return T      -- 验证后的选项（包含默认值）
---@return string|nil  -- 错误信息（如果有错误）
function OptsValidator:validate(opts)
   local errors = {}  -- 错误信息列表
   local valid_opts = {}  -- 验证通过的选项

   -- 遍历 schema 中的每个选项进行验证
   for _, opt in ipairs(self.schema) do
      local value = opts[opt.name]
      local error = false

      -- 处理值为 nil 的情况
      if value == nil then
         -- 如果选项是必填的，记录错误
         if opt.required then
            table.insert(errors, string.format('Field "%s" is required', opt.name))
            error = true
         end
      end

      -- 使用默认值
      if value == nil then
         valid_opts[opt.name] = opt.default
         goto continue
      end

      -- 验证值的类型是否正确
      if type(value) ~= opt.type then
         table.insert(errors, string.format('Field "%s" must of type "%s"', opt.name, opt.type))
         error = true
      end

      -- 如果有枚举值限制，验证值是否在枚举中
      if
         (opt.type == 'string' or opt.type == 'number')
         and opt.enum ~= nil
         and not tbl_contains(opt.enum, value)
      then
         table.insert(
            errors,
            string.format('Field "%s" must be one of [%s]', opt.name, table.concat(opt.enum, ', '))
         )
         error = true
      end

      -- 表格类型选项的额外验证
      if opt.type == 'table' then
         -- 验证表格中的每个元素类型
         for _, v in ipairs(value) do
            if type(v) ~= opt.table_of then
               table.insert(
                  errors,
                  string.format('Items in field "%s" must be of type "%s"', opt.name, opt.table_of)
               )
               error = true
               goto inner_continue
            end
         end
         ::inner_continue::
      end

      -- 如果有错误，使用默认值
      if error then
         valid_opts[opt.name] = opt.default
         goto continue
      end

      -- 验证通过，使用提供的值
      valid_opts[opt.name] = value
      ::continue::
   end

   -- 如果有错误，返回错误信息
   if #errors > 0 then
      local err_msg = '\n~~EventOpts ERRORS~~\n'
      for _, err in ipairs(errors) do
         err_msg = err_msg .. '- ' .. err .. '\n'
      end
      return valid_opts, err_msg
   end

   -- 没有错误，返回验证后的选项
   return valid_opts, nil
end

-- 导出选项验证器类
return OptsValidator
