local M = {
  coroutine = {},
  debug = {},
  io = {},
  math = {},
  os = {},
  package = {},
  string = {},
  table = {},
}

-- -----------------------------------------------------------------------------
-- Load / Unload
-- -----------------------------------------------------------------------------

function M.load()
  for key, value in pairs(M) do
    local value_type = type(value)

    if value_type == 'function' then
      if key ~= 'load' and key ~= 'unload' then
        _G[key] = value
      end
    elseif value_type == 'table' then
      local library = _G[key]

      if type(library) == 'table' then
        for subkey, subvalue in pairs(value) do
          library[subkey] = subvalue
        end
      end
    end
  end
end

function M.unload()
  for key, value in pairs(M) do
    local value_type = type(value)

    if value_type == 'function' then
      if _G[key] == value then -- only remove values we injected
        _G[key] = nil
      end
    elseif value_type == 'table' then
      local library = _G[key]

      if type(library) == 'table' then
        for subkey, subvalue in pairs(value) do
          if library[subkey] == subvalue then -- only remove values we injected
            library[subkey] = nil
          end
        end
      end
    end
  end
end

-- -----------------------------------------------------------------------------
-- Globals
-- -----------------------------------------------------------------------------

local function _kpairs_iter(a, i)
  local key, value = i, nil

  repeat
    key, value = next(a, key)
  until type(key) ~= 'number'

  return key, value
end

function M.kpairs(t)
  return _kpairs_iter, t, nil
end

-- -----------------------------------------------------------------------------
-- Coroutine
-- -----------------------------------------------------------------------------

-- EMPTY

-- -----------------------------------------------------------------------------
-- Debug
-- -----------------------------------------------------------------------------

-- EMPTY

-- -----------------------------------------------------------------------------
-- IO
-- -----------------------------------------------------------------------------

function M.io.exists(path)
  local file = io.open(path, 'r')

  if file == nil then
    return false
  end

  file:close()

  return true
end

function M.io.readfile(path)
  local file = assert(io.open(path, 'r'))
  local content = assert(file:read('*a'))
  file:close()
  return content
end

function M.io.writefile(path, content)
  local file = assert(io.open(path, 'w'))
  assert(file:write(content))
  file:close()
end

-- -----------------------------------------------------------------------------
-- Math
-- -----------------------------------------------------------------------------

function M.math.clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function M.math.round(x)
  if x < 0 then
    return math.ceil(x - 0.5)
  else
    return math.floor(x + 0.5)
  end
end

function M.math.sign(x)
  if x < 0 then
    return -1
  elseif x > 0 then
    return 1
  else
    return 0
  end
end

-- -----------------------------------------------------------------------------
-- OS
-- -----------------------------------------------------------------------------

function M.os.capture(cmd)
  local file = assert(io.popen(cmd, 'r'))
  local stdout = assert(file:read('*a'))
  file:close()
  return stdout
end

-- -----------------------------------------------------------------------------
-- Package
-- -----------------------------------------------------------------------------

function M.package.cinsert(...)
  local templates = M.package.split(package.cpath)
  table.insert(templates, ...)
  package.cpath = M.package.concat(templates)
end

function M.package.concat(templates, i, j)
  local template_separator = M.string.split(package.config, '\n')[2]
  return table.concat(templates, template_separator, i, j)
end

function M.package.cremove(position)
  local templates = M.package.split(package.cpath)
  local removed = table.remove(templates, position)
  package.cpath = M.package.concat(templates)
  return removed
end

function M.package.insert(...)
  local templates = M.package.split(package.path)
  table.insert(templates, ...)
  package.path = M.package.concat(templates)
end

function M.package.remove(position)
  local templates = M.package.split(package.path)
  local removed = table.remove(templates, position)
  package.path = M.package.concat(templates)
  return removed
end

function M.package.split(path)
  local template_separator = M.string.split(package.config, '\n')[2]
  return M.string.split(path, template_separator)
end

-- -----------------------------------------------------------------------------
-- String
-- -----------------------------------------------------------------------------

local function _string_chars_iter(a, i)
  i = i + 1
  local char = a:sub(i, i)
  if char ~= '' then
    return i, char
  end
end

function M.string.chars(s)
  return _string_chars_iter, s, 0
end

function M.string.escape(s)
  -- Store in local variable to ensure we return only 1 (stylua will remove wrapping parens)
  local escaped = s:gsub('[().%%+%-*?[^$]', '%%%1')
  return escaped
end

function M.string.lpad(s, length, padding)
  padding = padding or ' '
  return padding:rep(math.ceil((length - #s) / #padding)) .. s
end

function M.string.ltrim(s, pattern)
  pattern = pattern or '%s+'
  -- Wrap in parentheses to ensure we return only 1 value.
  return (s:gsub('^' .. pattern, ''))
end

function M.string.pad(s, length, padding)
  padding = padding or ' '
  local num_pads = math.ceil(((length - #s) / #padding) / 2)
  return padding:rep(num_pads) .. s .. padding:rep(num_pads)
end

function M.string.rpad(s, length, padding)
  padding = padding or ' '
  return s .. padding:rep(math.ceil((length - #s) / #padding))
end

function M.string.rtrim(s, pattern)
  pattern = pattern or '%s+'
  -- Store in local variable to ensure we return only 1 (stylua will remove wrapping parens)
  local trimmed = s:gsub(pattern .. '$', '')
  return trimmed
end

function M.string.split(s, separator)
  separator = separator or '%s+'

  local result = {}
  local i, j = s:find(separator)

  while i ~= nil do
    table.insert(result, s:sub(1, i - 1))
    s = s:sub(j + 1) or ''
    i, j = s:find(separator)
  end

  table.insert(result, s)
  return result
end

function M.string.trim(s, pattern)
  pattern = pattern or '%s+'
  return M.string.ltrim(M.string.rtrim(s, pattern), pattern)
end

-- -----------------------------------------------------------------------------
-- Table
-- -----------------------------------------------------------------------------

-- Polyfill `table.pack` and `table.unpack`
if _VERSION == 'Lua 5.1' then
  M.table.pack = function(...) return { n = select('#', ...), ... } end
  M.table.unpack = unpack
end

function M.table.clear(t, callback)
  if type(callback) == 'function' then
    for key, value in M.kpairs(t) do
      if callback(value, key) then
        t[key] = nil
      end
    end

    for i = #t, 1, -1 do
      if callback(t[i], i) then
        table.remove(t, i)
      end
    end
  else
    for key, value in M.kpairs(t) do
      if value == callback then
        t[key] = nil
      end
    end

    for i = #t, 1, -1 do
      if t[i] == callback then
        table.remove(t, i)
      end
    end
  end
end

function M.table.collect(...)
  local result = {}

  for key, value in ... do
    if value == nil then
      table.insert(result, key)
    else
      result[key] = value
    end
  end

  return result
end

function M.table.deepcopy(t)
  local result = {}

  for key, value in pairs(t) do
    if type(value) == 'table' then
      result[key] = M.table.deepcopy(value)
    else
      result[key] = value
    end
  end

  return result
end

function M.table.empty(t)
  return next(t) == nil
end

function M.table.filter(t, callback)
  local result = {}

  for key, value in pairs(t) do
    if callback(value, key) then
      if type(key) == 'number' then
        table.insert(result, value)
      else
        result[key] = value
      end
    end
  end

  return result
end

function M.table.find(t, callback)
  if type(callback) == 'function' then
    for key, value in pairs(t) do
      if callback(value, key) then
        return value, key
      end
    end
  else
    for key, value in pairs(t) do
      if value == callback then
        return value, key
      end
    end
  end
end

function M.table.has(t, callback)
  local _, key = M.table.find(t, callback)
  return key ~= nil
end

function M.table.keys(t)
  local result = {}

  for key in pairs(t) do
    table.insert(result, key)
  end

  return result
end

function M.table.map(t, callback)
  local result = {}

  for key, value in pairs(t) do
    local newValue, newKey = callback(value, key)

    if newKey ~= nil then
      result[newKey] = newValue
    elseif type(key) == 'number' then
      table.insert(result, newValue)
    else
      result[key] = newValue
    end
  end

  return result
end

function M.table.merge(t, ...)
  for _, _t in pairs({ ... }) do
    for key, value in pairs(_t) do
      if type(key) == 'number' then
        table.insert(t, value)
      else
        t[key] = value
      end
    end
  end
end

function M.table.reduce(t, initial, callback)
  local result = initial

  for key, value in pairs(t) do
    result = callback(result, value, key)
  end

  return result
end

function M.table.reverse(t)
  local len = #t

  for i = 1, math.floor(len / 2) do
    t[i], t[len - i + 1] = t[len - i + 1], t[i]
  end
end

function M.table.shallowcopy(t)
  local result = {}

  for key, value in pairs(t) do
    result[key] = value
  end

  return result
end

function M.table.slice(t, i, j)
  local len = #t

  i = i or 1
  j = j or len

  local result = {}

  if i < 0 then i = i + len + 1 end
  if j < 0 then j = j + len + 1 end

  for k = math.max(i, 0), math.min(j, len) do
    table.insert(result, t[k])
  end

  return result
end

function M.table.values(t)
  local result = {}

  for _, value in pairs(t) do
    table.insert(result, value)
  end

  return result
end

-- -----------------------------------------------------------------------------
-- Library Metatables
--
-- Set library metatables. We must do this at the end, since our libraries will
-- effectively be frozen once the `__newindex` metamethod is set.
-- -----------------------------------------------------------------------------

setmetatable(M.coroutine, { __index = coroutine, __newindex = coroutine })
setmetatable(M.debug, { __index = debug, __newindex = debug })
setmetatable(M.io, { __index = io, __newindex = io })
setmetatable(M.math, { __index = math, __newindex = math })
setmetatable(M.os, { __index = os, __newindex = os })
setmetatable(M.package, { __index = package, __newindex = package })
setmetatable(M.string, { __index = string, __newindex = string })
setmetatable(M.table, { __index = table, __newindex = table })

-- -----------------------------------------------------------------------------
-- Return
-- -----------------------------------------------------------------------------

return M
