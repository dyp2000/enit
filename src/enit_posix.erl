-module(enit_posix).
-export([load_nif/0, load_nif_or_die/0]).
-export([exec/1, getpwnam/1, getgrnam/1, setuid/1, setgid/1, syslog/3]).

load_nif() ->
    PrivDir = case code:priv_dir(enit) of
        {error, _} -> "priv";
        X -> X
    end,
    Lib = filename:join(PrivDir, "enit_posix"),
    erlang:load_nif(Lib, 0).

load_nif_or_die() ->
    case load_nif() of
        {error, {reload, _}} ->
            ok;
        {error, Error} ->
            io:format("could not load enit NIF library: ~s", [Error]),
            halt(10);
        ok ->
            ok
    end.

-spec exec([string(), ...]) -> {error, file:posix()} | no_return().
exec(_Argv) ->
    error(nif_not_loaded).

-spec getpwnam(nonempty_string()) -> {ok, [{atom(), term()}]} | {error, file:posix()}.
getpwnam(_Name) ->
    error(nif_not_loaded).

-spec getgrnam(nonempty_string()) -> {ok, [{atom(), term()}]} | {error, file:posix()}.
getgrnam(_Name) ->
    error(nif_not_loaded).

-spec setuid(non_neg_integer()) -> ok | {error, file:posix()}.
setuid(_User) ->
    error(nif_not_loaded).

-spec setgid(non_neg_integer()) -> ok | {error, file:posix()}.
setgid(_Group) ->
    error(nif_not_loaded).

-spec syslog(atom() | integer(), io:format(), [term()]) -> ok.
syslog(Level, Format, Data) ->
    Msg = lists:flatten(io_lib:format(Format, Data)),
    syslog(severity_int(Level), Msg).

-spec syslog(non_neg_integer(), string()) -> ok.
syslog(_Level, _Msg) ->
    error(nif_not_loaded).

severity_int(I) when is_integer(I), I >= 0, I =< 7 -> I;
severity_int(emergency)                            -> 0;
severity_int(emerg)                                -> 0;
severity_int(alert)                                -> 1;
severity_int(critical)                             -> 2;
severity_int(crit)                                 -> 2;
severity_int(error)                                -> 3;
severity_int(err)                                  -> 3;
severity_int(warning)                              -> 4;
severity_int(notice)                               -> 5;
severity_int(informational)                        -> 6;
severity_int(info)                                 -> 6;
severity_int(debug)                                -> 7.