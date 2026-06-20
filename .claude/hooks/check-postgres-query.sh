#!/bin/bash
# PostgreSQL 쿼리 안전성 검사 훅
# MCP postgres 도구 실행 전 DML/DDL 차단

set -euo pipefail

QUERY="${CLAUDE_TOOL_INPUT:-}"

# 차단 대상: DML/DDL 명령
BLOCKED_KEYWORDS=(
  "INSERT "
  "UPDATE "
  "DELETE "
  "DROP "
  "ALTER "
  "TRUNCATE "
  "CREATE "
  "GRANT "
  "REVOKE "
)

QUERY_UPPER=$(echo "$QUERY" | tr '[:lower:]' '[:upper:]')

for KEYWORD in "${BLOCKED_KEYWORDS[@]}"; do
  if [[ "$QUERY_UPPER" == *"$KEYWORD"* ]]; then
    echo "⛔ [check-postgres-query] 차단: DB 변경 쿼리는 실행할 수 없습니다."
    echo "   감지된 키워드: $KEYWORD"
    echo "   사유: 개발 중 의도치 않은 DB 변경 방지"
    exit 1
  fi
done

# 실제 업무 데이터 조회 차단 (메타 조회만 허용)
BUSINESS_TABLES=(
  "member"
  "benefit_grant"
  "payment"
  "settlement"
  "transaction"
)

for TABLE in "${BUSINESS_TABLES[@]}"; do
  TABLE_UPPER=$(echo "$TABLE" | tr '[:lower:]' '[:upper:]')
  if [[ "$QUERY_UPPER" == *"FROM $TABLE_UPPER"* ]] || [[ "$QUERY_UPPER" == *"FROM ${TABLE_UPPER}S"* ]]; then
    # information_schema 나 pg_* 조회가 아닌 경우 차단
    if [[ "$QUERY_UPPER" != *"INFORMATION_SCHEMA"* ]] && [[ "$QUERY_UPPER" != *"PG_"* ]]; then
      echo "⛔ [check-postgres-query] 차단: 업무 데이터 직접 조회는 허용되지 않습니다."
      echo "   대상 테이블: $TABLE"
      echo "   사유: 회원·거래·혜택 실데이터 보호 정책"
      exit 1
    fi
  fi
done

exit 0
