module ARITHMETIC-SYNTAX
  imports UNSIGNED-INT-SYNTAX

  syntax Exp ::= Int
               | "-" Exp      [neg, strict]
               | "(" Exp ")"  [bracket]
               | Exp "+" Exp  [add, strict]
               | Exp "-" Exp  [sub, strict]
               | Exp "*" Exp  [mul, strict]
               | Exp "/" Exp  [div, strict]

  syntax priorities neg > mul div > add sub
  syntax left       mul div
  syntax left       add sub
  syntax non-assoc  neg
endmodule

module ARITHMETIC
  imports ARITHMETIC-SYNTAX
  imports INT
  imports BOOL

  rule - I   => 0 -Int I
  rule A + B => A +Int B
  rule A - B => A -Int B
  rule A * B => A *Int B
  rule A / B => A /Int B

  syntax Bool ::= isKResult(K) [symbol, function]
  rule isKResult(_::Int) => true
  rule isKResult(_)      => false [owise]
endmodule
