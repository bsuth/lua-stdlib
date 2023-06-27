# lua-stdlib

An extension of [Lua's standard library](https://www.lua.org/manual/5.1/manual.html#5).
Works with Lua 5.1+ and LuaJIT.

Only `stdlib.lua` is required. The source file (`stdlib.erde`) is written in
[Erde](https://erde-lang.github.io/) and compiled to Lua.

## Library Usage

The module exports both top level functions, as well as tables matching each of
Lua's standard libraries:

```lua
local stdlib = require('stdlib')

local my_table = {
  1,
  2,
  a = 'hello',
  b = 'world',
}

-- top level function
for key, value in stdlib.kpairs(my_table) do
  -- a hello
  -- b world
  print(key, value)
end

-- string library
print(stdlib.string.trim('  hello world ')) -- "hello world"
```

Only libraries from Lua 5.1+ are provided:

- `coroutine`
- `debug`
- `io`
- `math`
- `os`
- `package`
- `string`
- `table`

Each exported library will default index the native library, which is especially
useful for overriding local references:

```lua
local string = require('stdlib').string

-- native Lua method
print(string.sub('hello world', 1, 5)) -- "hello"

-- lua-stdlib method
print(string.trim('  hello world ')) -- "hello world"
```

## Global Usage

This module exports two special functions, `load` and `unload`, that can be used
to inject methods into the global namespace and Lua's native standard library
tables.

When calling `load`, any top level function exports (other than `load` and
`unload` themselves) will be injected into `_G` and table exports (i.e. libraries)
will have their methods copied over to their native Lua counterpart.

```lua
require('stdlib').load()

local my_table = {
  1,
  2,
  a = 'hello',
  b = 'world',
}

-- top level function (now global)
for key, value in kpairs(my_table) do
  -- a hello
  -- b world
  print(key, value)
end

-- native string library (now extended)
print(string.trim('  hello world ')) -- "hello world"
```

This action can be undone with `unload`, which will remove all injected methods.

```lua
local stdlib = require('stdlib')

stdlib.load()
stdlib.unload()

print(kpairs) -- nil
print(string.trim) -- nil
```

## API

### Top Level Functions

- [`load()`](#load)
- [`unload()`](#unload)
- [`kpairs(t)`](#kpairst)

### Libraries

- [`coroutine`](#coroutine)
- [`debug`](#debug)
- [`io`](#io)
- [`math`](#math)
    - [`math.clamp(x, min, max)`](#math.clampx-min-max)
    - [`math.round(x)`](#math.roundx)
    - [`math.sign(x)`](#math.signx)
- [`os`](#os)
- [`package`](#package)
- [`string`](#string)
    - [`string.escape(s)`](#string.escapes)
    - [`string.lpad(s, length, padding = ' ')`](#string.lpads-length-padding)
    - [`string.ltrim(s, pattern = '%s+')`](#string.ltrims-pattern)
    - [`string.pad(s, length, padding = ' ')`](#string.pads-length-padding)
    - [`string.rpad(s, length, padding = ' ')`](#string.rpads-length-padding)
    - [`string.rtrim(s, pattern = '%s+')`](#string.rtrims-pattern)
    - [`string.split(s, separator = '%s+')`](#string.splits-separator)
    - [`string.trim(s, pattern = '%s+')`](#string.trims-pattern)
- [`table`](#table)
    - [`table.assign(t, ...)`](#table.assignt-)
    - [`table.clone(t)`](#table.clonet)
    - [`table.copy(t)`](#table.copyt)
    - [`table.default(t, ...)`](#table.defaultt-)
    - [`table.filter(t, callback)`](#table.filtert-callback)
    - [`table.find(t, callback)`](#table.findt-callback)
    - [`table.keys(t)`](#table.keyst)
    - [`table.map(t, callback)`](#table.mapt-callback)
    - [`table.pack(...)`](#table.pack)
    - [`table.reduce(t, result, callback)`](#table.reducet-result-callback)
    - [`table.reverse(t)`](#table.reverset)
    - [`table.slice(t, i = 1, j = #t)`](#table.slicet-i-j)
    - [`table.unpack(t, i = 1, j = #t)`](#table.unpackt-i-j)
    - [`table.values(t)`](#table.valuest)

## Top Level Functions

### `load()`

Injects methods into `_G` and Lua's standard libraries (`coroutine`, `debug`, etc).

See [Global Usage](#global-usage) for more.

```lua
require('stdlib').load()
```

### `unload()`

Removes injected methods from `_G` and Lua's standard libraries (`coroutine`, `debug`, etc).

A check is done to ensure only methods injected by this module are removed (i.e.
if `require('stdlib').load()` is called and then the user manually overrides one
of the injected methods with their own function, it will _not_ be removed).

See [Global Usage](#global-usage) for more.

```lua
require('stdlib').unload()
```

### `kpairs(t)`

Iterator over (key, value) pairs (i.e. the map portion of a table). This acts as
a counterpart to `ipairs`, so `ipairs` + `kpairs` is equivalent to `pairs`.

```lua
local stdlib = require('stdlib')

local my_table = {
  1,
  2,
  a = 'hello',
  b = 'world',
}

for key, value in stdlib.kpairs(my_table) do
  -- a hello
  -- b world
  print(key, value)
end
```

## `coroutine`

Extension of [Lua's native `coroutine` library](https://www.lua.org/manual/5.1/manual.html#5.2).
Currently has no additional methods.

```lua
local coroutine = require('stdlib').coroutine
```

## `debug`

Extension of [Lua's native `debug` library](https://www.lua.org/manual/5.1/manual.html#5.9).
Currently has no additional methods.

```lua
local debug = require('stdlib').debug
```

## `io`

Extension of [Lua's native `io` library](https://www.lua.org/manual/5.1/manual.html#5.7).
Currently has no additional methods.

```lua
local io = require('stdlib').io
```

## `math`

Extension of [Lua's native `math` library](https://www.lua.org/manual/5.1/manual.html#5.6).

```lua
local math = require('stdlib').math
```

- [`math.clamp(x, min, max)`](#math.clampx-min-max)
- [`math.round(x)`](#math.roundx)
- [`math.sign(x)`](#math.signx)

#### `math.clamp(x, min, max)`

Returns `x`, but bounded by `min` and `max`.

```lua
local math = require('stdlib').math

print(math.clamp(2, 1, 3) -- 2
print(math.clamp(0, 1, 3) -- 1
print(math.clamp(4, 1, 3) -- 3
```

#### `math.round(x)`

Returns the value of `x`, rounded to the nearest whole number. Note that for
negative numbers, -0.5 will round down to -1.

```lua
local math = require('stdlib').math

print(math.round(0.4) -- 0
print(math.round(0.5) -- 1

print(math.round(-0.4) -- 0
print(math.round(-0.5) -- -1
```

#### `math.sign(x)`

Returns -1 if x is negative, 1 if x is positive, and otherwise 0.

```lua
local math = require('stdlib').math

print(math.sign(-4) -- -1
print(math.sign(0) -- 0
print(math.sign(9) -- 1
```

## `os`

Extension of [Lua's native `os` library](https://www.lua.org/manual/5.1/manual.html#5.8).
Currently has no additional methods.

```lua
local os = require('stdlib').os
```

## `package`

Extension of [Lua's native `package` library](https://www.lua.org/manual/5.1/manual.html#5.3).
Currently has no additional methods.

```lua
local package = require('stdlib').package
```

## `string`

Extension of [Lua's native `string` library](https://www.lua.org/manual/5.1/manual.html#5.4).

```lua
local string = require('stdlib').string
```

- [`string.escape(s)`](#string.escapes)
- [`string.lpad(s, length, padding = ' ')`](#string.lpads-length-padding)
- [`string.ltrim(s, pattern = '%s+')`](#string.ltrims-pattern)
- [`string.pad(s, length, padding = ' ')`](#string.pads-length-padding)
- [`string.rpad(s, length, padding = ' ')`](#string.rpads-length-padding)
- [`string.rtrim(s, pattern = '%s+')`](#string.rtrims-pattern)
- [`string.split(s, separator = '%s+')`](#string.splits-separator)
- [`string.trim(s, pattern = '%s+')`](#string.trims-pattern)

#### `string.escape(s)`

Returns a copy of `s` with any [magic characters](https://www.lua.org/pil/20.2.html)
escaped via `%`.

```lua
local string = require('stdlib').string

print(string.escape('volume: 43%')) -- "volume: 43%%"
print(string.escape('a+')) -- "a%+"
```

#### `string.lpad(s, length, padding = ' ')`

Returns the string `s`, prepended with `padding` until the string length is
greater than `length`. If `padding` is not specified, defaults to prepending
spaces.

```lua
local string = require('stdlib').string

print(string.lpad('aaa', 6)) -- "   aaa"
print(string.lpad('aaa', 6, 'bb')) -- "bbbbaaa"
```

#### `string.ltrim(s, pattern = '%s+')`

Returns the string `s` without any leading matches for `pattern`. If no pattern
is specified, defaults to removing any leading whitespace.

```lua
local string = require('stdlib').string

print(string.ltrim('  hello world    ')) -- "hello world    "
print(string.ltrim('aabbbcccaaaaa', 'a+')) -- "bbbcccaaaaa"
```

#### `string.pad(s, length, padding = ' ')`

Takes a string, `s`, and both prepends and appends `padding` until the string
length is greater than `length`, returning the resulting string. This always
preprends and appends at the same time, so that `s` is "centered" around the
padding. If `padding` is not specified, defaults to prepending / appending spaces.

```lua
local string = require('stdlib').string

print(string.pad('aaa', 6)) -- "  aaa  "
print(string.pad('aaa', 6, 'bb')) -- "bbaaabb"
```

#### `string.rpad(s, length, padding = ' ')`

Returns the string `s`, appended with `padding` until the string length is
greater than `length`. If `padding` is not specified, defaults to appending
spaces.

```lua
local string = require('stdlib').string

print(string.rpad('aaa', 6)) -- "aaa   "
print(string.rpad('aaa', 6, 'bb')) -- "aaabbbb"
```

#### `string.rtrim(s, pattern = '%s+')`

Returns the string `s` without any trailing matches for `pattern`. If no pattern
is specified, defaults to removing any trailing whitespace.

```lua
local string = require('stdlib').string

print(string.rtrim('  hello world    ')) -- "  hello world"
print(string.rtrim('aabbbcccaaaaa', 'a+')) -- "aabbbccc"
```

#### `string.split(s, separator = '%s+')`

Divides up `s` into parts, using `separator` as a delimiter and returns a table
of all parts. If no delimiter is specified, defaults to splitting on whitespace.

```lua
local string = require('stdlib').string

print(string.split('a b c d')) -- { 'a', 'b', 'c', 'd' }
print(string.split('aabbbcccaaaaa', 'b+')) -- { 'aa', 'cccaaaa' }
```

#### `string.trim(s, pattern = '%s+')`

Returns the string `s` without any leading / trailling matches for `pattern`.
If no pattern is specified, defaults to removing any leading / trailing
whitespace.

```lua
local string = require('stdlib').string

print(string.trim('  hello world    ')) -- "hello world"
print(string.trim('aabbbcccaaaaa', 'a+')) -- "bbbccc"
```

## `table`

Extension of [Lua's native `table` library](https://www.lua.org/manual/5.1/manual.html#5.5).

```lua
local table = require('stdlib').table
```

- [`table.assign(t, ...)`](#table.assignt-)
- [`table.clone(t)`](#table.clonet)
- [`table.copy(t)`](#table.copyt)
- [`table.default(t, ...)`](#table.defaultt-)
- [`table.filter(t, callback)`](#table.filtert-callback)
- [`table.find(t, callback)`](#table.findt-callback)
- [`table.keys(t)`](#table.keyst)
- [`table.map(t, callback)`](#table.mapt-callback)
- [`table.pack(...)`](#table.pack)
- [`table.reduce(t, result, callback)`](#table.reducet-result-callback)
- [`table.reverse(t)`](#table.reverset)
- [`table.slice(t, i = 1, j = #t)`](#table.slicet-i-j)
- [`table.unpack(t, i = 1, j = #t)`](#table.unpackt-i-j)
- [`table.values(t)`](#table.valuest)

#### `table.assign(t, ...)`

Accepts tables as varargs and copies all of their fields into `t'. Note that
array elements are _not_ copied.

```lua
local table = require('stdlib').table

local t = { a = 'hi' }

table.assign(t, { b = 'bye' }, { a = 'bye' })

print(t) -- { a = 'bye', b = 'bye' }
```

#### `table.clone(t)`

Returns a deep copy of t.

```lua
local table = require('stdlib').table

local t = { a = {} }
local clone = table.clone(t)

print(t) -- { a = {} }
print(clone) -- { a = {} }

print(t == clone) -- false
print(t.a == clone.a) -- false
```

#### `table.copy(t)`

Returns a shallow copy of t.

```lua
local table = require('stdlib').table

local t = { a = {} }
local copy = table.copy(t)

print(t) -- { a = {} }
print(copy) -- { a = {} }

print(t == copy) -- false
print(t.a == copy.a) -- true
```

#### `table.default(t, ...)`

Accepts tables as varargs and copies all of their fields into `t`, but only if
their is no such field already in `t`. Note that array elements are _not_ copied.

```lua
local table = require('stdlib').table

local t = { a = 'hi' }

table.default(t, { b = 'bye' }, { a = 'bye' })

print(t) -- { a = 'hi', b = 'bye' }
```

#### `table.filter(t, callback)`

Accepts a callback that takes `(value, key)` from `t` and returns a boolean.
Returns a subset of `t` for which `callback` returned `true`.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

local filtered = table.filter(t, function(value, key)
  if type(value) == 'number' then
    return value > 15
  else
    return key == 'b'
  end
end)

print(filtered) -- { 20, b = 'world' }
```

#### `table.find(t, callback)`

If `callback` is a function, expects a function that takes `(value, key)` from
`t` and returns a boolean. This method will then return the first `(value, key)`
for which the callback returns `true`.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

local found_value, found_key = table.find(t, function(value, key)
  return type(value) == 'number' and value > 10
end)

print(found_value, found_key) -- 20 2
```

If `callback` is _not_ a function, returns the first `(value, key)` where
`value == callback`.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

print(table.find(t, 'world')) -- world b
```

#### `table.keys(t)`

Returns an array of all keys of `t`. Note that no order is guaranteed by this
method.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

print(table.keys(t)) -- { 1, 2, 'a', 'b' }
```

#### `table.map(t, callback)`

Accepts a callback that takes `(value, key)` from `t` and returns either a new
value, or a new (value, key). Returns a table of mapped values, determined by
the returns of `callback`.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

local mapped = table.map(t, function(value, key)
  if type(value) == 'number' then
    return value + 5
  else
    return value, key:upper()
  end
end)

print(mapped) -- { 15, 25, A = 'hello', B = 'world' }
```

#### `table.pack(...)`

Polyfill for the Lua 5.2+ [`table.pack`](https://www.lua.org/manual/5.2/manual.html#pdf-table.pack)
function. This field only exists if `_VERSION` is `Lua 5.1`.

#### `table.reduce(t, result, callback)`

Accepts an initial value `result`, and a callback that takes `(result, value, key)`
and returns a new value for `result`. The callback is called for every
`(value, key)` in `t` and the final `result` is returned.

```lua
local table = require('stdlib').table

local t = { 10, 20, 30, 40 }

local reduced = table.map(t, 0, function(result, value, key)
  return result + value
end)

print(reduced) -- 100
```

#### `table.reverse(t)`

Reverses the order of the array portion of `t`.

```lua
local table = require('stdlib').table

local t = { 10, 20, 30, 40 }

table.reverse(t)

print(t) -- { 40, 30, 20, 10 }
```

#### `table.slice(t, i = 1, j = #t)`

Creates a subset of the array portion of `t` from `i` to `j` (inclusive). Note
that either of `i` or `j` may be given as negative numbers, which will be
counted down from the end of the array. If `i` is not specified, defaults to the
start of the array and if `j` is not specified, defaults to the end.

```lua
local table = require('stdlib').table

local t = { 10, 20, 30, 40 }

print(table.slice(t)) -- { 10, 20, 30, 40 }

print(table.slice(t, 2, 3)) -- { 20, 30 }

print(table.slice(t, -2)) -- { 30, 40 }
```

#### `table.unpack(t, i = 1, j = #t)`

Simply an alias for the Lua 5.1 [`unpack`](https://www.lua.org/manual/5.1/manual.html#pdf-unpack)
builtin. This field only exists if `_VERSION` is `Lua 5.1`. Note that this is
equivalent in behavior to the Lua 5.2+ [`table.unpack`](https://www.lua.org/manual/5.2/manual.html#pdf-table.unpack).

#### `table.values(t)`

Returns an array of all values of `t`. Note that no order is guaranteed by this
method.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

print(table.values(t)) -- { 10, 20, 'hello', 'world' }
```
