# welfare-ax-be-harness

**복지AX-BE** 프로젝트의 Claude Code 하네스 설정 파일 저장소입니다.

## 개요

이 레포는 [`welfare-ax-be`](https://github.com/beple-dev-1/welfare-ax-be) 백엔드 프로젝트와 함께 사용하는
AI 개발 보조(Claude Code) 설정을 관리합니다.
순수 개발 소스는 `welfare-ax-be` 레포에서 관리합니다.

## 구성

```
.claude/
├── agents/       # 역할별 서브에이전트 정의
├── commands/     # /mr-review, /qa-test 커맨드
├── config/       # 프로젝트·스코프·시스템 설정 (YAML)
├── docs/         # 단계별 참조 가이드
├── hooks/        # 위험 작업 차단 훅
├── rules/        # 세션 공통 규칙 (자동 적용)
├── skills/       # 슬래시 커맨드 절차 정의
└── settings.json # 권한 설정
CLAUDE.md         # Claude Code 프로젝트 지침
HANDOFF.md        # 세션 인수인계 현황
```

## 사용 방법

`welfare-ax-be` 프로젝트 루트에 이 레포의 파일을 위치시킨 상태에서
Claude Code를 실행하면 하네스가 자동으로 적용됩니다.

```bash
# welfare-ax-be 프로젝트 루트에서
git clone https://github.com/beple-dev-1/welfare-ax-be-harness.git harness-tmp
cp -r harness-tmp/.claude .
cp harness-tmp/CLAUDE.md .
cp harness-tmp/HANDOFF.md .
rm -rf harness-tmp
```

## 관련 레포

| 레포 | 설명 |
|------|------|
| [welfare-ax-be](https://github.com/beple-dev-1/welfare-ax-be) | 백엔드 개발 소스 |
| [welfare-ax-be-harness](https://github.com/beple-dev-1/welfare-ax-be-harness) | Claude Code 하네스 설정 (이 레포) |
