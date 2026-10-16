> 만든 사람: maduinos<br>
> 문서 만든 날짜: 2026-05-30<br>
> https://maduinos.blogspot.com/

# Maduinos

FPGA·임베디드 하드웨어와 개발 도구를 만듭니다. 보드 bring-up과 Verilog/SystemVerilog 실습 자료부터 AI를 활용한 FPGA 개발 연동, 데스크톱 앱까지 공개 프로젝트를 정리합니다.

[비즈니스](https://maduinos.com/) · [블로그](https://maduinos.blogspot.com/) · [공개 저장소](https://github.com/maduinos?tab=repositories)

## 주요 분야

- FPGA 교육, Verilog/SystemVerilog 예제와 C_DUINO_A7 보드 실습
- 보드 bring-up과 임베디드 하드웨어 프로토타이핑
- Vivado·Vitis 개발 흐름과 MCP 기반 AI 도구 연동
- 에이전트 활동을 시각화하는 데스크톱 앱

## 대표 프로젝트

| 저장소 | 설명 |
| --- | --- |
| [`amd-fpga-mcp-releases`](https://github.com/maduinos/amd-fpga-mcp-releases) | MCP 클라이언트에서 Vivado·Vitis 개발 흐름, 빌드와 timing·CDC·DRC 보고서 검토를 연결하는 도구의 설치 가이드와 배포 패키지 |
| [`c_duino_a7`](https://github.com/maduinos/c_duino_a7) | C_DUINO_A7 보드를 위한 공개 FPGA 데모 소스와 문서 |
| [`agentpet-releases`](https://github.com/maduinos/agentpet-releases) | Codex·Claude Code·Cursor의 에이전트 활동을 바탕화면 캐릭터로 보여 주는 Linux 앱의 설치 안내와 .deb 배포 |

- [AMD FPGA MCP 다운로드](https://github.com/maduinos/amd-fpga-mcp-releases/releases/latest) · [기능 소개](https://maduinos.github.io/amd-fpga-mcp-releases/)
- [AgentPet 다운로드](https://github.com/maduinos/agentpet-releases/releases/latest)

AMD FPGA MCP는 독립 커뮤니티 프로젝트이며, AMD 공식 제품이 아닙니다. AMD 개발 도구와 라이선스는 별도로 준비해야 합니다. AgentPet은 Ubuntu Desktop용으로 배포합니다. 지원 환경과 설치 절차는 각 배포 저장소의 README를 확인하세요.

## 개인 실험 저장소

하드웨어 실습, 변환 도구, 데스크톱 앱 등 공개 개인 프로젝트입니다.

| 저장소 | 설명 |
| --- | --- |
| [`macroKey`](https://github.com/maduinos/macroKey) | Arduino HID 키패드와 Windows용 Python 매크로 GUI 앱 |
| [`GIFtoRGB565`](https://github.com/maduinos/GIFtoRGB565) | GIF 프레임을 Arduino용 RGB565 PROGMEM 헤더로 변환하는 GUI 도구 |
| [`turntable`](https://github.com/maduinos/turntable) | Arduino 스테퍼 모터 턴테이블 실험 |
| [`KiCAD_LIB`](https://github.com/maduinos/KiCAD_LIB) | 심볼, 풋프린트, 3D 모델을 모아둔 개인 KiCad 라이브러리 |
| [`SlimePet`](https://github.com/maduinos/SlimePet) | PyQt6 기반 데스크톱 슬라임 펫 앱 |
| [`ArenaTalk`](https://github.com/maduinos/ArenaTalk) | 캐릭터 토론과 Elo 순위를 구현한 데스크톱 앱. 개발 중단, MIT 소스 공개 |
| [`AutoTrading`](https://github.com/maduinos/AutoTrading) | 개인 암호화폐 트레이딩 리서치 스크립트 (실거래 추천 아님) |

## 웹사이트와 프로필

| 저장소 | 설명 |
| --- | --- |
| [`maduinos-biz-web`](https://github.com/maduinos/maduinos-biz-web) | maduinos.com 비즈니스 웹사이트 |
| [`maduinos-biz-redirect`](https://github.com/maduinos/maduinos-biz-redirect) | 기존 biz.maduinos.com 주소를 maduinos.com으로 연결 |
| [`maduinos`](https://github.com/maduinos/maduinos) | GitHub 프로필 README와 공개 저장소 소개·운영 문서 |

## 저장소 운영 문서

- [HTML 소개 문서](docs/repository-overview.html)
- [운영 가이드](docs/repository-operations.md)
- [변경 이력](CHANGELOG.md)
- [릴리스 절차](RELEASE.md)
- [지원 범위](SUPPORT.md)
- [기여 가이드](CONTRIBUTING.md)
- [보안 신고](SECURITY.md)

공개 저장소 목록 확인: 2026-10-16. 비공개 개발 저장소는 목록에 포함하지 않습니다.
