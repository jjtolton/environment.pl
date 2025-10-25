# Quick Start Guide

## Using the Environment Library

### Installation

#### Using Bakage

Add to your `scryer-manifest.pl`:

```prolog
dependencies([
    dependency("environment.pl", git("https://github.com/YOUR_USERNAME/environment.pl.git"))
]).
```

Then run:
```bash
./bakage.pl install
```

#### Manual Installation

Copy the `environment.pl` file into your project or add it to your Scryer Prolog library path.

### Basic Usage

```prolog
:- use_module(library(environment)).

% Set global values
?- env_set_global(username, 'Alice').
true.

% Retrieve values
?- env_key_val(username, User).
User = 'Alice'.

% Check flags with reified predicates
?- env_check_flag_t(debug, T).
T = false.

% Once-only initialization
?- env_set_global_once(config/loaded, true).
true.
```

## Quick Examples

See the `examples/` directory for complete working examples:

- `00_quickstart.pl` - Quick introduction (run this first!)
- `01_basic_usage.pl` - Fundamental operations
- `02_configuration_management.pl` - Config pattern
- `03_feature_flags.pl` - Feature flags system
- `04_counters_and_state.pl` - Counters & stacks
- `05_managed_predicates_pattern.pl` - Predicate registry

### Run an Example

```bash
scryer-prolog examples/00_quickstart.pl
```

## Testing

Run the test suite:

```bash
cd tests
scryer-prolog test_basic_operations.pl
scryer-prolog test_backtracking.pl
scryer-prolog test_edge_cases.pl
```

All 22 tests should pass!

## Next Steps

1. **Read the API** - See `README.md` for complete API reference
2. **Try examples** - Run examples to see patterns
3. **Write code** - Start using in your project!

## Common Use Cases

### Configuration Management

```prolog
init_config :-
    env_set_global_once(db/host, 'localhost'),
    env_set_global_once(db/port, 5432),
    env_set_global_flag_once(config/loaded).

get_db_host(Host) :-
    env_key_val(db/host, Host).
```

### Feature Flags

```prolog
enable_debug :-
    env_set_global_flag(debug).

maybe_log(Message) :-
    env_check_flag_t(debug, T),
    if_(T=true,
        (write('LOG: '), write(Message), nl),
        true
       ).
```

### Counters

```prolog
increment_requests :-
    env_key_val_notfound(requests, Current, 0),
    Next is Current + 1,
    env_set_global(requests, Next).
```

## Need Help?

- **API Reference**: See `README.md`
- **Examples**: Check `examples/` directory
- **Tests**: Look at `tests/` for usage patterns
- **Issues**: Open an issue on GitHub
