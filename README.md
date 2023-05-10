# BundleFilter

A filter for bundle that removes useless info when run bundle

## Installation

You can install by command line using

    $ bundler plugin install bundle_filter

or add this line to your application's Gemfile:

```ruby
plugin 'bundle_filter'
```

## Usage

After install, every time you execute:

    $ bundle install

this plugin will remove useless info from bundle install like unchanged gems "Using gem x.y.z"

## Uninstall

For uninstall the plugin from your application, you must run code above even if you install from Gemfile (only available on Bundler >= 2.2.0)

    $ bundler plugin uninstall bundle_filter

If your Bundler < 2.2.0, you should instead go to root of your project and delete de `.bundle/plugin/` folder, will work as well.

## To-do

New features ideas that may be interesting to add if more users want too
- Set config file to give freedom to user select which show up
- Remove or simplify "Complete" final mensage
- Add a "pretty" bundle install?
- Add progress-bar to bundle install gem?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dfop02/bundle_filter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
