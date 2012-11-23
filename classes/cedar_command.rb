require "classes/base_command.rb"

SIM_PATH = "/usr/local/bin/ios-sim"

class CedarCommand < BaseCommand

  # overrides from base class
  def initialize(params)
    super(params)
    @log_file_default = "/tmp/cedar-#{app_name}-#{Time.now.to_i}.log"
  end

  def main_command
    "#{test_command} > #{self.log_file} 2>&1"
  end

  def grep_command
    "grep -q \"0 failures\" #{self.log_file}"
  end

  # private methods
  private

  def test_command 
    command = "#{SIM_PATH} launch #{app_path} --setenv CEDAR_HEADLESS_SPECS=1\
 --setenv CEDAR_REPORTER_CLASS=CDRColorizedReporter,CDRJUnitXMLReporter\
 --setenv CEDAR_JUNIT_XML_FILE=#{@params.source_root}/test-reports/cedar.xml"
    command += " --family #{@params.family} " unless @params.family.nil?
    command += " --sdk #{@params.sdk} " unless @params.sdk.nil?
    command
  end

end