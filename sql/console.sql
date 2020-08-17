
/* Table list */
select * from information_schema.tables where table_schema='public';


/* Column List */
select * from information_schema.columns where table_schema='public' and table_name='wallet';

/* Relations */
SELECT
tc.constraint_name, tc.table_name, kcu.column_name,
ccu.table_name AS foreign_table_name,
ccu.column_name AS foreign_column_name
FROM
information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='wallet';

/* Relation Count */
select relations.table_name as table_name,
       count(relations.table_name) as relationships,
       count(relations.referenced_tables) as foreign_keys,
       count(relations.referencing_tables) as references,
       count(distinct related_table) as related_tables,
       count(distinct relations.referenced_tables) as referenced_tables,
       count(distinct relations.referencing_tables) as referencing_tables
from(
     select pk_tco.table_schema || '.' || pk_tco.table_name as table_name,
            fk_tco.table_schema || '.' || fk_tco.table_name as related_table,
            fk_tco.table_name as referencing_tables,
            null::varchar(100) as referenced_tables
     from information_schema.referential_constraints rco
     join information_schema.table_constraints fk_tco
          on rco.constraint_name = fk_tco.constraint_name
          and rco.constraint_schema = fk_tco.table_schema
     join information_schema.table_constraints pk_tco
          on rco.unique_constraint_name = pk_tco.constraint_name
          and rco.unique_constraint_schema = pk_tco.table_schema
    union all
    select fk_tco.table_schema || '.' || fk_tco.table_name as table_name,
           pk_tco.table_schema || '.' || pk_tco.table_name as related_table,
           null as referencing_tables,
           pk_tco.table_name as referenced_tables
    from information_schema.referential_constraints rco
    join information_schema.table_constraints fk_tco
         on rco.constraint_name = fk_tco.constraint_name
         and rco.constraint_schema = fk_tco.table_schema
    join information_schema.table_constraints pk_tco
         on rco.unique_constraint_name = pk_tco.constraint_name
         and rco.unique_constraint_schema = pk_tco.table_schema
) relations
group by table_name
order by relationships desc;

