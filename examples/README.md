# Environment Library Examples

This directory contains practical examples demonstrating the `environment` library.

## Running Examples

Each example can be run directly with Scryer Prolog:

```bash
scryer-prolog examples/01_basic_usage.pl
scryer-prolog examples/02_configuration_management.pl
scryer-prolog examples/03_feature_flags.pl
scryer-prolog examples/04_counters_and_state.pl
scryer-prolog examples/05_managed_predicates_pattern.pl
```

## Example Overview

### 01_basic_usage.pl
Demonstrates fundamental operations:
- Setting and getting global values
- Flag operations
- Reified predicates
- Default values
- Key-value checking
- Removing keys

### 02_configuration_management.pl
Shows how to use environment for application configuration:
- Once-only initialization with `env_set_global_once/2`
- Namespaced configuration keys
- Configuration validation
- Building derived values from config

### 03_feature_flags.pl
Feature flag pattern for conditional functionality:
- Enabling/disabling features at runtime
- Conditional execution with reified predicates
- Integration with `if_/3` for pure logic

### 04_counters_and_state.pl
Managing counters and stateful data:
- Simple increment counters
- Event tracking
- Stack-based undo functionality
- Statistics aggregation

### 05_managed_predicates_pattern.pl
Advanced pattern inspired by your `managed_predicates.pl`:
- Compile-time predicate registration
- Runtime metadata management
- Predicate registry queries
- Using `term_expansion/2` with environment
