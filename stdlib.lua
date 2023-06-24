local _MODULE = {}
local function load()
	for key, value in pairs(_MODULE) do
		local value_type = type(value)
		if value_type == "function" then
			if key ~= "load" and key ~= "unload" then
				_G[key] = value
			end
		elseif value_type == "table" then
			local library = _G[key]
			if type(library) == "table" then
				for subkey, subvalue in pairs(value) do
					library[subkey] = subvalue
				end
			end
		end
	end
end
_MODULE.load = load
local function unload()
	for key, value in pairs(_MODULE) do
		local value_type = type(value)
		if value_type == "function" then
			if _G[key] == value then
				_G[key] = nil
			end
		elseif value_type == "table" then
			local library = _G[key]
			if type(library) == "table" then
				for subkey, subvalue in pairs(value) do
					if library[subkey] == subvalue then
						library[subkey] = nil
					end
				end
			end
		end
	end
end
_MODULE.unload = unload
local function _kpairs_iter(a, i)
	local key, value = i, nil
	repeat
		key, value = next(a, key)
	until type(key) ~= "number"
	return key, value
end
local function kpairs(t)
	return _kpairs_iter, t, nil
end
_MODULE.kpairs = kpairs
local _native_coroutine = coroutine
local coroutine = setmetatable({}, {
	__index = _native_coroutine,
})
_MODULE.coroutine = coroutine
local _native_debug = debug
local debug = setmetatable({}, {
	__index = _native_debug,
})
_MODULE.debug = debug
local _native_io = io
local io = setmetatable({}, {
	__index = _native_io,
})
_MODULE.io = io
local _native_math = math
local math = setmetatable({}, {
	__index = _native_math,
})
_MODULE.math = math
function math.clamp(x, min, max)
	return math.min(math.max(x, min), max)
end
function math.product(...)
	local multiplicands = { ... }
	local result = 1
	for i, multiplicand in ipairs(multiplicands) do
		result = result * multiplicand
	end
	return result
end
function math.round(x)
	if x < 0 then
		return math.ceil(x - 0.5)
	else
		return math.floor(x + 0.5)
	end
end
function math.sign(x)
	if x < 0 then
		return -1
	else
		return 1
	end
end
function math.sum(...)
	local summands = { ... }
	local result = 0
	for i, summand in ipairs(summands) do
		result = result + summand
	end
	return result
end
local _native_os = os
local os = setmetatable({}, {
	__index = _native_os,
})
_MODULE.os = os
local _native_package = package
local package = setmetatable({}, {
	__index = _native_package,
})
_MODULE.package = package
local _native_string = string
local string = setmetatable({}, {
	__index = _native_string,
})
_MODULE.string = string
function string.escape(s)
	local result = {}
	for _, part in ipairs(string.split(s, "%%%%")) do
		part = part:gsub("^([().*?[^$+-])", "%%%1")
		part = part:gsub("([^%%])([().*?[^$+-])", "%1%%%2")
		part = part:gsub("%%([^%%().*?[^$+-])", "%%%%%1")
		part = part:gsub("%%$", "%%%%")
		table.insert(result, part)
	end
	return table.concat(result, "%%")
end
function string.split(s, separator)
	if separator == nil then
		separator = "%s+"
	end
	local result = {}
	local i, j = s:find(separator)
	while i ~= nil do
		table.insert(result, s:sub(1, i - 1))
		s = s:sub(j + 1) or ""
		i, j = s:find(separator)
	end
	table.insert(result, s)
	return result
end
function string.trim(s, pattern)
	if pattern == nil then
		pattern = "%s+"
	end
	return s:gsub(("^" .. tostring(pattern)), ""):gsub((tostring(pattern) .. "$"), "")
end
local _native_table = table
local table = setmetatable({}, {
	__index = _native_table,
})
_MODULE.table = table
function table.assign(t, ...)
	for _, _t in pairs({
		...,
	}) do
		for key, value in pairs(_t) do
			if type(key) == "string" then
				t[key] = value
			end
		end
	end
end
function table.clone(t)
	local result = {}
	for key, value in pairs(t) do
		if type(value) == "table" then
			result[key] = table.clone(value)
		else
			result[key] = value
		end
	end
	return result
end
function table.copy(t)
	local result = {}
	for key, value in pairs(t) do
		result[key] = value
	end
	return result
end
function table.default(t, ...)
	for _, _t in pairs({
		...,
	}) do
		for key, value in pairs(_t) do
			if type(key) == "string" and t[key] == nil then
				t[key] = value
			end
		end
	end
end
function table.filter(t, callback)
	local result = {}
	for key, value in pairs(t) do
		if callback(value, key) then
			if type(key) == "number" then
				table.insert(result, value)
			else
				result[key] = value
			end
		end
	end
	return result
end
function table.find(t, callback)
	if type(callback) == "function" then
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
function table.keys(t)
	local result = {}
	for key, value in pairs(t) do
		table.insert(result, key)
	end
	return result
end
function table.map(t, callback)
	local result = {}
	for key, value in pairs(t) do
		local newValue, newKey = callback(value, key)
		if newKey ~= nil then
			result[newKey] = newValue
		elseif type(key) == "number" then
			table.insert(result, newValue)
		else
			result[key] = newValue
		end
	end
	return result
end
function table.reduce(t, result, callback)
	for key, value in pairs(t) do
		result = callback(result, value, key)
	end
	return result
end
function table.reverse(t)
	local len = #t
	for i = 1, math.floor(len / 2) do
		t[i], t[len - i + 1] = t[len - i + 1], t[i]
	end
end
function table.slice(t, i, j)
	if i == nil then
		i = 1
	end
	if j == nil then
		j = #t
	end
	local result, len = {}, #t
	if i < 0 then
		i = i + len + 1
	end
	if j < 0 then
		j = j + len + 1
	end
	for i = math.max(i, 0), math.min(j, len) do
		table.insert(result, t[i])
	end
	return result
end
function table.values(t)
	local result = {}
	for key, value in pairs(t) do
		table.insert(result, value)
	end
	return result
end
return _MODULE
-- Compiled with Erde 0.6.0-1
-- __ERDE_COMPILED__
