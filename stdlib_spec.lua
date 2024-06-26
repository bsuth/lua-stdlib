local stdlib = require('stdlib')

-- busted loads penlight's `compat` module, which injects its own `table.pack`
-- and `table.unpack` polyfills. We unset them here to make sure they don't
-- interfere with our tests.
if _VERSION == 'Lua 5.1' then
  table.pack = nil
  table.unpack = nil
end

-- -----------------------------------------------------------------------------
-- Helpers
-- -----------------------------------------------------------------------------

local function any_sort(a, b)
  if type(a) == type(b) then
    return a < b
  else
    return type(a) < type(b)
  end
end

-- -----------------------------------------------------------------------------
-- Top Level
-- -----------------------------------------------------------------------------

spec('compare', function()
  assert.are.equal(true, stdlib.compare({}, {}))

  assert.are.equal(true, stdlib.compare({ 10 }, { 10 }))
  assert.are.equal(false, stdlib.compare({ 10, 20 }, { 10 }))
  assert.are.equal(false, stdlib.compare({ 10 }, { 10, 20 }))

  assert.are.equal(true, stdlib.compare({ a = 'a' }, { a = 'a' }))
  assert.are.equal(false, stdlib.compare({ a = 'a', b = 'b' }, { a = 'a' }))
  assert.are.equal(false, stdlib.compare({ a = 'a' }, { a = 'a', b = 'b' }))

  assert.are.equal(true, stdlib.compare({ a = 'a', 10 }, { a = 'a', 10 }))
  assert.are.equal(false, stdlib.compare({ a = 'a', 10, 20 }, { a = 'a', 10 }))
  assert.are.equal(false, stdlib.compare({ a = 'a', 10 }, { a = 'a', 10, 20 }))
  assert.are.equal(false, stdlib.compare({ a = 'a', b = 'b', 10 }, { a = 'a', 10 }))
  assert.are.equal(false, stdlib.compare({ a = 'a', 10 }, { a = 'a', b = 'b', 10 }))
end)

spec('kpairs', function()
  local function assert_kpairs(expected, t)
    local result = {}

    for key, value in stdlib.kpairs(t) do
      result[key] = value
    end

    assert.are.same(expected, result)
  end

  assert_kpairs({}, {})
  assert_kpairs({}, { 'hello', 'world' })
  assert_kpairs(
    { mykey = 'hello', myotherkey = 'world' },
    { mykey = 'hello', myotherkey = 'world' }
  )
  assert_kpairs(
    { mykey = 'hello', myotherkey = 'world' },
    { mykey = 'hello', myotherkey = 'world', 'hello', 'world' }
  )
end)

-- -----------------------------------------------------------------------------
-- Coroutine
-- -----------------------------------------------------------------------------

spec('coroutine', function()
  assert.is_table(stdlib.coroutine)
  for key in pairs(coroutine) do -- make sure we are not overriding native methods
    assert.are.equal(coroutine[key], stdlib.coroutine[key])
  end
end)

-- -----------------------------------------------------------------------------
-- Debug
-- -----------------------------------------------------------------------------

spec('debug', function()
  assert.is_table(stdlib.debug)
  for key in pairs(debug) do -- make sure we are not overriding native methods
    assert.are.equal(debug[key], stdlib.debug[key])
  end
end)

-- -----------------------------------------------------------------------------
-- IO
-- -----------------------------------------------------------------------------

spec('io', function()
  assert.is_table(stdlib.io)
  for key in pairs(io) do -- make sure we are not overriding native methods
    assert.are.equal(io[key], stdlib.io[key])
  end
end)

spec('io.exists', function()
  assert.are.equal(true, stdlib.io.exists('mock/empty_file'))
  assert.are.equal(true, stdlib.io.exists('mock/empty_dir'))
  assert.are.equal(false, stdlib.io.exists('mock/fake_file'))
end)

spec('io.readfile', function()
  assert.are.equal('', stdlib.io.readfile('mock/empty_file'))
  assert.are.equal('first line\n', stdlib.io.readfile('mock/single_line_file'))
  assert.are.equal('first line\nsecond line\n', stdlib.io.readfile('mock/multi_line_file'))

  assert.has_error(function() stdlib.io.readfile('mock/empty_dir') end)
  assert.has_error(function() stdlib.io.readfile('mock/fake_file') end)
end)

spec('io.writefile', function()
  local function assert_writefile(content)
    stdlib.io.writefile('mock/io_writefile', content)
    assert.are.equal(content, stdlib.io.readfile('mock/io_writefile'))
  end

  assert_writefile('')
  assert_writefile('first line')
  assert_writefile('first line\nsecond line')

  assert.has_error(function() stdlib.io.writefile('mock/empty_dir', '') end)
  assert.has_error(function() stdlib.io.writefile('mock/fake_dir/empty_file', '') end)
end)

-- -----------------------------------------------------------------------------
-- Math
-- -----------------------------------------------------------------------------

spec('math', function()
  assert.is_table(stdlib.math)
  for key in pairs(math) do -- make sure we are not overriding native methods
    assert.are.equal(math[key], stdlib.math[key])
  end
end)

spec('math.clamp', function()
  assert.are.equal(0, stdlib.math.clamp(0, 0, 1))
  assert.are.equal(0.5, stdlib.math.clamp(0.5, 0, 1))
  assert.are.equal(0, stdlib.math.clamp(-0.5, 0, 1))
  assert.are.equal(1, stdlib.math.clamp(1.5, 0, 1))
end)

spec('math.round', function()
  assert.are.equal(-1, stdlib.math.round(-1))
  assert.are.equal(-1, stdlib.math.round(-0.9))
  assert.are.equal(-1, stdlib.math.round(-0.51))
  assert.are.equal(-1, stdlib.math.round(-0.5))
  assert.are.equal(0, stdlib.math.round(-0.49))
  assert.are.equal(0, stdlib.math.round(-0.1))
  assert.are.equal(0, stdlib.math.round(0))
  assert.are.equal(0, stdlib.math.round(0.1))
  assert.are.equal(0, stdlib.math.round(0.49))
  assert.are.equal(1, stdlib.math.round(0.5))
  assert.are.equal(1, stdlib.math.round(0.51))
  assert.are.equal(1, stdlib.math.round(0.9))
  assert.are.equal(1, stdlib.math.round(1))
end)

-- -----------------------------------------------------------------------------
-- OS
-- -----------------------------------------------------------------------------

spec('os', function()
  assert.is_table(stdlib.os)
  for key in pairs(os) do -- make sure we are not overriding native methods
    assert.are.equal(os[key], stdlib.os[key])
  end
end)

spec('os.capture', function()
  assert.are.equal('hello world', stdlib.os.capture('printf "hello world"'))
  assert.are.equal('hello world\n', stdlib.os.capture('echo hello world'))
end)

-- -----------------------------------------------------------------------------
-- Package
-- -----------------------------------------------------------------------------

spec('package', function()
  assert.is_table(stdlib.package)
  for key in pairs(package) do -- make sure we are not overriding native methods
    assert.are.equal(package[key], stdlib.package[key])
  end
end)

-- -----------------------------------------------------------------------------
-- String
-- -----------------------------------------------------------------------------

spec('string', function()
  assert.is_table(stdlib.string)
  for key in pairs(string) do -- make sure we are not overriding native methods
    assert.are.equal(string[key], stdlib.string[key])
  end
end)

spec('string.chars', function()
  local function assert_chars(s)
    local chars = {}

    for _, char in stdlib.string.chars(s) do
      table.insert(chars, char)
    end

    assert.are.equal(s, table.concat(chars))
  end

  assert_chars('')
  assert_chars('hello world')
end)

spec('string.escape', function()
  assert.are.equal('a', stdlib.string.escape('a'))
  assert.are.equal('1', stdlib.string.escape('1'))
  assert.are.equal(',', stdlib.string.escape(','))

  assert.are.equal('%%', stdlib.string.escape('%'))
  assert.are.equal('%(', stdlib.string.escape('('))
  assert.are.equal('%)', stdlib.string.escape(')'))
  assert.are.equal('%.', stdlib.string.escape('.'))
  assert.are.equal('%*', stdlib.string.escape('*'))
  assert.are.equal('%?', stdlib.string.escape('?'))
  assert.are.equal('%[', stdlib.string.escape('['))
  assert.are.equal('%^', stdlib.string.escape('^'))
  assert.are.equal('%$', stdlib.string.escape('$'))
  assert.are.equal('%+', stdlib.string.escape('+'))
  assert.are.equal('%-', stdlib.string.escape('-'))

  assert.are.equal('a%%', stdlib.string.escape('a%'))
  assert.are.equal('a%(', stdlib.string.escape('a('))
  assert.are.equal('a%)', stdlib.string.escape('a)'))
  assert.are.equal('a%.', stdlib.string.escape('a.'))
  assert.are.equal('a%*', stdlib.string.escape('a*'))
  assert.are.equal('a%?', stdlib.string.escape('a?'))
  assert.are.equal('a%[', stdlib.string.escape('a['))
  assert.are.equal('a%^', stdlib.string.escape('a^'))
  assert.are.equal('a%$', stdlib.string.escape('a$'))
  assert.are.equal('a%+', stdlib.string.escape('a+'))
  assert.are.equal('a%-', stdlib.string.escape('a-'))

  assert.are.equal('%%%%', stdlib.string.escape('%%'))
  assert.are.equal('%%%(', stdlib.string.escape('%('))
  assert.are.equal('%%%)', stdlib.string.escape('%)'))
  assert.are.equal('%%%.', stdlib.string.escape('%.'))
  assert.are.equal('%%%*', stdlib.string.escape('%*'))
  assert.are.equal('%%%?', stdlib.string.escape('%?'))
  assert.are.equal('%%%[', stdlib.string.escape('%['))
  assert.are.equal('%%%^', stdlib.string.escape('%^'))
  assert.are.equal('%%%$', stdlib.string.escape('%$'))
  assert.are.equal('%%%+', stdlib.string.escape('%+'))
  assert.are.equal('%%%-', stdlib.string.escape('%-'))

  assert.are.equal('%(%[%(%[', stdlib.string.escape('([(['))
  assert.are.equal('%.%.%.', stdlib.string.escape('...'))
end)

spec('string.split', function()
  assert.are.same({ '' }, stdlib.string.split(''))

  assert.are.same({ 'a', 'b', 'c' }, stdlib.string.split('a b c'))
  assert.are.same({ 'a', 'b', 'c' }, stdlib.string.split('a  b \tc'))

  assert.are.same({ '', 'a' }, stdlib.string.split(' a'))
  assert.are.same({ 'a', '' }, stdlib.string.split('a '))
  assert.are.same({ '', 'a', '' }, stdlib.string.split(' a '))

  assert.are.same({ ' ', ' ' }, stdlib.string.split(' a ', '%a+'))
  assert.are.same({ 'hello', 'world' }, stdlib.string.split('hello11world', '%d+'))
end)

spec('string.trim', function()
  assert.are.equal('hello', stdlib.string.trim('hello'))

  assert.are.equal('hello', stdlib.string.trim('hello '))
  assert.are.equal('hello', stdlib.string.trim(' hello'))
  assert.are.equal('hello', stdlib.string.trim(' hello '))
  assert.are.equal('hello', stdlib.string.trim('hello  '))
  assert.are.equal('hello', stdlib.string.trim('  hello'))
  assert.are.equal('hello', stdlib.string.trim('  hello  '))

  assert.are.equal('hello', stdlib.string.trim('hello\t'))
  assert.are.equal('hello', stdlib.string.trim('\thello'))
  assert.are.equal('hello', stdlib.string.trim('\thello\t'))
  assert.are.equal('hello', stdlib.string.trim('hello\t\t'))
  assert.are.equal('hello', stdlib.string.trim('\t\thello'))
  assert.are.equal('hello', stdlib.string.trim('\t\thello\t\t'))

  assert.are.equal('hello', stdlib.string.trim('hello\n'))
  assert.are.equal('hello', stdlib.string.trim('\nhello'))
  assert.are.equal('hello', stdlib.string.trim('\nhello\n'))
  assert.are.equal('hello', stdlib.string.trim('hello\n\n'))
  assert.are.equal('hello', stdlib.string.trim('\n\nhello'))
  assert.are.equal('hello', stdlib.string.trim('\n\nhello\n\n'))

  assert.are.equal('hello', stdlib.string.trim('hello\t\n'))
  assert.are.equal('hello', stdlib.string.trim('\t\nhello'))
  assert.are.equal('hello', stdlib.string.trim('\t\nhello\t\n'))

  assert.are.equal('hello', stdlib.string.trim('hellox', 'x+'))
  assert.are.equal('hello', stdlib.string.trim('xhello', 'x+'))
  assert.are.equal('hello', stdlib.string.trim('xhellox', 'x+'))
  assert.are.equal('hello', stdlib.string.trim('helloxx', 'x+'))
  assert.are.equal('hello', stdlib.string.trim('xxhello', 'x+'))
  assert.are.equal('hello', stdlib.string.trim('xxhelloxx', 'x+'))
end)

-- -----------------------------------------------------------------------------
-- Table
-- -----------------------------------------------------------------------------

spec('table', function()
  assert.is_table(stdlib.table)
  for key in pairs(table) do -- make sure we are not overriding native methods
    assert.are.equal(table[key], stdlib.table[key])
  end
end)

spec('table.assign', function()
  local function assert_assign(expected, target, ...)
    stdlib.table.assign(target, ...)
    assert.are.same(expected, target)
  end

  assert_assign({}, {})

  assert_assign({ a = 1 }, {}, { a = 1 })
  assert_assign({ a = 2 }, {}, { a = 1 }, { a = 2 })
  assert_assign({ a = 1, b = 2 }, {}, { a = 1 }, { b = 2 })
  assert_assign({ a = 2 }, { a = 1 }, { a = 2 })
  assert_assign({ a = 1, b = 2 }, { a = 1 }, { b = 2 })
  assert_assign({ a = 1, b = 2, c = 3 }, { a = 1, c = 3 }, { b = 2 })

  assert_assign({ 10 }, { 10 })
  assert_assign({ 10 }, {}, { 10 })
  assert_assign({ 10, 20, 30 }, { 10, 20 }, { 30 })
  assert_assign({ 10, 20, 30 }, { 10, 20 }, {}, { 30 })
  assert_assign({ 10, 20, 30 }, { 10 }, { 20 }, { 30 })
end)

spec('table.clear', function()
  local function assert_clear(expected, t, callback)
    stdlib.table.clear(t, callback)
    assert.are.same(expected, t)
  end

  assert_clear({ 10, 20, 30 }, { 10, 20, 30 }, 0)
  assert_clear({ 20, 30 }, { 10, 20, 30 }, 10)
  assert_clear({ 10, 30 }, { 10, 20, 30 }, 20)
  assert_clear({ 10, 20 }, { 10, 20, 30 }, 30)

  assert_clear({ a = 10, b = 20, c = 30 }, { a = 10, b = 20, c = 30 }, 0)
  assert_clear({ b = 20, c = 30 }, { a = 10, b = 20, c = 30 }, 10)
  assert_clear({ a = 10, c = 30 }, { a = 10, b = 20, c = 30 }, 20)
  assert_clear({ a = 10, b = 20 }, { a = 10, b = 20, c = 30 }, 30)

  assert_clear({ 10, 30 }, { 10, 20, 20, 30 }, 20)
  assert_clear({ c = 20 }, { a = 10, b = 10, c = 20 }, 10)

  assert_clear({ 10, 20, 30 }, { 10, 20, 30 }, function(value) return value < 10 end)
  assert_clear({ 20, 30 }, { 10, 20, 30 }, function(value) return value < 20 end)
  assert_clear({ 30 }, { 10, 20, 30 }, function(value) return value < 30 end)
  assert_clear({}, { 10, 20, 30 }, function(value) return value < 40 end)

  assert_clear({ a = 10, b = 20, c = 30 }, { a = 10, b = 20, c = 30 }, function(value) return value < 10 end)
  assert_clear({ b = 20, c = 30 }, { a = 10, b = 20, c = 30 }, function(value) return value < 20 end)
  assert_clear({ c = 30 }, { a = 10, b = 20, c = 30 }, function(value) return value < 30 end)
  assert_clear({}, { a = 10, b = 20, c = 30 }, function(value) return value < 40 end)

  assert_clear({ b = 20, c = 30 }, { a = 10, b = 20, c = 30 }, function(_, key) return key == 'a' end)
  assert_clear({ a = 10, c = 30 }, { a = 10, b = 20, c = 30 }, function(_, key) return key == 'b' end)
  assert_clear({ a = 10, b = 20 }, { a = 10, b = 20, c = 30 }, function(_, key) return key == 'c' end)
end)

spec('table.collect', function()
  assert.are.same(
    { a = 1, b = 2, 10, 20, 30 },
    stdlib.table.collect(pairs({ a = 1, b = 2, 10, 20, 30 }))
  )

  assert.are.same(
    { 10, 20, 30 },
    stdlib.table.collect(ipairs({ a = 1, b = 2, 10, 20, 30 }))
  )

  assert.are.same(
    { a = 1, b = 2 },
    stdlib.table.collect(stdlib.kpairs({ a = 1, b = 2, 10, 20, 30 }))
  )

  local function value_iter(t)
    local next_key = nil

    local function value_iter_next()
      local new_next_key, value = next(t, next_key)
      next_key = new_next_key
      return value
    end

    return value_iter_next, t, nil
  end

  local value_iter_expected = { 10, 20, 30, 'hello', 'world' }
  local value_iter_got = stdlib.table.collect(value_iter({ a = 'hello', b = 'world', 10, 20, 30 }))

  table.sort(value_iter_expected, any_sort)
  table.sort(value_iter_got, any_sort)

  assert.are.same(value_iter_expected, value_iter_got)
end)

spec('table.deepcopy', function()
  local function assert_deepcopy(t, copy)
    copy = copy or stdlib.table.deepcopy(t)

    assert.are_not.equal(t, copy)
    assert.are.same(t, copy)

    for key, value in pairs(t) do
      if type(value) == 'table' then
        assert_deepcopy(value, copy[key])
      end
    end
  end

  assert_deepcopy({})
  assert_deepcopy({ 1, 2, 3 })
  assert_deepcopy({ a = 1, b = 2, c = 3 })
  assert_deepcopy({ a = 1, 'hello' })
  assert_deepcopy({ a = 1, b = 2, 'hello', 'world' })
  assert_deepcopy({ { 'hello' } })
  assert_deepcopy({ a = { 'hello' } })
  assert_deepcopy({ a = { 'hello' }, { 'world' } })
end)

spec('table.filter', function()
  assert.are.same({}, stdlib.table.filter({}, function() return false end))
  assert.are.same({}, stdlib.table.filter({}, function() return true end))
  assert.are.same({}, stdlib.table.filter({ 1, 2, 3 }, function() return false end))
  assert.are.same({ 1, 2, 3 }, stdlib.table.filter({ 1, 2, 3 }, function() return true end))
  assert.are.same({}, stdlib.table.filter({ a = 1, b = 2 }, function() return false end))
  assert.are.same({ a = 1, b = 2 }, stdlib.table.filter({ a = 1, b = 2 }, function() return true end))
  assert.are.same({ 1, 2 }, stdlib.table.filter({ 1, 2, 3 }, function(value) return value < 3 end))
  assert.are.same({ 3 }, stdlib.table.filter({ 1, 2, 3 }, function(value) return value > 2 end))
  assert.are.same({ a = 1 }, stdlib.table.filter({ a = 1, b = 2 }, function(value) return value < 2 end))
  assert.are.same({ b = 2 }, stdlib.table.filter({ a = 1, b = 2 }, function(value) return value > 1 end))
  assert.are.same({ a = 1 }, stdlib.table.filter({ a = 1, b = 2 }, function(_, key) return key == 'a' end))
end)

spec('table.find', function()
  local function assert_find(expected_key, t, callback)
    local value, key = stdlib.table.find(t, callback)
    assert.are.equal(expected_key, key)
    assert.are.equal(t[expected_key], value)
  end

  assert_find(1, { 'a', 'b', 'c' }, 'a')
  assert_find(2, { 'a', 'b', 'c' }, 'b')
  assert_find(3, { 'a', 'b', 'c' }, 'c')
  assert_find(nil, { 'a', 'b', 'c' }, 'd')

  assert_find('a', { a = 'x', b = 'y', c = 'z' }, 'x')
  assert_find('b', { a = 'x', b = 'y', c = 'z' }, 'y')
  assert_find('c', { a = 'x', b = 'y', c = 'z' }, 'z')
  assert_find(nil, { a = 'x', b = 'y', c = 'z' }, 'w')

  assert_find(1, { 30, 20, 10 }, function(value) return value < 40 end)
  assert_find(2, { 30, 20, 10 }, function(value) return value < 30 end)
  assert_find(3, { 30, 20, 10 }, function(value) return value < 20 end)

  assert_find('a', { a = 10 }, function(value) return value < 20 end)
  assert_find(nil, { a = 20 }, function(value) return value < 20 end)
end)

spec('table.has', function()
  assert.are.equal(true, stdlib.table.has({ 'a', 'b', 'c' }, 'a'))

  assert.are.equal(true, stdlib.table.has({ 'a', 'b', 'c' }, 'a'))
  assert.are.equal(true, stdlib.table.has({ 'a', 'b', 'c' }, 'b'))
  assert.are.equal(true, stdlib.table.has({ 'a', 'b', 'c' }, 'c'))
  assert.are.equal(false, stdlib.table.has({ 'a', 'b', 'c' }, 'd'))

  assert.are.equal(true, stdlib.table.has({ a = 'x', b = 'y', c = 'z' }, 'x'))
  assert.are.equal(true, stdlib.table.has({ a = 'x', b = 'y', c = 'z' }, 'y'))
  assert.are.equal(true, stdlib.table.has({ a = 'x', b = 'y', c = 'z' }, 'z'))
  assert.are.equal(false, stdlib.table.has({ a = 'x', b = 'y', c = 'z' }, 'w'))

  assert.are.equal(true, stdlib.table.has({ 30, 20, 10 }, function(value) return value < 40 end))
  assert.are.equal(true, stdlib.table.has({ 30, 20, 10 }, function(value) return value < 30 end))
  assert.are.equal(true, stdlib.table.has({ 30, 20, 10 }, function(value) return value < 20 end))
  assert.are.equal(false, stdlib.table.has({ 30, 20, 10 }, function(value) return value < 10 end))

  assert.are.equal(true, stdlib.table.has({ a = 10 }, function(value) return value < 20 end))
  assert.are.equal(false, stdlib.table.has({ a = 20 }, function(value) return value < 20 end))
end)

spec('table.keys', function()
  local function assert_keys(expected, t)
    local keys = stdlib.table.keys(t)
    table.sort(expected, any_sort)
    table.sort(keys, any_sort)
    assert.are.same(expected, keys)
  end

  assert_keys({}, {})
  assert_keys({ 1 }, { 'a' })
  assert_keys({ 1, 2 }, { 'a', 'b' })
  assert_keys({ 'a' }, { a = 10 })
  assert_keys({ 'a', 'b' }, { a = 10, b = 20 })
  assert_keys({ 1, 'b' }, { 'a', b = 10 })
end)

spec('table.map', function()
  assert.are.same({}, stdlib.table.map({}, function() return true end))
  assert.are.same({}, stdlib.table.map({ 1, 2, 3 }, function() return nil end))

  assert.are.same({ 0, 10, 20 }, stdlib.table.map({ 0, 1, 2 }, function(value) return 10 * value end))
  assert.are.same({ a = 10, b = 20 }, stdlib.table.map({ a = 1, b = 2 }, function(value) return 10 * value end))

  assert.are.same({ a = 10 }, stdlib.table.map({ 1 }, function(value) return 10 * value, 'a' end))
  assert.are.same({ 10 }, stdlib.table.map({ a = 1 }, function(value) return 10 * value, 1 end))
  assert.are.same({ b = 10 }, stdlib.table.map({ a = 10 }, function(value) return value, 'b' end))
end)

spec('table.merge', function()
  local function assert_merge(expected, target, ...)
    local merged = stdlib.table.merge(target, ...)
    assert.are_not.equal(target, merged)
    assert.are.same(expected, stdlib.table.merge(target, ...))
  end

  assert_merge({}, {})

  assert_merge({ a = 1 }, { a = 1 })
  assert_merge({ a = 2 }, { a = 1 }, { a = 2 })
  assert_merge({ a = 1, b = 2 }, { a = 1 }, { b = 2 })
  assert_merge({ a = 1, b = 2, c = 3 }, { a = 1, c = 3 }, { b = 2 })

  assert_merge({ 10 }, { 10 })
  assert_merge({ 10, 20, 30 }, { 10, 20 }, { 30 })
  assert_merge({ 10, 20, 30 }, { 10 }, { 20 }, { 30 })
end)

spec('table.reduce', function()
  assert.are.equal(60,
    stdlib.table.reduce({ 10, 20, 30 }, 0, function(reduction, value) return reduction + value end))
  assert.are.equal(70,
    stdlib.table.reduce({ 10, 20, 30 }, 10, function(reduction, value) return reduction + value end))
  assert.are.equal(60,
    stdlib.table.reduce({ a = 10, b = 20, c = 30 }, 0, function(reduction, value) return reduction + value end))
  assert.are.equal(70,
    stdlib.table.reduce({ a = 10, b = 20, c = 30 }, 10, function(reduction, value) return reduction + value end))
end)

spec('table.reverse', function()
  local function assert_reverse(expected, t)
    stdlib.table.reverse(t)
    assert.are.same(expected, t)
  end

  assert_reverse({}, {})
  assert_reverse({ 'a' }, { 'a' })
  assert_reverse({ 'b', 'a' }, { 'a', 'b' })
  assert_reverse({ 'c', 'b', 'a' }, { 'a', 'b', 'c' })
  assert_reverse({ 'c', 'b', 'a', d = true }, { 'a', 'b', 'c', d = true })
end)

spec('table.pack', function()
  if _VERSION == 'Lua 5.1' then
    assert.are.same({ n = 0 }, stdlib.table.pack())
    assert.are.same({ n = 1, 10 }, stdlib.table.pack(10))
    assert.are.same({ n = 3, 10, 30, 20 }, stdlib.table.pack(10, 30, 20))
  else
    assert.is_nil(rawget(stdlib.table, 'pack'))
  end
end)

spec('table.shallowcopy', function()
  local function assert_shallowcopy(t)
    local copy = stdlib.table.shallowcopy(t)

    assert.are_not.equal(t, copy)
    assert.are.same(t, copy)

    for key, value in pairs(t) do
      assert.are.equal(value, copy[key])
    end
  end

  assert_shallowcopy({})
  assert_shallowcopy({ 1, 2, 3 })
  assert_shallowcopy({ a = 1, b = 2, c = 3 })
  assert_shallowcopy({ a = 1, 'hello' })
  assert_shallowcopy({ a = 1, b = 2, 'hello', 'world' })
  assert_shallowcopy({ { 'hello' } })
  assert_shallowcopy({ a = { 'hello' } })
  assert_shallowcopy({ a = { 'hello' }, { 'world' } })
end)

spec('table.slice', function()
  assert.are.same({}, stdlib.table.slice({}))
  assert.are.same({ 1, 2 }, stdlib.table.slice({ 1, 2 }))
  assert.are.same({ 1, 2 }, stdlib.table.slice({ 1, 2, a = 3 }))

  assert.are.same({ 'a', 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 1))
  assert.are.same({ 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 2))
  assert.are.same({ 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 3))

  assert.are.same({ 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, -1))
  assert.are.same({ 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, -2))
  assert.are.same({ 'a', 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, -3))

  assert.are.same({ 'a' }, stdlib.table.slice({ 'a', 'b', 'c' }, 1, 1))
  assert.are.same({ 'a', 'b' }, stdlib.table.slice({ 'a', 'b', 'c' }, 1, 2))
  assert.are.same({ 'b' }, stdlib.table.slice({ 'a', 'b', 'c' }, 2, 2))
  assert.are.same({ 'a', 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 1, 3))

  assert.are.same({ 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 2, -1))
  assert.are.same({ 'a', 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 1, -1))
  assert.are.same({ 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, 3, -1))
  assert.are.same({ 'b', 'c' }, stdlib.table.slice({ 'a', 'b', 'c' }, -2, 3))

  assert.are.same({}, stdlib.table.slice({ 'a', 'b', 'c' }, 4))
end)

spec('table.unpack', function()
  if _VERSION == 'Lua 5.1' then
    assert.are.equal(unpack, stdlib.table.unpack)
  else
    assert.is_nil(rawget(stdlib.table, 'unpack'))
  end
end)

spec('table.values', function()
  local function assert_values(expected, t)
    local values = stdlib.table.values(t)
    table.sort(expected, any_sort)
    table.sort(values, any_sort)
    assert.are.same(expected, values)
  end

  assert_values({}, {})
  assert_values({ 'a' }, { 'a' })
  assert_values({ 'a', 'b' }, { 'a', 'b' })
  assert_values({ 1 }, { a = 1 })
  assert_values({ 1, 2 }, { a = 1, b = 2 })
  assert_values({ 1, 'a' }, { 'a', b = 1 })
end)
