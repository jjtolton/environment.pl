%% Global environment/context management for Scryer Prolog
%%
%% This module provides a clean interface for managing global state using
%% association trees (AVL trees) backed by the blackboard. It offers both
%% persistent (global) and backtrackable (local) storage with reified predicates
%% for pure conditional logic.
%%
%% @author Jay
%% @license BSD-2-Clause

:- module(environment, [
    environment/1,
    env_put/1,
    env_b_put/1,
    env_remove/1,
    env_b_remove/1,
    env_set_local_flag/1,
    env_set_global_flag/1,
    env_set_global_once/2,
    env_set_global_flag_once/1,
    env_set_global/2,
    env_set_local/2,
    env_key_val/2,
    env_key_val_notfound/3,
    env_check_flag/1,
    env_check_flag_t/2,
    env_check_key_value_t/3,
    env_assert_flag/1,
    env_check_key_val_t/3,
    env_check_key_val/2
]).

:- use_module(library(reif)).
:- use_module(library(assoc)).
:- use_module(library(iso_ext)).

:- op(1200, fx, :->).

%% Initialize the global environment exactly once using term expansion.
%% This creates an empty association tree and stores it in the blackboard.
term_expansion((:-> establish_context), context_established) :-
    (   bb_get(global_context, _), !
    ;   write('establishing global environment context...'), nl,
        empty_assoc(Assoc),
        bb_put(global_context, Assoc)
    ).

:-> establish_context.

%% environment(-Environment) is det.
%
%  Retrieve the current global environment as an association tree.
%
%  @arg Environment The current global environment (assoc tree)
environment(Environment) :-
    bb_get(global_context, Environment).

%% env_put(+Env) is det.
%
%  Replace the entire global environment (persistent across backtracking).
%
%  @arg Env The new environment to install
env_put(Env) :-
    bb_put(global_context, Env).

%% env_b_put(+Env) is det.
%
%  Replace the entire global environment (backtrackable).
%  Changes are undone on backtracking.
%
%  @arg Env The new environment to install
env_b_put(Env) :-
    bb_b_put(global_context, Env).

%% env_remove(+Key) is det.
%
%  Remove a key from the environment (persistent).
%
%  @arg Key The key to remove
env_remove(K) :-
    environment(Env),
    del_assoc(K, Env, _, Env1),
    env_put(Env1).

%% env_b_remove(+Key) is det.
%
%  Remove a key from the environment (backtrackable).
%
%  @arg Key The key to remove
env_b_remove(K) :-
    environment(Env),
    del_assoc(K, Env, _, Env1),
    env_b_put(Env1).

%% env_set_local_flag(+Key) is det.
%
%  Set a flag (key with value `true`) locally (backtrackable).
%
%  @arg Key The flag name
env_set_local_flag(K) :-
    env_set_local(K, true).

%% env_set_local(+Key, +Value) is det.
%
%  Set a key-value pair locally (backtrackable).
%  Changes are undone on backtracking.
%
%  @arg Key The key to set
%  @arg Value The value to associate with the key
env_set_local(K, V) :-
    environment(Env),
    put_assoc(K, Env, V, Env1),
    bb_b_put(global_context, Env1).

%% env_set_global(+Key, +Value) is det.
%
%  Set a key-value pair globally (persistent across backtracking).
%
%  @arg Key The key to set
%  @arg Value The value to associate with the key
env_set_global(K, V) :-
    environment(Env),
    put_assoc(K, Env, V, Env1),
    env_put(Env1).

%% env_set_global_flag(+Key) is det.
%
%  Set a flag (key with value `true`) globally (persistent).
%
%  @arg Key The flag name
env_set_global_flag(K) :-
    env_set_global(K, true).

%% env_set_global_once(+Key, +Value) is det.
%
%  Set a key-value pair globally, but only if it doesn't already exist.
%  If the key exists with the same value, succeeds silently.
%  If the key exists with a different value, throws an error.
%
%  @arg Key The key to set
%  @arg Value The value to associate with the key
%  @throws error(runtime_error(env_set_global_once), _) if key exists with different value
env_set_global_once(K, V) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
        (   get_assoc(K, Env, Val),
            if_(V=Val,
                true,
                throw(error(runtime_error(env_set_global_once),
                           'Double initialized env key with different values'))
               )
        ),
        (   put_assoc(K, Env, V, Env1),
            bb_put(global_context, Env1)
        )
       ).

%% env_set_global_flag_once(+Key) is det.
%
%  Set a flag globally, but only once. Throws error if flag exists with different value.
%
%  @arg Key The flag name
%  @throws error(runtime_error(env_set_global_once), _) if flag exists with value other than `true`
env_set_global_flag_once(K) :-
    env_set_global_once(K, true).

%% env_key_val(+Key, ?Value) is det.
%
%  Retrieve the value associated with a key.
%  Throws an error if the key doesn't exist.
%
%  @arg Key The key to look up
%  @arg Value The value associated with the key
%  @throws error(key_error(Key), _) if key doesn't exist
env_key_val(K, V) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
        get_assoc(K, Env, V),
        throw(error(key_error(K), 'missing key'))
       ).

%% env_check_key_val_t(+Key, +Value, ?Truth) is det.
%
%  Reified check: does the key exist with the specified value?
%  Unifies Truth with `true` or `false`.
%
%  @arg Key The key to check
%  @arg Value The expected value
%  @arg Truth Unified with `true` if key exists with value, `false` otherwise
env_check_key_val_t(K, V, T) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
        (   get_assoc(K, Env, Val),
            if_(Val=V,
                T=true,
                T=false
               )
        ),
        T=false
       ).

%% env_check_key_val(+Key, +Value) is semidet.
%
%  Check if the key exists with the specified value (deterministic).
%  Succeeds if true, fails if false.
%
%  @arg Key The key to check
%  @arg Value The expected value
env_check_key_val(K, V) :-
    env_check_key_val_t(K, V, true).

%% env_key_val_notfound(+Key, ?Value, +NotFound) is det.
%
%  Retrieve value for a key, or unify with NotFound if key doesn't exist.
%  Never throws an error.
%
%  @arg Key The key to look up
%  @arg Value Unified with the key's value or NotFound
%  @arg NotFound The default value if key is missing
env_key_val_notfound(K, V, NotFound) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
        get_assoc(K, Env, V),
        V=NotFound
       ).

%% env_check_flag(+Key) is semidet.
%
%  Check if a flag (key) exists in the environment (deterministic).
%  Succeeds if the key exists, fails otherwise.
%
%  @arg Key The flag name to check
env_check_flag(K) :-
    env_check_flag_t(K, true).

%% env_assert_flag(+Key) is det.
%
%  Assert that a flag exists. Throws error if it doesn't.
%  Use this for precondition checking.
%
%  @arg Key The flag name to assert
%  @throws error(key_error(Key), _) if flag doesn't exist
env_assert_flag(K) :-
    env_key_val(K, _).

%% env_check_flag_t(+Key, ?Truth) is det.
%
%  Reified check: does the flag (key) exist?
%  Unifies Truth with `true` or `false`.
%
%  @arg Key The flag name to check
%  @arg Truth Unified with `true` if flag exists, `false` otherwise
env_check_flag_t(K, T) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
        T=true,
        T=false
       ).

%% env_check_key_value_t(+Key, +Value, ?Truth) is det.
%
%  Alias for env_check_key_val_t/3.
%  Reified check: does the key exist with the specified value?
%
%  @arg Key The key to check
%  @arg Value The expected value
%  @arg Truth Unified with `true` or `false`
env_check_key_value_t(K, V, T) :-
    environment(Env),
    if_(contains_key_assoc_t(K, Env),
       (   get_assoc(K, Env, Val),
           if_(V=Val,
               T=true,
               T=false
              )
       ),
        T=false
       ).

%% Internal helper predicates for reified key existence checking
%% These implement efficient O(log n) lookup in the AVL tree structure

%% contains_key_assoc_t(?Key, +Assoc, ?Found) is det.
%
%  Reified predicate: check if Key exists in Assoc.
%  Works with both ground and unground keys.
%
%  @arg Key The key to check (may be unground)
%  @arg Assoc The association tree
%  @arg Found Unified with `true` or `false`
contains_key_assoc_t(_Key, t, false).
contains_key_assoc_t(Key, t(K,V,Rel,L,R), Found) :-
    Assoc = t(K,V,Rel,L,R),
    (   ground(Key)
    ->  contains_key_assoc_t_(Key, Assoc, Found)
    ;   gen_assoc(Key, Assoc, _), Found=true
    ).

contains_key_assoc_t_(Key, t(K,V,_,L,R), Found) :-
    Assoc = t(K,V,_,L,R),
    min_assoc(Assoc, Kmin, _),
    max_assoc(Assoc, Kmax, _),
    compare(Minrel, Kmin, Key),
    compare(Maxrel, Kmax, Key),
    if_((Minrel=(>);Maxrel=(<)),
        Found=false,
        (   compare(Rel, Key, K),
            contains_key_assoc_helper(Rel, Key, V, L, R, Found)
        )
       ).

contains_key_assoc_helper(<, Key, _, Tree, _, Found) :-
    contains_key_assoc_t(Key, Tree, Found).
contains_key_assoc_helper(>, Key, _, _, Tree, Found) :-
    contains_key_assoc_t(Key, Tree, Found).
contains_key_assoc_helper(=, _Key, _, _, _, true).
