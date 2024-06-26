# lua-stdlib

An extension of [Lua's standard library](https://www.lua.org/manual/5.1/manual.html#5).
Works with Lua 5.1+ and LuaJIT.

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

Each exported library uses its native library as its `__index` metamethod,
which is especially useful for overriding local references:

```lua
local string = require('stdlib').string

-- native Lua method
print(string.sub('hello world', 1, 5)) -- "hello"

-- lua-stdlib method
print(string.trim('  hello world ')) -- "hello world"
```

## API

### Top Level Functions

- [`compare(a, b)`](#compareab)
- [`kpairs(t)`](#kpairst)

### Libraries

- [`coroutine`](#coroutine)
- [`debug`](#debug)
- [`io`](#io)
    - [`io.exists(path)`](#ioexistspath)
    - [`io.readfile(path)`](#ioreadfilepath)
    - [`io.writefile(path, content)`](#iowritefilepath-content)
- [`math`](#math)
    - [`math.clamp(x, min, max)`](#mathclampx-min-max)
    - [`math.round(x)`](#mathroundx)
    - [`math.sign(x)`](#mathsignx)
- [`os`](#os)
    - [`os.capture(cmd)`](#oscapturecmd)
- [`package`](#package)
- [`string`](#string)
    - [`string.chars(s)`](#stringcharss)
    - [`string.escape(s)`](#stringescapes)
    - [`string.split(s, separator = '%s+')`](#stringsplits-separator--s)
    - [`string.trim(s, pattern = '%s+')`](#stringtrims-pattern--s)
- [`table`](#table)
    - [`table.clear(t, callback)`](#tablecleart-callback)
    - [`table.collect(...)`](#tablecollect)
    - [`table.deepcopy(t)`](#tabledeepcopyt)
    - [`table.filter(t, callback)`](#tablefiltert-callback)
    - [`table.find(t, callback)`](#tablefindt-callback)
    - [`table.has(t, callback)`](#tablehast-callback)
    - [`table.keys(t)`](#tablekeyst)
    - [`table.map(t, callback)`](#tablemapt-callback)
    - [`table.merge(t, ...)`](#tablemerget-)
    - [`table.pack(...)`](#tablepack)
    - [`table.reduce(t, initial, callback)`](#tablereducet-initial-callback)
    - [`table.reverse(t)`](#tablereverset)
    - [`table.shallowcopy(t)`](#tableshallowcopyt)
    - [`table.slice(t, i = 1, j = #t)`](#tableslicet-i--1-j--t)
    - [`table.unpack(t, i = 1, j = #t)`](#tableunpackt-i--1-j--t)
    - [`table.values(t)`](#tablevaluest)

## Top Level Functions

### `compare(a, b)`

Deep compare the values `a` and `b`, i.e. if both `a` and `b` are tables, then
ensure they have the same fields / same length, then recursively `compare`
all of their values, otherwise return `a == b`.

```lua
local compare = require('stdlib').compare

local a = { a = 'hello', 'world' }
local b = { a = 'hello', 'world' }
local c = { a = 'bye', 'world' }

print(compare(a, b)) -- true
print(compare(a, c)) -- false
print(compare(b, c)) -- false
```

### `kpairs(t)`

Iterator over (key, value) pairs (i.e. the map portion of a table). This acts as
a counterpart to `ipairs`, so `ipairs` + `kpairs` is equivalent to `pairs`.

```lua
local kpairs = require('stdlib').kpairs

local my_table = {
  1,
  2,
  a = 'hello',
  b = 'world',
}

for key, value in kpairs(my_table) do
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

```lua
local io = require('stdlib').io
```

- [`io.exists(path)`](#ioexistspath)
- [`io.readfile(path)`](#ioreadfilepath)
- [`io.writefile(path, content)`](#iowritefilepath-content)

#### `io.exists(path)`

Returns true if `path` exists in the file system, otherwise false.

```lua
local io = require('stdlib').io

print(io.exists('my_file') -- true
print(io.exists('my/nested/file') -- true
print(io.exists('my_fake_file') -- false
```

#### `io.readfile(path)`

Reads and returns the entire contents of the file at `path`. Any error messages
returned from `io.open` or `file:read` are instead thrown via `error`.

```lua
local io = require('stdlib').io

io.writefile('my_file', 'hello world')

print(io.readfile('my_file') -- hello world
print(io.readfile('my_fake_file') -- error! my_fake_file does not exist
```

#### `io.writefile(path, content)`

Overwrites all contents of the file at `path` with `content`. Any error messages
returned from `io.open` or `file:write` are instead thrown via `error`.

```lua
local io = require('stdlib').io

print(io.readfile('my_empty_file') -- ''

io.writefile('my_empty_file', 'hello world')

print(io.readfile('my_empty_file') -- hello world
```

## `math`

Extension of [Lua's native `math` library](https://www.lua.org/manual/5.1/manual.html#5.6).

```lua
local math = require('stdlib').math
```

- [`math.clamp(x, min, max)`](#mathclampx-min-max)
- [`math.round(x)`](#mathroundx)
- [`math.sign(x)`](#mathsignx)

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

```lua
local os = require('stdlib').os
```

- [`os.capture(cmd)`](#oscapturecmd)

#### `os.capture(cmd)`

Executes a command `cmd` and returns the output (stdout) as a string.

## `package`

Extension of [Lua's native `package` library](https://www.lua.org/manual/5.1/manual.html#5.3).
Currently has no additional methods.

## `string`

Extension of [Lua's native `string` library](https://www.lua.org/manual/5.1/manual.html#5.4).

```lua
local string = require('stdlib').string
```

- [`string.chars(s)`](#stringcharss)
- [`string.escape(s)`](#stringescapes)
- [`string.split(s, separator = '%s+')`](#stringsplits-separator--s)
- [`string.trim(s, pattern = '%s+')`](#stringtrims-pattern--s)

#### `string.chars(s)`

Iterator over all characters in the string `s`. Iterations return `(i, char)`,
with `i` being the index of the given character.

```lua
local string = require('stdlib').string

for i, char in string.chars('hello') do
    -- 1, h
    -- 2, e
    -- 3, l
    -- 4, l
    -- 5, o
    print(i, char)
end
```

#### `string.escape(s)`

Returns a copy of `s` with any [magic characters](https://www.lua.org/pil/20.2.html)
escaped via `%`.

```lua
local string = require('stdlib').string

print(string.escape('volume: 43%')) -- "volume: 43%%"
print(string.escape('a+')) -- "a%+"
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

- [`table.assign(t, ...)`](#tableassignt-)
- [`table.clear(t, callback)`](#tablecleart-callback)
- [`table.collect(...)`](#tablecollect)
- [`table.deepcopy(t)`](#tabledeepcopyt)
- [`table.filter(t, callback)`](#tablefiltert-callback)
- [`table.find(t, callback)`](#tablefindt-callback)
- [`table.has(t, callback)`](#tablehast-callback)
- [`table.keys(t)`](#tablekeyst)
- [`table.map(t, callback)`](#tablemapt-callback)
- [`table.merge(...)`](#tablemerge)
- [`table.pack(...)`](#tablepack)
- [`table.reduce(t, initial, callback)`](#tablereducet-initial-callback)
- [`table.reverse(t)`](#tablereverset)
- [`table.shallowcopy(t)`](#tableshallowcopyt)
- [`table.slice(t, i = 1, j = #t)`](#tableslicet-i--1-j--t)
- [`table.unpack(t, i = 1, j = #t)`](#tableunpackt-i--1-j--t)
- [`table.values(t)`](#tablevaluest)

#### `table.assign(t, ...)`

Accepts tables as varargs and for each such table, copies all fields and appends
all array elements into `t`. This is the mutable version of
[`table.merge(...)`](#tablemerge).

```lua
local table = require('stdlib').table

local t = { a = 'hi' }

table.assign(t, { b = 'bye' }, { a = 'bye' }, { 10, 20, 30 })

print(t) -- { a = 'bye', b = 'bye', 10, 20, 30 }
```

#### `table.clear(t, callback)`

If `callback` is a function, expects a function that takes `(value, key)` from
`t` and returns a boolean. This method will remove all entries from `t` for which
`callback` returns true. This is the mutable version of
[`table.filter(t, callback)`](#tablefiltert-callback).

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 10, b = 20 }

table.clear(t, function(value, key)
  return value == 10
end)

print(t) -- { 20, b = 20 }
```

If `callback` is _not_ a function, this method will remove all entries from `t`
where `value == callback`.

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 10, b = 20 }

table.clear(t, 10)

print(t) -- { 20, b = 20 }
```

#### `table.collect(...)`

Iterates using the provided [generic for](https://www.lua.org/pil/7.2.html)
vararg expressions and places the iteration results into a table. If the
iteration returns two values, the first will be used as a key and the second as
the value. Otherwise the iteration return will simply be inserted into the array
portion of the resulting table.

```lua
local kpairs = require('stdlib').kpairs
local table = require('stdlib').table

local t = { a = 1, b = 2, 10, 20, 30 }

print(table.collect(ipairs(t))) -- { 10, 20, 30 }
print(table.collect(kpairs(t))) -- { a = 1, b = 2 }
```

#### `table.deepcopy(t)`

Returns a deep copy of t.

```lua
local table = require('stdlib').table

local t = { a = {} }
local copy = table.deepcopy(t)

print(t) -- { a = {} }
print(clone) -- { a = {} }

print(t == clone) -- false
print(t.a == clone.a) -- false
```

#### `table.filter(t, callback)`

Accepts a callback that takes `(value, key)` from `t` and returns a boolean.
Returns a subset of `t` for which `callback` returned `true`. This is the
immutable version of [`table.clear(t, callback)`](#tablecleart-callback).

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

#### `table.has(t, callback)`

Same behavior as [`table.find`](#tablefindt-callback), but returns true if a
value is found and otherwise false

```lua
local table = require('stdlib').table

local t = { 10, 20, a = 'hello', b = 'world' }

print(table.has(t, 'world')) -- true
print(table.has(t, 'blah')) -- false

print(table.has(t, function(value, key)
  return type(value) == 'number' and value > 10
end)) -- true

print(table.has(t, function(value, key)
  return type(value) == 'number' and value > 1000
end)) -- false
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

#### `table.merge(...)`

Accepts tables as varargs and returns a table with all fields copied and all
array elements appended. This is the immutable version of
[`table.assign(t, ...)`](#tableassignt-).

```lua
local table = require('stdlib').table

local t = table.merge(
  { a = 'hi' },
  { b = 'bye' },
  { 10, 20, 30 }
)

print(t) -- { a = 'hi', b = 'bye', 10, 20, 30 }
```

#### `table.pack(...)`

Polyfill for the Lua 5.2+ [`table.pack`](https://www.lua.org/manual/5.2/manual.html#pdf-table.pack)
function. This field only exists if `_VERSION` is `Lua 5.1`.

#### `table.reduce(t, initial, callback)`

Accepts an initial value `initial`, and a callback that takes `(result, value, key)`.
The callback is called for every `(value, key)` in `t`, with the first call
having `result == initial` and subsequent calls using the return value of the
previous call. The final `result` is returned.

```lua
local table = require('stdlib').table

local t = { 10, 20, 30, 40 }

local reduced = table.reduce(t, 0, function(result, value, key)
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

#### `table.shallowcopy(t)`

Returns a shallow copy of t.

```lua
local table = require('stdlib').table

local t = { a = {} }
local copy = table.shallowcopy(t)

print(t) -- { a = {} }
print(copy) -- { a = {} }

print(t == copy) -- false
print(t.a == copy.a) -- true
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
