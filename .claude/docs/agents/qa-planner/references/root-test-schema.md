# 테스트 계획서 루트 문서 형식

`target/plans/{과업번호}/{과업번호}_test_plan.md` 파일의 형식이다.

```markdown
# 테스트 계획서

| 항목 | 내용 |
|------|------|
| 과업번호 | {N} |
| 제목 | {과업 제목} 테스트 계획 |
| 작성일 | {YYYY-MM-DD} |
| 대응 개발 계획서 | {N}_dev_plan.md |

## 1. 테스트 범위
{테스트 대상 기능 목록}

## 2. 테스트 방법
| 유형 | 도구 | 범위 |
|------|------|------|
| 단위 테스트 | JUnit5 + Mockito | Service 비즈니스 로직 |
| 슬라이스 테스트 | @WebMvcTest, @DataJpaTest | Controller, Repository |
| 통합 테스트 | @SpringBootTest | 주요 흐름 E2E |

## 3. 테스트 환경
- DB: H2 (단위/슬라이스), Testcontainers PostgreSQL (통합)
- Spring Boot 테스트 슬라이스 활용

## 4. 테스트케이스 목록
| TC 번호 | 제목 | 유형 | 우선순위 | 완료 |
|--------|------|------|---------|------|
| TC-{N}-BENEFIT-001 | ... | 단위 | 높음 | [ ] |

## 5. 완료 기준 (DoD)
- [ ] 전체 TC GREEN
- [ ] CRITICAL 항목 0건
- [ ] 경계값 케이스 포함 확인
- [ ] 중복 처리 방지 케이스 포함 확인
```
