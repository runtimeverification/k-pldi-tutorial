module CHANGE-SYNTAX
  imports UNSIGNED-INT-SYNTAX

  syntax Pgm ::= "change" Int
endmodule

module CHANGE
  imports INT
  imports MAP
  imports LIST
  imports CHANGE-SYNTAX

  rule change I => makeChange(I)

  syntax Map ::=  makeChange(Int)             [function]
               | #makeChange(Int, List, Map)  [function]

  syntax List ::= #available() [function]
  rule #available() =>
    ListItem(100)
    ListItem(25)
    ListItem(10)
    ListItem(1)

  rule makeChange(X) => #makeChange(X, #available(), .Map)

  rule #makeChange(X, ListItem(C) Rest, M) =>
       #let Existing = M [ C ] orDefault 0 #in
       #makeChange(
         X -Int C,
         ListItem(C) Rest,
         M [ C <- {Existing}:>Int +Int 1 ])
    requires X >=Int C

  rule #makeChange(X, ListItem(C) Rest, M) =>
       #makeChange(X, Rest, M)
    requires X <Int C

  rule #makeChange(0, .List, M) => M
endmodule
