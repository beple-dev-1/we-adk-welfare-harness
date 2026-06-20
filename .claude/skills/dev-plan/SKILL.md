# /dev-plan 스킬

개발 브리프를 기반으로 개발 계획서와 테스트 계획서를 작성한다.

## 사용법
```
/dev-plan {과업번호 | 브리프 파일 경로}
```

## 절차

### 1단계: 브리프 확인
- `target/works/{과업번호}_dev_brief.md` 파일을 읽는다.
- 브리프가 없으면 `/dev-interview`를 먼저 실행하도록 안내한다.

### 2단계: dev-planner 에이전트 실행
- dev-planner 에이전트에게 브리프를 전달하여 개발 계획서 초안을 생성한다.
- `.claude/docs/agents/dev-planner/references/` 문서를 참조한다.

### 3단계: 개발 계획서 생성
`target/plans/{과업번호}/` 경로에 저장:
- `{과업번호}_dev_plan.md` — 루트 계획서 (10개 항목)
- `phases/phase_{N}.md` — 단계별 상세 계획

### 4단계: qa-planner 에이전트 실행
- 개발 계획서를 기반으로 테스트 계획서를 생성한다.
- `.claude/docs/agents/qa-planner/references/` 문서를 참조한다.

### 5단계: 테스트 계획서 생성
`target/plans/{과업번호}/` 경로에 저장:
- `{과업번호}_test_plan.md` — 테스트 계획서 (루트 + TC 목록)

## 완료 후
계획서 저장 경로를 안내하고 `/develop {스코프} {과업번호}` 명령으로 구현을 시작하도록 안내한다.
