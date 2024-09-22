%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%         50007.2 Introduction to Prolog    %
%                                           %
%         Coursework (Matching Fruits)      %
%                                           %
%         Assessed Coursework               %
%                                           %

%% ------------  (utilities) DO NOT EDIT

print_configurations([H],[]):-
	 !,
	 print_configuration(H),
	 nl.

print_configurations([H|T], [A|AS]) :-
    print_configuration(H),
    nl,
    write(A),
    nl,nl,
    print_configurations(T,AS).

print_configuration([]).
print_configuration([H|T]) :-
    write(H),
    nl,
    print_configuration(T).

% solutions for testing 

solution([[[b,g],[g,b]],[[g,b],[g,b]],[[g,b],[b,g]],[[b,b],[g,g]],[[e,e],[g,g]],[[e,e],[e,e]]]).
solution([[[b,g],[g,b]],[[g,b],[g,b]],[[g,b],[b,g]],[[b,b],[g,g]],[[b,b],[e,e]],[[e,e],[e,e]]]).
solution([[[b,g],[g,b]],[[g,b],[g,b]],[[g,b],[b,g]],[[g,g],[b,b]],[[e,e],[b,b]],[[e,e],[e,e]]]).

%% --------- END (utilities)


%% ------ Add your code to this file here.

/* Add code for Step 1 below this comment */
% same_length(+L1, +L2)
% same_length/2 checks that two given
% lists are of the same length
% Assumption: L1, L2 are always ground terms.

same_length([], []).
same_length([ _ | Tail1], [ _ | Tail2]) :- same_length(Tail1, Tail2).

/* Add code for Step 2.a below this comment  */
% invalid(+Board)
% invalid/1 holds when a given Board, represented as 
% a list of lists, is not a square board.
% Assumption Board is always ground

invalid(Board) :- invalidRows(Board, Board).

% A board is invalid if any of the rows has a different length
% than the dimension of the board.
invalidRows([Row | Tail], Board) :-
	( \+ same_length(Row, Board)
	; invalidRows(Tail, Board)
	).

/* Add code for Step 2.b below this comment */
% valid(+Board)
% valid/1  succeeds only if a given board is not invalid.

valid(Board) :- \+ invalid(Board).

% matching_row(+B)
% matching_row/1 checks that a given row 
% in the board, represented as a list,
% contains matching tiles only 

matching_row([]).
matching_row([X | Tail]) :- match_item(X, Tail).

% Helper function which checks if a given row contains all elements 
% equal to the given element.

match_item(X, [X]).
match_item(X, [X | Tail]) :- match_item(X, Tail).

/* Add code for Step 4 below this comment */
% empty_row(+B)
% empty_row/1 checks that a given row is empty, 
% i.e., contains only 'e' tiles 

empty_row(B) :- match_item(e, B).

/* Add code for Step 5 below this comment */
% empty_board(+B)
% empty_board/1 holds when a given board is  
% empty, i.e., contains only 'e' tiles 

empty_board([Row]) :- empty_row(Row).
empty_board([Row | Board]) :- 
	empty_row(Row), 
	empty_board(Board).

/* Add code for Step 6 below this comment */
% goal(+B)
% goal/1  succeeds when B is an empty board

goal(B) :- empty_board(B).

/* Add code for Step 7 below this comment */
% swap_row_tiles(+L1, -L2)
% swap_row_tiles/2 takes a list L1 
% returns a list in which two of L1's  
% adjacent tiles are swapped. 

swap_row_tiles([X, Y | Tail], [Y, X | Tail]) :- 
  X \= Y, 
  X \= e, 
  Y \= e.

swap_row_tiles([X | Tail1], [X | Tail2]) :- 
  swap_row_tiles(Tail1, Tail2).

/* Add code for Step 8 below this comment */
% switch_row(+B1, -B2)
% switch_row/2 takes a board B1 as input
% and returns a board in which 
% two adjacent tiles within a row in B1
% are swapped. 
% This should work for any number of rows

% Case 1: Two top rows are identical, we search
% for a switched row in the remainder of the board.

switch_row([Row | B1], [Row | B2]) :- 
  switch_row(B1, B2).

% Case 2: The two top rows are different and
% the second one results from swapping row tiles in the
% first one, then we terminate as we have found the 
% switched row and the remainders of the boards are identical.

switch_row([Row1 | Tail], [Row2 | Tail]) :-
  swap_row_tiles(Row1, Row2).

/* Add code for Step 9 below this comment */
% replace_row_tiles(+L1, +X, -L2)
% replace_row_tiles/3 replaces all
% tiles in L1 with X  in L2
% This should work for any number of tiles

replace_row_tiles([], _, []).
replace_row_tiles([ _ | L1], X, [X | L2]) :- 
	replace_row_tiles(L1, X, L2).

/* Add code for Step 10 below this comment */
% remove_row(+B1, -B2)
% remove_row/2 removes fruit tiles within a row 
% when all tiles in the row are matching 

remove_row([Row1 | Tail], [Row2 | Tail]) :- 
	matching_row(Row1),
	replace_row_tiles(Row1, e, Row2),
  \+ match_item(e, Row1).

remove_row([Row | B1], [Row | B2]) :-
	remove_row(B1, B2).

/* Add code for Step 11 below this comment */
% swap_columns_tiles(+L1, +L2, -NL1, -NL2)
% swap_columns_tiles/2 takes two lists L1 and L2 
% and lists NL1 and NL2 are obtained when a pair of  
% tiles from L1 and L2 at the same position 
% are swapped. 

swap_columns_tiles([X | L1], [Y | L2], [Y | L1], [X | L2]) :- 
	X \= Y, 
  X \= e, 
  Y \= e.

swap_columns_tiles([X | L1], [Y | L2], [X | NL1], [Y | NL2]) :- 
	swap_columns_tiles(L1, L2, NL1, NL2).

/* Add code for Step 12 below this comment */
% switch_column(+B1, -B2)
% switch_column/2 holds when a board B1 is given as input
% and B2 is the board obtained when 
% two adjacent tiles within a single column in B1
% are swapped. 
% This should work for any number of columns

% If the two current rows are identical and the 
% remaining parts of the two boards are different, 
% then we look for the switched column in the remainder
% of the board.

switch_column([Row | B1], [Row | B2]) :- 
	switch_column(B1, B2). 

% If the four currernt rows are different and satisfy
% swap_columns_tiles, and the remainders of the boards
% are identical then we have found our swapped tiles and
% can terminate.

switch_column([Row1, Row2 | Tail], [Row3, Row4 | Tail]) :- 
 swap_columns_tiles(Row1, Row2, Row3, Row4).


/* Add code for Step 13 below this comment */
% visited(+Board, +Sequence)
% visited/2 holds when a given state board 
% is equivalent to some member of a given Sequence

visited(Board, [Board | _ ]).
visited(Board, [_ | Tail]) :- 
	visited(Board, Tail ).

/* Add code for Step 14 below this comment  */
% move(+B1,M,-B2) 
% move/3 holds when M is a move (which is either the constant 
% remove, switch_row, switch_column representing one
% of the moves clear row, or switching tiles in 
% columns or rows) that can be made from B1. 
% B2 is the board obtained when that move is made.

move(B1, M, B2) :- remove_row(B1, B2), M = remove.
move(B1, M, B2) :- switch_column(B1, B2), M = switch_column.
move(B1, M, B2) :- switch_row(B1, B2), M = switch_row.

% initial(+Board)
% initial/1 holds B1 is a ground configuration 

initial([[b,g],[g,b]]).

/* Add code for Step 15 below this comment */
% succeeds(-Sequence)
%
% succeeds/1 holds for a sequence (a list of board configurations) 
% that starts with an initial valid board configuration and 
% terminates with the empty board, where each step is the result
% of a move and no configurations are repeated. 

/*  Uncomment the following if you wish to skip Step 15.   
     Else Add code for Step 15  below this comment */

/* 

succeeds(Sequence) :- solution(Sequence).

*/

succeeds(Sequence) :-
	initial(I_State),
	valid(I_State),
	plan(I_State, [], Actions, Sequence),
	print_configurations(Sequence, Actions).
 
% The recursive clause for plan/4 should look 
% for a possible move to some next configuration, 
% check that this configuration has not already 
% been visited, add it to the current list of visited 
% configuration, and continue until the 
% goal configuration (base case) is reached.

plan(State, History, [Action | Actions], [State, NewState | Sequence]) :-
	move(State, Action, NewState),
	\+ member(NewState, History),
	plan(NewState, [State | History], Actions, [NewState | Sequence]).

plan(State, _, _, _) :- goal(State).
