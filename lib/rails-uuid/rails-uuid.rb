module RailsUUID
  
  UUID_DB_PK_TYPE =
  {
    'sqlite3' => 'TEXT(36)',
    'sqlite' => 'TEXT(36)',
    'postgresql' => 'uuid',
    'mysql' => 'CHAR(36)' 
  }
  
  UUID_DB_PK = 
  {
    'sqlite3' => 'PRIMARY KEY NOT NULL',
    'sqlite' => 'PRIMARY KEY NOT NULL',
    'postgresql' => 'primary key',
    'mysql' => 'DEFAULT NULL PRIMARY KEY'   
  }
  #TODO: Cache this
  def db_type
    Rails.configuration.database_configuration[Rails.env]['adapter']
  end
  
  #TODO: add t.uuid compatible method
  module TableDefinitionUUID
    def self.included(base)
      base.class_eval do
        alias_method_chain :references, :uuid
        alias :belongs_to :references_with_uuid
      end
    end
    #TODO: Add the ability to force UUID.
    def references_with_uuid(*args)
      options = args.extract_options!
      polymorphic = options.delete(:polymorphic)
      force_uuid = options.delete(:uuid)
      args.each do |col|
        pk_type = :uuid
        #copy from column implementation somehow  
        if !force_uuid && Object.const_defined?(col.to_s.camelize) && !col.to_s.camelize.constantize.pk_is_uuid?
            pk_type = :integer
        end
        column("#{col}_id", pk_type, options)
        column("#{col}_type", :string, polymorphic.is_a?(Hash) ? polymorphic : options) unless polymorphic.nil?
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
      uuid_native_database_types[:uuid] = UUID_DB_PK_TYPE[db_type]
      uuid_native_database_types[:primary_key_autoincrement] = uuid_native_database_types[:primary_key]
      uuid_native_database_types[:primary_key] = "#{UUID_DB_PK_TYPE[db_type]} #{UUID_DB_PK[db_type]}"
      uuid_native_database_types
    end
    def create_table_without_uuid(table_name, options = {})
      options[:id] = false
      create_table(table_name, options) do |table_def|
        table_def.column 'id', :primary_key_autoincrement
  			yield table_def if block_given?
      end
    end
    def db_type
      Rails.configuration.database_configuration[Rails.env]['adapter']
    end
  end   
    
  module ActiveRecordUUID
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do 
        before_create :set_id_as_new_uuid
      end
    end  
    module ClassMethods
      def pk_is_uuid?
        self.columns_hash[self.primary_key].type != :integer
      end
    end
    def set_id_as_new_uuid
      if self.class.pk_is_uuid?
        self.id = UUIDTools::UUID.random_create.to_s
      end 
    end
  end
  
end
