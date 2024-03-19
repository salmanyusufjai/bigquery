WITH SortingCriteria AS (
  SELECT
    CASE
      WHEN gazzate_pubish_date IS NOT NULL AND transaction_type IN ('01', '02') THEN gazzate_pubish_date
      WHEN gazzate_pubish_date IS NOT NULL AND transaction_type IN ('03', '04') AND correction_marker != 9 THEN gazzate_pubish_date
      WHEN document_received_date IS NOT NULL THEN document_received_date
      WHEN tape_date IS NOT NULL THEN tape_date
      ELSE processing_date
    END AS sorting_criteria,
    COUNT(*) AS total_records
  FROM
    your_table
  WHERE
    (gazzate_pubish_date IS NOT NULL AND transaction_type IN ('01', '02'))
    OR (gazzate_pubish_date IS NOT NULL AND transaction_type IN ('03', '04') AND correction_marker != 9)
    OR document_received_date IS NOT NULL
    OR tape_date IS NOT NULL
    OR processing_date IS NOT NULL
  GROUP BY
    sorting_criteria
)

SELECT
  sorting_criteria,
  total_records,
  COUNT(*) AS duplicate_records
FROM
  SortingCriteria
GROUP BY
  sorting_criteria,
  total_records
HAVING
  COUNT(*) > 1;
