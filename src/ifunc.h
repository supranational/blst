#include "cpuid.h"

#ifdef __GNUC__
/**
 * The resolver defined below will run early during load, when some features
 * like the stack protector may not be fully set up yet.
 */
# define no_stack_protector \
    __attribute__((__optimize__("-fno-stack-protector")))
#else
# define no_stack_protector
#endif

#ifdef __BLST_DYNAMIC_DEBUG__
# include <stdio.h>
# define ifunc_resolver_debug(s) puts(s)
#else
# define ifunc_resolver_debug(s)
#endif

/**
 * Chooses whether to use `portable_fn` or `optimized_fn` at runtime depending
 * on whether ADX is available or not.
 */
#define ifunc_resolver(fn, portable_fn, optimized_fn)                     \
    no_stack_protector                                                    \
    static fn##_func_t *resolve_##fn(void) {                              \
        __blst_cpuid();                                                   \
        if (__blst_platform_cap & 1) {                                    \
            ifunc_resolver_debug("optimized: " #fn " -> " #optimized_fn); \
            return optimized_fn;                                          \
        } else {                                                          \
            ifunc_resolver_debug("portable: " #fn " -> " #portable_fn);   \
            return portable_fn;                                           \
        }                                                                 \
    }

/**
 * Defines an "indirect function" (ifunc) which is dynamically resolved when
 * blst is loaded depending on whether the ADX instruction set is supported or
 * not.
 *
 * Example:
 *
 *     ifunc(dynamic_fn, portable_fn, optimized_fn,
 *         int, short x, long y, char z);
 *
 * This example would (roughly) generate the following declarations:
 *
 *     int dynamic_fn(short x, long y, char z);
 *     int portable_fn(short x, long y, char z);
 *     int optimized_fn(short x, long y, char z);
 *
 * The special symbol `dynamic_fn` will be assigned to either `portable_fn` or
 * `optimized_fn` at load time, and can be called at low cost at runtime.
 */
#if defined(__GNUC__) && defined(__ELF__)
/* On GCC/clang using the ELF standard; use `__attribute__((ifunc))` */
# define ifunc(fn, portable_fn, optimized_fn, return_type, ...)         \
    typedef return_type (fn##_func_t)(__VA_ARGS__);                     \
    return_type fn(__VA_ARGS__);                                        \
    return_type portable_fn(__VA_ARGS__);                               \
    return_type optimized_fn(__VA_ARGS__);                              \
    ifunc_resolver(fn, portable_fn, optimized_fn);                      \
    return_type fn(__VA_ARGS__) __attribute__((ifunc("resolve_" #fn)));
#elif defined(__GNUC__)
/* On GCC/clang with a generic loader; use function pointers and
 * `__attribute__((constructor))` */
# define ifunc(fn, portable_fn, optimized_fn, return_type, ...)         \
    typedef return_type (fn##_func_t)(__VA_ARGS__);                     \
    return_type (*fn)(__VA_ARGS__);                                     \
    return_type portable_fn(__VA_ARGS__);                               \
    return_type optimized_fn(__VA_ARGS__);                              \
    ifunc_resolver(fn, portable_fn, optimized_fn);                      \
    __attribute__((constructor))                                        \
    no_stack_protector                                                  \
    static void resolve_and_store_##fn(void) {                          \
        fn = resolve_##fn();                                            \
    }
#elif defined(_MSC_VER)
/* On MSVC; use function pointers and add an entry to the `.CRT$XCU` section */
# pragma section(".CRT$XCU",read)
# define ifunc(fn, portable_fn, optimized_fn, return_type, ...)         \
    typedef return_type (fn##_func_t)(__VA_ARGS__);                     \
    return_type (*fn)(__VA_ARGS__);                                     \
    return_type portable_fn(__VA_ARGS__);                               \
    return_type optimized_fn(__VA_ARGS__);                              \
    ifunc_resolver(fn, portable_fn, optimized_fn);                      \
    static void resolve_and_store_##fn(void) {                          \
        fn = resolve_##fn();                                            \
    }                                                                   \
    __declspec(allocate(".CRT$XCU")) static void                        \
        (*__resolve_and_store_##fn)(void) = resolve_and_store_##fn;
#endif
