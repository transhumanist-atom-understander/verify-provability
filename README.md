# verify-provability

Lean checks what a tableau of
[decide-provability](https://github.com/transhumanist-atom-understander/decide-provability)
shows, with [`ProvabilityLogic`](https://github.com/FormalizedFormalLogic/ProvabilityLogic):
that its sentence is in `LogicGL` if it closed, by the derivation it is in the labelled
sequent calculus `G3KGL`, and that it is not if a branch stayed open, by the finite Kripke
countermodel the branch describes. It is a Lean library, `GLVerify`, and a server, `verify`,
that the Python package `gltableau` of
[wrap-provability](https://github.com/transhumanist-atom-understander/wrap-provability) runs;
use it from there. It depends on `decide-provability` and on `ProvabilityLogic`, hence on
Mathlib, which is why it is a project of its own: the decider builds in seconds without it.

    $ lake exe cache get   # Mathlib's prebuilt artifacts
    $ lake build           # then Foundation and ProvabilityLogic, from source: slow, once

`lake-manifest.json` pins the commit of `decide-provability` that is built against; after
the decider changes, `lake update decide-provability` moves it to the head of `main`.

`verify` is the server of `decide-provability`, `Tableau.serve`, with `GLVerify` loaded in
place of `GLTableau`, so it answers the same requests: `{"lean": source}` with `{"output": ...,
"errors": ...}`, what the `#eval`s of the Lean file `source` print, and Lean's errors, with
the file's own `import`s ignored. Loading `GLVerify` takes a couple of seconds, most of it
Mathlib; each request then takes a fraction of a second. So the tableau that the Lean file
`t.lean` of the decider defines is checked by sending the file with
`theorem proof : t.verdict := t.verified` added: Lean's kernel evaluates the tableau's
certificate, and the theorem is rejected if the rules were misapplied. The same file checks on
its own in this project, after `lake env lean t.lean`, with its header changed to
`import GLVerify`.

## Files

- `GLVerify.lean`: a tableau as a derivation in `G3KGL`, an open branch as a countermodel, and
  the theorem `Tableau.verified` that Lean's kernel proves by evaluating them.
- `Main.lean`: the server `verify`.
