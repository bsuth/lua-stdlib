local stdlib = require("stdlib")
spec("load / unload", function()
	assert.is_nil(kpairs)
	assert.is_nil(math.clamp)
	assert.is_nil(math.round)
	assert.is_nil(table.assign)
	assert.is_nil(table.clone)
	stdlib.load()
	assert.is_function(kpairs)
	assert.is_function(math.clamp)
	assert.is_function(math.round)
	assert.is_function(table.assign)
	assert.is_function(table.clone)
	stdlib.unload()
	assert.is_nil(kpairs)
	assert.is_nil(math.clamp)
	assert.is_nil(math.round)
	assert.is_nil(table.assign)
	assert.is_nil(table.clone)
end)
local function collect_kpairs(t)
	local result = {}
	for key, value in stdlib.kpairs(t) do
		result[key] = value
	end
	return result
end
spec("kpairs", function()
	assert.are.same({}, collect_kpairs({}))
	assert.are.same(
		{},
		collect_kpairs({
			"hello",
			"world",
		})
	)
	assert.are.same(
		{
			mykey = "hello",
			myotherkey = "world",
		},
		collect_kpairs({
			mykey = "hello",
			myotherkey = "world",
		})
	)
	assert.are.same(
		{
			mykey = "hello",
			myotherkey = "world",
		},
		collect_kpairs({
			mykey = "hello",
			myotherkey = "world",
			"hello",
			"world",
		})
	)
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
spec("math.product", function()
	assert.are.equal(1, stdlib.math.product())
	assert.are.equal(0, stdlib.math.product(0))
	assert.are.equal(1, stdlib.math.product(1))
	assert.are.equal(24, stdlib.math.product(1, 2, 3, 4))
	assert.are.equal(-6, stdlib.math.product(1, -2, 3))
end)
spec("math.round", function()
	assert.are.equal(-1, stdlib.math.round(-1))
	assert.are.equal(-1, stdlib.math.round(-0.9))
	assert.are.equal(-1, stdlib.math.round(-0.51))
	assert.are.equal(0, stdlib.math.round(-0.5))
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
spec("math.sum", function()
	assert.are.equal(0, stdlib.math.sum())
	assert.are.equal(0, stdlib.math.sum(0))
	assert.are.equal(1, stdlib.math.sum(1))
	assert.are.equal(10, stdlib.math.sum(1, 2, 3, 4))
	assert.are.equal(-2, stdlib.math.sum(1, -2, 3, -4))
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
	assert.are.equal("hello", stdlib.string.trim("\thello"))
	assert.are.equal("hello", stdlib.string.trim("hello\t"))
	assert.are.equal("hello", stdlib.string.trim("\thello\t"))
	assert.are.equal("hello", stdlib.string.trim("\t\thello"))
	assert.are.equal("hello", stdlib.string.trim("hello\t\t"))
	assert.are.equal("hello", stdlib.string.trim("\t\thello\t\t"))
	assert.are.equal("hello", stdlib.string.trim("\nhello"))
	assert.are.equal("hello", stdlib.string.trim("hello\n"))
	assert.are.equal("hello", stdlib.string.trim("\nhello\n"))
	assert.are.equal("hello", stdlib.string.trim("\n\nhello"))
	assert.are.equal("hello", stdlib.string.trim("hello\n\n"))
	assert.are.equal("hello", stdlib.string.trim("\n\nhello\n\n"))
	assert.are.equal("hello", stdlib.string.trim("\n\t hello\t \n"))
	assert.are.equal("hello", stdlib.string.trim("xxhelloxx", "x+"))
end)
local function array_sort(a, b)
	if type(a) == type(b) then
		return a < b
	else
		return type(a) == "number"
	end
end
local function assert_array(expected, received)
	table.sort(expected, array_sort)
	table.sort(received, array_sort)
	assert.are.same(expected, received)
end
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
spec("table.clone", function()
	local function assert_clone(t, clone)
		if clone == nil then
			clone = stdlib.table.clone(t)
		end
		assert.are_not.equal(t, clone)
		assert.are.same(t, clone)
		for key, value in pairs(t) do
			if type(value) == "stdlib.table" then
				assert_clone(value, clone[key])
			end
		end
	end
	assert_clone({})
	assert_clone({
		1,
		2,
		3,
	})
	assert_clone({
		a = 1,
		b = 2,
		c = 3,
	})
	assert_clone({
		a = 1,
		"hello",
	})
	assert_clone({
		a = 1,
		b = 2,
		"hello",
		"world",
	})
	assert_clone({
		{
			"hello",
		},
	})
	assert_clone({
		a = {
			"hello",
		},
	})
	assert_clone({
		a = {
			"hello",
		},
		{
			"world",
		},
	})
end)
spec("table.copy", function()
	local function assert_copy(t)
		local copy = stdlib.table.copy(t)
		assert.are_not.equal(t, copy)
		assert.are.same(t, copy)
		for key, value in pairs(t) do
			assert.are.equal(value, copy[key])
		end
	end
	assert_copy({})
	assert_copy({
		1,
		2,
		3,
	})
	assert_copy({
		a = 1,
		b = 2,
		c = 3,
	})
	assert_copy({
		a = 1,
		"hello",
	})
	assert_copy({
		a = 1,
		b = 2,
		"hello",
		"world",
	})
	assert_copy({
		{
			"hello",
		},
	})
	assert_copy({
		a = {
			"hello",
		},
	})
	assert_copy({
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
	assert_array({}, stdlib.table.keys({}))
	assert_array(
		{
			1,
		},
		stdlib.table.keys({
			"a",
		})
	)
	assert_array(
		{
			1,
			2,
		},
		stdlib.table.keys({
			"a",
			"b",
		})
	)
	assert_array(
		{
			"a",
		},
		stdlib.table.keys({
			a = 10,
		})
	)
	assert_array(
		{
			"a",
			"b",
		},
		stdlib.table.keys({
			a = 10,
			b = 20,
		})
	)
	assert_array(
		{
			1,
			"b",
		},
		stdlib.table.keys({
			"a",
			b = 10,
		})
	)
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
spec("table.values", function()
	assert_array({}, stdlib.table.values({}))
	assert_array(
		{
			"a",
		},
		stdlib.table.values({
			"a",
		})
	)
	assert_array(
		{
			"a",
			"b",
		},
		stdlib.table.values({
			"a",
			"b",
		})
	)
	assert_array(
		{
			1,
		},
		stdlib.table.values({
			a = 1,
		})
	)
	assert_array(
		{
			1,
			2,
		},
		stdlib.table.values({
			a = 1,
			b = 2,
		})
	)
	assert_array(
		{
			1,
			"a",
		},
		stdlib.table.values({
			"a",
			b = 1,
		})
	)
end)
-- Compiled with Erde 0.6.0-1
-- __ERDE_COMPILED__
