#!/usr/bin/env bash
set -ex

mkdir -p .build

kompile -v k-src/basic/colors.k -o .build/colors
kompile -v k-src/basic/change.k -o .build/colors

kompile -v k-src/arithmetic/arithmetic.k -o .build/arithmetic
kompile -v k-src/arithmetic/arithmetic-eval.k -o .build/arithmetic-eval
kompile -v k-src/arithmetic/arithmetic-vars.k -o .build/arithmetic-vars

kompile -v k-src/imperative/control-flow.k
kompile -v k-src/imperative/imp-balance.md

kompile -v k-src/imperative/pldi-imp.k  \
  -ccopt k-src/imperative/hooks.cpp     \
  --hook-namespaces PLDI                \
  -o .build/pldi-imp

kompile -v k-src/imperative/proof-basic/verification.k  \
  --backend haskell                                     \
  -o .build/proof-basic

kprove                                \
  --definition .build/proof-basic     \
  k-src/imperative/proof-basic/spec.k

kompile -v k-src/imperative/proof-transfer/verification.md  \
  --backend haskell                                         \
  -o .build/proof-transfer

kprove                                    \
  --definition .build/proof-transfer      \
  k-src/imperative/proof-transfer/working-spec.k
