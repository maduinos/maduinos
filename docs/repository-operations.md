# Maduinos 공개 저장소 운영 문서

## 기본 방향

GitHub 공개 프로필은 FPGA와 C_DUINO_A7 보드 자료가 먼저 보이도록 운영합니다.

- FPGA, C_DUINO_A7, 보드 bring-up, 교육 자료를 핵심 공개 자료로 둡니다.
- 개인 실험 저장소는 공개하되 취미/실험 프로젝트로 명확히 표시합니다.
- 자동매매, 데스크톱 장난감 앱, 매크로 도구는 비즈니스 코드처럼 보이지 않게 구분합니다.

## 작업 폴더 구조

`/home/maduinos/00_github_maduinos` 폴더에는 여러 개의 독립 Git 저장소가 들어 있습니다. 상위 폴더 하나를 한 번에 커밋하는 구조가 아니므로, 변경 사항은 각 하위 저장소 안에서 따로 확인하고 커밋합니다.

## 저장소 구분

| 저장소 | 구분 | 운영 기준 |
| --- | --- | --- |
| `c_duino_a7` | 비즈니스 공개 FPGA 자료 | 보드 설명, 예제 구조, bring-up 문서를 우선 관리 |
| `AutoTrading` | 개인 실험 | 실제 키를 넣지 않고 실거래 추천 코드처럼 보이지 않게 관리 |
| `SlimePet` | 개인 실험 | 실행 방법과 버전 기록을 간단히 유지 |
| `macroKey` | 개인 실험 | Arduino HID 동작, Python GUI 앱, 안전 주의사항을 명확히 기록 |
| `turntable` | 개인 실험 | 하드웨어 요구사항과 안전 주의사항을 명확히 기록 |
| `Burndori` | 개인 실험 | OCR/번역 API 키는 환경변수로만 관리하고 로컬 설정 파일은 추적하지 않음 |
| `GIFtoRGB565` | 개인 실험 | 변환 로직 테스트와 GUI 실행 방법을 함께 유지 |
| `KiCAD_LIB` | 개인 실험 | KiCad 라이브러리 자산을 공개 자료로 관리 |
| `maduinos` | 프로필/운영 문서 | GitHub 프로필 README와 전체 저장소 운영 기준 관리 |

## 공개 전 확인 기준

- README에 목적, 요구사항, 사용법, 라이선스가 정리되어 있는지 확인합니다.
- `CHANGELOG.md`에는 공개적으로 의미 있는 변경 사항만 남깁니다.
- `SUPPORT.md`에는 공개 이슈로 다룰 내용과 비공개 연락이 필요한 내용을 구분합니다.
- `RELEASE.md`에는 릴리스와 태그 기준을 적습니다.
- `CONTRIBUTING.md`에는 허용되는 변경 범위와 로컬 확인 절차를 적습니다.
- `SECURITY.md`에는 비밀키, 개인 데이터, 안전 문제가 생겼을 때의 비공개 신고 경로를 둡니다.
- 공개 위험이 있는 API 키, 로컬 경로, 개인 로그는 추적하지 않습니다.
- 버전 기록이 있는 저장소는 코드와 문서의 버전 표기를 맞춥니다.
- GitHub 프로필 README는 `c_duino_a7`을 대표 저장소로 보여줍니다.

## 보안 이력

과거에 비밀키처럼 보이는 파일이 추적된 저장소는 이력과 대응 방식을 문서화합니다. `AutoTrading/docs/security-history.md`는 `ext_key` 파일 이력과 실제 자격 증명이 노출됐을 때의 회전 원칙을 기록합니다.

## 현재 외부 상태

- 표준 작업 폴더의 공개 GitHub 저장소가 생성되어 있습니다.
- 각 저장소는 `origin/main`으로 직접 푸시합니다.
- GitHub CLI 인증 상태가 흔들릴 수 있으므로 일반 푸시는 Git 원격 상태를 기준으로 확인합니다.
- Arduino 관련 빌드는 로컬 host 환경의 도구 설치 상태에 따라 달라질 수 있습니다.

## 프로필 저장소 설정

프로필 저장소는 이미 생성되어 푸시되어 있습니다. 새 환경에서 다시 구성해야 할 때는 다음 명령을 사용합니다.

```bash
cd /home/maduinos/00_github_maduinos/maduinos
gh repo create maduinos/maduinos --public --description "Maduinos GitHub profile" --source=. --remote=origin --push
```

GitHub 저장소가 이미 있고 로컬 원격만 빠진 경우:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
git remote add origin https://github.com/maduinos/maduinos.git
git push -u origin main
```

## 푸시 순서

비즈니스 공개 자료를 먼저 푸시한 뒤 개인 실험 저장소를 푸시합니다.

```bash
git -C /home/maduinos/00_github_maduinos/c_duino_a7 push origin main
git -C /home/maduinos/00_github_maduinos/AutoTrading push origin main
git -C /home/maduinos/00_github_maduinos/SlimePet push origin main
git -C /home/maduinos/00_github_maduinos/macroKey push origin main
git -C /home/maduinos/00_github_maduinos/turntable push origin main
git -C /home/maduinos/00_github_maduinos/Burndori push origin main
git -C /home/maduinos/00_github_maduinos/GIFtoRGB565 push origin main
git -C /home/maduinos/00_github_maduinos/KiCAD_LIB push origin main
git -C /home/maduinos/00_github_maduinos/maduinos push origin main
```

## 로컬 도구

하드웨어/임베디드 저장소를 점검하려면 host 환경에 필요한 도구를 설치합니다.

- `iverilog`: Verilog 소스 문법 확인
- `arduino-cli`: Arduino 스케치 컴파일
- Arduino AVR core
- `MsTimer2`: `turntable` 빌드에 필요한 Arduino 라이브러리

설치 예:

```bash
cd /home/maduinos/00_github_maduinos/maduinos
./scripts/install-tools.sh
```

수동 설치 예:

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

## 현재 작업 환경에서 확인된 제한

Codex sandbox에서는 host 시스템 도구 설치와 일부 네트워크 작업이 제한될 수 있습니다.

- root 권한이 필요한 패키지 설치는 실패할 수 있습니다.
- snap 기반 `arduino-cli`는 sandbox에서 런타임 폴더를 만들지 못할 수 있습니다.
- 외부 네트워크가 필요한 GitHub 작업은 승인된 실행 환경에서 처리해야 합니다.

이 제한은 저장소 내용 문제가 아니라 실행 환경의 제약입니다.
