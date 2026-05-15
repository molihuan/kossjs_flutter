#include "kossjs_flutter.h"
#include "kossjs.h"


FFI_PLUGIN_EXPORT int sum(int a, int b) { return a + b; }

FFI_PLUGIN_EXPORT int sum_long_running(int a, int b) {
  // Simulate work.
#if _WIN32
  Sleep(5000);
#else
  usleep(5000 * 1000);
#endif
  return a + b;
}

FFI_PLUGIN_EXPORT const char * version(void) {
  return koss_version();
}

FFI_PLUGIN_EXPORT long long create(void){
  return (long long)koss_create();
}

FFI_PLUGIN_EXPORT const char * eval(long long inst,const char *code){
  KossResult result = koss_eval((KossInstance*)inst,code);
  if (result.code != 0){
      //koss_free_result(result);
  }
  return result.value;
}

FFI_PLUGIN_EXPORT void destroy(long long inst){
    koss_destroy((KossInstance*)inst);
}
