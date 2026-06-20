# /java-junit 스킬

JUnit5 기반 단위 테스트 작성을 지원한다.

## 복지AX 테스트 표준

### 의존성
```xml
<!-- build.gradle.kts에 이미 포함됨 -->
testImplementation("org.springframework.boot:spring-boot-starter-webmvc-test")
testImplementation("org.springframework.boot:spring-boot-starter-data-jpa-test")
testImplementation("org.springframework.boot:spring-boot-starter-security-test")
```

### Service 단위 테스트 템플릿
```java
@ExtendWith(MockitoExtension.class)
class BenefitServiceImplTest {

    @InjectMocks
    private BenefitServiceImpl benefitService;

    @Mock
    private BenefitRepository benefitRepository;

    @Test
    void 혜택_지급_성공() {
        // given
        // when
        // then
    }

    @Test
    void 잔액_부족시_예외발생() {
        // given
        // when & then
        assertThatThrownBy(() -> benefitService.grant(...))
            .isInstanceOf(InsufficientBalanceException.class);
    }
}
```

### Controller 슬라이스 테스트 템플릿
```java
@WebMvcTest(BenefitController.class)
class BenefitControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private BenefitService benefitService;

    @Test
    @WithMockUser(roles = "USER")
    void 혜택_지급_API_200() throws Exception {
        mockMvc.perform(post("/api/v1/benefits/grant")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{...}"))
            .andExpect(status().isOk());
    }
}
```

### Repository 슬라이스 테스트 템플릿
```java
@DataJpaTest
class MemberRepositoryTest {

    @Autowired
    private MemberRepository memberRepository;

    @Test
    void 회원_저장_및_조회() {
        // given
        // when
        // then
    }
}
```

### 테스트 메서드명 규칙
한국어 사용 권장: `{행위}_{상황}_{기대결과}()`
예: `혜택지급_잔액부족시_InsufficientBalanceException발생()`
