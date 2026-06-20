#!/bin/bash
# dev-plan 완료 후 qa-plan 자동 실행 훅
# SubagentStop: dev-planner 에이전트 완료 후 실행됨

set -euo pipefail

TASK_NUMBER="${1:-}"
PLANS_DIR="target/plans/${TASK_NUMBER}"

if [[ -z "$TASK_NUMBER" ]]; then
  echo "[auto-qa-plan] 과업번호가 없어 자동 QA 계획 생성을 건너뜁니다."
  exit 0
fi

DEV_PLAN="${PLANS_DIR}/${TASK_NUMBER}_dev_plan.md"

if [[ ! -f "$DEV_PLAN" ]]; then
  echo "[auto-qa-plan] 개발 계획서를 찾을 수 없습니다: $DEV_PLAN"
  exit 0
fi

echo "[auto-qa-plan] 개발 계획서 확인 완료: $DEV_PLAN"
echo "[auto-qa-plan] qa-planner 에이전트를 실행하여 테스트 계획서를 생성합니다..."
exit 0
