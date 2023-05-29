module ARITHMETIC-EVAL-SYNTAX
  imports UNSIGNED-INT-SYNTAX

  syntax Exp ::= Int
               | "-" Exp      [non-assoc, group(neg)]
               | Exp "+" Exp  [left, group(add)]
               | Exp "-" Exp  [left, group(sub)]
               | Exp "*" Exp  [left, group(mul)]
               | Exp "/" Exp  [left, group(div)]
               | "(" Exp ")"  [bracket]

  syntax priorities neg > mul div > add sub
endmodule

module ARITHMETIC-EVAL
  imports ARITHMETIC-EVAL-SYNTAX
  imports INT

  syntax Int ::= eval(Exp) [function]
  rule eval(X:Int) => X
  rule eval(- E) => 0 -Int eval(E)
  rule eval(E1 + E2) => eval(E1) +Int eval(E2)
  rule eval(E1 - E2) => eval(E1) -Int eval(E2)
  rule eval(E1 * E2) => eval(E1) *Int eval(E2)
  rule eval(E1 / E2) => eval(E1) /Int eval(E2)
endmodule
