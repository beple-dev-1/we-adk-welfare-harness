# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

---

## 워크스페이스 개요

**복지AX-BE(welfare-ax-be)** 는 비플페이(beplepay)가 개발 중인 복지혜택 관리 플랫폼 백엔드입니다.
첫 번째 업무 도메인: **경조사지원** (결혼·출산·장례 등 경조사 이벤트에 대한 복지 지원)
향후 동일 프로젝트에 다른 성격의 복지 업무가 추가되므로, **공통 레이어**와 **경조사 전용 레이어**를 분리하여 관리한다.

## 기술 스택

| 항목 | 내용 |
|------|------|
| 언어 | Java 21 |
| 프레임워크 | Spring Boot 4.1.0 (Jakarta EE 10 기반) |
| Web | Spring MVC (`spring-boot-starter-webmvc`) |
| 보안 | Spring Security 6.x (`spring-boot-starter-security`) |
| ORM | Spring Data JPA 3.x / Hibernate 6 |
| DB | PostgreSQL |
| 유틸 | Lombok |
| 빌드 | Gradle 8.x (Kotlin DSL) |

## 패키지 구조 원칙

```
com.beplepay.welfareaxbe
├── config/           # Spring 설정 (Security, JPA 등)
├── common/           # 공통 인프라 (예외, 응답 래퍼, 유틸)
├── member/           # 회원 관리 — 복지 공통
├── merchant/         # 가맹점 관리 — 복지 공통
└── ceremony/         # 경조사 전용 (현재 구현 업무)
    ├── application/  # 경조사 신청
    ├── approval/     # 승인 처리
    ├── payment/      # 지급 처리
    └── settlement/   # 정산
```

**분리 원칙:**
- `common/`, `member/`, `merchant/`, `config/` → 모든 복지 업무에서 재사용
- `ceremony/` → 경조사 전용, 다른 복지 업무 추가 시 새 최상위 패키지 추가

## 빌드·실행 명령

```bash
./gradlew build              # 빌드
./gradlew bootRun            # 애플리케이션 실행
./gradlew test               # 전체 테스트
./gradlew test --tests "com.beplepay.welfareaxbe.SomeTest"         # 특정 클래스
./gradlew test --tests "com.beplepay.welfareaxbe.SomeTest.메서드"  # 특정 메서드
./gradlew clean build        # 클린 빌드
```

Windows에서는 `.\gradlew` 또는 `gradlew.bat` 사용.

## 산출물 위치

| 산출물 | 경로 |
|-------|------|
| 개발 브리프 | `target/works/{과업번호}_dev_brief.md` |
| 개발 계획서 | `target/plans/{과업번호}/` |
| 페이즈 문서 | `target/plans/{과업번호}/phases/` |
| 테스트 결과서 | `target/test-reports/{과업번호}_test_result.md` |
| 세션 인수인계 | `HANDOFF.md` (진행 중), `HANDOFF_HISTORY.md` (완료 이력) |

## 설정 데이터 참조

| 파일 | 내용 |
|------|------|
| `.claude/config/project.yaml` | 프로젝트 정의, 가이드 연결 |
| `.claude/config/project-meta.yaml` | 도메인 키워드 사전 |
| `.claude/config/scope.yaml` | 작업 스코프 및 허용 경로 |
| `.claude/config/system.yaml` | GitLab, DB, 리뷰 시스템 설정 |

## 개발 워크플로

```
/dev-interview → /dev-plan → /develop → /qa-test → /code-review → /git → /pack
```

| 단계 | 명령 | 설명 |
|------|------|------|
| 요구사항 정리 | `/dev-interview` | 기획서·주제 → 개발 브리프 작성 |
| 계획 수립 | `/dev-plan {과업번호}` | 브리프 → 개발·테스트 계획서 |
| 구현 시작 | `/develop {스코프} {과업번호}` | 범위 설정 후 구현 |
| QA | `/qa-test {과업번호}` | 테스트 계획서 기준 실행 |
| 코드 리뷰 | `/code-review` | 커밋 전 심각도 검토 |
| 커밋·푸시 | `/git commit`, `/git push` | 브랜치 규칙 준수 |
| MR 리뷰 | `/mr-review` | GitLab MR diff 리뷰 |
| 인수인계 | `/pack` | 세션 종료 전 상태 기록 |

스코프 목록: `ceremony`, `member`, `merchant`, `common`, `batch`

## 하네스 구조

```
.claude/
├── agents/       # 역할별 서브에이전트 정의
├── commands/     # /mr-review, /qa-test 커맨드
├── config/       # 설정 데이터 (YAML)
├── docs/         # 단계별 참조 문서
├── hooks/        # 위험 작업 차단 훅
├── rules/        # 항상 적용되는 공통 규칙
├── skills/       # 슬래시 커맨드 절차 정의
└── settings.json # 권한 차단 설정
```

`.claude/rules/` 파일은 모든 세션에 자동 적용됩니다.
상세 가이드는 `.claude/docs/guideline/`에서 필요 시 참조합니다.

## 주의사항

- `application-prod*`, `application-staging*`, `.env` 파일은 절대 읽거나 수정하지 않는다.
- 경조사 지급·취소·정산 로직은 반드시 계획서 작성 후 구현한다.
- 트랜잭션 내 외부 REST 호출 금지 (DB 커넥션풀 고갈 위험).
- `javax.*` 대신 `jakarta.*` 사용 (Spring Boot 4.x / Jakarta EE 10).
- Entity에 `@Data` 사용 금지.
- `ceremony/` 패키지 코드가 다른 복지 업무 패키지를 직접 참조하지 않도록 주의 (공통은 `common/` 경유).
