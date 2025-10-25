run_all_tests :-
    write('Environment Library - Test Suite'), nl,
    write('====================================='), nl, nl,

    write('Loading: Basic Operations'), nl,
    use_module('tests/test_basic_operations.pl'),
    nl,

    write('Loading: Backtracking Behavior'), nl,
    use_module('tests/test_backtracking.pl'),
    nl,

    write('Loading: Edge Cases'), nl,
    use_module('tests/test_edge_cases.pl'),

    nl, nl,
    write('====================================='), nl,
    write('All test suites completed!'), nl.

:- initialization(run_all_tests).
