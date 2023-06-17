#include <runtime/header.h>

#include <iostream>
#include <string>

extern "C" block *hook_PLDI_log(SortString msg) {
  std::cerr << std::string(msg->data, len(msg)) << '\n';
  return dot_k();
}
