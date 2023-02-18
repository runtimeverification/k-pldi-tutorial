module ARITHMETIC-SYNTAX
  imports UNSIGNED-INT-SYNTAX

  syntax Exp ::= Int
               | "-" Exp      [neg]
               | "(" Exp ")"  [bracket]
               | Exp "+" Exp  [add]
               | Exp "-" Exp  [sub]
               | Exp "*" Exp  [mul]
               | Exp "/" Exp  [div]

  syntax priorities neg > mul div > add sub
  syntax left       mul div
  syntax left       add sub
  syntax non-assoc  neg
endmodule

module ARITHMETIC-EVAL
  imports ARITHMETIC-SYNTAX
  imports INT

  syntax Int ::= eval(Exp) [function]
  rule eval(I:Int) => I
  rule eval(- I)   => 0 -Int eval(I)
  rule eval(A + B) => eval(A) +Int eval(B)
  rule eval(A - B) => eval(A) -Int eval(B)
  rule eval(A * B) => eval(A) *Int eval(B)
  rule eval(A / B) => eval(A) /Int eval(B)
endmodule
