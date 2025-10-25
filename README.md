# environment

A global environment/context management system for Scryer Prolog providing key-value metadata storage one level of abstraction above the blackboard.

## Purpose

This library provides a clean interface for managing global state in Prolog programs using association trees (AVL trees) backed by the blackboard. It offers:

- **Global persistent storage** - Changes persist across backtracking
- **Backtrackable local storage** - Changes roll back on backtracking
- **Type-safe reified predicates** - Use `if_/3` for conditional logic without cuts
- **Once-only initialization** - Prevent accidental double initialization
- **Key existence checking** - Efficiently check for key presence

## Installation

### Using Bakage

```bash
bakage.pl install environment
```

### Manual Installation

Copy `environment.pl` to your project's library directory or ensure it's in your Scryer Prolog load path.

## Dependencies

- `library(reif)` - Reified predicates for conditional logic
- `library(assoc)` - Association trees (AVL trees)
- `library(iso_ext)` - ISO extensions including blackboard predicates

## Quick Start

```prolog
?- use_module(library(environment)).

% Set global values (persistent across backtracking)
?- env_set_global(username, 'Alice').
true.

?- env_set_global(counter, 42).
true.

% Retrieve values
?- env_key_val(username, User).
User = 'Alice'.

% Check if key exists (reified)
?- env_check_flag_t(username, T).
T = true.

% Set local value (backtrackable)
?- env_set_local(temp, 'temporary'), env_key_val(temp, V).
V = 'temporary'.

% Initialize once (prevents double initialization)
?- env_set_global_once(config_loaded, true).
true.

?- env_set_global_once(config_loaded, false).
ERROR: runtime_error(env_set_global_once)
```

## API Reference

### Core Operations

#### `environment(-Environment)`
Retrieve the current global environment as an association tree.

#### `env_put(+Env)`
Replace the entire global environment (persistent).

#### `env_b_put(+Env)`
Replace the entire global environment (backtrackable).

### Setting Values

#### `env_set_global(+Key, +Value)`
Set a key-value pair globally (persistent across backtracking).

#### `env_set_global_flag(+Key)`
Set a flag (key with value `true`) globally.

#### `env_set_global_once(+Key, +Value)`
Set a key-value pair only if it doesn't exist. If it exists with a different value, throws an error.

#### `env_set_global_flag_once(+Key)`
Set a flag only once. Throws error if already set with different value.

#### `env_set_local(+Key, +Value)`
Set a key-value pair locally (backtrackable).

#### `env_set_local_flag(+Key)`
Set a flag locally (backtrackable).

### Retrieving Values

#### `env_key_val(+Key, ?Value)`
Retrieve value for a key. Throws `key_error` if key doesn't exist.

```prolog
?- env_set_global(name, 'Bob'), env_key_val(name, N).
N = 'Bob'.
```

#### `env_key_val_notfound(+Key, ?Value, +NotFound)`
Retrieve value for a key, or unify with `NotFound` if key doesn't exist.

```prolog
?- env_key_val_notfound(missing_key, V, default).
V = default.
```

### Checking Keys

#### `env_check_flag(+Key)`
Check if a flag exists (deterministic success/failure).

#### `env_check_flag_t(+Key, ?Truth)`
Reified version: unifies `Truth` with `true` or `false`.

```prolog
?- env_set_global_flag(debug),
   env_check_flag_t(debug, T1),
   env_check_flag_t(missing, T2).
T1 = true,
T2 = false.
```

#### `env_check_key_val(+Key, +Value)`
Check if key exists with specific value (deterministic).

#### `env_check_key_val_t(+Key, +Value, ?Truth)`
Reified version of key-value check.

#### `env_check_key_value_t(+Key, +Value, ?Truth)`
Alias for `env_check_key_val_t/3`.

#### `env_assert_flag(+Key)`
Assert that a flag exists (throws error if missing).

### Removing Keys

#### `env_remove(+Key)`
Remove a key from the environment (persistent).

#### `env_b_remove(+Key)`
Remove a key from the environment (backtrackable).

## Usage Patterns

### Configuration Management

```prolog
% Initialize configuration once
init_config :-
    env_set_global_once(db_host, 'localhost'),
    env_set_global_once(db_port, 5432),
    env_set_global_flag_once(config_loaded).

% Access configuration
get_db_connection(Host, Port) :-
    env_key_val(db_host, Host),
    env_key_val(db_port, Port).
```

### Feature Flags

```prolog
% Enable/disable features
enable_feature(Feature) :-
    env_set_global_flag(Feature).

disable_feature(Feature) :-
    env_remove(Feature).

% Check if feature is enabled
feature_enabled(Feature) :-
    env_check_flag(Feature).

% Conditional execution
maybe_log(Message) :-
    env_check_flag_t(logging_enabled, T),
    if_(T=true,
        format('LOG: ~w~n', [Message]),
        true
       ).
```

### Temporary State

```prolog
% Use local state that backtracks
process_with_context(Data, Result) :-
    env_set_local(current_data, Data),
    process_step_1,
    process_step_2,
    env_key_val(result, Result).
```

### Counters and State

```prolog
% Increment counter
increment_counter(Name) :-
    env_key_val_notfound(Name, Current, 0),
    Next is Current + 1,
    env_set_global(Name, Next).

% Usage
?- increment_counter(requests), increment_counter(requests).
true.

?- env_key_val(requests, Count).
Count = 2.
```

## Implementation Details

### Initialization

The environment is initialized exactly once using `term_expansion/2`. The first time the module is loaded, it creates an empty association tree and stores it in the blackboard under `global_context`.

### Reified Predicates

This library extensively uses reified predicates from `library(reif)` for conditional logic without cuts. This enables pure, declarative programming with backtracking-friendly conditionals.

### Performance

- All operations are O(log n) due to the underlying AVL tree implementation
- Key lookups are efficient even with thousands of entries
- Reified key existence checking avoids expensive exception handling

## License

BSD-2-Clause (compatible with Scryer Prolog standard libraries)

## Author

Jay

## Version

0.1.0
