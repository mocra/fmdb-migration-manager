require File.dirname(__FILE__) + '/test_helper'

class TestFmdbMigrationManager < Test::Unit::TestCase
  include OSX
  
  context "with clean sqlite db" do
    setup_db
    teardown_db
    should_have_no_errors
    should "create sqlite db" do assert File.exists?(@db_path) end
    
    context "run zero migrations" do
      setup do
        @migration_manager = FmdbMigrationManager.executeForDatabasePath_withMigrations(@db_path, [])
      end
      
      should "have migration manager" do
        assert_not_nil(@migration_manager)
        assert_instance_of(OSX::FmdbMigrationManager, @migration_manager)
      end

      should_have_table "schema_info" do
        should_have_column "version"
      end
      
      should "have current version 0" do
        assert_equal(0, @migration_manager.currentVersion)
      end
      
      should "still have version 0 if migrations run again" do
        FmdbMigrationManager.executeForDatabasePath_withMigrations(@db_path, [])
        assert_equal(0, @migration_manager.currentVersion)
      end
    end

    context "run some migrations" do
      setup do
        @migrations = [
            CreateAccounts.migration, 
            CreateTransactions.migration
        ]
        @migration_manager = FmdbMigrationManager.executeForDatabasePath_withMigrations(@db_path, @migrations)
      end
      
      teardown { @results.close if @results }

      should_have_table "schema_info"
      should_have_table "accounts"
      should_have_table "transactions" do
        should_have_column "amount"
        should_not_have_column "timestamp"
      end
      
      should "have version 2" do
        assert_equal(2, @migration_manager.currentVersion)
      end
      
      should "have version 2 in schema_info" do
        @results = @db.executeQuery("select version from schema_info order by version desc")
        flunk "no schema_info rows (error: #{@db.lastErrorMessage})" unless @results.next?
        assert_equal(2, @results.intForColumn("version"))
      end

      context "and rerun with another migration" do
        setup do
          @migrations << AddTimestampToTransactions.migration
          @migration_manager = FmdbMigrationManager.executeForDatabasePath_withMigrations(@db_path, @migrations)
        end

        should_have_table "schema_info"
        should_have_table "accounts"
        should_have_table "transactions" do
          should_have_column "amount"
          should_have_column "timestamp"
        end
        
        should "have version 3" do
          assert_equal(3, @migration_manager.currentVersion)
        end
        
        should "have version 3 in schema_info" do
          @results = @db.executeQuery("select version from schema_info order by version desc")
          flunk "no schema_info rows (error: #{@db.lastErrorMessage})" unless @results.next?
          assert_equal(3, @results.intForColumn("version"))
        end
        
        context "and go down to specific version 1" do
          setup do
            @migration_manager = FmdbMigrationManager.executeForDatabasePath_withMigrations_andMatchVersion(@db_path, @migrations, 1)
          end

          should_have_table "schema_info"
          should_have_table "accounts"
          should_not_have_table "transactions"

          should "have version 1" do
            assert_equal(1, @migration_manager.currentVersion)
          end

          should "have version 1 in schema_info" do
            @results = @db.executeQuery("select version from schema_info order by version desc")
            flunk "no schema_info rows (error: #{@db.lastErrorMessage})" unless @results.next?
            assert_equal(1, @results.intForColumn("version"))
          end
        end
        
      end
      
    end
  end


end