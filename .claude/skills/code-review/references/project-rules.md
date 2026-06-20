# 복지AX 프로젝트 코드 리뷰 기준

## 복지혜택 도메인 규칙

### 지급 API
- 멱등성 키 또는 unique 제약으로 중복 지급 방지 필수
- 지급 전 잔액/한도 검증 로직 존재 확인
- 지급 결과는 이력 테이블에 기록

### 취소 API
- 원거래 조회 후 취소 처리
- 이미 취소된 거래의 재취소 방지
- 부분 취소 지원 여부 명시

### 정산 배치
- Job 단위 멱등성 (동일 날짜 재실행 시 중복 없음)
- 처리 상태 컬럼으로 재처리 대상 구분
- 실패 레코드 별도 관리

## Spring Boot 4.1.0 규칙

### Jakarta EE
- `javax.*` 대신 `jakarta.*` 사용 확인
- Spring Security 6.x: WebSecurityConfigurerAdapter 미사용 확인

### JPA/Hibernate
- Entity에 `@Data` 사용 금지
- 양방향 관계 `mappedBy` 명시
- `@Column(nullable = false)` 등 제약조건 명시

### Lombok
- Entity: `@NoArgsConstructor(access = AccessLevel.PROTECTED)` 사용
- `@RequiredArgsConstructor`는 Service/Controller DI에 활용

## 공통 모듈 사용 규칙
- 응답 래퍼: 프로젝트 공통 `ApiResponse<T>` 사용
- 예외: 커스텀 예외 클래스 + `@RestControllerAdvice`
- 공통 기능 중복 구현 금지
