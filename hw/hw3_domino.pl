%---------------------------------------- 
% sdi1600192
% 
% Mrv was not implemented.
% 
% To
% dominos([(x,x)]).
% frame([[x,x]]).
% bgazei 2 solutions
%---------------------------------------- 
dominos([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(2,2),(2,3),(2,4),(2,5),(2,6),
(3,3),(3,4),(3,5),(3,6),
(4,4),(4,5),(4,6),
(5,5),(5,6),
(6,6)]).

frame([[3,1,2,6,6,1,2,2],
    [3,4,1,5,3,0,3,6],
    [5,6,6,1,2,4,5,0],
    [5,6,4,1,3,3,0,0],
    [6,1,0,6,3,2,4,0],
    [4,1,5,2,4,3,5,5],
    [4,1,0,2,4,5,2,0]]).
%---------------------------------------- 
put_dominos:-
    frame(Fr),
    dominos(Dom),
    size_matrix(Fr, N, Res),
    % get a list from 1 to N size nXm of frame
    make_domain(N, Domain),
    solution(Fr, Dom, Domain, Res, Matr),
    print_matrix(Matr),
    write("-----------------------"),nl.

%----------------------------------------
solution(_,[],[],Res, Res).
solution(Fr,[(A,B)|T],Domain,Res, Matr) :-
    % get coordinates of the 1st value of a domino
    coord_2d(I,J,Fr,A),

    % get coordinates of the neighbors
    get_neigh(I,J,Fr, X, I2,J2, Or1,Or2),

    % check if the neighbor is equal with the 2nd value of a domino
    B = X,

    % if they are get the ids of their place in the frame
    get_id(I,J,Fr,Id),
    get_id(I2,J2,Fr,Id2),

    % check to see if they are available in the domain
    member(Id, Domain),
    member(Id2, Domain),

    % if they are remove them
    remove_if_exists(Id, Domain, Domain2),
    remove_if_exists(Id2, Domain2, Domain3),

    % put the domino with its orientation in the matrix
    replace(Res,I,J, (A,Or1),Res2),
    replace(Res2,I2,J2, (B,Or2),Res3),

    % do the same for the next domino piece
    solution(Fr, T, Domain3, Res3, Matr).

%----------------------------------------
% get the size of the frame and get a matrix
size_matrix(Fr, N, Res):-
    row(Fr,X),
    col(Fr,Y),
    N is X*Y,
    make_matrix(X,Y,Res).
%----------------------------------------
col([H|_], N) :-
    length(H, N).

row(L, N) :-
    length(L,N).
%----------------------------------------
make_matrix(M, N, Matrix) :-
   length(Matrix, M),
   make_lines(N, Matrix).

make_lines(_, []).
make_lines(N, [Line|Matrix]) :-
   length(Line, N),
   make_lines(N, Matrix).
%----------------------------------------
make_domain(1, [1]).
make_domain(N, Domain) :-
   N > 1,
   N1 is N-1,
   make_domain(N1, RestDomain),
   append(RestDomain, [N], Domain).
%----------------------------------------
% gives the I and J of element you want  in the matrix
coord([Elem|_], Elem, 1).
coord([_|T], Elem, X):-
    coord(T, Elem, X1),   
    X is X1+1.               

coord_2d(I, J, Matrix, Elem):-
    coord(Matrix, Line, I), 
    coord(Line, Elem, J).  
%----------------------------------------
% get the neighbor value of element (i,j)
get_neigh(I,J,Fr,X, I2,J2, v,^):-
    I2 is I+1,
    J2 is J,
    get_ijth(I2,J2,Fr,X).

get_neigh(I,J,Fr,X, I2,J2, ^,v):-
    I2 is I-1,
    J2 is J,
    get_ijth(I2,J2,Fr,X).

get_neigh(I,J,Fr,X, I2,J2, >,<):-
    I2 is I,
    J2 is J+1,
    get_ijth(I2,J2,Fr,X).

get_neigh(I,J,Fr,X, I2,J2, <,>):-
    I2 is I,
    J2 is J-1,
    get_ijth(I2,J2,Fr,X).
%----------------------------------------
get_ith(1, [X|_], X).
get_ith(I, [_|L], X) :-
   I > 1,
   I1 is I-1,
   get_ith(I1, L, X).

get_ijth(I, J, Matrix, X) :-
   get_ith(I, Matrix, Line), 
   get_ith(J, Line, X).
%----------------------------------------
% get id of index int the frame
get_id(I,J,Fr,Id):-
    col(Fr,X),
    K is I-1,
    L is J-1,
    Id is X*K+L+1.
%----------------------------------------
remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-
   !.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).
%----------------------------------------
print_matrix([]).
print_matrix([H|T]) :- 
    print_line(H),
    nl, 
    print_line2(H),
    nl,
    print_matrix(T).

print_line([]).
print_line([(A,B)|T]) :-
    write(A),
    ( B = '>' ->
      write("-");
      write(" ") ),
    print_line(T).

print_line2([]).
print_line2([(_,B)|T]) :-
    ( B = 'v' ->
      write("| ");
      write("  ") ),
    print_line2(T).

%----------------------------------------
% replaces element in matrix at the coordinates given with given value
replace([H|T],1,J,X,[H2|T]):-
    replace2(H,J,X,H2).
replace([H|T],I,J,X,[H|T2]):-
    I > 1,
    I2 is I-1,
    replace(T,I2,J,X,T2).

replace2([_|T],1,X,[X|T]).
replace2([H|T],J,X,[H|T2]):-
    J > 1,
    J2 is J-1,
    replace2(T,J2,X,T2).  
%----------------------------------------