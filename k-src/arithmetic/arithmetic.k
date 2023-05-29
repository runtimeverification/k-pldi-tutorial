module ARITHMETIC-SYNTAX
  imports UNSIGNED-INT-SYNTAX

  syntax Exp ::= Int
               | "-" Exp      [group(neg), strict]
               | Exp "+" Exp  [left, group(add), strict]
               | Exp "-" Exp  [left, group(sub), strict]
               | Exp "*" Exp  [left, group(mul), strict]
               | Exp "/" Exp  [left, group(div), strict]
               | "(" Exp ")"  [bracket]

  syntax priorities neg > mul div > add sub
endmodule

module ARITHMETIC
  imports ARITHMETIC-SYNTAX
  imports INT

  rule - I => 0 -Int I
  rule A + B => A +Int B
  rule A - B => A -Int B
  rule A * B => A *Int B
  rule A / B => A /Int B

  syntax KResult ::= Int
endmodule
