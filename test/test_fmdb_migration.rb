require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

# load fixture migrations
require "create_accounts"

class TestFmdbMigration < Test::Unit::TestCase
  include OSX
  
  should "have FmdbMigration class" do
    assert FmdbMigration
  end
  
  context "with clean sqlite db" do
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = FMDatabase.databaseWithPath @db_path
      @db.open
    end
    
    teardown { FileUtils.rm @db_path if File.exists?(@db_path) }

    should "create sqlite db" do
      assert File.exists?(@db_path)
    end
    
    should_have_no_errors
    
    # this block is for testing individual helpers, such as createTable/dropTable etc
    context "prepare for migration helpers" do
      setup do
        @migration = FmdbMigration.alloc.initWithDatabase(@db) # dummy migration obj
      end
      
      should "have migration" do
        assert_not_nil(@migration)
        assert_instance_of(OSX::FmdbMigration, @migration)
      end

      context "then create table with no explicit columns" do
        setup do
          @m1 = @migration.createTable("people")
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
            @migration.dropTable "people"
            @results = find_all "people"
          end

          should "have destroyed table" do
            assert(@db.hadError?, "Should be an error for query on non-existent table")
          end
        end
        
      end
      
      # context "then create table with columns and default values" do
      #   setup do
      #     # [mm createTable:@"students" withColumns:[NSArray arrayWithObjects:
      #     #  [FmdbMigrationColumn columnWithColumnName:@"first_name" columnType:@"string"],
      #     #  [FmdbMigrationColumn columnWithColumnName:@"age" columnType:@"integer" defaultValue:21],
      #     #  nil];
      #     @m1 = @migration.createTable_withColumns("students", [
      #       FmdbMigrationColumn.columnWithColumnName_columnType("first_name", "string"),
      #       FmdbMigrationColumn.columnWithColumnName_columnType_defaultValue("age", "string", 21)
      #     ])
      #     @results = find_all "students"
      #   end
      #   
      #   teardown { @results.close if @results }
      #   
      #   should_have_no_errors
      # 
      #   should "have table 'students'" do
      #     assert_not_nil(@results)
      #     assert_instance_of(OSX::FMResultSet, @results)
      #     assert(!@results.next?, "Should be no results")
      #   end
      #   
      #   should "have default column 'id'" do
      #     assert_equal(0, @results.columnIndexForName("id"))
      #   end
      # 
      #   should "have default column 'first_name'" do
      #     assert_equal(1, @results.columnIndexForName("first_name"))
      #   end
      # 
      #   should "have default column 'age'" do
      #     assert_equal(2, @results.columnIndexForName("age"))
      #   end
      # end

    end

    # this block is for testing up/down method activation
    context "and construct migration with up/down" do
      setup do
        @migration = CreateAccounts.migration
      end

      context "perform -up method" do
        setup do
          @results.close if @results
          @migration.upWithDatabase(@db) 
          @results = find_all "accounts"
        end
        
        teardown { @results.close if @results }
        
        should_have_no_errors

        should "have table 'accounts'" do
          assert_not_nil(@results)
          assert(!@results.next?, "Should be no results")
        end
        
        context "then perform -down method" do
          setup do
            @results.close if @results
            @migration.downWithDatabase(@db) 
            @results = find_all "accounts"
          end

          should "have errors as no 'accounts' table for select cmd" do
            assert(@db.hadError?)
          end

          should "not have table 'accounts'" do
            assert_nil(@results)
          end
        end
        
      end
    end
    
    
  end
  
end