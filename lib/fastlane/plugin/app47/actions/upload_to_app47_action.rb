require 'fastlane/action'
require_relative '../helper/APP47_helper'

module Fastlane
  module Actions
    module SharedValues
    end

    class UploadToApp47Action < Action
      def self.run(params)
        build = {}

        build[:token] = (params[:account_token]).to_s
        build[:app_id] = (params[:app_id]).to_s
        build[:path] = (params[:ipa_path]).to_s
        build[:environment] = params[:environment]
        build[:release_notes] = params[:release_notes]
        build[:notify_users_on_activation] = params[:notify_users_on_activation]
        build[:make_active] = params[:make_active]
        build[:reset_bundle_identifier] = params[:reset_bundle_identifier]
        build[:reuse_version] = params[:reuse_version]
        build[:update_app_icon] = params[:update_app_icon]
        build[:update_app_name] = params[:update_app_name]

        UI.message("Uploading `#{params[:ipa_path]}` to App47 for app ID #{params[:app_id]} for #{params[:environment]} environment")

        response = Helper::App47Helper.upload(build)

        # if distributed_release
        #   UI.success("Release '#{release_id}' (#{distributed_release['short_version']}) was successfully distributed to #{destination_type} \"#{destination_name}\"")
        # else
        #   UI.error("App47 Upload #{response}")
        # end
      end

      def self.description
        "Upload IPA to Simple MDM"
      end

      def self.authors
        ["iotashan"]
      end

      def self.details
        # Optional:
        "When using App47 for iOS app distribution, this provides an automate way to send updates directly to App47"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :account_token,
                                       type: String,
                                       env_name: "APP47_ACCOUNT_TOKEN",
                                       description: "API Token for App47"),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       type: String,
                                       env_name: "APP47_APP_ID",
                                       description: "The App47 App ID that will be uploaded"),
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                       type: String,
                                       env_name: "APP47_IPA_PATH",
                                       description: "The the path to the IPA",
                                       default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH],
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find ipa file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :environment,
                                       type: String,
                                       env_name: "APP47_ENVIRONMENT",
                                       description: "Environment for the build",
                                       verify_block: proc do |value|
                                        accepted_formats = ["Production", "Test"]
                                        UI.user_error!("Only \"Production\" or \"Test\" values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :release_notes,
                                       type: String,
                                       env_name: "APP47_RELEASE_NOTES",
                                       optional: true,
                                       description: "Release notes for build"),
          FastlaneCore::ConfigItem.new(key: :notify_users_on_activation,
                                       env_name: "APP47_NOTIFY_USERS_ON_ACTIVATION",
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Notify users when the build is made active",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :make_active,
                                       env_name: "APP47_MAKE_ACTIVE", # The name of the environment variable
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Notify users when the build is made active",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :reset_bundle_identifier,
                                       env_name: "APP47_RESET_BUNDLE_IDENTIFIER", # The name of the environment variable
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Reset the build identifier if it has changed",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :reuse_version,
                                       env_name: "APP47_REUSE_VERSION",
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Reuse the version number if it is already present in the environment",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :update_app_icon,
                                       env_name: "APP47_UPDATE_APP_ICON",
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Reuse the version number if it is already present in the environment",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end),
          FastlaneCore::ConfigItem.new(key: :update_app_name,
                                       env_name: "APP47_UPDATE_APP_NAME",
                                       optional: true,
                                       default_value: false,
                                       is_string: false,
                                       description: "Reuse the version number if it is already present in the environment",
                                       verify_block: proc do |value|
                                        accepted_formats = [true, false]
                                        UI.user_error!("Only true or false values are allowed, you provided \"#{value}\"") unless accepted_formats.include? value
                                      end)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
