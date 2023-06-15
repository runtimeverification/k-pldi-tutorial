require "verification.k"

module SPEC
  imports VERIFICATION

  claim
    <k> 1 + 1 => 2 </k>

  claim
    <k> if (A < B) { $n = A; } else { $n = B; } => . </k>
    <env> $n |-> (_:Int => minInt(A, B)) </env>

  claim
    <k> $n = $n - 1; => . </k>
    <env> $n |-> (N => N -Int 1) </env>

  claim
    <k>
      while($n > 0) {
        $n = $n - 1;
      } => .
    </k>
    <env> $n |-> (N => 0) </env>
    requires N >=Int 0

  claim
    <k>
      if ($n < 0) {
        $n = -$n;
      } else {}

      while($n > 0) {
        $n = $n - 1;
      } => .
    </k>
    <env> $n |-> (_:Int => 0) </env>

  claim
    <k>
      while ($n > 0) {
        $s = $s + $n;
        $n = $n - 1;
      } => .
    </k>
    <env>
      $n |-> (N => 0)
      $s |-> (S => S +Int ((N *Int (N +Int 1)) /Int 2))
    </env>
    requires N >=Int 0

  claim
    <k>
      $n = N;
      $s = 0;

      while ($n > 0) {
        $s = $s + $n;
        $n = $n - 1;
      } => .
    </k>
    <env> .Map =>
      $n |-> 0
      $s |-> ((N *Int (N +Int 1)) /Int 2)
    </env>
    requires N >=Int 0
endmodule
