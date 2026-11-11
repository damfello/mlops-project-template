-- Staging: 1:1 with the raw source, only renames/casts. Requires the
-- `ingest` stage to have produced data/raw/dataset.csv.
select
    cast(x1 as double) as x1,
    cast(x2 as double) as x2,
    cast(x3 as double) as x3,
    cast(x4 as double) as x4,
    cast(target as integer) as target
from read_csv_auto('data/raw/dataset.csv')
