module ARITHMETIC-VARS-SYNTAX
  imports UNSIGNED-INT-SYNTAX
  imports ID-SYNTAX

  syntax Exp ::= Int
               | Id
               | "-" Exp      [group(neg), strict]
               | Exp "+" Exp  [left, group(add), strict]
               | Exp "-" Exp  [left, group(sub), strict]
               | Exp "*" Exp  [left, group(mul), strict]
               | Exp "/" Exp  [left, group(div), strict]
               | "(" Exp ")"  [bracket]

  syntax Stmt ::= Id "=" Exp ";"  [strict(2)]
  syntax Stmts ::= List{Stmt, ""}

  syntax Pgm ::= Stmts Exp

  syntax priorities neg > mul div > add sub
endmodule

module ARITHMETIC-VARS
  imports ARITHMETIC-VARS-SYNTAX
  imports INT

  configuration
    <k> $PGM:Pgm </k>
    <env> .Map </env>

  rule S:Stmts E:Exp => S ~> E
  rule S:Stmt Rest:Stmts => S ~> Rest
  rule .Stmts => .

  rule
    <k> X = V ; => . ...</k>
    <env> M => M [ X <- V ] </env>

  rule
    <k> X:Id => V ...</k>
    <env> X |-> V ...</env>

  rule - I => 0 -Int I
  rule A + B => A +Int B
  rule A - B => A -Int B
  rule A * B => A *Int B
  rule A / B => A /Int B

  syntax KResult ::= Int
endmodule
