class Bundler::Source
  def print_using_message(message)
    if !message.include?("(was ") && Bundler.feature_flag.suppress_install_using_messages?
      Bundler.ui.debug message
    else
      Bundler.ui.info message
    end
  end
end
