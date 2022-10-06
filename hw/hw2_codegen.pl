codegen([],[],[]).
codegen(Start, End, Actions) :-
    change*(End, End2),
    iddfs(1, Start, End2, Actions).

iddfs(Depth, Start, End, Actions) :-
    dfs(Start, End, [Start], Plan, [], Actions, Depth), !.

iddfs(Depth, Start, End, Actions) :-
    Depth1 is Depth + 1,
    iddfs(Depth1, Start, End, Actions).

dfs(State, State, Plan, Plan, Actions, Actions, _).
dfs(State1, State3, Plan1, Plan3, Actions1, Actions3, Depth) :-
    % kane dfs mono mexri to Depth pou eimaste
    % to opoio to vlepoume apo to poses kiniseis 
    % exoume kanei dld to mikos tou plan1
    length(Plan1, X),
    X < Depth,
    State1 \= State3,
    legal_move(State1, State2, Action),
    \+ member(State2, Plan1),
    append(Plan1, [State2], Plan2),
    append(Actions1, [Action], Actions2),
    dfs(State2, State3, Plan2, Plan3, Actions2, Actions3, Depth).

legal_move(State1, State2, move(X)) :-
    length(State1, N),
    between(1, N, X),
    move(X, State1, State2).

legal_move(State1, State2, swap(X,Y)) :-
    length(State1, N),
    between(1, N, X),
    between(1, N, Y),
    swap(X, Y, State1, State2).

get_ith(1, [X|_], X).
get_ith(I, [_|L], X) :-
   I > 1,
   I1 is I-1,
   get_ith(I1, L, X).

replace(1, [_|L], X, [X|L]). 
replace(I, [Y|L], X, [Y|L1]) :- 
    I > 1, 
    I1 is I-1, 
    replace(I1, L, X, L1).   

between(LBound, RBound, LBound) :-
    LBound =< RBound. 

between(LBound, RBound, Result) :-
    LBound < RBound,
    NextLBound is LBound + 1,
    between(NextLBound, RBound, Result).

move(I, List, List2) :-
    length(List, N),
    I >= 1,
    I =< N,
    (  I < N 
    -> moveI(I, List, List2)
    ;  moveN(List, List2) ).    

moveN(List, List2) :- 
    length(List, N),
    get_ith(N, List, X),
    replace(1, List, X, List2).

moveI(I, List, List2) :-
    get_ith(I, List, X),
    I1 is I+1,
    replace(I1, List, X, List2).
% 
swap(_, _, [], []).
swap(I, J, List, List2) :-
    length(List, N),
    I >= 1,
    I < J,
    J =< N,
    get_ith(I, List, X),
    get_ith(J, List, Y),
    replace(I, List, Y, L2),
    replace(J, L2, X, List2).

% change "*" with anonymous variable
change*([], []).
change*([H|T], [H|T2]) :-
    H \= *, 
    change*(T, T2).

change*([*|T], [_|T2]) :-
    change*(T, T2).