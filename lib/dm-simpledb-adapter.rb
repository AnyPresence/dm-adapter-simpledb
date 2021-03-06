require 'dm-core'
require 'dm-aggregates'
require 'dm-migrations'
require 'dm-types'
require 'digest/sha1'
require 'uuidtools'
require 'sdbtools'

$:.unshift(File.dirname(__FILE__))
require 'dm-simpledb-adapter/sdb_array'
require 'dm-simpledb-adapter/utils'
require 'dm-simpledb-adapter/record'
require 'dm-simpledb-adapter/table'
require 'dm-simpledb-adapter/where_expression'
require 'dm-simpledb-adapter/migrations/simpledb_adapter'
require 'dm-simpledb-adapter/adapters/simpledb_adapter'
