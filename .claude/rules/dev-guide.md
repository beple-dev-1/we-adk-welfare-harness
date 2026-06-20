# 개발 가이드

## 아키텍처 원칙: 공통 vs 경조사 전용 분리

복지AX-BE는 현재 **경조사지원**을 첫 번째 업무로 개발하며, 향후 다른 성격의 복지 업무가 추가된다.
소스 코드는 다음 원칙으로 분리한다:

| 레이어 | 패키지 | 설명 |
|-------|-------|------|
| 공통 인프라 | `common/`, `config/`, `security/` | 모든 업무에서 사용하는 기반 코드 |
| 복지 공통 도메인 | `member/`, `merchant/` | 모든 복지 업무에서 공유하는 도메인 |
| 경조사 전용 | `ceremony/` | 경조사지원 전용 비즈니스 로직 |

새로운 복지 업무 추가 시: 새 최상위 패키지(예: `housing/`, `health/`)를 추가하고 `common/`의 공통 기능을 활용한다.

## 새 구현 전 확인 사항

1. `com.beplepay.welfareaxbe.common` 패키지에 공통 기능이 이미 있는지 확인한다.
2. 경조사 전용 코드인지 공통으로 올릴 코드인지 먼저 판단한다.
3. 프로젝트 유형에 맞는 가이드 문서를 먼저 읽는다.
4. 기존 유사 구현이 있으면 패턴을 맞춘다 — code-investigator 에이전트 활용.

## Spring Boot 4.1.0 주의사항

- Spring Boot 4.x는 Jakarta EE 10 기반: `javax.*` → `jakarta.*`
- Spring Security 6.x 이상 사용 중: 보안 설정은 `SecurityFilterChain` Bean 방식
- Spring Data JPA 3.x: Hibernate 6 기반, native query 작성 시 방언(dialect) 확인

## API 구현 기준

- 모든 API 응답은 공통 응답 래퍼(예: `ApiResponse<T>`)를 사용한다.
- 예외 처리는 `@RestControllerAdvice`를 통해 일관되게 처리한다.
- 입력값 검증은 `@Valid` + Bean Validation을 사용하고, 서버 검증을 반드시 수행한다.
- 경조사 지급·취소·정산 API는 반드시 멱등성 키 또는 중복 처리 방지 로직을 포함한다.

## JPA 사용 기준

- 복잡한 조회는 `@Query` JPQL 또는 QueryDSL 사용
- 대용량 데이터 처리: `@Query` + `Pageable` 또는 Scroll API 사용
- N+1 문제: `@EntityGraph` 또는 `fetch join` 명시적 사용
- 트랜잭션 범위: `@Transactional`은 Service 레이어에서 관리
- 트랜잭션 내 외부 REST 호출 금지 (DB 커넥션풀 고갈 위험)

## 배치 처리 기준

- Spring Batch 5.x 기반 Job으로 구현
- 배치 Job은 멱등성 보장: 동일 조건 재실행 시 중복 처리 없음
- 실패 시 재처리 로직 명시적 설계
- 배치 실행 결과는 로그 및 DB에 기록

## 보안 구현 기준

- 인증은 JWT 기반 구현 (Spring Security 6.x 필터 체인)
- 권한 검사는 메서드 레벨 `@PreAuthorize` 또는 컨트롤러 레벨 `.requestMatchers()` 사용
- 민감 정보(주민번호, 계좌번호 등)는 암호화하여 저장
