class Bundler::CLI
  def install
    SharedHelpers.major_deprecation(2, "The `--force` option has been renamed to `--redownload`") if ARGV.include?("--force")

    %w[clean deployment frozen no-cache no-prune path shebang system without with].each do |option|
      remembered_flag_deprecation(option)
    end

    # Try reload cli install to change the complete msg
    require_relative "install"
    Bundler.settings.temporary(no_install: false) do
      Install.new(options.dup).run
    end
  end
end
