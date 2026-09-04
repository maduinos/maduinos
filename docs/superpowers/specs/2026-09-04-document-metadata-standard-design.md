> 만든 사람: maduinos<br>
> 문서 만든 날짜: 2026-09-04<br>
> https://maduinos.blogspot.com/

# maduinos 문서 메타데이터 표준 설계

## 목적

`/home/whjeong/00_Github/maduinos` 아래의 작성 문서 상단에 만든 사람, 문서 만든 날짜,
블로그 주소를 일관되게 표시한다. 기존 문서를 일괄 갱신하고, 이후 Codex가 새 문서를 만들거나
기존 문서를 수정할 때도 같은 규칙을 적용한다.

## 적용 범위

실행 시점의 대상은 21개 Git 저장소에서 추적 중인 Markdown/HTML 문서 294개와 아직 추적되지
않은 새 HoloEye `docs/wiring.html` 1개다. 이 설계 문서, 구현 계획 및 상위 `AGENTS.md`처럼
작업 중 새로 생기는 문서도 같은 형식을 적용하며 최종 검증 대상에 포함한다.

문서 후보는 다음 조건으로 찾는다.

- 확장자가 `.md`, `.html`, `.htm`인 추적 파일
- 확장자와 무관하게 `README`, `CHANGELOG`, `CONTRIBUTING`, `SECURITY`, `AGENTS`,
  `CLAUDE` 이름을 사용하는 추적 파일
- 현재 작업에서 생성한 HoloEye `docs/wiring.html`

다음은 제외한다.

- `maduinos-biz-web`의 공개 웹사이트 HTML 전체
- `maduinos-biz-redirect/index.html`과 `maduinos-biz-redirect/404.html`
- `zm4/index.html`과 `zm4/deck/index.html`
- `.git`, 빌드 산출물, 의존성, 캐시, 가상환경 안의 문서
- Git이 추적하지 않는 캐릭터 자산 안내문 등 현재 작업 범위 밖 사용자 파일

공개 웹사이트 저장소의 README 같은 Markdown 문서는 공개 페이지 HTML이 아니므로 대상에
포함한다.

## 표시 형식

Markdown 계열 문서는 다음 블록을 문서 상단에 넣는다.

```markdown
> 만든 사람: maduinos<br>
> 문서 만든 날짜: YYYY-MM-DD<br>
> https://maduinos.blogspot.com/
```

`<br>`은 Git trailing-whitespace 검사에 걸리지 않으면서 세 항목을 줄바꿈해 표시한다.
YAML front matter가 있는 문서는 front matter 종료 구분자 다음에 넣어 기존 파서 동작을
보존한다. UTF-8 BOM이 있으면 BOM 뒤에 넣는다.

완전한 HTML 문서는 `<!doctype>`, `<html>`, `<head>` 구조를 유지하고 `<body>`의 첫 번째 보이는
요소로 `maduinos-document-meta` 클래스를 가진 `<aside>`를 넣는다. 블로그 게시용 HTML 조각처럼
`<body>`가 없는 파일은 파일의 첫 번째 보이는 요소로 같은 `<aside>`를 넣는다. 기존 스타일시트와
이름이 충돌하지 않도록 필요한 표현은 해당 요소의 인라인 스타일로 제한한다. 표시 내용은
Markdown과 같으며 블로그 주소는 클릭 가능한 링크다.

## 날짜 산정

기존 추적 문서는 각 저장소에서 다음 의미의 Git 이력을 조회한다.

```text
git log --follow --diff-filter=A --format=%as -- <문서 경로>
```

파일이 처음 추가된 가장 오래된 결과를 `YYYY-MM-DD`로 사용한다. 이력이 없는 새 파일은
표준 적용일인 `2026-09-04`를 사용한다. 파일의 최근 수정일이나 일괄 적용일로 기존 작성일을
덮어쓰지 않는다.

## 일괄 처리

처리는 두 단계로 나눈다.

1. Dry-run에서 대상 경로, 날짜, 문서 형식, 삽입 위치를 계산한다.
2. 모든 항목을 판단할 수 있을 때만 실제 파일을 갱신한다.

Markdown과 HTML의 메타데이터에는 고유한 시작 패턴을 사용한다. 이미 패턴이 존재하면 새
블록을 추가하지 않고 기존 블록을 유지하므로 작업을 재실행해도 중복이 생기지 않는다.

날짜 조회 실패, 닫히지 않은 YAML front matter, HTML 삽입 위치를 판정할 수 없는 구조,
UTF-8로 읽을 수 없는 파일을 발견하면 그 파일을 추측해서 수정하지 않는다. 전체 실제 쓰기를
시작하기 전에 오류 목록을 보고하고 중단한다.

## 향후 문서 규칙

`/home/whjeong/00_Github/maduinos/AGENTS.md`를 새로 만들고 다음 내용을 규정한다.

- 적용 대상과 공개 웹사이트 예외
- Markdown/HTML 메타데이터 형식
- 새 문서는 생성 당일을 `YYYY-MM-DD`로 기록
- 기존 문서 수정 시 이미 있는 작성일을 변경하지 않음
- YAML front matter와 HTML 문서 구조 보존
- 완료 전에 필드 누락과 중복 검사

상위 `AGENTS.md`는 sibling 저장소 전체에 적용되는 로컬 작업 정책이다. 각 저장소의 기존
하위 `AGENTS.md`는 그대로 두며, 충돌하지 않는 범위에서 추가 규칙으로 함께 적용된다.

## 검증

일괄 수정 후 다음을 확인한다.

- 계산된 대상 문서마다 완전한 메타데이터 블록이 정확히 한 번 존재
- 날짜 형식이 `YYYY-MM-DD`이고 추적 문서는 Git 최초 추가 날짜와 일치
- YAML front matter가 원래 위치와 구조를 유지
- 대상 HTML을 HTML 파서가 읽을 수 있고 메타데이터가 `<body>` 안 첫 보이는 요소이거나
  HTML 조각의 첫 보이는 요소
- 제외한 공개 웹사이트 HTML 12개의 작업 전후 SHA-256 해시가 동일
- 각 저장소에서 `git diff --check` 통과
- 실제 변경 파일이 계산된 대상 집합을 벗어나지 않음
- HoloEye의 기존 변경과 새 배선 문서 내용이 메타데이터 외에는 보존됨

문서 전용 일괄 변경이므로 전체 제품 빌드는 실행하지 않는다. HTML/Markdown 구조 검증과
변경 집합 검사가 이 작업의 직접 검증이다.

## 변경 등급과 보안

문서 본문 갱신은 Level 1이지만 상위 `AGENTS.md`가 향후 에이전트 행동을 바꾸므로 전체 작업은
Level 2다. 소스 코드, 프로토콜, 하드웨어 인터페이스 및 공개 웹사이트 동작은 바꾸지 않는다.

작업은 로컬 저장소 내용만 사용한다. 문서 본문을 외부 서비스로 전송하지 않으며, 새
메타데이터에는 공개 블로그 주소 외의 credential, 개인정보 또는 내부 접속 정보를 넣지 않는다.
