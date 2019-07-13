--
-- test RSA by lalawue, 2019/07/13

local gmp = require("gmp_ffi")
local rsa = {}

function rsa.read_content( path )
   local f = io.open( path, "rb" )
   if f then
      local content = f:read("*a")
      f:close()
      return content
   end
   return nil
end

function rsa.write_content(path, content)
   local f = io.open( path, "w")
   if f then
      f:write(content)
      f:close()
      return true
   end
   return false
end

function rsa.load_hex_prime( file_path )
   local content = rsa.read_content( file_path )
   if content then
      local primes = {}
      for v in content:gmatch("%s+(%x+)") do
         local mpz = gmp.mpz(v, 16)
         primes[#primes + 1] = mpz
      end
      return primes
   end
end

function rsa.keygen( primes )
   if not primes then
      return
   end
   math.randomseed(os.time())
   local p = math.random(#primes)
   local q = math.random(#primes)
   local zp = primes[p]
   local zq = primes[q]
   local zn, zf, ze, zd = gmp.mpz(), gmp.mpz(), gmp.mpz(65537), gmp.mpz()
   gmp.mpz_mul(zn, zp, zq)      -- pub
   gmp.mpz_sub_ui(zp, zp, 1)
   gmp.mpz_sub_ui(zq, zq, 1)
   gmp.mpz_mul(zf, zp, zq)
   gmp.mpz_invert(zd, ze, zf)   -- priv

   local cs = gmp.cstring(2048)
   gmp.snprintf(cs, 2048, "%Zx\n%Zx\n", ze, zn)
   rsa.write_content("rsa_pub.txt", gmp.tostring(cs))
   
   gmp.snprintf(cs, 2048, "%Zx\n%Zx\n", zd, zn);
   rsa.write_content("rsa_priv.txt", gmp.tostring(cs))
end

function rsa.load_keys( file_path, tbl )
   local content = rsa.read_content(file_path)
   if content then
      local e, n = content:match("(%x+)\n(%x+)\n")
      tbl[1] = gmp.mpz(e, 16)
      tbl[2] = gmp.mpz(n, 16)
      tbl[3] = n:len()
      return true
   end
   return false
end

function rsa.string_to_hex( message )
   local tbl = {}
   local i = 1
   repeat
      tbl[#tbl + 1] = string.format("%02X", message:byte(i))
      i = i + 1
   until i > message:len()
   return table.concat(tbl, "")
end

function rsa.hex_to_string( hex )
   local tbl = {}
   local i = 1
   repeat
      tbl[#tbl + 1] = string.char(tonumber(hex:sub(i, i+1), 16))
      i = i + 2
   until i > hex:len()
   return table.concat(tbl, "")
end

function rsa.encode( message, tbl )
   local hex = rsa.string_to_hex(message)
   local ze = tbl[1]
   local zn = tbl[2]
   local blen = tbl[3]
   local zm = gmp.mpz()
   local zx = gmp.mpz()
   local cs = gmp.cstring(tonumber(blen) * 2)
   local tbl = {}
   local i = 1
   repeat
      local ptext = hex:sub(i, math.min(i+blen-1, hex:len()))
      gmp.mpz_set_str(zm, ptext, 16)
      gmp.mpz_powm(zx, zm, ze, zn)
      gmp.sprintf(cs, "%Zx", zx)
      tbl[#tbl + 1] = gmp.tostring(cs)
      i = i + blen
   until i >= hex:len()
   local output = table.concat(tbl, "")
   print(output)
end

function rsa.decode( message, tbl )
   local zd = tbl[1]
   local zn = tbl[2]
   local blen = tbl[3]
   local zm = gmp.mpz()
   local zx = gmp.mpz()
   local cs = gmp.cstring( blen * 3 )
   local tbl = {}
   local i = 1
   repeat
      local ctext = message:sub(i, math.min(i+blen-1, message:len()))
      gmp.mpz_set_str(zm, ctext, 16)
      gmp.mpz_powm(zx, zm, zd, zn)
      gmp.sprintf(cs, "%Zx", zx)
      local str = gmp.tostring(cs)
      if str:len() < blen and (i + blen) < message:len() then
         str = string.rep("0", blen - str:len()) .. str         
      end
      tbl[#tbl + 1] = str         
      i = i + blen
   until i >= message:len()
   local output = table.concat(tbl, "")
   output = rsa.hex_to_string(output)
   io.write(output)
end

function rsa.help()
   print("Usage:")
   print("-keygen hex_primes.txt")
   print("-encode rsa_pub.txt plain.txt")
   print("-decode rsa_priv.txt encode.txt")      
   os.exit(0)
end

--
-- read program args

local arg_option, arg_config, arg_path = ...

if not arg_option or not arg_config then
   rsa.help()
end

if arg_option == "-keygen" then
   local primes = rsa.load_hex_prime( arg_config )
   if not primes then
      print(string.format("fail to load %s", arg_input))
   else
      rsa.keygen( primes )
      print("generate rsa_pub.txt and rsa_priv.txt")
   end
   os.exit();
end

if arg_option == "-encode" then
   local tbl = {}
   local content = rsa.read_content(arg_path)
   if content and rsa.load_keys(arg_config, tbl) then
      rsa.encode( content, tbl )
   else
      print("invalid params")
   end
elseif arg_option == "-decode" then
   local tbl = {}
   local content = rsa.read_content(arg_path)
   if content and rsa.load_keys(arg_config, tbl)  then
      rsa.decode( content, tbl )
   else      
      print("invalid params")
   end
end
