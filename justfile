# Run the example tests
test:
    cd example && scryer-prolog -f run_tests.pl -g main

# Run tests on a specific file
test-file FILE:
    scryer-prolog -g "use_module(library(environment)), halt"

# Check the example
check-example:
    scryer-prolog -g "use_module(library(environment))"

# Start a REPL with package loaded
repl:
    scryer-prolog -g "use_module(library(environment))"

# Clean temporary files
clean:
    find . -name '.ediprolog-tmp' -delete
    find . -name '*.fasl' -delete

# Install dependencies (if any)
install:
    ./bakage.pl install
