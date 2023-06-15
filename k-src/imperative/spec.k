require "verification.k"

module SPEC
  imports VERIFICATION

  claim
    <k> 1 + 1 => 2 </k>

  claim
    <k> if (A < B) { A } else { B } => minInt(A, B) </k>

  claim
    <k>
      while($n > 0) {
        $n = $n - 1
      } => ()
    </k>
    <env> $n |-> (N => 0) </env>
    requires N >=Int 0

  claim
    <k>
      if ($n < 0) {
        $n = -$n
      } else { () };

      while($n > 0) {
        $n = $n - 1
      } => ()
    </k>
    <env> $n |-> (_:Int => 0) </env>
endmodule
