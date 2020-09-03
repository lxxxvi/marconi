## How to add a new fact calculator

1. Create calculator service class in `./app/services/facts/(artist|song|station)/[name]_calculator.rb`
2. Create test class in `./test/services/(artist|song|station)/[name]_calculator_test.rb`, test `#call!`
3. Add decoration rule in `FactDecorator::VALUE_DECORATOR_METHODS`
4. Add rake task in the corresponding namespace in `facts.rake`.
5. Include rake task in `facts:(artists|songs|stations):all` rake task
