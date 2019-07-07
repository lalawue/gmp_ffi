--
-- test demo

local gmp = require("gmp_ffi")

function basic_test()
   local a = gmp.mpz(11111111111)
   local b = gmp.mpz("999999999999999999999999999999999")
   local c = gmp.mpz()
   gmp.mpz_mul(c, a, b)
   gmp.printf("mpz: %Zd\n", c)

   a = gmp.mpf(111111111.111111111)
   b = gmp.mpf("999999999999999999999999999.99999999999999999999999999999999999")
   c = gmp.mpf()
   gmp.mpf_mul(c, a, b)
   gmp.printf("mpf: %Ff\n", c)

   a = gmp.mpq(111111111, 111111111)
   b = gmp.mpq("9999999999999999999999999999999/99999999999999999999999999999999999999")
   c = gmp.mpq()
   gmp.mpq_div(c, a, b)
   gmp.printf("mpq: %Qx\n", c)
end

basic_test()
