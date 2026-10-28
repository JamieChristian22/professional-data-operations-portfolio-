-- SQL training examples: adapt table names and functions to your database dialect.
-- 01: Canonical key collisions
SELECT external_key, COUNT(*) AS rows_per_key FROM canonical_master
GROUP BY external_key HAVING COUNT(*) > 1;

-- 02: Ownership gaps
SELECT COUNT(*) AS unowned_rows FROM canonical_master
WHERE account_owner IS NULL OR TRIM(account_owner) = '';

-- 03: Orphan parent IDs (if source snapshot retains parent refs)
SELECT s.source_id, s.parent_source_id FROM source_snapshot s
LEFT JOIN source_snapshot parent ON s.parent_source_id = parent.source_id
WHERE s.parent_source_id IS NOT NULL AND s.parent_source_id <> ''
  AND parent.source_id IS NULL;

-- 04: Source to published reconciliation (counts are simulated; use actual table names)
SELECT (SELECT COUNT(*) FROM source_snapshot) AS source_rows,
       (SELECT COUNT(*) FROM canonical_master) AS published_rows;
