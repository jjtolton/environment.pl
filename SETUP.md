# Setup Guide

## For Package Users

### Using Bakage

1. Add to your `scryer-manifest.pl`:
```prolog
dependencies([
    dependency("environment.pl", git("https://github.com/jjtolton/environment.pl.git"))
]).
```

2. Install:
```bash
./bakage.pl install
```

3. Use in your code:
```prolog
:- use_module(library(environment)).
```

### Manual Installation

Copy `environment.pl` to your project or Scryer library path.

## For Contributors/Developers

### 1. Clone Repository

```bash
git clone https://github.com/jjtolton/environment.pl.git
cd environment
```

### 2. Setup Environment (Optional but Recommended)

#### Using direnv

```bash
direnv allow
```

This sets `SCRYER_PATH` automatically when you enter the directory.

#### Manual Setup

```bash
export SCRYER_PATH=/path/to/environment
```

### 3. Run Tests

```bash
cd tests
scryer-prolog test_basic_operations.pl
scryer-prolog test_backtracking.pl
scryer-prolog test_edge_cases.pl
```

All 22/22 tests should pass.

### 4. Try Examples

```bash
scryer-prolog examples/00_quickstart.pl
scryer-prolog examples/01_basic_usage.pl
# ... etc
```

## Development Workflow

### Running Tests

From tests directory:
```bash
scryer-prolog test_basic_operations.pl
```

### Interactive Testing

```bash
scryer-prolog
?- use_module(environment).
?- env_set_global(test, value).
?- env_key_val(test, V).
```

### Adding New Features

1. Edit `environment.pl`
2. Add PLDoc documentation
3. Add tests to appropriate test file
4. Add example if significant feature
5. Update README.md
6. Run all tests to verify

## File Structure

```
environment/
├── environment.pl           # Core module (317 lines)
├── scryer-manifest.pl       # Bakage manifest
├── .envrc                   # direnv config
├── justfile                 # Task runner
├── LICENSE                  # BSD-2-Clause
├── README.md                # Main documentation
├── QUICKSTART.md            # Quick start guide
├── SETUP.md                 # This file
├── CONTRIBUTING.md          # Contribution guidelines
├── PACKAGE_SUMMARY.md       # Package overview
├── .gitignore               # Git ignores
├── examples/                # 7 example files
│   ├── README.md
│   ├── 00_quickstart.pl
│   ├── 01_basic_usage.pl
│   ├── 02_configuration_management.pl
│   ├── 03_feature_flags.pl
│   ├── 04_counters_and_state.pl
│   └── 05_managed_predicates_pattern.pl
└── tests/                   # 6 test files (22 tests)
    ├── README.md
    ├── test_basic_operations.pl
    ├── test_backtracking.pl
    ├── test_edge_cases.pl
    ├── test_environment.pl
    └── run_all_tests.pl
```

## Dependencies

Standard Scryer Prolog libraries only:
- `library(reif)` - Reified predicates
- `library(assoc)` - AVL trees
- `library(iso_ext)` - Blackboard operations

No external packages required!

## Troubleshooting

### Module Not Found

Make sure:
1. `SCRYER_PATH` is set correctly (if using direnv, run `direnv allow`)
2. The `environment.pl` file exists in the package directory

### Tests Failing

1. Check you're in the correct directory
2. Verify all dependencies are available
3. Try running individual predicates interactively

### Examples Not Working

Examples use relative paths (`'../environment.pl'`).
Run them from the project root:
```bash
scryer-prolog examples/00_quickstart.pl
```

## Publishing

### 1. Create GitHub Repository

```bash
git init
git add .
git commit -m "Initial commit"
gh repo create environment --public --source=. --remote=origin
git push -u origin main
```

### 2. Update README

Replace `jjtolton` with your GitHub username in:
- README.md
- QUICKSTART.md
- SETUP.md

### 3. Tag a Release

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Need Help?

- **Issues**: Open an issue on GitHub
- **API Docs**: See `README.md`
- **Examples**: Check `examples/` directory
- **Tests**: Look at `tests/` for usage patterns
