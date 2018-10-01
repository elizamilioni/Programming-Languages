read_file(File, N, List) :-
    open(File, read, Stream),
    read_line(Stream, N1),
    read_line(Stream, List),
    get_head(N1,N),
    close(Stream).
    
/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).
    
/* StackOverFlow : https://stackoverflow.com/questions/19471778/reversing-a-list-in-prolog */
reverse_list([],Z,Z).
reverse_list([H|T], Acc, Z) :- reverse_list(T, [H|Acc], Z).

/* Get head, tail or both! */
get_head_tail([], [], []).
get_head_tail([H|T], H, T).
get_head([H|_],H).
get_tail([_|T],T).

/* GCD given by nickie. Added Restrictions for time purposes */
gcd(X, 0, GCD) :- GCD = X, !.
gcd(X, Y, GCD) :-
    Mod is mod(X, Y),
    NewX is Y,
    NewY is Mod,
    gcd(NewX, NewY, GCD).


lcm(X, Y, LCM) :-
    gcd(X, Y, GCD),
    LCM is (X // GCD) * Y.
    
/* Make a list with the least common multiples. */	
lcm_list([], Helper_list, List) :- List = Helper_list.
lcm_list([H|T], Helper_list, List) :- 
    get_head_tail(Helper_list, Head, _),
    lcm(H, Head, LCM),
    append([LCM], Helper_list, List2),
    lcm_list(T, List2, List).
    
min(_, [], [], Second_min, Second_Pos, -99, Second_min, Second_Pos).
    
min(N, [Hd|Tl], [H|T], Second_min, Second_Pos, 1, Min, Pos) :-
    get_head_tail(T, Head_T, _),
    ( Head_T < Second_min -> min(N, [Hd|Tl], [H|T], Head_T, 1, 2, Min, Pos)
    ; min(N, [Hd|Tl], [H|T], Second_min, Second_Pos, 2, Min, Pos)).
    
min(N, [Hd|Tl], [_|T], Second_min, Second_Pos, Index, Min, Pos) :-
    ( Index =:= N -> ( Hd < Second_min -> min(N, [], [], Hd, Index, -99, Min, Pos)
    ; min(N, [], [], Second_min, Second_Pos, -99, Min, Pos))
    ; get_head_tail(T, _, Tl_T),
      get_head_tail(Tl_T, Hd_Tl_t, _),
      lcm(Hd, Hd_Tl_t, LCM),
      New_Index is Index + 1,
      ( LCM < Second_min -> min(N, Tl, T, LCM, Index, New_Index, Min, Pos)
      ; min(N, Tl, T, Second_min, Second_Pos, New_Index, Min, Pos))).
      
    
agora_main(File, When, Missing) :-
 	read_file(File, N, List),
    get_head_tail(List, Head, Tail),
    reverse_list(List, [], R_List),
    get_head_tail(R_List, R_Head, R_Tail),
    lcm_list(Tail, [Head], Left_lcm),
    lcm_list(R_Tail, [R_Head], Right_lcm),
    get_head_tail(Right_lcm, Head_Right_lcm, _),
    reverse_list(Left_lcm, [], R_Left_lcm),
    min(N, R_Left_lcm, Right_lcm, Head_Right_lcm, 0, 1, When, Missing).  

/* Terminate without testing other options. */
agora(File, When, Missing) :-
    once(agora_main(File, When, Missing)).
