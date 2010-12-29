module RailsUUID  
  class Railtie < Rails::Railtie

  # the adapter is not loaded until a connection is actually established, so we 
  # can't mangle NATIVE_DATABASE_TYPES until the end of initialization
  # The values from it should be read DURING the migarion process, so it should
  # still work.
    initializer 'activerecord.uuid.pk.support' do |app|  
      
      #only make the changes if the DB type is supported, otherwise log an error. 
      if UUID_DB_PK_TYPE.contains_key? Rails.configuration.database_configuration[Rails.env]['adapter']
        ActiveRecord::Base.send :include, RailsUUID::ActiveRecordUUID
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, RailsUUID::TableDefinitionUUID
        ActiveRecord::Base.connection.class.send :include, RailsUUID::AdapterUUID
      else
        raise "DB Adapter is not supported by rails-uuid gem"
      end  
    end
  end
end