#include <windows.h>

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{   return TRUE;   }

/*
 * Even though we don't have memcpy/memset anywhere, MSVC compiler
 * generates them as it recognizes corresponding pattern.
 */
void *memcpy(unsigned char *dst, unsigned char *src, size_t n)
{
    void *ret = dst;

    while(n--)
        *dst++ = *src++;

    return ret;
}

void *memset(unsigned char *dst, int c, size_t n)
{
    void *ret = dst;

    while(n--)
        *dst++ = (unsigned char)c;

    return ret;
}
