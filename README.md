# verify-provability

Lean checks what a tableau of
[decide-provability](https://github.com/transhumanist-atom-understander/decide-provability)
shows, with [`ProvabilityLogic`](https://github.com/FormalizedFormalLogic/ProvabilityLogic):
that its sentence is in `LogicGL` if it closed, by the derivation it is in the labelled
sequent calculus `G3KGL`, and that it is not if a branch stayed open, by the finite Kripke
countermodel the branch describes. It is a Lean library, `GLVerify`, that the Python package
`gltableau` of
[wrap-provability](https://github.com/transhumanist-atom-understander/wrap-provability) uses;
use it from there. It depends on `decide-provability` and on `ProvabilityLogic`, hence on
Mathlib, which is why it is a project of its own: the decider builds in seconds without it.

    $ lake exe cache get   # Mathlib's prebuilt artifacts
    $ lake build           # then Foundation and ProvabilityLogic, from source: slow, once

`decide-provability` is required at `main`, and `lake-manifest.json` is not committed, so a
fresh checkout builds against the decider's latest commit; an older checkout moves to it with
`lake update decide-provability`. As `lake update` raises this project's toolchain to the newest
of its dependencies', the decider's must be no newer than Mathlib's. Everything else is pinned
in the lakefile: `ProvabilityLogic` to a commit, and with it Mathlib, and the
[Lean REPL](https://github.com/augustepoiroux/repl)
to the tag for this project's toolchain, so the two move together.

The wrapper runs the REPL in this project, with `GLVerify` imported once, which takes a
couple of seconds, most of it Mathlib, and has it evaluate Lean: the tableau that a Lean file
`t.lean` of the decider defines is checked by sending the file with
`theorem proof : t.verdict := t.verified` added. Lean's kernel evaluates the tableau's
certificate, and the theorem is rejected if the rules were misapplied. The same file checks
on its own in this project, after `lake env lean t.lean`, with its header changed to
`import GLVerify`.

## Files

- `GLVerify.lean`: a tableau as a derivation in `G3KGL`, an open branch as a countermodel, and
  the theorem `Tableau.verified` that Lean's kernel proves by evaluating them.
