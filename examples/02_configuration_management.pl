:- use_module('../environment.pl').

init_app_config :-
    write('Initializing application configuration...'), nl,
    env_set_global_once(app/name, 'MyApp'),
    env_set_global_once(app/version, '1.0.0'),
    env_set_global_once(db/host, 'localhost'),
    env_set_global_once(db/port, 5432),
    env_set_global_once(db/name, 'myapp_db'),
    env_set_global_flag_once(config/loaded),
    write('Configuration initialized!'), nl, nl.

show_config :-
    write('=== Application Configuration ==='), nl,
    env_key_val(app/name, AppName),
    env_key_val(app/version, Version),
    env_key_val(db/host, Host),
    env_key_val(db/port, Port),
    env_key_val(db/name, DBName),
    format('App: ~w v~w~n', [AppName, Version]),
    format('Database: ~w:~w/~w~n', [Host, Port, DBName]), nl.

get_db_connection_string(ConnStr) :-
    env_key_val(db/host, Host),
    env_key_val(db/port, Port),
    env_key_val(db/name, DBName),
    format(atom(ConnStr), 'postgresql://~w:~w/~w', [Host, Port, DBName]).

verify_config_loaded :-
    (env_check_flag(config/loaded) ->
        write('Configuration is loaded.'), nl
    ;   write('ERROR: Configuration not loaded!'), nl,
        fail
    ).

config_example :-
    write('=== Configuration Management Example ==='), nl, nl,

    init_app_config,
    verify_config_loaded,
    show_config,

    write('Getting database connection string...'), nl,
    get_db_connection_string(Conn),
    format('Connection: ~w~n', [Conn]), nl,

    write('Attempting to reinitialize (should preserve values)...'), nl,
    init_app_config,
    show_config,

    write('Configuration management complete!'), nl.

:- initialization(config_example).
