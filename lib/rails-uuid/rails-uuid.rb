module RailsUUID
  UUID_DB_PK = 
  {
    'sqlite3' => 'TEXT(36) PRIMARY KEY NOT NULL',
    'sqlite' => 'TEXT(36) PRIMARY KEY NOT NULL',
    'postgresql' => 'uuid primary key',
    'mysql' => 'CHAR(36) DEFAULT NULL PRIMARY KEY'
    
  }
  module TableDefinitionUUID
    def create_table_without_uuid(table_name, options = {})
      options[:id] = false
      create_table(table_name, options) do |table_def|
        t.column 'id', :primary_key_autoincrement
  			yield table_def if block_given?
      end
    end
  end
  
  module AdapterUUID
    def self.included(base)
      base.class_eval do
        alias_method_chain :native_database_types, :uuid
      end
    end
    def native_database_types_with_uuid
      #use native_database_types_without_uuid to get the list - some adapters use a constant, some don't.
      #dup() to unfreeze (postgresql freezes primary_key key in the hash)
      uuid_native_database_types = native_database_types_without_uuid.dup
      uuid_native_database_types[:primary_key_autoincrement] = uuid_native_database_types[:primary_key]
      uuid_native_database_types[:primary_key] = UUID_DB_PK[Rails.configuration.database_configuration[Rails.env]['adapter']]
      uuid_native_database_types
    end
    def create_table_without_uuid(table_name, options = {})
      options[:id] = false
      create_table(table_name, options) do |table_def|
        table_def.column 'id', :primary_key_autoincrement
  			yield table_def if block_given?
      end
    end
  end   
    
  module ActiveRecordUUID
    def self.included(base)
      base.class_eval do 
        before_create :set_id_as_new_uuid
      end
    end  
    def set_id_as_new_uuid
      if self.class.columns_hash[self.class.primary_key].type != :integer 
        self.id = UUIDTools::UUID.random_create.to_s
      end
    end
  end
  
end
