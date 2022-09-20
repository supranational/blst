#if defined(__x86_64) || defined(__x86_64__)
# if defined(__ELF__)
#  include "elf/sha256-portable-x86_64.s"
#  include "elf/ctq_inverse_mod_384-x86_64.s"
#  include "elf/add_mod_384-x86_64.s"
#  include "elf/add_mod_384x384-x86_64.s"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  define __sub_mod_384x384 __sub_mont_384x384
#  include "elf/mulq_mont_384-x86_64.s"
#  include "elf/mulq_mont_256-x86_64.s"
#  include "elf/add_mod_256-x86_64.s"
#  include "elf/ct_inverse_mod_256-x86_64.s"
#  include "elf/div3w-x86_64.s"
#  include "elf/ct_is_square_mod_384-x86_64.s"
# elif defined(_WIN64) || defined(__CYGWIN__)
#  include "coff/sha256-portable-x86_64.s"
#  include "coff/ctq_inverse_mod_384-x86_64.s"
#  include "coff/add_mod_384-x86_64.s"
#  include "coff/add_mod_384x384-x86_64.s"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  define __sub_mod_384x384 __sub_mont_384x384
#  include "coff/mulq_mont_384-x86_64.s"
#  include "coff/mulq_mont_256-x86_64.s"
#  include "coff/add_mod_256-x86_64.s"
#  include "coff/ct_inverse_mod_256-x86_64.s"
#  include "coff/div3w-x86_64.s"
#  include "coff/ct_is_square_mod_384-x86_64.s"
# elif defined(__APPLE__)
#  include "mach-o/sha256-x86_64.s"
#  include "mach-o/ctq_inverse_mod_384-x86_64.s"
#  include "mach-o/add_mod_384-x86_64.s"
#  include "mach-o/add_mod_384x384-x86_64.s"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  define __sub_mod_384x384 __sub_mont_384x384
#  include "mach-o/mulq_mont_384-x86_64.s"
#  include "mach-o/mulq_mont_256-x86_64.s"
#  include "mach-o/add_mod_256-x86_64.s"
#  include "mach-o/ct_inverse_mod_256-x86_64.s"
#  include "mach-o/div3w-x86_64.s"
#  include "mach-o/ct_is_square_mod_384-x86_64.s"
# endif
#elif defined(__aarch64__)
# if defined(__ELF__)
#  include "elf/sha256-armv8.S"
#  include "elf/ct_inverse_mod_384-armv8.S"
#  include "elf/add_mod_384-armv8.S"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  include "elf/mul_mont_384-armv8.S"
#  include "elf/mul_mont_256-armv8.S"
#  include "elf/add_mod_256-armv8.S"
#  include "elf/ct_inverse_mod_256-armv8.S"
#  include "elf/div3w-armv8.S"
#  include "elf/ct_is_square_mod_384-armv8.S"
# elif defined(_WIN64)
#  include "coff/sha256-armv8.S"
#  include "coff/ct_inverse_mod_384-armv8.S"
#  include "coff/add_mod_384-armv8.S"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  include "coff/mul_mont_384-armv8.S"
#  include "coff/mul_mont_256-armv8.S"
#  include "coff/add_mod_256-armv8.S"
#  include "coff/ct_inverse_mod_256-armv8.S"
#  include "coff/div3w-armv8.S"
#  include "coff/ct_is_square_mod_384-armv8.S"
# elif defined(__APPLE__)
#  include "mach-o/sha256-armv8.S"
#  include "mach-o/ct_inverse_mod_384-armv8.S"
#  include "mach-o/add_mod_384-armv8.S"
#  define __add_mod_384     __add_mont_384
#  define __sub_mod_384     __sub_mont_384
#  include "mach-o/mul_mont_384-armv8.S"
#  include "mach-o/mul_mont_256-armv8.S"
#  include "mach-o/add_mod_256-armv8.S"
#  include "mach-o/ct_inverse_mod_256-armv8.S"
#  include "mach-o/div3w-armv8.S"
#  include "mach-o/ct_is_square_mod_384-armv8.S"
# endif
#elif defined(__BLST_NO_ASM__) || \
      (defined(__SIZEOF_POINTER__) && __SIZEOF_POINTER__==4)
/* inaccurate way to detect a 32-bit processor, but it's close enough */
#else
# error "unsupported platform"
#endif
