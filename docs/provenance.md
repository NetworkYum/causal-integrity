# Provenance

Where the content in this repository came from, and what may still be missing.

## Source material (timeline)

| When | Source | Role |
|------|--------|------|
| 2026-03-06 | `gemini_google-gemini_2026-03-06…` (MD/JSON) | **Origin of property=causality formalization**, FOL base axioms, attack vectors (chats 13–18) |
| 2026-03-24…26 | `grok_codifying-ethics-for-ai-alignment_*.json` | UPB proof critique, merge with Gemini, SymPy sketches, X-thread drafting |
| 2026-07-16 | `grok_ai-ethics_*.json` | Coherence preference, forward sim, is/ought strengthening, systemic stability, V2 thread |
| 2026-07-26 | `GROK BUILD UPDATE grok_ai-ethics_*.json` | FOL+Lean packaging for GitHub (thin slice that first landed on `main`) |
| Local | `H:\Grok Projects\Research and Theory\theory\Causal-Integrity-overview.md` | Mid distillation |

## Known translation loss (why the repo felt thinner)

The **July packaging** captured FOL skeleton + Lean PoC + README but under-represented:

1. Gemini **Agency / Effect / Homesteading** base layer and proof-by-contradiction shovel argument
2. **Attack vectors** (butterfly, nature) and user patches (agent filter, liability≠ownership)
3. March **UPB five-proof critique** map (what is worth encoding for AI)
4. July **systemic stability** and is/ought bridge (restored earlier)
5. Correct SymPy pattern (Direct required)

Mining passes on 2026-07-26 restored most of the above into `docs/` and `examples/`.

## Still not recovered as machine-checked proofs

Exports contain **sketches and PoC axioms**, not a finished Lean development of non-trivial theorems beyond starter lemmas. References to “full FOL proofs” in chat are often the Gemini chat-16 style proofs (prose + FOL fragments), which are now cleaned into [foundations-gemini.md](foundations-gemini.md).

If older Gemini shares or missing chats appear, drop them into the local `_inbox` for another pass.

## Companion mesh

Short July export on Project Companion attractors is **not** part of the formal ethics core and is not merged into Lean axioms.
