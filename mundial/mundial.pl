read_input(File, Teams) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream, N, Teams).

read_lines(Stream, N, Teams) :-
    ( N == 0 -> Teams = []
    ; N > 0  -> read_line(Stream, Team),
                Nm1 is N-1,
                read_lines(Stream, Nm1, RestTeams),
                Teams = [Team | RestTeams]).

read_line(Stream, team(Name, P, A, B)) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat([Name | Atoms], ' ', Atom),
    maplist(atom_number, Atoms, [P, A, B]).

check_losers_per_round([], W, L, W, L).
check_losers_per_round([team(N, S, Gs, Gt) | T], W, L, Winners, Losers) :-
   (S == 1 -> append([team(N, S, Gs, Gt)], L, NL),
              check_losers_per_round(T, W, NL, Winners, Losers)
            ; append([team(N, S, Gs, Gt)], W, NW),
              check_losers_per_round(T, NW, L, Winners, Losers)).

pair(team(N1, S1, Gs1, Gt1), team(N2, _, Gs2, Gt2), team(N1, S3, Gs3, Gt3), match(N1, N2, Gt2, Gs2)) :- %N1=Winner,  N2=Loser, N3=Newwiiner
    Gs1 >= Gt2, Gt1 >= Gs2, Gs2 =\= Gt2 -> S3 is S1 - 1,
                                          Gs3 is Gs1 - Gt2,
                                          Gt3 is Gt1 - Gs2.

pair_all([], [], W, P, W, P).
pair_all([Hw | Tw], [Hl | Tl], NewWinners, Pairs, W, P) :-
    pair(Hw, Hl, NW, Match),
    append([NW], NewWinners, NewW),
    append([Match], Pairs, NewPairs),
    pair_all(Tw, Tl, NewW, NewPairs, W, P).
    
match_up_per_round(Winners, Losers, NewWinners, Matches) :-     
    permutation(Winners, PW),    
    pair_all(PW, Losers, [], [], NewWinners, Matches).

matches([team(N1, _, Gs1, Gt1), team(N2, _, Gs2, Gt2)], M, Final) :-
    Gs1 = Gt2,
    Gt1 = Gs2,
    Gs1 =\= Gs2,
    (Gs1 > Gs2 -> append([match(N1, N2, Gs1, Gt1)], M, Final)
                ; append([match(N2, N1, Gs2, Gt2)], M, Final)).
matches(Teams, Matches, FinalRes) :-
    check_losers_per_round(Teams, [], [], Winners, Losers),
    match_up_per_round(Winners, Losers, NewWinners, M),
    append(M, Matches, NewMatches),
    matches(NewWinners, NewMatches, FinalRes).    
       
mundial(File, Res) :-
    read_input(File, Teams),
    matches(Teams, [], Res).    

