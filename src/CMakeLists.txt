cmake_minimum_required(VERSION 3.10)

project(kossjs_flutter_library VERSION 0.0.1 LANGUAGES C)

set(M_TAG "nnlln")
#定义名称
set(KOSSJS_CORE_LIB_NAME "kossjs")
# 添加头文件
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/third_party/KossJS/include
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-omit-frame-pointer")

add_library(${KOSSJS_CORE_LIB_NAME} SHARED IMPORTED)

add_library(kossjs_flutter SHARED
        "kossjs_flutter.c"
)

if(CMAKE_SYSTEM_NAME MATCHES "OHOS" OR OHOS)
  # 源
  set(OHOS_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/KossJS/libs/harmony_lib/${OHOS_ARCH})
  set(OHOS_LIB_DIR_SO ${OHOS_LIB_DIR}/lib${KOSSJS_CORE_LIB_NAME}.so)
  # 目的地
  set(OHOS_DEFAULT_LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ohos/libs/${OHOS_ARCH})
  set(OHOS_DEFAULT_LIBS_DIR_SO ${OHOS_DEFAULT_LIBS_DIR}/lib${KOSSJS_CORE_LIB_NAME}.so)

  # 拷贝
  add_custom_command(
          OUTPUT ${OHOS_DEFAULT_LIBS_DIR_SO}
          # 创建目录
          COMMAND ${CMAKE_COMMAND} -E make_directory "${OHOS_DEFAULT_LIBS_DIR}"
          #拷贝
          COMMAND ${CMAKE_COMMAND} -E copy "${OHOS_LIB_DIR_SO}" "${OHOS_DEFAULT_LIBS_DIR}"
          DEPENDS ${OHOS_LIB_DIR_SO}
          COMMENT "Copying libkossjs lib"
  )

  add_custom_target(copy_kossjs_lib ALL
          DEPENDS ${OHOS_DEFAULT_LIBS_DIR_SO}
  )

  add_dependencies(kossjs_flutter copy_kossjs_lib)

  # 设置导入规则
  set_target_properties(${KOSSJS_CORE_LIB_NAME} PROPERTIES
    IMPORTED_NO_SONAME TRUE
    IMPORTED_LOCATION ${OHOS_DEFAULT_LIBS_DIR_SO}
  )
elseif(ANDROID)
  # 源
  set(ANDROID_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/KossJS/libs/android_lib/${ANDROID_ABI})
  set(ANDROID_LIB_DIR_SO ${ANDROID_LIB_DIR}/lib${KOSSJS_CORE_LIB_NAME}.so)
  # 目的地
  set(ANDROID_DEFAULT_LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../android/src/main/jniLibs/${ANDROID_ABI})
  set(ANDROID_DEFAULT_LIBS_DIR_SO ${ANDROID_DEFAULT_LIBS_DIR}/lib${KOSSJS_CORE_LIB_NAME}.so)

  # 拷贝
  add_custom_command(
          OUTPUT ${ANDROID_DEFAULT_LIBS_DIR_SO}
          # 创建目录
          COMMAND ${CMAKE_COMMAND} -E make_directory "${ANDROID_DEFAULT_LIBS_DIR}"
          #拷贝
          COMMAND ${CMAKE_COMMAND} -E copy "${ANDROID_LIB_DIR_SO}" "${ANDROID_DEFAULT_LIBS_DIR}"
          DEPENDS ${ANDROID_LIB_DIR_SO}
          COMMENT "Copying libkossjs lib"
  )

  add_custom_target(copy_kossjs_lib ALL
          DEPENDS ${ANDROID_DEFAULT_LIBS_DIR_SO}
  )

  add_dependencies(kossjs_flutter copy_kossjs_lib)

  # 设置导入规则
  set_target_properties(${KOSSJS_CORE_LIB_NAME} PROPERTIES
    IMPORTED_NO_SONAME TRUE
    IMPORTED_LOCATION ${ANDROID_DEFAULT_LIBS_DIR_SO}
  )
elseif(WIN32)
  # 判断架构
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(WIN_ABI_NAME x64)
  else()
    set(WIN_ABI_NAME x86)
  endif()

  # 源
  set(WIN_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/KossJS/libs/win_lib/${WIN_ABI_NAME})
  set(WIN_LIB_DIR_DLL ${WIN_LIB_DIR}/${KOSSJS_CORE_LIB_NAME}.dll)
  set(WIN_LIB_DIR_DLL_LIB ${WIN_LIB_DIR}/${KOSSJS_CORE_LIB_NAME}.dll.lib)
  # 目的地
  set(WIN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/runner/Debug)
  set(WIN_OUTPUT_DIR_DLL ${WIN_OUTPUT_DIR}/${KOSSJS_CORE_LIB_NAME}.dll)

  message(WARNING "${M_TAG}:WIN_OUTPUT_DIR:${WIN_OUTPUT_DIR}")

  # 拷贝
  add_custom_command(
          OUTPUT ${WIN_OUTPUT_DIR_DLL}
          # 创建目录
          COMMAND ${CMAKE_COMMAND} -E make_directory "${WIN_OUTPUT_DIR}"
          #拷贝
          COMMAND ${CMAKE_COMMAND} -E copy "${WIN_LIB_DIR_DLL}" "${WIN_OUTPUT_DIR}"
          DEPENDS ${WIN_LIB_DIR_DLL}
          COMMENT "Copying libkossjs lib"
  )

  add_custom_target(copy_kossjs_lib ALL
          DEPENDS ${WIN_OUTPUT_DIR_DLL}
  )

  add_dependencies(kossjs_flutter copy_kossjs_lib)

  # 设置导入规则,包括lib
  set_target_properties(${KOSSJS_CORE_LIB_NAME} PROPERTIES
    IMPORTED_NO_SONAME TRUE
    IMPORTED_LOCATION "${WIN_LIB_DIR_DLL}"
    IMPORTED_IMPLIB "${WIN_LIB_DIR_DLL_LIB}"
  )

elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
elseif(APPLE)
  if(CMAKE_SYSTEM_NAME MATCHES "iOS")
    message(WARNING "Compiling: iOS")
  else()
    message(WARNING "Compiling: macOS")
  endif()
else()
  message(WARNING "Compiling err: ${CMAKE_SYSTEM_NAME}")
endif()


set_target_properties(kossjs_flutter PROPERTIES
  PUBLIC_HEADER kossjs_flutter.h
  OUTPUT_NAME "kossjs_flutter"
)

target_compile_definitions(kossjs_flutter PUBLIC DART_SHARED_LIB)

#链接core
target_link_libraries(kossjs_flutter ${KOSSJS_CORE_LIB_NAME})

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(kossjs_flutter PRIVATE "-Wl,-z,max-page-size=16384")
endif()
