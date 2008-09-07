class CreateTransactions < OSX::FmdbMigration
  def up
    createTable_withColumns "transactions", [
      OSX::FmdbMigrationColumn.columnWithColumnName_columnType("amount", "real")
      ]
  end
  
  def down
    dropTable "transactions"
  end
end