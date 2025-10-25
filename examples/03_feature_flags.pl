:- use_module('../environment.pl').
:- use_module(library(reif)).
:- use_module(library(format)).

enable_feature(Feature) :-
    env_set_global_flag(Feature),
    format('Feature enabled: ~w~n', [Feature]).

disable_feature(Feature) :-
    env_remove(Feature),
    format('Feature disabled: ~w~n', [Feature]).

feature_enabled(Feature) :-
    env_check_flag(Feature).

feature_enabled_t(Feature, T) :-
    env_check_flag_t(Feature, T).

conditional_feature(Message) :-
    feature_enabled_t(feature/logging, T),
    if_(T=true,
        format('LOG: ~w~n', [Message]),
        true
       ).

maybe_cache(Data, Result) :-
    feature_enabled_t(feature/caching, T),
    if_(T=true,
        (format('Caching enabled - storing: ~w~n', [Data]),
         Result = cached(Data)),
        (format('Caching disabled - passthrough: ~w~n', [Data]),
         Result = Data)
       ).

feature_flags_example :-
    write('=== Feature Flags Example ==='), nl, nl,

    write('1. Enabling features:'), nl,
    enable_feature(feature/logging),
    enable_feature(feature/caching),
    enable_feature(feature/analytics), nl,

    write('2. Testing conditional execution:'), nl,
    conditional_feature('This message should appear'),
    disable_feature(feature/logging),
    conditional_feature('This message should NOT appear'), nl,

    write('3. Conditional logic with caching:'), nl,
    enable_feature(feature/caching),
    maybe_cache([1,2,3], R1),
    format('Result: ~w~n', [R1]), nl,

    disable_feature(feature/caching),
    maybe_cache([4,5,6], R2),
    format('Result: ~w~n', [R2]), nl,

    write('4. Checking multiple features:'), nl,
    enable_feature(feature/logging),
    enable_feature(feature/debug),
    (feature_enabled(feature/logging) ->
        write('   Logging: ON') ; write('   Logging: OFF')), nl,
    (feature_enabled(feature/debug) ->
        write('   Debug: ON') ; write('   Debug: OFF')), nl,
    (feature_enabled(feature/caching) ->
        write('   Caching: ON') ; write('   Caching: OFF')), nl,

    write('Feature flags example complete!'), nl.

:- initialization(feature_flags_example).
