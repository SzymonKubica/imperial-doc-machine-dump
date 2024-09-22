write('Question 1 - same_length(L1, L2)\n'),
  same_length([],		 []).
\+same_length([1],		 []).
\+same_length([],		 [1]).
  same_length([1],		 [3]).
  same_length([1, 2],	 [3, 4]).
\+same_length([1, 2, 7], [3, 4]).

write('Question 2 - invalid(B) and valid(B)\n'),
\+invalid([]).
\+invalid([[1]]).
  invalid([[1, 2], [2, 1, 3]]).
\+invalid([[1, 2, 3], [2, 1, 3], [1, 2, 4]]).

  valid([]).
  valid([[1]]).
\+valid([[1, 2], [2, 1, 3]]).
  valid([[1, 2, 3], [2, 1, 3], [1, 2, 4]]).

write('Question 3 - matching_row(R)\n'), 
  matching_row([]).
  matching_row([b]).
  matching_row([b, b]).
\+matching_row([e, b]).
\+matching_row([b, e]).
  matching_row([e, e]).
  matching_row([b, b, b]).
\+matching_row([b, b, e]).
\+matching_row([e, b, e]).
\+matching_row([e, b, b]).

write('Question 4 - empty_row(R)\n'),
  empty_row([e, e, e, e, e]).
  empty_row([]).
\+empty_row([e, e, e, d, e]).
\+empty_row([d]).
  empty_row([e]).

write('Question 5 - empty_board(B)\n'),
  empty_board([]).
  empty_board([[e]]).
\+empty_board([[b]]).
  empty_board([[e, e], [e, e]]).
\+empty_board([[b, e], [e, e]]).
\+empty_board([[e, b], [e, e]]).
\+empty_board([[e, e], [b, e]]).
\+empty_board([[e, e], [e, b]]).
\+empty_board([[b, b], [b, b]]).

write('Question 6 - goal(B)\n'). 

write('Question 7 - swap_row_tiles(R, NR)\n'),
\+swap_row_tiles([],		[]).
\+swap_row_tiles([g],		[r]).
  swap_row_tiles([r, g],	[g, r]).
\+swap_row_tiles([r, g, b], [b, g, r]).
  swap_row_tiles([r, g, b], [r, b, g]).
\+swap_row_tiles([g, g],	[g, g]).
\+swap_row_tiles([e, e], 	[e, e]).
\+swap_row_tiles([b, e], 	[e, b]).

write('Question 8 - switch_row(B1, B2)\n'),
  switch_row([[r, g],	 [g, r]],	 [[g, r],	 [g, r]]).
\+switch_row([[r, g], 	 [g, r]], 	 [[r, g], 	 [g, r]]).
\+switch_row([[r, g], 	 [g, r]], 	 [[g, r], 	 [r, g]]).
  switch_row([[r, g, b], [r, g, b]], [[g, r, b], [r, g, b]]).
  switch_row([[g, r, b], [r, g, b]], [[g, b, r], [r, g, b]]).

write('Question 9 - replace_row_tiles(R, X, NR)\n'),
  replace_row_tiles([],		c, []).
  replace_row_tiles([r],	c, [c]).
\+replace_row_tiles([r], 	c, [r]).
  replace_row_tiles([r, r], c, [c, c]).
\+replace_row_tiles([r, r], c, [r, r]).
\+replace_row_tiles([r, r], c, [r, c]).
\+replace_row_tiles([r, r], c, []).

write('Question 10 - remove_row(B1, B2)\n'),
\+remove_row([],			 []).
\+remove_row([[b]],			 [[b]]).
\+remove_row([[e]],			 [[e]]).
  remove_row([[b]], 		 [[e]]).
  remove_row([[r,r], [b,b]], [[e,e], [b,b]]).
  remove_row([[r,r], [b,b]], [[r,r], [e,e]]).
  remove_row([[e,e], [b,b]], [[e,e], [e,e]]).
\+remove_row([[r,e], [g,e]], [[e,e], [e,e]]).
\+remove_row([[e,e], [e,e]], [[e,e], [e,e]]).

write('Question 11 - swap_columns_tiles(L1, L2, NL1, NL2)\n'),
\+swap_columns_tiles([],	 [],	 [],	 []).
\+swap_columns_tiles([a],	 [b],	 [a],	 [b]).
  swap_columns_tiles([a], 	 [b], 	 [b], 	 [a]).
\+swap_columns_tiles([o, b], [p, r], [o, b], [p, r]).
  swap_columns_tiles([o, b], [p, r], [p, b], [o, r]).
  swap_columns_tiles([o, b], [p, r], [o, r], [p, b]).
\+swap_columns_tiles([o, e], [p, r], [o, r], [p, e]).
\+swap_columns_tiles([g, g], [e, e], [e, g], [e, g]).
\+swap_columns_tiles([g, g], [e, e], [e, g], [g, e]).

write('Question 12 - switch_column(B1, B2)\n'), 
\+switch_column([],								   []).
\+switch_column([[a]],							   [[a]]).
\+switch_column([[o, b],	[p, r]],			   [[o, b],	   [p, r]]).
  switch_column([[o, b], 	[p, r]], 			   [[p, b],    [o, r]]).
  switch_column([[o, b], 	[p, r]], 			   [[o, r],    [p, b]]).
\+switch_column([[a, b, c], [d, e, f], [g, h, i]], [[a, b, c], [d, e, f], [g, h, i]]).
  switch_column([[a, b, c], [d, e, f], [g, h, i]], [[d, b, c], [a, e, f], [g, h, i]]).
  switch_column([[d, b, c], [a, e, f], [g, h, i]], [[d, b, c], [g, e, f], [a, h, i]]).
  switch_column([[g, b],	[b, g]],			   [[b, b],	   [g, g]]).
\+switch_column([[e, b],	[b, g]],			   [[b, b],	   [e, g]]).
\+switch_column([[g, g], 	[e, e]], 			   [[e, g], [g, e]]).

write('Question 13 - visited(C, H)\n'),
\+visited([],				[]).
\+visited([1],				[]).
\+visited([[1, 2], [3, 4]], []).
  visited([],				[[]]).
  visited([[1]],			[[[1]]]).
  visited([[1, 2], [3, 4]], [[[1, 2], [3, 4]], [[3, 1], [1, 4]]]).
\+visited([[2, 1], [3, 4]], [[[1, 2], [3, 4]], [[3, 1], [1, 4]]]).

write('Question 14 - move(B, M, NB)\n'),
\+move([],			   remove, []).
\+move([[b]],		   remove, [[b]]).
\+move([[e]], 		   remove, [[e]]).
  move([[b]], 		   remove, [[e]]).
  move([[r,r], [b,b]], remove, [[e,e], [b,b]]).
  move([[r,r], [b,b]], remove, [[r,r], [e,e]]).
  move([[e,e], [b,b]], remove, [[e,e], [e,e]]).
\+move([[r,e], [g,e]], remove, [[e,e], [e,e]]).
\+move([[e,e], [e,e]], remove, [[e,e], [e,e]]).

  move([[r, g],	   [g, r]],	   switch_row, [[g, r],    [g, r]]).
\+move([[r, g],    [g, r]],    switch_row, [[r, g],    [g, r]]).
\+move([[r, g],    [g, r]],    switch_row, [[g, r],    [r, g]]).
  move([[r, g, b], [r, g, b]], switch_row, [[g, r, b], [r, g, b]]).
  move([[g, r, b], [r, g, b]], switch_row, [[g, b, r], [r, g, b]]).

\+move([],								  switch_column, []).
\+move([[a]],							  switch_column, [[a]]).
\+move([[o, b],	   [p, r]],				  switch_column, [[o, b],    [p, r]]).
  move([[o, b],    [p, r]], 			  switch_column, [[p, b],    [o, r]]).
  move([[o, b],    [p, r]], 			  switch_column, [[o, r],    [p, b]]).
\+move([[a, b, c], [d, e, f], [g, h, i]], switch_column, [[a, b, c], [d, e, f], [g, h, i]]).
  move([[a, b, c], [d, e, f], [g, h, i]], switch_column, [[d, b, c], [a, e, f], [g, h, i]]).
  move([[d, b, c], [a, e, f], [g, h, i]], switch_column, [[d, b, c], [g, e, f], [a, h, i]]).

write('Question 15 - succeeds(Sequence)\n'). 
succeeds(Sequence).
