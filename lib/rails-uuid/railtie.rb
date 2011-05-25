module RailsUUID
  class Railtie < Rails::Railtie
  # the adapter is not loaded until a connection is actually established, so
  # we can't mangle NATIVE_DATABASE_TYPES until the end of initialization The
  # values from it should be read DURING the migarion process, so it should
  # still work.
  #

  config.after_initialize do
  ## grab the spec
  #
    spec = Rails.configuration.database_configuration[Rails.env].to_options!
    adapter = spec[:adapter]
    before = ActiveRecord::ConnectionAdapters::AbstractAdapter.subclasses

    raise("DB Adapter is not supported by rails-uuid gem") unless UUID_DB_PK_TYPE.has_key?(adapter)

  ## force the adapter to load, tracking loaded connection adapters
  #
    begin
      require "active_record/connection_adapters/#{ adapter }_adapter"
    rescue LoadError => e
      raise "Please install the #{ adapter } adapter: `gem install activerecord-#{ adapter }-adapter` (#{e})"
    end
    after = ActiveRecord::ConnectionAdapters::AbstractAdapter.subclasses

  ## now we know the connection class!
  #
    connection_class =
      (before - after).last ||
      ActiveRecord::ConnectionAdapters::AbstractAdapter.subclasses.last

  ## monkey patch the shit out of it... # TODO
  #
    ActiveRecord::Base.send(:include, RailsUUID::ActiveRecordUUID)
    ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, RailsUUID::TableDefinitionUUID)
    connection_class.send(:include, RailsUUID::AdapterUUID)
  end

  end
end
