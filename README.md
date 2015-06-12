# Sitemappex
[![Build Status](https://secure.travis-ci.org/doomspork/sitemappex.png?branch=master)](http://travis-ci.org/doomspork/sitemappex) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

A site mapper built in Elixir.

## Installation

_Coming soon..._

## Usage

To use `Sitemappex`, there is the `map_links/2` function. It takes two arguments, a starting URL and an optional list of whitelisted domains.  The result of it is a list of tuples: `[{url, occurrences}]`

See it in action:

##### example.com

```html
<html>
  <body>
    <a href="http://www.example.com/blog">Blog</a>
    <a href="http://www.othersite.com">Blog</a>
  </body>
</html>
```
_Assumption: Neither "example.com/blog" or "othersite.com" have additional links._

```elixir
iex> Sitemappex.map_links("http://example.com")
[{"http://www.example.com/blog", 1}, {"http://www.othersite.com", 1}]

iex> Sitemappex.map_links("http://example.com", ["example.com"])
[{"http://www.example.com/blog", 1}]
```

## Contributing

Feedback, feature requests, and fixes are welcomed and encouraged.  Please make appropriate use of [Issues](https://github.com/doomspork/sitemappex/issues) and [Pull Requests](https://github.com/doomspork/sitemappex/pulls).  All code should have accompanying tests.

## License

Please see [LICENSE](LICENSE) for licensing details.
