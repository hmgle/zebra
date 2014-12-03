-module(zebra).
-compile(export_all).

%% @spec (List::list(), Ele) -> integer()
%% @doc Returns the position of `Ele' in the `List'. 0 is returned
%%      when `Ele' is not found.
%% @end
pos(List, Ele) ->
     pos(List, Ele, 1).
pos([Ele | _Tail], Ele, Pos) ->
     Pos;
pos([_ | Tail], Ele, Pos) ->
     pos(Tail, Ele, Pos+1);
pos([], _Ele, _) ->
     0.

nation() -> ['England', 'Spain', 'Japan', 'Italy', 'Norway'].
profession() -> [painter, diplomat, violinist, doctor, sculptor].
color() -> [green, red, yellow, blue, white].
animal() -> [dog, zebra, fox, snail, horse].
drink() -> [juice, water, tea, coffee, milk].

data_inx(N, Data) ->
    lists:nth(N, Data()).

data_pos(Name, Data) ->
    pos(Data(), Name).

perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

full_perms(N) ->
    perms(lists:seq(1, N)).

zebra_print() ->
    [io:format("Nation:\t\t~-12s~-12s~-12s~-12s~-12s~n"
                "Color:\t\t~-12s~-12s~-12s~-12s~-12s~n"
                "Profession:\t~-12s~-12s~-12s~-12s~-12s~n"
                "Animal:\t\t~-12s~-12s~-12s~-12s~-12s~n"
                "Drink:\t\t~-12s~-12s~-12s~-12s~-12s~n~n",
               [data_inx(pos(N, 1), fun nation/0),
                data_inx(pos(N, 2), fun nation/0),
                data_inx(pos(N, 3), fun nation/0),
                data_inx(pos(N, 4), fun nation/0),
                data_inx(pos(N, 5), fun nation/0),

                data_inx(pos(C, 1), fun color/0),
                data_inx(pos(C, 2), fun color/0),
                data_inx(pos(C, 3), fun color/0),
                data_inx(pos(C, 4), fun color/0),
                data_inx(pos(C, 5), fun color/0),

                data_inx(pos(P, 1), fun profession/0),
                data_inx(pos(P, 2), fun profession/0),
                data_inx(pos(P, 3), fun profession/0),
                data_inx(pos(P, 4), fun profession/0),
                data_inx(pos(P, 5), fun profession/0),

                data_inx(pos(A, 1), fun animal/0),
                data_inx(pos(A, 2), fun animal/0),
                data_inx(pos(A, 3), fun animal/0),
                data_inx(pos(A, 4), fun animal/0),
                data_inx(pos(A, 5), fun animal/0),

                data_inx(pos(D, 1), fun drink/0),
                data_inx(pos(D, 2), fun drink/0),
                data_inx(pos(D, 3), fun drink/0),
                data_inx(pos(D, 4), fun drink/0),
                data_inx(pos(D, 5), fun drink/0)]) ||
                                    {N, C, P, A, D} <- zebra()
    ].

who_own_zebra() ->
    [data_inx(pos(N, pos(A, data_pos(zebra, fun animal/0))), fun nation/0) ||
        {N, _C, _P, A, _D} <- zebra()
    ].

zebra() ->
    [{N, C, P, A, D} ||
            N <- full_perms(5),

            %% The Norwegian lives in the leftmost house
            lists:nth(data_pos('Norway', fun nation/0), N) =:= 1,

            C <- full_perms(5),

            %% The Norwegian's house is next to the blue one
            (((lists:nth(data_pos('Norway', fun nation/0), N) + 1) =:= lists:nth(data_pos(blue, fun color/0), C)) orelse ((lists:nth(4, C) + 1) =:= lists:nth(5, N))),

            %% The Englishman lives in the red house
            lists:nth(data_pos('England', fun nation/0), N) =:= lists:nth(data_pos(red, fun color/0), C),

            %% The green house is to the right of the white one
            lists:nth(data_pos(white, fun color/0), C) + 1 =:= lists:nth(data_pos(green, fun color/0), C),

            P <- full_perms(5),

            %% The Japanese is the painter
            lists:nth(data_pos('Japan', fun nation/0), N) =:= lists:nth(data_pos(painter, fun profession/0), P),

            A <- full_perms(5),

            %% The Spaniard owns the dog
            lists:nth(data_pos('Spain', fun nation/0), N) =:= lists:nth(data_pos(dog, fun animal/0), A),

            %% The sculptor breeds snails
            lists:nth(data_pos(sculptor, fun profession/0), P) =:= lists:nth(data_pos(snail, fun animal/0), A),

            D <- full_perms(5),

            %% The diplomat lives in the yellow house
            lists:nth(data_pos(diplomat, fun profession/0), P) =:= lists:nth(data_pos(yellow, fun color/0), C),

            %% The fox is in the house next to the doctor's house
            (((lists:nth(data_pos(fox, fun animal/0), A) + 1) =:= lists:nth(data_pos(doctor, fun profession/0), P)) orelse ((lists:nth(data_pos(doctor, fun profession/0), P) + 1) =:= lists:nth(data_pos(fox, fun animal/0), A))),

            %% The horse is in the house next to the diplomat's
            (((lists:nth(data_pos(horse, fun animal/0), A) + 1) =:= lists:nth(data_pos(diplomat, fun profession/0), P)) orelse ((lists:nth(data_pos(diplomat, fun profession/0), P) + 1) =:= lists:nth(data_pos(horse, fun animal/0), A))),

            %% Milk is drunk in the third house
            lists:nth(data_pos(milk, fun drink/0), D) =:= 3,

            %% The Italian likes tea
            lists:nth(data_pos('Italy', fun nation/0), N) =:= lists:nth(data_pos(tea, fun drink/0), D),

            %% The owner of the green house likes coffee
            lists:nth(data_pos(green, fun color/0), C) =:= lists:nth(data_pos(coffee, fun drink/0), D),

            %% The violinist likes juice
            lists:nth(data_pos(violinist, fun profession/0), P) =:= lists:nth(data_pos(juice, fun drink/0), D)
    ].

