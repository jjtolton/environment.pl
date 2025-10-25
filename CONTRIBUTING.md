# Contributing to Environment

Thank you for your interest in contributing to the `environment` library!

## Development Setup

1. Clone or download the repository
2. Ensure you have Scryer Prolog installed
3. Run the tests to verify your setup:

```bash
cd tests
scryer-prolog test_basic_operations.pl
scryer-prolog test_backtracking.pl
scryer-prolog test_edge_cases.pl
```

## Making Changes

### Code Style

- Use descriptive predicate names
- Include PLDoc-style documentation for all exported predicates
- Follow the existing code formatting conventions
- Use `%` for line comments, `%%` for predicate documentation blocks

### Documentation

When adding new predicates:

1. Add PLDoc comments with:
   - Brief description
   - Mode indicators (e.g., `+Key`, `?Value`, `-Result`)
   - `@arg` tags for each argument
   - `@throws` tags for exceptions
   - Determinism indicator (e.g., `is det`, `is semidet`)

Example:

```prolog
%% env_new_predicate(+Key, ?Value) is det.
%
%  Brief description of what the predicate does.
%
%  @arg Key Description of the key parameter
%  @arg Value Description of the value parameter
%  @throws error(type, context) Description of when this is thrown
env_new_predicate(K, V) :-
    % implementation
```

### Testing

1. Add tests for any new functionality
2. Ensure all existing tests still pass
3. Test edge cases
4. Test backtracking behavior if applicable

Add tests to the appropriate file in `tests/`:
- `test_basic_operations.pl` - core functionality
- `test_backtracking.pl` - backtracking semantics
- `test_edge_cases.pl` - edge cases and error handling

### Examples

If adding significant new features, add an example to `examples/`:

```prolog
:- use_module(library(environment)).

example_feature :-
    write('=== Feature Name Example ==='), nl,
    % demonstrate the feature
    write('Example complete!'), nl.

:- initialization(example_feature).
```

## Submitting Changes

1. Test your changes thoroughly
2. Update documentation
3. Add examples if appropriate
4. Ensure all tests pass
5. Submit a pull request with:
   - Clear description of changes
   - Rationale for the changes
   - Test results

## Questions?

Open an issue to discuss:
- Proposed features
- Bugs or unexpected behavior
- Documentation improvements
- Design decisions

## Code of Conduct

- Be respectful and constructive
- Focus on the technical merits
- Help maintain a welcoming environment
