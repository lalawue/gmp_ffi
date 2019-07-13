
# About

gmp_ffi.lua is a LuaJIT FFI binding for [GMP](http://gmplib.org) 6.1.2 with ffi.gc hook, export Integer, Float, Rational, Random and Format interface.

# Examples

examples to show how to use gmp_ffi.lua.

## 1. Test Prime

It's a prime calculation program, try to get first 1 millon primes below, cost about 2 minutes, or just get the last

```lua
$ luajit test_prime.lua 15485864 > output_primes.txt
$ luajit test_prime.lua 15485800 15485864
```

we can testify with <https://primes.utm.edu/lists/small/millions/primes1.zip>, download and extract the file then output primes in lines:

```lua
$ unzip primes1.zip
Archive:  primes1.zip
  inflating: primes1.txt
$ luajit test_read_primes.lua primes1.txt > primes_lines.txt
$ diff primes_lines.txt output_primes.txt
```

## 2. RSA encode/decode

first get primes in hex using later, using 32bit integer for example

```lua
$ luajit test_prime.lua 0xffffff00 0xffffffff 1 > primes_hex.txt
```

generate key pairs in current dir

```lua
$ luajit test_rsa.lua -keygen primes_hex.txt
generate rsa_pub.txt and rsa_priv.txt
```

try encode

```lua
$ luajit test_rsa.lua -encode rsa_pub.txt primes_hex.txt > c.txt
```

try decode and diff

```lua
$ luajit test_rsa.lua -decode rsa_priv.txt c.txt > p.txt
$ diff p.txt primes_hex.txt
```



