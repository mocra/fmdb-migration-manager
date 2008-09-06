class CreateAccounts < OSX::FmdbMigration
  def up
    createTable "accounts"
  end
  
  def down
    dropTable "accounts"
  end
end