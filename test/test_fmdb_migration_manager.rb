require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  include OSX
  
  context "with clean sqlite db" do
    setup_db
    teardown_db

    should "create sqlite db" do
      assert File.exists?(@db_path)
    end
    
    should_have_no_errors
    
    context "prepare for migrations" do
      setup do
        @migration_manager = FmdbMigrationManager.alloc.initWithDatabase(@db)
      end
      
      should "have migration manager" do
        assert_not_nil(@migration_manager)
        assert_instance_of(OSX::FmdbMigrationManager, @migration_manager)
      end

    end
    
  end
  
end