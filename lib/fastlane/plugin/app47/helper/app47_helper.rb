require 'rest_client'
require 'json'
require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class App47Helper
      # class methods that you define here become available in your action
      # as `Helper::App47Helper.your_method`
      #

      #
      # Perform the upload to the server
      #
      def self.upload(build)
        app_id = build.delete(:app_id)
        token = build.delete(:token)
        load_file(build)
        binary = build.delete(:build_upload)

        UI.message("uploading file")
        response = RestClient::Request.execute(method: :post,
                                    url: "https://cirrus.app47.com/api/v2/upload_file",
                                    payload: {
                                      multipart: true,
                                      file: binary
                                    },
                                    headers: {
                                      'Access-Token': token
                                    },
                                    raw_response: true)

        UI.user_error!("Error response '#{response.code}'") unless response.code === 200
        hash = JSON.parse(response.to_s)
        build[:build_upload_file_id] = hash['results']['file_id']
        UI.message("uploaded fileID #{hash['results']['file_id']}")
        UI.message("adding build to #{app_id}")
        resp = RestClient.send( :post,
                                "https://cirrus.app47.com/api/v2/apps/#{app_id}/builds",
                                {
                                  build: build
                                },
                                {
                                  'Access-Token': token
                                })
        UI.user_error!("Error response '#{resp.code}'") unless resp.code === 200
        hash = JSON.parse(resp.to_s)
        puts hash.to_yaml
        
        return hash
      end

      #
      # Load file for processing, making sure it exists
      #
      def self.load_file(options)
        file_path = options.delete(:path)
        raise "File not found: #{file_path}" unless File.exist?(file_path)

        options[:build_upload] = File.new(file_path, 'rb')
        extension = file_path.split('.').last
        options[:platform] = case extension
                            when 'ipa'
                              'iOS'
                            when 'apk'
                              'Android'
                            else
                              'Windows'
                            end
        options
      end
    end
  end
end
