:- lib(ic).
:- lib(branch_and_bound).
:- compile(graph).

maxclq(N, D, Clique, Size):-
    create_graph(N, D, Graph),
    length(Solution, N),
    Solution #:: 0..1,
    constrain(Graph, 1, Solution),
    Cost #= N - sum(Solution),
    bb_min(search(Solution, 0, first_fail, indomain, complete, []), Cost, bb_options{strategy:restart}),
    generate(1, Solution, Clique),
    length(Clique, Size).

constrain(_, _, []).	
constrain(Graph, I, [H | T]):- 
	I1 is I + 1,
	new_const(Graph, I, I1, H, T),
	constrain(Graph, I1,T ).

new_const(_, _, _, _, []).
new_const(Graph, I, I1, H, [H1|T]):- 
	\+ member(I - I1, Graph), !,
	H + H1 #=< 1,
	I2 is I1 + 1,
	new_const(Graph, I, I2, H, T).
new_const(Graph, I, I1, H, [_|T] ):- 
	I2 is I1 + 1,
	new_const(Graph, I, I2, H, T).

generate(_, [], []).
generate(I, [0|T], Clique):-
    I1 is I+1,
    generate(I1, T, Clique).

generate(I, [1|T], [I|Clique]):-
    I1 is I+1,
    generate(I1, T, Clique).

