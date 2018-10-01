list_head([],[],[]).
list_head([H | T], H, T).

read_input(File, Pistes) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream, N, Pistes).

read_lines(Stream, N, Pistes) :-
    ( N == -1 -> Pistes = []
	; N > -1  ->read_line(Stream, N, Pista),
				Nm1 is N-1,
				read_lines(Stream, Nm1, RestPistes),
				Pistes = [Pista | RestPistes]).

read_line(Stream, N, pista(Index, Stars, Rk, Ek)) :-
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	maplist(atom_number, Atoms, [Num_Of_Rk, _, Stars | Rest]),
    append(Rk, Ek, Rest),
    length(Rk, Num_Of_Rk),
    Index is N.            %h prwth pista einai to 4

remove_keys([], I, I).
remove_keys([H | T], Inv, New_Inv) :-
    select(H, Inv, I),
    remove_keys(T, I, New_Inv).

check_keys(_, []).
check_keys(I, [H | T]) :-   %[H|T]==Rk  
    select(H, I, Rest),
    check_keys(Rest, T).

check_visited_pista(Ind, Visited) :-
    member(Ind, Visited).

next_states(_, [], NewStates, NewStates).
next_states(state(Ind, St, Vis, Inv), Pistes, NS1, NewStates) :-
    list_head(Pistes, pista(Index, Stars, Rk, Ek), Tlpista),
    (\+check_visited_pista(Index, Vis), check_keys(Inv, Rk) -> 
                        NewSt is St + Stars,
                        append([Index], Vis, NewVis),
                        remove_keys(Rk, Inv, I),
                        append(Ek, I, NewInv),                   
                        append([state(Index, NewSt, NewVis, NewInv)], NS1, NS2),
                        next_states(state(Ind, St, Vis, Inv), Tlpista, NS2, NewStates)
    ; next_states(state(Ind, St, Vis, Inv), Tlpista, NS1, NewStates)).

quick_check_states(state(Index, _, _, _), [state(Ind, _, _, _) | T]) :-
    Index == Ind ; quick_check_states(state(Index, _, _, _), T).

check_states(state(_, _, Vis1, Inv1), [state(_, _, Vis2, Inv2) | T]) :-
    subset(Vis1, Vis2), subset(Vis2, Vis1), subset(Inv1, Inv2), subset(Inv2, Inv1) ; check_states(state(_, _, Vis1, Inv1), T).

check_score(state(_, S, _, _), M, Max) :-
    ( S > M -> Max is S
    ; Max is M).

check_new_visited(PVs, [], Q, PVs, Q).
check_new_visited(PVs, [H | T], Q, Visited, Queue) :- %[H|T]==nextStates
    (quick_check_states(H, PVs), check_states(H, PVs) -> check_new_visited(PVs, T, Q, Visited, Queue) 
    ; append([H], PVs, NVs), %an den exei ta next_states sta visisted ta bazei sto queue kai sta visited
    append([H], Q, NewQ),
    check_new_visited(NVs, T, NewQ, Visited, Queue)).

bfs([], _, _, NewM, NewM).
bfs([H | T], ListOfPistes, VisitedStates, M, MaxScore) :-     %[H|T]==Queue
    next_states(H, ListOfPistes, [], NewStates),
    check_new_visited(VisitedStates, NewStates, [], NewV, Q),
    append(T, Q, Queue),
    check_score(H, M, NewM),
    bfs(Queue, ListOfPistes, NewV, NewM, MaxScore).

initial_state(pista(I, S, _, E), state(I, S, [I], E)).

solution(In, In).

pistes(File, Answer) :-
    read_input(File, Pistes),
    list_head(Pistes, InPista, _),
    initial_state(InPista, InState),
    VisitedStates = [InState],
    bfs([InState], Pistes, VisitedStates, 0, Max),
    solution(Max, Answer), 
    !.
