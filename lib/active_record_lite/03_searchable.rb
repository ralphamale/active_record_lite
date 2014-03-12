require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map do |key|
        "#{key} = ?"
      end.join(" AND ")

    found = DBConnection.execute(<<-SQL, params.values)
        SELECT
        *
        FROM
        #{self.table_name}
        WHERE
        #{where_line}
        SQL

        parse_all(found)
  end
end


class SQLObject
  extend Searchable

  # Mixin Searchable here...
end
