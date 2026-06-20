# /qa-test 커맨드

테스트 계획서 기준으로 테스트를 실행하고 결과를 집계한다.

## 사용법
```
/qa-test {과업번호}
```
예시: `/qa-test 001`

## 절차

### 1. 테스트 계획서 로드
`target/plans/{과업번호}/{과업번호}_test_plan.md`를 읽는다.
파일이 없으면 `/dev-plan {과업번호}`를 먼저 실행하도록 안내한다.

### 2. qa-tester 에이전트 실행
- qa-tester 에이전트에게 테스트 계획서와 과업번호를 전달한다.
- `./gradlew test` 실행 결과를 집계한다.

### 3. 결과 저장 및 보고
- `target/test-reports/{과업번호}_test_result.md`에 결과를 저장한다.
- GREEN (전체 통과) 또는 RED (실패 항목 포함) 판정을 출력한다.
