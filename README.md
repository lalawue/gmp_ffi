
# About

gmp_ffi.lua is a LuaJIT FFI binding for [GMP](http://gmplib.org) 6.1.2 with ffi.gc hook, export Integer, Float, Rational, Random and Format interface.

# Examples

examples to show how to use gmp_ffi.lua.

## 1. Basic

get basic example with

```bash
$ luajit test_gmpffi.lua
mpz: a:11111111110999999999999999999999988888888889, c sign:1, odd:true
mpz: value base ff
mpf: 111111111111111104488000000000000000.000000, c sign:1
mpq: 626aec68da8949667fc8628d85031c7078369/a51e113c298b8eea12d162747078369, c sign:0
random: 4176066647
```

## 2. Test Prime

a prime calculation program, try to get first 1 millon primes below, cost about 2 minutes, or just get the last like

```bash
$ luajit test_prime.lua 15485864 > output_primes.txt
$ luajit test_prime.lua 15485800 15485864
```

we can testify with <https://primes.utm.edu/lists/small/millions/primes1.zip>, download and extract the file then output primes in lines:

```bash
$ unzip primes1.zip
Archive:  primes1.zip
  inflating: primes1.txt
$ luajit test_read_primes.lua primes1.txt > primes_lines.txt
$ diff primes_lines.txt output_primes.txt
```

## 3. RSA encode/decode

first get primes in hex using later, using 32bit integer for example

```bash
$ luajit test_prime.lua 0xffffff00 0xffffffff hex > primes_hex.txt
```

generate key pairs in current dir

```bash
$ luajit test_rsa.lua -keygen primes_hex.txt
generate rsa_pub.txt and rsa_priv.txt
```

try encode

```bash
$ luajit test_rsa.lua -encode rsa_pub.txt primes_hex.txt > c.txt
```

try decode and diff

```bash
$ luajit test_rsa.lua -decode rsa_priv.txt c.txt > p.txt
$ diff p.txt primes_hex.txt
```

# Interface

get more inteface infomation with help()

```bash
LuaJIT 2.0.5 -- Copyright (C) 2005-2017 Mike Pall. http://luajit.org/
JIT: ON CMOV SSE2 SSE3 SSE4.1 fold cse dce fwd dse narrow loop abc sink fuse
> gmp = require("gmp_ffi")
> gmp.help()
Usage: gmp.mpz(), gmp.mpf(), gmp.mpq(), gmp.randinit() with ffi.gc() hook
supported interface with gmp.help("[integer|rational|float|random|misc]")
> gmp.help("misc")
snprintf
tostring
mpz_even
cstring
randinit
mpq_sgn
printf
asprintf
vsnprintf
mpz_odd
vsprintf
mpz_sgn
mpf_sgn
sprintf
vasprintf
vprintf
```



