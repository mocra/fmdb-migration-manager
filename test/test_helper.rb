require "test/unit"
require "osx/cocoa"

$:.unshift File.dirname(__FILE__) + "/../build/bundles"
$:.unshift File.dirname(__FILE__) + "/migrations"

require "fileutils"
require "rubygems"
gem 'Shoulda'
require "Shoulda"

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

# load fixture migrations
require "create_accounts"
require "create_transactions"
require "add_timestamp_to_transactions"

class Test::Unit::TestCase
  def self.should_have_no_errors
    should "have no db errors" do
      assert_no_errors(@db)
    end
  end

  def self.should_have_table(table_name, &block)
    @current_table_name = table_name
    should "have table '#{table_name}'" do
      @results = find_all table_name
      assert_no_errors(@db)
      assert_instance_of(OSX::FMResultSet, @results)
      @results.close
    end
    yield if block_given?
  end

  def self.should_have_column(column_name, table_name = @current_table_name)
    should "have column '#{column_name}' on table '#{table_name}'" do
      @results = find_all table_name
      assert_no_errors(@db)
      assert_not_equal(-1, @results.columnIndexForName(column_name))
      @results.close
    end
  end
  
  def self.should_not_have_column(column_name, table_name = @current_table_name)
    should "not have column '#{column_name}' on table '#{table_name}'" do
      @results = find_all table_name
      assert(!@results.columnNameToIndexMap[column_name])
      @results.close
    end
  end

  def find_all(table_name)
    @db.executeQuery "select * from #{table_name}"
  end
  
  def assert_no_errors(db)
    assert(!db.hadError?, "Last error (#{db.lastErrorCode}): #{db.lastErrorMessage}")
  end

  def assert_some_errors(db)
    assert(db.hadError?)
  end
end

class Thoughtbot::Shoulda::Context
  def setup_db
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = OSX::FMDatabase.databaseWithPath @db_path
      # @db.setTraceExecution true
      @db.open
    end
  end

  def teardown_db
    teardown { FileUtils.rm @db_path if File.exists?(@db_path) }
  end
end