:- use_module('../environment.pl').
:- use_module(library(format)).

test_get_set :-
    write('Test: Basic get/set... '),
    env_set_global(test1, value1),
    env_key_val(test1, V),
    (V = value1 -> write('PASS') ; write('FAIL')), nl.

test_flags :-
    write('Test: Flag operations... '),
    env_set_global_flag(flag1),
    env_check_flag(flag1),
    write('PASS'), nl.

test_remove :-
    write('Test: Remove key... '),
    env_set_global(temp1, temp_value),
    env_remove(temp1),
    env_check_flag_t(temp1, T),
    (T = false -> write('PASS') ; write('FAIL')), nl.

test_notfound :-
    write('Test: Key not found with default... '),
    env_key_val_notfound(missing1, V, default1),
    (V = default1 -> write('PASS') ; write('FAIL')), nl.

test_reified_check :-
    write('Test: Reified flag check... '),
    env_set_global_flag(exists1),
    env_check_flag_t(exists1, T1),
    env_check_flag_t(nonexistent1, T2),
    (T1 = true, T2 = false -> write('PASS') ; write('FAIL')), nl.

test_key_val_check :-
    write('Test: Key-value checking... '),
    env_set_global(color1, blue),
    env_check_key_val_t(color1, blue, T1),
    env_check_key_val_t(color1, red, T2),
    (T1 = true, T2 = false -> write('PASS') ; write('FAIL')), nl.

test_set_once_same :-
    write('Test: Set once with same value... '),
    env_set_global_once(once1, val1),
    env_set_global_once(once1, val1),
    env_key_val(once1, V),
    (V = val1 -> write('PASS') ; write('FAIL')), nl.

test_set_once_different :-
    write('Test: Set once with different value (should fail)... '),
    env_set_global_once(once2, val2),
    catch(
        (env_set_global_once(once2, different_val), write('FAIL')),
        error(runtime_error(env_set_global_once), _),
        write('PASS')
    ), nl.

run_basic_tests :-
    write('=== Basic Operations Tests ==='), nl, nl,
    test_get_set,
    test_flags,
    test_remove,
    test_notfound,
    test_reified_check,
    test_key_val_check,
    test_set_once_same,
    test_set_once_different,
    nl, write('Basic tests complete!'), nl.

:- initialization(run_basic_tests).
