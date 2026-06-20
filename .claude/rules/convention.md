# 코드 컨벤션

## Java 코드 스타일

- 들여쓰기: 스페이스 4칸
- 최대 줄 길이: 120자
- 클래스·인터페이스: PascalCase
- 메서드·변수: camelCase
- 상수: UPPER_SNAKE_CASE
- 패키지: lowercase

## 네이밍 규칙

### 레이어별 클래스 접미사
- Controller: `*Controller` (예: `CeremonyController`)
- Service 인터페이스: `*Service` (예: `CeremonyApplicationService`)
- Service 구현체: `*ServiceImpl` (예: `CeremonyApplicationServiceImpl`)
- Repository: `*Repository` (예: `CeremonyRepository`)
- Entity: 도메인 명사 그대로 (예: `Ceremony`, `Member`, `Merchant`)
- DTO 요청: `*Request` 또는 `*Req` (예: `CeremonyApplyRequest`)
- DTO 응답: `*Response` 또는 `*Res` (예: `CeremonyApplyResponse`)
- 예외: `*Exception` (예: `CeremonyNotFoundException`)

### 패키지 구조 기준

```
com.beplepay.welfareaxbe
├── config/           # Spring 설정 클래스
├── common/           # 공통 인프라 (모든 업무 공유)
│   ├── exception/    # 공통 예외, 전역 핸들러
│   ├── response/     # ApiResponse 래퍼
│   └── util/         # 유틸리티
├── security/         # Spring Security, JWT
├── member/           # 회원 관리 — 복지 공통
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── entity/
│   └── dto/
├── merchant/         # 가맹점 관리 — 복지 공통
│   └── (동일 구조)
└── ceremony/         # 경조사 전용 (현재 구현)
    ├── application/  # 경조사 신청 처리
    ├── approval/     # 승인 처리
    ├── payment/      # 지급 처리
    └── settlement/   # 정산 처리
```

**패키지 분리 규칙:**
- `ceremony/` 하위 코드가 `member/`, `merchant/`를 직접 import할 수 있으나
  다른 복지 업무 패키지(미래에 추가될)를 직접 참조하지 않는다.
- 업무 간 공유가 필요한 코드는 반드시 `common/`으로 이동한다.

## import 순서
1. java.*
2. javax.*, jakarta.*
3. org.*
4. com.*(외부 라이브러리)
5. com.beplepay.*(내부)

(각 그룹 사이 빈 줄)

## 주석
- 모든 주석은 한국어로 작성한다.
- WHY가 명확한 경우에만 주석을 달고, WHAT 설명 주석은 작성하지 않는다.
- Javadoc은 public API에만 작성하고 간결하게 유지한다.

## Lombok 사용 기준
- Entity: `@Getter`, `@NoArgsConstructor(access = PROTECTED)` 기본
- DTO: `@Getter`, `@Builder`, `@AllArgsConstructor`, `@NoArgsConstructor`
- `@Data`는 Entity에 사용 금지 (equals/hashCode 문제)
- `@RequiredArgsConstructor`는 Service/Controller DI에 사용

## JPA Entity 기준
- `@Entity` 클래스는 `public`이며 `protected` 기본 생성자 필수
- ID 생성 전략: `@GeneratedValue(strategy = GenerationType.IDENTITY)`
- 양방향 관계는 필요한 경우에만 사용, 무한 순환 주의
- `@Column(nullable = false)` 등 제약조건 명시
