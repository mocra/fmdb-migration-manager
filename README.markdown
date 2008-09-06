# SQLite Migration Manager with FMDB for iPhone and Cocoa

The only DB for the iPhone is SQLite, and a nice adapter for SQLite is [FMDB](http://gusmueller.com/blog/archives/2008/06/new_home_for_fmdb.html). 
Unfortunately it does not have an API for managing versioned migrations to the schema, 
as you'd need when you release new versions of an application.

This project provides some drop-in files to provide versioned schema migrations for
your Objective-C (iPhone/Cocoa) applications.

## Status

Pre-alpha - I've just started. The critical aspect of this project is that it has a Ruby-based test suite.

For tests, see `test/test_*.rb` files.

To build and run tests, run `rake`. If you have autotest installed, run `autotest` to build and run tests automatically with file changes.

## Usage

The follow is not the target API, just a sample of what currently works. There is no versioning or anything useful
yet.

    FMDatabase* db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    [db open];
  
    FmdbMigrationManager* migrationManager = [[FmdbMigrationManager alloc] initWithDatabase:db];
  
    [migrationManager createTable:@"people"];

## Running tests

This project has a suite of tests written in Ruby, although the library is in Objective-C.

### Install dependencies

    sudo gem install Shoulda

## Author

Dr Nic Williams, [drnicwilliams@gmail.com](mailto:&#x64;&#x72;&#x6E;&#x69;&#x63;&#x77;&#x69;&#x6C;&#x6C;&#x69;&#x61;&#x6D;&#x73;&#x40;&#x67;&#x6D;&#x61;&#x69;&#x6C;&#x2E;&#x63;&#x6F;&#x6D;), [http://drnicwilliams.com](http://drnicwilliams.com)

CEO, [Mocra](http://www.mocra.com/) - the premier iPhone/Rails consultancy
