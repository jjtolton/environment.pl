# Environment Library Tests

Comprehensive test suite for the `environment` library.

## Running Tests

### Individual Test Suites

From the project root:

```bash
scryer-prolog tests/test_basic_operations.pl
scryer-prolog tests/test_backtracking.pl
scryer-prolog tests/test_edge_cases.pl
```

### All Tests

Run all test files sequentially:

```bash
cd tests
scryer-prolog test_basic_operations.pl
scryer-prolog test_backtracking.pl
scryer-prolog test_edge_cases.pl
```

## Test Suites

### test_basic_operations.pl

Tests fundamental operations:
- ✓ Basic get/set operations
- ✓ Flag operations
- ✓ Key removal
- ✓ Default values with `env_key_val_notfound/3`
- ✓ Reified flag checking
- ✓ Key-value checking
- ✓ Once-only initialization (same value)
- ✓ Once-only initialization (different value - error)

**8/8 tests passing**

### test_backtracking.pl

Tests backtracking behavior:
- ✓ Global changes persist across backtracking
- ✓ Local changes backtrack
- ✓ Local set inside choice points
- ✓ Backtrackable remove
- ✓ Mixed global and local changes

**5/5 tests passing**

### test_edge_cases.pl

Tests edge cases and special scenarios:
- ✓ Compound term keys (e.g., `app/config/db`)
- ✓ Atom keys
- ✓ Number keys
- ✓ Complex term values (nested lists, etc.)
- ✓ Overwriting values
- ✓ Empty list as value
- ✓ Checking non-existent keys
- ✓ Multiple flags
- ✓ Asserting missing flags (error handling)

**9/9 tests passing**

## Total Coverage

**22/22 tests passing (100%)**

## Test Categories

### Core Operations
- Setting and getting values
- Flag operations
- Key removal
- Default values

### Backtracking Semantics
- Global (persistent) vs local (backtrackable) changes
- Choice point behavior
- Mixed operations

### Edge Cases
- Various key types (atoms, numbers, compounds)
- Complex values (nested structures)
- Empty values
- Multiple operations
- Error handling

## Adding New Tests

Follow the pattern in existing test files:

```prolog
:- use_module('../environment.pl').
:- use_module(library(format)).

test_something :-
    write('Test: Description... '),
    % test code here
    (condition -> write('PASS') ; write('FAIL')), nl.

run_tests :-
    write('=== Test Suite Name ==='), nl, nl,
    test_something,
    nl, write('Tests complete!'), nl.

:- initialization(run_tests).
```

## Dependencies

Tests require:
- `library(format)` - for output formatting
- `library(lists)` - for list operations (backtracking tests)
- `library(reif)` - automatically loaded by environment module
- `library(assoc)` - automatically loaded by environment module
- `library(iso_ext)` - automatically loaded by environment module
