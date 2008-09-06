require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  should "have FmdbMigrationManager class" do
    assert OSX::FmdbMigrationManager
  end
  
  context "with clean sqlite db" do
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = OSX::FMDatabase.databaseWithPath @db_path
      @db.open
    end
    
    teardown { FileUtils.rm @db_path if File.exists?(@db_path) }

    should "create sqlite db" do
      assert File.exists?(@db_path)
    end
    
    should_have_no_errors
    
    context "prepare for migrations" do
      setup do
        @migration_manager = OSX::FmdbMigrationManager.alloc.initWithDatabase(@db)
      end
      
      should "have migration manager" do
        assert_not_nil(@migration_manager)
        assert_instance_of(OSX::FmdbMigrationManager, @migration_manager)
      end

      context "then create table with no explicit columns" do
        setup do
          @m1 = @migration_manager.createTable("people")
          @results = find_all "people"
        end
        
        teardown { @results.close if @results }
        
        should_have_no_errors

        should "have table 'people'" do
          assert_not_nil(@results)
          assert_instance_of(OSX::FMResultSet, @results)
          assert(!@results.next?, "Should be no results")
        end
        
        should "have default column 'id'" do
          assert_equal(0, @results.columnIndexForName("id"))
        end
        
        context "then insert some rows" do
          setup do
            @results.close
            @db.executeUpdate "insert into people default values"
            @db.executeUpdate "insert into people default values"
          end
          
          should "autoincrement primary key column" do
            @results = find_all "people"
            expected_id = 1
            while @results.next?
              assert_equal(expected_id, @results.intForColumn("id"), "default id value incorrect")
              expected_id += 1
            end
            assert_equal(3, expected_id, "should only be 2 returned rows")
          end
        end
        
        context "then destroy table" do
          setup do
            @results.close
            @migration_manager.dropTable "people"
            @results = find_all "people"
          end

          should "have destroyed table" do
            assert(@db.hadError?, "Should be an error for query on non-existent table")
          end
        end
        
      end
      
    end
    
  end
  
end