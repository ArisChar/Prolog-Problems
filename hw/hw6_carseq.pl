:- lib(ic).
:- lib(ic_global).
:- lib(ic_global_gac).

% options list of M/K/O
carseq(S):-
    classes(Cars),
    options(Opts),
    Car_num #= sum(Cars),       % number of cars is the sum
    length(Cars, Size),         % get size of classes
    length(S, Car_num),         % make a list with size = number of cars
    S #:: 1..Size,              % the list has domain from 1 until size of classes
    constrain(Cars, 1, S),      % set 1st constrain
    new_const(Cars, Opts, S),   % set 2nd constrain
    search(S, 0, input_order, indomain, complete, []).

% Classes = [C1, C2, ..., Ci]
% there must exist at least 1 C1
%                           2 C2
%                           .
%                           .
%                           i Ci
constrain([], _, _).
constrain([N|T], I, S):-
    occurrences(I, S, N),
    I1 is I+1,
    constrain(T, I1, S).

% set 2nd constrain with the help of sequence_total
% sequence_total(Min, Max, Low, High, K, Vars, Values)
% In our case Min = Max, Low = 0, High = K, K = M, Vars = S (Our solution)
new_const(_, [], _).
new_const(Cars, [M/K/O|T], S):-
    getValues_Total(Cars, O, Values, Total),
    sequence_total(Total, Total, 0, K, M, S, Values),
    new_const(Cars, T, S).    


getValues_Total(Cars, O, Values, Total):-
    getValues(O, Values),
    getTotal(Values, Cars, Total).

% make a list with the indexes of 1s in the O list
getValues(L, Res):-
    findall(X, get_ones(L, X), Res).

% with the list of the indexes get the sum of the cars that have O
getTotal([], _, 0).
getTotal([H|T], Cars, Sum):-
    get_ith(H, Cars, X),
    getTotal(T, Cars, Rest),
    Sum is X+Rest.

% get ith element of list
get_ith(1, [X|_], X).
get_ith(I, [_|L], X) :-
   I > 1,
   I1 is I-1,
   get_ith(I1, L, X).

% finds the index of 1s in a list
get_ones([1|_], 1).
get_ones([_|T], X):-
    get_ones(T, X1),   
    X is X1+1.  
