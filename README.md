# From Zero to Proving: Building Your First Language with the K Framework

This repository contains the demonstration code and presenter notes for the PLDI
2023 tutorial session "_From Zero To Proving: Building Your First Language with
the K Framework_". It is intended primarily for use as reference material by an
experienced K user presenting the tutorial, but may also be of interest to
attendees of the tutorial looking to follow along with the material.

## Overview

The K Framework is a set of tools for building _mechanised operational
semantics_ of programming languages. By writing down a single description of
your language's syntax and semantics, K helps you generate a full set of useful
tools for working with programs written in your language. For example, straight
out of the box, K provides you with a fast interpreter and a powerful symbolic
execution engine.

At Runtime Verification, we have developed K over a number of years to be a
commercially viable tool for our business needs, and it's grown from its
original roots as a research prototype into an extremely useful tool for anyone
who works with programming languages in some respect. We've built semantics for
a number of real-world languages: C, WebAssembly and the Ethereum virtual
machine, among others.

This tutorial session aims to give you an idea of what writing K code and
defining language semantics looks like, and to introduce you to enough of the K
toolchain that you can begin to think about developing your own semantics in K.
I hope to keep things reasonably interactive, and aim for attendees to be able
to follow along with the demonstrations in the tutorial.

## Attendee Information

The tutorial will be held from **9am - 12:30pm** on **Saturday 17th June**, in
the **Magnolia 17** room. Full event details are on the PLDI
[conference page][researchr].

Please feel free to get in touch with me ahead of the tutorial; you can email me
directly at
[bruce.collie@runtimeverification.com](mailto:bruce.collie@runtimeverification.com),
or contact the K development team at Runtime Verification through our
[public support channels][support].

## Getting Started

The easiest way to install K for use with this tutorial is to use the `kup`
tool, which provides a [one-click install][kup-install] for K. From the root of
this repository, run:
```console
$ bash <(curl https://kframework.org/install)
$ kup install k --version v$(cat deps/k_release)
```

You can verify that you have installed K correctly by running:
```console
$ kompile --version
K version:    v5.6.73
Build date:   Fri Apr 28 16:19:26 BST 2023
```

The precise version number and build date depend on the state of this
repository, and so may not match your installation.

If you have any difficulties installing K using these instructions, please get
in touch with me via the instructions above.

## Tutorial Structure

The tutorial will be split into two sessions, in which I will roughly aim to
cover the following topics:

### Session 1 (Basics & Concrete Execution): 9-11am

* Introduction to mechanised semantics and the K Framework.
* Defining concrete syntax and parsing programs with K
* Term rewriting systems for semantics
* Basic functional programming in K
* Example: arithmetic calculator
* Developing an imperative language in K

### Session 2 (Symbolic Execution & Proving): 11:20am-12:30pm

* Writing K specifications
* Extending our language for proving
* Verifying a transfer function
* Loop invariants

If time permits, we may also cover:
* More advanced K scripting, including summarization and proof tactics
* Real-world K project setup and development
* Extending K with native code

[kup-install]: https://github.com/runtimeverification/k#quick-start
[researchr]: https://pldi23.sigplan.org/details/pldi-2023-tutorials/5/From-Zero-to-Proving-Building-Your-First-Language-with-the-K-Framework
[support]: https://kframework.org/
