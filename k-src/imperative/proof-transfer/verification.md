```k
require "../pldi-imp.k"

module VERIFICATION
  imports PLDI-IMP
  imports INT

  syntax Id ::= "from"      [token]
              | "to"        [token]
              | "amount"    [token]
              | "transfer"  [token]
              | "$s"        [token]
              | "$n"        [token]
```

```{.k .lemmas}
  rule A +Int (0 -Int B) => A -Int B
    [simplification]

  rule maxInt(A +Int B, 0) => A +Int B
    requires A >=Int 0 andBool B >=Int 0
    [simplification]

  rule {(A +Int (B +Int C)) #Equals (D +Int B)}
    => {(A +Int         C)  #Equals  D}
    [simplification]
```

```k
endmodule
```
