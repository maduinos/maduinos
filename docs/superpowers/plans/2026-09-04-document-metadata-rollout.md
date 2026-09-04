> 만든 사람: maduinos<br>
> 문서 만든 날짜: 2026-09-04<br>
> https://maduinos.blogspot.com/

# maduinos Document Metadata Rollout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add consistent creator, creation-date, and blog metadata to every in-scope maduinos document, persist the rule for future documents, then commit and push every changed repository.

**Architecture:** A temporary, test-driven transformer inventories only Git-tracked Markdown/HTML files plus the known new HoloEye wiring guide. It computes original creation dates from each repository's Git history, inserts format-specific metadata idempotently into complete documents or HTML fragments, and leaves public website HTML and generated/untracked content untouched. A parent `AGENTS.md` persists the authoring rule for future Codex sessions.

**Tech Stack:** Python 3 standard library, pytest for temporary transformer tests, Git, HTMLParser, Markdown/YAML front-matter-aware text insertion.

**Spec:** `docs/superpowers/specs/2026-09-04-document-metadata-standard-design.md`

## Global Constraints

- The execution corpus is 294 tracked Markdown/HTML documents across 21 repositories plus the new HoloEye `docs/wiring.html`; the spec, this plan, and the parent policy are also in scope.
- Exclude all public HTML under `maduinos-biz-web`, both redirect HTML files, `zm4/index.html`, and `zm4/deck/index.html`.
- Do not touch build outputs, dependencies, caches, virtual environments, ignored files, or unrelated untracked assets.
- Existing tracked document dates come from the oldest `git log --follow --diff-filter=A --format=%as` result; new files use `2026-09-04`.
- Preserve YAML front matter, UTF-8 BOMs, HTML document structure, and all existing document content.
- Preserve the existing HoloEye README and untracked wiring-guide changes from the earlier task.
- Do not commit or push the parent `/home/whjeong/00_Github/maduinos/AGENTS.md` because its parent directory is not a Git repository.
- Commit only files changed by this task and push each repository's current branch to its configured upstream.

---

### Task 1: Build and prove the temporary transformer

**Files:**
- Create temporarily: `/tmp/maduinos-document-metadata-20260904/metadata_rollout.py`
- Create temporarily: `/tmp/maduinos-document-metadata-20260904/test_metadata_rollout.py`

**Interfaces:**
- Produces: `insert_markdown(text: str, date: str) -> str`
- Produces: `insert_html(text: str, date: str) -> str`
- Produces: `creation_date(repo: Path, relpath: str) -> str`
- Produces: `inventory(root: Path) -> list[DocumentTarget]`
- `DocumentTarget` fields: `path: Path`, `repo: Path | None`, `relative_path: str`, `kind: Literal["markdown", "html"]`, `date: str`

- [ ] **Step 1: Create the temporary working directory**

Run:

```bash
mkdir -p /tmp/maduinos-document-metadata-20260904
```

- [ ] **Step 2: Write failing transformer tests**

The tests must use these literal expectations:

```python
import pytest

from metadata_rollout import insert_html, insert_markdown


def test_markdown_metadata_precedes_heading():
    source = "# Title\n"
    result = insert_markdown(source, "2024-01-02")
    assert result.startswith(
        "> 만든 사람: maduinos<br>\n"
        "> 문서 만든 날짜: 2024-01-02<br>\n"
        "> https://maduinos.blogspot.com/\n\n# Title\n"
    )


def test_markdown_metadata_follows_yaml_front_matter():
    source = "---\ntitle: Example\n---\n# Title\n"
    result = insert_markdown(source, "2024-01-02")
    assert result.startswith(
        "---\ntitle: Example\n---\n\n"
        "> 만든 사람: maduinos<br>\n"
        "> 문서 만든 날짜: 2024-01-02<br>\n"
        "> https://maduinos.blogspot.com/\n\n# Title\n"
    )


def test_html_metadata_is_first_visible_body_element():
    source = "<!doctype html><html><head><title>X</title></head><body><main>X</main></body></html>"
    result = insert_html(source, "2024-01-02")
    assert result.index('class="maduinos-document-meta"') > result.index("<body>")
    assert result.index('class="maduinos-document-meta"') < result.index("<main>")


def test_existing_metadata_is_not_duplicated():
    once = insert_markdown("# Title\n", "2024-01-02")
    assert insert_markdown(once, "2024-01-02") == once


def test_html_fragment_receives_metadata_at_start():
    result = insert_html("<h1>Blog fragment</h1>\n", "2024-01-02")
    assert result.startswith('<aside class="maduinos-document-meta"')
    assert result.index("</aside>") < result.index("<h1>")
```

- [ ] **Step 3: Run the focused tests and verify RED**

Run:

```bash
pytest -q /tmp/maduinos-document-metadata-20260904/test_metadata_rollout.py
```

Expected: collection or import failure because `metadata_rollout.py` does not exist yet.

- [ ] **Step 4: Implement the minimal transformer**

Use these exact metadata forms:

```python
MARKDOWN_TEMPLATE = (
    "> 만든 사람: maduinos<br>\n"
    "> 문서 만든 날짜: {date}<br>\n"
    "> https://maduinos.blogspot.com/\n"
)

HTML_TEMPLATE = """<aside class="maduinos-document-meta" role="note" style="margin:0;padding:10px 16px;border-bottom:1px solid #d3dbd5;background:#f1f4f0;color:#14201c;font:14px/1.55 sans-serif">
  <div><strong>만든 사람:</strong> maduinos</div>
  <div><strong>문서 만든 날짜:</strong> {date}</div>
  <div><a href="https://maduinos.blogspot.com/">https://maduinos.blogspot.com/</a></div>
</aside>"""
```

`insert_markdown` must preserve a leading BOM and place metadata after a complete leading YAML front matter block. `insert_html` must find the opening `<body ...>` tag case-insensitively and insert immediately after it; when the file is an HTML fragment without `<body>`, it must prepend metadata before the first visible element. Both functions must identify existing metadata only at that legal insertion point, so example snippets do not cause false duplicate detection.

- [ ] **Step 5: Run the focused tests and verify GREEN**

Run:

```bash
pytest -q /tmp/maduinos-document-metadata-20260904/test_metadata_rollout.py
```

Expected: 5 passed.

### Task 2: Inventory the exact corpus and preserve exclusions

**Files:**
- Create temporarily: `/tmp/maduinos-document-metadata-20260904/manifest.json`
- Create temporarily: `/tmp/maduinos-document-metadata-20260904/public-html-sha256.json`

**Interfaces:**
- Consumes: `inventory(root)` and `creation_date(repo, relpath)` from Task 1
- Produces: a complete dry-run manifest and immutable exclusion hashes used by Tasks 3 and 4

- [ ] **Step 1: Extend tests for inventory boundaries**

Create controlled temporary Git repositories in pytest fixtures. Assert that inventory includes tracked `README.md` and `docs/manual.html`, excludes an untracked `characters/example/ASSET_NOTICE.md`, and excludes the exact public-HTML patterns from Global Constraints.

```python
import subprocess

from metadata_rollout import inventory


def git(repo, *args):
    subprocess.run(["git", "-C", str(repo), *args], check=True, capture_output=True)


def test_inventory_uses_tracked_files_and_excludes_public_html(tmp_path):
    root = tmp_path / "maduinos"
    repo = root / "ExampleRepo"
    (repo / "docs").mkdir(parents=True)
    (repo / "characters" / "example").mkdir(parents=True)
    git(repo, "init")
    git(repo, "config", "user.email", "test@example.invalid")
    git(repo, "config", "user.name", "Test")
    (repo / "README.md").write_text("# Readme\n")
    (repo / "docs" / "manual.html").write_text("<html><body>Manual</body></html>")
    (repo / "characters" / "example" / "ASSET_NOTICE.md").write_text("untracked\n")
    git(repo, "add", "README.md", "docs/manual.html")
    git(repo, "commit", "-m", "add docs")

    website = root / "maduinos-biz-web"
    website.mkdir()
    git(website, "init")
    git(website, "config", "user.email", "test@example.invalid")
    git(website, "config", "user.name", "Test")
    (website / "index.html").write_text("<html><body>Site</body></html>")
    git(website, "add", "index.html")
    git(website, "commit", "-m", "add site")

    paths = {target.path.relative_to(root).as_posix() for target in inventory(root)}
    assert "ExampleRepo/README.md" in paths
    assert "ExampleRepo/docs/manual.html" in paths
    assert "maduinos-biz-web/index.html" not in paths
    assert "ExampleRepo/characters/example/ASSET_NOTICE.md" not in paths
```

- [ ] **Step 2: Run inventory tests and verify RED**

Run:

```bash
pytest -q /tmp/maduinos-document-metadata-20260904/test_metadata_rollout.py
```

Expected: the new inventory tests fail until path filtering and Git history lookup exist.

- [ ] **Step 3: Implement inventory and dry-run output**

The inventory must enumerate files from `git ls-files`, not from an unrestricted recursive filesystem walk. Add only `/home/whjeong/00_Github/maduinos/HoloEye/docs/wiring.html` as the approved untracked exception. Write JSON with absolute path, repository, relative path, kind, and date for each target. Record SHA-256 hashes for the 12 excluded public HTML files.

- [ ] **Step 4: Run the temporary test suite and verify GREEN**

Run:

```bash
pytest -q /tmp/maduinos-document-metadata-20260904/test_metadata_rollout.py
```

Expected: all temporary transformer and inventory tests pass.

- [ ] **Step 5: Generate and inspect the dry-run manifest**

Run:

```bash
python /tmp/maduinos-document-metadata-20260904/metadata_rollout.py --root /home/whjeong/00_Github/maduinos --manifest /tmp/maduinos-document-metadata-20260904/manifest.json --hashes /tmp/maduinos-document-metadata-20260904/public-html-sha256.json --dry-run
```

Expected: no errors; every target has a valid format, insertion point, and date; excluded public HTML count is 12.

### Task 3: Persist the future rule and apply metadata

**Files:**
- Create: `/home/whjeong/00_Github/maduinos/AGENTS.md`
- Modify: every path listed in `/tmp/maduinos-document-metadata-20260904/manifest.json`

**Interfaces:**
- Consumes: the reviewed manifest and transformer from Tasks 1–2
- Produces: an idempotently marked document corpus and a parent policy for future sessions

- [ ] **Step 1: Create the parent policy with its own metadata**

The policy must define the exact scope, Markdown template, HTML template, date preservation rule, public-site exclusions, and verification requirement from the design spec. Its own date is `2026-09-04`.

- [ ] **Step 2: Re-run dry-run including new workflow documents and policy**

Regenerate the manifest so the design spec, implementation plan, and parent policy are included. Verify that all newly created files use `2026-09-04`.

- [ ] **Step 3: Apply the reviewed manifest**

Run the transformer with `--apply`. It must abort before writing if any target has an unknown date, malformed YAML front matter, non-UTF-8 content, or existing incomplete metadata marker.

- [ ] **Step 4: Re-run apply to prove idempotence**

Run the same `--apply` command again.

Expected: zero files changed on the second run.

### Task 4: Verify the entire rollout

**Files:**
- Verify: every changed document in all 21 repositories
- Verify unchanged: the 12 excluded public HTML files

**Interfaces:**
- Consumes: manifest, exclusion hashes, and modified corpus
- Produces: evidence that scope, syntax, dates, idempotence, and exclusions are correct

- [ ] **Step 1: Validate metadata contracts**

For every manifest entry, assert exactly one format-specific metadata marker, `maduinos` as creator, the recorded `YYYY-MM-DD` date, and the exact blog URL in that metadata block.

- [ ] **Step 2: Validate document structure**

Use Python `HTMLParser` for all target HTML files. Assert that Markdown files with original YAML front matter still begin with the same complete front matter and that each HTML metadata block is inside `<body>` before the original first visible element, or at the beginning of an HTML fragment.

- [ ] **Step 3: Verify excluded hashes**

Recompute SHA-256 for all 12 excluded public HTML files and compare byte-for-byte with `public-html-sha256.json`.

- [ ] **Step 4: Verify repository diffs**

For each of the 21 repositories, run:

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; changed paths are only manifest documents, plus the already approved HoloEye README/wiring changes and the plan/spec documents.

- [ ] **Step 5: Run directly affected project tests**

Run:

```bash
cd /home/whjeong/00_Github/maduinos/HoloEye
python3 -m pytest -q
```

Expected: 23 tests pass. Other product builds are omitted because only document prefixes changed.

### Task 5: Commit and push every changed repository

**Files:**
- Commit: all verified task-owned changes in each changed Git repository
- Do not commit: `/home/whjeong/00_Github/maduinos/AGENTS.md` or temporary files under `/tmp`

**Interfaces:**
- Consumes: verified repository diffs from Task 4
- Produces: one focused commit per changed repository and a successful upstream push for each

- [ ] **Step 1: Record branches and upstreams**

For each changed repository, record `git branch --show-current` and `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}`. Stop before committing a repository that is detached or lacks an upstream and report it separately.

- [ ] **Step 2: Stage only verified task-owned paths**

Use the manifest to pass explicit paths to `git add`. In HoloEye also stage the approved `README.md` and `docs/wiring.html`. Never use `git add -A` across an unchecked worktree.

- [ ] **Step 3: Commit each repository**

Use `docs: add maduinos document metadata` for metadata-only repositories. Use `docs: add HoloEye wiring guide and metadata` for HoloEye. The `maduinos` profile repository commit also includes the design and plan documents.

- [ ] **Step 4: Verify commits before network mutation**

For every repository, verify `git status --short` is empty for tracked task paths and inspect `git show --stat --oneline HEAD`.

- [ ] **Step 5: Push each current branch**

Run plain `git push` in each changed repository so only the configured current branch is updated. Record repository name and push result. If a push fails, preserve the local commit, continue only for failures that are independent, and report every unpushed commit hash.

- [ ] **Step 6: Final verification**

Re-run the metadata audit and public hash comparison, then report repository commit hashes, push results, the non-versioned parent policy path, tests, exclusions, and any residual dirty files.
