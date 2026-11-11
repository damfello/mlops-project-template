-- Example mart: an aggregated, analysis-ready table.
select
    count(*) as n_rows,
    avg(target) as target_rate
from {{ ref('stg_dataset') }}
