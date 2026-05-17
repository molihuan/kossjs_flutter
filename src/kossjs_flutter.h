#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT int sum(int a, int b);

FFI_PLUGIN_EXPORT int sum_long_running(int a, int b);

FFI_PLUGIN_EXPORT const char * version(void);

FFI_PLUGIN_EXPORT long long create(void);

FFI_PLUGIN_EXPORT const char * eval(long long inst,const char *code);

FFI_PLUGIN_EXPORT const char * run_async(long long inst,const char *code,uint64_t timeout_ms);

FFI_PLUGIN_EXPORT void destroy(long long inst);