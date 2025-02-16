require 'yaml'
require 'json'
require 'fileutils'

module Configurator
  class Generator
    DATA_TYPE_MAPPING = {
      'int' => 'integer',
      'string' => 'string',
      'date' => 'date',
      'datetime' => 'datetime',
      'float' => 'float',
      'enum' => 'enum'
    }

    def initialize(file, output_dir)
      @file = file
      @config = load_config(file)
      @migrations_dir = output_dir
      validate_config!
    end

    def generate_migrations
      FileUtils.mkdir_p(@migrations_dir)

      @config.each do |model, details|
        table_name = details["table_name"]
        attributes = details["attributes"]

        unless attributes
          puts "Warning: No attributes found for model '#{model}'. Skipping."
          next
        end

        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        migration_file = "#{@migrations_dir}/#{timestamp}_create_#{table_name}_table.php"

        File.open(migration_file, 'w') do |file|
          file.write <<~PHP
            <?php

            use Illuminate\\Database\\Migrations\\Migration;
            use Illuminate\\Database\\Schema\\Blueprint;
            use Illuminate\\Support\\Facades\\Schema;

            class Create#{model.capitalize}Table extends Migration
            {
                public function up()
                {
                    Schema::create('#{table_name}', function (Blueprint $table) {
                        $table->id();
            #{generate_columns(attributes).map { |col| "\t\t\t#{col};" }.join("\n")}
                        $table->timestamps();
                    });
                }

                public function down()
                {
                    Schema::dropIfExists('#{table_name}');
                }
            }
          PHP
        end

        puts "Generated migration: #{migration_file}"
      end

      puts "All migrations generated in '#{@migrations_dir}' directory."
    end

    private

    def load_config(file)
      case File.extname(file)
      when '.yaml', '.yml'
        YAML.load_file(file)
      when '.json'
        JSON.parse(File.read(file), symbolize_names: true)
      else
        raise "Unsupported file format: #{File.extname(file)}"
      end
    end

    def validate_config!
      unless @config.is_a?(Hash)
        raise "Invalid configuration: Expected a hash, got #{@config.class}"
      end

      @config.each do |model, details|
        unless details.is_a?(Hash)
          raise "Invalid configuration for model '#{model}': Expected a hash, got #{details.class}"
        end

        unless details["table_name"]
          raise "Missing 'table_name' for model '#{model}'"
        end

        unless details["attributes"]
          puts "Warning: No 'attributes' found for model '#{model}'"
        end
      end
    end

    def generate_columns(attributes)
      columns = []
      attributes.each do |attr, config|
        type = DATA_TYPE_MAPPING[config["type"]] || 'string'
        if type == 'enum'
          columns << "\$table->#{type}('#{attr}', [#{config["enum"].map { |v| "'#{v}'" }.join(', ')}])"
        elsif config["foreign_key"]
            columns << "\$table->foreignId('#{attr}')"
        else
          column_def = "\$table->#{type}('#{attr}')"
          column_def += '->unique()' if config["unique"]
          column_def += '->nullable()' unless config["primary_key"]
          columns << column_def
        end
      end
      columns
    end
  end
end