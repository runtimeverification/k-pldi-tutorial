module WORKING-SPEC
  imports VERIFICATION

  claim
    <k>
      fn transfer(from, to, amount) {
        #send(from, -amount);
        #send(to,    amount);
      }

      fn main(.Params) {
        transfer(1, 2, N:Int);
        return #balance(1) + #balance(2);
      }

      ~> main ( .Args )
      => .
    </k>

    <exit-code>
      _ => B1 +Int B2
    </exit-code>

    <balances>
      1 |-> (B1 => ?_)
      2 |-> (B2 => ?_)
    </balances>

    <stack>     .List   </stack>
    <env>       .Map    </env>
    <args>      .Map    </args>
    <functions> _ => ?_ </functions>

  requires  B1 >=Int 0
    andBool B2 >=Int 0
    andBool N  >=Int 0
    andBool B1 >=Int N
endmodule
