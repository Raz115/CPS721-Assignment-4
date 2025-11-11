% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: Raza Hussain Mirza
%%%%% NAME: Alvin Chan
%%%%% NAME: Amitoz Banga
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

movie(M) :- releaseInfo(M, _, _).
movie(M) :- directedBy(M, _).
movie(M) :- actedIn(_, M, _).
movie(M) :- movieGenre(M, _).

actor(A) :- actedIn(A, M, C).
director(D) :- directedBy(M, D).
character(C) :- actedIn(A, M, C).
genre(G) :- movieGenre(M, G).
releaseYear(Y) :- releaseInfo(M, Y, L).

movieLength(M) :- releaseInfo(M, Y, L).

newDirector(Name) :-
    currentYear(Y),
    directedBy(M, Name),
    releaseInfo(M, Y, _),
    not((directedBy(M1, Name),
         releaseInfo(M1, Y1, _),
         Y1 < Y)).

newActor(Name) :-
    currentYear(Y),
    actedIn(Name, M, _),
    releaseInfo(M, Y, _),
    not((actedIn(Name, M1, _),
         releaseInfo(M1, Y1, _),
         Y1 < Y)).

genreDirector(Name, Genre) :-
    directedBy(M1, Name),
    directedBy(M2, Name),
    not(M1 = M2),
    movieGenre(M1, Genre),
    movieGenre(M2, Genre).

genreActor(Name, Genre) :-
    actedIn(Name, M1, _),
    actedIn(Name, M2, _),
    not(M1 = M2),
    movieGenre(M1, Genre),
    movieGenre(M2, Genre).

% Task 3

article(a).
article(an).
article(the).
article(any).

common_noun(movie, X) :- movie(X).   
common_noun(film, X) :- movie(X).    
common_noun(actor, X) :- actor(X).
common_noun(director, X) :- director(X).
common_noun(character, X) :- character(X).
common_noun(length, L) :- releaseInfo(_, _, L).
common_noun(running_time, L) :- releaseInfo(_, _, L).
common_noun(genre, G) :- movieGenre(_, G).
common_noun(release_year, Y) :- releaseInfo(_, Y, _).

adjective(three_hour, M) :-
    movie(M),
    releaseInfo(M, _, L),
    L >= 180.

adjective(short, M) :-
    movie(M),
    releaseInfo(M, _, L),
    L < 60.

adjective(new, M) :-
    movie(M),
    releaseInfo(M, Y, _),
    currentYear(Y).
adjective(new, A) :-
    actor(A),
    newActor(A).
adjective(new, D) :-
    director(D),
    newDirector(D).

adjective(Genre, M) :-
    movie(M),
    movieGenre(M, Genre).

adjective(Genre, Name) :-
    actor(Name),
    genreActor(Name, Genre).
adjective(Genre, Name) :-
    director(Name),
    genreDirector(Name, Genre).

adjective(Name, X) :-
    movie(X),
    directedBy(X, Name).
adjective(Name, X) :-
    movie(X),
    actedIn(Name, X, _).

proper_noun(X) :- movie(X).
proper_noun(X) :- actor(X).
proper_noun(X) :- director(X).
proper_noun(X) :- character(X).
proper_noun(X) :- number(X).

preposition(by, M, D) :- directedBy(M, D).

preposition(with, M, A) :- actedIn(A, M, _).
preposition(with, M, C) :- actedIn(_, M, C).

preposition(in, A, M) :- actedIn(A, M, _).
preposition(in, C, M) :- actedIn(_, M, C).

preposition(from, M, Y) :- releaseInfo(M, Y, _).

preposition(released_in, M, Y) :- releaseInfo(M, Y, _).

preposition(played_by, C, A) :- actedIn(A, _, C).


preposition(of, Y, M) :- movie(M), releaseInfo(M, Y, _).
preposition(of, L, M) :- movie(M), releaseInfo(M, _, L).
preposition(of, G, M) :- movie(M), movieGenre(M, G).


%%%%% SECTION: parser_import
%%%%% This section imports the parser. By default, it imports the 
%%%%% original parser. To test your edited parser, comment out the first
%%%%% line and uncomment the second. Your code should work when only one
%%%%% of these is uncommented at any time, as our autograder will only
%%%%% import the original parser or q5_parser depended on which part of
%%%%% the assignment is being graded.

%:- [original_parser].
:- [q5_parser].



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
   



