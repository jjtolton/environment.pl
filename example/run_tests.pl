:- use_module('../environment.pl').

test_environment :-
    write('Running environment tests...'), nl,
    
    env_set_global(test_key, test_value),
    env_key_val(test_key, V),
    (V = test_value ->
        write('Test PASSED: Basic get/set') ;
        write('Test FAILED: Basic get/set')), nl.

main :-
    test_environment,
    write('Tests complete!'), nl.

:- initialization(main).
