module PLDI-IMP-VALUE-SYNTAX
  imports UNSIGNED-INT-SYNTAX
  imports STRING-SYNTAX
  imports BOOL-SYNTAX

  syntax Value    ::= "(" ")"
                    | Int
                    | Bool
                    | String
endmodule

module PLDI-IMP-EXPR-SYNTAX
  imports PLDI-IMP-VALUE-SYNTAX
  imports ID-SYNTAX

  syntax Args     ::= List{Expr, ","}

  syntax Expr     ::= Value
                    | Id
                    | Id "(" Args ")"
                    | "(" Expr ")" [bracket]

  syntax Expr     ::= "-" Expr      [group(unary), strict, non-assoc]
                    | Expr "*" Expr [group(mul), strict, left]
                    | Expr "/" Expr [group(mul), strict, left]
                    | Expr "+" Expr [group(add), strict, left]
                    | Expr "-" Expr [group(add), strict, left]

  syntax Expr     ::= Expr "==" Expr [group(bool),   strict, non-assoc]
                    | Expr "!=" Expr [group(bool),  strict, non-assoc]
                    | Expr ">=" Expr [group(bool), strict, non-assoc]
                    | Expr ">"  Expr [group(bool),   strict, non-assoc]
                    | Expr "<=" Expr [group(bool), strict, non-assoc]
                    | Expr "<"  Expr [group(bool),   strict, non-assoc]

  syntax Expr     ::= #balance(Expr)    [strict]
                    | #send(Expr, Expr) [strict]
endmodule

module PLDI-IMP-STMT-SYNTAX
  imports PLDI-IMP-EXPR-SYNTAX

  syntax Stmt     ::= Expr ";"
                    | Stmt Stmt [right, group(seq)]
                    | "if" "(" Expr ")" Stmt "else" Stmt [group(control),     strict(1)]
                    | "if" "(" Expr ")"                  [group(control), avoid]
                    | "while" "(" Expr ")" Stmt          [group(control)]
                    | "return" Expr ";"                  [group(control), strict]
                    | "return" ";"
                    | Id "=" Expr ";"       [group(control), strict(2)]
                    | "assert" Expr ";" [strict]

  syntax Block    ::= "{" Stmt "}" | "{" "}"
  syntax Stmt     ::= Block
endmodule

module PLDI-IMP-SYNTAX
  imports PLDI-IMP-STMT-SYNTAX

  syntax Param    ::= Id
  syntax Params   ::= List{Param, ","}
  syntax FunDecl  ::= "fn" Id "(" Params ")" Block

  syntax Decl     ::= FunDecl
  syntax Decls    ::= NeList{Decl, ""} [prefer]
  syntax Pgm      ::= Decls

  syntax priorities unary > mul > add > bool > control > seq
endmodule

module PLDI-IMP-EXPR
  imports PLDI-IMP-CONFIGURATION
  imports PLDI-IMP-EXPR-SYNTAX
  imports INT
  imports BOOL

  rule
    <k> X:Id => V ...</k>
    <env> X |-> V ...</env>

  rule   - X => 0 -Int X

  rule X + Y => X +Int Y
  rule X - Y => X -Int Y
  rule X * Y => X *Int Y
  rule X / Y => X /Int Y

  rule B1 == B2 => B1 ==Bool B2
  rule I1 == I2 => I1 ==Int I2

  rule B1 != B2 => B1 =/=Bool B2
  rule I1 != I2 => I1 =/=Int  I2

  rule I1 >= I2 => I1 >=Int I2
  rule I1 >  I2 => I1 >Int  I2
  rule I1 <= I2 => I1 <=Int I2
  rule I1 <  I2 => I1 <Int  I2
endmodule

module PLDI-IMP-CALL-STMT
  imports PLDI-IMP-CONFIGURATION
  imports PLDI-IMP-STMT-SYNTAX

  syntax KItem ::= frame(K, Map)
                 | #return(Value)

  rule
    <k> (X (AS) ~> Rest) => bind(AS, PS) ~> Body ~> #return(()) </k>
    <stack>  .List => ListItem(frame(Rest, E)) ...</stack>
    <env> E </env>
    <function-id>     X    </function-id>
    <function-params> PS   </function-params>
    <function-body>   Body </function-body>

  syntax KItem ::= bind(args: Args, names: List)
                 | bindArg(arg: Expr, name: Id) [strict(1)]

  rule
    <k> bind(.Args, .List) => . ...</k>
    <args> AS => .Map </args>
    <env> _ => AS </env>

  rule bind(E , AS:Args, ListItem(X) XS) => bindArg(E, X) ~> bind(AS, XS)

  rule
    <k> bindArg(V:Value, X) => . ...</k>
    <args> E => E [ X <- V ] </args>

  rule <k> V               => #return(V) </k>
  rule <k> (return V ; ~> _) => #return(V) </k>

  rule _:Value => . [owise]

  rule return ; => return () ;

  rule
    <k> #return(V) => V ~> F </k>
    <stack> ListItem(frame(F, E)) => .List ...</stack>
    <env> _ => E </env>

  rule
    <k> #return(V) => . ... </k>
    <stack> .List </stack>
    <exit-code> _ => V </exit-code>
endmodule

module PLDI-IMP-CONTROL-STMT
  imports PLDI-IMP-CONFIGURATION

  rule if ( C ) E => if ( C ) E else {}

  rule if ( true  ) E1 else _  => E1
  rule if ( false ) _  else E2 => E2

  rule
    while ( C ) E
    => if ( C ) { 
        E
        while ( C ) E 
       } else {}

  rule assert true ; => .
  rule
    <k> (assert false ; ~> _) => . </k>
    <exit-code> _ => 1 </exit-code>
endmodule

module PLDI-IMP-PRINT-STMT
  imports PLDI-IMP-STMT-SYNTAX
  imports STRING

  syntax K ::= #print(String) [function, total, hook(PLDI.log)]

  syntax Id ::= "print" [token]
  rule print(S) ; => #print(S) [priority(40)]
endmodule

module PLDI-IMP-BALANCE-EXPR
  imports PLDI-IMP-CONFIGURATION
  imports INT

  syntax KItem ::= #setBalance(addr: Int, balance: Int)
  rule
    <k> #setBalance(Addr, Balance) => Balance ...</k>
    <balances> BM => BM [ Addr <- Balance ] </balances>

  rule
    <k> #balance(Addr) => BM [ Addr ] ...</k>
    <balances> BM </balances>
    requires Addr in_keys(BM)
  rule #balance(_) => 0 [owise]

  rule #send(0, _) => 0

  rule
    <k>
      #send(Addr:Int, Amount) => #setBalance(Addr, maxInt(B +Int Amount, 0))
      ...
    </k>
    <balances> Addr |-> B ...</balances>
    requires Addr =/=Int 0

  rule #send(Addr:Int, Amount) => #setBalance(Addr, maxInt(Amount, 0))
  [owise]
endmodule

module PLDI-IMP-STMT
  imports PLDI-IMP-CALL-STMT
  imports PLDI-IMP-CONTROL-STMT
  imports PLDI-IMP-PRINT-STMT
  imports PLDI-IMP-BALANCE-EXPR

  rule
    <k> X = V:Value ; => . ...</k>
    <env> E => E [ X <- V ] </env>

  rule E:Expr ; => E
  rule { E } => E
  rule {} => .
  rule S1:Stmt S2:Stmt => S1 ~> S2
endmodule

module PLDI-IMP-CONFIGURATION
  imports PLDI-IMP-SYNTAX
  imports LIST
  imports MAP

  syntax Id       ::= "dummy" [token]
                    | "main"  [token]

  configuration
    <k> $PGM:Pgm ~> main(.Args) </k>
    <exit-code> 0 </exit-code>
    <stack>     .List </stack>
    <env>       .Map  </env>
    <args>      .Map  </args>
    <balances>  .Map  </balances>
    <functions>
      <function multiplicity="*" type="Map">
        <function-id>     dummy </function-id>
        <function-params> .List </function-params>
        <function-body>   .K    </function-body>
      </function>
    </functions>
endmodule

module PLDI-IMP
  imports PLDI-IMP-CONFIGURATION
  imports PLDI-IMP-EXPR
  imports PLDI-IMP-STMT
  imports DOMAINS

  rule
    <k> fn X (PS) Body => . ...</k>
    <functions>
      (.Bag =>
        <function>
          <function-id> X </function-id>
          <function-params> paramNames(PS) </function-params>
          <function-body> Body </function-body>
        </function>
      )
      ...
    </functions>

  syntax List ::= paramNames(Params) [function]
  rule paramNames(.Params) => .List
  rule paramNames(X , PS) => ListItem(X) paramNames(PS)

  rule D:Decl DS => D ~> DS
  rule .Decls => .K

  syntax Bool ::= isKResult(Expr) [symbol, function]
  rule isKResult(_:Value) => true
  rule isKResult(_) => false [owise]
endmodule
