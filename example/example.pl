:- use_module('../environment.pl').

example_usage :-
    write('=== Environment Library Example ==='), nl, nl,
    
    env_set_global(name, 'Example User'),
    env_set_global_flag(initialized),
    
    env_key_val(name, Name),
    write('Name: '), write(Name), nl,
    
    (env_check_flag(initialized) ->
        write('Status: Initialized') ;
        write('Status: Not initialized')), nl.

:- initialization(example_usage).
