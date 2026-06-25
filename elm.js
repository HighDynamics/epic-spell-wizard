(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.ar.M === region.aB.M)
	{
		return 'on line ' + region.ar.M;
	}
	return 'on lines ' + region.ar.M + ' through ' + region.aB.M;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (typeof x.$ === 'undefined')
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**_UNUSED/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bf,
		impl.bx,
		impl.bt,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**_UNUSED/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**/
	var node = args['node'];
	//*/
	/**_UNUSED/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS
//
// For some reason, tabs can appear in href protocols and it still works.
// So '\tjava\tSCRIPT:alert("!!!")' and 'javascript:alert("!!!")' are the same
// in practice. That is why _VirtualDom_RE_js and _VirtualDom_RE_js_html look
// so freaky.
//
// Pulling the regular expressions out to the top level gives a slight speed
// boost in small benchmarks (4-10%) but hoisting values to reduce allocation
// can be unpredictable in large programs where JIT may have a harder time with
// functions are not fully self-contained. The benefit is more that the js and
// js_html ones are so weird that I prefer to see them near each other.


var _VirtualDom_RE_script = /^script$/i;
var _VirtualDom_RE_on_formAction = /^(on|formAction$)/i;
var _VirtualDom_RE_js = /^\s*j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:/i;
var _VirtualDom_RE_js_html = /^\s*(j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:|d\s*a\s*t\s*a\s*:\s*t\s*e\s*x\s*t\s*\/\s*h\s*t\s*m\s*l\s*(,|;))/i;


function _VirtualDom_noScript(tag)
{
	return _VirtualDom_RE_script.test(tag) ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return _VirtualDom_RE_on_formAction.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return _VirtualDom_RE_js.test(value)
		? /**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return _VirtualDom_RE_js_html.test(value)
		? /**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlJson(value)
{
	return (typeof _Json_unwrap(value) === 'string' && _VirtualDom_RE_js_html.test(_Json_unwrap(value)))
		? _Json_wrap(
			/**/''//*//**_UNUSED/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		) : value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		y: func(record.y),
		as: record.as,
		ag: record.ag
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.y;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.as;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.ag) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bf,
		impl.bx,
		impl.bt,
		function(sendToApp, initialModel) {
			var view = impl.by;
			/**/
			var domNode = args['node'];
			//*/
			/**_UNUSED/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bf,
		impl.bx,
		impl.bt,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.ao && impl.ao(sendToApp)
			var view = impl.by;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.a2);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.bv) && (_VirtualDom_doc.title = title = doc.bv);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.bl;
	var onUrlRequest = impl.bm;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		ao: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.aO === next.aO
							&& curr.aF === next.aF
							&& curr.aL.a === next.aL.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		bf: function(flags)
		{
			return A3(impl.bf, flags, _Browser_getUrl(), key);
		},
		by: impl.by,
		bx: impl.bx,
		bt: impl.bt
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { bc: 'hidden', a3: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { bc: 'mozHidden', a3: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { bc: 'msHidden', a3: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { bc: 'webkitHidden', a3: 'webkitvisibilitychange' }
		: { bc: 'hidden', a3: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		aS: _Browser_getScene(),
		aV: {
			aX: _Browser_window.pageXOffset,
			aY: _Browser_window.pageYOffset,
			aW: _Browser_doc.documentElement.clientWidth,
			aE: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		aW: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		aE: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			aS: {
				aW: node.scrollWidth,
				aE: node.scrollHeight
			},
			aV: {
				aX: node.scrollLeft,
				aY: node.scrollTop,
				aW: node.clientWidth,
				aE: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			aS: _Browser_getScene(),
			aV: {
				aX: x,
				aY: y,
				aW: _Browser_doc.documentElement.clientWidth,
				aE: _Browser_doc.documentElement.clientHeight
			},
			a6: {
				aX: x + rect.left,
				aY: y + rect.top,
				aW: rect.width,
				aE: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var $elm$core$Basics$EQ = 1;
var $elm$core$Basics$LT = 0;
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$GT = 2;
var $author$project$Types$CopyResult = function (a) {
	return {$: 19, a: a};
};
var $elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var $elm$core$Basics$False = 1;
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Maybe$Nothing = {$: 1};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 0:
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 1) {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 1:
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 2:
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.e) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.g),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.g);
		} else {
			var treeLen = builder.e * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.h) : builder.h;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.e);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.g) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.g);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{h: nodeList, e: (len / $elm$core$Array$branchFactor) | 0, g: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = 0;
var $elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$bool = _Json_decodeBool;
var $author$project$Main$copyResult = _Platform_incomingPort('copyResult', $elm$json$Json$Decode$bool);
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 1, a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = $elm$core$Basics$identity;
var $elm$url$Url$Http = 0;
var $elm$url$Url$Https = 1;
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {aD: fragment, aF: host, aJ: path, aL: port_, aO: protocol, aP: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 1) {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		0,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		1,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = $elm$core$Basics$identity;
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return 0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0;
		return A2($elm$core$Task$map, tagger, task);
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			A2($elm$core$Task$map, toMessage, task));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$Types$MarkdownExport = 0;
var $author$project$Main$init = {k: _List_Nil, X: $elm$core$Maybe$Nothing, aa: 0, ab: true, N: 0, G: $elm$core$Maybe$Nothing, t: $elm$core$Maybe$Nothing, j: _List_Nil, al: true, am: $elm$core$Maybe$Nothing, an: $elm$core$Maybe$Nothing, ap: '', at: true, I: $elm$core$Maybe$Nothing};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$Types$PersonalToArea = 12;
var $author$project$Types$TargetToArea = 11;
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Main$copyToClipboard = _Platform_outgoingPort('copyToClipboard', $elm$json$Json$Encode$string);
var $elm$core$Dict$RBEmpty_elm_builtin = {$: -2};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $author$project$Types$Augmenting = 0;
var $author$project$Types$Mitigating = 1;
var $author$project$Types$DcMultiplier = 2;
var $author$project$Types$PermanentDuration = 7;
var $author$project$Types$StoneTablet = 26;
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (!maybeValue.$) {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Types$Foresee = 13;
var $author$project$Types$Reveal = 18;
var $author$project$Types$Afflict = 0;
var $author$project$Types$Negates = 0;
var $author$project$Types$S = 1;
var $author$project$Types$SeedStackable = 1;
var $author$project$Types$V = 0;
var $author$project$Types$WillSave = 0;
var $author$project$Seeds$afflict = {
	U: $elm$core$Maybe$Nothing,
	a0: 14,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'Afflicts the target with a –2 morale penalty on attack rolls, checks, and saving throws. For each additional –1 penalty assessed on either the target\'s attack rolls, checks, or saving throws, increase the Spellcraft DC by +2. A character may also develop a spell with this seed that afflicts the target with a –1 penalty on caster level checks, a –1 penalty to an ability score, a –1 penalty to Spell Resistance, or a –1 penalty to some other aspect of the target. For each additional –1 penalty assessed in one of the above categories, increase the Spellcraft DC by +4. This seed can afflict a character\'s ability scores to the point where they reach 0, except for Constitution where 1 is the minimum. If a factor is applied to increase the duration of this seed, ability score penalties instead become temporary ability damage. If a factor is applied to make the duration permanent, any ability score penalties become permanent ability drain. Finally, by increasing the Spellcraft DC by +2, one of the target\'s senses can be afflicted: sight, smell, hearing, taste, touch, or a special sense the target possesses. If the target fails its saving throw, the sense selected doesn\'t function for the spell\'s duration, with all attendant penalties that apply for losing the specified sense.',
	Z: _List_fromArray(
		['Fear', 'Mind-Affecting']),
	_: '20 minutes',
	S: $elm$core$Maybe$Nothing,
	bd: 0,
	bj: _List_Nil,
	q: 'Afflict',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 0}),
	ak: 'Enchantment (Compulsion)',
	aq: true,
	au: $elm$core$Maybe$Just('One living creature'),
	bw: _List_fromArray(
		[
			{Y: 2, aA: 'Each additional –1 morale penalty beyond base –2', bd: 'afflict_rolls', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Additional –1 to rolls/checks/saves'},
			{Y: 4, aA: 'Each –1 penalty to Strength score', bd: 'afflict_ability_str', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Strength'},
			{Y: 4, aA: 'Each –1 penalty to Dexterity score', bd: 'afflict_ability_dex', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Dexterity'},
			{Y: 4, aA: 'Each –1 penalty to Constitution score', bd: 'afflict_ability_con', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Constitution'},
			{Y: 4, aA: 'Each –1 penalty to Intelligence score', bd: 'afflict_ability_int', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Intelligence'},
			{Y: 4, aA: 'Each –1 penalty to Wisdom score', bd: 'afflict_ability_wis', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Wisdom'},
			{Y: 4, aA: 'Each –1 penalty to Charisma score', bd: 'afflict_ability_cha', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to Charisma'},
			{Y: 4, aA: 'Each –1 penalty to caster level checks', bd: 'afflict_cl', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to caster level checks'},
			{Y: 4, aA: 'Each –1 penalty to spell resistance', bd: 'afflict_sr', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to spell resistance'},
			{Y: 4, aA: 'Each –1 penalty to some other aspect of the target', bd: 'afflict_other', bh: 1, a: $elm$core$Maybe$Nothing, q: '–1 to other aspect'},
			{Y: 2, aA: 'One sense (sight, smell, hearing, taste, touch, or special) ceases to function for duration', bd: 'afflict_sense', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Afflict a sense'}
		])
};
var $author$project$Types$Animate = 1;
var $author$project$Types$SeedToggle = 0;
var $author$project$Seeds$animate = {
	U: $elm$core$Maybe$Nothing,
	a0: 25,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed can imbue inanimate objects with mobility and a semblance of life (not actual life). The animated object attacks whomever or whatever the caster initially designates. The animated object can be of any nonmagical material. The caster can also animate part of a larger mass of raw matter, such as a volume of water in the ocean, part of a stony wall, or the earth itself, as long as the volume of material does not exceed 20 cubic feet. For each additional 10 cubic feet of matter animated, increase the Spellcraft DC by +1, up to 1,000 cubic feet. For each additional 100 cubic feet of matter animated after the first 1,000 cubic feet, increase the Spellcraft DC by +1. For each additional Hit Die granted to an animated object of a given size, increase the Spellcraft DC by +2. To animate attended objects (objects carried or worn by another creature), increase the Spellcraft DC by +10.',
	Z: _List_Nil,
	_: '20 rounds',
	S: $elm$core$Maybe$Nothing,
	bd: 1,
	bj: _List_Nil,
	q: 'Animate',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Transmutation',
	aq: false,
	au: $elm$core$Maybe$Just('Object or 20 cu. ft. of matter'),
	bw: _List_fromArray(
		[
			{
			Y: 1,
			aA: 'Increases animated volume beyond base 20 cu. ft., up to 1,000 cu. ft.',
			bd: 'animate_vol_1k',
			bh: 1,
			a: $elm$core$Maybe$Just(98),
			q: 'Each additional 10 cu. ft. (up to 1,000)'
		},
			{Y: 1, aA: 'Increases animated volume beyond 1,000 cu. ft.', bd: 'animate_vol_over1k', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 100 cu. ft. (beyond 1,000)'},
			{Y: 2, aA: 'Each additional HD granted to the animated object', bd: 'animate_hd', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Additional Hit Die for animated object'},
			{
			Y: 10,
			aA: 'Objects carried or worn by another creature',
			bd: 'animate_attended',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Animate attended objects'
		}
		])
};
var $author$project$Types$AnimateDead = 2;
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $author$project$Seeds$animateDead = {
	U: $elm$core$Maybe$Nothing,
	a0: 23,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'The caster can turn the bones or bodies of dead creatures into undead that follow his or her spoken commands. The undead can follow the caster, or they can remain in an area and attack any creature (or a specific type of creature) entering the place. The undead remain animated until they are destroyed. (A destroyed undead can\'t be animated again.) Intelligent undead can follow more sophisticated commands. The animate dead seed allows a character to create 20 HD of undead. For each additional 1 HD of undead created, increase the Spellcraft DC by +1. The undead created remain under the caster\'s control indefinitely. A caster can naturally control 1 HD per caster level of undead creatures he or she has personally created, regardless of the method used. If the caster exceeds this number, newly created creatures fall under his or her control, and excess undead from previous castings become uncontrolled (the caster chooses which creatures are released). If the caster is a cleric, any undead he or she commands through his or her ability to command or rebuke undead do not count toward the limit. For each additional 2 HD of undead to be controlled, increase the Spellcraft DC by +1. Only undead in excess of 20 HD created with this seed can be controlled using this DC adjustment. To both create and control more than 20 HD of undead, increase the Spellcraft DC by +3 per additional 2 HD of undead.\n\nType of Undead: All types of undead can be created with the animate dead seed, although creating more powerful undead increases the Spellcraft DC of the epic spell, according to the table below. The GM must set the Spellcraft DC for undead not included on the table, using similar undead as a basis for comparison.',
	Z: _List_fromArray(
		['Evil']),
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 2,
	bj: _List_Nil,
	q: 'Animate Dead',
	ah: 'Touch',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Necromancy',
	aq: false,
	au: $elm$core$Maybe$Just('One or more corpses touched'),
	bw: _List_fromArray(
		[
			{Y: 1, aA: 'Above base 20 HD', bd: 'adead_extra_hd_create', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1 HD of undead created'},
			{Y: 1, aA: 'Control undead beyond free limit (above 20 HD created)', bd: 'adead_extra_hd_control', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 2 HD to control'},
			{
			Y: -12,
			aA: 'DC modifier for skeleton type',
			bd: 'adead_skeleton',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Skeleton'
		},
			{
			Y: -12,
			aA: 'DC modifier for zombie type',
			bd: 'adead_zombie',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Zombie'
		},
			{
			Y: -10,
			aA: 'DC modifier for ghoul type',
			bd: 'adead_ghoul',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Ghoul'
		},
			{
			Y: -8,
			aA: 'DC modifier for shadow type',
			bd: 'adead_shadow',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Shadow'
		},
			{
			Y: -6,
			aA: 'DC modifier for ghast type',
			bd: 'adead_ghast',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Ghast'
		},
			{
			Y: -4,
			aA: 'DC modifier for wight type',
			bd: 'adead_wight',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Wight'
		},
			{
			Y: -2,
			aA: 'DC modifier for wraith type',
			bd: 'adead_wraith',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Wraith'
		},
			{
			Y: 0,
			aA: 'DC modifier for mummy type',
			bd: 'adead_mummy',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Mummy'
		},
			{
			Y: 2,
			aA: 'DC modifier for spectre type',
			bd: 'adead_spectre',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Spectre'
		},
			{
			Y: 4,
			aA: 'DC modifier for mohrg type',
			bd: 'adead_mohrg',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Mohrg'
		},
			{
			Y: 6,
			aA: 'DC modifier for vampire type',
			bd: 'adead_vampire',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Vampire'
		},
			{
			Y: 8,
			aA: 'DC modifier for ghost type',
			bd: 'adead_ghost',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Undead type: Ghost'
		}
		])
};
var $author$project$Types$Armor = 3;
var $author$project$Seeds$armor = {
	U: $elm$core$Maybe$Nothing,
	a0: 14,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed grants a creature additional armor, providing a +4 bonus to Armor Class. The bonus is either an armor bonus or a natural armor bonus, whichever the caster selects. Unlike mundane armor, the armor seed provides an intangible protection that entails no armor check penalty, arcane spell failure chance, or speed reduction. Incorporeal creatures can\'t bypass the armor seed the way they can ignore normal armor. For each additional point of Armor Class bonus, increase the Spellcraft DC by +2. The caster can also grant a creature a +1 bonus to Armor Class using a different bonus type, such as deflection, divine, or insight. For each additional point of bonus to Armor Class of one of these types, increase the Spellcraft DC by +10.',
	Z: _List_fromArray(
		['Force']),
	_: '24 hours (D)',
	S: $elm$core$Maybe$Nothing,
	bd: 3,
	bj: _List_Nil,
	q: 'Armor',
	ah: 'Touch',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: true, ai: 0}),
	ak: 'Conjuration (Creation)',
	aq: true,
	au: $elm$core$Maybe$Just('Creature touched'),
	bw: _List_fromArray(
		[
			{Y: 2, aA: 'Above base +4', bd: 'armor_ac_bonus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional +1 armor/natural armor bonus'},
			{Y: 10, aA: 'Bonus type other than armor/natural armor, per +1', bd: 'armor_other_type', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 bonus of other type (deflection, divine, insight…)'}
		])
};
var $author$project$Types$Banish = 4;
var $author$project$Seeds$banish = {
	U: $elm$core$Maybe$Nothing,
	a0: 27,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed forces extraplanar creatures out of the caster\'s home plane. The caster can banish up to 14 HD of extraplanar creatures. For each additional 2 HD of extraplanar creatures banished, increase the Spellcraft DC by +1. To specify a type or subtype of creature other than outsider to be banished, increase the Spellcraft DC by +20.',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 4,
	bj: _List_Nil,
	q: 'Banish',
	ah: '75 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 0}),
	ak: 'Abjuration',
	aq: true,
	au: $elm$core$Maybe$Just('One or more extraplanar creatures, no two more than 30 ft. apart'),
	bw: _List_fromArray(
		[
			{Y: 1, aA: 'Above base 14 HD', bd: 'banish_hd', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 2 HD banished'},
			{
			Y: 20,
			aA: 'Banish a creature type other than outsider',
			bd: 'banish_type',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Specify non-outsider creature type/subtype'
		}
		])
};
var $author$project$Types$Compel = 5;
var $author$project$Types$M = 2;
var $author$project$Seeds$compel = {
	U: $elm$core$Maybe$Nothing,
	a0: 19,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 2]),
	aA: 'This seed compels a target to follow a course of activity. At the basic level of effect, a spell using the compel seed must be worded in such a manner as to make the activity sound reasonable. Asking the creature to do an obviously harmful act automatically negates the effect (unless the Spellcraft DC has been increased to avoid this limitation; see below). To compel a creature to follow an outright unreasonable course of action, increase the Spellcraft DC by +10. The compelled course of activity can continue for the entire duration. If the compelled activity can be completed in a shorter time, the spell ends when the subject finishes what he or she was asked to do. The caster can instead specify conditions that will trigger a special activity during the duration. If the condition is not met before the spell using this seed expires, the activity is not performed.',
	Z: _List_fromArray(
		['Mind-Affecting']),
	_: '20 hours or until completed',
	S: $elm$core$Maybe$Nothing,
	bd: 5,
	bj: _List_Nil,
	q: 'Compel',
	ah: '75 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 0}),
	ak: 'Enchantment (Compulsion)',
	aq: true,
	au: $elm$core$Maybe$Just('One living creature'),
	bw: _List_fromArray(
		[
			{
			Y: 10,
			aA: 'Removes the \'sounds reasonable\' restriction',
			bd: 'compel_unreasonable',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Compel outright unreasonable / self-harmful action'
		}
		])
};
var $author$project$Types$Conceal = 6;
var $author$project$Seeds$conceal = {
	U: $elm$core$Maybe$Nothing,
	a0: 17,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed can conceal a creature or object touched from sight, even from darkvision. If the subject is a creature carrying gear, the gear vanishes too, rendering the creature invisible. A spell using the conceal seed ends if the subject attacks any creature. Actions directed at unattended objects do not break the spell, and causing harm indirectly is not an attack. To create invisibility that lasts regardless of the actions of the subject, increase the Spellcraft DC by +4. Alternatively, this seed can conceal the exact location of the subject so that it appears to be about 2 feet away from its true location; this increases the Spellcraft DC by +2. The subject benefits from a 50% miss chance as if it had total concealment. However, unlike actual total concealment, this displacement effect does not prevent enemies from targeting him or her normally. The conceal seed can also be used to block divination spells, spell-like effects, and epic spells developed using the reveal seed; this increases the Spellcraft DC by +6. In all cases where divination magic of any level, including epic level, is employed against the subject of a spell using the conceal seed for this purpose, an opposed caster level check determines which spell works.',
	Z: _List_Nil,
	_: '200 minutes or until expended (D)',
	S: $elm$core$Maybe$Nothing,
	bd: 6,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 4,
					aA: 'Normally ends if subject attacks; this removes that restriction',
					bd: 'conceal_persist',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Persistent invisibility (regardless of actions)'
				}
				]),
			bd: 'conceal_invisibility',
			q: 'Invisibility'
		},
			{a8: _List_Nil, bd: 'conceal_displacement', q: 'Displacement'}
		]),
	q: 'Conceal',
	ah: 'Personal or touch',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Illusion (Glamer)',
	aq: false,
	au: $elm$core$Maybe$Just('You or a creature or object of up to 2,000 lb.'),
	bw: _List_fromArray(
		[
			{
			Y: 6,
			aA: 'Opposed caster level check determines which spell works',
			bd: 'conceal_block_divination',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Block divination / reveal-seed spells'
		}
		])
};
var $author$project$Types$Conjure = 7;
var $author$project$Seeds$conjure = {
	U: $elm$core$Maybe$Nothing,
	a0: 21,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed creates a nonmagical, unattended object of nonliving matter of up to 20 cubic feet in volume. The caster must succeed at an appropriate skill check to make a complex item. The seed can create matter ranging in hardness and rarity from vegetable matter all the way up to mithral and even adamantine. Simple objects have a natural duration of 24 hours. For each additional cubic foot of matter created, increase the Spellcraft DC by +2. Attempting to use any created object as a material component or a resource during epic spell development causes the spell to fail and the object to disappear.\n\nThe Conjure seed can be used in conjunction with the life and fortify seeds for an epic spell that creates an entirely new creature, if made permanent. To give a creature spell-like abilities, apply other epic seeds to the epic spell that replicate the desired ability. To give the creature a supernatural or extraordinary ability rather than a spell-like ability, double the cost of the relevant seed. Remember that two doublings equals a tripling, and so forth. To give a creature Hit Dice, use the fortify seed. Each 5 hit points granted to the creature gives it an additional 1 HD. Once successfully created, the new creature will breed true.',
	Z: _List_Nil,
	_: '8 hours (simple objects last 24 hours)',
	S: $elm$core$Maybe$Just('Unattended, nonmagical object of nonliving matter up to 20 cu. ft.'),
	bd: 7,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Above base 20 cu. ft.', bd: 'conjure_vol', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional cu. ft. of matter'}
				]),
			bd: 'conjure_object',
			q: 'Simple Object Creation'
		},
			{a8: _List_Nil, bd: 'conjure_creature', q: 'Creature Creation (with Life + Fortify)'}
		]),
	q: 'Conjure',
	ah: '0 ft.',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Conjuration (Creation)',
	aq: false,
	au: $elm$core$Maybe$Nothing,
	bw: _List_Nil
};
var $author$project$Types$Contact = 8;
var $author$project$Seeds$contact = {
	U: $elm$core$Maybe$Nothing,
	a0: 23,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed forges a telepathic bond with a particular creature with which the caster is familiar (or one that the caster can currently see directly or through magical means) and can converse back and forth. The subject recognizes the caster if it knows him or her. It can answer in like manner immediately, though it does not have to. The caster can forge a communal bond among more than two creatures. For each additional creature contacted, increase the Spellcraft DC by +1. The bond can be established only among willing subjects, which therefore receive no saving throw or Spell Resistance. For telepathic communication through the bond regardless of language, increase the Spellcraft DC by +4. No special influence is established as a result of the bond, only the power to communicate at a distance.\n\nAt the base Spellcraft DC of 20, a caster can also use the contact seed to imbue an object (or creature) with a message he or she prepares that appears as written text for the spell\'s duration or is spoken aloud in a language the caster knows. The spoken message can be of any length, but the length of written text is limited to what can be contained (as text of a readable size) on the surface of the target. The message is delivered when specific conditions are fulfilled according to the caster\'s desire when the spell is cast.',
	Z: _List_Nil,
	_: '200 minutes',
	S: $elm$core$Maybe$Nothing,
	bd: 8,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 1, aA: 'Bond only among willing subjects (no save or SR)', bd: 'contact_extra_creature', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional creature in bond'},
					{
					Y: 4,
					aA: '',
					bd: 'contact_language',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Telepathic communication regardless of language'
				}
				]),
			bd: 'contact_bond',
			q: 'Telepathic Bond'
		},
			{a8: _List_Nil, bd: 'contact_messenger', q: 'Messenger'}
		]),
	q: 'Contact',
	ah: 'See text',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Divination',
	aq: false,
	au: $elm$core$Maybe$Just('One creature'),
	bw: _List_Nil
};
var $author$project$Types$Delude = 9;
var $author$project$Seeds$delude = {
	U: $elm$core$Maybe$Nothing,
	a0: 14,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'A spell developed with the delude seed creates the visual illusion of an object, creature, or force, as visualized by the caster. The caster can move the image within the limits of the size of the effect by concentrating (the image is otherwise stationary). The image disappears when struck by an opponent unless the caster causes the illusion to react appropriately. For an illusion that includes audible, olfactory, tactile, taste, and thermal aspects, increase the Spellcraft DC by +2 per extra aspect. Even realistic tactile and thermal illusions can\'t deal damage, however. For each additional image to be created, increase the Spellcraft DC by +1. For an illusion that follows a script determined by the caster, increase the Spellcraft DC by +9. The figment follows the script without the caster having to concentrate on it. The illusion can include intelligible speech if desired. For an illusion that makes any area appear to be something other than it is, increase the Spellcraft DC by +4. Additional components, such as sounds, can be added as noted above. Concealing creatures requires additional spell development using this or other seeds.',
	Z: _List_Nil,
	_: 'Concentration + 20 hours',
	S: $elm$core$Maybe$Just('Visual figment up to twenty 30-ft. cubes (S)'),
	bd: 9,
	bj: _List_Nil,
	q: 'Delude',
	ah: '12,000 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 0}),
	ak: 'Illusion (Figment)',
	aq: false,
	au: $elm$core$Maybe$Nothing,
	bw: _List_fromArray(
		[
			{
			Y: 2,
			aA: 'Audible, olfactory, tactile, taste, or thermal (cannot deal damage)',
			bd: 'delude_sense',
			bh: 1,
			a: $elm$core$Maybe$Just(5),
			q: 'Each additional sensory aspect'
		},
			{Y: 1, aA: '', bd: 'delude_extra_image', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional image'},
			{
			Y: 9,
			aA: 'Can include intelligible speech',
			bd: 'delude_script',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Illusion follows a script (no concentration)'
		},
			{
			Y: 4,
			aA: '',
			bd: 'delude_area',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Make an area appear to be something other than it is'
		}
		])
};
var $author$project$Types$Destroy = 10;
var $author$project$Types$FortSave = 2;
var $author$project$Types$Half = 1;
var $author$project$Seeds$destroy = {
	U: $elm$core$Maybe$Nothing,
	a0: 29,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed deals 20d6 points of damage to the target. The damage is of no particular type or energy. For each additional 1d6 points of damage dealt, increase the Spellcraft DC by +2. If the target is reduced to -10 hit points or less (or a construct, object, or undead is reduced to 0 hit points), it is utterly destroyed as if disintegrated, leaving behind only a trace of fine dust. Up to a 10-foot cube of nonliving matter is affected, so a spell using the destroy seed destroys only part of any very large object or structure targeted. The destroy seed affects even magical matter, energy fields, and force effects that are normally only affected by the disintegrate spell. Such effects are automatically destroyed. Epic spells using the ward seed may also be destroyed, though the caster must succeed at an opposed caster level check against the other spellcaster to bring down a ward spell.',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 10,
	bj: _List_Nil,
	q: 'Destroy',
	ah: '12,000 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 1, bb: false, ai: 2}),
	ak: 'Transmutation',
	aq: true,
	au: $elm$core$Maybe$Just('One creature, or up to a 10-ft. cube of nonliving matter'),
	bw: _List_fromArray(
		[
			{Y: 2, aA: 'Above base 20d6', bd: 'destroy_damage', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1d6 damage'}
		])
};
var $author$project$Types$Dispel = 11;
var $author$project$Seeds$dispel = {
	U: $elm$core$Maybe$Nothing,
	a0: 19,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed can end ongoing spells that have been cast on a creature or object, temporarily suppress the magical abilities of a magic item, or end ongoing spells (or at least their effects) within an area. A dispelled spell ends as if its duration had expired. The dispel seed can defeat all spells, even those not normally subject to dispel magic. The dispel seed can dispel (but not counter) the ongoing effects of supernatural abilities as well as spells, and it affects spell-like effects just as it affects spells. One creature, object, or spell is the target of the dispel seed. The caster makes a dispel check against the spell or against each ongoing spell currently in effect on the object or creature. A dispel check is 1d20 + 10 against a DC of 11 + the target spell\'s caster level. For each additional +1 on the dispel check, increase the Spellcraft DC by +1. If targeting an object or creature that is the effect of an ongoing spell, make a dispel check to end the spell that affects the object or creature. If the object targeted is a magic item, make a dispel check against the item\'s caster level. If succeessful, all the item\'s magical properties are suppressed for 1d4 rounds, after which the item recovers on its own. A suppressed item becomes nonmagical for the duration of the effect. An interdimensional interface is temporarily closed. A magic item\'s physical properties are unchanged. Any creature, object, or spell is potentially subject to the dispel seed, even the spells of gods and the abilities of artifacts. A character automatically succeeds on the dispel check against any spell that he or she cast him or her self.',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 11,
	bj: _List_Nil,
	q: 'Dispel',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Abjuration',
	aq: false,
	au: $elm$core$Maybe$Just('One creature, object, or spell'),
	bw: _List_fromArray(
		[
			{Y: 1, aA: 'Above base +10', bd: 'dispel_bonus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 to dispel check'}
		])
};
var $author$project$Types$Energy = 12;
var $author$project$Types$ReflexSave = 1;
var $author$project$Seeds$energy = {
	U: $elm$core$Maybe$Just('20-ft.-radius hemisphere burst'),
	a0: 19,
	V: '1 minute',
	ay: _List_fromArray(
		[
			{
			a4: 'fire',
			bd: 'energyType',
			L: 'Energy Type',
			af: _List_fromArray(
				['acid', 'cold', 'electricity', 'fire', 'sonic'])
		}
		]),
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed uses whichever one of five energy types the caster chooses: acid, cold, electricity, fire, or sonic. The caster can cast the energy forth as a bolt, imbue an object with the energy, or create a freestanding manifestation of the energy. If the spell developed using the energy seed releases a bolt, that bolt instantaneously deals 10d6 points of damage of the appropriate energy type, and all in the bolt\'s area must make a Reflex save for half damage. For each additional 1d6 points of damage dealt, increase the Spellcraft DC by +2. The bolt begins at the caster’s fingertips. To imbue another creature with the ability to use an energy bolt as a spell-like ability at its option or when a particular condition is met, increase the Spellcraft DC by +25. The caster can also cause a creature or object to emanate the specific energy type out to a radius of 10 feet for 20 hours. The emanated energy deals 2d6 points of energy damage per round against unprotected creatures (the target creature is susceptible if not separately warded or otherwise resistant to the energy). For each additional 1d6 points of damage emanated, increase the Spellcraft DC by +2. The caster may also create a wall, half-circle, circle, dome, or sphere of the desired energy that emanates the energy for up to 20 hours. One side of the wall, selected by the caster, sends forth waves of energy, dealing 2d4 points of energy damage to creatures within 10 feet and 1d4 points of energy damage to those past 10 feet but within 20 feet. The wall deals this damage when it appears and in each round that a creature enters or remains in the area. In addition, the wall deals 2d6+20 points of energy damage to any creature passing through it. The wall deals double damage to undead creatures. For each additional 1d4 points of damage, increase the Spellcraft DC by +2.\n\nThe caster can also use the energy seed to create a spell that carefully releases and balances the emanation of cold, electricity, and fire, creating specific weather effects for a period of 20 hours. Using the energy seed this way has a base Spellcraft DC of 25. The area extends to a two-mile-radius centered on the caster. Once the spell is cast, the weather takes 10 minutes to manifest. Ordinarily, a caster can\'t directly target a creature or object, though indirect effects are possible. This seed can create cold snaps, heat waves, thunderstorms, fogs, blizzards—even a tornado that moves randomly in the affected area. Creating targeted damaging effects requires an additional use of the energy seed.',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 12,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Above base 10d6', bd: 'energy_bolt_damage', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1d6 damage'},
					{
					Y: 25,
					aA: 'As a spell-like ability, at its option or on trigger',
					bd: 'energy_bolt_imbue',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Imbue another creature with bolt ability'
				}
				]),
			bd: 'energy_bolt',
			q: 'Bolt'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Above base 2d6/round', bd: 'energy_em_damage', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1d6 damage per round'}
				]),
			bd: 'energy_emanation',
			q: 'Emanation'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: 'Above base 2d4 near / 1d4 far; passage damage scales with proximity damage', bd: 'energy_wall_damage', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1d4 damage (wall proximity)'}
				]),
			bd: 'energy_wall',
			q: 'Wall / Dome / Sphere'
		},
			{a8: _List_Nil, bd: 'energy_weather', q: 'Weather Effects'}
		]),
	q: 'Energy',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 1, bb: false, ai: 1}),
	ak: 'Evocation',
	aq: true,
	au: $elm$core$Maybe$Nothing,
	bw: _List_Nil
};
var $author$project$Seeds$foresee = {
	U: $elm$core$Maybe$Nothing,
	a0: 17,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'The caster can foretell the immediate future, or gain information about specific questions. He or she is 90% likely to receive a meaningful reading of the future of the next 30 minutes. If successful, the caster knows if a particular action will bring good results, bad results, or no result. For each additional 30 minutes into the future, multiply the Spellcraft DC by x2. For better results, the caster can pose up to ten specific questions (one per round while he or she concentrates) to unknown powers of other planes, but the base Spellcraft DC for such an attempt is 23. The answers return in a language the caster understands, but use only one-word replies: “yes,” “no,” “maybe,” “never,” “irrelevant,” or some other one-word answer. Unlike 0- to 9th-level spells of similar type, all questions answered are 90% likely to be answered truthfully. However, a specific spell using the foresee seed can only be cast once every five weeks. The foresee seed is also useful for epic spells requiring specific information before functioning, such as spells using the reveal and transport seeds. The foresee seed can also be used to gain one basic piece of information about a living target: level, class, alignment, or some special ability (or one of an object\'s magical abilities, if any). For each additional piece of information revealed, increase the Spellcraft DC by +2.',
	Z: _List_Nil,
	_: 'Instantaneous or concentration',
	S: $elm$core$Maybe$Nothing,
	bd: 13,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 0, aA: 'Multiplies this seed\'s DC by ×2 per interval (special: not additive)', bd: 'foresee_interval', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 30-min interval'}
				]),
			bd: 'foresee_predict',
			q: 'Predict the Future (30 min)'
		},
			{a8: _List_Nil, bd: 'foresee_questions', q: 'Ask Questions (10 questions)'},
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Level, class, alignment, special ability, or magic item ability', bd: 'foresee_extra_info', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional piece of info about target'}
				]),
			bd: 'foresee_info',
			q: 'Targeted Info'
		}
		]),
	q: 'Foresee',
	ah: 'Personal',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Divination',
	aq: false,
	au: $elm$core$Maybe$Just('You'),
	bw: _List_Nil
};
var $author$project$Types$Fortify = 14;
var $author$project$Seeds$fortify = {
	U: $elm$core$Maybe$Nothing,
	a0: 17,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'Spells using the fortify seed grant a +1 enhancement bonus to whichever one of the following the caster chooses:\n\nAny one ability score.\nAny one kind of saving throw.\nSpell resistance.\nNatural armor.\nThe fortify seed can also grant energy resistance 1 for one energy type or 1 temporary hit point. For each additional +1 bonus, point of energy resistance, or hit point, increase the Spellcraft DC by +2.\n\nThe fortify seed has a base Spellcraft DC of 23 if it grants a +1 bonus of a type other than enhancement. For each additional +1 bonus of a type other than enhancement, increase the Spellcraft DC by +6. If the caster applies a factor to make the duration permanent, the bonus must be an inherent bonus, and the maximum inherent bonus allowed is +5.\n\nThe fortify seed has a base Spellcraft DC of 27 if it grants a creature a +1 bonus to an ability score or other statistic it does not possess. For each additional +1 bonus, increase the Spellcraft DC by +4. If a spell with the fortify seed grants an inanimate object an ability score it would not normally possess (such as Intelligence), the spell must also incorporate the life seed.\n\nGranting Spell Resistance to a creature that doesn\'t already have it is a special case; the base Spellcraft DC of 27 grants Spell Resistance 25, and each additional point of Spell Resistance increases the Spellcraft DC by +4 (each -1 to Spell Resistance reduces the Spellcraft DC by -2).\n\nThe fortify seed can also grant damage reduction 1/magic. For each additional point of damage reduction, increase the Spellcraft DC by +2. To increase the damage reduction value to epic, increase the Spellcraft DC by +15.\n\nA special use of the fortify seed grants the target a permanent +1 year to its current age category. For each additional +1 year added to the creature\'s current age category, increase the Spellcraft DC by +2. Incremental adjustments to a creature\'s maximum age do not stack; they overlap. When a spell increases a creature\'s current age category, all higher age categories are also adjusted accordingly.',
	Z: _List_Nil,
	_: '20 hours',
	S: $elm$core$Maybe$Nothing,
	bd: 14,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Above base +1', bd: 'fortify_enhance_plus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional +1 (or 1 energy resist / 1 temp hp)'}
				]),
			bd: 'fortify_enhance',
			q: 'Enhancement Bonus'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 6, aA: '', bd: 'fortify_other_plus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional +1 non-enhancement bonus'}
				]),
			bd: 'fortify_nonenhance',
			q: 'Non-Enhancement Bonus'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: '', bd: 'fortify_new_plus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional +1'}
				]),
			bd: 'fortify_new',
			q: 'Bonus to New Statistic (target doesn\'t have it)'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: '', bd: 'fortify_sr_plus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 SR above 25'},
					{Y: -2, aA: '', bd: 'fortify_sr_minus', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each –1 SR below 25'},
					{
					Y: 15,
					aA: '+15 DC surcharge to make DR bypass epic',
					bd: 'fortify_dr_epic',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Damage Reduction vs. epic'
				}
				]),
			bd: 'fortify_sr',
			q: 'Grant Spell Resistance 25'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: 'Increments do not stack; they overlap', bd: 'fortify_age_year', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 year to current age category'}
				]),
			bd: 'fortify_age',
			q: 'Expand Age Category'
		}
		]),
	q: 'Fortify',
	ah: 'Touch',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: true, ai: 0}),
	ak: 'Transmutation',
	aq: true,
	au: $elm$core$Maybe$Just('Creature touched'),
	bw: _List_fromArray(
		[
			{Y: 2, aA: 'Any mode: adds DR/magic', bd: 'fortify_dr', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 damage reduction'}
		])
};
var $author$project$Types$DF = 3;
var $author$project$Types$Heal = 15;
var $author$project$Seeds$heal = {
	U: $elm$core$Maybe$Nothing,
	a0: 25,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1, 3]),
	aA: 'Spells developed with the heal seed channel positive energy into a creature to wipe away disease and injury. Such a spell completely cures all diseases, blindness, deafness, hit point damage, and temporary ability damage. To restore permanently drained ability score points, increase the Spellcraft DC by +6. The heal seed neutralizes poisons in the subject\'s system so that no additional damage or effects are suffered. It offsets feeblemindedness and cures mental disorders caused by spells or injury to the brain. It dispels all magical effects penalizing the character\'s abilities, including effects caused by spells, even epic spells developed with the afflict seed. Only a single application of the spell is needed to simultaneously achieve all these effects. This seed does not restore levels or Constitution points lost due to death.\n\nTo dispel all negative levels afflicting the target, increase the Spellcraft DC by +2. This reverses level drains by a force or creature. The drained levels are restored only if the creature lost the levels within the last 20 weeks. For each additional week since the levels were drained, increase the Spellcraft DC by +2.\n\nAgainst undead, the influx of positive energy causes the loss of all but 1d4 hit points if the undead fails a Fortitude saving throw.\n\nAn epic caster with 24 ranks in Knowledge (arcana), Knowledge (nature), or Knowledge (religion) can cast a spell developed with a special version of the heal seed that flushes negative energy into the subject, healing undead completely but causing the loss of all but 1d4 hit points in living creatures if they fail a Fortitude saving throw. Alternatively, a living target that fails its Fortitude saving throw could gain four negative levels for the next 8 hours. For each additional negative level bestowed, increase the Spellcraft DC by +4, and for each extra hour the negative levels persist, increase the Spellcraft DC by +2. If the subject has at least as many negative levels as Hit Dice, it dies. If the subject survives and the negative levels persist for 24 hours or longer, the subject must make another Fortitude saving throw, or the negative levels are converted to actual level loss.\n\n',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 15,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 6,
					aA: '',
					bd: 'heal_drain',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Restore drained ability scores'
				},
					{
					Y: 2,
					aA: '',
					bd: 'heal_neg_levels',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Dispel all negative levels'
				},
					{Y: 2, aA: 'Above free 20-week window', bd: 'heal_extra_week', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional week to restore negative levels'}
				]),
			bd: 'heal_heal',
			q: 'Heal'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: '', bd: 'heal_neg_level_extra', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional negative level bestowed'},
					{Y: 2, aA: '', bd: 'heal_neg_level_hour', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each extra hour negative levels persist'}
				]),
			bd: 'heal_harm',
			q: 'Harm (requires 24 ranks Knowledge)'
		}
		]),
	q: 'Heal',
	ah: 'Touch',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: true, ai: 0}),
	ak: 'Conjuration (Healing)',
	aq: true,
	au: $elm$core$Maybe$Just('Creature touched'),
	bw: _List_Nil
};
var $author$project$Types$Life = 16;
var $author$project$Seeds$life = {
	U: $elm$core$Maybe$Nothing,
	a0: 27,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1, 3]),
	aA: 'A spell developed with the life seed will restore life and complete vigor to any deceased creature. The condition of the remains is not a factor. So long as some small portion of the creature\'s body still exists, it can be returned to life, but the portion receiving the spell must have been part of the creature\'s body at the time of death. (The remains of a creature hit by a disintegrate spell count as a small portion of its body.) The creature can have been dead for no longer than two hundred years. For each additional ten years, increase the Spellcraft DC by +1.\n\nThe creature is immediately restored to full hit points, vigor, and health, with no loss of prepared spells. However, the subject loses one level (or 1 point of Constitution if the subject was 1st level). The life seed cannot revive someone who has died of old age.\n\nAn epic caster with 24 ranks in Knowledge (arcana), Knowledge (nature), or Knowledge (religion) can cast a spell developed with a special version of the life seed that gives actual life to normally inanimate objects. The caster can give inanimate plants and animals a soul, personality, and humanlike sentience. To succeed, the caster must make a Will save (DC 10 + the target\'s Hit Dice, or the Hit Dice a plant will have once it comes to life).\n\nThe newly living object, intelligent animal, or sentient plant is friendly toward the caster. An object or plant has characteristics as if it were an animated object, except that its Intelligence, Wisdom, and Charisma scores are all 3d6. Animated objects and plants gain the ability to move their limbs, projections, roots, carved legs and arms, or other appendages, and have senses similar to a human\'s. A newly intelligent animal gets 3d6 Intelligence, +1d3 Charisma, and +2 HD. Objects, animals, and plants speak one language that the caster knows, plus one additional language that he or she knows per point of Intelligence bonus (if any).\n\n',
	Z: _List_Nil,
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 16,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 1, aA: 'Target can have been dead longer', bd: 'life_extra_decade', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 10 years beyond 200'}
				]),
			bd: 'life_resurrect',
			q: 'Resurrection'
		},
			{a8: _List_Nil, bd: 'life_give', q: 'Give Life (to object/plant/animal)'}
		]),
	q: 'Life',
	ah: 'Touch',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Conjuration (Healing)',
	aq: true,
	au: $elm$core$Maybe$Just('Dead creature touched'),
	bw: _List_Nil
};
var $author$project$Types$Reflect = 17;
var $author$project$Seeds$reflect = {
	U: $elm$core$Maybe$Nothing,
	a0: 27,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'Attacks targeted against the caster rebound on the original attacker. Each use of the reflect seed in an epic spell is effective against one type of attack only: spells (and spell-like effects), ranged attacks, or melee attacks. To reflect an area spell, where the caster is not the target but are caught in the vicinity, increase the Spellcraft DC by +20. A single successful use of reflect expends its protection. Spells developed with the reflect seed against spells and spell-like effects return all spell effects of up to 1st level. For each additional level of spells to be reflected, increase the Spellcraft DC by +20. Epic spells are treated as 10th-level spells for this purpose.\n\nThe desired effect is automatically reflected if the spell in question is 9th level or lower. An opposed caster level check is required when the reflect seed is used against another epic spell. If the enemy spellcaster gets his spell through by winning the caster level check, the epic spell using the reflect seed is not expended, just momentarily suppressed.\n\nIf the reflect seed is used against a melee attack or ranged attack, five such attacks are automatically reflected back on the original attacker. For each additional attack reflected, increase the Spellcraft DC by +4. The reflected attack rebounds on the attacker using the same attack roll. Once the allotted attacks are reflected, the spell using the reflect seed is expended.\n\n',
	Z: _List_Nil,
	_: 'Until expended (up to 12 hours)',
	S: $elm$core$Maybe$Nothing,
	bd: 17,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 20,
					aA: '',
					bd: 'reflect_aoe',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Reflect AoE spell (not directly targeted)'
				},
					{Y: 20, aA: 'Base reflects up to 1st level; each +1 level costs +20 DC; epic spells count as 10th level', bd: 'reflect_spell_level', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional spell level reflected'}
				]),
			bd: 'reflect_spell',
			q: 'Spell Reflection'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: 'Base: 5 attacks', bd: 'reflect_ranged_extra', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional ranged attack reflected'}
				]),
			bd: 'reflect_ranged',
			q: 'Ranged Attack Reflection'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: 'Base: 5 attacks', bd: 'reflect_melee_extra', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional melee attack reflected'}
				]),
			bd: 'reflect_melee',
			q: 'Melee Attack Reflection'
		}
		]),
	q: 'Reflect',
	ah: 'Personal',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Abjuration',
	aq: false,
	au: $elm$core$Maybe$Just('You'),
	bw: _List_Nil
};
var $author$project$Seeds$reveal = {
	U: $elm$core$Maybe$Nothing,
	a0: 19,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'The caster of this seed can see some distant location or hear the sounds at some distant location almost as if he or she was there. To both hear and see, increase the Spellcraft DC by +2. Distance is not a factor, but the locale must be known—a place familiar to the caster or an obvious one. The spell creates an invisible sensor that can be dispelled. Lead sheeting or magical protection blocks the spell, and the caster senses that the spell is so blocked. If the caster prefers to create a mobile sensor (speed 30 feet) that he or she controls, increase the Spellcraft DC by +2. To use the reveal seed to reach one specific different plane of existence, increase the Spellcraft DC by +8. To allow magically enhanced senses to work through a spell built with the reveal seed, increase the Spellcraft DC by +4. To cast any spell from the sensor whose range is touch or greater, increase the Spellcraft DC by +6; however, the caster must maintain line of effect to the sensor at all times. If the line of effect is obstructed, the spell ends. To free the caster of the line of effect restriction for casting spells through the sensor, multiply the Spellcraft DC by ×10.\n\nThe reveal seed has a base Spellcraft DC of 25 if used to pierce illusions and see things as they really are. The caster can see through normal and magical darkness, notice secret doors hidden by magic, see the exact locations of creatures or objects under blur or displacement effects, see invisible creatures or objects normally, see through illusions, see onto the Ethereal Plane (but not into extradimensional spaces), and see the true form of polymorphed, changed, or transmuted things. The range of such sight is 120 feet.\n\nThe reveal seed can also be used to develop spells that will do any one of the following: duplicate the read magic spell, comprehend the written and verbal language of another, or speak in the written or verbal language of another. To both comprehend and speak a language, increase the Spellcraft DC by +4.\n\n',
	Z: _List_Nil,
	_: 'Concentration + 20 minutes',
	S: $elm$core$Maybe$Just('See text'),
	bd: 18,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 2,
					aA: '',
					bd: 'reveal_hear',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Both see and hear through sensor'
				},
					{
					Y: 2,
					aA: '',
					bd: 'reveal_mobile',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Mobile sensor (speed 30 ft.)'
				},
					{
					Y: 8,
					aA: '',
					bd: 'reveal_plane',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Sensor on a different plane'
				},
					{
					Y: 4,
					aA: '',
					bd: 'reveal_magic_senses',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Magically enhanced senses through sensor'
				},
					{
					Y: 6,
					aA: 'Must maintain line of effect to sensor',
					bd: 'reveal_cast_through',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Cast touch-or-greater spells through sensor'
				},
					{
					Y: 0,
					aA: 'Multiplies DC by ×10',
					bd: 'reveal_no_loe',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'No line of effect required for spells through sensor'
				}
				]),
			bd: 'reveal_sensor',
			q: 'Sensor'
		},
			{a8: _List_Nil, bd: 'reveal_truesight', q: 'Pierce Illusions (True Sight, 120 ft.)'},
			{
			a8: _List_fromArray(
				[
					{
					Y: 4,
					aA: '',
					bd: 'reveal_both_lang',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Both comprehend and speak a language'
				}
				]),
			bd: 'reveal_language',
			q: 'Languages'
		}
		]),
	q: 'Reveal',
	ah: 'See text',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Divination',
	aq: false,
	au: $elm$core$Maybe$Nothing,
	bw: _List_Nil
};
var $author$project$Types$Partial = 2;
var $author$project$Types$Slay = 19;
var $author$project$Seeds$slay = {
	U: $elm$core$Maybe$Nothing,
	a0: 25,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'A spell developed using the slay seed snuffs out the life force of a living creature, killing it instantly. The slay seed kills a creature of up to 80 HD. The subject is entitled to a Fortitude saving throw to survive the attack. If the save is successful, it instead takes 3d6+20 points of damage. For each additional 80 HD affected (or each additional creature affected), increase the Spellcraft DC by +8. Alternatively, a caster can use the slay seed in an epic spell to suppress the life force of the target by bestowing 2d4 negative levels on the target (or half as many negative levels on a successful Fortitude save). For each additional 1d4 negative levels bestowed, increase the Spellcraft DC by +4. If the subject has at least as many negative levels as Hit Dice, it dies. If the subject survives and the negative levels persist for 24 hours or longer, the subject must make another Fortitude saving throw, or the negative levels are converted to actual level loss.',
	Z: _List_fromArray(
		['Death']),
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 19,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 8, aA: 'Or each additional creature affected', bd: 'slay_hd', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 80 HD affected'}
				]),
			bd: 'slay_kill',
			q: 'Kill'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 4, aA: 'Base: 2d4 negative levels', bd: 'slay_neg_level', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 1d4 negative levels'}
				]),
			bd: 'slay_enervate',
			q: 'Enervate (negative levels)'
		}
		]),
	q: 'Slay',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 2, bb: false, ai: 2}),
	ak: 'Necromancy',
	aq: true,
	au: $elm$core$Maybe$Just('One living creature of up to 80 HD'),
	bw: _List_Nil
};
var $author$project$Types$Summon = 20;
var $author$project$Seeds$summon = {
	U: $elm$core$Maybe$Nothing,
	a0: 14,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed can summon an outsider. It appears where the caster designates and acts immediately, on his or her turn, if its spell resistance is overcome and it fails a Will saving throw. It attacks the caster\'s opponents to the best of its ability. If the caster can communicate with the outsider, he or she can direct it not to attack, to attack particular enemies, or to perform other actions. The spell conjures an outsider the caster selects of CR 2 or less. For each +1 CR of the summoned outsider, increase the Spellcraft DC by +2. For each additional outsider of the same Challenge Rating summoned, multiply the Spellcraft DC by x2. When a caster develops a spell with the summon seed that summons an air, chaotic, earth, evil, fire, good, lawful, or water creature, the completed spell is also of that type.\n\nIf the caster increases the Spellcraft DC by +10, he or she can summon a creature of CR 2 or less from another monster type or subtype. The summoned creature is assumed to have been plucked from some other plane (or somewhere on the same plane). The summoned creature attacks the caster\'s opponents to the best of its ability; or, if the caster can communicate with it, it will perform other actions. However, the summoning ends if the creature is asked to perform a task inimical to its nature. For each +1 CR of the summoned creature, increase the Spellcraft DC by +2.\n\nFinally, by increasing the Spellcraft DC by +60, the caster can summon a unique individual he or she specifies from anywhere in the multiverse. The caster must know the target\'s name and some facts about its life, defeat any magical protection against discovery or other protection possessed by the target, and overcome the target\'s spell resistance, and it must fail a Will saving throw. The target is under no special compulsion to serve the caster.',
	Z: _List_Nil,
	_: '20 rounds (D)',
	S: $elm$core$Maybe$Just('One summoned creature'),
	bd: 20,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{Y: 2, aA: '', bd: 'summon_cr', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each +1 CR above CR 1'},
					{
					Y: 10,
					aA: '+10 DC flat surcharge',
					bd: 'summon_nonoutsider',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Summon a non-outsider creature type'
				}
				]),
			bd: 'summon_generic',
			q: 'Summon Generic Creature'
		},
			{
			a8: _List_fromArray(
				[
					{
					Y: 60,
					aA: '+60 DC flat surcharge',
					bd: 'summon_unique_dc',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Summon specific named individual'
				}
				]),
			bd: 'summon_unique',
			q: 'Summon Unique Individual'
		}
		]),
	q: 'Summon',
	ah: '75 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 0}),
	ak: 'Conjuration (Summoning)',
	aq: true,
	au: $elm$core$Maybe$Nothing,
	bw: _List_Nil
};
var $author$project$Types$Transform = 21;
var $author$project$Seeds$transform = {
	U: $elm$core$Maybe$Nothing,
	a0: 21,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'Spells using the transform seed change the subject into another form of creature or object. The new form can range in size from Diminutive to one size larger than the subject\'s normal form. For each additional increment of size change, increase the Spellcraft DC by +6. If the caster wants to transform a nonmagical, inanimate object into a creature of his or her type or transform a creature into a nonmagical, inanimate object, increase the Spellcraft DC by +10. To change a creature of one type into another type increase the Spellcraft DC by +5.\n\nTransformations involving nonmagical, inanimate substances with hardness are more difficult; for each 2 points of hardness, increase the Spellcraft DC by +1.\n\nTo transform a creature into an incorporeal or gaseous form, increase the Spellcraft DC by +10. Conversely, to overcome the natural immunity of a gaseous or incorporeal creature to transformation, increase the Spellcraft DC by +10.\n\nThe transform seed can also change its target into someone specific. To transform an object or creature into the specific likeness of another individual (including memories and mental abilities), increase the Spellcraft DC by +25. If the transformed creature doesn\'t have the level or Hit Dice of its new likeness, it can only use the abilities of the creature at its own level or Hit Dice. If slain or destroyed, the transformed creature or object reverts to its original form. The subject\'s equipment, if any, remains untransformed or melds into the new form\'s body, at the caster\'s option. The transformed creature or object acquires the physical and natural abilities of the creature or object it has been changed into while retaining its own memories and mental ability scores. Mental abilities include personality, Intelligence, Wisdom, and Charisma scores, level and class, hit points (despite any change in its Constitution score), alignment, base attack bonus, base saves, extraordinary abilities, spells, and spell-like abilities, but not its supernatural abilities. Physical abilities include natural size and Strength, Dexterity, and Constitution scores. Natural abilities include armor, natural weapons, and similar gross physical qualities (presence or absence of wings, number of extremities, and so forth), and possibly hardness. Creatures transformed into inanimate objects do not gain the benefit of their untransformed physical abilities, and may well be blind, deaf, dumb, and unfeeling. Objects transformed into creatures gain that creature\'s average physical ability scores, but are considered to have mental ability scores of 0 (the fortify seed can add points to each mental ability, if desired). For each normal extraordinary ability or supernatural ability granted to the transformed creature, increase the Spellcraft DC by +10. The transformed subject can have no more Hit Dice than the caster has or than the subject has (whichever is greater). In any case, for each Hit Die the assumed form has above 15, increase the Spellcraft DC by +2.',
	Z: _List_Nil,
	_: '20 hours',
	S: $elm$core$Maybe$Nothing,
	bd: 21,
	bj: _List_Nil,
	q: 'Transform',
	ah: '300 ft.',
	aj: $elm$core$Maybe$Just(
		{S: 0, bb: false, ai: 2}),
	ak: 'Transmutation',
	aq: true,
	au: $elm$core$Maybe$Just('One creature'),
	bw: _List_fromArray(
		[
			{
			Y: 5,
			aA: '',
			bd: 'transform_type',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Change creature type'
		},
			{Y: 6, aA: 'Beyond one size larger than normal', bd: 'transform_size', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional size increment change'},
			{
			Y: 10,
			aA: '',
			bd: 'transform_inanimate',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Nonmagical inanimate ↔ creature'
		},
			{Y: 1, aA: '', bd: 'transform_hardness', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each 2 points of hardness of target object'},
			{
			Y: 10,
			aA: '+10 each direction',
			bd: 'transform_incorporeal',
			bh: 1,
			a: $elm$core$Maybe$Just(2),
			q: 'Transform to/from incorporeal or gaseous form'
		},
			{
			Y: 25,
			aA: '',
			bd: 'transform_specific',
			bh: 0,
			a: $elm$core$Maybe$Just(1),
			q: 'Transform into specific individual (with memories)'
		},
			{Y: 10, aA: '', bd: 'transform_ability', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each extraordinary or supernatural ability granted'},
			{Y: 2, aA: '', bd: 'transform_hd', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each HD of assumed form above 15'}
		])
};
var $author$project$Types$Transport = 22;
var $author$project$Seeds$transport = {
	U: $elm$core$Maybe$Nothing,
	a0: 27,
	V: '1 minute',
	ay: _List_Nil,
	W: _List_fromArray(
		[0, 1]),
	aA: 'Spells using the transport seed instantly take the caster to a designated destination, regardless of distance. For interplanar travel, increase the Spellcraft DC by +4. For each additional 50 pounds in objects and willing creatures beyond the base 1,000 pounds, increase the Spellcraft DC by +2. The base use of the transport seed provides instantaneous travel through the Astral Plane. To shift the transportation medium to another medium increase the Spellcraft DC by +2. The caster does not need to make a saving throw, nor is spell resistance applicable to him or her. Only objects worn or carried (attended) by another person receive saving throws and spell resistance. For a spell intended to transport unwilling creatures, increase the Spellcraft DC by +4. The caster must have at least a reliable description of the place to which he or she is transporting. If the caster attempts to use the transport seed with insufficient or misleading information, the character disappears and simply reappear in his or her original location.\n\nAs a special use of the transport seed, a caster can develop a spell that temporarily transports him or her into a different time stream (leaving the caster in the same physical location); this increases the Spellcraft DC by +8. If the caster moves him or herself, or the subject, into a slower time stream for 5 rounds, time ceases to flow for the subject, and its condition becomes fixed—no force or effect can harm it until the duration expires. If the caster moves him or her self into a faster time stream, the caster speeds up so greatly that all other creatures seem frozen, though they are actually still moving at their normal speeds. The caster is free to act for 5 rounds of apparent time. Fire, cold, poison gas, and similar effects can still harm the caster. While the caster is in the fast time stream, other creatures are invulnerable to his or her attacks and spells; however, the caster can create spell effects and leave them to take effect when he or she reenters normal time. Because of the branching nature of time, epic spells used to transport a subject into a faster time stream cannot be made permanent, nor can the duration of 5 rounds be extended. More simply, the seed can haste or slow a subject for 20 rounds by transporting it to the appropriate time stream. This decreases the Spellcraft DC by -4.',
	Z: _List_fromArray(
		['Teleportation']),
	_: 'Instantaneous',
	S: $elm$core$Maybe$Nothing,
	bd: 22,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 4,
					aA: '',
					bd: 'transport_interplanar',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Interplanar travel'
				},
					{Y: 2, aA: '', bd: 'transport_weight', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional 50 lbs. beyond 1,000'},
					{
					Y: 2,
					aA: '',
					bd: 'transport_medium',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Use transport medium other than Astral Plane'
				},
					{
					Y: 4,
					aA: '',
					bd: 'transport_unwilling',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Transport unwilling creatures'
				}
				]),
			bd: 'transport_spatial',
			q: 'Spatial (Teleport)'
		},
			{
			a8: _List_fromArray(
				[
					{
					Y: 8,
					aA: '+8 DC to enter a different time stream (freeze or accelerate)',
					bd: 'transport_temporal_dc',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Temporal transport surcharge'
				}
				]),
			bd: 'transport_temporal',
			q: 'Temporal (time stream)'
		},
			{
			a8: _List_fromArray(
				[
					{
					Y: -4,
					aA: '–4 DC for haste/slow effect only',
					bd: 'transport_lite_dc',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Temporal lite discount'
				}
				]),
			bd: 'transport_temporal_lite',
			q: 'Temporal Lite (haste/slow 20 rounds)'
		}
		]),
	q: 'Transport',
	ah: 'Touch',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Conjuration',
	aq: false,
	au: $elm$core$Maybe$Just('You and touched willing creatures up to 1,000 lb.'),
	bw: _List_Nil
};
var $author$project$Types$Ward = 23;
var $author$project$Seeds$ward = {
	U: $elm$core$Maybe$Just('10-ft.-radius emanation'),
	a0: 14,
	V: '1 minute',
	ay: _List_fromArray(
		[
			{
			a4: 'fire',
			bd: 'wardEnergyType',
			L: 'Energy Type (Energy Ward)',
			af: _List_fromArray(
				['acid', 'cold', 'electricity', 'fire', 'sonic'])
		},
			{
			a4: 'undead',
			bd: 'wardCreatureType',
			L: 'Creature Type (Creature Ward)',
			af: _List_fromArray(
				['aberrations', 'animals', 'constructs', 'dragons', 'elementals', 'fey', 'giants', 'humanoids', 'magical beasts', 'monstrous humanoids', 'oozes', 'outsiders', 'plants', 'undead', 'vermin'])
		}
		]),
	W: _List_fromArray(
		[0, 1]),
	aA: 'This seed can grant a creature protection from damage of a specified type. The caster can protect a creature from standard damage or from energy damage. The caster can protect a creature or area from magic. Alternatively, he or she can hedge out a type of creature from a specified area. A ward against standard damage protects a creature from whichever two the caster selects of the three damage types: bludgeoning, piercing, and slashing. For a ward against all three types, increase the Spellcraft DC by +4. Each round, the spell created with the ward seed absorbs the first 5 points of damage the creature would otherwise take, regardless of whether the source of the damage is natural or magical. For each additional point of protection, increase the Spellcraft DC by +2.\n\nA ward against energy grants a creature protection from whichever one the caster selects of the five energy types: acid, cold, electricity, fire, or sonic. Each round, the spell absorbs the first 5 points of damage the creature would otherwise take from the specified energy type, regardless of whether the source of damage is natural or magical. The spell protects the recipient\'s equipment as well. For each additional point of protection, increase the Spellcraft DC by +1.\n\nA ward against a specific type of creature prevents bodily contact from whichever one of several monster types the caster selects. This causes the natural weapon attacks of such creatures to fail and the creatures to recoil if such attacks require touching the warded creature. The protection ends if the warded creature makes an attack against or intentionally moves within 5 feet of the blocked creature. Spell resistance can allow a creature to overcome this protection and touch the warded creature.\n\nA ward against magic creates an immobile, faintly shimmering magical sphere (with radius 10 feet) that surrounds the caster and excludes all spell effects of up to 1st level. Alternatively, the caster can ward just the target and not create the radius effect. For each additional level of spells to be excluded, increase the Spellcraft DC by +20 (but see below). The area or effect of any such spells does not include the area of the ward, and such spells fail to affect any target within the ward. This includes spell-like abilities and spells or spell-like effects from magic items. However, any type of spell can be cast through or out of the ward. The caster can leave and return to the protected area without penalty (unless the spell specifically targets a creature and does not provide a radius effect). The ward could be brought down by a targeted dispel magic spell. Epic spells using the dispel seed may bring down a ward if the enemy spellcaster succeeds at a caster level check. The ward may also be brought down with a targeted epic spell using the destroy seed if the enemy spellcaster succeeds at a caster level check.\n\nInstead of creating an epic spell that uses the ward seed to nullify all spells of a given level and lower, the caster can create a ward that nullifies a specific spell (or specific set of spells). For each specific spell so nullified, increase the Spellcraft DC by +2 per spell level above 1st.',
	Z: _List_Nil,
	_: '200 minutes (D)',
	S: $elm$core$Maybe$Nothing,
	bd: 23,
	bj: _List_fromArray(
		[
			{
			a8: _List_fromArray(
				[
					{
					Y: 4,
					aA: 'Base covers two; +4 DC for all three',
					bd: 'ward_all_three',
					bh: 0,
					a: $elm$core$Maybe$Just(1),
					q: 'Ward all three damage types (B, P, and S)'
				},
					{Y: 2, aA: 'Above base 5', bd: 'ward_dmg_pts', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional point of damage absorbed per round'}
				]),
			bd: 'ward_damage',
			q: 'Damage Ward (B/P/S)'
		},
			{
			a8: _List_fromArray(
				[
					{Y: 1, aA: 'Above base 5', bd: 'ward_energy_pts', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional point of energy absorbed per round'}
				]),
			bd: 'ward_energy',
			q: 'Energy Ward'
		},
			{a8: _List_Nil, bd: 'ward_creature', q: 'Creature Ward'},
			{
			a8: _List_fromArray(
				[
					{Y: 20, aA: 'Above 1st level; +20 DC per level', bd: 'ward_magic_level', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each additional spell level excluded'},
					{Y: 2, aA: '+2 DC per spell level above 1st', bd: 'ward_specific_spell', bh: 1, a: $elm$core$Maybe$Nothing, q: 'Each specific spell nullified (per spell level above 1st)'}
				]),
			bd: 'ward_magic',
			q: 'Magic Ward (spell level exclusion)'
		}
		]),
	q: 'Ward',
	ah: 'Touch',
	aj: $elm$core$Maybe$Nothing,
	ak: 'Abjuration',
	aq: true,
	au: $elm$core$Maybe$Just('Touched creature or object up to 2,000 lb.'),
	bw: _List_Nil
};
var $author$project$Seeds$allSeeds = _List_fromArray(
	[$author$project$Seeds$afflict, $author$project$Seeds$animate, $author$project$Seeds$animateDead, $author$project$Seeds$armor, $author$project$Seeds$banish, $author$project$Seeds$compel, $author$project$Seeds$conceal, $author$project$Seeds$conjure, $author$project$Seeds$contact, $author$project$Seeds$delude, $author$project$Seeds$destroy, $author$project$Seeds$dispel, $author$project$Seeds$energy, $author$project$Seeds$foresee, $author$project$Seeds$fortify, $author$project$Seeds$heal, $author$project$Seeds$life, $author$project$Seeds$reflect, $author$project$Seeds$reveal, $author$project$Seeds$slay, $author$project$Seeds$summon, $author$project$Seeds$transform, $author$project$Seeds$transport, $author$project$Seeds$ward]);
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Seeds$getSeed = function (id) {
	return $elm$core$List$head(
		A2(
			$elm$core$List$filter,
			function (s) {
				return _Utils_eq(s.bd, id);
			},
			$author$project$Seeds$allSeeds));
};
var $elm$core$Basics$pow = _Basics_pow;
var $elm$core$List$sum = function (numbers) {
	return A3($elm$core$List$foldl, $elm$core$Basics$add, 0, numbers);
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Calc$effectiveSeedBaseDC = function (inst) {
	var _v0 = $author$project$Seeds$getSeed(inst.v);
	if (_v0.$ === 1) {
		return 0;
	} else {
		var seed = _v0.a;
		var baseDC = A2($elm$core$Maybe$withDefault, seed.a0, inst.a1);
		if (inst.v === 13) {
			var intervals = $elm$core$List$sum(
				A2(
					$elm$core$List$map,
					function ($) {
						return $.o;
					},
					A2(
						$elm$core$List$filter,
						function (asf) {
							return asf.d === 'foresee_interval';
						},
						inst.T)));
			return baseDC * A2($elm$core$Basics$pow, 2, intervals);
		} else {
			if (inst.v === 18) {
				var noLoe = A2(
					$elm$core$List$any,
					function (asf) {
						return (asf.d === 'reveal_no_loe') && (asf.o > 0);
					},
					inst.T);
				return noLoe ? (baseDC * 10) : baseDC;
			} else {
				return baseDC;
			}
		}
	}
};
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (!_v0.$) {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $author$project$Types$AddExtraTarget = 10;
var $author$project$Types$AreaToTarget = 20;
var $author$project$Types$AreaToTouch = 21;
var $author$project$Types$ChangeToBolt = 15;
var $author$project$Types$ChangeToCone = 17;
var $author$project$Types$ChangeToCylinder = 16;
var $author$project$Types$ChangeToFourCubes = 18;
var $author$project$Types$ChangeToRadius = 19;
var $author$project$Types$Contingent = 3;
var $author$project$Types$Dismissible = 8;
var $author$project$Types$FieldCastingTime = 1;
var $author$project$Types$FieldComponents = 0;
var $author$project$Types$FieldDuration = 4;
var $author$project$Types$FieldNone = 7;
var $author$project$Types$FieldRange = 2;
var $author$project$Types$FieldSaveDC = 5;
var $author$project$Types$FieldSpellResistance = 6;
var $author$project$Types$FieldTargetArea = 3;
var $author$project$Types$IncreaseArea = 22;
var $author$project$Types$IncreaseDamageDie = 27;
var $author$project$Types$IncreaseDuration = 6;
var $author$project$Types$IncreaseRange = 9;
var $author$project$Types$IncreaseSRCheck = 24;
var $author$project$Types$IncreaseSaveDC = 23;
var $author$project$Types$IncreaseVsDispel = 25;
var $author$project$Types$NoSomatic = 5;
var $author$project$Types$NoVerbal = 4;
var $author$project$Types$OneActionCastTime = 1;
var $author$project$Types$QuickenedSpell = 2;
var $author$project$Types$ReduceCastTime1Round = 0;
var $author$project$Types$Stackable = 1;
var $author$project$Types$TargetToTouch = 13;
var $author$project$Types$Toggle = 0;
var $author$project$Types$TouchToTarget = 14;
var $author$project$Factors$augmentingFactors = _List_fromArray(
	[
		{aw: 0, Y: 2, bd: 0, bh: 1, bk: 1, q: 'Reduce casting time by 1 round', b: 'minimum 1 round', c: 1},
		{aw: 0, Y: 20, bd: 1, bh: 0, bk: 1, q: '1-action casting time', b: 'Reduces to standard action', c: 1},
		{aw: 0, Y: 28, bd: 2, bh: 0, bk: 1, q: 'Quickened spell', b: 'Cast as a free action; max 1/round', c: 1},
		{aw: 0, Y: 25, bd: 3, bh: 0, bk: 1, q: 'Contingent on specific trigger', b: '', c: 7},
		{aw: 0, Y: 2, bd: 4, bh: 0, bk: 1, q: 'No verbal component', b: '', c: 0},
		{aw: 0, Y: 2, bd: 5, bh: 0, bk: 1, q: 'No somatic component', b: '', c: 0},
		{aw: 0, Y: 2, bd: 6, bh: 1, bk: 1, q: 'Increase duration 100%', b: '', c: 4},
		{aw: 0, Y: 0, bd: 7, bh: 0, bk: 5, q: 'Permanent duration', b: '×5 multiplier on total DC', c: 4},
		{aw: 0, Y: 2, bd: 8, bh: 0, bk: 1, q: 'Dismissible by caster', b: 'Adds (D) tag if not already', c: 4},
		{aw: 0, Y: 2, bd: 9, bh: 1, bk: 1, q: 'Increase range 100%', b: '', c: 2},
		{aw: 0, Y: 10, bd: 10, bh: 1, bk: 1, q: 'Add extra target within 300 ft.', b: '+1 target per application', c: 3},
		{aw: 0, Y: 10, bd: 11, bh: 0, bk: 1, q: 'Target → area', b: 'Changes targeting to area', c: 3},
		{aw: 0, Y: 15, bd: 12, bh: 0, bk: 1, q: 'Personal → area', b: 'Changes personal to area', c: 3},
		{aw: 0, Y: 4, bd: 13, bh: 0, bk: 1, q: 'Target → touch/ray (300 ft. range)', b: '', c: 3},
		{aw: 0, Y: 4, bd: 14, bh: 0, bk: 1, q: 'Touch/ray → target', b: '', c: 3},
		{aw: 0, Y: 2, bd: 15, bh: 0, bk: 1, q: 'Change area to bolt', b: '5 ft. x 300 ft. OR 10 ft. x 150 ft.', c: 3},
		{aw: 0, Y: 2, bd: 16, bh: 0, bk: 1, q: 'Change area to cylinder', b: '10-ft. radius, 30 ft. high', c: 3},
		{aw: 0, Y: 2, bd: 17, bh: 0, bk: 1, q: 'Change area to 40-ft. cone', b: '', c: 3},
		{aw: 0, Y: 2, bd: 18, bh: 0, bk: 1, q: 'Change area to four 10-ft. cubes', b: '', c: 3},
		{aw: 0, Y: 2, bd: 19, bh: 0, bk: 1, q: 'Change area to 20-ft. radius', b: '', c: 3},
		{aw: 0, Y: 4, bd: 20, bh: 0, bk: 1, q: 'Area → target', b: '', c: 3},
		{aw: 0, Y: 4, bd: 21, bh: 0, bk: 1, q: 'Area → touch/ray', b: 'Close range (25 ft. + 5 ft./2 levels)', c: 3},
		{aw: 0, Y: 4, bd: 22, bh: 1, bk: 1, q: 'Increase area 100%', b: '', c: 3},
		{aw: 0, Y: 2, bd: 23, bh: 1, bk: 1, q: 'Increase save DC by +1', b: '', c: 5},
		{aw: 0, Y: 2, bd: 24, bh: 1, bk: 1, q: '+1 to caster level check vs. SR', b: '', c: 6},
		{aw: 0, Y: 2, bd: 25, bh: 1, bk: 1, q: '+1 vs. dispel effects', b: '', c: 7},
		{aw: 0, Y: 0, bd: 26, bh: 2, bk: 2, q: 'Recorded onto stone tablet', b: 'x2 multiplier on total DC', c: 7},
		{aw: 0, Y: 10, bd: 27, bh: 1, bk: 1, q: 'Increase damage die +1 step', b: 'max d20', c: 7}
	]);
var $author$project$Types$Backlash = 28;
var $author$project$Types$ChangeToPersonal = 32;
var $author$project$Types$DecreaseDamageDie = 33;
var $author$project$Types$IncreaseCastTime1Day = 31;
var $author$project$Types$IncreaseCastTime1Min = 30;
var $author$project$Types$RitualSlot1 = 34;
var $author$project$Types$RitualSlot2 = 35;
var $author$project$Types$RitualSlot3 = 36;
var $author$project$Types$RitualSlot4 = 37;
var $author$project$Types$RitualSlot5 = 38;
var $author$project$Types$RitualSlot6 = 39;
var $author$project$Types$RitualSlot7 = 40;
var $author$project$Types$RitualSlot8 = 41;
var $author$project$Types$RitualSlot9 = 42;
var $author$project$Types$RitualSlotEpic = 43;
var $author$project$Types$XPBurn = 29;
var $author$project$Factors$mitigatingFactors = _List_fromArray(
	[
		{aw: 1, Y: -1, bd: 28, bh: 1, bk: 1, q: 'Backlash (1d6 per die to caster)', b: 'Caster takes Xd6 on casting or per round (max = HD×2 dice)', c: 7},
		{aw: 1, Y: -1, bd: 29, bh: 1, bk: 1, q: 'XP burn (per 100 XP)', b: 'Max 20,000 XP (-200 DC)', c: 7},
		{aw: 1, Y: -2, bd: 30, bh: 1, bk: 1, q: 'Increase casting time +1 minute', b: 'Max 10 min total', c: 1},
		{aw: 1, Y: -2, bd: 31, bh: 1, bk: 1, q: 'Increase casting time +1 day', b: 'After reaching 10 min; max 100 days', c: 1},
		{aw: 1, Y: -2, bd: 32, bh: 0, bk: 1, q: 'Change target/touch/area → personal', b: '', c: 3},
		{aw: 1, Y: -5, bd: 33, bh: 1, bk: 1, q: 'Decrease damage die -1 step', b: 'Min d4', c: 7},
		{aw: 1, Y: -1, bd: 34, bh: 1, bk: 1, q: 'Ritual: 1st-level spell slot', b: '-1 DC per participant', c: 7},
		{aw: 1, Y: -3, bd: 35, bh: 1, bk: 1, q: 'Ritual: 2nd-level spell slot', b: '-3 DC per participant', c: 7},
		{aw: 1, Y: -5, bd: 36, bh: 1, bk: 1, q: 'Ritual: 3rd-level spell slot', b: '-5 DC per participant', c: 7},
		{aw: 1, Y: -7, bd: 37, bh: 1, bk: 1, q: 'Ritual: 4th-level spell slot', b: '-7 DC per participant', c: 7},
		{aw: 1, Y: -9, bd: 38, bh: 1, bk: 1, q: 'Ritual: 5th-level spell slot', b: '-9 DC per participant', c: 7},
		{aw: 1, Y: -11, bd: 39, bh: 1, bk: 1, q: 'Ritual: 6th-level spell slot', b: '-11 DC per participant', c: 7},
		{aw: 1, Y: -13, bd: 40, bh: 1, bk: 1, q: 'Ritual: 7th-level spell slot', b: '-13 DC per participant', c: 7},
		{aw: 1, Y: -15, bd: 41, bh: 1, bk: 1, q: 'Ritual: 8th-level spell slot', b: '-15 DC per participant', c: 7},
		{aw: 1, Y: -17, bd: 42, bh: 1, bk: 1, q: 'Ritual: 9th-level spell slot', b: '-17 DC per participant', c: 7},
		{aw: 1, Y: -19, bd: 43, bh: 1, bk: 1, q: 'Ritual: Epic spell slot', b: '-19 DC per participant', c: 7}
	]);
var $author$project$Factors$allFactors = _Utils_ap($author$project$Factors$augmentingFactors, $author$project$Factors$mitigatingFactors);
var $author$project$Factors$getFactor = function (id) {
	return $elm$core$List$head(
		A2(
			$elm$core$List$filter,
			function (f) {
				return _Utils_eq(f.bd, id);
			},
			$author$project$Factors$allFactors));
};
var $elm$core$Basics$neq = _Utils_notEqual;
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $author$project$Calc$seedInstanceFactorDC = function (inst) {
	var _v0 = $author$project$Seeds$getSeed(inst.v);
	if (_v0.$ === 1) {
		return 0;
	} else {
		var seed = _v0.a;
		var skipIds = _List_fromArray(
			['foresee_interval', 'reveal_no_loe']);
		var availableFactors = _Utils_ap(
			seed.bw,
			A2(
				$elm$core$List$concatMap,
				function ($) {
					return $.a8;
				},
				seed.bj));
		return $elm$core$List$sum(
			A2(
				$elm$core$List$filterMap,
				function (asf) {
					return A2($elm$core$List$member, asf.d, skipIds) ? $elm$core$Maybe$Nothing : A2(
						$elm$core$Maybe$map,
						function (sf) {
							return sf.Y * asf.o;
						},
						$elm$core$List$head(
							A2(
								$elm$core$List$filter,
								function (sf) {
									return _Utils_eq(sf.bd, asf.d);
								},
								availableFactors)));
				},
				inst.T));
	}
};
var $author$project$Calc$calculateBreakdown = F2(
	function (instances, rawFactors) {
		var seedsTotal = $elm$core$List$sum(
			A2($elm$core$List$map, $author$project$Calc$effectiveSeedBaseDC, instances));
		var seedFactorsTotal = $elm$core$List$sum(
			A2($elm$core$List$map, $author$project$Calc$seedInstanceFactorDC, instances));
		var globalFactors = rawFactors;
		var mitigatingTotal = $elm$core$List$sum(
			A2(
				$elm$core$List$filterMap,
				function (af) {
					return A2(
						$elm$core$Maybe$andThen,
						function (f) {
							return (f.aw === 1) ? $elm$core$Maybe$Just(f.Y * af.o) : $elm$core$Maybe$Nothing;
						},
						$author$project$Factors$getFactor(af.d));
				},
				globalFactors));
		var permanentMult = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 7;
			},
			globalFactors) ? 5 : 1;
		var stoneTabletMult = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 26;
			},
			globalFactors) ? 2 : 1;
		var augmentingTotal = $elm$core$List$sum(
			A2(
				$elm$core$List$filterMap,
				function (af) {
					return A2(
						$elm$core$Maybe$andThen,
						function (f) {
							return ((!f.aw) && (f.bh !== 2)) ? $elm$core$Maybe$Just(f.Y * af.o) : $elm$core$Maybe$Nothing;
						},
						$author$project$Factors$getFactor(af.d));
				},
				globalFactors));
		var subtotal = (seedsTotal + seedFactorsTotal) + augmentingTotal;
		var finalDC = A2($elm$core$Basics$max, 1, ((subtotal * permanentMult) * stoneTabletMult) + mitigatingTotal);
		return {a$: augmentingTotal, a9: finalDC, bi: mitigatingTotal, bo: permanentMult, bq: seedFactorsTotal, br: seedsTotal, bs: stoneTabletMult};
	});
var $elm$core$String$concat = function (strings) {
	return A2($elm$core$String$join, '', strings);
};
var $author$project$Calc$devCosts = function (finalDC) {
	var gold = 9000 * finalDC;
	var timeDays = $elm$core$Basics$ceiling(gold / 50000);
	var xp = (gold / 25) | 0;
	return {ba: gold, bu: timeDays, bA: xp};
};
var $elm$core$Basics$modBy = _Basics_modBy;
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$shiftRightBy = _Bitwise_shiftRightBy;
var $elm$core$String$repeatHelp = F3(
	function (n, chunk, result) {
		return (n <= 0) ? result : A3(
			$elm$core$String$repeatHelp,
			n >> 1,
			_Utils_ap(chunk, chunk),
			(!(n & 1)) ? result : _Utils_ap(result, chunk));
	});
var $elm$core$String$repeat = F2(
	function (n, chunk) {
		return A3($elm$core$String$repeatHelp, n, chunk, '');
	});
var $elm$core$String$padLeft = F3(
	function (n, _char, string) {
		return _Utils_ap(
			A2(
				$elm$core$String$repeat,
				n - $elm$core$String$length(string),
				$elm$core$String$fromChar(_char)),
			string);
	});
var $author$project$Export$formatNum = function (n) {
	var str = $elm$core$String$fromInt(n);
	var len = $elm$core$String$length(str);
	return (len <= 3) ? str : ($author$project$Export$formatNum((n / 1000) | 0) + (',' + A3(
		$elm$core$String$padLeft,
		3,
		'0',
		$elm$core$String$fromInt(
			A2($elm$core$Basics$modBy, 1000, n)))));
};
var $elm$core$Basics$ge = _Utils_ge;
var $author$project$Export$showSign = function (n) {
	return (n >= 0) ? ('+' + $elm$core$String$fromInt(n)) : $elm$core$String$fromInt(n);
};
var $author$project$Export$factorLine = function (af) {
	return A2(
		$elm$core$Maybe$map,
		function (f) {
			return _Utils_ap(
				f.q,
				_Utils_ap(
					(af.o > 1) ? (' ×' + $elm$core$String$fromInt(af.o)) : '',
					(f.bh === 2) ? (' (×' + ($elm$core$String$fromInt(f.bk) + ')')) : (' (' + ($author$project$Export$showSign(f.Y * af.o) + ')'))));
		},
		$author$project$Factors$getFactor(af.d));
};
var $author$project$Export$globalFactorLines = F2(
	function (category, globalFactors) {
		return A2(
			$elm$core$List$filterMap,
			$author$project$Export$factorLine,
			A2(
				$elm$core$List$filter,
				function (af) {
					return A2(
						$elm$core$Maybe$withDefault,
						false,
						A2(
							$elm$core$Maybe$map,
							function (f) {
								return _Utils_eq(f.aw, category);
							},
							$author$project$Factors$getFactor(af.d)));
				},
				globalFactors));
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $author$project$Export$resolvePrimaryInstanceId = F2(
	function (instances, maybePrimaryId) {
		if (!maybePrimaryId.$) {
			var pid = maybePrimaryId.a;
			return A2(
				$elm$core$List$any,
				function (i) {
					return _Utils_eq(i.bg, pid);
				},
				instances) ? $elm$core$Maybe$Just(pid) : A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.bg;
				},
				$elm$core$List$head(instances));
		} else {
			return A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.bg;
				},
				$elm$core$List$head(instances));
		}
	});
var $author$project$Export$primarySeedId = F2(
	function (instances, maybePrimaryId) {
		return A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.v;
			},
			A2(
				$elm$core$Maybe$andThen,
				function (pid) {
					return $elm$core$List$head(
						A2(
							$elm$core$List$filter,
							function (i) {
								return _Utils_eq(i.bg, pid);
							},
							instances));
				},
				A2($author$project$Export$resolvePrimaryInstanceId, instances, maybePrimaryId)));
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === -2) {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1) {
					case 0:
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 1:
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$Black = 1;
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: -1, a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = 0;
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === -1) && (!right.a)) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === -1) && (!left.a)) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === -1) && (!left.a)) && (left.d.$ === -1)) && (!left.d.a)) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === -2) {
			return A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1) {
				case 0:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 1:
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $elm$core$List$sortBy = _List_sortBy;
var $author$project$Export$seedFactorBlocks = function (instances) {
	return A2(
		$elm$core$List$sortBy,
		function ($) {
			return $.L;
		},
		A3(
			$elm$core$List$foldl,
			F2(
				function (inst, _v0) {
					var seenCounts = _v0.a;
					var acc = _v0.b;
					var _v1 = $author$project$Seeds$getSeed(inst.v);
					if (_v1.$ === 1) {
						return _Utils_Tuple2(seenCounts, acc);
					} else {
						var seed = _v1.a;
						var priorCount = A2(
							$elm$core$Maybe$withDefault,
							0,
							A2($elm$core$Dict$get, seed.q, seenCounts));
						var overrideLines = function () {
							var _v2 = inst.a1;
							if (!_v2.$) {
								var dc = _v2.a;
								return (!_Utils_eq(dc, seed.a0)) ? _List_fromArray(
									[
										'Base DC override: ' + $elm$core$String$fromInt(dc)
									]) : _List_Nil;
							} else {
								return _List_Nil;
							}
						}();
						var label = (!priorCount) ? seed.q : (seed.q + (' (' + ($elm$core$String$fromInt(priorCount + 1) + ')')));
						var choiceLines = A2(
							$elm$core$List$map,
							function (c) {
								return c.L + (': ' + A2(
									$elm$core$Maybe$withDefault,
									c.a4,
									A2($elm$core$Dict$get, c.bd, inst.ay)));
							},
							seed.ay);
						var availableFactors = _Utils_ap(
							seed.bw,
							A2(
								$elm$core$List$concatMap,
								function ($) {
									return $.a8;
								},
								seed.bj));
						var factorLines = A2(
							$elm$core$List$filterMap,
							function (asf) {
								return A2(
									$elm$core$Maybe$map,
									function (sf) {
										return _Utils_ap(
											sf.q,
											_Utils_ap(
												(asf.o > 1) ? (' ×' + $elm$core$String$fromInt(asf.o)) : '',
												(!sf.Y) ? ' (special)' : (' (' + ($author$project$Export$showSign(sf.Y * asf.o) + ')'))));
									},
									$elm$core$List$head(
										A2(
											$elm$core$List$filter,
											function (sf) {
												return _Utils_eq(sf.bd, asf.d);
											},
											availableFactors)));
							},
							A2(
								$elm$core$List$filter,
								function (asf) {
									return asf.o > 0;
								},
								inst.T));
						var lines = _Utils_ap(
							choiceLines,
							_Utils_ap(overrideLines, factorLines));
						return $elm$core$List$isEmpty(lines) ? _Utils_Tuple2(
							A3($elm$core$Dict$insert, seed.q, priorCount + 1, seenCounts),
							acc) : _Utils_Tuple2(
							A3($elm$core$Dict$insert, seed.q, priorCount + 1, seenCounts),
							_Utils_ap(
								acc,
								_List_fromArray(
									[
										{L: label, ac: lines}
									])));
					}
				}),
			_Utils_Tuple2($elm$core$Dict$empty, _List_Nil),
			instances).b);
};
var $author$project$Export$seedListLine = F2(
	function (maybePrimaryId, instances) {
		var showPrimaryTag = $elm$core$List$length(instances) > 1;
		var resolvedPrimaryId = A2($author$project$Export$resolvePrimaryInstanceId, instances, maybePrimaryId);
		return A2(
			$elm$core$String$join,
			', ',
			A2(
				$elm$core$List$filterMap,
				function (inst) {
					return A2(
						$elm$core$Maybe$map,
						function (s) {
							return s.q + (' (' + ($elm$core$String$fromInt(
								A2($elm$core$Maybe$withDefault, s.a0, inst.a1)) + (')' + ((showPrimaryTag && _Utils_eq(
								resolvedPrimaryId,
								$elm$core$Maybe$Just(inst.bg))) ? ' [Primary]' : ''))));
						},
						$author$project$Seeds$getSeed(inst.v));
				},
				instances));
	});
var $author$project$Export$componentToString = function (c) {
	switch (c) {
		case 0:
			return 'V';
		case 1:
			return 'S';
		case 2:
			return 'M';
		case 3:
			return 'DF';
		case 4:
			return 'F';
		default:
			return 'XP';
	}
};
var $author$project$Export$seedStatBlockRows = function (seed) {
	var savingThrowStr = function () {
		var _v0 = seed.aj;
		if (_v0.$ === 1) {
			return 'None';
		} else {
			var st = _v0.a;
			var typeStr = function () {
				var _v2 = st.ai;
				switch (_v2) {
					case 0:
						return 'Will';
					case 1:
						return 'Reflex';
					default:
						return 'Fortitude';
				}
			}();
			var harmlessStr = st.bb ? ' (harmless)' : '';
			var effectStr = function () {
				var _v1 = st.S;
				switch (_v1) {
					case 0:
						return 'negates';
					case 1:
						return 'half';
					case 2:
						return 'partial';
					default:
						return '(see text)';
				}
			}();
			return typeStr + (' ' + (effectStr + harmlessStr));
		}
	}();
	var descriptorStr = $elm$core$List$isEmpty(seed.Z) ? '' : (' [' + (A2($elm$core$String$join, ', ', seed.Z) + ']'));
	return _Utils_ap(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'School',
				_Utils_ap(seed.ak, descriptorStr)),
				_Utils_Tuple2(
				'Components',
				A2(
					$elm$core$String$join,
					', ',
					A2($elm$core$List$map, $author$project$Export$componentToString, seed.W))),
				_Utils_Tuple2('Casting Time', seed.V),
				_Utils_Tuple2('Range', seed.ah)
			]),
		_Utils_ap(
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2(
						$elm$core$Maybe$map,
						function (t) {
							return _Utils_Tuple2('Target', t);
						},
						seed.au),
						A2(
						$elm$core$Maybe$map,
						function (a) {
							return _Utils_Tuple2('Area', a);
						},
						seed.U),
						A2(
						$elm$core$Maybe$map,
						function (e) {
							return _Utils_Tuple2('Effect', e);
						},
						seed.S)
					])),
			_List_fromArray(
				[
					_Utils_Tuple2('Duration', seed._),
					_Utils_Tuple2('Saving Throw', savingThrowStr),
					_Utils_Tuple2(
					'Spell Resistance',
					seed.aq ? 'Yes' : 'No')
				])));
};
var $author$project$Calc$availableSavingThrows = function (instances) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (st, acc) {
				return A2(
					$elm$core$List$any,
					function (s) {
						return _Utils_eq(s.ai, st.ai);
					},
					acc) ? acc : _Utils_ap(
					acc,
					_List_fromArray(
						[st]));
			}),
		_List_Nil,
		A2(
			$elm$core$List$filterMap,
			function (inst) {
				return A2(
					$elm$core$Maybe$andThen,
					function ($) {
						return $.aj;
					},
					$author$project$Seeds$getSeed(inst.v));
			},
			instances));
};
var $author$project$Calc$availableSchools = function (instances) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (s, acc) {
				return A2($elm$core$List$member, s, acc) ? acc : _Utils_ap(
					acc,
					_List_fromArray(
						[s]));
			}),
		_List_Nil,
		A2(
			$elm$core$List$filterMap,
			function (inst) {
				return A2(
					$elm$core$Maybe$map,
					function ($) {
						return $.ak;
					},
					$author$project$Seeds$getSeed(inst.v));
			},
			instances));
};
var $author$project$Calc$componentToString = function (c) {
	switch (c) {
		case 0:
			return 'V';
		case 1:
			return 'S';
		case 2:
			return 'M';
		case 3:
			return 'DF';
		case 4:
			return 'F';
		default:
			return 'XP';
	}
};
var $author$project$Calc$deriveCastingTime = F2(
	function (globalFactors, primarySeed) {
		var base = A2(
			$elm$core$Maybe$withDefault,
			'1 minute',
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.V;
				},
				primarySeed));
		if (A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 2;
			},
			globalFactors)) {
			return 'Free action (quickened)';
		} else {
			if (A2(
				$elm$core$List$any,
				function (af) {
					return af.d === 1;
				},
				globalFactors)) {
				return '1 action';
			} else {
				var roundReductions = $elm$core$List$sum(
					A2(
						$elm$core$List$map,
						function ($) {
							return $.o;
						},
						A2(
							$elm$core$List$filter,
							function (af) {
								return !af.d;
							},
							globalFactors)));
				var minExtra = $elm$core$List$sum(
					A2(
						$elm$core$List$map,
						function ($) {
							return $.o;
						},
						A2(
							$elm$core$List$filter,
							function (af) {
								return af.d === 30;
							},
							globalFactors)));
				var dayExtra = $elm$core$List$sum(
					A2(
						$elm$core$List$map,
						function ($) {
							return $.o;
						},
						A2(
							$elm$core$List$filter,
							function (af) {
								return af.d === 31;
							},
							globalFactors)));
				if (dayExtra > 0) {
					return $elm$core$String$fromInt(10 + dayExtra) + (' minutes + ' + ($elm$core$String$fromInt(dayExtra) + ' day(s)'));
				} else {
					if (roundReductions > 0) {
						var totalRounds = (1 + minExtra) * 10;
						var roundsStr = function (n) {
							return _Utils_ap(
								$elm$core$String$fromInt(n),
								(n === 1) ? ' round' : ' rounds');
						};
						var minutesStr = function (n) {
							return _Utils_ap(
								$elm$core$String$fromInt(n),
								(n === 1) ? ' minute' : ' minutes');
						};
						var afterRounds = A2($elm$core$Basics$max, totalRounds - roundReductions, 1);
						var resultMinutes = (afterRounds / 10) | 0;
						var resultRounds = A2($elm$core$Basics$modBy, 10, afterRounds);
						return ((resultMinutes > 0) && (resultRounds > 0)) ? (minutesStr(resultMinutes) + (' + ' + roundsStr(resultRounds))) : ((resultMinutes > 0) ? minutesStr(resultMinutes) : roundsStr(resultRounds));
					} else {
						if (minExtra > 0) {
							return $elm$core$String$fromInt(1 + minExtra) + ' minutes';
						} else {
							return base;
						}
					}
				}
			}
		}
	});
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $author$project$Calc$durationRank = function (d) {
	switch (d) {
		case '5 rounds':
			return 5;
		case '20 rounds':
			return 10;
		case '20 rounds (D)':
			return 11;
		case 'Concentration + 20 minutes':
			return 20;
		case '20 minutes':
			return 30;
		case '200 minutes':
			return 40;
		case '200 minutes (D)':
			return 41;
		case '200 minutes or until expended (D)':
			return 42;
		case '8 hours (simple objects last 24 hours)':
			return 50;
		case 'Until expended (up to 12 hours)':
			return 55;
		case '20 hours':
			return 60;
		case '20 hours or until completed':
			return 61;
		case '24 hours (D)':
			return 65;
		case 'Concentration + 20 hours':
			return 70;
		default:
			return 99;
	}
};
var $author$project$Calc$instanceDuration = function (inst) {
	var _v0 = $author$project$Seeds$getSeed(inst.v);
	if (_v0.$ === 1) {
		return '—';
	} else {
		var seed = _v0.a;
		return seed._;
	}
};
var $elm$core$Basics$not = _Basics_not;
var $author$project$Calc$leadingDigits = function (s) {
	var _v0 = $elm$core$String$uncons(s);
	if (_v0.$ === 1) {
		return _Utils_Tuple2('', '');
	} else {
		var _v1 = _v0.a;
		var c = _v1.a;
		var rest = _v1.b;
		if ($elm$core$Char$isDigit(c)) {
			var _v2 = $author$project$Calc$leadingDigits(rest);
			var moreDigits = _v2.a;
			var remaining = _v2.b;
			return _Utils_Tuple2(
				_Utils_ap(
					$elm$core$String$fromChar(c),
					moreDigits),
				remaining);
		} else {
			return _Utils_Tuple2('', s);
		}
	}
};
var $author$project$Calc$scaleDuration = F2(
	function (mult, s) {
		var _v0 = $elm$core$String$uncons(s);
		if (_v0.$ === 1) {
			return '';
		} else {
			var _v1 = _v0.a;
			var c = _v1.a;
			var rest = _v1.b;
			if ($elm$core$Char$isDigit(c)) {
				var _v2 = $author$project$Calc$leadingDigits(s);
				var digits = _v2.a;
				var remaining = _v2.b;
				var _v3 = $elm$core$String$toInt(digits);
				if (_v3.$ === 1) {
					return _Utils_ap(
						digits,
						A2($author$project$Calc$scaleDuration, mult, remaining));
				} else {
					var n = _v3.a;
					return _Utils_ap(
						$elm$core$String$fromInt(n * mult),
						A2($author$project$Calc$scaleDuration, mult, remaining));
				}
			} else {
				return _Utils_ap(
					$elm$core$String$fromChar(c),
					A2($author$project$Calc$scaleDuration, mult, rest));
			}
		}
	});
var $author$project$Calc$deriveDuration = F2(
	function (globalFactors, instances) {
		var isPermanent = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 7;
			},
			globalFactors);
		var isDismissable = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 8;
			},
			globalFactors) || A2(
			$elm$core$List$any,
			A2(
				$elm$core$Basics$composeR,
				$author$project$Calc$instanceDuration,
				$elm$core$String$contains('(D)')),
			instances);
		var doublings = $elm$core$List$sum(
			A2(
				$elm$core$List$map,
				function ($) {
					return $.o;
				},
				A2(
					$elm$core$List$filter,
					function (af) {
						return af.d === 6;
					},
					globalFactors)));
		var base = A2(
			$elm$core$Maybe$withDefault,
			'—',
			$elm$core$List$head(
				A2(
					$elm$core$List$sortBy,
					$author$project$Calc$durationRank,
					A2($elm$core$List$map, $author$project$Calc$instanceDuration, instances))));
		var addDismissTag = function (s) {
			return (isDismissable && (!A2($elm$core$String$contains, '(D)', s))) ? (s + ' (D)') : s;
		};
		return isPermanent ? addDismissTag('Permanent') : ((doublings > 0) ? addDismissTag(
			A2($author$project$Calc$scaleDuration, doublings + 1, base)) : addDismissTag(base));
	});
var $author$project$Calc$formatLargeInt = function (n) {
	return (n >= 1000) ? ($author$project$Calc$formatLargeInt((n / 1000) | 0) + (',' + A3(
		$elm$core$String$padLeft,
		3,
		'0',
		$elm$core$String$fromInt(
			A2($elm$core$Basics$modBy, 1000, n))))) : $elm$core$String$fromInt(n);
};
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $author$project$Calc$scaleRange = F2(
	function (mult, s) {
		var _v0 = $elm$core$String$uncons(s);
		if (_v0.$ === 1) {
			return '';
		} else {
			var _v1 = _v0.a;
			var c = _v1.a;
			var rest = _v1.b;
			if ($elm$core$Char$isDigit(c)) {
				var _v2 = $author$project$Calc$leadingDigits(s);
				var digits = _v2.a;
				var afterDigits = _v2.b;
				var _v3 = function () {
					if (A2($elm$core$String$startsWith, ',', afterDigits)) {
						var commaTail = A2($elm$core$String$dropLeft, 1, afterDigits);
						var _v4 = $author$project$Calc$leadingDigits(commaTail);
						var extraDigits = _v4.a;
						var afterExtra = _v4.b;
						return (($elm$core$String$length(extraDigits) === 3) && A2($elm$core$String$startsWith, ' ft.', afterExtra)) ? _Utils_Tuple2(digits + (',' + extraDigits), afterExtra) : _Utils_Tuple2(digits, afterDigits);
					} else {
						return _Utils_Tuple2(digits, afterDigits);
					}
				}();
				var fullNumStr = _v3.a;
				var remaining = _v3.b;
				if (A2($elm$core$String$startsWith, ' ft.', remaining)) {
					var _v5 = $elm$core$String$toInt(
						A3($elm$core$String$replace, ',', '', fullNumStr));
					if (_v5.$ === 1) {
						return _Utils_ap(
							fullNumStr,
							A2($author$project$Calc$scaleRange, mult, remaining));
					} else {
						var n = _v5.a;
						return _Utils_ap(
							$author$project$Calc$formatLargeInt(n * mult),
							A2($author$project$Calc$scaleRange, mult, remaining));
					}
				} else {
					return _Utils_ap(
						fullNumStr,
						A2($author$project$Calc$scaleRange, mult, remaining));
				}
			} else {
				return _Utils_ap(
					$elm$core$String$fromChar(c),
					A2($author$project$Calc$scaleRange, mult, rest));
			}
		}
	});
var $author$project$Calc$deriveRange = F2(
	function (globalFactors, primarySeed) {
		var doublings = $elm$core$List$sum(
			A2(
				$elm$core$List$map,
				function ($) {
					return $.o;
				},
				A2(
					$elm$core$List$filter,
					function (af) {
						return af.d === 9;
					},
					globalFactors)));
		var base = A2(
			$elm$core$Maybe$withDefault,
			'—',
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.ah;
				},
				primarySeed));
		return (doublings > 0) ? A2($author$project$Calc$scaleRange, doublings + 1, base) : base;
	});
var $author$project$Calc$deriveSavingThrow = F3(
	function (mst, globalFactors, saveDCBonus) {
		if (mst.$ === 1) {
			return 'None';
		} else {
			var st = mst.a;
			var typeStr = function () {
				var _v2 = st.ai;
				switch (_v2) {
					case 0:
						return 'Will';
					case 1:
						return 'Reflex';
					default:
						return 'Fortitude';
				}
			}();
			var harmlessStr = st.bb ? ' (harmless)' : '';
			var effectStr = function () {
				var _v1 = st.S;
				switch (_v1) {
					case 0:
						return 'negates';
					case 1:
						return 'half';
					case 2:
						return 'partial';
					default:
						return '(see text)';
				}
			}();
			var dcBonusFromFactors = $elm$core$List$sum(
				A2(
					$elm$core$List$map,
					function ($) {
						return $.o;
					},
					A2(
						$elm$core$List$filter,
						function (af) {
							return af.d === 23;
						},
						globalFactors)));
			var totalBonus = saveDCBonus + dcBonusFromFactors;
			var dcStr = (totalBonus > 0) ? (' (DC +' + ($elm$core$String$fromInt(totalBonus) + ')')) : '';
			return typeStr + (' ' + (effectStr + (dcStr + harmlessStr)));
		}
	});
var $author$project$Calc$targetToAreaText = function (label) {
	switch (label) {
		case 'Cylinder':
			return 'Cylinder (10-ft. radius, 30 ft. high)';
		case '20-ft. radius':
			return '20-ft.-radius spread';
		default:
			return label;
	}
};
var $author$project$Calc$statBlock = F8(
	function (instances, rawFactors, saveDCBonus, maybePrimaryId, maybeSchool, maybeSavingThrow, maybeTargetToAreaShape, maybePersonalToAreaShape) {
		var seeds = A2(
			$elm$core$List$filterMap,
			function (inst) {
				return $author$project$Seeds$getSeed(inst.v);
			},
			instances);
		var spellResistance = A2(
			$elm$core$List$any,
			function ($) {
				return $.aq;
			},
			seeds) ? 'Yes' : 'No';
		var school = A2(
			$elm$core$Maybe$withDefault,
			A2(
				$elm$core$Maybe$withDefault,
				'—',
				$elm$core$List$head(
					$author$project$Calc$availableSchools(instances))),
			maybeSchool);
		var resolvedSave = function () {
			if (!maybeSavingThrow.$) {
				return maybeSavingThrow;
			} else {
				return $elm$core$List$head(
					$author$project$Calc$availableSavingThrows(instances));
			}
		}();
		var primarySeed = function () {
			var found = A2(
				$elm$core$Maybe$andThen,
				function (iid) {
					return A2(
						$elm$core$Maybe$andThen,
						function (i) {
							return $author$project$Seeds$getSeed(i.v);
						},
						$elm$core$List$head(
							A2(
								$elm$core$List$filter,
								function (i) {
									return _Utils_eq(i.bg, iid);
								},
								instances)));
				},
				maybePrimaryId);
			if (!found.$) {
				return found;
			} else {
				return $elm$core$List$head(seeds);
			}
		}();
		var globalFactors = rawFactors;
		var personalToAreaActive = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 12;
			},
			globalFactors);
		var range = A2($author$project$Calc$deriveRange, globalFactors, primarySeed);
		var removeS = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 5;
			},
			globalFactors);
		var removeV = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 4;
			},
			globalFactors);
		var savingThrow = A3($author$project$Calc$deriveSavingThrow, resolvedSave, globalFactors, saveDCBonus);
		var targetToAreaActive = A2(
			$elm$core$List$any,
			function (af) {
				return af.d === 11;
			},
			globalFactors);
		var extraTargets = A2(
			$elm$core$Maybe$withDefault,
			0,
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.o;
				},
				$elm$core$List$head(
					A2(
						$elm$core$List$filter,
						function (af) {
							return af.d === 10;
						},
						globalFactors))));
		var effect = A2(
			$elm$core$Maybe$andThen,
			function ($) {
				return $.S;
			},
			primarySeed);
		var duration = A2($author$project$Calc$deriveDuration, globalFactors, instances);
		var descriptors = A3(
			$elm$core$List$foldl,
			F2(
				function (d, acc) {
					return A2($elm$core$List$member, d, acc) ? acc : _Utils_ap(
						acc,
						_List_fromArray(
							[d]));
				}),
			_List_Nil,
			A2(
				$elm$core$List$concatMap,
				function ($) {
					return $.Z;
				},
				seeds));
		var convertingToArea = targetToAreaActive || personalToAreaActive;
		var target = convertingToArea ? $elm$core$Maybe$Nothing : A2(
			$elm$core$Maybe$map,
			function (t) {
				return (extraTargets > 0) ? (t + (' (+' + ($elm$core$String$fromInt(extraTargets) + (' additional ' + (((extraTargets === 1) ? 'target' : 'targets') + ')'))))) : t;
			},
			A2(
				$elm$core$Maybe$andThen,
				function ($) {
					return $.au;
				},
				primarySeed));
		var castingTime = A2($author$project$Calc$deriveCastingTime, globalFactors, primarySeed);
		var baseComponents = A3(
			$elm$core$List$foldl,
			F2(
				function (c, acc) {
					return A2($elm$core$List$member, c, acc) ? acc : _Utils_ap(
						acc,
						_List_fromArray(
							[c]));
				}),
			_List_Nil,
			A2(
				$elm$core$List$concatMap,
				function ($) {
					return $.W;
				},
				seeds));
		var components = A2(
			$elm$core$List$map,
			$author$project$Calc$componentToString,
			A2(
				$elm$core$List$filter,
				function (c) {
					return !(removeS && (c === 1));
				},
				A2(
					$elm$core$List$filter,
					function (c) {
						return !(removeV && (!c));
					},
					baseComponents)));
		var activeToAreaShape = targetToAreaActive ? maybeTargetToAreaShape : (personalToAreaActive ? maybePersonalToAreaShape : $elm$core$Maybe$Nothing);
		var area = convertingToArea ? A2($elm$core$Maybe$map, $author$project$Calc$targetToAreaText, activeToAreaShape) : A2(
			$elm$core$Maybe$andThen,
			function ($) {
				return $.U;
			},
			primarySeed);
		return {U: area, V: castingTime, W: components, Z: descriptors, _: duration, S: effect, ah: range, aj: savingThrow, ak: school, aq: spellResistance, au: target};
	});
var $author$project$Export$statBlockRows = F2(
	function (finalDC, sb) {
		var descriptorStr = $elm$core$List$isEmpty(sb.Z) ? '' : (' [' + (A2($elm$core$String$join, ', ', sb.Z) + ']'));
		return _Utils_ap(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'School',
					_Utils_ap(sb.ak, descriptorStr)),
					_Utils_Tuple2(
					'Spellcraft DC',
					$elm$core$String$fromInt(finalDC)),
					_Utils_Tuple2(
					'Components',
					A2($elm$core$String$join, ', ', sb.W)),
					_Utils_Tuple2('Casting Time', sb.V),
					_Utils_Tuple2('Range', sb.ah)
				]),
			_Utils_ap(
				A2(
					$elm$core$List$filterMap,
					$elm$core$Basics$identity,
					_List_fromArray(
						[
							A2(
							$elm$core$Maybe$map,
							function (t) {
								return _Utils_Tuple2('Target', t);
							},
							sb.au),
							A2(
							$elm$core$Maybe$map,
							function (a) {
								return _Utils_Tuple2('Area', a);
							},
							sb.U),
							A2(
							$elm$core$Maybe$map,
							function (e) {
								return _Utils_Tuple2('Effect', e);
							},
							sb.S)
						])),
				_List_fromArray(
					[
						_Utils_Tuple2('Duration', sb._),
						_Utils_Tuple2('Saving Throw', sb.aj),
						_Utils_Tuple2('Spell Resistance', sb.aq)
					])));
	});
var $author$project$Export$uniqueSeeds = function (instances) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (seed, acc) {
				return A2(
					$elm$core$List$any,
					function (s) {
						return _Utils_eq(s.bd, seed.bd);
					},
					acc) ? acc : _Utils_ap(
					acc,
					_List_fromArray(
						[seed]));
			}),
		_List_Nil,
		A2(
			$elm$core$List$filterMap,
			function (inst) {
				return $author$project$Seeds$getSeed(inst.v);
			},
			instances));
};
var $author$project$Export$generateMarkdown = F7(
	function (spellName, instances, globalFactors, casterSaveDCBonus, maybePrimaryId, maybeTargetToAreaShape, maybePersonalToAreaShape) {
		var title = $elm$core$String$isEmpty(spellName) ? 'Unnamed Spell' : spellName;
		var seeds = $author$project$Export$uniqueSeeds(instances);
		var seedBlocks = $author$project$Export$seedFactorBlocks(instances);
		var sb = A8($author$project$Calc$statBlock, instances, globalFactors, casterSaveDCBonus, maybePrimaryId, $elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing, maybeTargetToAreaShape, maybePersonalToAreaShape);
		var primarySeed = A2($author$project$Export$primarySeedId, instances, maybePrimaryId);
		var mitigations = A2($author$project$Export$globalFactorLines, 1, globalFactors);
		var mdRows = function (rows) {
			return $elm$core$String$concat(
				A2(
					$elm$core$List$map,
					function (_v0) {
						var label = _v0.a;
						var val = _v0.b;
						return '**' + (label + (':** ' + (val + '  \n')));
					},
					rows));
		};
		var bulletList = function (items) {
			return $elm$core$List$isEmpty(items) ? '_None_\n' : $elm$core$String$concat(
				A2(
					$elm$core$List$map,
					function (i) {
						return '- ' + (i + '\n');
					},
					items));
		};
		var breakdown = A2($author$project$Calc$calculateBreakdown, instances, globalFactors);
		var costs = $author$project$Calc$devCosts(breakdown.a9);
		var augments = A2($author$project$Export$globalFactorLines, 0, globalFactors);
		return '# ' + (title + ('\n\n' + ('## Stat Block\n\n' + (mdRows(
			A2($author$project$Export$statBlockRows, breakdown.a9, sb)) + ('\n' + ('## Seeds Used\n\n' + (A2($author$project$Export$seedListLine, maybePrimaryId, instances) + ('\n\n' + ('## DC Breakdown\n\n' + ('| | |\n|---|---|\n' + ('| Seeds | ' + ($author$project$Export$showSign(breakdown.br) + (' |\n' + ('| Seed Factors | ' + ($author$project$Export$showSign(breakdown.bq) + (' |\n' + ('| Augmenting | ' + ($author$project$Export$showSign(breakdown.a$) + (' |\n' + (((breakdown.bo > 1) ? '| Permanent Duration | ×5 |\n' : '') + (((breakdown.bs > 1) ? '| Stone Tablet | ×2 |\n' : '') + ('| Mitigating | ' + ($author$project$Export$showSign(breakdown.bi) + (' |\n' + ('| **Final DC** | **' + ($elm$core$String$fromInt(breakdown.a9) + ('** |\n\n' + ('## Development Costs\n\n' + ('| | |\n|---|---|\n' + ('| Gold Cost | ' + ($author$project$Export$formatNum(costs.ba) + (' gp |\n' + ('| Development Time | ' + ($elm$core$String$fromInt(costs.bu) + (' days |\n' + ('| XP Cost | ' + ($author$project$Export$formatNum(costs.bA) + (' XP |\n\n' + ('## Seed Factors\n\n' + (($elm$core$List$isEmpty(seedBlocks) ? '_None_\n\n' : $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				function (b) {
					return '**' + (b.L + ('**\n\n' + (bulletList(b.ac) + '\n')));
				},
				seedBlocks))) + ('## Global Augments\n\n' + (bulletList(augments) + ('\n' + ('## Global Mitigations\n\n' + (bulletList(mitigations) + ('\n' + ('## Original Seed Listing\n\n' + $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				function (seed) {
					return '### ' + (seed.q + (((($elm$core$List$length(seeds) > 1) && _Utils_eq(
						primarySeed,
						$elm$core$Maybe$Just(seed.bd))) ? ' (Primary)' : '') + ('\n\n' + (mdRows(
						$author$project$Export$seedStatBlockRows(seed)) + ('\n' + (seed.aA + '\n\n'))))));
				},
				seeds)))))))))))))))))))))))))))))))))))))))))))))))));
	});
var $elm$core$String$toUpper = _String_toUpper;
var $author$project$Export$generatePlainText = F7(
	function (spellName, instances, globalFactors, casterSaveDCBonus, maybePrimaryId, maybeTargetToAreaShape, maybePersonalToAreaShape) {
		var title = $elm$core$String$isEmpty(spellName) ? 'Unnamed Spell' : spellName;
		var seeds = $author$project$Export$uniqueSeeds(instances);
		var seedBlocks = $author$project$Export$seedFactorBlocks(instances);
		var sb = A8($author$project$Calc$statBlock, instances, globalFactors, casterSaveDCBonus, maybePrimaryId, $elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing, maybeTargetToAreaShape, maybePersonalToAreaShape);
		var ptRows = function (rows) {
			return $elm$core$String$concat(
				A2(
					$elm$core$List$map,
					function (_v0) {
						var label = _v0.a;
						var val = _v0.b;
						return label + (': ' + (val + '\n'));
					},
					rows));
		};
		var primarySeed = A2($author$project$Export$primarySeedId, instances, maybePrimaryId);
		var mitigations = A2($author$project$Export$globalFactorLines, 1, globalFactors);
		var header = function (label) {
			var bar = A2($elm$core$String$repeat, 40, '-');
			return bar + ('\n' + ($elm$core$String$toUpper(label) + ('\n' + (bar + '\n\n'))));
		};
		var bulletList = function (items) {
			return $elm$core$List$isEmpty(items) ? 'None\n' : $elm$core$String$concat(
				A2(
					$elm$core$List$map,
					function (i) {
						return '- ' + (i + '\n');
					},
					items));
		};
		var breakdown = A2($author$project$Calc$calculateBreakdown, instances, globalFactors);
		var costs = $author$project$Calc$devCosts(breakdown.a9);
		var augments = A2($author$project$Export$globalFactorLines, 0, globalFactors);
		return title + ('\n\n' + (header('Stat Block') + (ptRows(
			A2($author$project$Export$statBlockRows, breakdown.a9, sb)) + ('\n' + (header('Seeds Used') + (A2($author$project$Export$seedListLine, maybePrimaryId, instances) + ('\n\n' + (header('DC Breakdown') + ('Seeds: ' + ($author$project$Export$showSign(breakdown.br) + ('\n' + ('Seed Factors: ' + ($author$project$Export$showSign(breakdown.bq) + ('\n' + ('Augmenting: ' + ($author$project$Export$showSign(breakdown.a$) + ('\n' + (((breakdown.bo > 1) ? 'Permanent Duration: x5\n' : '') + (((breakdown.bs > 1) ? 'Stone Tablet: x2\n' : '') + ('Mitigating: ' + ($author$project$Export$showSign(breakdown.bi) + ('\n' + ('Final DC: ' + ($elm$core$String$fromInt(breakdown.a9) + ('\n\n' + (header('Development Costs') + ('Gold Cost: ' + ($author$project$Export$formatNum(costs.ba) + (' gp\n' + ('Development Time: ' + ($elm$core$String$fromInt(costs.bu) + (' days\n' + ('XP Cost: ' + ($author$project$Export$formatNum(costs.bA) + (' XP\n\n' + (header('Seed Factors') + (($elm$core$List$isEmpty(seedBlocks) ? 'None\n\n' : $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				function (b) {
					return b.L + (':\n' + (bulletList(b.ac) + '\n'));
				},
				seedBlocks))) + (header('Global Augments') + (bulletList(augments) + ('\n' + (header('Global Mitigations') + (bulletList(mitigations) + ('\n' + (header('Original Seed Listing') + $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				function (seed) {
					return seed.q + (((($elm$core$List$length(seeds) > 1) && _Utils_eq(
						primarySeed,
						$elm$core$Maybe$Just(seed.bd))) ? ' (Primary)' : '') + ('\n\n' + (ptRows(
						$author$project$Export$seedStatBlockRows(seed)) + ('\n' + (seed.aA + '\n\n')))));
				},
				seeds))))))))))))))))))))))))))))))))))))))))))))));
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 0:
				var name = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ap: name}),
					$elm$core$Platform$Cmd$none);
			case 1:
				var seedId = msg.a;
				var newPrimary = function () {
					var _v1 = model.t;
					if (_v1.$ === 1) {
						return $elm$core$Maybe$Just(model.N);
					} else {
						return model.t;
					}
				}();
				var newInstance = {T: _List_Nil, a1: $elm$core$Maybe$Nothing, ay: $elm$core$Dict$empty, bg: model.N, v: seedId};
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							N: model.N + 1,
							t: newPrimary,
							j: _Utils_ap(
								model.j,
								_List_fromArray(
									[newInstance]))
						}),
					$elm$core$Platform$Cmd$none);
			case 2:
				var iid = msg.a;
				var remaining = A2(
					$elm$core$List$filter,
					function (i) {
						return !_Utils_eq(i.bg, iid);
					},
					model.j);
				var newPrimary = _Utils_eq(
					model.t,
					$elm$core$Maybe$Just(iid)) ? A2(
					$elm$core$Maybe$map,
					function ($) {
						return $.bg;
					},
					$elm$core$List$head(remaining)) : model.t;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{t: newPrimary, j: remaining}),
					$elm$core$Platform$Cmd$none);
			case 8:
				var iid = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							t: $elm$core$Maybe$Just(iid)
						}),
					$elm$core$Platform$Cmd$none);
			case 9:
				var school = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							an: $elm$core$Maybe$Just(school)
						}),
					$elm$core$Platform$Cmd$none);
			case 10:
				var mst = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{am: mst}),
					$elm$core$Platform$Cmd$none);
			case 3:
				var iid = msg.a;
				var factorId = msg.b;
				var qty = msg.c;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							j: A2(
								$elm$core$List$map,
								function (i) {
									if (_Utils_eq(i.bg, iid)) {
										var existing = A2(
											$elm$core$List$filter,
											function (asf) {
												return !_Utils_eq(asf.d, factorId);
											},
											i.T);
										var updated = (qty > 0) ? _Utils_ap(
											existing,
											_List_fromArray(
												[
													{d: factorId, o: qty}
												])) : existing;
										return _Utils_update(
											i,
											{T: updated});
									} else {
										return i;
									}
								},
								model.j)
						}),
					$elm$core$Platform$Cmd$none);
			case 4:
				var iid = msg.a;
				var choiceId = msg.b;
				var value = msg.c;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							j: A2(
								$elm$core$List$map,
								function (i) {
									return _Utils_eq(i.bg, iid) ? _Utils_update(
										i,
										{
											ay: A3($elm$core$Dict$insert, choiceId, value, i.ay)
										}) : i;
								},
								model.j)
						}),
					$elm$core$Platform$Cmd$none);
			case 5:
				var factorId = msg.a;
				var alreadyApplied = A2(
					$elm$core$List$any,
					function (af) {
						return _Utils_eq(af.d, factorId);
					},
					model.k);
				return alreadyApplied ? _Utils_Tuple2(model, $elm$core$Platform$Cmd$none) : _Utils_Tuple2(
					_Utils_update(
						model,
						{
							k: _Utils_ap(
								model.k,
								_List_fromArray(
									[
										{d: factorId, o: 1}
									]))
						}),
					$elm$core$Platform$Cmd$none);
			case 6:
				var factorId = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							k: A2(
								$elm$core$List$filter,
								function (af) {
									return !_Utils_eq(af.d, factorId);
								},
								model.k),
							G: (factorId === 12) ? $elm$core$Maybe$Nothing : model.G,
							I: (factorId === 11) ? $elm$core$Maybe$Nothing : model.I
						}),
					$elm$core$Platform$Cmd$none);
			case 11:
				var shape = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							I: $elm$core$Maybe$Just(shape)
						}),
					$elm$core$Platform$Cmd$none);
			case 12:
				var shape = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							G: $elm$core$Maybe$Just(shape)
						}),
					$elm$core$Platform$Cmd$none);
			case 13:
				var iid = msg.a;
				var raw = msg.b;
				var parsed = $elm$core$String$isEmpty(raw) ? $elm$core$Maybe$Nothing : $elm$core$String$toInt(raw);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							j: A2(
								$elm$core$List$map,
								function (i) {
									return _Utils_eq(i.bg, iid) ? _Utils_update(
										i,
										{a1: parsed}) : i;
								},
								model.j)
						}),
					$elm$core$Platform$Cmd$none);
			case 7:
				var factorId = msg.a;
				var qty = msg.b;
				return (qty <= 0) ? _Utils_Tuple2(
					_Utils_update(
						model,
						{
							k: A2(
								$elm$core$List$filter,
								function (af) {
									return !_Utils_eq(af.d, factorId);
								},
								model.k)
						}),
					$elm$core$Platform$Cmd$none) : _Utils_Tuple2(
					_Utils_update(
						model,
						{
							k: A2(
								$elm$core$List$map,
								function (af) {
									return _Utils_eq(af.d, factorId) ? _Utils_update(
										af,
										{o: qty}) : af;
								},
								model.k)
						}),
					$elm$core$Platform$Cmd$none);
			case 14:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{al: !model.al}),
					$elm$core$Platform$Cmd$none);
			case 15:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ab: !model.ab}),
					$elm$core$Platform$Cmd$none);
			case 16:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{at: !model.at}),
					$elm$core$Platform$Cmd$none);
			case 17:
				var fmt = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aa: fmt}),
					$elm$core$Platform$Cmd$none);
			case 18:
				var generate = function () {
					var _v2 = model.aa;
					if (!_v2) {
						return $author$project$Export$generateMarkdown;
					} else {
						return $author$project$Export$generatePlainText;
					}
				}();
				var output = A7(generate, model.ap, model.j, model.k, 0, model.t, model.I, model.G);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{X: $elm$core$Maybe$Nothing}),
					$author$project$Main$copyToClipboard(output));
			default:
				var success = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							X: $elm$core$Maybe$Just(success)
						}),
					$elm$core$Platform$Cmd$none);
		}
	});
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$html$Html$div = _VirtualDom_node('div');
var $author$project$Types$ToggleFactorsPanel = {$: 15};
var $elm$html$Html$button = _VirtualDom_node('button');
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 0, a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$html$Html$span = _VirtualDom_node('span');
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $elm$html$Html$Attributes$title = $elm$html$Html$Attributes$stringProperty('title');
var $author$project$Types$SetPersonalToAreaShape = function (a) {
	return {$: 12, a: a};
};
var $author$project$Types$SetTargetToAreaShape = function (a) {
	return {$: 11, a: a};
};
var $elm$html$Html$label = _VirtualDom_node('label');
var $elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var $elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 1, a: a};
};
var $elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$json$Json$Decode$string = _Json_decodeString;
var $elm$html$Html$Events$targetValue = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	$elm$json$Json$Decode$string);
var $elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		$elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			$elm$json$Json$Decode$map,
			$elm$html$Html$Events$alwaysStop,
			A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue)));
};
var $elm$html$Html$option = _VirtualDom_node('option');
var $elm$html$Html$select = _VirtualDom_node('select');
var $elm$json$Json$Encode$bool = _Json_wrap;
var $elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$bool(bool));
	});
var $elm$html$Html$Attributes$selected = $elm$html$Html$Attributes$boolProperty('selected');
var $author$project$Calc$targetToAreaShapes = _List_fromArray(
	['Bolt (5 ft. × 300 ft.)', 'Bolt (10 ft. × 150 ft.)', 'Cylinder', '40-ft. cone', 'Four 10-ft. cubes', '20-ft. radius']);
var $elm$html$Html$Attributes$value = $elm$html$Html$Attributes$stringProperty('value');
var $author$project$View$FactorsPanel$viewAreaShapeDropdown = F2(
	function (maybeShape, toMsg) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center justify-between py-1 gap-2 pl-4')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$label,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs text-gray-400 shrink-0')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Area shape')
						])),
					A2(
					$elm$html$Html$select,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex-1 bg-gray-800 text-gray-200 text-xs rounded px-2 py-1 border border-gray-700'),
							$elm$html$Html$Events$onInput(toMsg)
						]),
					A2(
						$elm$core$List$cons,
						A2(
							$elm$html$Html$option,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$value(''),
									$elm$html$Html$Attributes$selected(
									_Utils_eq(maybeShape, $elm$core$Maybe$Nothing))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('— select —')
								])),
						A2(
							$elm$core$List$map,
							function (shape) {
								return A2(
									$elm$html$Html$option,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$value(shape),
											$elm$html$Html$Attributes$selected(
											_Utils_eq(
												maybeShape,
												$elm$core$Maybe$Just(shape)))
										]),
									_List_fromArray(
										[
											$elm$html$Html$text(shape)
										]));
							},
							$author$project$Calc$targetToAreaShapes)))
				]));
	});
var $author$project$Types$AddGlobalFactor = function (a) {
	return {$: 5, a: a};
};
var $author$project$Types$RemoveGlobalFactor = function (a) {
	return {$: 6, a: a};
};
var $author$project$Types$SetGlobalFactorQty = F2(
	function (a, b) {
		return {$: 7, a: a, b: b};
	});
var $elm$html$Html$Attributes$checked = $elm$html$Html$Attributes$boolProperty('checked');
var $elm$html$Html$Attributes$disabled = $elm$html$Html$Attributes$boolProperty('disabled');
var $elm$html$Html$input = _VirtualDom_node('input');
var $elm$html$Html$Attributes$type_ = $elm$html$Html$Attributes$stringProperty('type');
var $author$project$View$FactorsPanel$viewGlobalFactorRow = F2(
	function (factor, maybeApplied) {
		var qty = A2(
			$elm$core$Maybe$withDefault,
			0,
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.o;
				},
				maybeApplied));
		var isActive = !_Utils_eq(maybeApplied, $elm$core$Maybe$Nothing);
		var dimClass = isActive ? '' : ' opacity-40';
		var dcDisplay = function () {
			var _v1 = factor.bh;
			switch (_v1) {
				case 0:
					return (factor.Y > 0) ? ('+' + ($elm$core$String$fromInt(factor.Y) + ' DC')) : ($elm$core$String$fromInt(factor.Y) + ' DC');
				case 1:
					if (!isActive) {
						return ((factor.Y > 0) ? '+' : '') + ($elm$core$String$fromInt(factor.Y) + ' DC ea.');
					} else {
						var total = factor.Y * qty;
						return ((total > 0) ? '+' : '') + ($elm$core$String$fromInt(total) + ' DC');
					}
				default:
					return '×' + $elm$core$String$fromInt(factor.bk);
			}
		}();
		var controls = function () {
			var _v0 = factor.bh;
			switch (_v0) {
				case 1:
					return A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center gap-1')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center disabled:opacity-30 disabled:cursor-not-allowed'),
										$elm$html$Html$Events$onClick(
										A2(
											$author$project$Types$SetGlobalFactorQty,
											factor.bd,
											A2($elm$core$Basics$max, 0, qty - 1))),
										$elm$html$Html$Attributes$disabled(!qty)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('−')
									])),
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-xs text-gray-300 w-4 text-center tabular-nums')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(
										$elm$core$String$fromInt(qty))
									])),
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center'),
										$elm$html$Html$Events$onClick(
										isActive ? A2($author$project$Types$SetGlobalFactorQty, factor.bd, qty + 1) : $author$project$Types$AddGlobalFactor(factor.bd))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('+')
									]))
							]));
				case 0:
					return A2(
						$elm$html$Html$input,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$type_('checkbox'),
								$elm$html$Html$Attributes$checked(isActive),
								$elm$html$Html$Events$onClick(
								isActive ? $author$project$Types$RemoveGlobalFactor(factor.bd) : $author$project$Types$AddGlobalFactor(factor.bd)),
								$elm$html$Html$Attributes$class('w-4 h-4 accent-arcane-500 cursor-pointer')
							]),
						_List_Nil);
				default:
					return A2(
						$elm$html$Html$input,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$type_('checkbox'),
								$elm$html$Html$Attributes$checked(isActive),
								$elm$html$Html$Events$onClick(
								isActive ? $author$project$Types$RemoveGlobalFactor(factor.bd) : $author$project$Types$AddGlobalFactor(factor.bd)),
								$elm$html$Html$Attributes$class('w-4 h-4 accent-arcane-500 cursor-pointer')
							]),
						_List_Nil);
			}
		}();
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center justify-between py-1 gap-2 text-sm h-10' + dimClass)
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex-1 min-w-0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-200 text-xs truncate')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(factor.q)
								])),
							A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 text-xs')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(factor.b)
								]))
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center gap-1 shrink-0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 text-xs w-16 text-right')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(dcDisplay)
								])),
							controls
						]))
				]));
	});
var $author$project$View$FactorsPanel$viewGlobalFactorSection = F3(
	function (model, label, category) {
		var categoryFactors = A2(
			$elm$core$List$filter,
			function (f) {
				return _Utils_eq(f.aw, category);
			},
			$author$project$Factors$allFactors);
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('border-b border-gray-800')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('px-4 py-2 bg-gray-900 text-xs text-gray-400 font-semibold uppercase tracking-wider')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('── Global ' + (label + ' ──'))
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('px-4 py-2')
						]),
					A2(
						$elm$core$List$concatMap,
						function (f) {
							var maybeApplied = $elm$core$List$head(
								A2(
									$elm$core$List$filter,
									function (af) {
										return _Utils_eq(af.d, f.bd);
									},
									model.k));
							var isActive = !_Utils_eq(maybeApplied, $elm$core$Maybe$Nothing);
							return A2(
								$elm$core$List$cons,
								A2($author$project$View$FactorsPanel$viewGlobalFactorRow, f, maybeApplied),
								((f.bd === 11) && isActive) ? _List_fromArray(
									[
										A2($author$project$View$FactorsPanel$viewAreaShapeDropdown, model.I, $author$project$Types$SetTargetToAreaShape)
									]) : (((f.bd === 12) && isActive) ? _List_fromArray(
									[
										A2($author$project$View$FactorsPanel$viewAreaShapeDropdown, model.G, $author$project$Types$SetPersonalToAreaShape)
									]) : _List_Nil));
						},
						categoryFactors))
				]));
	});
var $author$project$Types$RemoveSeedInstance = function (a) {
	return {$: 2, a: a};
};
var $author$project$Types$SetPrimarySeed = function (a) {
	return {$: 8, a: a};
};
var $author$project$Types$SetSeedBaseDCOverride = F2(
	function (a, b) {
		return {$: 13, a: a, b: b};
	});
var $elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $elm$html$Html$Attributes$attribute = $elm$virtual_dom$VirtualDom$attribute;
var $elm$html$Html$p = _VirtualDom_node('p');
var $author$project$Types$SetChoice = F3(
	function (a, b, c) {
		return {$: 4, a: a, b: b, c: c};
	});
var $author$project$View$FactorsPanel$viewChoiceDropdown = F2(
	function (inst, choice) {
		var current = A2(
			$elm$core$Maybe$withDefault,
			choice.a4,
			A2($elm$core$Dict$get, choice.bd, inst.ay));
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('mb-2')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$label,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs text-gray-500 mb-1 block')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(choice.L)
						])),
					A2(
					$elm$html$Html$select,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('w-full bg-gray-800 text-gray-200 text-xs rounded px-2 py-1 border border-gray-700'),
							$elm$html$Html$Events$onInput(
							A2($author$project$Types$SetChoice, inst.bg, choice.bd))
						]),
					A2(
						$elm$core$List$map,
						function (opt) {
							return A2(
								$elm$html$Html$option,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$value(opt),
										$elm$html$Html$Attributes$selected(
										_Utils_eq(current, opt))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(opt)
									]));
						},
						choice.af))
				]));
	});
var $elm$html$Html$blockquote = _VirtualDom_node('blockquote');
var $author$project$View$FactorsPanel$viewSeedDescriptionQuote = function (seed) {
	return A2(
		$elm$html$Html$blockquote,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('border-l-2 border-gray-700 pl-3 mb-3 text-gray-400 text-xs italic leading-relaxed')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(seed.aA)
			]));
};
var $author$project$Types$SetSeedFactor = F3(
	function (a, b, c) {
		return {$: 3, a: a, b: b, c: c};
	});
var $elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var $author$project$View$FactorsPanel$viewSeedFactor = F2(
	function (inst, sf) {
		var currentQty = A2(
			$elm$core$Maybe$withDefault,
			0,
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.o;
				},
				$elm$core$List$head(
					A2(
						$elm$core$List$filter,
						function (asf) {
							return _Utils_eq(asf.d, sf.bd);
						},
						inst.T))));
		var dcLabel = (!sf.Y) ? '(special)' : ((sf.Y > 0) ? ('+' + ($elm$core$String$fromInt(
			sf.Y * A2($elm$core$Basics$max, 1, currentQty)) + ' DC')) : ($elm$core$String$fromInt(
			sf.Y * A2($elm$core$Basics$max, 1, currentQty)) + ' DC'));
		var isActive = currentQty > 0;
		var dimClass = isActive ? '' : ' opacity-40';
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center justify-between py-1 gap-2 text-sm' + dimClass)
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex-1 min-w-0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-200 text-xs truncate')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(sf.q)
								])),
							$elm$core$String$isEmpty(sf.aA) ? $elm$html$Html$text('') : A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 text-xs truncate')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(sf.aA)
								]))
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center gap-1 shrink-0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 text-xs w-16 text-right')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(dcLabel)
								])),
							function () {
							var _v0 = sf.bh;
							if (!_v0) {
								return A2(
									$elm$html$Html$button,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class(
											(currentQty > 0) ? 'px-2 py-0.5 rounded text-xs bg-arcane-500 text-white' : 'px-2 py-0.5 rounded text-xs bg-gray-700 text-gray-300 hover:bg-gray-600'),
											$elm$html$Html$Events$onClick(
											A3(
												$author$project$Types$SetSeedFactor,
												inst.bg,
												sf.bd,
												(currentQty > 0) ? 0 : 1))
										]),
									_List_fromArray(
										[
											$elm$html$Html$text(
											(currentQty > 0) ? 'On' : 'Off')
										]));
							} else {
								return A2(
									$elm$html$Html$div,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('flex items-center gap-1')
										]),
									_List_fromArray(
										[
											A2(
											$elm$html$Html$button,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center'),
													$elm$html$Html$Events$onClick(
													A3(
														$author$project$Types$SetSeedFactor,
														inst.bg,
														sf.bd,
														A2($elm$core$Basics$max, 0, currentQty - 1)))
												]),
											_List_fromArray(
												[
													$elm$html$Html$text('−')
												])),
											A2(
											$elm$html$Html$span,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('text-xs text-gray-300 w-4 text-center tabular-nums')
												]),
											_List_fromArray(
												[
													$elm$html$Html$text(
													$elm$core$String$fromInt(currentQty))
												])),
											A2(
											$elm$html$Html$button,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center'),
													$elm$html$Html$Events$onClick(
													A3(
														$author$project$Types$SetSeedFactor,
														inst.bg,
														sf.bd,
														function () {
															var _v1 = sf.a;
															if (_v1.$ === 1) {
																return currentQty + 1;
															} else {
																var mx = _v1.a;
																return A2($elm$core$Basics$min, mx, currentQty + 1);
															}
														}()))
												]),
											_List_fromArray(
												[
													$elm$html$Html$text('+')
												]))
										]));
							}
						}()
						]))
				]));
	});
var $author$project$View$FactorsPanel$viewSeedInstanceFactors = F2(
	function (model, inst) {
		var _v0 = $author$project$Seeds$getSeed(inst.v);
		if (_v0.$ === 1) {
			return $elm$html$Html$text('');
		} else {
			var seed = _v0.a;
			var universalFactorRows = A2(
				$elm$core$List$map,
				$author$project$View$FactorsPanel$viewSeedFactor(inst),
				seed.bw);
			var modeFactorSections = A2(
				$elm$core$List$concatMap,
				function (m) {
					return A2(
						$elm$core$List$cons,
						A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-xs text-gray-500 font-semibold uppercase tracking-wider mt-2 mb-1 pt-2 border-t border-gray-800')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(m.q)
								])),
						A2(
							$elm$core$List$map,
							$author$project$View$FactorsPanel$viewSeedFactor(inst),
							m.a8));
				},
				A2(
					$elm$core$List$filter,
					function (m) {
						return !$elm$core$List$isEmpty(m.a8);
					},
					seed.bj));
			var factorRows = ($elm$core$List$isEmpty(universalFactorRows) && $elm$core$List$isEmpty(modeFactorSections)) ? _List_fromArray(
				[
					A2(
					$elm$html$Html$p,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-500 text-xs italic mt-1')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('No seed-specific factors')
						]))
				]) : _Utils_ap(universalFactorRows, modeFactorSections);
			var currentDC = A2($elm$core$Maybe$withDefault, seed.a0, inst.a1);
			var choiceRows = A2(
				$elm$core$List$map,
				$author$project$View$FactorsPanel$viewChoiceDropdown(inst),
				seed.ay);
			var baseDCRow = A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex items-center justify-between py-1 gap-2 text-sm h-10')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex-1 min-w-0')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-200 text-xs')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Base DC')
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-500 text-xs')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(
										'default: ' + $elm$core$String$fromInt(seed.a0))
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center gap-1 shrink-0')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center'),
										$elm$html$Html$Events$onClick(
										A2(
											$author$project$Types$SetSeedBaseDCOverride,
											inst.bg,
											$elm$core$String$fromInt(currentDC - 1)))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('−')
									])),
								A2(
								$elm$html$Html$input,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$type_('text'),
										A2($elm$html$Html$Attributes$attribute, 'inputmode', 'numeric'),
										$elm$html$Html$Attributes$value(
										$elm$core$String$fromInt(currentDC)),
										$elm$html$Html$Events$onInput(
										$author$project$Types$SetSeedBaseDCOverride(inst.bg)),
										$elm$html$Html$Attributes$class('w-10 bg-gray-800 border border-gray-600 rounded px-2 py-0.5 text-xs text-gray-100 tabular-nums text-center focus:outline-none focus:border-arcane-400')
									]),
								_List_Nil),
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center'),
										$elm$html$Html$Events$onClick(
										A2(
											$author$project$Types$SetSeedBaseDCOverride,
											inst.bg,
											$elm$core$String$fromInt(currentDC + 1)))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('+')
									]))
							]))
					]));
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('border-b border-gray-800')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center justify-between px-4 py-2 bg-gray-900')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-xs text-arcane-400 font-semibold uppercase tracking-wider')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('── ' + (seed.q + ' ──'))
									])),
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex items-center gap-2')
									]),
								_List_fromArray(
									[
										($elm$core$List$length(model.j) > 1) ? (_Utils_eq(
										model.t,
										$elm$core$Maybe$Just(inst.bg)) ? A2(
										$elm$html$Html$span,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('text-xs text-arcane-400 font-semibold px-1.5 py-0.5 rounded border border-arcane-700 bg-arcane-950')
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Primary')
											])) : A2(
										$elm$html$Html$button,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('text-xs text-gray-600 hover:text-gray-300 px-1.5 py-0.5 rounded border border-gray-800 hover:border-gray-600'),
												$elm$html$Html$Events$onClick(
												$author$project$Types$SetPrimarySeed(inst.bg))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Make primary')
											]))) : $elm$html$Html$text(''),
										A2(
										$elm$html$Html$button,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$class('text-gray-600 hover:text-red-400 text-xs'),
												$elm$html$Html$Events$onClick(
												$author$project$Types$RemoveSeedInstance(inst.bg))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('✕')
											]))
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('px-4 py-2')
							]),
						A2(
							$elm$core$List$cons,
							$author$project$View$FactorsPanel$viewSeedDescriptionQuote(seed),
							A2(
								$elm$core$List$cons,
								baseDCRow,
								_Utils_ap(choiceRows, factorRows))))
					]));
		}
	});
var $author$project$View$FactorsPanel$viewFactorsPanel = F2(
	function (model, _v0) {
		if (model.ab) {
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex-1 flex flex-col bg-gray-950 border-r border-gray-700 overflow-y-auto min-w-0')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-950 z-10')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Factors')
									])),
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-500 hover:text-gray-300 text-lg'),
										$elm$html$Html$Events$onClick($author$project$Types$ToggleFactorsPanel),
										$elm$html$Html$Attributes$title('Collapse panel')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('◀')
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						A2(
							$elm$core$List$map,
							$author$project$View$FactorsPanel$viewSeedInstanceFactors(model),
							model.j)),
						A3($author$project$View$FactorsPanel$viewGlobalFactorSection, model, 'Augmenting', 0),
						A3($author$project$View$FactorsPanel$viewGlobalFactorSection, model, 'Mitigating', 1)
					]));
		} else {
			var totalFactors = $elm$core$List$length(model.k) + $elm$core$List$sum(
				A2(
					$elm$core$List$map,
					function (i) {
						return $elm$core$List$length(i.T);
					},
					model.j));
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('w-8 shrink-0 flex flex-col items-center bg-gray-950 border-r border-gray-700 cursor-pointer hover:bg-gray-900'),
						$elm$html$Html$Events$onClick($author$project$Types$ToggleFactorsPanel),
						$elm$html$Html$Attributes$title('Expand factors panel')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(
								'FACTORS (' + ($elm$core$String$fromInt(totalFactors) + ')'))
							]))
					]));
		}
	});
var $author$project$Types$SetSpellName = function (a) {
	return {$: 0, a: a};
};
var $elm$html$Html$Attributes$placeholder = $elm$html$Html$Attributes$stringProperty('placeholder');
var $author$project$View$Header$viewHeader = F2(
	function (model, breakdown) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex items-center justify-between px-6 py-3 bg-gray-900 border-b border-gray-700 shrink-0')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$input,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('bg-transparent text-2xl font-bold text-gray-100 outline-none placeholder-gray-600 w-96'),
							$elm$html$Html$Attributes$placeholder('Unnamed Spell'),
							$elm$html$Html$Attributes$value(model.ap),
							$elm$html$Html$Events$onInput($author$project$Types$SetSpellName)
						]),
					_List_Nil),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center gap-3')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-400 text-sm uppercase tracking-widest')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Spellcraft DC')
								])),
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-arcane-400 text-4xl font-bold tabular-nums')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(
									$elm$core$String$fromInt(breakdown.a9))
								]))
						]))
				]));
	});
var $author$project$Types$ToggleSeedsPanel = {$: 14};
var $author$project$Types$AddSeedInstance = function (a) {
	return {$: 1, a: a};
};
var $author$project$View$SeedsPanel$viewSeedCard = F2(
	function (instances, seed) {
		var count = $elm$core$List$length(
			A2(
				$elm$core$List$filter,
				function (i) {
					return _Utils_eq(i.v, seed.bd);
				},
				instances));
		var activeClass = (count > 0) ? 'bg-arcane-900 border-arcane-500 text-arcane-400' : 'bg-gray-800 border-gray-700 text-gray-300 hover:border-gray-500';
		return A2(
			$elm$html$Html$button,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('w-full flex justify-between items-center px-3 py-2 rounded border text-sm ' + activeClass),
					$elm$html$Html$Events$onClick(
					$author$project$Types$AddSeedInstance(seed.bd)),
					$elm$html$Html$Attributes$title(seed.aA)
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$span,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text(seed.q)
						])),
					A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs text-gray-500 tabular-nums')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(
							$elm$core$String$fromInt(seed.a0)),
							(count > 0) ? A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('ml-1 text-arcane-400')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(
									'×' + $elm$core$String$fromInt(count))
								])) : $elm$html$Html$text('')
						]))
				]));
	});
var $author$project$View$SeedsPanel$viewSeedsPanel = function (model) {
	return model.al ? A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('w-72 shrink-0 flex flex-col bg-gray-900 border-r border-gray-700 overflow-y-auto')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-900 z-10')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$span,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Seeds')
							])),
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('text-gray-500 hover:text-gray-300 text-lg'),
								$elm$html$Html$Events$onClick($author$project$Types$ToggleSeedsPanel),
								$elm$html$Html$Attributes$title('Collapse panel')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('◀')
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('px-4 py-3 text-gray-500 text-xs text-center border-b border-gray-800')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Click/Tap to add a seed to your spell')
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('p-3 grid grid-cols-1 gap-1')
					]),
				A2(
					$elm$core$List$map,
					$author$project$View$SeedsPanel$viewSeedCard(model.j),
					$author$project$Seeds$allSeeds))
			])) : A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('w-8 shrink-0 flex flex-col items-center bg-gray-900 border-r border-gray-700 cursor-pointer hover:bg-gray-800'),
				$elm$html$Html$Events$onClick($author$project$Types$ToggleSeedsPanel),
				$elm$html$Html$Attributes$title('Expand seeds panel')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						'SEEDS (' + ($elm$core$String$fromInt(
							$elm$core$List$length(model.j)) + ')'))
					]))
			]));
};
var $author$project$Types$ToggleSummaryPanel = {$: 16};
var $author$project$Types$CopySpellSummary = {$: 18};
var $author$project$Types$PlainTextExport = 1;
var $author$project$Types$SetExportFormat = function (a) {
	return {$: 17, a: a};
};
var $author$project$View$SummaryPanel$formatButton = F3(
	function (model, fmt, label) {
		return A2(
			$elm$html$Html$button,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					'flex-1 py-1.5 text-xs font-semibold ' + (_Utils_eq(model.aa, fmt) ? 'bg-arcane-500 text-white' : 'bg-gray-800 text-gray-400 hover:bg-gray-700')),
					$elm$html$Html$Events$onClick(
					$author$project$Types$SetExportFormat(fmt))
				]),
			_List_fromArray(
				[
					$elm$html$Html$text(label)
				]));
	});
var $author$project$View$SummaryPanel$viewCopyFooter = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('shrink-0 border-t border-gray-700 bg-gray-900 p-4 space-y-2')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex rounded overflow-hidden border border-gray-700')
					]),
				_List_fromArray(
					[
						A3($author$project$View$SummaryPanel$formatButton, model, 0, 'Markdown'),
						A3($author$project$View$SummaryPanel$formatButton, model, 1, 'Plain Text')
					])),
				A2(
				$elm$html$Html$button,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold'),
						$elm$html$Html$Events$onClick($author$project$Types$CopySpellSummary)
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Copy Spell Summary')
					])),
				function () {
				var _v0 = model.X;
				if (!_v0.$) {
					if (_v0.a) {
						return A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-green-400 text-xs text-center')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Copied to clipboard!')
								]));
					} else {
						return A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-red-400 text-xs text-center')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Copy failed — check browser permissions.')
								]));
					}
				} else {
					return $elm$html$Html$text('');
				}
			}()
			]));
};
var $author$project$View$SummaryPanel$showSign = function (n) {
	return (n >= 0) ? ('+' + $elm$core$String$fromInt(n)) : $elm$core$String$fromInt(n);
};
var $author$project$View$SummaryPanel$viewBreakdownRow = F3(
	function (label, val, colorClass) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex justify-between')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-500 text-xs')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(label)
						])),
					A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs tabular-nums ' + colorClass)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(val)
						]))
				]));
	});
var $author$project$View$SummaryPanel$viewDcBreakdown = function (bd) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('DC Breakdown')
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('space-y-1 text-sm')
					]),
				_List_fromArray(
					[
						A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'Seeds',
						$author$project$View$SummaryPanel$showSign(bd.br),
						'text-gray-300'),
						A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'Seed factors',
						$author$project$View$SummaryPanel$showSign(bd.bq),
						'text-gray-300'),
						A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'Augmenting',
						$author$project$View$SummaryPanel$showSign(bd.a$),
						'text-gray-300'),
						(bd.bo > 1) ? A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'× Permanent',
						'×' + $elm$core$String$fromInt(bd.bo),
						'text-yellow-400') : $elm$html$Html$text(''),
						(bd.bs > 1) ? A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'× Stone Tablet',
						'×' + $elm$core$String$fromInt(bd.bs),
						'text-yellow-400') : $elm$html$Html$text(''),
						A3(
						$author$project$View$SummaryPanel$viewBreakdownRow,
						'Mitigating',
						$author$project$View$SummaryPanel$showSign(bd.bi),
						'text-green-400'),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('border-t border-gray-700 pt-1 mt-1 flex justify-between')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-400 text-xs uppercase')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Final DC')
									])),
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-arcane-400 text-lg font-bold tabular-nums')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(
										$elm$core$String$fromInt(bd.a9))
									]))
							]))
					]))
			]));
};
var $author$project$View$SummaryPanel$formatNumber = function (n) {
	var str = $elm$core$String$fromInt(n);
	var len = $elm$core$String$length(str);
	return (len <= 3) ? str : ($author$project$View$SummaryPanel$formatNumber((n / 1000) | 0) + (',' + A3(
		$elm$core$String$padLeft,
		3,
		'0',
		$elm$core$String$fromInt(
			A2($elm$core$Basics$modBy, 1000, n)))));
};
var $author$project$View$SummaryPanel$viewCostRow = F2(
	function (label, val) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('flex justify-between text-sm')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-500 text-xs')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(label)
						])),
					A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-200 text-xs tabular-nums')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(val)
						]))
				]));
	});
var $author$project$View$SummaryPanel$viewDevCosts = function (costs) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Development')
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('space-y-1')
					]),
				_List_fromArray(
					[
						A2(
						$author$project$View$SummaryPanel$viewCostRow,
						'Gold',
						$author$project$View$SummaryPanel$formatNumber(costs.ba) + ' gp'),
						A2(
						$author$project$View$SummaryPanel$viewCostRow,
						'Time',
						$elm$core$String$fromInt(costs.bu) + ' days'),
						A2(
						$author$project$View$SummaryPanel$viewCostRow,
						'XP',
						$author$project$View$SummaryPanel$formatNumber(costs.bA) + ' XP')
					]))
			]));
};
var $author$project$View$SummaryPanel$viewGlobalFactorList = F3(
	function (model, label, category) {
		var lines = A2(
			$elm$core$List$filterMap,
			function (af) {
				return A2(
					$elm$core$Maybe$map,
					function (f) {
						return _Utils_ap(
							f.q,
							_Utils_ap(
								(af.o > 1) ? (' ×' + $elm$core$String$fromInt(af.o)) : '',
								(f.bh === 2) ? (' (×' + ($elm$core$String$fromInt(f.bk) + ')')) : (' (' + ($author$project$View$SummaryPanel$showSign(f.Y * af.o) + ')'))));
					},
					$elm$core$List$head(
						A2(
							$elm$core$List$filter,
							function (f) {
								return _Utils_eq(f.bd, af.d) && _Utils_eq(f.aw, category);
							},
							$author$project$Factors$allFactors)));
			},
			model.k);
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(label)
						])),
					$elm$core$List$isEmpty(lines) ? A2(
					$elm$html$Html$p,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-500 text-xs italic')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('None active')
						])) : A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('space-y-1')
						]),
					A2(
						$elm$core$List$map,
						function (l) {
							return A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-200 text-xs')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(l)
									]));
						},
						lines))
				]));
	});
var $author$project$View$SummaryPanel$viewSeedFactorsBySeed = function (model) {
	var blocks = A2(
		$elm$core$List$sortBy,
		$elm$core$Tuple$first,
		A3(
			$elm$core$List$foldl,
			F2(
				function (inst, _v1) {
					var seenCounts = _v1.a;
					var acc = _v1.b;
					var _v2 = $author$project$Seeds$getSeed(inst.v);
					if (_v2.$ === 1) {
						return _Utils_Tuple2(seenCounts, acc);
					} else {
						var seed = _v2.a;
						var priorCount = A2(
							$elm$core$Maybe$withDefault,
							0,
							A2($elm$core$Dict$get, seed.q, seenCounts));
						var overrideLines = function () {
							var _v3 = inst.a1;
							if (!_v3.$) {
								var dc = _v3.a;
								return (!_Utils_eq(dc, seed.a0)) ? _List_fromArray(
									[
										'Base DC override: ' + $elm$core$String$fromInt(dc)
									]) : _List_Nil;
							} else {
								return _List_Nil;
							}
						}();
						var label = (!priorCount) ? seed.q : (seed.q + (' (' + ($elm$core$String$fromInt(priorCount + 1) + ')')));
						var choiceLines = A2(
							$elm$core$List$map,
							function (c) {
								return c.L + (': ' + A2(
									$elm$core$Maybe$withDefault,
									c.a4,
									A2($elm$core$Dict$get, c.bd, inst.ay)));
							},
							seed.ay);
						var availableFactors = _Utils_ap(
							seed.bw,
							A2(
								$elm$core$List$concatMap,
								function ($) {
									return $.a8;
								},
								seed.bj));
						var factorLines = A2(
							$elm$core$List$filterMap,
							function (asf) {
								return A2(
									$elm$core$Maybe$map,
									function (sf) {
										return _Utils_ap(
											sf.q,
											_Utils_ap(
												(asf.o > 1) ? (' ×' + $elm$core$String$fromInt(asf.o)) : '',
												(!sf.Y) ? ' (special)' : (' (' + ($author$project$View$SummaryPanel$showSign(sf.Y * asf.o) + ')'))));
									},
									$elm$core$List$head(
										A2(
											$elm$core$List$filter,
											function (sf) {
												return _Utils_eq(sf.bd, asf.d);
											},
											availableFactors)));
							},
							A2(
								$elm$core$List$filter,
								function (asf) {
									return asf.o > 0;
								},
								inst.T));
						var lines = _Utils_ap(
							choiceLines,
							_Utils_ap(overrideLines, factorLines));
						return $elm$core$List$isEmpty(lines) ? _Utils_Tuple2(
							A3($elm$core$Dict$insert, seed.q, priorCount + 1, seenCounts),
							acc) : _Utils_Tuple2(
							A3($elm$core$Dict$insert, seed.q, priorCount + 1, seenCounts),
							_Utils_ap(
								acc,
								_List_fromArray(
									[
										_Utils_Tuple2(label, lines)
									])));
					}
				}),
			_Utils_Tuple2($elm$core$Dict$empty, _List_Nil),
			model.j).b);
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Seed Factors')
					])),
				$elm$core$List$isEmpty(blocks) ? A2(
				$elm$html$Html$p,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-gray-500 text-xs italic')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('No seed-specific factors active')
					])) : A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('space-y-2')
					]),
				A2(
					$elm$core$List$map,
					function (_v0) {
						var label = _v0.a;
						var lines = _v0.b;
						return A2(
							$elm$html$Html$div,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									$elm$html$Html$div,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('text-arcane-400 text-xs font-semibold mb-1')
										]),
									_List_fromArray(
										[
											$elm$html$Html$text(label)
										])),
									A2(
									$elm$html$Html$div,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('space-y-0.5')
										]),
									A2(
										$elm$core$List$map,
										function (l) {
											return A2(
												$elm$html$Html$div,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$class('text-gray-200 text-xs')
													]),
												_List_fromArray(
													[
														$elm$html$Html$text(l)
													]));
										},
										lines))
								]));
					},
					blocks))
			]));
};
var $author$project$View$SummaryPanel$resolvePrimaryInstanceId = function (model) {
	var _v0 = model.t;
	if (!_v0.$) {
		var pid = _v0.a;
		return A2(
			$elm$core$List$any,
			function (i) {
				return _Utils_eq(i.bg, pid);
			},
			model.j) ? $elm$core$Maybe$Just(pid) : A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.bg;
			},
			$elm$core$List$head(model.j));
	} else {
		return A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.bg;
			},
			$elm$core$List$head(model.j));
	}
};
var $author$project$View$SummaryPanel$viewSeedsUsed = function (model) {
	var showPrimaryTag = $elm$core$List$length(model.j) > 1;
	var primaryId = $author$project$View$SummaryPanel$resolvePrimaryInstanceId(model);
	var names = A2(
		$elm$core$List$filterMap,
		function (inst) {
			return A2(
				$elm$core$Maybe$map,
				function (s) {
					return s.q + (' (' + ($elm$core$String$fromInt(
						A2($elm$core$Maybe$withDefault, s.a0, inst.a1)) + (')' + ((showPrimaryTag && _Utils_eq(
						primaryId,
						$elm$core$Maybe$Just(inst.bg))) ? ' [Primary]' : ''))));
				},
				$author$project$Seeds$getSeed(inst.v));
		},
		model.j);
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Seeds Used')
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('text-xs text-gray-200')
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						$elm$core$List$isEmpty(names) ? 'None' : A2($elm$core$String$join, ', ', names))
					]))
			]));
};
var $author$project$View$SummaryPanel$viewSpellName = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('text-sm font-semibold text-gray-200 truncate')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(
				$elm$core$String$isEmpty(model.ap) ? 'Unnamed Spell' : model.ap)
			]));
};
var $author$project$Types$SetSavingThrow = function (a) {
	return {$: 10, a: a};
};
var $author$project$Types$SetSchool = function (a) {
	return {$: 9, a: a};
};
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			$elm$core$List$any,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, isOkay),
			list);
	});
var $author$project$View$SummaryPanel$saveTypeLabel = function (st) {
	switch (st) {
		case 0:
			return 'Will';
		case 1:
			return 'Reflex';
		default:
			return 'Fortitude';
	}
};
var $author$project$View$SummaryPanel$viewStatBlock = F3(
	function (model, breakdown, sb) {
		var schools = $author$project$Calc$availableSchools(model.j);
		var rowEl = F2(
			function (label, el) {
				return A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex gap-2 text-xs items-start')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 w-24 shrink-0')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(label)
								])),
							el
						]));
			});
		var row = F2(
			function (label, val) {
				return A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex gap-2 text-xs')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 w-24 shrink-0')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(label)
								])),
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-200')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(val)
								]))
						]));
			});
		var descriptorStr = $elm$core$List$isEmpty(sb.Z) ? '' : (' [' + (A2($elm$core$String$join, ', ', sb.Z) + ']'));
		var schoolEl = function () {
			if (!schools.b) {
				return A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-200')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('—')
						]));
			} else {
				if (!schools.b.b) {
					var single = schools.a;
					return A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-200')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(single)
									])),
								$elm$core$List$isEmpty(sb.Z) ? $elm$html$Html$text('') : A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-400 mt-1')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(descriptorStr)
									]))
							]));
				} else {
					var activeSchool = A2(
						$elm$core$Maybe$withDefault,
						A2(
							$elm$core$Maybe$withDefault,
							'',
							$elm$core$List$head(schools)),
						model.an);
					return A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('flex flex-wrap gap-1')
									]),
								A2(
									$elm$core$List$map,
									function (s) {
										return A2(
											$elm$html$Html$button,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$class(
													_Utils_eq(s, activeSchool) ? 'text-xs px-2 py-0.5 rounded bg-indigo-600 text-white' : 'text-xs px-2 py-0.5 rounded bg-gray-700 text-gray-500 hover:text-gray-300 hover:bg-gray-600'),
													$elm$html$Html$Events$onClick(
													$author$project$Types$SetSchool(s))
												]),
											_List_fromArray(
												[
													$elm$html$Html$text(s)
												]));
									},
									schools)),
								$elm$core$List$isEmpty(sb.Z) ? $elm$html$Html$text('') : A2(
								$elm$html$Html$div,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-400 mt-1')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(descriptorStr)
									]))
							]));
				}
			}
		}();
		var availableSaves = $author$project$Calc$availableSavingThrows(model.j);
		var savingThrowEl = function () {
			if (!availableSaves.b) {
				return A2(
					$elm$html$Html$span,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-gray-200')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('None')
						]));
			} else {
				if (!availableSaves.b.b) {
					return A2(
						$elm$html$Html$span,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('text-gray-200')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(sb.aj)
							]));
				} else {
					var harmlessStr = A2(
						$elm$core$List$all,
						function ($) {
							return $.bb;
						},
						availableSaves) ? ' (harmless)' : '';
					var effects = A2(
						$elm$core$List$map,
						function ($) {
							return $.S;
						},
						availableSaves);
					var effectStr = function () {
						var _v1 = $elm$core$List$head(effects);
						if (_v1.$ === 1) {
							return '';
						} else {
							var first = _v1.a;
							if (A2(
								$elm$core$List$all,
								function (e) {
									return _Utils_eq(e, first);
								},
								effects)) {
								switch (first) {
									case 0:
										return 'negates';
									case 1:
										return 'half';
									case 2:
										return 'partial';
									default:
										return '(see text)';
								}
							} else {
								return '(see text)';
							}
						}
					}();
					var currentTypeStr = A2(
						$elm$core$Maybe$withDefault,
						A2(
							$elm$core$Maybe$withDefault,
							'',
							A2(
								$elm$core$Maybe$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.ai;
									},
									$author$project$View$SummaryPanel$saveTypeLabel),
								$elm$core$List$head(availableSaves))),
						A2(
							$elm$core$Maybe$map,
							A2(
								$elm$core$Basics$composeR,
								function ($) {
									return $.ai;
								},
								$author$project$View$SummaryPanel$saveTypeLabel),
							model.am));
					return A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('flex flex-wrap items-center gap-1')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$select,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('bg-gray-800 text-gray-200 text-xs rounded px-1 py-0.5'),
										$elm$html$Html$Events$onInput(
										function (typeStr) {
											return $author$project$Types$SetSavingThrow(
												$elm$core$List$head(
													A2(
														$elm$core$List$filter,
														function (st) {
															return _Utils_eq(
																$author$project$View$SummaryPanel$saveTypeLabel(st.ai),
																typeStr);
														},
														availableSaves)));
										}),
										$elm$html$Html$Attributes$value(currentTypeStr)
									]),
								A2(
									$elm$core$List$map,
									function (st) {
										var label = $author$project$View$SummaryPanel$saveTypeLabel(st.ai);
										return A2(
											$elm$html$Html$option,
											_List_fromArray(
												[
													$elm$html$Html$Attributes$value(label),
													$elm$html$Html$Attributes$selected(
													_Utils_eq(currentTypeStr, label))
												]),
											_List_fromArray(
												[
													$elm$html$Html$text(label)
												]));
									},
									availableSaves)),
								A2(
								$elm$html$Html$span,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class('text-gray-200')
									]),
								_List_fromArray(
									[
										$elm$html$Html$text(
										_Utils_ap(effectStr, harmlessStr))
									]))
							]));
				}
			}
		}();
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400 mb-2')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Stat Block')
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('space-y-1')
						]),
					_Utils_ap(
						_List_fromArray(
							[
								A2(
								rowEl,
								($elm$core$List$length(schools) > 1) ? 'School (pick)' : 'School',
								schoolEl),
								A2(
								row,
								'Spellcraft DC',
								$elm$core$String$fromInt(breakdown.a9)),
								A2(
								row,
								'Components',
								A2($elm$core$String$join, ', ', sb.W)),
								A2(row, 'Casting Time', sb.V),
								A2(row, 'Range', sb.ah)
							]),
						_Utils_ap(
							A2(
								$elm$core$List$filterMap,
								$elm$core$Basics$identity,
								_List_fromArray(
									[
										A2(
										$elm$core$Maybe$map,
										row('Target'),
										sb.au),
										A2(
										$elm$core$Maybe$map,
										row('Area'),
										sb.U),
										A2(
										$elm$core$Maybe$map,
										row('Effect'),
										sb.S)
									])),
							_List_fromArray(
								[
									A2(row, 'Duration', sb._),
									A2(rowEl, 'Saving Throw', savingThrowEl),
									A2(row, 'Spell Resistance', sb.aq)
								]))))
				]));
	});
var $author$project$View$SummaryPanel$viewSummaryPanel = F4(
	function (model, breakdown, costs, sb) {
		return model.at ? A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('w-96 shrink-0 flex flex-col bg-gray-900 overflow-hidden')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex items-center justify-between px-4 py-3 border-b border-gray-700 shrink-0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-xs font-bold uppercase tracking-widest text-gray-400')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Summary')
								])),
							A2(
							$elm$html$Html$button,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('text-gray-500 hover:text-gray-300 text-lg'),
									$elm$html$Html$Events$onClick($author$project$Types$ToggleSummaryPanel),
									$elm$html$Html$Attributes$title('Collapse panel')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('▶')
								]))
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('flex-1 overflow-y-auto p-4 space-y-5')
						]),
					_List_fromArray(
						[
							$author$project$View$SummaryPanel$viewSpellName(model),
							A3($author$project$View$SummaryPanel$viewStatBlock, model, breakdown, sb),
							$author$project$View$SummaryPanel$viewSeedsUsed(model),
							$author$project$View$SummaryPanel$viewDcBreakdown(breakdown),
							$author$project$View$SummaryPanel$viewDevCosts(costs),
							$author$project$View$SummaryPanel$viewSeedFactorsBySeed(model),
							A3($author$project$View$SummaryPanel$viewGlobalFactorList, model, 'Global Augments', 0),
							A3($author$project$View$SummaryPanel$viewGlobalFactorList, model, 'Global Mitigations', 1)
						])),
					$author$project$View$SummaryPanel$viewCopyFooter(model)
				])) : A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('w-8 shrink-0 flex flex-col items-center bg-gray-900 cursor-pointer hover:bg-gray-800'),
					$elm$html$Html$Events$onClick($author$project$Types$ToggleSummaryPanel),
					$elm$html$Html$Attributes$title('Expand summary panel')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('SUMMARY')
						]))
				]));
	});
var $author$project$Main$view = function (model) {
	var sb = A8($author$project$Calc$statBlock, model.j, model.k, 0, model.t, model.an, model.am, model.I, model.G);
	var breakdown = A2($author$project$Calc$calculateBreakdown, model.j, model.k);
	var costs = $author$project$Calc$devCosts(breakdown.a9);
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('flex flex-col h-screen bg-gray-950 text-gray-100 overflow-hidden')
			]),
		_List_fromArray(
			[
				A2($author$project$View$Header$viewHeader, model, breakdown),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('flex flex-1 overflow-hidden')
					]),
				_List_fromArray(
					[
						$author$project$View$SeedsPanel$viewSeedsPanel(model),
						A2($author$project$View$FactorsPanel$viewFactorsPanel, model, breakdown),
						A4($author$project$View$SummaryPanel$viewSummaryPanel, model, breakdown, costs, sb)
					]))
			]));
};
var $author$project$Main$main = $elm$browser$Browser$element(
	{
		bf: function (_v0) {
			return _Utils_Tuple2($author$project$Main$init, $elm$core$Platform$Cmd$none);
		},
		bt: function (_v1) {
			return $author$project$Main$copyResult($author$project$Types$CopyResult);
		},
		bx: $author$project$Main$update,
		by: $author$project$Main$view
	});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(0))(0)}});}(this));