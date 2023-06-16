local _MODULE = {}
local
function
kpairs_iter
(a,i)
local key,value
=
i
,
nil
repeat
key
,
value
=
next(
a
,
key
)
until
type(
key
)
~=
(
'number'
)
return
key
,
value
end
local
function
kpairs
(t)
return
kpairs_iter
,
t
,
nil
end
_MODULE.kpairs = kpairs
return _MODULE
-- Compiled with Erde 0.6.0-1
-- __ERDE_COMPILED__