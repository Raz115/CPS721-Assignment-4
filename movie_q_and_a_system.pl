% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: 
%%%%% NAME:
%%%%% NAME:
%
% Add the required rules in the corresponding sections. 
% If you put the rules in the wrong sections, you will lose marks.
%
% You may add additional comments as you choose but DO NOT MODIFY the comment lines below
%

%%%%% SECTION: current_year
%%%%% This section defined the current year
%%%%% You can edit it if you want to test your code with different current years
%%%%% However, our autograder will ignore everything in this section

currentYear(2025).


%%%%% SECTION: kb_import
%%%%% This section simply imports the movie KB file.
%%%%% You may edit it to toggle between different KBs for testing.
%%%%% However, our autograder will ignore everything in this section

:- [movie_kb].



%%%%% SECTION: lexicon_and_helpers
%%%%% Put the rules/statements defining articles, adjectives, proper nouns, common nouns,
%%%%% and prepositions in this section.
%%%%% You should also put your the helpers described in q2 in this part.
%%%%% You may introduce other helpers for defining your lexicon as you see fit.
%%%%% DO NOT INCLUDE ANY KB atomic statements in this section. 
%%%%% Those should appear in movie_kb.pl



%%%%% SECTION: parser_import
%%%%% This section imports the parser. By default, it imports the 
%%%%% original parser. To test your edited parser, comment out the first
%%%%% line and uncomment the second. Your code should work when only one
%%%%% of these is uncommented at any time, as our autograder will only
%%%%% import the original parser or q5_parser depended on which part of
%%%%% the assignment is being graded.

:- [original_parser].
%:- [q5_parser]



%%%%% SECTION: define_what
%%%%% This section defines the "what" predicate used for interacting with
%%%%% your program. It includes a convenient form of the "what" predicate
%%%%% that takes in a string instead of a list of words as atoms

% The usual "what" call, but ensures a list is provided
what(Words, Ref) :- is_list(Words), np(Words, Ref).


% Allows for queries like 'what("the steven_spielberg movie from 2022", X)'
% Simply tokenizes the strong, converts the strings to atoms, and calls what
% on the list of atoms.
what(WordsString, Ref) :- string(WordsString),
   atom_list_from_string(WordsString, Words), what(Words, Ref).

% Convers a list of strings to a list of atoms
strings_to_atoms([], []).
strings_to_atoms([String | RestStrings], [Atom | RestAtoms]) :-
   atom_string(Atom, String), strings_to_atoms(RestStrings, RestAtoms).

% Takes in a string where words are separated by spaces, and finds a list
% of atoms corresponding to that string.
% ie. " hello    world how are  you   " becomes [hello, world, how, are, you]
atom_list_from_string(WordsString, AtomList) :-
   split_string(WordsString, " ", " ", WordList), strings_to_atoms(WordList, AtomList).
   



