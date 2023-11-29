module COLORS-SYNTAX
  syntax Color ::= Yellow() | Blue()
  syntax Fruit ::= Banana() | Blueberry()

  syntax Color ::= colorOf(Fruit) [function]
endmodule

module COLORS
  imports COLORS-SYNTAX

  rule colorOf(Banana()) => Yellow()
  rule colorOf(Blueberry()) => Blue()
endmodule
