module RailsUUID  
  class Railtie < Rails::Railtie

  # the adapter is not loaded until a connection is actually established, so we 
  # can't mangle NATIVE_DATABASE_TYPES until the end of initialization
  # The values from it should be read DURING the migarion process, so it should
  # still work.
    initializer 'activerecord.uuid.pk.support' do |app|          
      ActiveRecord::Base.send :include, RailsUUID::ActiveRecordUUID
      ActiveRecord::Base.connection.class.send :include, RailsUUID::AdapterUUID
    end
  end
end