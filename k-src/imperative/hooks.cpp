// clang-format off
#include <cstddef>
// clang-format on

#include <runtime/alloc.h>
#include <runtime/header.h>

#include <cstdint>
#include <iostream>
#include <string>

__attribute__((always_inline)) static uintptr_t get_tag(char const *symbol) {
  return (static_cast<uintptr_t>(getTagForSymbolName(symbol)) << 32) | 1;
}

__attribute__((always_inline)) static block *dot_k() {
  return (block *)(void *)(get_tag("dotk{}"));
}

__attribute__((always_inline)) static std::string k_string_to_cpp(
    SortString s) {
  return std::string(s->data, len(s));
}

extern "C" block *hook_PLDI_log(SortString msg) {
  std::cerr << k_string_to_cpp(msg) << '\n';
  return dot_k();
}
