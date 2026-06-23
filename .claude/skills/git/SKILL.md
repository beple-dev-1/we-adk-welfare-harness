# /git 스킬

복지AX 프로젝트의 git 작업을 안전하게 처리한다.

## 레포 라우팅 — system.yaml 기준

git 작업 요청 시 탐색 없이 아래 표를 즉시 참조한다.
현재 VCS 값은 `.claude/config/system.yaml`의 `vcs.current` / `harness.current`에서 읽는다.

| 변경 파일 유형 | 레포 | 로컬 경로 | Remote (`system.yaml` 키) |
|--------------|------|----------|--------------------------|
| `.claude/**`, `CLAUDE.md` | 하네스 레포 | `../we-adk-welfare-harness` | `harness.{current}.remote` |
| `src/`, `*.gradle.kts`, `*.java`, `*.properties` 등 소스 파일 | 소스 레포 | `.` (프로젝트 루트) | `vcs.{current}.remote` |

**현재 값 (github):**
- 소스 레포 remote: `https://github.com/beple-dev-1/we-adk-welfare.git`
- 하네스 레포 remote: `https://github.com/beple-dev-1/we-adk-welfare-harness.git`

**GitLab 전환 시 할 일 — `SKILL.md` 수정 불필요, `system.yaml`만 수정:**
1. `vcs.current` → `gitlab`
2. `vcs.gitlab.baseUrl` / `vcs.gitlab.remote` → GitLab 소스 레포 URL 입력
3. `harness.current` → `gitlab`
4. `harness.gitlab.remote` → GitLab 하네스 레포 URL 입력

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
