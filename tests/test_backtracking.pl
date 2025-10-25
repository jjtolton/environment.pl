:- use_module('../environment.pl').
:- use_module(library(format)).
:- use_module(library(lists)).

test_global_persists :-
    write('Test: Global changes persist across backtracking... '),
    env_set_global(global1, value1),
    (env_key_val(global1, V1), V1 = value1 ; true),
    env_key_val(global1, V2),
    (V2 = value1 -> write('PASS') ; write('FAIL')), nl.

test_local_backtracks :-
    write('Test: Local changes backtrack... '),
    env_set_global(local1, initial),
    (env_set_local(local1, changed), fail ; true),
    env_key_val(local1, V),
    (V = initial -> write('PASS') ; write('FAIL')), nl.

test_local_in_choice_point :-
    write('Test: Local set inside choice point... '),
    env_set_global(choice1, base),
    findall(V,
            (member(X, [1,2,3]),
             env_set_local(choice1, X),
             env_key_val(choice1, V)),
            Vs),
    env_key_val(choice1, Final),
    (Vs = [1,2,3], Final = base -> write('PASS') ; write('FAIL')), nl.

test_b_remove_backtracks :-
    write('Test: Backtrackable remove... '),
    env_set_global(bremove1, kept),
    (env_b_remove(bremove1), fail ; true),
    env_check_flag_t(bremove1, T),
    (T = true -> write('PASS') ; write('FAIL')), nl.

test_mixed_global_local :-
    write('Test: Mix of global and local changes... '),
    env_set_global(mix1, global_val),
    (   env_set_local(mix1, local_val),
        env_key_val(mix1, V1),
        V1 = local_val,
        fail
    ;   true
    ),
    env_key_val(mix1, V2),
    (V2 = global_val -> write('PASS') ; write('FAIL')), nl.

run_backtracking_tests :-
    write('=== Backtracking Tests ==='), nl, nl,
    test_global_persists,
    test_local_backtracks,
    test_local_in_choice_point,
    test_b_remove_backtracks,
    test_mixed_global_local,
    nl, write('Backtracking tests complete!'), nl.

:- initialization(run_backtracking_tests).
