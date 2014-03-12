# ActiveRecord Lite

Clone of ActiveRecord's ORM features to explore Ruby metaprogramming and see how ActiveRecord works with SQL. Includes mass assignment, querying, and association methods.


## attr_accessor_object and mass_object
* `my_attr_accessor` using `define_method`
* `my_attr_accessible`
* `attributes` and `my_attr_accessible`

## SQL_Object
* `::find` to look up single record by primary key
* `::all` to return array of all records in DB
* `#insert` to insert new row into table to represent `SQLObject`
* `#update` to update the row with `id` of `SQLObject`
* `#save` is a convenience method to call `insert` or `update` depending of `SQLObject` already exists

## Searchable
* Search with `::where` with unlimited parameters and mixing it into SQL object

## Associatable
* Module defines `belongs_to`, `has_many`, and `has_one_through`