class QueryCollection {
  static String selectAllTable({String schema = 'public'}) => '''
  select table_schema,
       table_name from information_schema.tables where table_schema='$schema';
         ''';

  static String getAllColumn(String tableName, {String schema = 'public'}) => '''
select column_name,
       data_type,
       is_nullable,
       is_identity,
       is_self_referencing
from information_schema.columns
where table_schema = '$schema'
  and table_name = '$tableName';
  ''';

  static String getAllPrimaryKey({String schema = 'public'}) => '''
select
       kcu.table_name,
       kcu.column_name      as key_column,
       tco.constraint_name,
       kcu.ordinal_position as position
from information_schema.table_constraints tco
         join information_schema.key_column_usage kcu
              on kcu.constraint_name = tco.constraint_name
                  and kcu.constraint_schema = tco.constraint_schema
                  and kcu.constraint_name = tco.constraint_name
where tco.constraint_type = 'PRIMARY KEY'
  and tco.table_schema = '$schema'
  ''';

  static String getTableConstraints(String tableName, {String schema = 'public'}) => '''
SELECT tc.constraint_type,
       tc.table_name,
       kcu.column_name,
       ccu.table_name  AS foreign_table_name,
       ccu.column_name AS foreign_column_name,
       tc.table_schema
FROM information_schema.table_constraints AS tc
         JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
         JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_schema = 'public'
  and tc.table_name = '$tableName'
order by tc.constraint_type desc
  ''';

  static String getForeignTableConstraints(String tableName, {String schema = 'public'}) => '''
SELECT tc.constraint_type,
       tc.table_name,
       kcu.column_name,
       ccu.table_name  AS foreign_table_name,
       ccu.column_name AS foreign_column_name,
       tc.table_schema
FROM information_schema.table_constraints AS tc
         JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
         JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_schema = '$schema'
  and ccu.table_name = '$tableName' and tc.constraint_type='FOREIGN KEY'
order by tc.constraint_type desc;
''';
}
