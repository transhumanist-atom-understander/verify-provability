import GLTableau.Server

/-- The server `verify`: `Tableau.serve` of `decide-provability` with `GLVerify` imported, so
the Lean files it runs can prove their tableaux's verdicts with `Tableau.verified`. -/
unsafe def main : IO Unit := Tableau.serve #[`GLVerify]
