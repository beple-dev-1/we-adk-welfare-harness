# /mr-review 커맨드

GitLab MR diff를 리뷰하고 결과를 MR 댓글로 등록한다.

## 사용법
```
/mr-review {프로젝트명+MR번호 | MR URL} [en]
```
예시: `/mr-review ax 42`, `/mr-review https://gitlab.com/.../merge_requests/42`

## 절차

### 1. 입력 파싱
- `.claude/config/system.yaml`의 `gitlab` 설정에서 base URL과 project_id 매핑을 읽는다.
- MR 번호 또는 URL에서 project_id와 MR IID를 파싱한다.
- `en` 옵션이 있으면 리뷰 출력 언어를 영어로 설정한다.

### 2. GitLab MR diff 수집
```bash
curl -s -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "{gitlab.baseUrl}/api/v4/projects/{project_id}/merge_requests/{mr_iid}/changes"
```
- GitLab 연동이 설정되지 않은 경우 오류를 안내하고 중단한다.

### 3. mr-reviewer 에이전트 실행
- diff를 mr-reviewer 에이전트에 전달한다.
- `.claude/docs/anti-patterns/incident-antipatterns.md` 기준 적용

### 4. 댓글 등록 및 알림
- 리뷰 결과를 GitLab MR 댓글로 등록한다.
- `system.yaml`의 `notification.enabled`가 true이면 알림도 전송한다.

## 설정 미완료 시
`system.yaml`의 `gitlab.baseUrl`이 비어있으면:
"GitLab 연동이 설정되지 않았습니다. `.claude/config/system.yaml`의 `gitlab` 섹션을 설정해주세요."
