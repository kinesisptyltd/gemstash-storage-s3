Gemstash::Storage::S3
=====================
This is a [Gemstash][gemstash] plugin that allows you to store and retrieve private gems in
[Amazon's S3 cloud storage][s3].

[gemstash]: https://github.com/bundler/gemstash
[s3]: https://aws.amazon.com/s3/

## Installation
If you're deploying Gemstash with Bundler, add this line to your Gemfile:

```ruby
gem 'gemstash-storage-s3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemstash-storage-s3

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gemstash-storage-s3.
