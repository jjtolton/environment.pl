:- use_module(environment).

test_basic_get_set :-
    env_set_global(test_key, test_value),
    env_key_val(test_key, Value),
    write('Test 1 (basic get/set): '),
    (Value = test_value -> write('PASS') ; write('FAIL')), nl.

test_flag_operations :-
    env_set_global_flag(test_flag),
    env_check_flag(test_flag),
    write('Test 2 (flag operations): PASS'), nl.

test_reified_check :-
    env_set_global(key1, value1),
    env_check_flag_t(key1, T1),
    env_check_flag_t(nonexistent, T2),
    write('Test 3 (reified check): '),
    (T1 = true, T2 = false -> write('PASS') ; write('FAIL')), nl.

test_key_val_notfound :-
    env_key_val_notfound(missing, Value, default_value),
    write('Test 4 (key_val_notfound): '),
    (Value = default_value -> write('PASS') ; write('FAIL')), nl.

test_remove :-
    env_set_global(temp_key, temp_value),
    env_remove(temp_key),
    env_check_flag_t(temp_key, T),
    write('Test 5 (remove): '),
    (T = false -> write('PASS') ; write('FAIL')), nl.

test_check_key_val :-
    env_set_global(color, blue),
    env_check_key_val_t(color, blue, T1),
    env_check_key_val_t(color, red, T2),
    write('Test 6 (check_key_val): '),
    (T1 = true, T2 = false -> write('PASS') ; write('FAIL')), nl.

test_set_once :-
    env_set_global_once(once_key, first_value),
    env_set_global_once(once_key, first_value),
    env_key_val(once_key, V),
    write('Test 7 (set_once same value): '),
    (V = first_value -> write('PASS') ; write('FAIL')), nl.

run_all_tests :-
    write('Running environment.pl tests...'), nl, nl,
    test_basic_get_set,
    test_flag_operations,
    test_reified_check,
    test_key_val_notfound,
    test_remove,
    test_check_key_val,
    test_set_once,
    nl,
    write('All tests completed!'), nl.

:- initialization(run_all_tests).
