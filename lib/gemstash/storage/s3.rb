require "aws-sdk-resources"
require "aws-sdk-core"
require "gemstash"

module Gemstash
  class Storage
    # Re-open Storage class and redefined #store to upload_to_s3.
    def store(filename)
      FileUtils.mkpath(@folder) unless Dir.exist?(@folder)
      save_file(filename) { content }
      upload_to_s3(filename)
    end

    def delete(key)
      return self unless exist?(key)

      begin
        File.delete(content_filename(key))
        delete_from_s3(content_filename(key))
      rescue => e
        log_error "Failed to delete stored content at #{content_filename(key)}", e, level: :warn
      end

      begin
        File.delete(properties_filename) unless content?
        delete_from_s3(properties_filename) unless content?
      rescue => e
        log_error "Failed to delete stored properties at #{properties_filename}", e, level: :warn
      end

      return self
    ensure
      reset
    end

    module S3
      %w(AWS_S3_ACCOUNT_ID AWS_S3_SECRET_ACCESS_KEY AWS_S3_REGION AWS_S3_BUCKET).each do |env_var|
        raise("#{env_var} environment variable not set.") if ENV[env_var].nil?
      end

      @s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV['AWS_S3_ACCOUNT_ID'], ENV['AWS_S3_SECRET_ACCESS_KEY']),
        region: ENV['AWS_S3_REGION']
      )

      def upload_to_s3(filename)
        obj = @s3.bucket(ENV['AWS_S3_BUCKET']).object(filename)
        obj.upload_file(filename) unless obj.exists?
      end

      def delete_from_s3(resource)
        obj = @s3.bucket(ENV['AWS_S3_BUCKET']).object(resource)
        obj.delete
      end

      def exists_in_s3?(resource)
        obj = @s3.bucket(ENV['AWS_S3_BUCKET']).object(resource)
        obj.exists?
      end

      # @param properties_file [String] Path to the gem's properties.yaml file.
      def fetch_properties_from_s3(properties_file)
        # Check to make sure we get the file path with the Gemstash::Storage#properties object.
        File.write(properties_file), @s3.get_object(bucket: ENV[AWS_S3_BUCKET], key: properties_file))
      end

      # @param gem_contents [String]
      def fetch_gem_from_s3(gem_contents)
        File.open(local_copy_of_gem, 'wb') do |file|
          s3_copy = @s3.get_object({ bucket: ENV[AWS_S3_BUCKET], key: gem_contents }, target: file)
        end
      end
    end

    module GemSource
      class PrivateSource
        include Gemstash::Storage::S3

        def fetch_gem(gem_full_name)
          gem = storage.resource(gem_full_name)
          relative_path_to_gem = gem.pathfh
          relative_path_to_properties = gem.pathfh

          if exists_in_s3?(relative_path_to_gem)
            fetch_properties_from_s3(relative_path_to_properties)
            fetch_gem_from_s3(relative_path_to_gem)
            gem
          else
            halt 404
          end
          halt 403, "That gem has been yanked" unless gem.properties[:indexed]
        end
      end
    end

    helper Gemstash::Storage::S3
  end
end
