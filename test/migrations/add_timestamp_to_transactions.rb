class AddTimestampToTransactions < OSX::FmdbMigration
  def up
    addColumn_forTableName(OSX::FmdbMigrationColumn.columnWithColumnName_columnType("timestamp", "real"), "transactions")
  end
  
  def down
  end
end