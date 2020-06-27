def application_name
  Rails.application.class.module_parent.name
end

def rails_environment
  Rails.env
end

def log_path
  Rails.root.join('log', '.irb_history.log')
end

# Checking if we are in rails console
if defined?(Rails)
  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join

  prompt = "#{application_name}[#{rails_environment}]"

  # defining custom prompt
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => " => %s\n"
  }

  # Setting our custom prompt as prompt mode
  IRB.conf[:PROMPT_MODE] = :RAILS
end
