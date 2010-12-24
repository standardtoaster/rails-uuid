This plugin changes the default handling of primary keys in rails. It currently supports sqlite, sqlite3 and postgre sql. 

By default, new migrations will use a UUID as the primary key. Should you already have tables, they will still use autoincrementing IDs. 

You can disable the use of UUIDs for a specific table by calling create_table_without_uuid instead of create_table in your migration. 

This is a fairly new library and has not been tested heavily. 