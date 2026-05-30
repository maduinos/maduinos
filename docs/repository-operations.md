# Maduinos Public Repository Operations

## Positioning

Use GitHub as a business-first public code portfolio.

- Lead with FPGA, C_DUINO_A7, board bring-up, and education material.
- Keep personal lab repositories public but clearly labeled as hobby/lab work.
- Avoid presenting trading, desktop toy, and macro helper repositories as business code.

## Repository Classes

| Repository | Class | Operating Rule |
| --- | --- | --- |
| `c_duino_a7` | Business-facing FPGA reference | Prioritize docs, reproducible simulation, release hygiene, and customer-readable explanations |
| `AutoTrading` | Personal lab | Keep safe to inspect, avoid real keys, avoid accidental live trading examples |
| `SlimePet` | Personal lab | Keep runnable docs and small tests |
| `macroKey` | Personal lab | Keep build instructions and safety notes |
| `macrokey_python` | Personal lab | Keep import-safe and testable, no tracked logs |
| `turntable` | Personal lab | Keep build instructions and hardware safety notes |

## Release Checklist

- README has purpose, status, requirements, usage, tests, and license.
- `.gitignore` excludes generated files, local secrets, logs, and build output.
- Public-risk files such as API keys and local paths are not tracked.
- CI exists for repositories with testable code.
- Version history is updated when a repository has explicit version bookkeeping.
- GitHub profile README points to `c_duino_a7` as the featured repository.

## Current External Blockers

- `maduinos/maduinos` profile repository must exist before this local repository can be pushed.
- Local `gh` authentication tokens were invalid during setup. Re-authenticate before creating the profile repository or pushing through `gh`.
- Shell network access failed with DNS errors during `git push`. Retry after network/DNS access is restored.

## Profile Repository Setup

After `gh auth login -h github.com` succeeds:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
gh repo create maduinos/maduinos --public --description "Maduinos GitHub profile" --source=. --remote=origin --push
```

If the GitHub repository already exists:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
git remote add origin https://github.com/maduinos/maduinos.git
git push -u origin main
```

## Push Order

Push the business-facing repository first, then personal lab repositories:

```bash
git -C /home/maduinos/00_github_maduinos/c_duino_a7 push origin main
git -C /home/maduinos/00_github_maduinos/AutoTrading push origin main
git -C /home/maduinos/00_github_maduinos/SlimePet push origin main
git -C /home/maduinos/00_github_maduinos/macroKey push origin main
git -C /home/maduinos/00_github_maduinos/macrokey_python push origin main
git -C /home/maduinos/00_github_maduinos/turntable push origin main
```

