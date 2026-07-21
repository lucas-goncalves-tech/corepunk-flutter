# Memory Index

> Max 200 lines. Format: `- [type] summary → topic-file.md`

---

## User

- [user] Background: Fullstack Dev TypeScript/Java em transição para Web Pentester → user-preferences.md
- [user] OS: CachyOS (Arch Linux), Shell: Zsh, Editor provavelmente Cursor/VSCode → user-preferences.md
- [user] Idioma: Português BR (comunicação), código em inglês → user-preferences.md
- [user] Estudo: Links de pré-requisitos nos guias devem usar wikilinks diretos do Obsidian [[caminho|Nome]] → user-preferences.md
- [lesson] 🔴 Prerequisites MUST NOT give away lab solutions even indirectly — no lab-specific file names, paths, or assembled payloads. Only teach isolated building blocks. → user-preferences.md
- [user] Não possui licença do Burp Suite Pro (sem Collaborator); labs que exigem OAST exclusivo devem ser pulados ou adaptados → user-preferences.md

---

## Project

- [project] Repo: pentester-2019 — workspace de estudo para Web Pentesting / Bug Bounty → project-state.md
- [project] Pasta principal de conteúdo: raiz `/` e `fase-01-portswigger/` contendo os materiais → project-state.md
- [project] Roadmap principal: `fase-00-fundacao.md` até `fase-05-python-toolkit.md` na raiz (5 fases sequenciais) → project-state.md
- [project] Roadmap antigo arquivado em: `_archive/` no diretório raiz → project-state.md
- [project] Fase atual: Fase 01 — PortSwigger Academy (M09 - OAuth 2.0 em andamento 🧪) → project-state.md
- [project] Roadmap: 00 (Fundação ✅) → 01 (PortSwigger) → 02 (DVWA + JuiceShop + Relatório Profissional + Build to Break + LinkedIn) → 03 (BSCP) → 04 (Expansão) → 05 (Python Automation Toolkit) → project-state.md
- [project] Lab preferido: OWASP Juice Shop (Docker local, porta 3000, v20.0.0) → project-state.md
- [project] Outros docs: Workflow Framework, Diagnóstico de Payloads, Build to Break Labs Specs → project-state.md

---

## Reference

- [reference] Juice Shop (v20.0.0) challenges listados em: `fase-02-juiceshop.md` → project-state.md
- [reference] Guia Juice Shop: https://pwning.owasp-juice.shop → project-state.md
- [reference] Roadmap timeline: Fast-Track 6-9 meses para 1º emprego AppSec (sequencial: PW → JS → BSCP → AD/Cloud) → project-state.md
- [reference] Skill usada para estudo: `ethical-hacking-study` + `red-team-tactics` → project-state.md
- [automation] Gatilho "continue o próximo módulo" → lê memória, avança para próximo módulo via ethical-hacking-study → web-pentest-tutor.md
- [automation] Gatilho "terminei o módulo" → gera Layer 2, atualiza memória, commit+push → web-pentest-tutor.md
- [automation] Gatilho "tirar duvida" → consulta skill, responde socrático sem criar módulo → web-pentest-tutor.md
- [automation] Gatilho "estou travado" → hints progressivos sem payload final → web-pentest-tutor.md
- [automation] Gatilho "revisar" → lê memória, busca módulo, sintetiza resumo → web-pentest-tutor.md
- [lesson] 🔴 Skill ethical-hacking-study atualizada: pré-requisitos são gerados para TODOS os labs do módulo na primeira entrega, não apenas para o lab de entrada → user-preferences.md
- [lesson] 🔴 Cada lab no MISSAO.md deve ter seus PRÓPRIOS pré-requisitos (nunca reciclados de outro lab) → user-preferences.md
- [lesson] 🔴 Subagentes (Blocker Extractor, Context7, Modern Standards) pesquisam TODOS os labs em escopo, não apenas o entry lab → user-preferences.md
- [lesson] 🔴 Links de pré-requisitos usam wikilinks Obsidian limpos `[[prerequisites/[pasta]/[arquivo].md|Nome]]` sem prefixo redundante → user-preferences.md
- [lesson] 🔴 A IA principal não faz pesquisas na Fase 1 (Sequential Thinking), delegando pesquisas de conteúdo aos subagentes da Fase 2 → user-preferences.md

- [reference] Build to Break specs arquivado em: `_archive/Build to Break Labs_ Specs para Aplicações Vulneráveis Custom.md` → project-state.md
- [struggle] Usuário travou em Web shell upload via path traversal em 2026-07-03 → web-pentest-tutor.md
- [struggle] Usuário travou na lógica multithreaded de Race Condition em 2026-07-03 → web-pentest-tutor.md
- [struggle] Usuário travou em Password brute-force via password change em 2026-07-06 → web-pentest-tutor.md
- [struggle] Usuário travou em JWT authentication bypass via jku header injection em 2026-07-07 → web-pentest-tutor.md
- [progress] Módulo 05 da Fase 01 concluído → project-state.md
- [progress] Labs Username enumeration via account lock e 2FA broken logic do M06 concluídos em 2026-07-04 → project-state.md
- [progress] Módulo M06 (Authentication) da Fase 01 concluído em 2026-07-06 → project-state.md
- [progress] Lab JWT authentication bypass via jku header injection concluído em 2026-07-07 → web-pentest-tutor.md
- [progress] Módulo M08 (JWT Attacks) da Fase 01 concluído em 2026-07-07 → project-state.md
- [fix] Links do M06 Authentication corrigidos (6 URLs quebradas): PortSwigger mudou `authentication/other/` → `authentication/other-mechanisms/`, `lab-brute-force-` → `lab-bruteforce-`, `host-header/exploiting/` → `authentication/other-mechanisms/` → m06-authentication_labs.md
- [lesson] 🔴 Formato pós-lab mudou de "Deconstruct the Code" (blocos progressivos de CLI) para "Raciocínio & Replicação" (tool-agnostic: Causa Raiz → Cadeia de Decisão → Sinal de Reconhecimento → Código só se necessário). O usuário resolve labs via Burp Suite, não terminal → user-preferences.md
