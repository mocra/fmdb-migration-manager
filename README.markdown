# SQLite Versioned Migrations for FMDB adapter for iPhone and Cocoa

The only DB for the iPhone is SQLite, and a nice adapter for SQLite is [FMDB](http://gusmueller.com/blog/archives/2008/06/new_home_for_fmdb.html). 
Unfortunately it does not have an API for managing versioned migrations to the schema, 
which you need when you release new versions of an application to end users.

Initially when a user runs their application (read: YOUR application, which includes *FMDB* and 
*FMDB Migration Manager*), all current migrations are executed. Thus the
database schema corresponds to the current version of the application.

If the user downloads a new version of your application, which includes one or more migrations,
those migrations will be automatically executed when they launch the application. Thus again,
their database schema corresponds with the current version of the application.

## Current status

This project was written on the weekend of Sept 6-7, 2008. In the coming days it will be integrated into an 
existing project to confirm that the code works and the API is nice.

Nonetheless, the tests do pass and I'd be interested in any feedback on the API, etc.

## Installation

This project provides some drop-in files to provide versioned schema migrations for
your Objective-C (iPhone/Cocoa) applications. Similarly, FMDB is distributed as a set of
Objective-C files to copy into your application.

Copy the files in `Classes/` into your Xcode project. You will also need the FMDB source files. There is copy of them in the `fmdb/` folder, though it is recommended to download the [latest version directly](http://gusmueller.com/blog/archives/2008/06/new_home_for_fmdb.html).

## Usage

When a user starts your application, the following code should be executed one time, 
before any database activities are performed. This will ensure that any new migrations are
executed before any database queries/statements can be accidently executed on a stale schema.

Setup your list of migration subclasses and send them to the manager, which will determine which need to be executed:

    NSArray *migrations = [NSArray arrayWithObjects:
        [CreateStudents migration], // 1
        [CreateStaffMembers migration], // 2
        [AddStudentNumberToStudents migration], // 3
        nil
      ];
    [FmdbMigrationManager executeForDatabasePath:@"/tmp/tmp.db" withMigrations:migrations];

Note, the `+migration` method is equivalent to `[[[CreateStudents alloc] init] autorelease]` just much shorter. 

Each migration header and class looks something like:

    @interface CreateStudents : FmdbMigration
    {
    }
    @end

    @implementation CreateStudents
    - (void)up {
      [self createTable:@"students" withColumns:[NSArray arrayWithObjects:
          [FmdbMigrationColumn columnWithColumnName:@"first_name" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"age" columnType:@"integer" defaultValue:21],
          nil];
    }
    - (void)down {
      [self dropTable:@"students"];
    }
    @end

The header and migration class files can be stored anywhere in your application, as long as they are
linked in (performed automatically by Xcode). They are referenced, in their appropriate order of execution,
by the `[FmdbMigrationManager executeWithDatabase:db withMigrations:migrations]` statement
mentioned earlier. The `migrations` is an `NSArray` of instances of these migration classes. Again, read above
for an example of preparing this array and calling the `+executeWithDatabase:withMigrations:` method.

Internally, if a migration object needs to have its `-up` method invoked, the automated manager
will actually call `-upWithDatabase:(FMDatabase *)db`, which in turn calls `-up`. 

NOTE: currently the `-down` method is optional as the current alpha version of this project doesn't support reversing 
the migrations. It may be supported in future if there is a use case.

### FmdbMigrationManager

This class has a list of individual micro-changes to the database schema called *migrations*, represented
as instances of `FmdbMigration` subclasses. 

Each `FmdbMigration` instance can create or drop whole tables, add/remove individual columns, or change columns. 

Which migrations are executed depends upon the current
migration status of the target environment. This information is stored in a special table `schema_info`
which is created and managed by `FmdbMigrationManager`. The user/developer does not need to worry about
this table.

### Migration helpers

Inside the `-up` (and future purpose `-down`) method, you can execute any Objective-C code: NSLog calss, store values into 
objects, etc. Mostly, you will execute `CREATE TABLE`, `ALTER TABLE` and `DROP TABLE` SQL requests upon your database.

You can call any `FMDatabase` queries within the `-up` method.

This project `FMDB Migration Manager` includes some helpers to make schema creation and modification. Here are some 
self-explanatory examples:

    - (void)up {
      [self createTable:@"countries"];
      [self addColumn:[FmdbMigrationColumn columnWithColumnName:@"name" columnType:@"string"] forTableName:@"countries"];
    }
    
Or create the table and its columns in one method call:

    - (void)up {
      [self createTable:@"students" withColumns:[NSArray arrayWithObjects:
        [FmdbMigrationColumn columnWithColumnName:@"name"        columnType:@"string"],
        [FmdbMigrationColumn columnWithColumnName:@"age"         columnType:@"real"],
        [FmdbMigrationColumn columnWithColumnName:@"description" columnType:@"text"],
        nil
      ]];
    }

Or drop an existing table, all its columns and data:

    [self dropTableName:@"countries"];
    
See `FmdbMigration.h` for definition of these methods.

## Running project tests

This project has a suite of tests written in Ruby, even though the library is in Objective-C. It uses the RubyCocoa project
to bridge between Ruby (for the tests) and Objective-C (for the library). Ruby was used for testing due to its concise
syntax of the test/unit and Shoulda test suite libraries. You can easily read the test suites to see what behaviour
is being tested and the expected outcomes.

Install the dependencies (assuming you have Ruby and RubyGems installed, as is true for OS X 10.5 Leopard):

    sudo gem install Shoulda

Run the tests:

    rake

If you want to continuously run the tests whilst writing code + tests, use the `autotest` tool:

    sudo gem install ZenTest
    autotest

## Author

Dr Nic Williams 

* [drnicwilliams@gmail.com](mailto:&#x64;&#x72;&#x6E;&#x69;&#x63;&#x77;&#x69;&#x6C;&#x6C;&#x69;&#x61;&#x6D;&#x73;&#x40;&#x67;&#x6D;&#x61;&#x69;&#x6C;&#x2E;&#x63;&#x6F;&#x6D;)
* [http://drnicwilliams.com](http://drnicwilliams.com)
* CEO, [Mocra](http://www.mocra.com/) - the premier iPhone/Rails consultancy

## Thanks

Thanks to [Gus Mueller](http://gusmueller.com/) for writing [FMDB](http://gusmueller.com/blog/archives/2008/06/new_home_for_fmdb.html). A version of it is included in this project
to allow the tests to be executed, and it is a dependency of this project.

Thanks to the [Ruby on Rails](http://www.rubyonrails.org/) web framework which introduced the idea and syntax for database
schema migrations. The implementation of versioned migrations in this project lends heavily from as many syntactical ideas
as possible. The differences between the Ruby and Objective-C languages were the reason for any API distinctions.

## License

Copyright (c) 2008 Dr Nic Williams

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.