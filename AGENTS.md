# Rules for AI helpers working in this repo

1. The AL in this repo is written by the local BC agent and committed unedited. Never change agent-written AL by hand, not even to fix an analyzer finding. Fix the agent's prompts or checks in LAAI-Document-Library instead.
2. AL follows Microsoft's AL coding guidelines. The CodeCop and UICop analyzers run in every AL-Go build (`enableCodeCop`, `enableUICop` in `.github/AL-Go-Settings.json`). Their warnings are a score of the agent's output: read them in the build log, and don't fail or block a PR on them.
3. The full standards and review checklist are in TheLAAIGuy_AI's [docs/code-standards.md](https://github.com/shiprek/TheLAAIGuy_AI/blob/main/docs/code-standards.md).
