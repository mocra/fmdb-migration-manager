require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  def test_fmdb_migration_manager_class_exists
    OSX::FmdbMigrationManager
  end
end