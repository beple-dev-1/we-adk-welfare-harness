# JPA 개발 가이드

복지AX-BE Spring Data JPA 3.x / Hibernate 6 기반 구현 가이드이다.

> **참고**: Entity·Repository 작성 전 **반드시 db-meta-manager 에이전트를 통해 DDL 메타를 조회**한다.
> DDL에 없는 테이블·컬럼을 추정하거나 임의 생성하지 않는다. (`dev-guide.md` DB 구현 원칙 참조)

---

## 1. Entity 작성 기준

```java
/**
 * 경조사 정보 엔티티.
 */
@Entity
@Table(name = "ceremony")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Ceremony {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 20)
    private String eventType;           // 경조사 유형

    @Column(nullable = false)
    private LocalDate eventDate;        // 경조사 발생일

    @Column(nullable = false, length = 100)
    private String applicantName;

    // 양방향 관계는 꼭 필요한 경우에만 설정
    // @ManyToOne(fetch = FetchType.LAZY) 기본 — EAGER 사용 금지
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    // 생성자: 정적 팩토리 메서드 권장 (유효성 로직 캡슐화)
    public static Ceremony create(String eventType, LocalDate eventDate,
                                  String applicantName, Member member) {
        Ceremony c = new Ceremony();
        c.eventType     = eventType;
        c.eventDate     = eventDate;
        c.applicantName = applicantName;
        c.member        = member;
        return c;
    }
}
```

### Entity 필수 규칙

| 항목 | 규칙 |
|------|------|
| ID 전략 | `@GeneratedValue(strategy = GenerationType.IDENTITY)` |
| 기본 생성자 | `protected` 접근 제한 필수 (`@NoArgsConstructor(access = PROTECTED)`) |
| `@Data` | **Entity에 절대 사용 금지** (equals/hashCode 무한 순환 위험) |
| Fetch 전략 | `@ManyToOne`, `@OneToOne` — **LAZY 기본** (EAGER 사용 금지) |
| 컬럼 제약 | `@Column(nullable = false)`, `length` 등 DDL 제약조건 명시 |
| 양방향 관계 | 꼭 필요한 경우에만 설정. `mappedBy` + `cascade` 신중하게 선택 |

---

## 2. Repository 작성 기준

```java
/**
 * 경조사 Repository.
 */
public interface CeremonyRepository extends JpaRepository<Ceremony, Long> {

    // 단순 조건 조회 — Spring Data 메서드 이름 쿼리 활용
    List<Ceremony> findByMemberId(Long memberId);

    // 복잡한 조회 — @Query JPQL 사용
    @Query("SELECT c FROM Ceremony c JOIN FETCH c.member m " +
           "WHERE m.id = :memberId AND c.eventDate BETWEEN :from AND :to")
    List<Ceremony> findByMemberAndDateRange(
            @Param("memberId") Long memberId,
            @Param("from") LocalDate from,
            @Param("to") LocalDate to);

    // 페이징 — Pageable 파라미터
    Page<Ceremony> findByEventType(String eventType, Pageable pageable);

    // 존재 여부 확인 (count 쿼리 최적화)
    boolean existsByMemberIdAndEventTypeAndEventDate(
            Long memberId, String eventType, LocalDate eventDate);
}
```

---

## 3. N+1 문제 해결

### 방법 1 — `@EntityGraph` (단순 연관 조회)

```java
@EntityGraph(attributePaths = {"member"})
List<Ceremony> findAll();
```

### 방법 2 — JPQL fetch join (복잡한 조건 포함)

```java
@Query("SELECT c FROM Ceremony c JOIN FETCH c.member WHERE c.id = :id")
Optional<Ceremony> findByIdWithMember(@Param("id") Long id);
```

### 주의사항

- **컬렉션 fetch join + Pageable 동시 사용 금지** — `HibernateJpaDialect` 경고 + 인메모리 페이징 위험
- 컬렉션 조회가 필요한 경우: `@BatchSize` 또는 별도 쿼리 분리

---

## 4. 복잡한 조회 — JPQL vs QueryDSL

| 선택 기준 | 방법 |
|----------|------|
| 조건이 2개 이하, 고정 조건 | `@Query` JPQL |
| 동적 조건 (파라미터에 따라 WHERE 절 변경) | QueryDSL `BooleanBuilder` 또는 `Predicate` |
| 집계·통계 쿼리 | `@Query` JPQL 또는 QueryDSL Projection |

### QueryDSL 동적 쿼리 예시

```java
/**
 * 경조사 목록 동적 조회.
 *
 * @param condition 검색 조건 DTO
 * @param pageable  페이징 정보
 * @return 조회 결과 페이지
 */
public Page<Ceremony> searchCeremonies(CeremonySearchCondition condition, Pageable pageable) {
    QCeremony c = QCeremony.ceremony;

    BooleanBuilder builder = new BooleanBuilder();
    if (StringUtils.hasText(condition.getEventType())) {
        builder.and(c.eventType.eq(condition.getEventType()));
    }
    if (condition.getFromDate() != null) {
        builder.and(c.eventDate.goe(condition.getFromDate()));
    }

    List<Ceremony> content = queryFactory
            .selectFrom(c)
            .where(builder)
            .offset(pageable.getOffset())
            .limit(pageable.getPageSize())
            .fetch();

    long total = queryFactory.select(c.count()).from(c).where(builder).fetchOne();
    return new PageImpl<>(content, pageable, total);
}
```

---

## 5. 페이징 처리

```java
// Controller
@GetMapping("/list")
public ResponseEntity<ApiResponse<Page<CeremonyResponse>>> list(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "20") int size) {
    Pageable pageable = PageRequest.of(page, size, Sort.by("eventDate").descending());
    return ResponseEntity.ok(ApiResponse.success(ceremonyService.findAll(pageable)));
}

// Service
@Transactional(readOnly = true)
public Page<CeremonyResponse> findAll(Pageable pageable) {
    return ceremonyRepository.findAll(pageable)
            .map(CeremonyResponse::from);
}
```

---

## 6. 트랜잭션 기준

| 상황 | 설정 |
|------|------|
| 조회 전용 메서드 (기본) | `@Transactional(readOnly = true)` |
| 등록·수정·삭제 메서드 | `@Transactional` |
| 트랜잭션 내 외부 HTTP 호출 | **금지** — 트랜잭션 밖으로 분리 |
| 복잡한 비즈니스 로직 | 트랜잭션 시작을 최대한 늦게 (외부 API 호출 완료 후 트랜잭션 진입) |

```java
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)   // 클래스 레벨: 조회 기본
public class CeremonyApplicationServiceImpl implements CeremonyApplicationService {

    @Transactional                // 메서드 레벨: 쓰기 오버라이드
    public CeremonyApplyResponse apply(CeremonyApplyRequest req) {
        // 외부 API 호출은 이미 완료 후 진입
        Ceremony ceremony = Ceremony.create(...);
        ceremonyRepository.save(ceremony);
        return CeremonyApplyResponse.from(ceremony);
    }
}
```

---

## 7. DB 구현 원칙 (필수 준수)

1. **DDL 메타 선확인 필수**: Entity·Repository·nativeQuery 작성 전 db-meta-manager 에이전트로 실제 테이블·컬럼 DDL 조회
2. **추정 금지**: DDL에 없는 테이블·컬럼을 임의로 추정하거나 생성하지 않는다
3. **미확인 시 중단**: 필요한 테이블·컬럼이 DDL에 없으면 즉시 구현을 멈추고 사용자에게 확인 요청
4. **Native Query 검증**: `@Query(nativeQuery = true)` 작성 시 PostgreSQL 방언(dialect) 기준으로 작성

---

## 8. 구현 완료 자가점검

- [ ] Entity `@NoArgsConstructor(access = PROTECTED)` 적용
- [ ] `@Data` Entity 미사용 확인
- [ ] `@ManyToOne`, `@OneToOne` LAZY fetch 확인
- [ ] N+1 발생 가능 연관 조회에 `@EntityGraph` 또는 fetch join 적용
- [ ] 동적 조건이 있는 조회에 QueryDSL 사용
- [ ] 페이징 조회에 `Pageable` 파라미터 사용
- [ ] `@Transactional(readOnly = true)` 기본 적용, 쓰기 메서드에 `@Transactional`
- [ ] 트랜잭션 내 외부 HTTP 호출 없음
- [ ] Entity·nativeQuery 작성 전 DDL 메타 조회 완료
- [ ] DDL에 없는 컬럼·테이블 임의 생성 없음
