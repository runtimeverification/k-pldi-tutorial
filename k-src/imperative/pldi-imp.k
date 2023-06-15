module PLDI-IMP-SYNTAX
  imports ID-SYNTAX
  imports UNSIGNED-INT-SYNTAX
  imports STRING-SYNTAX
  imports BOOL

  syntax Value    ::= "(" ")"
                    | Int
                    | Bool
                    | String

  syntax Expr     ::= Value
                    | Id
                    | Id "(" Args ")"
                    | "(" Expr ")" [bracket]

  syntax Stmt     ::= Expr ";"
                    | Stmt Stmt [seq, right]

  syntax Expr     ::= "-" Expr      [neg, strict, non-assoc]
                    | Expr "*" Expr [mul, strict, left]
                    | Expr "/" Expr [div, strict, left]
                    | Expr "+" Expr [add, strict, left]
                    | Expr "-" Expr [sub, strict, left]

  syntax Expr     ::= Expr "==" Expr [eq,   strict, non-assoc]
                    | Expr "!=" Expr [neq,  strict, non-assoc]
                    | Expr ">=" Expr [gteq, strict, non-assoc]
                    | Expr ">"  Expr [gt,   strict, non-assoc]
                    | Expr "<=" Expr [lteq, strict, non-assoc]
                    | Expr "<"  Expr [lt,   strict, non-assoc]

  syntax Stmt     ::= "if" "(" Expr ")" Stmt "else" Stmt [if,     strict(1)]
                    | "while" "(" Expr ")" Stmt          [while]
                    | "return" Expr ";"                  [return, strict]
                    | "return" ";"

  syntax Stmt     ::= Id "=" Expr ";"       [assign, strict(2)]

  syntax Stmt     ::= "assert" Expr ";" [strict]

  syntax Args     ::= List{Expr, ","}

  syntax Block    ::= "{" Stmt "}" | "{" "}"
  syntax Stmt     ::= Block [block]

  syntax Param    ::= Id
  syntax Params   ::= List{Param, ","}
  syntax FunDecl  ::= "fn" Id "(" Params ")" Block

  syntax Decl     ::= FunDecl
  syntax Decls    ::= NeList{Decl, ""} [prefer]
  syntax Pgm      ::= Decls

  syntax priorities neg > mul div > add sub > eq neq gteq gt lteq lt > if while assign > seq
endmodule

module PLDI-IMP
  imports PLDI-IMP-SYNTAX
  imports LIST
  imports INT
  imports MAP
  imports STRING

  syntax Id       ::= "dummy" [token]
                    | "main"  [token]

  configuration
    <k> $PGM:Pgm ~> main(.Args) </k>
    <exit-code> 0 </exit-code>
    <stack>     .List </stack>
    <env>       .Map  </env>
    <args>      .Map  </args>
    <functions>
      <function multiplicity="*" type="Map">
        <function-id>     dummy </function-id>
        <function-params> .List </function-params>
        <function-body>   .K    </function-body>
      </function>
    </functions>

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

  rule E:Expr ; => E
  rule { E } => E
  rule {} => .

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

  rule S1:Stmt S2:Stmt => S1 ~> S2

  rule
    <k> X = V:Value ; => . ...</k>
    <env> E => E [ X <- V ] </env>

  rule
    <k> X:Id => V ...</k>
    <env> X |-> V ...</env>

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

  syntax KItem ::= frame(K, Map)

  syntax K ::= #log(String) [function, total, hook(PLDI.log)]

  syntax Id ::= "log" [token]
  rule log(S) ; => #log(S) [priority(40)]

  rule
    <k> (X (AS) ~> Rest) => bind(AS, PS) ~> Body ~> #return(()) </k>
    <stack>  .List => ListItem(frame(Rest, E)) ...</stack>
    <env> E </env>
    <function-id>     X    </function-id>
    <function-params> PS   </function-params>
    <function-body>   Body </function-body>

  syntax KItem ::= #return(Value)

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

  syntax Bool ::= isKResult(Expr) [symbol, function]
  rule isKResult(_:Value) => true
  rule isKResult(_) => false [owise]
endmodule
