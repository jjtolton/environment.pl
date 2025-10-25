:- use_module('../environment.pl').
:- use_module(library(format)).

init_counter(Name) :-
    env_set_global_once(Name, 0).

increment_counter(Name) :-
    env_key_val_notfound(Name, Current, 0),
    Next is Current + 1,
    env_set_global(Name, Next),
    format('~w: ~w -> ~w~n', [Name, Current, Next]).

get_counter(Name, Value) :-
    env_key_val_notfound(Name, Value, 0).

reset_counter(Name) :-
    env_set_global(Name, 0),
    format('Reset ~w to 0~n', [Name]).

record_event(Event) :-
    atom_concat('counter/', Event, CounterKey),
    increment_counter(CounterKey).

show_statistics :-
    write('=== Event Statistics ==='), nl,
    get_counter('counter/page_views', PageViews),
    get_counter('counter/api_calls', APICalls),
    get_counter('counter/errors', Errors),
    format('Page Views: ~w~n', [PageViews]),
    format('API Calls: ~w~n', [APICalls]),
    format('Errors: ~w~n', [Errors]), nl.

push_undo_stack(Item) :-
    env_key_val_notfound('state/undo_stack', Stack, []),
    env_set_global('state/undo_stack', [Item|Stack]),
    format('Pushed to undo stack: ~w~n', [Item]).

pop_undo_stack(Item) :-
    env_key_val_notfound('state/undo_stack', [Item|Rest], []),
    env_set_global('state/undo_stack', Rest),
    format('Popped from undo stack: ~w~n', [Item]).

show_undo_stack :-
    env_key_val_notfound('state/undo_stack', Stack, []),
    format('Undo stack: ~w~n', [Stack]).

counters_example :-
    write('=== Counters and State Management Example ==='), nl, nl,

    write('1. Simple counters:'), nl,
    init_counter('counter/requests'),
    increment_counter('counter/requests'),
    increment_counter('counter/requests'),
    increment_counter('counter/requests'),
    get_counter('counter/requests', Count),
    format('Total requests: ~w~n', [Count]), nl,

    write('2. Event tracking:'), nl,
    record_event(page_views),
    record_event(page_views),
    record_event(page_views),
    record_event(api_calls),
    record_event(api_calls),
    record_event(errors),
    show_statistics,

    write('3. Undo stack:'), nl,
    push_undo_stack(action1),
    push_undo_stack(action2),
    push_undo_stack(action3),
    show_undo_stack,
    pop_undo_stack(A1),
    pop_undo_stack(A2),
    show_undo_stack, nl,

    write('4. Resetting counters:'), nl,
    reset_counter('counter/requests'),
    get_counter('counter/requests', FinalCount),
    format('Requests after reset: ~w~n', [FinalCount]),

    write('Counters example complete!'), nl.

:- initialization(counters_example).
