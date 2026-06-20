# /git 스킬

복지AX 프로젝트의 git 작업을 안전하게 처리한다.

## 사용법
```
/git {subcmd} [{대상}]
```

서브커맨드: `status`, `log`, `diff`, `add`, `commit`, `push`, `checkout`, `branch`

## 규칙

### 보호 브랜치 직접 커밋 금지
- `main`, `develop`, `release-*`, `internal-*` 브랜치에는 직접 커밋하지 않는다.
- 위 브랜치로 checkout 후 커밋 시도 시 경고 후 중단한다.

### 커밋 전 리뷰 게이트
- `commit` 서브커맨드 실행 시 `/code-review staged`가 완료되었는지 확인한다.
- CRITICAL 항목이 해결되지 않은 경우 커밋을 중단하고 수정을 요청한다.

### 커밋 메시지 형식
```
{TYPE} : {메시지} (#{브랜치명})
```

TYPE 종류:
- `feat` : 새 기능
- `fix` : 버그 수정
- `refactor` : 리팩터링
- `test` : 테스트 추가·수정
- `docs` : 문서 변경
- `chore` : 빌드·설정 변경
- `hotfix` : 긴급 수정

예시: `feat : 복지혜택 지급 API 구현 (#feature/001/hong)`

### 파괴적 명령 차단
- `git push --force`, `git reset --hard`, `git clean -f`, `git branch -D` 는 실행하지 않는다.
- 위 명령이 필요한 상황이 발생하면 사용자에게 직접 실행을 요청한다.

## 브랜치 네이밍 규칙
| 유형 | 형식 | 예시 |
|------|------|------|
| 기능 개발 | `feature/{과업번호}/{사용자ID}` | `feature/001/hong` |
| 내부 개선 | `feature/internal/{기능명}/{사용자ID}` | `feature/internal/security-refactor/hong` |
| 긴급 수정 | `hotfix/{버그명}` | `hotfix/benefit-null-error` |
| 운영 배포 | `release-{yyyy.MM.dd}-v{N}` | `release-2026.07.01-v1` |
| 내부 배포 | `internal-{yyyy.MM.dd}-v{N}` | `internal-2026.07.01-v1` |
