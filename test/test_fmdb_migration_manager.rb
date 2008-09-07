require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  include OSX
  
  context "with clean sqlite db" do
    setup_db
    teardown_db
    should_have_no_errors
    should "create sqlite db" do assert File.exists?(@db_path) end
    
    context "run zero migrations" do
      setup do
        @migration_manager = FmdbMigrationManager.executeForDatabase(@db)
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
        FmdbMigrationManager.executeForDatabase(@db)
        assert_equal(0, @migration_manager.currentVersion)
      end
    end
    
  end
  
end