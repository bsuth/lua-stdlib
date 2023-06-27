local stdlib = require("stdlib")
if _VERSION == "Lua 5.1" then
	table.pack = nil
	table.unpack = nil
end
local function any_sort(a, b)
	if type(a) == type(b) then
		return a < b
	else
		return type(a) < type(b)
	end
end
spec("load / unload", function()
	local function assert_loaded(library_name)
		for key in pairs(stdlib[library_name]) do
			assert.are.equal(_G[library_name][key], stdlib[library_name][key])
		end
	end
	local function assert_unloaded(library_name)
		for key in pairs(stdlib[library_name]) do
			assert.is_nil(_G[library_name][key])
		end
	end
	assert_unloaded("coroutine")
	assert_unloaded("debug")
	assert_unloaded("io")
	assert_unloaded("math")
	assert_unloaded("os")
	assert_unloaded("package")
	assert_unloaded("string")
	assert_unloaded("table")
	stdlib.load()
	assert.are_not.equal(_G.load, stdlib.load)
	assert.are_not.equal(_G.unload, stdlib.unload)
	assert.are.equal(_G.kpairs, stdlib.kpairs)
	assert_loaded("coroutine")
	assert_loaded("debug")
	assert_loaded("io")
	assert_loaded("math")
	assert_loaded("os")
	assert_loaded("package")
	assert_loaded("string")
	assert_loaded("table")
	stdlib.unload()
	assert_unloaded("coroutine")
	assert_unloaded("debug")
	assert_unloaded("io")
	assert_unloaded("math")
	assert_unloaded("os")
	assert_unloaded("package")
	assert_unloaded("string")
	assert_unloaded("table")
end)
spec("kpairs", function()
	local function assert_kpairs(expected, t)
		local result = {}
		for key, value in stdlib.kpairs(t) do
			result[key] = value
		end
		assert.are.same(expected, result)
	end
	assert_kpairs({}, {})
	assert_kpairs({}, {
		"hello",
		"world",
	})
	assert_kpairs({
		mykey = "hello",
		myotherkey = "world",
	}, {
		mykey = "hello",
		myotherkey = "world",
	})
	assert_kpairs({
		mykey = "hello",
		myotherkey = "world",
	}, {
		mykey = "hello",
		myotherkey = "world",
		"hello",
		"world",
	})
end)
spec("coroutine", function()
	assert.is_table(stdlib.coroutine)
	for key in pairs(coroutine) do
		assert.are.equal(coroutine[key], stdlib.coroutine[key])
	end
end)
spec("debug", function()
	assert.is_table(stdlib.debug)
	for key in pairs(debug) do
		assert.are.equal(debug[key], stdlib.debug[key])
	end
end)
spec("io", function()
	assert.is_table(stdlib.io)
	for key in pairs(io) do
		assert.are.equal(io[key], stdlib.io[key])
	end
end)
spec("math", function()
	assert.is_table(stdlib.math)
	for key in pairs(math) do
		assert.are.equal(math[key], stdlib.math[key])
	end
end)
spec("math.clamp", function()
	assert.are.equal(0, stdlib.math.clamp(0, 0, 1))
	assert.are.equal(0.5, stdlib.math.clamp(0.5, 0, 1))
	assert.are.equal(0, stdlib.math.clamp(-0.5, 0, 1))
	assert.are.equal(1, stdlib.math.clamp(1.5, 0, 1))
end)
spec("math.round", function()
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
spec("math.sign", function()
	assert.are.equal(-1, stdlib.math.sign(-3))
	assert.are.equal(-1, stdlib.math.sign(-1))
	assert.are.equal(0, stdlib.math.sign(0))
	assert.are.equal(1, stdlib.math.sign(1))
	assert.are.equal(1, stdlib.math.sign(4))
end)
spec("os", function()
	assert.is_table(stdlib.os)
	for key in pairs(os) do
		assert.are.equal(os[key], stdlib.os[key])
	end
end)
spec("package", function()
	assert.is_table(stdlib.package)
	for key in pairs(package) do
		assert.are.equal(package[key], stdlib.package[key])
	end
end)
spec("string", function()
	assert.is_table(stdlib.string)
	for key in pairs(string) do
		assert.are.equal(string[key], stdlib.string[key])
	end
end)
spec("string.escape", function()
	assert.are.equal("a", stdlib.string.escape("a"))
	assert.are.equal("1", stdlib.string.escape("1"))
	assert.are.equal(",", stdlib.string.escape(","))
	assert.are.equal("%%", stdlib.string.escape("%"))
	assert.are.equal("%(", stdlib.string.escape("("))
	assert.are.equal("%)", stdlib.string.escape(")"))
	assert.are.equal("%.", stdlib.string.escape("."))
	assert.are.equal("%*", stdlib.string.escape("*"))
	assert.are.equal("%?", stdlib.string.escape("?"))
	assert.are.equal("%[", stdlib.string.escape("["))
	assert.are.equal("%^", stdlib.string.escape("^"))
	assert.are.equal("%$", stdlib.string.escape("$"))
	assert.are.equal("%+", stdlib.string.escape("+"))
	assert.are.equal("%-", stdlib.string.escape("-"))
	assert.are.equal("a%%", stdlib.string.escape("a%"))
	assert.are.equal("a%(", stdlib.string.escape("a("))
	assert.are.equal("a%)", stdlib.string.escape("a)"))
	assert.are.equal("a%.", stdlib.string.escape("a."))
	assert.are.equal("a%*", stdlib.string.escape("a*"))
	assert.are.equal("a%?", stdlib.string.escape("a?"))
	assert.are.equal("a%[", stdlib.string.escape("a["))
	assert.are.equal("a%^", stdlib.string.escape("a^"))
	assert.are.equal("a%$", stdlib.string.escape("a$"))
	assert.are.equal("a%+", stdlib.string.escape("a+"))
	assert.are.equal("a%-", stdlib.string.escape("a-"))
	assert.are.equal("%%", stdlib.string.escape("%%"))
	assert.are.equal("%(", stdlib.string.escape("%("))
	assert.are.equal("%)", stdlib.string.escape("%)"))
	assert.are.equal("%.", stdlib.string.escape("%."))
	assert.are.equal("%*", stdlib.string.escape("%*"))
	assert.are.equal("%?", stdlib.string.escape("%?"))
	assert.are.equal("%[", stdlib.string.escape("%["))
	assert.are.equal("%^", stdlib.string.escape("%^"))
	assert.are.equal("%$", stdlib.string.escape("%$"))
	assert.are.equal("%+", stdlib.string.escape("%+"))
	assert.are.equal("%-", stdlib.string.escape("%-"))
	assert.are.equal("%%%(", stdlib.string.escape("%%("))
	assert.are.equal("%(%%", stdlib.string.escape("(%%"))
	assert.are.equal("%%%%", stdlib.string.escape("%%%%"))
	assert.are.equal("%%%(%%", stdlib.string.escape("%%(%%"))
end)
spec("string.lpad", function()
	assert.are.equal("bbbbb", stdlib.string.lpad("", 5, "b"))
	assert.are.equal("bbbba", stdlib.string.lpad("a", 5, "b"))
	assert.are.equal("bbbaa", stdlib.string.lpad("aa", 5, "b"))
	assert.are.equal("bbaaa", stdlib.string.lpad("aaa", 5, "b"))
	assert.are.equal("baaaa", stdlib.string.lpad("aaaa", 5, "b"))
	assert.are.equal("aaaaa", stdlib.string.lpad("aaaaa", 5, "b"))
	assert.are.equal("aaaaaa", stdlib.string.lpad("aaaaaa", 5, "b"))
	assert.are.equal("bbbbbb", stdlib.string.lpad("", 5, "bb"))
	assert.are.equal("bbbba", stdlib.string.lpad("a", 5, "bb"))
	assert.are.equal("bbbbaa", stdlib.string.lpad("aa", 5, "bb"))
	assert.are.equal("bbaaa", stdlib.string.lpad("aaa", 5, "bb"))
	assert.are.equal("bbaaaa", stdlib.string.lpad("aaaa", 5, "bb"))
	assert.are.equal("aaaaa", stdlib.string.lpad("aaaaa", 5, "bb"))
	assert.are.equal("aaaaaa", stdlib.string.lpad("aaaaaa", 5, "bb"))
end)
spec("string.ltrim", function()
	assert.are.equal("hello", stdlib.string.ltrim("hello"))
	assert.are.equal("hello ", stdlib.string.ltrim("hello "))
	assert.are.equal("hello", stdlib.string.ltrim(" hello"))
	assert.are.equal("hello ", stdlib.string.ltrim(" hello "))
	assert.are.equal("hello  ", stdlib.string.ltrim("hello  "))
	assert.are.equal("hello", stdlib.string.ltrim("  hello"))
	assert.are.equal("hello  ", stdlib.string.ltrim("  hello  "))
	assert.are.equal("hello\t", stdlib.string.ltrim("hello\t"))
	assert.are.equal("hello", stdlib.string.ltrim("\thello"))
	assert.are.equal("hello\t", stdlib.string.ltrim("\thello\t"))
	assert.are.equal("hello\t\t", stdlib.string.ltrim("hello\t\t"))
	assert.are.equal("hello", stdlib.string.ltrim("\t\thello"))
	assert.are.equal("hello\t\t", stdlib.string.ltrim("\t\thello\t\t"))
	assert.are.equal("hello\n", stdlib.string.ltrim("hello\n"))
	assert.are.equal("hello", stdlib.string.ltrim("\nhello"))
	assert.are.equal("hello\n", stdlib.string.ltrim("\nhello\n"))
	assert.are.equal("hello\n\n", stdlib.string.ltrim("hello\n\n"))
	assert.are.equal("hello", stdlib.string.ltrim("\n\nhello"))
	assert.are.equal("hello\n\n", stdlib.string.ltrim("\n\nhello\n\n"))
	assert.are.equal("hello\t\n", stdlib.string.ltrim("hello\t\n"))
	assert.are.equal("hello", stdlib.string.ltrim("\t\nhello"))
	assert.are.equal("hello\t\n", stdlib.string.ltrim("\t\nhello\t\n"))
	assert.are.equal("hellox", stdlib.string.ltrim("hellox", "x+"))
	assert.are.equal("hello", stdlib.string.ltrim("xhello", "x+"))
	assert.are.equal("hellox", stdlib.string.ltrim("xhellox", "x+"))
	assert.are.equal("helloxx", stdlib.string.ltrim("helloxx", "x+"))
	assert.are.equal("hello", stdlib.string.ltrim("xxhello", "x+"))
	assert.are.equal("helloxx", stdlib.string.ltrim("xxhelloxx", "x+"))
end)
spec("string.pad", function()
	assert.are.equal("bbbbbb", stdlib.string.pad("", 5, "b"))
	assert.are.equal("bbabb", stdlib.string.pad("a", 5, "b"))
	assert.are.equal("bbaabb", stdlib.string.pad("aa", 5, "b"))
	assert.are.equal("baaab", stdlib.string.pad("aaa", 5, "b"))
	assert.are.equal("baaaab", stdlib.string.pad("aaaa", 5, "b"))
	assert.are.equal("aaaaa", stdlib.string.pad("aaaaa", 5, "b"))
	assert.are.equal("aaaaaa", stdlib.string.pad("aaaaaa", 5, "b"))
	assert.are.equal("bbbbbbbb", stdlib.string.pad("", 5, "bb"))
	assert.are.equal("bbabb", stdlib.string.pad("a", 5, "bb"))
	assert.are.equal("bbaabb", stdlib.string.pad("aa", 5, "bb"))
	assert.are.equal("bbaaabb", stdlib.string.pad("aaa", 5, "bb"))
	assert.are.equal("bbaaaabb", stdlib.string.pad("aaaa", 5, "bb"))
	assert.are.equal("aaaaa", stdlib.string.pad("aaaaa", 5, "bb"))
	assert.are.equal("aaaaaa", stdlib.string.pad("aaaaaa", 5, "bb"))
end)
spec("string.rpad", function()
	assert.are.equal("bbbbb", stdlib.string.rpad("", 5, "b"))
	assert.are.equal("abbbb", stdlib.string.rpad("a", 5, "b"))
	assert.are.equal("aabbb", stdlib.string.rpad("aa", 5, "b"))
	assert.are.equal("aaabb", stdlib.string.rpad("aaa", 5, "b"))
	assert.are.equal("aaaab", stdlib.string.rpad("aaaa", 5, "b"))
	assert.are.equal("aaaaa", stdlib.string.rpad("aaaaa", 5, "b"))
	assert.are.equal("aaaaaa", stdlib.string.rpad("aaaaaa", 5, "b"))
	assert.are.equal("bbbbbb", stdlib.string.rpad("", 5, "bb"))
	assert.are.equal("abbbb", stdlib.string.rpad("a", 5, "bb"))
	assert.are.equal("aabbbb", stdlib.string.rpad("aa", 5, "bb"))
	assert.are.equal("aaabb", stdlib.string.rpad("aaa", 5, "bb"))
	assert.are.equal("aaaabb", stdlib.string.rpad("aaaa", 5, "bb"))
	assert.are.equal("aaaaa", stdlib.string.rpad("aaaaa", 5, "bb"))
	assert.are.equal("aaaaaa", stdlib.string.rpad("aaaaaa", 5, "bb"))
end)
spec("string.rtrim", function()
	assert.are.equal("hello", stdlib.string.rtrim("hello"))
	assert.are.equal("hello", stdlib.string.rtrim("hello "))
	assert.are.equal(" hello", stdlib.string.rtrim(" hello"))
	assert.are.equal(" hello", stdlib.string.rtrim(" hello "))
	assert.are.equal("hello", stdlib.string.rtrim("hello  "))
	assert.are.equal("  hello", stdlib.string.rtrim("  hello"))
	assert.are.equal("  hello", stdlib.string.rtrim("  hello  "))
	assert.are.equal("hello", stdlib.string.rtrim("hello\t"))
	assert.are.equal("\thello", stdlib.string.rtrim("\thello"))
	assert.are.equal("\thello", stdlib.string.rtrim("\thello\t"))
	assert.are.equal("hello", stdlib.string.rtrim("hello\t\t"))
	assert.are.equal("\t\thello", stdlib.string.rtrim("\t\thello"))
	assert.are.equal("\t\thello", stdlib.string.rtrim("\t\thello\t\t"))
	assert.are.equal("hello", stdlib.string.rtrim("hello\n"))
	assert.are.equal("\nhello", stdlib.string.rtrim("\nhello"))
	assert.are.equal("\nhello", stdlib.string.rtrim("\nhello\n"))
	assert.are.equal("hello", stdlib.string.rtrim("hello\n\n"))
	assert.are.equal("\n\nhello", stdlib.string.rtrim("\n\nhello"))
	assert.are.equal("\n\nhello", stdlib.string.rtrim("\n\nhello\n\n"))
	assert.are.equal("hello", stdlib.string.rtrim("hello\t\n"))
	assert.are.equal("\t\nhello", stdlib.string.rtrim("\t\nhello"))
	assert.are.equal("\t\nhello", stdlib.string.rtrim("\t\nhello\t\n"))
	assert.are.equal("hello", stdlib.string.rtrim("hellox", "x+"))
	assert.are.equal("xhello", stdlib.string.rtrim("xhello", "x+"))
	assert.are.equal("xhello", stdlib.string.rtrim("xhellox", "x+"))
	assert.are.equal("hello", stdlib.string.rtrim("helloxx", "x+"))
	assert.are.equal("xxhello", stdlib.string.rtrim("xxhello", "x+"))
	assert.are.equal("xxhello", stdlib.string.rtrim("xxhelloxx", "x+"))
end)
spec("string.split", function()
	assert.are.same({
		"a",
		"b",
		"c",
	}, stdlib.string.split("a b c"))
	assert.are.same({
		"a",
		"b",
		"c",
	}, stdlib.string.split("a  b \tc"))
	assert.are.same({
		"",
		"a",
	}, stdlib.string.split(" a"))
	assert.are.same({
		"a",
		"",
	}, stdlib.string.split("a "))
	assert.are.same({
		"",
		"a",
		"",
	}, stdlib.string.split(" a "))
	assert.are.same({
		" ",
		" ",
	}, stdlib.string.split(" a ", "%a+"))
	assert.are.same({
		"hello",
		"world",
	}, stdlib.string.split("hello11world", "%d+"))
end)
spec("string.trim", function()
	assert.are.equal("hello", stdlib.string.trim("hello"))
	assert.are.equal("hello", stdlib.string.trim("hello "))
	assert.are.equal("hello", stdlib.string.trim(" hello"))
	assert.are.equal("hello", stdlib.string.trim(" hello "))
	assert.are.equal("hello", stdlib.string.trim("hello  "))
	assert.are.equal("hello", stdlib.string.trim("  hello"))
	assert.are.equal("hello", stdlib.string.trim("  hello  "))
	assert.are.equal("hello", stdlib.string.trim("hello\t"))
	assert.are.equal("hello", stdlib.string.trim("\thello"))
	assert.are.equal("hello", stdlib.string.trim("\thello\t"))
	assert.are.equal("hello", stdlib.string.trim("hello\t\t"))
	assert.are.equal("hello", stdlib.string.trim("\t\thello"))
	assert.are.equal("hello", stdlib.string.trim("\t\thello\t\t"))
	assert.are.equal("hello", stdlib.string.trim("hello\n"))
	assert.are.equal("hello", stdlib.string.trim("\nhello"))
	assert.are.equal("hello", stdlib.string.trim("\nhello\n"))
	assert.are.equal("hello", stdlib.string.trim("hello\n\n"))
	assert.are.equal("hello", stdlib.string.trim("\n\nhello"))
	assert.are.equal("hello", stdlib.string.trim("\n\nhello\n\n"))
	assert.are.equal("hello", stdlib.string.trim("hello\t\n"))
	assert.are.equal("hello", stdlib.string.trim("\t\nhello"))
	assert.are.equal("hello", stdlib.string.trim("\t\nhello\t\n"))
	assert.are.equal("hello", stdlib.string.trim("hellox", "x+"))
	assert.are.equal("hello", stdlib.string.trim("xhello", "x+"))
	assert.are.equal("hello", stdlib.string.trim("xhellox", "x+"))
	assert.are.equal("hello", stdlib.string.trim("helloxx", "x+"))
	assert.are.equal("hello", stdlib.string.trim("xxhello", "x+"))
	assert.are.equal("hello", stdlib.string.trim("xxhelloxx", "x+"))
end)
spec("table", function()
	assert.is_table(stdlib.table)
	for key in pairs(table) do
		assert.are.equal(table[key], stdlib.table[key])
	end
end)
spec("table.assign", function()
	local function assert_assign(expected, target, ...)
		stdlib.table.assign(target, ...)
		assert.are.same(expected, target)
	end
	assert_assign({}, {})
	assert_assign({
		a = 1,
	}, {}, {
		a = 1,
	})
	assert_assign({
		a = 2,
	}, {}, {
		a = 1,
	}, {
		a = 2,
	})
	assert_assign({
		a = 1,
		b = 2,
	}, {}, {
		a = 1,
	}, {
		b = 2,
	})
	assert_assign({
		a = 2,
	}, {
		a = 1,
	}, {
		a = 2,
	})
	assert_assign({
		a = 1,
		b = 2,
	}, {
		a = 1,
	}, {
		b = 2,
	})
	assert_assign({
		a = 1,
		b = 2,
		c = 3,
	}, {
		a = 1,
		c = 3,
	}, {
		b = 2,
	})
	assert_assign({
		1,
	}, {
		1,
	})
	assert_assign({}, {}, {
		1,
	})
end)
spec("table.deepcopy", function()
	local function assert_deepcopy(t, copy)
		if copy == nil then
			copy = stdlib.table.deepcopy(t)
		end
		assert.are_not.equal(t, copy)
		assert.are.same(t, copy)
		for key, value in pairs(t) do
			if type(value) == "table" then
				assert_deepcopy(value, copy[key])
			end
		end
	end
	assert_deepcopy({})
	assert_deepcopy({
		1,
		2,
		3,
	})
	assert_deepcopy({
		a = 1,
		b = 2,
		c = 3,
	})
	assert_deepcopy({
		a = 1,
		"hello",
	})
	assert_deepcopy({
		a = 1,
		b = 2,
		"hello",
		"world",
	})
	assert_deepcopy({
		{
			"hello",
		},
	})
	assert_deepcopy({
		a = {
			"hello",
		},
	})
	assert_deepcopy({
		a = {
			"hello",
		},
		{
			"world",
		},
	})
end)
spec("table.default", function()
	local function assert_default(expected, target, ...)
		stdlib.table.default(target, ...)
		assert.are.same(expected, target)
	end
	assert_default({}, {})
	assert_default({
		a = 1,
	}, {}, {
		a = 1,
	})
	assert_default({
		a = 1,
	}, {}, {
		a = 1,
	}, {
		a = 2,
	})
	assert_default({
		a = 1,
		b = 2,
	}, {}, {
		a = 1,
	}, {
		b = 2,
	})
	assert_default({
		a = 1,
	}, {
		a = 1,
	}, {
		a = 2,
	})
	assert_default({
		a = 1,
		b = 2,
	}, {
		a = 1,
	}, {
		b = 2,
	})
	assert_default({
		a = 1,
		b = 2,
		c = 3,
	}, {
		a = 1,
		c = 3,
	}, {
		b = 2,
	})
	assert_default({
		1,
	}, {
		1,
	})
	assert_default({}, {}, {
		1,
	})
end)
spec("table.filter", function()
	assert.are.same(
		{},
		stdlib.table.filter({}, function()
			return false
		end)
	)
	assert.are.same(
		{},
		stdlib.table.filter({}, function()
			return true
		end)
	)
	assert.are.same(
		{},
		stdlib.table.filter({
			1,
			2,
			3,
		}, function()
			return false
		end)
	)
	assert.are.same(
		{
			1,
			2,
			3,
		},
		stdlib.table.filter({
			1,
			2,
			3,
		}, function()
			return true
		end)
	)
	assert.are.same(
		{},
		stdlib.table.filter({
			a = 1,
			b = 2,
		}, function()
			return false
		end)
	)
	assert.are.same(
		{
			a = 1,
			b = 2,
		},
		stdlib.table.filter({
			a = 1,
			b = 2,
		}, function()
			return true
		end)
	)
	assert.are.same(
		{
			1,
			2,
		},
		stdlib.table.filter({
			1,
			2,
			3,
		}, function(value)
			return value < 3
		end)
	)
	assert.are.same(
		{
			3,
		},
		stdlib.table.filter({
			1,
			2,
			3,
		}, function(value)
			return value > 2
		end)
	)
	assert.are.same(
		{
			a = 1,
		},
		stdlib.table.filter({
			a = 1,
			b = 2,
		}, function(value)
			return value < 2
		end)
	)
	assert.are.same(
		{
			b = 2,
		},
		stdlib.table.filter({
			a = 1,
			b = 2,
		}, function(value)
			return value > 1
		end)
	)
	assert.are.same(
		{
			a = 1,
		},
		stdlib.table.filter({
			a = 1,
			b = 2,
		}, function(_, key)
			return key == "a"
		end)
	)
end)
spec("table.find", function()
	local function assert_find(expected_key, t, callback)
		local value, key = stdlib.table.find(t, callback)
		assert.are.equal(expected_key, key)
		assert.are.equal(t[expected_key], value)
	end
	assert_find(1, {
		"a",
		"b",
		"c",
	}, "a")
	assert_find(2, {
		"a",
		"b",
		"c",
	}, "b")
	assert_find(3, {
		"a",
		"b",
		"c",
	}, "c")
	assert_find(nil, {
		"a",
		"b",
		"c",
	}, "d")
	assert_find("a", {
		a = "x",
		b = "y",
		c = "z",
	}, "x")
	assert_find("b", {
		a = "x",
		b = "y",
		c = "z",
	}, "y")
	assert_find("c", {
		a = "x",
		b = "y",
		c = "z",
	}, "z")
	assert_find(nil, {
		a = "x",
		b = "y",
		c = "z",
	}, "w")
	assert_find(1, {
		30,
		20,
		10,
	}, function(value)
		return value < 40
	end)
	assert_find(2, {
		30,
		20,
		10,
	}, function(value)
		return value < 30
	end)
	assert_find(3, {
		30,
		20,
		10,
	}, function(value)
		return value < 20
	end)
	assert_find("a", {
		a = 10,
	}, function(value)
		return value < 20
	end)
	assert_find(nil, {
		a = 20,
	}, function(value)
		return value < 20
	end)
end)
spec("table.keys", function()
	local function assert_keys(expected, t)
		local keys = stdlib.table.keys(t)
		table.sort(expected, any_sort)
		table.sort(keys, any_sort)
		assert.are.same(expected, keys)
	end
	assert_keys({}, {})
	assert_keys({
		1,
	}, {
		"a",
	})
	assert_keys({
		1,
		2,
	}, {
		"a",
		"b",
	})
	assert_keys({
		"a",
	}, {
		a = 10,
	})
	assert_keys({
		"a",
		"b",
	}, {
		a = 10,
		b = 20,
	})
	assert_keys({
		1,
		"b",
	}, {
		"a",
		b = 10,
	})
end)
spec("table.map", function()
	assert.are.same(
		{},
		stdlib.table.map({}, function(value)
			return true
		end)
	)
	assert.are.same(
		{},
		stdlib.table.map({
			1,
			2,
			3,
		}, function(value)
			return nil
		end)
	)
	assert.are.same(
		{
			0,
			10,
			20,
		},
		stdlib.table.map({
			0,
			1,
			2,
		}, function(value)
			return 10 * value
		end)
	)
	assert.are.same(
		{
			a = 10,
			b = 20,
		},
		stdlib.table.map({
			a = 1,
			b = 2,
		}, function(value)
			return 10 * value
		end)
	)
	assert.are.same(
		{
			a = 10,
		},
		stdlib.table.map({
			1,
		}, function(value)
			return 10 * value, "a"
		end)
	)
	assert.are.same(
		{
			10,
		},
		stdlib.table.map({
			a = 1,
		}, function(value)
			return 10 * value, 1
		end)
	)
	assert.are.same(
		{
			b = 10,
		},
		stdlib.table.map({
			a = 10,
		}, function(value)
			return value, "b"
		end)
	)
end)
spec("table.reduce", function()
	assert.are.equal(
		60,
		stdlib.table.reduce(
			{
				10,
				20,
				30,
			},
			0,
			function(reduction, value)
				return reduction + value
			end
		)
	)
	assert.are.equal(
		70,
		stdlib.table.reduce(
			{
				10,
				20,
				30,
			},
			10,
			function(reduction, value)
				return reduction + value
			end
		)
	)
	assert.are.equal(
		60,
		stdlib.table.reduce(
			{
				a = 10,
				b = 20,
				c = 30,
			},
			0,
			function(reduction, value)
				return reduction + value
			end
		)
	)
	assert.are.equal(
		70,
		stdlib.table.reduce(
			{
				a = 10,
				b = 20,
				c = 30,
			},
			10,
			function(reduction, value)
				return reduction + value
			end
		)
	)
end)
spec("table.reverse", function()
	local function assert_reverse(expected, t)
		stdlib.table.reverse(t)
		assert.are.same(expected, t)
	end
	assert_reverse({}, {})
	assert_reverse({
		"a",
	}, {
		"a",
	})
	assert_reverse({
		"b",
		"a",
	}, {
		"a",
		"b",
	})
	assert_reverse({
		"c",
		"b",
		"a",
	}, {
		"a",
		"b",
		"c",
	})
	assert_reverse({
		"c",
		"b",
		"a",
		d = true,
	}, {
		"a",
		"b",
		"c",
		d = true,
	})
end)
spec("table.pack", function()
	if _VERSION == "Lua 5.1" then
		assert.are.same({
			n = 0,
		}, stdlib.table.pack())
		assert.are.same({
			n = 1,
			10,
		}, stdlib.table.pack(10))
		assert.are.same({
			n = 3,
			10,
			30,
			20,
		}, stdlib.table.pack(10, 30, 20))
	else
		assert.is_nil(rawget(stdlib.table, "pack"))
	end
end)
spec("table.shallowcopy", function()
	local function assert_shallowcopy(t)
		local copy = stdlib.table.shallowcopy(t)
		assert.are_not.equal(t, copy)
		assert.are.same(t, copy)
		for key, value in pairs(t) do
			assert.are.equal(value, copy[key])
		end
	end
	assert_shallowcopy({})
	assert_shallowcopy({
		1,
		2,
		3,
	})
	assert_shallowcopy({
		a = 1,
		b = 2,
		c = 3,
	})
	assert_shallowcopy({
		a = 1,
		"hello",
	})
	assert_shallowcopy({
		a = 1,
		b = 2,
		"hello",
		"world",
	})
	assert_shallowcopy({
		{
			"hello",
		},
	})
	assert_shallowcopy({
		a = {
			"hello",
		},
	})
	assert_shallowcopy({
		a = {
			"hello",
		},
		{
			"world",
		},
	})
end)
spec("table.slice", function()
	assert.are.same({}, stdlib.table.slice({}))
	assert.are.same(
		{
			1,
			2,
		},
		stdlib.table.slice({
			1,
			2,
		})
	)
	assert.are.same(
		{
			1,
			2,
		},
		stdlib.table.slice({
			1,
			2,
			a = 3,
		})
	)
	assert.are.same(
		{
			"a",
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 1)
	)
	assert.are.same(
		{
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 2)
	)
	assert.are.same(
		{
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 3)
	)
	assert.are.same(
		{
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, -1)
	)
	assert.are.same(
		{
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, -2)
	)
	assert.are.same(
		{
			"a",
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, -3)
	)
	assert.are.same(
		{
			"a",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 1, 1)
	)
	assert.are.same(
		{
			"a",
			"b",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 1, 2)
	)
	assert.are.same(
		{
			"b",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 2, 2)
	)
	assert.are.same(
		{
			"a",
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 1, 3)
	)
	assert.are.same(
		{
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 2, -1)
	)
	assert.are.same(
		{
			"a",
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 1, -1)
	)
	assert.are.same(
		{
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 3, -1)
	)
	assert.are.same(
		{
			"b",
			"c",
		},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, -2, 3)
	)
	assert.are.same(
		{},
		stdlib.table.slice({
			"a",
			"b",
			"c",
		}, 4)
	)
end)
spec("table.unpack", function()
	if _VERSION == "Lua 5.1" then
		assert.are.equal(unpack, stdlib.table.unpack)
	else
		assert.is_nil(rawget(stdlib.table, "unpack"))
	end
end)
spec("table.values", function()
	local function assert_values(expected, t)
		local values = stdlib.table.values(t)
		table.sort(expected, any_sort)
		table.sort(values, any_sort)
		assert.are.same(expected, values)
	end
	assert_values({}, {})
	assert_values({
		"a",
	}, {
		"a",
	})
	assert_values({
		"a",
		"b",
	}, {
		"a",
		"b",
	})
	assert_values({
		1,
	}, {
		a = 1,
	})
	assert_values({
		1,
		2,
	}, {
		a = 1,
		b = 2,
	})
	assert_values({
		1,
		"a",
	}, {
		"a",
		b = 1,
	})
end)
-- Compiled with Erde 0.6.0-1
-- __ERDE_COMPILED__
