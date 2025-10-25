:- use_module('../environment.pl').
:- use_module(library(assoc)).
:- use_module(library(format)).

:- op(1200, fx, :->).

user:term_expansion((:-> init_predicate_registry), predicate_registry_initialized) :-
    empty_assoc(A),
    env_set_global_once(registry/predicates, A).

:-> init_predicate_registry.

register_predicate(Name, Metadata) :-
    env_key_val(registry/predicates, Registry0),
    put_assoc(Name, Registry0, Metadata, Registry1),
    env_set_global(registry/predicates, Registry1),
    format('Registered predicate: ~w~n', [Name]).

get_predicate_metadata(Name, Metadata) :-
    env_key_val(registry/predicates, Registry),
    get_assoc(Name, Registry, Metadata).

list_registered_predicates :-
    env_key_val(registry/predicates, Registry),
    assoc_to_list(Registry, Pairs),
    write('=== Registered Predicates ==='), nl,
    list_predicates(Pairs).

list_predicates([]).
list_predicates([Name-Metadata|Rest]) :-
    format('  ~w: ~w~n', [Name, Metadata]),
    list_predicates(Rest).

is_predicate_registered(Name) :-
    env_key_val(registry/predicates, Registry),
    get_assoc(Name, Registry, _).

user:term_expansion((:-> register_builtin_predicates), builtins_registered) :-
    register_predicate(factorial/1, [type(arithmetic), complexity(exponential)]),
    register_predicate(fibonacci/2, [type(arithmetic), complexity(exponential)]),
    register_predicate(append/3, [type(list), complexity(linear)]),
    register_predicate(member/2, [type(list), complexity(linear)]).

:-> register_builtin_predicates.

managed_predicates_example :-
    write('=== Managed Predicates Pattern Example ==='), nl, nl,

    write('This pattern is inspired by your managed_predicates.pl'), nl,
    write('It shows how to use environment for predicate metadata.'), nl, nl,

    write('1. Predicates auto-registered at compile time:'), nl,
    list_registered_predicates, nl,

    write('2. Registering predicates at runtime:'), nl,
    register_predicate(custom_sort/2, [type(sorting), complexity(nlogn), author('Alice')]),
    register_predicate(binary_search/3, [type(search), complexity(logn), author('Bob')]), nl,

    write('3. Updated registry:'), nl,
    list_registered_predicates, nl,

    write('4. Querying metadata:'), nl,
    get_predicate_metadata(fibonacci/2, FibMeta),
    format('fibonacci/2 metadata: ~w~n', [FibMeta]),
    get_predicate_metadata(custom_sort/2, SortMeta),
    format('custom_sort/2 metadata: ~w~n', [SortMeta]), nl,

    write('5. Checking registration:'), nl,
    (is_predicate_registered(append/3) ->
        write('  append/3 is registered') ;
        write('  append/3 not found')), nl,
    (is_predicate_registered(nonexistent/1) ->
        write('  nonexistent/1 is registered') ;
        write('  nonexistent/1 not found')), nl,

    write('Managed predicates pattern complete!'), nl.

:- initialization(managed_predicates_example).
