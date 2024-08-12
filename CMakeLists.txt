cmake_minimum_required (VERSION 3.5)
project (skt)
set (skt_version_major 2)
set (skt_version_minor 2)
set (skt_version_micro 4)
set (skt_version "${skt_version_major}.${skt_version_minor}.${skt_version_micro}")

set (SKT_DEBUG_LEVEL "0" CACHE STRING "SKT debug level")

add_definitions (-DDEBUG=${SKT_DEBUG_LEVEL})
if (MSVC)
  add_definitions (-D_CRT_SECURE_NO_WARNINGS=1)
endif (MSVC)

add_executable(skt skt.c)
set_target_properties(skt PROPERTIES
  VERSION "${skt_version}"
)

install (TARGETS skt RUNTIME)
install (FILES "${PROJECT_SOURCE_DIR}/README.md" TYPE DOC)
if (WIN32)
  set (CPACK_PACKAGE_VERSION "${skt_version}")
  set (CPACK_BINARY_ZIP ON)
  set (CPACK_BINARY_NSIS OFF)
  include(CPack)
endif (WIN32)

enable_testing()
add_test(NAME "skt"
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  COMMAND "${CMAKE_CURRENT_BINARY_DIR}/skt" "${CMAKE_CURRENT_SOURCE_DIR}/sktdoc.skt" "${CMAKE_CURRENT_BINARY_DIR}/sktdoc.tex")

add_test(NAME "output-buffer-move"
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  COMMAND "${CMAKE_CURRENT_BINARY_DIR}/skt" "${CMAKE_CURRENT_SOURCE_DIR}/tests/copyright.skt" "copyright.tex")
