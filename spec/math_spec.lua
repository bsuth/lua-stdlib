local math
do
local __ERDE_TMP_2__
__ERDE_TMP_2__=
require(
(
'stl'
)
)
math = __ERDE_TMP_2__["math"]
end
spec(
(
'default index to native math lib'
)
,
function()
assert
.is_function(
math
.ceil
)
assert
.is_function(
math
.floor
)
assert
.is_function(
math
.min
)
assert
.is_function(
math
.max
)
end
)
spec(
(
'clamp'
)
,
function()
assert
.are
.equal(
0
,
math
.clamp(
0
,
0
,
1
)
)
assert
.are
.equal(
0.5
,
math
.clamp(
0.5
,
0
,
1
)
)
assert
.are
.equal(
0
,
math
.clamp(
-
0.5
,
0
,
1
)
)
assert
.are
.equal(
1
,
math
.clamp(
1.5
,
0
,
1
)
)
end
)
spec(
(
'product'
)
,
function()
assert
.are
.equal(
1
,
math
.product()
)
assert
.are
.equal(
0
,
math
.product(
0
)
)
assert
.are
.equal(
1
,
math
.product(
1
)
)
assert
.are
.equal(
24
,
math
.product(
1
,
2
,
3
,
4
)
)
assert
.are
.equal(
-
6
,
math
.product(
1
,
-
2
,
3
)
)
end
)
spec(
(
'round'
)
,
function()
assert
.are
.equal(
-
1
,
math
.round(
-
1
)
)
assert
.are
.equal(
-
1
,
math
.round(
-
0.9
)
)
assert
.are
.equal(
-
1
,
math
.round(
-
0.51
)
)
assert
.are
.equal(
0
,
math
.round(
-
0.5
)
)
assert
.are
.equal(
0
,
math
.round(
-
0.49
)
)
assert
.are
.equal(
0
,
math
.round(
-
0.1
)
)
assert
.are
.equal(
0
,
math
.round(
0
)
)
assert
.are
.equal(
0
,
math
.round(
0.1
)
)
assert
.are
.equal(
0
,
math
.round(
0.49
)
)
assert
.are
.equal(
1
,
math
.round(
0.5
)
)
assert
.are
.equal(
1
,
math
.round(
0.51
)
)
assert
.are
.equal(
1
,
math
.round(
0.9
)
)
assert
.are
.equal(
1
,
math
.round(
1
)
)
end
)
spec(
(
'sum'
)
,
function()
assert
.are
.equal(
0
,
math
.sum()
)
assert
.are
.equal(
0
,
math
.sum(
0
)
)
assert
.are
.equal(
1
,
math
.sum(
1
)
)
assert
.are
.equal(
10
,
math
.sum(
1
,
2
,
3
,
4
)
)
assert
.are
.equal(
-
2
,
math
.sum(
1
,
-
2
,
3
,
-
4
)
)
end
)
-- Compiled with Erde 0.6.0-1
-- __ERDE_COMPILED__