:- lib(ic).

liars(List, Liars):-
    length(List, N),
    length(Liars, N),               % The lists are the same size
    Liars #:: 0..1,                 % 0 or 1 depending on if he is a liar or not
    Sum #= sum(Liars),              % the sum is equal with the number of liars
    constrain(List, Liars, Sum),    % check the constrain
    search(Liars, 0, input_order, indomain, complete, []).  % find solution

constrain([], [], _).
constrain([H1|T1], [H2|T2], Sum):-
    H2 #= (Sum #< H1),
    constrain(T1, T2, Sum).