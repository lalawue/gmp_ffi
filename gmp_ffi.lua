--
-- GMP LuaJIT FFI binding for 6.1.2, by lalawue, 2019/07/07

assert(jit, "Please use LuaJIT 2.0.5")

local ffi = require("ffi")
local bit = require("bit")
local gmp = ffi.load("gmp")

assert(gmp, "Please provide gmp library in your load path")

ffi.cdef[[

/** Types
 */

typedef unsigned long long int	mp_limb_t;
typedef long long int		mp_limb_signed_t;

typedef unsigned long int	mp_bitcnt_t;

/* For reference, note that the name __mpz_struct gets into C++ mangled
   function names, which means although the "__" suggests an internal, we
   must leave this name for binary compatibility.  */
typedef struct
{
  int _mp_alloc;		/* Number of *limbs* allocated and pointed
				   to by the _mp_d field.  */
  int _mp_size;			/* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
} __mpz_struct;


typedef __mpz_struct MP_INT;    /* gmp 1 source compatibility */
typedef __mpz_struct mpz_t[1];

typedef mp_limb_t *		mp_ptr;
typedef const mp_limb_t *	mp_srcptr;

typedef long int		mp_size_t;
typedef long int		mp_exp_t;

typedef struct
{
  __mpz_struct _mp_num;
  __mpz_struct _mp_den;
} __mpq_struct;

typedef __mpq_struct MP_RAT;    /* gmp 1 source compatibility */
typedef __mpq_struct mpq_t[1];

typedef struct
{
  int _mp_prec;			/* Max precision, in number of `mp_limb_t's.
				   Set by mpf_init and modified by
				   mpf_set_prec.  The area pointed to by the
				   _mp_d field contains `prec' + 1 limbs.  */
  int _mp_size;			/* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_exp_t _mp_exp;		/* Exponent, in the base of `mp_limb_t'.  */
  mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
} __mpf_struct;

/* typedef __mpf_struct MP_FLOAT; */
typedef __mpf_struct mpf_t[1];

/* Available random number generation algorithms.  */
typedef enum
{
  GMP_RAND_ALG_DEFAULT = 0,
  GMP_RAND_ALG_LC = GMP_RAND_ALG_DEFAULT /* Linear congruential.  */
} gmp_randalg_t;

/* Random state struct.  */
typedef struct
{
  mpz_t _mp_seed;	  /* _mp_d member points to state of the generator. */
  gmp_randalg_t _mp_alg;  /* Currently unused. */
  union {
    void *_mp_lc;         /* Pointer to function pointers structure.  */
  } _mp_algdata;
} __gmp_randstate_struct;
typedef __gmp_randstate_struct gmp_randstate_t[1];

/* Types for function declarations in gmp files.  */
typedef const __mpz_struct *mpz_srcptr;
typedef __mpz_struct *mpz_ptr;
typedef const __mpf_struct *mpf_srcptr;
typedef __mpf_struct *mpf_ptr;
typedef const __mpq_struct *mpq_srcptr;
typedef __mpq_struct *mpq_ptr;


/** Integer
 */

void __gmpz_abs (mpz_ptr, mpz_srcptr);
void __gmpz_add (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_add_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_addmul (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_addmul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_and (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_array_init (mpz_ptr, mp_size_t, mp_size_t);
void __gmpz_bin_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_bin_uiui (mpz_ptr, unsigned long int, unsigned long int);
void __gmpz_cdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_cdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_cdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_cdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
unsigned long int __gmpz_cdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_cdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_cdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_cdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
unsigned long int __gmpz_cdiv_ui (mpz_srcptr, unsigned long int) ;
void __gmpz_clear (mpz_ptr);
void __gmpz_clears (mpz_ptr, ...);
void __gmpz_clrbit (mpz_ptr, mp_bitcnt_t);
int __gmpz_cmp (mpz_srcptr, mpz_srcptr)  ;
int __gmpz_cmp_d (mpz_srcptr, double) ;
int __gmpz_cmpabs (mpz_srcptr, mpz_srcptr)  ;
int __gmpz_cmpabs_d (mpz_srcptr, double) ;
int __gmpz_cmpabs_ui (mpz_srcptr, unsigned long int)  ;
void __gmpz_com (mpz_ptr, mpz_srcptr);
void __gmpz_combit (mpz_ptr, mp_bitcnt_t);
int __gmpz_congruent_p (mpz_srcptr, mpz_srcptr, mpz_srcptr) ;
int __gmpz_congruent_2exp_p (mpz_srcptr, mpz_srcptr, mp_bitcnt_t)  ;
int __gmpz_congruent_ui_p (mpz_srcptr, unsigned long, unsigned long) ;
void __gmpz_divexact (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_divexact_ui (mpz_ptr, mpz_srcptr, unsigned long);
int __gmpz_divisible_p (mpz_srcptr, mpz_srcptr) ;
int __gmpz_divisible_ui_p (mpz_srcptr, unsigned long) ;
int __gmpz_divisible_2exp_p (mpz_srcptr, mp_bitcnt_t)  ;
void __gmpz_dump (mpz_srcptr);
void* __gmpz_export (void *, size_t *, int, size_t, int, size_t, mpz_srcptr);
void __gmpz_fac_ui (mpz_ptr, unsigned long int);
void __gmpz_2fac_ui (mpz_ptr, unsigned long int);
void __gmpz_mfac_uiui (mpz_ptr, unsigned long int, unsigned long int);
void __gmpz_primorial_ui (mpz_ptr, unsigned long int);
void __gmpz_fdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_fdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_fdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_fdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
unsigned long int __gmpz_fdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_fdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_fdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_fdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
unsigned long int __gmpz_fdiv_ui (mpz_srcptr, unsigned long int) ;
void __gmpz_fib_ui (mpz_ptr, unsigned long int);
void __gmpz_fib2_ui (mpz_ptr, mpz_ptr, unsigned long int);
int __gmpz_fits_sint_p (mpz_srcptr)  ;
int __gmpz_fits_slong_p (mpz_srcptr)  ;
int __gmpz_fits_sshort_p (mpz_srcptr)  ;
int __gmpz_fits_uint_p (mpz_srcptr)  ;
int __gmpz_fits_ulong_p (mpz_srcptr)  ;
int __gmpz_fits_ushort_p (mpz_srcptr)  ;
void __gmpz_gcd (mpz_ptr, mpz_srcptr, mpz_srcptr);
unsigned long int __gmpz_gcd_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_gcdext (mpz_ptr, mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
double __gmpz_get_d (mpz_srcptr) ;
double __gmpz_get_d_2exp (signed long int *, mpz_srcptr);
long int __gmpz_get_si (mpz_srcptr)  ;
char *__gmpz_get_str (char *, int, mpz_srcptr);
unsigned long int __gmpz_get_ui (mpz_srcptr)  ;
mp_limb_t __gmpz_getlimbn (mpz_srcptr, mp_size_t)  ;
mp_bitcnt_t __gmpz_hamdist (mpz_srcptr, mpz_srcptr)  ;
void __gmpz_import (mpz_ptr, size_t, int, size_t, int, size_t, const void *);
void __gmpz_init (mpz_ptr);
void __gmpz_init2 (mpz_ptr, mp_bitcnt_t);
void __gmpz_inits (mpz_ptr, ...);
void __gmpz_init_set (mpz_ptr, mpz_srcptr);
void __gmpz_init_set_d (mpz_ptr, double);
void __gmpz_init_set_si (mpz_ptr, signed long int);
int __gmpz_init_set_str (mpz_ptr, const char *, int);
void __gmpz_init_set_ui (mpz_ptr, unsigned long int);
size_t __gmpz_inp_raw(mpz_ptr, void *);
size_t __gmpz_inp_str(mpz_ptr, void *, int);
int __gmpz_invert (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_ior (mpz_ptr, mpz_srcptr, mpz_srcptr);
int __gmpz_jacobi (mpz_srcptr, mpz_srcptr) ;
int __gmpz_kronecker_si (mpz_srcptr, long) ;
int __gmpz_kronecker_ui (mpz_srcptr, unsigned long) ;
int __gmpz_si_kronecker (long, mpz_srcptr) ;
int __gmpz_ui_kronecker (unsigned long, mpz_srcptr) ;
void __gmpz_lcm (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_lcm_ui (mpz_ptr, mpz_srcptr, unsigned long);
void __gmpz_lucnum_ui (mpz_ptr, unsigned long int);
void __gmpz_lucnum2_ui (mpz_ptr, mpz_ptr, unsigned long int);
int __gmpz_millerrabin (mpz_srcptr, int) ;
void __gmpz_mod (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_mul (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_mul_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
void __gmpz_mul_si (mpz_ptr, mpz_srcptr, long int);
void __gmpz_mul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_neg (mpz_ptr, mpz_srcptr);
void __gmpz_nextprime (mpz_ptr, mpz_srcptr);
size_t __gmpz_out_raw(void *, mpz_srcptr);
size_t __gmpz_out_str(void *, int, mpz_srcptr);
int __gmpz_perfect_power_p (mpz_srcptr) ;
int __gmpz_perfect_square_p (mpz_srcptr) ;
mp_bitcnt_t __gmpz_popcount (mpz_srcptr)  ;
void __gmpz_pow_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_powm (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);
void __gmpz_powm_sec (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);
void __gmpz_powm_ui (mpz_ptr, mpz_srcptr, unsigned long int, mpz_srcptr);
int __gmpz_probab_prime_p (mpz_srcptr, int) ;
void __gmpz_random (mpz_ptr, mp_size_t);
void __gmpz_random2 (mpz_ptr, mp_size_t);
void __gmpz_realloc2 (mpz_ptr, mp_bitcnt_t);
mp_bitcnt_t __gmpz_remove (mpz_ptr, mpz_srcptr, mpz_srcptr);
int __gmpz_root (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_rootrem (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_rrandomb (mpz_ptr, gmp_randstate_t, mp_bitcnt_t);
mp_bitcnt_t __gmpz_scan0 (mpz_srcptr, mp_bitcnt_t)  ;
mp_bitcnt_t __gmpz_scan1 (mpz_srcptr, mp_bitcnt_t)  ;
void __gmpz_set (mpz_ptr, mpz_srcptr);
void __gmpz_set_d (mpz_ptr, double);
void __gmpz_set_f (mpz_ptr, mpf_srcptr);
void __gmpz_set_q (mpz_ptr, mpq_srcptr);
void __gmpz_set_si (mpz_ptr, signed long int);
int __gmpz_set_str (mpz_ptr, const char *, int);
void __gmpz_set_ui (mpz_ptr, unsigned long int);
void __gmpz_setbit (mpz_ptr, mp_bitcnt_t);
size_t __gmpz_size (mpz_srcptr)  ;
size_t __gmpz_sizeinbase (mpz_srcptr, int)  ;
void __gmpz_sqrt (mpz_ptr, mpz_srcptr);
void __gmpz_sqrtrem (mpz_ptr, mpz_ptr, mpz_srcptr);
void __gmpz_sub (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_sub_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_ui_sub (mpz_ptr, unsigned long int, mpz_srcptr);
void __gmpz_submul (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_submul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_swap (mpz_ptr, mpz_ptr) ;
unsigned long int __gmpz_tdiv_ui (mpz_srcptr, unsigned long int) ;
void __gmpz_tdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_tdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_tdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_tdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
unsigned long int __gmpz_tdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
void __gmpz_tdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
void __gmpz_tdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
unsigned long int __gmpz_tdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
int __gmpz_tstbit (mpz_srcptr, mp_bitcnt_t)  ;
void __gmpz_ui_pow_ui (mpz_ptr, unsigned long int, unsigned long int);
void __gmpz_urandomb (mpz_ptr, gmp_randstate_t, mp_bitcnt_t);
void __gmpz_urandomm (mpz_ptr, gmp_randstate_t, mpz_srcptr);
void __gmpz_xor (mpz_ptr, mpz_srcptr, mpz_srcptr);
mp_srcptr __gmpz_limbs_read (mpz_srcptr);
mp_ptr __gmpz_limbs_write (mpz_ptr, mp_size_t);
mp_ptr __gmpz_limbs_modify (mpz_ptr, mp_size_t);
void __gmpz_limbs_finish (mpz_ptr, mp_size_t);
mpz_srcptr __gmpz_roinit_n (mpz_ptr, mp_srcptr, mp_size_t);

/** Rational
 */
void __gmpq_abs (mpq_ptr, mpq_srcptr);
void __gmpq_add (mpq_ptr, mpq_srcptr, mpq_srcptr);
void __gmpq_canonicalize (mpq_ptr);
void __gmpq_clear (mpq_ptr);
void __gmpq_clears (mpq_ptr, ...);
int __gmpq_cmp (mpq_srcptr, mpq_srcptr) ;
int __gmpq_cmp_si (mpq_srcptr, long, unsigned long) ;
int __gmpq_cmp_ui (mpq_srcptr, unsigned long int, unsigned long int) ;
int __gmpq_cmp_z (mpq_srcptr, mpz_srcptr) ;
void __gmpq_div (mpq_ptr, mpq_srcptr, mpq_srcptr);
void __gmpq_div_2exp (mpq_ptr, mpq_srcptr, mp_bitcnt_t);
int __gmpq_equal (mpq_srcptr, mpq_srcptr) ;
void __gmpq_get_num (mpz_ptr, mpq_srcptr);
void __gmpq_get_den (mpz_ptr, mpq_srcptr);
double __gmpq_get_d (mpq_srcptr) ;
char* __gmpq_get_str (char *, int, mpq_srcptr);
void __gmpq_init (mpq_ptr);
void __gmpq_inits (mpq_ptr, ...);
size_t __gmpq_inp_str (mpq_ptr, void *, int);
void __gmpq_inv (mpq_ptr, mpq_srcptr);
void __gmpq_mul (mpq_ptr, mpq_srcptr, mpq_srcptr);
void __gmpq_mul_2exp (mpq_ptr, mpq_srcptr, mp_bitcnt_t);
void __gmpq_neg (mpq_ptr, mpq_srcptr);
size_t __gmpq_out_str (void *, int, mpq_srcptr);
void __gmpq_set (mpq_ptr, mpq_srcptr);
void __gmpq_set_d (mpq_ptr, double);
void __gmpq_set_den (mpq_ptr, mpz_srcptr);
void __gmpq_set_f (mpq_ptr, mpf_srcptr);
void __gmpq_set_num (mpq_ptr, mpz_srcptr);
void __gmpq_set_si (mpq_ptr, signed long int, unsigned long int);
int __gmpq_set_str (mpq_ptr, const char *, int);
void __gmpq_set_ui (mpq_ptr, unsigned long int, unsigned long int);
void __gmpq_set_z (mpq_ptr, mpz_srcptr);
void __gmpq_sub (mpq_ptr, mpq_srcptr, mpq_srcptr);
void __gmpq_swap (mpq_ptr, mpq_ptr) ;

/** Float
 */
void __gmpf_abs (mpf_ptr, mpf_srcptr);
void __gmpf_add (mpf_ptr, mpf_srcptr, mpf_srcptr);
void __gmpf_add_ui (mpf_ptr, mpf_srcptr, unsigned long int);
void __gmpf_ceil (mpf_ptr, mpf_srcptr);
void __gmpf_clear (mpf_ptr);
void __gmpf_clears (mpf_ptr, ...);
int __gmpf_cmp (mpf_srcptr, mpf_srcptr)  ;
int __gmpf_cmp_z (mpf_srcptr, mpz_srcptr)  ;
int __gmpf_cmp_d (mpf_srcptr, double) ;
int __gmpf_cmp_si (mpf_srcptr, signed long int)  ;
int __gmpf_cmp_ui (mpf_srcptr, unsigned long int)  ;
void __gmpf_div (mpf_ptr, mpf_srcptr, mpf_srcptr);
void __gmpf_div_2exp (mpf_ptr, mpf_srcptr, mp_bitcnt_t);
void __gmpf_div_ui (mpf_ptr, mpf_srcptr, unsigned long int);
void __gmpf_dump (mpf_srcptr);
int __gmpf_eq (mpf_srcptr, mpf_srcptr, mp_bitcnt_t) ;
int __gmpf_fits_sint_p (mpf_srcptr)  ;
int __gmpf_fits_slong_p (mpf_srcptr)  ;
int __gmpf_fits_sshort_p (mpf_srcptr)  ;
int __gmpf_fits_uint_p (mpf_srcptr)  ;
int __gmpf_fits_ulong_p (mpf_srcptr)  ;
int __gmpf_fits_ushort_p (mpf_srcptr)  ;
void __gmpf_floor (mpf_ptr, mpf_srcptr);
double __gmpf_get_d (mpf_srcptr) ;
double __gmpf_get_d_2exp (signed long int *, mpf_srcptr);
mp_bitcnt_t __gmpf_get_default_prec (void)  ;
mp_bitcnt_t __gmpf_get_prec (mpf_srcptr)  ;
long __gmpf_get_si (mpf_srcptr)  ;
char* __gmpf_get_str (char *, mp_exp_t *, int, size_t, mpf_srcptr);
unsigned long __gmpf_get_ui (mpf_srcptr)  ;
void __gmpf_init (mpf_ptr);
void __gmpf_init2 (mpf_ptr, mp_bitcnt_t);
void __gmpf_inits (mpf_ptr, ...);
void __gmpf_init_set (mpf_ptr, mpf_srcptr);
void __gmpf_init_set_d (mpf_ptr, double);
void __gmpf_init_set_si (mpf_ptr, signed long int);
int __gmpf_init_set_str (mpf_ptr, const char *, int);
void __gmpf_init_set_ui (mpf_ptr, unsigned long int);
size_t __gmpf_inp_str (mpf_ptr, void *, int);
int __gmpf_integer_p (mpf_srcptr)  ;
void __gmpf_mul (mpf_ptr, mpf_srcptr, mpf_srcptr);
void __gmpf_mul_2exp (mpf_ptr, mpf_srcptr, mp_bitcnt_t);
void __gmpf_mul_ui (mpf_ptr, mpf_srcptr, unsigned long int);
void __gmpf_neg (mpf_ptr, mpf_srcptr);
size_t __gmpf_out_str (void *, int, size_t, mpf_srcptr);
void __gmpf_pow_ui (mpf_ptr, mpf_srcptr, unsigned long int);
void __gmpf_random2 (mpf_ptr, mp_size_t, mp_exp_t);
void __gmpf_reldiff (mpf_ptr, mpf_srcptr, mpf_srcptr);
void __gmpf_set (mpf_ptr, mpf_srcptr);
void __gmpf_set_d (mpf_ptr, double);
void __gmpf_set_default_prec (mp_bitcnt_t) ;
void __gmpf_set_prec (mpf_ptr, mp_bitcnt_t);
void __gmpf_set_prec_raw (mpf_ptr, mp_bitcnt_t) ;
void __gmpf_set_q (mpf_ptr, mpq_srcptr);
void __gmpf_set_si (mpf_ptr, signed long int);
int __gmpf_set_str (mpf_ptr, const char *, int);
void __gmpf_set_ui (mpf_ptr, unsigned long int);
void __gmpf_set_z (mpf_ptr, mpz_srcptr);
size_t __gmpf_size (mpf_srcptr)  ;
void __gmpf_sqrt (mpf_ptr, mpf_srcptr);
void __gmpf_sqrt_ui (mpf_ptr, unsigned long int);
void __gmpf_sub (mpf_ptr, mpf_srcptr, mpf_srcptr);
void __gmpf_sub_ui (mpf_ptr, mpf_srcptr, unsigned long int);
void __gmpf_swap (mpf_ptr, mpf_ptr) ;
void __gmpf_trunc (mpf_ptr, mpf_srcptr);
void __gmpf_ui_div (mpf_ptr, unsigned long int, mpf_srcptr);
void __gmpf_ui_sub (mpf_ptr, unsigned long int, mpf_srcptr);
void __gmpf_urandomb (mpf_t, gmp_randstate_t, mp_bitcnt_t);

/** Misc
 */
int __gmp_asprintf (char **, const char *, ...);
int __gmp_fprintf (void *, const char *, ...);
int __gmp_printf (const char *, ...);
int __gmp_snprintf (char *, size_t, const char *, ...);
int __gmp_sprintf (char *, const char *, ...);
int __gmp_vasprintf (char **, const char *, va_list);
int __gmp_vfprintf (void *, const char *, va_list);
int __gmp_vprintf (const char *, va_list);
int __gmp_vsnprintf (char *, size_t, const char *, va_list);
int __gmp_vsprintf (char *, const char *, va_list);
]]

local gmpffi = {
   integer_interface = {
      "mpz_abs",
      "mpz_add",
      "mpz_add_ui",
      "mpz_addmul",
      "mpz_addmul_ui",
      "mpz_and",
      "mpz_array_init",
      "mpz_bin_ui",
      "mpz_bin_uiui",
      "mpz_cdiv_q",
      "mpz_cdiv_q_2exp",
      "mpz_cdiv_q_ui",
      "mpz_cdiv_qr",
      "mpz_cdiv_qr_ui",
      "mpz_cdiv_r",
      "mpz_cdiv_r_2exp",
      "mpz_cdiv_r_ui",
      "mpz_cdiv_ui",
      "mpz_clear",
      "mpz_clears",
      "mpz_clrbit",
      "mpz_cmp",
      "mpz_cmp_d",
      "mpz_cmpabs",
      "mpz_cmpabs_d",
      "mpz_cmpabs_ui",
      "mpz_com",
      "mpz_combit",
      "mpz_congruent_p",
      "mpz_congruent_2exp_p",
      "mpz_congruent_ui_p",
      "mpz_divexact",
      "mpz_divexact_ui",
      "mpz_divisible_p",
      "mpz_divisible_ui_p",
      "mpz_divisible_2exp_p",
      "mpz_dump",
      "mpz_export",
      "mpz_fac_ui",
      "mpz_2fac_ui",
      "mpz_mfac_uiui",
      "mpz_primorial_ui",
      "mpz_fdiv_q",
      "mpz_fdiv_q_2exp",
      "mpz_fdiv_q_ui",
      "mpz_fdiv_qr",
      "mpz_fdiv_qr_ui",
      "mpz_fdiv_r",
      "mpz_fdiv_r_2exp",
      "mpz_fdiv_r_ui",
      "mpz_fdiv_ui",
      "mpz_fib_ui",
      "mpz_fib2_ui",
      "mpz_fits_sint_p",
      "mpz_fits_slong_p",
      "mpz_fits_sshort_p",
      "mpz_fits_uint_p",
      "mpz_fits_ulong_p",
      "mpz_fits_ushort_p",
      "mpz_gcd",
      "mpz_gcd_ui",
      "mpz_gcdext",
      "mpz_get_d",
      "mpz_get_d_2exp",
      "mpz_get_si",
      "mpz_get_str",
      "mpz_get_ui",
      "mpz_getlimbn",
      "mpz_hamdist",
      "mpz_import",
      "mpz_init",
      "mpz_init2",
      "mpz_inits",
      "mpz_init_set",
      "mpz_init_set_d",
      "mpz_init_set_si",
      "mpz_init_set_str",
      "mpz_init_set_ui",
      "mpz_inp_raw",
      "mpz_inp_str",
      "mpz_invert",
      "mpz_ior",
      "mpz_jacobi",
      "mpz_kronecker_si",
      "mpz_kronecker_ui",
      "mpz_si_kronecker",
      "mpz_ui_kronecker",
      "mpz_lcm",
      "mpz_lcm_ui",
      "mpz_lucnum_ui",
      "mpz_lucnum2_ui",
      "mpz_millerrabin",
      "mpz_mod",
      "mpz_mul",
      "mpz_mul_2exp",
      "mpz_mul_si",
      "mpz_mul_ui",
      "mpz_neg",
      "mpz_nextprime",
      "mpz_out_raw",
      "mpz_out_str",      
      "mpz_perfect_power_p",
      "mpz_perfect_square_p",
      "mpz_popcount",
      "mpz_pow_ui",
      "mpz_powm",
      "mpz_powm_sec",
      "mpz_powm_ui",
      "mpz_probab_prime_p",
      "mpz_random",
      "mpz_random2",
      "mpz_realloc2",
      "mpz_remove",
      "mpz_root",
      "mpz_rootrem",
      "mpz_rrandomb",
      "mpz_scan0",
      "mpz_scan1",
      "mpz_set",
      "mpz_set_d",
      "mpz_set_f",
      "mpz_set_q",
      "mpz_set_si",
      "mpz_set_str",
      "mpz_set_ui",
      "mpz_setbit",
      "mpz_size",
      "mpz_sizeinbase",
      "mpz_sqrt",
      "mpz_sqrtrem",
      "mpz_sub",
      "mpz_sub_ui",
      "mpz_ui_sub",
      "mpz_submul",
      "mpz_submul_ui",
      "mpz_swap",
      "mpz_tdiv_ui",
      "mpz_tdiv_q",
      "mpz_tdiv_q_2exp",
      "mpz_tdiv_q_ui",
      "mpz_tdiv_qr",
      "mpz_tdiv_qr_ui",
      "mpz_tdiv_r",
      "mpz_tdiv_r_2exp",
      "mpz_tdiv_r_ui",
      "mpz_tstbit",
      "mpz_ui_pow_ui",
      "mpz_urandomb",
      "mpz_urandomm",
      "mpz_xor",
      "mpz_limbs_read",
      "mpz_limbs_write",
      "mpz_limbs_modify",
      "mpz_limbs_finish",
      "mpz_roinit_n",
   },
   rational_interface = {
      "mpq_abs",
      "mpq_add",
      "mpq_canonicalize",
      "mpq_clear",
      "mpq_clears",
      "mpq_cmp",
      "mpq_cmp_si",
      "mpq_cmp_ui",
      "mpq_cmp_z",
      "mpq_div",
      "mpq_div_2exp",
      "mpq_equal",
      "mpq_get_num",
      "mpq_get_den",
      "mpq_get_d",
      "mpq_get_str",
      "mpq_init",
      "mpq_inits",
      "mpq_inp_str",
      "mpq_inv",
      "mpq_mul",
      "mpq_mul_2exp",
      "mpq_neg",
      "mpq_out_str",
      "mpq_set",
      "mpq_set_d",
      "mpq_set_den",
      "mpq_set_f",
      "mpq_set_num",
      "mpq_set_si",
      "mpq_set_str",
      "mpq_set_ui",
      "mpq_set_z",
      "mpq_sub",
      "mpq_swap",
   },
   float_interface = {
      "mpf_abs",
      "mpf_add",
      "mpf_add_ui",
      "mpf_ceil",
      "mpf_clear",
      "mpf_clears",
      "mpf_cmp",
      "mpf_cmp_z",
      "mpf_cmp_d",
      "mpf_cmp_si",
      "mpf_cmp_ui",
      "mpf_div",
      "mpf_div_2exp",
      "mpf_div_ui",
      "mpf_dump",
      "mpf_eq",
      "mpf_fits_sint_p",
      "mpf_fits_slong_p",
      "mpf_fits_sshort_p",
      "mpf_fits_uint_p",
      "mpf_fits_ulong_p",
      "mpf_fits_ushort_p",
      "mpf_floor",
      "mpf_get_d",
      "mpf_get_d_2exp",
      "mpf_get_default_prec",
      "mpf_get_prec",
      "mpf_get_si",
      "mpf_get_str",
      "mpf_get_ui",
      "mpf_init",
      "mpf_init2",
      "mpf_inits",
      "mpf_init_set",
      "mpf_init_set_d",
      "mpf_init_set_si",
      "mpf_init_set_str",
      "mpf_init_set_ui",
      "mpf_inp_str",
      "mpf_integer_p",
      "mpf_mul",
      "mpf_mul_2exp",
      "mpf_mul_ui",
      "mpf_neg",
      "mpf_out_str",
      "mpf_pow_ui",
      "mpf_random2",
      "mpf_reldiff",
      "mpf_set",
      "mpf_set_d",
      "mpf_set_default_prec",
      "mpf_set_prec",
      "mpf_set_prec_raw",
      "mpf_set_q",
      "mpf_set_si",
      "mpf_set_str",
      "mpf_set_ui",
      "mpf_set_z",
      "mpf_size",
      "mpf_sqrt",
      "mpf_sqrt_ui",
      "mpf_sub",
      "mpf_sub_ui",
      "mpf_swap",
      "mpf_trunc",
      "mpf_ui_div",
      "mpf_ui_sub",
      "mpf_urandomb",
   },
   misc_interface = {
      ["asprintf"] = "__gmp_asprintf",
      ["fprintf"] = "__gmp_fprintf",
      ["printf"] = "__gmp_printf",
      ["snprintf"] = "__gmp_snprintf",
      ["sprintf"]= "__gmp_sprintf",
      ["vasprintf"] = "__gmp_vasprintf",
      ["vfprintf"] = "__gmp_vfprintf",
      ["vprintf"] = "__gmp_vprintf",
      ["vsnprintf"] = "__gmp_vsnprintf",
      ["vsprintf"] = "__gmp_vsprintf",
      ["mpz_sgn"] = "",
      ["mpf_sgn"] = "",
      ["mpq_sgn"] = "",
      ["mpz_odd"] = "",
      ["mpz_even"] = "",
   }
}

function gmpffi.help( option )
   if not option then
      print("Usage: init with gmpffi.mpz(value), gmpffi.mpf(value), gmpffi.mpq(num, den)")
      print("List supported interface: gmpffi.help( \"[integer|rational|float|misc]\" )")
      return
   end
   local tbl = gmpffi.misc_interface
   if option == "misc" then
      for k, _ in pairs(tbl) do
         print(k)
      end
      return
   end
   
   if option == "float" then
      tbl = gmpffi.float_interface
   elseif option == "rational" then
      tbl = gmpffi.rational_interface
   elseif option == "misc" then
      tbl = gmpffi.integer_interface
   end
   for _, v in ipairs(tbl) do
      print(v)
   end
end

function gmpffi.mpz( value, base )
   local mpz = ffi.new("mpz_t")
   if mpz then
      ffi.gc(mpz, gmp.__gmpz_clear)
      if type(value) == "string" then
         gmp.__gmpz_init_set_str(mpz, value, base or 10)
      elseif type(value) == "number" then
         gmp.__gmpz_init_set_d(mpz, value)
      else
         gmp.__gmpz_init(mpz)
      end
      return mpz
   end
   return nil
end

function gmpffi.mpz_sgn( value )
   assert(value)
   local v = value[0]._mp_size;
   return v < 0 and -1 or v > 0 and 1 or 0
end

function gmpffi.mpz_odd( value )
   assert(value)
   return value[0]._mp_size ~= 0 and bit.band(1, tonumber(value[0]._mp_d[0])) == 1
end

function gmpffi.mpz_event( value )
   return gmpffi.mpz_odd( value )
end

function gmpffi.mpf( value, base )
   local mpf = ffi.new("mpf_t")
   if mpf then
      ffi.gc(mpf, gmp.__gmpf_clear)
      if type(value) == "string" then
         gmp.__gmpf_init_set_str(mpf, value, base or 10)
      elseif type(value) == "number" then
         gmp.__gmpf_init_set_d(mpf, value)
      else
         gmp.__gmpf_init(mpf)
      end
      return mpf
   end
   return nil
end

function gmpffi.mpf_sgn( value )
   assert(value)
   local v = value[0]._mp_size;
   return v < 0 and -1 or v > 0 and 1 or 0
end

function gmpffi.mpq( num, den  )
   local mpq = ffi.new("mpq_t")
   if mpq then
      ffi.gc(mpq, gmp.__gmpq_clear)      
      gmp.__gmpq_init(mpq)
      if type(num) == "string" then
         gmp.__gmpq_set_str(mpq, num, 10)
      elseif type(num) == "number" and type(den) == "number" then
         gmp.__gmpq_set_si(mpq, num, den)
      end
      return mpq
   end
   return nil
end

function gmpffi.mpq_sgn( value )
   assert(value)
   local v = value[0]._mp_num._mp_size;
   return v < 0 and -1 or v > 0 and 1 or 0
end

function gmpffi.init()
   local tbl = {
      gmpffi.integer_interface,
      gmpffi.rational_interface,
      gmpffi.float_interface
   }
   for _, inteface in ipairs(tbl) do
      for _, name in ipairs(inteface) do
         local fname = "__g" .. name
         assert(gmp[fname], string.format("gmp.%s not exist", name))
         gmpffi[name] = gmp[fname]
      end
   end
   for k, v in pairs(gmpffi.misc_interface) do
      if v:len() > 3 then
         assert(gmp[v], string.format("gmp.%s not exist", v)) 
         gmpffi[k] = gmp[v]
      end
   end
   return true
end

return gmpffi.init() and gmpffi
