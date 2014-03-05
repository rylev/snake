lib_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "snake"))
$LOAD_PATH.unshift lib_path

Dir.glob("#{lib_path}/*").each {|f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end