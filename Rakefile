#!/usr/bin/env rake
require 'rake/testtask'
require "bundler"
Bundler.setup

gemspec = eval(File.read("rails-uuid.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rails-uuid.gemspec"] do
  system "gem build rails-uuid.gemspec"
  system "gem install rails-uuid-#{RailsUUID::VERSION}.gem"
end

#test stuff

require File.expand_path(File.dirname(__FILE__)) + "/test/config"

MYSQL_DB_USER = 'rails'

def run_without_aborting(*tasks)
  errors = []

  tasks.each do |task|
    begin
      Rake::Task[task].invoke
    rescue Exception
      errors << task
    end
  end

  abort "Errors running #{errors.join(', ')}" if errors.any?
end


desc 'Run mysql, mysql2, sqlite, and postgresql tests by default'
task :default => :test

desc 'Run mysql, mysql2, sqlite, and postgresql tests'
task :test do
  tasks = defined?(JRUBY_VERSION) ?
    %w(test_jdbcmysql test_jdbcsqlite3 test_jdbcpostgresql) :
    %w(test_mysql test_mysql2 test_sqlite3 test_postgresql)
  run_without_aborting(*tasks)
end

%w( mysql mysql2 postgresql sqlite3 firebird db2 oracle sybase openbase frontbase jdbcmysql jdbcpostgresql jdbcsqlite3 jdbcderby jdbch2 jdbchsqldb ).each do |adapter|
  Rake::TestTask.new("test_#{adapter}") { |t|
    connection_path = "test/connections/#{adapter =~ /jdbc/ ? 'jdbc' : 'native'}_#{adapter}"
    adapter_short = adapter == 'db2' ? adapter : adapter[/^[a-z0-9]+/]
    t.libs << "test" << connection_path
    t.test_files = (Dir.glob( "test/cases/**/*_test.rb" ).reject {
      |x| x =~ /\/adapters\//
    } + Dir.glob("test/cases/adapters/#{adapter_short}/**/*_test.rb")).sort

    t.verbose = true
    t.warning = true
  }
  
  namespace :mysql do
    desc 'Build the MySQL test databases'
    task :build_databases do
      %x( mysql --user=#{MYSQL_DB_USER} -e "create DATABASE activerecord_unittest DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci ")
      %x( mysql --user=#{MYSQL_DB_USER} -e "create DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci ")
    end

    desc 'Drop the MySQL test databases'
    task :drop_databases do
      %x( mysqladmin --user=#{MYSQL_DB_USER} -f drop activerecord_unittest )
      %x( mysqladmin --user=#{MYSQL_DB_USER} -f drop activerecord_unittest2 )
    end

    desc 'Rebuild the MySQL test databases'
    task :rebuild_databases => [:drop_databases, :build_databases]
  end

  task :build_mysql_databases => 'mysql:build_databases'
  task :drop_mysql_databases => 'mysql:drop_databases'
  task :rebuild_mysql_databases => 'mysql:rebuild_databases'


  namespace :postgresql do
    desc 'Build the PostgreSQL test databases'
    task :build_databases do
      %x( createdb -E UTF8 activerecord_unittest )
      %x( createdb -E UTF8 activerecord_unittest2 )
    end

    desc 'Drop the PostgreSQL test databases'
    task :drop_databases do
      %x( dropdb activerecord_unittest )
      %x( dropdb activerecord_unittest2 )
    end

    desc 'Rebuild the PostgreSQL test databases'
    task :rebuild_databases => [:drop_databases, :build_databases]
  end

  task :build_postgresql_databases => 'postgresql:build_databases'
  task :drop_postgresql_databases => 'postgresql:drop_databases'
  task :rebuild_postgresql_databases => 'postgresql:rebuild_databases'
  