{module, test} = QUnit
module \ES6
DESCRIPTORS and test 'Int16 conversions', !(assert)~>
  {Int16Array, Uint8Array, DataView} = core
  data = [
    [0,0,[0,0]]
    [-0,0,[0,0]]
    [1,1,[1,0]]
    [-1,-1,[255,255]]
    [1.1,1,[1,0]]
    [-1.1,-1,[255,255]]
    [1.9,1,[1,0]]
    [-1.9,-1,[255,255]]
    [127,127,[127,0]]
    [-127,-127,[129,255]]
    [128,128,[128,0]]
    [-128,-128,[128,255]]
    [255,255,[255,0]]
    [-255,-255,[1,255]]
    [255.1,255,[255,0]]
    [255.9,255,[255,0]]
    [256,256,[0,1]]
    [32767,32767,[255,127]]
    [-32767,-32767,[1,128]]
    [32768,-32768,[0,128]]
    [-32768,-32768,[0,128]]
    [65535,-1,[255,255]]
    [65536,0,[0,0]]
    [65537,1,[1,0]]
    [65536.54321,0,[0,0]]
    [-65536.54321,0,[0,0]]
    [2147483647,-1,[255,255]]
    [-2147483647,1,[1,0]]
    [2147483648,0,[0,0]]
    [-2147483648,0,[0,0]]
    [4294967296,0,[0,0]]
    [Infinity,0,[0,0]]
    [-Infinity,0,[0,0]]
    [-1.7976931348623157e+308,0,[0,0]]
    [1.7976931348623157e+308,0,[0,0]]
    [5e-324,0,[0,0]]
    [-5e-324,0,[0,0]]
    [NaN,0,[0,0]]
  ]

  # Android 4.3- bug
  if NATIVE or !/Android [2-4]/.test navigator?userAgent
    data = data.concat [
      [2147483649,1,[1,0]]
      [-2147483649,-1,[255,255]]
      [4294967295,-1,[255,255]]
      [4294967297,1,[1,0]]
    ]

  KEY   = \setInt16
  typed = new Int16Array 1
  uint8 = new Uint8Array typed.buffer
  view  = new DataView typed.buffer

  z = -> if it is 0 and 1 / it is -Infinity => '-0' else it
  
  for [value, conversion, little] in data
    
    big = little.slice!reverse!
    rep = if LITTLE_ENDIAN => little else big

    typed[0] = value
    assert.same typed[0], conversion, "#{z value} -> #{z conversion}"
    assert.arrayEqual uint8, rep, "#{z value} -> #rep"

    view[KEY] 0, value
    assert.arrayEqual uint8, big, "view.#KEY(0, #{z value}) -> #big"
    view[KEY] 0, value, no
    assert.arrayEqual uint8, big, "view.#KEY(0, #{z value}, false) -> #big"
    view[KEY] 0, value, on
    assert.arrayEqual uint8, little, "view.#KEY(0, #{z value}, true) -> #little"