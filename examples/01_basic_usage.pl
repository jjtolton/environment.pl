:- use_module('../environment.pl').

basic_example :-
    write('=== Basic Environment Usage ==='), nl, nl,

    write('1. Setting a global value (persistent):'), nl,
    env_set_global(username, 'Alice'),
    env_key_val(username, User),
    format('   Username: ~w~n', [User]), nl,

    write('2. Setting and checking flags:'), nl,
    env_set_global_flag(debug_mode),
    (env_check_flag(debug_mode) ->
        write('   Debug mode is ON') ;
        write('   Debug mode is OFF')
    ), nl, nl,

    write('3. Using reified predicates (no cuts):'), nl,
    env_check_flag_t(debug_mode, DebugStatus),
    env_check_flag_t(nonexistent_flag, MissingStatus),
    format('   debug_mode exists: ~w~n', [DebugStatus]),
    format('   nonexistent_flag exists: ~w~n', [MissingStatus]), nl,

    write('4. Getting value with default:'), nl,
    env_key_val_notfound(missing_key, Value, 'default_value'),
    format('   Value for missing_key: ~w~n', [Value]), nl,

    write('5. Checking key-value pairs:'), nl,
    env_set_global(color, blue),
    env_check_key_val_t(color, blue, IsBlue),
    env_check_key_val_t(color, red, IsRed),
    format('   color=blue? ~w~n', [IsBlue]),
    format('   color=red? ~w~n', [IsRed]), nl,

    write('6. Removing keys:'), nl,
    env_set_global(temp, 'temporary data'),
    format('   Before removal: '),
    (env_check_flag(temp) -> write('temp exists') ; write('temp missing')), nl,
    env_remove(temp),
    format('   After removal: '),
    (env_check_flag(temp) -> write('temp exists') ; write('temp missing')), nl.

:- initialization(basic_example).
