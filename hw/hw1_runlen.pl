repeat(_, 0, []).
repeat(H, Num, [H|T]) :-
    Num > 0,
    Num1 is Num-1,
    repeat(H, Num1, T).

decode_rl([], []).

decode_rl([(X,N)|T], D) :-
    decode_rl(T, Dr),
    repeat(X, N, L),
    append(L, Dr, D).

decode_rl([X|T],[X|D]):-
    X \= (_,_),
    decode_rl(T,D).

encode_rl([],[]).

encode_rl([X|T],[(X,C1)|R]) :- 
    encode_rl(T,[(X,C)|R]),!, 
    C1 is C+1.

encode_rl([X|T],[(X,1)|R]) :- 
    encode_rl(T,R).

% encode_rl([p(3),p(X),q(X),q(Y),q(4)], L).
% X = 3
% Y = 3
% L = [(p(3), 2), (q(3), 2), (q(4), 1)]
% Η prolog προσπαθεί να αντιστοιχίσει τα Χ,Υ σε ορισμένες τιμές μια μια και επειδή βλέπει μια λίστα 
% από αριστερά στα δεξιά δίνει πρώτα στην Χ και μετά στην Υ. 
% Ανάλογα το πρόγραμμα το Χ και το Υ θα μπορούσαν να πάρουν τιμή 
% είτε 3 είτε 4 στην περίπτωση μου όμως πήραν την τιμή 3.