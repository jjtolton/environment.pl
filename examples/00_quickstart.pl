:- use_module('../environment.pl').

quickstart :-
    write('=== Environment Library Quickstart ==='), nl, nl,

    write('Setting global values...'), nl,
    env_set_global(name, 'Alice'),
    env_set_global(age, 30),
    env_set_global_flag(active),
    nl,

    write('Retrieving values...'), nl,
    env_key_val(name, Name),
    write('  Name: '), write(Name), nl,
    env_key_val(age, Age),
    write('  Age: '), write(Age), nl,
    nl,

    write('Checking flags...'), nl,
    (env_check_flag(active) ->
        write('  active flag: YES') ;
        write('  active flag: NO')), nl,
    (env_check_flag(missing) ->
        write('  missing flag: YES') ;
        write('  missing flag: NO')), nl,
    nl,

    write('Using reified predicates...'), nl,
    env_check_flag_t(active, T1),
    write('  active exists (reified): '), write(T1), nl,
    env_check_flag_t(missing, T2),
    write('  missing exists (reified): '), write(T2), nl,
    nl,

    write('Getting value with default...'), nl,
    env_key_val_notfound(configured, Val, default_config),
    write('  configured (with default): '), write(Val), nl,
    nl,

    write('Once-only initialization...'), nl,
    env_set_global_once(initialized, true),
    write('  First init: OK'), nl,
    env_set_global_once(initialized, true),
    write('  Second init with same value: OK'), nl,
    nl,

    write('Quickstart complete!'), nl.

:- initialization(quickstart).
