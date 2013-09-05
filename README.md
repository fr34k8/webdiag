# Webdiag

Webdiag: blockdiag web interface

## Installation

blockdiag instlled

[http://blockdiag.com/ja/blockdiag/introduction.html](http://blockdiag.com/ja/blockdiag/introduction.html)

webdiag clone

```sh
$ git clone https://github.com/naoto/webdiag.git
```

webdiag bundle

```sh
$ bundle install
```

webdiag runup

```sh
$ bundle exec ruby web.rb
```


## Usage

Options

 * `-p`, `--port` to listen tcp port 
 * `-b`, `--bind` to binding address

## Heroku Deployment

```sh
$ git clone https://github.com/naoto/webdiag.git
$ cd webdiag
$ heroku create webdiag --stack cedar --buildpack git://github.com/naoto/heroku-buildpack-rubypython.git
$ git push heroku master
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
