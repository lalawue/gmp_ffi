--
-- test prime using division, try 15485863
-- try compare with first million primes from <https://primes.utm.edu/lists/small/millions/primes1.zip>

local gmp = require("gmp_ffi")
local prime = {}

local function with_base(str)
   if str:find("0x") or str:find("0X") then
      return str:sub(3, str:len()), 16
   end
   if str:find("[abcdefABCDEF]") then
      return str, 16
   end
   return str, 10
end

function prime.check_number_n( n, d, q, r, tmp )
   gmp.mpz_root(tmp, n, 2)
   repeat
      gmp.mpz_tdiv_qr(q, r, n, d)
      if gmp.mpz_cmpabs_ui(r, 0) == 0 then
         return false
      end
      gmp.mpz_add_ui(d, d, 1)
   until gmp.mpz_cmp(d, tmp) > 0
   return true
end

function prime.print_prime_between(min, max, tohex)
   local min = min
   local max = max
   
   if not max then
      max = gmp.mpz(with_base(min))
      if gmp.mpz_cmpabs_ui(max, 2) < 0 then
         return
      end
      min = gmp.mpz(1)
      print("1")
      print("2")
   else
      min = gmp.mpz(with_base(min))      
      max = gmp.mpz(with_base(max))
      if gmp.mpz_cmpabs_ui(max, 2) < 0 then
         return
      end
      if gmp.mpz_cmpabs_ui(min, 2) <= 0 then
         gmp.mpz_set_si(min, 1)
         print("1")
         print("2")
      elseif gmp.mpz_even(min) then
         gmp.mpz_sub_ui(min, min, 1)
      else
         gmp.mpz_sub_ui(min, min, 2)
      end
   end

   local n = min
   local d = gmp.mpz(0)
   local q = gmp.mpz(0)
   local r = gmp.mpz(0)
   local tmp = gmp.mpz(0)
   
   repeat
      gmp.mpz_set_ui(d, 2)
      gmp.mpz_add_ui(n, n, 2)
      if prime.check_number_n(n, d, q, r, tmp) then
         if tohex then
            gmp.printf("%Zx\n", n)
         else
            gmp.printf("%Zd\n", n)
         end
      end
   until gmp.mpz_cmp(n, max) >= 0   
end

-- 
-- get parameter

local min, max, tohex = ...

if not min and not max then
   print("Print prime between: MIN_INTEGER [MAX_INTERGER] [TO_HEX]")
   os.exit(0)
end

prime.print_prime_between(min, max, tohex)
