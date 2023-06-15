require "pldi-imp.k"

module VERIFICATION-SYNTAX
endmodule

module VERIFICATION
  imports VERIFICATION-SYNTAX
  imports PLDI-IMP

  syntax Id ::= "$n" [token]
              | "$s" [token]
endmodule
