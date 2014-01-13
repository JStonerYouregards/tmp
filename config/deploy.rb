set :stage, ENV["stage"] || "bb_dev"
load "#{File.dirname(__FILE__)}/#{stage}.rb"
load "#{File.dirname(__FILE__)}/deploy-common"

# sets a variable recipes can use without hardcoding the stage
@hostname = eval "@#{stage}" + "_host"
