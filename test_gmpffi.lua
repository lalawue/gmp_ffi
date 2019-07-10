--
-- test demo

local gmp = require("gmp_ffi")

function basic_test()
   local a = gmp.mpz(11111111111)
   local b = gmp.mpz("999999999999999999999999999999999")
   local c = gmp.mpz("99999")
   gmp.mpz_mul(a, a, b)
   --gmp.mpz_set_ui(c, 1)
   gmp.printf("mpz: a:%Zd, c sign:", a)
   print(string.format("%d, odd:%s", gmp.mpz_sgn(c), gmp.mpz_odd(c)))

   a = gmp.mpf(111111111.111111111)
   b = gmp.mpf("999999999999999999999999999.99999999999999999999999999999999999")
   c = gmp.mpf("9999")
   gmp.mpf_mul(a, a, b)
   gmp.printf("mpf: %Ff, c sign:", a)
   print(gmp.mpf_sgn(c))

   a = gmp.mpq(111111111, 111111111)
   b = gmp.mpq("9999999999999999999999999999999/99999999999999999999999999999999999999")
   c = gmp.mpq(0)
   gmp.mpq_div(a, a, b)
   gmp.printf("mpq: %Qx, c sign:", a)
   print(gmp.mpq_sgn(c))
end

basic_test()
