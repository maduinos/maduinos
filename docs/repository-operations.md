# Maduinos Public Repository Operations

## Positioning

Use GitHub as a business-first public code portfolio.

- Lead with FPGA, C_DUINO_A7, board bring-up, and education material.
- Keep personal lab repositories public but clearly labeled as hobby/lab work.
- Avoid presenting trading, desktop toy, and macro helper repositories as business code.

## Workspace Layout

`/home/maduinos/00_github_maduinos` is a workspace that contains several independent Git repositories. It is not managed as one parent Git repository.

The top-level `.git` path may appear in the Codex environment as a read-only `tmpfs` mount. Treat it as environment metadata, not as a project repository. Run Git commands inside the child repositories listed below.

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
- `CHANGELOG.md` records public-facing changes.
- `SUPPORT.md` explains what belongs in public issues and what should go to private business contact.
- `RELEASE.md` explains release and tag expectations.
- `.gitignore` excludes generated files, local secrets, logs, and build output.
- `.editorconfig` defines line endings, final newline behavior, and indentation.
- `CONTRIBUTING.md` defines acceptable contribution scope and local checks.
- `SECURITY.md` defines private reporting for secrets, private data, or unsafe hardware behavior.
- `.github/CODEOWNERS` assigns ownership to `@maduinos`.
- Public-risk files such as API keys and local paths are not tracked.
- CI exists for repositories with testable code.
- Version history is updated when a repository has explicit version bookkeeping.
- GitHub profile README points to `c_duino_a7` as the featured repository.

## Business-Facing Issue Handling

`c_duino_a7` is the business-facing public FPGA reference. It has issue templates for:

- HDL/testbench bug reports.
- Documentation requests.
- Private consulting or customer-specific requests redirected to the business site.

Personal lab repositories may keep issues simpler, but they still need security and ownership metadata.

## Pull Request Baseline

Each repository has `.github/PULL_REQUEST_TEMPLATE.md` so changes are reviewed against the local verification commands and repository-specific safety checks.

## Secret History Baseline

Any repository that ever tracked a secret-like file must document the history and rotation/rewrite response. `AutoTrading/docs/security-history.md` records the known `ext_key` history and the rule for rotating real credentials.

## Current External Status

- Public GitHub repositories now exist for the standard workspace set, including `maduinos/AutoTrading` and `maduinos/maduinos`.
- Direct `git push` over each configured `origin` works when external network access is available.
- `gh auth status` may still report stale local token entries. Direct Git operations are the source of truth for normal pushes unless a `gh`-specific workflow is required.
- The sandbox-visible `arduino-cli` is a snap shim that cannot create its runtime directories here. `verify-all.sh` detects that condition and skips Arduino compile checks with a clear message.

## Profile Repository Setup

The profile repository has already been created and pushed. If it ever needs to be recreated from a fresh machine, use:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
gh repo create maduinos/maduinos --public --description "Maduinos GitHub profile" --source=. --remote=origin --push
```

If the GitHub repository already exists and only the remote is missing locally:

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
git -C /home/maduinos/00_github_maduinos/maduinos push origin main
```

## Local Tool Installation

The verification script can run without HDL/Arduino tools, but full local verification needs:

- `iverilog` for C_DUINO_A7 Verilog testbenches.
- `arduino-cli` for Arduino sketch compile checks.
- Arduino AVR core.
- `MsTimer2` library for `turntable`.

Install on the host machine, not inside a restricted Codex sandbox:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
./scripts/install-tools.sh
```

Manual equivalent:

```bash
sudo apt-get update
sudo apt-get install -y iverilog curl ca-certificates
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
sudo install -m 0755 bin/arduino-cli /usr/local/bin/arduino-cli
rm -rf bin
arduino-cli core update-index
arduino-cli core install arduino:avr
arduino-cli lib install MsTimer2
```

After installation, run:

```bash
cd /home/maduinos/00_github_maduinos
./maduinos/scripts/verify-all.sh
```

## Current Sandbox Limits Observed

In the Codex sandbox used for this cleanup:

- `apt-get install -y iverilog` failed because the session is not root.
- `sudo` inside the sandbox failed because `no new privileges` is set; outside the sandbox it still requires an interactive password.
- `snap install arduino-cli` failed because the snapd socket is not accessible.
- unapproved shell network access failed with DNS errors; approved external network execution reached GitHub successfully.
- `/snap/bin/arduino-cli` exists but is not runnable in this environment because snap cannot create its user data and runtime directories.

These are environment blockers, not repository problems.
