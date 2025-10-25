:- use_module('../environment.pl').
:- use_module(library(format)).

test_compound_keys :-
    write('Test: Compound term keys... '),
    env_set_global(app/config/db, localhost),
    env_set_global(app/config/port, 5432),
    env_key_val(app/config/db, DB),
    env_key_val(app/config/port, Port),
    (DB = localhost, Port = 5432 -> write('PASS') ; write('FAIL')), nl.

test_atom_keys :-
    write('Test: Atom keys... '),
    env_set_global(simple, value),
    env_key_val(simple, V),
    (V = value -> write('PASS') ; write('FAIL')), nl.

test_number_keys :-
    write('Test: Number keys... '),
    env_set_global(42, answer),
    env_key_val(42, V),
    (V = answer -> write('PASS') ; write('FAIL')), nl.

test_complex_values :-
    write('Test: Complex term values... '),
    env_set_global(data, [a,b,c, nested([1,2,3])]),
    env_key_val(data, V),
    (V = [a,b,c, nested([1,2,3])] -> write('PASS') ; write('FAIL')), nl.

test_overwrite_value :-
    write('Test: Overwriting values... '),
    env_set_global(overwrite1, first),
    env_set_global(overwrite1, second),
    env_set_global(overwrite1, third),
    env_key_val(overwrite1, V),
    (V = third -> write('PASS') ; write('FAIL')), nl.

test_empty_list_value :-
    write('Test: Empty list as value... '),
    env_set_global(empty, []),
    env_key_val(empty, V),
    (V = [] -> write('PASS') ; write('FAIL')), nl.

test_check_nonexistent :-
    write('Test: Check non-existent key... '),
    env_check_flag_t(totally_missing_key_12345, T),
    (T = false -> write('PASS') ; write('FAIL')), nl.

test_multiple_flags :-
    write('Test: Multiple flags... '),
    env_set_global_flag(flag_a),
    env_set_global_flag(flag_b),
    env_set_global_flag(flag_c),
    env_check_flag(flag_a),
    env_check_flag(flag_b),
    env_check_flag(flag_c),
    write('PASS'), nl.

test_assert_missing_flag :-
    write('Test: Assert missing flag (should error)... '),
    catch(
        (env_assert_flag(missing_flag_xyz), write('FAIL')),
        error(key_error(_), _),
        write('PASS')
    ), nl.

run_edge_case_tests :-
    write('=== Edge Case Tests ==='), nl, nl,
    test_compound_keys,
    test_atom_keys,
    test_number_keys,
    test_complex_values,
    test_overwrite_value,
    test_empty_list_value,
    test_check_nonexistent,
    test_multiple_flags,
    test_assert_missing_flag,
    nl, write('Edge case tests complete!'), nl.

:- initialization(run_edge_case_tests).
