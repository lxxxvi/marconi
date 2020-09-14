# rubocop:disable Metrics/ClassLength
class CachedFactsTableCreator
  def initialize(factable_type)
    @factable_type = factable_type
  end

  def create!
    execute(create_extension_sql)

    ActiveRecord::Base.transaction do
      execute(drop_temporary_table_sql)
      execute(create_temporary_table_sql)
      execute(drop_facts_table_sql)
      execute(create_facts_table_sql)
      execute(add_index_on_foreign_key_sql)
    end

    cached_facts_table_name
  end

  def execute(statement)
    ActiveRecord::Base.connection.execute(statement)
  rescue StandardError => e
    Rails.logger.error "Failing statement: \n\n#{statement}"
    raise e
  end

  def temporary_table_name
    "#{@factable_type.to_s.downcase.pluralize}_facts_with_missing"
  end

  def cached_facts_table_name
    "cached_#{@factable_type.to_s.downcase}_facts"
  end

  def foreign_key_column_name
    "#{@factable_type.to_s.downcase}_id"
  end

  def index_name
    "index_#{foreign_key_column_name}_on_#{cached_facts_table_name}"
  end

  def create_extension_sql
    'CREATE EXTENSION IF NOT EXISTS tablefunc'
  end

  def drop_temporary_table_sql
    "DROP TABLE IF EXISTS #{temporary_table_name}"
  end

  def drop_facts_table_sql
    "DROP TABLE IF EXISTS #{cached_facts_table_name}"
  end

  def ordered_list_of_keys_sql
    <<~SQL.squish
      SELECT DISTINCT
             f.key     AS key
        FROM facts f
       WHERE f.factable_type = '#{@factable_type.to_s.capitalize}'
       ORDER BY f.key
    SQL
  end

  def create_temporary_table_sql
    <<~SQL.squish
      CREATE TEMPORARY TABLE #{temporary_table_name}
      AS
      WITH
        facts_keys AS (
          #{ordered_list_of_keys_sql}
        ),

        existing_facts AS (
          SELECT station_id      AS station_id
               , factable_id     AS factable_id
               , key             AS key
               , value           AS value
            FROM facts
           WHERE factable_type = '#{@factable_type.to_s.capitalize}'
        ),

        unique_existing_facts AS (
          SELECT DISTINCT
                 station_id                 AS station_id
               , factable_id                AS factable_id
            FROM existing_facts
        ),

        all_possible_facts_combinations AS (
          SELECT uesf.station_id            AS station_id
               , uesf.factable_id           AS factable_id
               , sfk.key                    AS key
            FROM unique_existing_facts uesf
           CROSS JOIN facts_keys sfk
        ),

        facts_raw_data AS (
          SELECT apsfc.station_id           AS station_id
               , apsfc.factable_id          AS factable_id
               , apsfc.key                  AS key
               , esf.value                  AS value
            FROM all_possible_facts_combinations apsfc
            LEFT OUTER JOIN existing_facts esf ON apsfc.station_id = esf.station_id
                                                   AND apsfc.factable_id = esf.factable_id
                                                   AND apsfc.key = esf.key
        )
        SELECT cast(station_id || '~' || factable_id AS varchar)  AS group_key
             , key                                                AS key
             , value                                              AS value
          FROM facts_raw_data
    SQL
  end

  def create_facts_table_sql
    <<~SQL.squish
      CREATE TABLE #{cached_facts_table_name}
      AS
      WITH
        pivoted_facts AS (
          SELECT position('~' in group_key) delimiter_position
               , *
            FROM crosstab('SELECT group_key
                                , key
                                , value
                             FROM #{temporary_table_name}
                         ORDER BY group_key, key')
                  AS ct(
                        group_key VARCHAR
                      , #{list_of_keys_for_pivot_statement}
                    )
        ),
        resolved_facts AS (
          SELECT CAST(substring(group_key FROM 1 FOR delimiter_position - 1) AS INT) AS station_id
               , CAST(substring(group_key FROM delimiter_position + 1) AS INT) AS factable_id
               , pf.*
            FROM pivoted_facts pf
        )
        SELECT station_id                          AS station_id
             , factable_id                         AS #{foreign_key_column_name}
             , #{list_of_keys_for_select_statement}
          FROM resolved_facts sf
    SQL
  end

  def add_index_on_foreign_key_sql
    <<~SQL.squish
      CREATE INDEX #{index_name}
      ON #{cached_facts_table_name}
      (
        #{foreign_key_column_name}
      )
    SQL
  end

  # ['foo', 'bar', 'baz']
  # => "foo VARCHAR, bar VARCHAR, baz VARCHAR"
  def list_of_keys_for_pivot_statement
    sorted_list_of_keys.map { "#{_1} VARCHAR" }.join(', ')
  end

  def list_of_keys_for_select_statement
    sorted_list_of_keys.join(', ')
  end

  def sorted_list_of_keys
    @sorted_list_of_keys ||= fetch_list_of_keys.sort
  end

  def fetch_list_of_keys
    execute(ordered_list_of_keys_sql).values.flatten
  end
end
# rubocop:enable Metrics/ClassLength
