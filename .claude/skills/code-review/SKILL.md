# /code-review 스킬

커밋 전 변경 코드를 심각도 기준으로 검토한다.

## 사용법
```
/code-review [staged|HEAD~N|경로] [ko|en]
```

기본값: `staged`, 언어: `ko`

## 절차

### 1단계: 설정 확인
- `.claude/config/system.yaml`의 `review` 설정을 읽는다.
- 현재 `/develop` 스코프가 활성화된 경우 해당 허용 경로를 우선 대상으로 삼는다.

### 2단계: diff 수집
- `git diff --staged` (staged) 또는 `git diff HEAD~N` 등으로 변경사항을 수집한다.
- 파일 50개 또는 5,000줄 초과 시 Java 소스를 우선 분석한다.
- 변경사항이 없으면 안내 후 중단한다.

### 3단계: 기준 로드
다음 파일을 읽는다:
- `.claude/docs/anti-patterns/incident-antipatterns.md`
- `.claude/skills/code-review/references/severity-rules.md`
- `.claude/skills/code-review/references/project-rules.md`

### 4단계: code-reviewer 에이전트 실행
- code-reviewer 에이전트에게 diff와 기준 문서를 전달한다.
- 심각도: CRITICAL (즉시 수정) / WARNING (권고) / INFO (참고)

### 5단계: 결과 출력
- 화면에 마크다운 형식으로 출력한다 (파일 저장 안 함).
- CRITICAL 항목이 있으면 커밋 전 수정을 강력 권고한다.
- CRITICAL 0건이면 커밋 가능임을 안내한다.

## 복지AX 필수 검토 항목
- 복지혜택 지급·취소 API의 중복 처리 방지 로직
- 잔액·한도 산정 로직의 정확성
- 트랜잭션 내 외부 REST 호출 여부
- 입력값 서버 검증 (`@Valid`, Bean Validation) 누락
- 개인정보(PII) 로그 노출 여부
