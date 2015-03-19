/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var l=window.location;

function setCaptchaCookie(key, val) {
	var tmp = key + "=" + escape(val) + "; ";
	// tmp += "path=" + location.pathname + "; ";
	// tmp += "expires=Tue, 31-Dec-2030 23:59:59; ";
	d.cookie = tmp;
}

function getrand() {
	return ~~(Math.random()*10000000);
}

function reload_captcha (cookieid, id) {
	var crand = getrand();
	crand = MD5_hexhash(crand);
	crand = crand + d.cookie + navigator.userAgent + getrand();
	crand = MD5_hexhash(crand);
	var now = new Date();
	crand += now.getFullYear() + now.getMonth() + now.getDate()
		  +  now.getHours() +  now.getMinutes() + now.getSeconds()
		  + l.host + l.hostname + l.pathname
		  + d.referrer + d.domain
		  + s.width + s.height + s.colorDepth
	crand = penc(MD5_hexhash(crand), cs);
	if(cookieid == "" || id == "") {
		return false;
	}
	gid(id).innerHTML='<img src=\"?cmd=captcha&amp;mode=image&amp;teststring=' + crand + '\" />';
	setCaptchaCookie(cookieid, crand);
	for(var i=0; i < d.forms.length; i++) {
		if(d.forms[i].captcha_check && d.forms[i].captcha) {
			d.forms[i].captcha_check.value=crand;
		}
	}
	return false;
}



function penc(str, enc_list) {
	var i, dd, res,dif;
	res=h;
	for (i = 0; i < str.length; i++) {
		dif = (~~( Math.random() * 127 ) + i) % 127;
		res = res + enc_list.substr(dif / 0x10,1) + enc_list.substr(dif % 0x10, 1);
		dd = str.charCodeAt(i) + dif;
		res = res + enc_list.substr(dd / 0x10,1) + enc_list.substr(dd % 0x10, 1);
	}
	return res;
}






jQuery.KLIMIT = jQuery.KLIMIT || {};
jQuery.KLIMIT.KEY_CODE_MAP = [
	{ c: '"',  k: [{ code: 0x32, shift: true }] },
	{ c: '&',  k: [{ code: 0x36, shift: true }] },
	{ c: "'",  k: [{ code: 0x37, shift: true }] },
	{ c: '(',  k: [{ code: 0x38, shift: true }] },
	{ c: ')',  k: [{ code: 0x39, shift: true }] },
	{ c: ':',  k: [{ code: 0xBA }, { code: 0x3B }] },
	{ c: '*',  k: [{ code: 0xBA, shift: true }, { code: 0x3B, shift: true }, { code: 0x6A }] },
	{ c: ';',  k: [{ code: 0xBB }, { code: 0x6B }] },
	{ c: '=',  k: [{ code: 0xBD, shift: true }, { code: 0x6D, shift: true }] },
	{ c: '@',  k: [{ code: 0xC0 }] },
	{ c: '`',  k: [{ code: 0xC0, shift: true }] },
	{ c: '\\', k: [{ code: 0xDC }, { code: 0xE2 }] },
	{ c: '^',  k: [{ code: 0xDE }] },
	{ c: '~',  k: [{ code: 0xDE, shift: true }] },
	{ c: '_',  k: [{ code: 0xE2, shift: true }] }
];




(function($) {

	// The following functions/variables are private.
	var key_code_map = [],
		key_bypassed = [
		0x08,	// Back space
		0x09,	// Tab
		0x0D,	// Enter
		0x21,	// Page up
		0x22,	// Page down
		0x23,	// End
		0x24,	// Home
		0x25,	// Left
		0x26,	// Up
		0x27,	// Right
		0x28,	// Down
		0x2D,	// Insert
		0x2E	// Delete
	];

	function set_key_code(c, k) {
		key_code_map.push({ chr: c, key: k });
	}

	function reset_key_code(c, k) {
		for(var i = 0; i < key_code_map.length; ++i) {
			if(key_code_map[i].chr == c) {
				key_code_map[i].key = k;
				return;
			}
		}
		set_key_code(c, k);
	}

	// Initialize key_code_map based on 101 US keyboard
	(function (){

		// For digit [0-9]
		var offset_digit = 0x30,
			offset_10key = 0x60;
		for(var i = 0; i <= 9; ++i) {
			set_key_code(
				String.fromCharCode(i+offset_digit),
				[ { code: i+offset_digit }, { code: i+offset_10key } ]
			);
		}

		// For alpha [a-zA-Z]
		var offset_upper = offset_code = 0x41,
			offset_lower = 0x61;
		for(var i = 0; i < 26; ++i) {
			set_key_code(
				String.fromCharCode(i+offset_upper),
				[{ code: i+offset_code, shift: true }]
			);
			set_key_code(
				String.fromCharCode(i+offset_lower),
				[{ code: i+offset_code }]
			);
		}

		// For graph ^[0-9a-zA-Z]
		jQuery.each([
			{ c: ' ',  k: [{ code: 0x20 }] },
			{ c: ')',  k: [{ code: 0x30, shift: true }] },
			{ c: '!',  k: [{ code: 0x31, shift: true }] },
			{ c: '@',  k: [{ code: 0x32, shift: true }] },
			{ c: '#',  k: [{ code: 0x33, shift: true }] },
			{ c: '$',  k: [{ code: 0x34, shift: true }] },
			{ c: '%',  k: [{ code: 0x35, shift: true }] },
			{ c: '^',  k: [{ code: 0x36, shift: true }] },
			{ c: '&',  k: [{ code: 0x37, shift: true }] },
			{ c: '*',  k: [{ code: 0x38, shift: true }, { code: 0x6A }, { code: 0x6A, shift: true }] },
			{ c: '(',  k: [{ code: 0x39, shift: true }] },

			{ c: ';',  k: [{ code: 0xBA }] },
			{ c: ':',  k: [{ code: 0xBA, shift: true }] },
			{ c: '+',  k: [{ code: 0xBB, shift: true }, { code: 0x6B }, { code: 0x6B, shift: true }] },
			{ c: ',',  k: [{ code: 0xBC }] },
			{ c: '<',  k: [{ code: 0xBC, shift: true }] },
			{ c: ',',  k: [{ code: 0xBB, shift: true }] },
			{ c: '-',  k: [{ code: 0xBD }, { code: 0x6D }, { code: 0x6D, shift: true }] },
			{ c: '_',  k: [{ code: 0xBD, shift: true }] },
			{ c: '.',  k: [{ code: 0xBE }, { code: 0x6E }, { code: 0x6E, shift: true }] },
			{ c: '>',  k: [{ code: 0xBE, shift: true }] },
			{ c: '/',  k: [{ code: 0xBF }, { code: 0x6F }, { code: 0x6F, shift: true }] },
			{ c: '?',  k: [{ code: 0xBF, shift: true }] },
			{ c: '`',  k: [{ code: 0xC0 }] },
			{ c: '~',  k: [{ code: 0xC0, shift: true }] },
			{ c: '[',  k: [{ code: 0xDB }] },
			{ c: '{',  k: [{ code: 0xDB, shift: true }] },
			{ c: '\\', k: [{ code: 0xDC }] },
			{ c: '|',  k: [{ code: 0xDC, shift: true }] },
			{ c: ']',  k: [{ code: 0xDD }] },
			{ c: '}',  k: [{ code: 0xDD, shift: true }] },
			{ c: "'",  k: [{ code: 0xDE }] },
			{ c: '"',  k: [{ code: 0xDE, shift: true }] }

		] , function() {
			set_key_code(this.c, this.k);
		});

		jQuery.KLIMIT = jQuery.KLIMIT || {};
		if(jQuery.KLIMIT.KEY_CODE_MAP) {
			jQuery.each(jQuery.KLIMIT.KEY_CODE_MAP, function() {
				reset_key_code(this.c, this.k);
			});
		}
	})();

	function is_key_bypassed(ev) {
		if(ev.ctrlKey) {
			return true;
		}
		if(ev.keyCode >= 0x70 && ev.keyCode <= 0x7B) {
			// Function keys: F1-F12
			return true;
		}
		return jQuery.inArray(ev.keyCode, key_bypassed) >= 0;
	}

	function is_key_obj(obj) {
		return typeof obj == 'object'
			&& obj.normal != undefined && obj.normal.constructor == Array
			&& obj.shift != undefined && obj.shift.constructor == Array;
	}

	function find_key(c) {
		var size = key_code_map.length;
		for(var i = 0; i < size; ++i) {
			if(key_code_map[i].chr == c) {
				return key_code_map[i].key;
			}
		}
		return null;
	}

	function make_key(str) {
		var obj = { normal: [], shift: [] },
			len = str.length;
		for(var i = 0; i < len; ++i) {
			var key = find_key(str.charAt(i));
			if(key) {
				jQuery.each(key, function() {
					(this.shift ? obj.shift : obj.normal).push(this.code);
				});
			}
		}
		return obj;
	}

	function concat_key() {
		var obj = make_key('');
		jQuery.each(arguments, function() {
			obj.normal = obj.normal.concat(this.normal);
			obj.shift = obj.shift.concat(this.shift);
		});
		return obj;
	}

	function build_key(keys) {
		var obj = make_key('');
		jQuery.each(keys, function(i, key) {
			if(is_key_obj(key)) {
				obj = concat_key(obj, key);
			}
			else if(typeof key == 'string') {
				obj = concat_key(obj, make_key(key));
			}
		});
		return obj;
	}

	function is_allowed(ev, keys) {
		if(is_key_bypassed(ev)) {
			return true;
		}

		var key = build_key(keys);
		return jQuery.inArray(ev.keyCode, ev.shiftKey ? key.shift : key.normal) >= 0;
	}

	// The following functions/variables are pubilc.
	jQuery.KLIMIT.DIGIT	= make_key('0123456789');
	jQuery.KLIMIT.HEX	= concat_key(jQuery.KLIMIT.DIGIT, make_key('abcdefABCDEF'));
	jQuery.KLIMIT.LOWER	= make_key('abcdefghijklmnopqrstuvwxyz');
	jQuery.KLIMIT.UPPER	= make_key('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
	jQuery.KLIMIT.ALPHA	= concat_key(jQuery.KLIMIT.LOWER, jQuery.KLIMIT.UPPER);
	jQuery.KLIMIT.ALNUM	= concat_key(jQuery.KLIMIT.ALPHA, jQuery.KLIMIT.DIGIT);
	jQuery.KLIMIT.GRAPH	= concat_key(jQuery.KLIMIT.ALNUM, make_key('!"#$%&\'()*+-,./:;<=>?@[\\]^_`{|}~'));

	jQuery.makeKeyLimit	= make_key;

	jQuery.fn.klimit = function(keys) {
		return this.each(function() {
			jQuery(this).keydown(function(ev) {
				return is_allowed(ev, keys);
			});
		});
	};

})(jQuery);

jQuery(function() {
	var K = jQuery.KLIMIT;
	jQuery.each({
		digit:	[ K.DIGIT ],
		hex:	[ K.HEX ],
		lower:	[ K.LOWER ],
		upper:	[ K.UPPER ],
		alpha:	[ K.ALPHA ],
		alnum:	[ K.ALNUM ],
		graph:	[ K.GRAPH ],
		mail:	[ K.ALNUM, '@-_.' ]
	},
	function(cls, keys) {
		jQuery('input.klimit-'+cls).klimit(keys);
	});
});












var MD5Z=0, MD5_T;
if(!MD5Z) {
	MD5_T=ar();
	for(var i=1; i < 65; i++) {
		MD5_T[i] = parseInt(Math.abs(Math.sin(i)) * 4294967296.0);
	}
	MD5_T[0]=0;
}


var MD5_round1 = new Array(
					new Array( 0, 7, 1),	new Array( 1,12, 2),
					new Array( 2,17, 3),	new Array( 3,22, 4),
					new Array( 4, 7, 5),	new Array( 5,12, 6),
					new Array( 6,17, 7),	new Array( 7,22, 8),
					new Array( 8, 7, 9),	new Array( 9,12,10),
					new Array(10,17,11),	new Array(11,22,12),
					new Array(12, 7,13),	new Array(13,12,14),
					new Array(14,17,15),	new Array(15,22,16)
				);

var MD5_round2 = new Array(
					new Array( 1, 5,17),	new Array( 6, 9,18),
					new Array(11,14,19),	new Array( 0,20,20),
					new Array( 5, 5,21),	new Array(10, 9,22),
					new Array(15,14,23),	new Array( 4,20,24),
					new Array( 9, 5,25),	new Array(14, 9,26),
					new Array( 3,14,27),	new Array( 8,20,28),
					new Array(13, 5,29),	new Array( 2, 9,30),
					new Array( 7,14,31),	new Array(12,20,32)
				);

var MD5_round3 = new Array(
					new Array( 5, 4,33),	new Array( 8,11,34),
					new Array(11,16,35),	new Array(14,23,36),
					new Array( 1, 4,37),	new Array( 4,11,38),
					new Array( 7,16,39),	new Array(10,23,40),
					new Array(13, 4,41),	new Array( 0,11,42),
					new Array( 3,16,43),	new Array( 6,23,44),
					new Array( 9, 4,45),	new Array(12,11,46),
					new Array(15,16,47),	new Array( 2,23,48)
				);

var MD5_round4 = new Array(
					new Array( 0, 6,49),	new Array( 7,10,50),
					new Array(14,15,51),	new Array( 5,21,52),
					new Array(12, 6,53),	new Array( 3,10,54),
					new Array(10,15,55),	new Array( 1,21,56),
					new Array( 8, 6,57),	new Array(15,10,58),
					new Array( 6,15,59),	new Array(13,21,60),
					new Array( 4, 6,61),	new Array(11,10,62),
					new Array( 2,15,63),	new Array( 9,21,64)
				);

function MD5_F(x, y, z) { return (x & y) | (~x & z);}
function MD5_G(x, y, z) { return (x & z) | (y & ~z);}
function MD5_H(x, y, z) { return x ^ y ^ z; 		}
function MD5_I(x, y, z) { return y ^ (x | ~z);		}

var MD5_round = new Array(
					new Array(MD5_F, MD5_round1),
					new Array(MD5_G, MD5_round2),
					new Array(MD5_H, MD5_round3),
					new Array(MD5_I, MD5_round4)
				);

function MD5_pack(n32) {
	return String.fromCharCode(n32 & 0xff) +
		String.fromCharCode((n32 >>> 8) & 0xff) +
		String.fromCharCode((n32 >>> 16) & 0xff) +
		String.fromCharCode((n32 >>> 24) & 0xff);
}

function MD5_unpack(s4) {
	return  s4.charCodeAt(0)        |
		(s4.charCodeAt(1) <<  8) |
		(s4.charCodeAt(2) << 16) |
		(s4.charCodeAt(3) << 24);
}

function MD5_number(n) {
	while (n < 0)
		n += 4294967296;
	while (n > 4294967295)
		n -= 4294967296;
	return n;
}

function MD5_apply_round(x, s, f, abcd, r) {
	var a, b, c, d,
		kk, ss, ii,
		t, u;

	a = abcd[0];
	b = abcd[1];
	c = abcd[2];
	d = abcd[3];
	kk = r[0];
	ss = r[1];
	ii = r[2];

	u = f(s[b], s[c], s[d]);
	t = s[a] + u + x[kk] + MD5_T[ii];
	t = MD5_number(t);
	t = ((t<<ss) | (t>>>(32-ss)));
	t += s[b];
	s[a] = MD5_number(t);
}

function MD5_hash(data) {
	var abcd, x, state, s,
		len, index, padLen, f, r,
		i, j, k,
		tmp;

	state = new Array(0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476);
	len = data.length;
	index = len & 0x3f;
	padLen = (index < 56) ? (56 - index) : (120 - index);
	if(padLen > 0) {
		data += "\x80";
		for(i = 0; i < padLen - 1; i++)
			data += "\x00";
	}
	data += MD5_pack(len * 8);
	data += MD5_pack(0);
	len  += padLen + 8;
	abcd = new Array(0, 1, 2, 3);
	x    = new Array(16);
	s    = new Array(4);

	for(k = 0; k < len; k += 64) {
		for(i = 0, j = k; i < 16; i++, j += 4) {
			x[i] = data.charCodeAt(j) |
				(data.charCodeAt(j + 1) <<  8) |
				(data.charCodeAt(j + 2) << 16) |
				(data.charCodeAt(j + 3) << 24);
	    }
		for(i = 0; i < 4; i++)
			s[i] = state[i];
		for(i = 0; i < 4; i++) {
			f = MD5_round[i][0];
			r = MD5_round[i][1];
			for(j = 0; j < 16; j++) {
				MD5_apply_round(x, s, f, abcd, r[j]);
				tmp = abcd[0];
				abcd[0] = abcd[3];
				abcd[3] = abcd[2];
				abcd[2] = abcd[1];
				abcd[1] = tmp;
			}
		}

		for(i = 0; i < 4; i++) {
			state[i] += s[i];
			state[i] = MD5_number(state[i]);
		}
	}

	return	MD5_pack(state[0]) +
			MD5_pack(state[1]) +
			MD5_pack(state[2]) +
			MD5_pack(state[3]);
}

function MD5_hexhash(data) {
	var i, out, c,
		bit128;

	bit128 = MD5_hash(data);
	out = h;
	for(i = 0; i < 16; i++) {
		c = bit128.charCodeAt(i);
		out += "0123456789abcdef".charAt((c>>4) & 0xf);
		out += "0123456789abcdef".charAt(c & 0xf);
	}
	return out;
}
