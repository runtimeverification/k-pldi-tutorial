# From Zero to Proving: Building Your First Language with the K Framework

This repository contains the demonstration code and presenter notes for the PLDI
2023 tutorial session "_From Zero To Proving: Building Your First Language with
the K Framework_". It is intended primarily for use as reference material by an
experienced K user presenting the tutorial, but may also be of interest to
attendees of the tutorial looking to follow along with the material.

## Getting Started

The easiest way to install K for use with this tutorial is to use the `kup`
tool, which provides a [one-click install][kup-install] for K:
```console
$ bash <(curl https://kframework.org/install)
$ kup install k --version v$(cat deps/k_release)
```

## Structure

The structure of this repository is roughly as follows:

[kup-install]: https://github.com/runtimeverification/k#quick-start
