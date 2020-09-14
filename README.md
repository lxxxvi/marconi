![Continuous Integration](https://github.com/lxxxvi/marconi/workflows/Continuous%20Integration/badge.svg)

## Setup

`google_custom_search_api_key` is required for the Google Custom Search API.

Set encryption keys:

`./config/master.key` : secret
`./config/credentials/test.key` : `f2904ff27c5c71196618b6f6beaa9ca0`

## How to add a new fact calculator

1. Create calculator service class in `./app/services/facts/(artist|song|station)/[name]_calculator.rb`
2. Create test class in `./test/services/(artist|song|station)/[name]_calculator_test.rb`, test `#call!`
3. Add decoration rule in `FactDecorator::VALUE_DECORATOR_METHODS`
4. Add rake task in the corresponding namespace in `facts.rake`.
5. Include rake task in `facts:(artists|songs|stations):all` rake task
