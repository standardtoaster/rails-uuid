This plugin changes the default handling of primary keys in rails. It currently supports sqlite, sqlite3 and postgre sql. 

By default, new migrations will use a UUID as the primary key. Should you already have tables, they will still use auto incrementing IDs. 

You can disable the use of UUIDs for a specific table by calling create_table_without_uuid instead of create_table in your migration. 

In your migrations, calls to t.references and t.belongs_to should automatically figure out if the destination model is setup for UUIDs. If the model does not already exist (and have a valid table in the DB) it will default to an auto incrementing integer. You can force a traditional relationship by calling t.references_without_uuid. The ability to force a UUID in the references call is coming soon. 

This is a fairly new library and has not been tested heavily, but seems to work with rails 3.0.3.

There are no working tests - I've still got to write some. testing framework has been largely stolen from ActiveRecord. 

The gems in the repo are currently out of date. 

Original gem template taken from https://github.com/wycats/newgem-template