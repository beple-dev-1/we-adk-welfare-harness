# HANDOFF

> 이 파일은 세션 종료 시 `/pack` 명령으로 자동 갱신됩니다.
> 진행 중인 작업의 상태를 다음 세션에서 이어받을 수 있도록 기록합니다.

## 진행 중인 작업
없음 — 초기 하네스 구성 완료 및 프로젝트 설정 변경

## 최근 작업 요약
- 프로젝트명: welfare-ax → welfare-ax-be
- 패키지: com.beplepay.welfareax → com.beplepay.welfareaxbe
- 회사명: 베플페이 → 비플페이(beplepay)
- 도메인 아키텍처: 경조사 전용(ceremony/) + 복지 공통(member/, merchant/, common/) 분리 구조 정의
- 전체 파일 `biplepay` → `beplepay` 수정 완료 (16개 파일)
- 구 패키지 디렉터리(`com/biplepay/`) 삭제 완료

## 다음 단계
1. `.claude/config/system.yaml`에 GitLab URL과 프로젝트 ID 설정 (MR 리뷰 연동 시)
2. `.mcp.json`에 실제 PostgreSQL 접속 정보 설정
3. 첫 번째 기능 개발: `/dev-interview`로 경조사 신청 API 시작

## 미결 사항
- GitLab 연동 정보 미설정
- PostgreSQL MCP 연결 정보 미설정
