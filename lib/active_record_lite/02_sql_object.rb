require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'
#require_relative '03_searchable.rb'

class MassObject
  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end
end

class SQLObject < MassObject

  # def self.assoc_options
  #   @assoc_options ||= {}
  # end

  def self.table_name=(table_name)
    @table_name= table_name
  end

  def self.table_name
    @table_name ||= self.name.underscore.pluralize
  end

  def self.all

    results = DBConnection.execute(<<-SQL)
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    SQL


    parse_all(results)
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
    #{ table_name }.*
      FROM
    #{ table_name }
      WHERE
    #{ table_name }.id = ?
    SQL

    parse_all(results).first
  end

  def insert

    col_names = self.class.attributes.join(", ")
    question_marks = []

    self.class.attributes.count.times do
      question_marks << "?"
    end
    question_marks = question_marks.join(", ")


    DBConnection.execute(<<-SQL, attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
      SQL

    self.id = DBConnection.last_insert_row_id
  end

  def save
    @id ? update : insert
  end

  def update
    set_line = attributes_without_id.map {|attr_name| "#{attr_name} = ?"}.reverse

    DBConnection.execute(<<-SQL, attribute_values.reverse)
    UPDATE
      #{self.class.table_name}
    SET
      #{set_line.join(", ")}
    WHERE
      id = ?
    SQL


  end


  def attribute_hash
    # build hash of non-nil attributes
    row = {}
    self.class.attributes.each do |attr|
      value = self.send(attr)
      row[attr] = value unless value.nil?
    end
    row
  end


  def attributes_without_id
    class_attributes = self.class.attributes.dup
    class_attributes.delete(:id)
    class_attributes.map {|sym| sym.to_s}
  end

  def attribute_values
    self.class.attributes.map do |attribute|
      self.send(attribute)
    end
  end


end
