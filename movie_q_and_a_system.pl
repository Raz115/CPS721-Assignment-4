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

movie(Name) :- releaseInfo(Name, _, _).
movie(Name) :- directedBy(Name, _).
movie(Name) :- actedIn(_, Name, _).
movie(Name) :- movieGenre(Name, _).

actor(X) :- actedIn(X, _, _).
director(X) :- directedBy(_, X).
character(X) :- actedIn(_, _, X).
genre(X) :- movieGenre(_, X).
releaseYear(X) :- releaseInfo(_, X, _).

movieLength(X) :- releaseInfo(_, _, X).
movieLength(X, L) :- releaseInfo(X, _, L).

newDirector(Name) :-
   currentYear(CurrYear), 
   directedBy(Movie, Name),        
   releaseInfo(Movie, CurrYear, _),      
   not((directedBy(OldMovie, Name),       
        releaseInfo(OldMovie, OldYear, _),
        OldYear < CurrYear)).

newActor(Name) :-
   currentYear(CurrYear),
   actedIn(Name, Movie, _),
   releaseInfo(Movie, CurrYear, _),
   not(( actedIn(Name, OldMovie, _),
         releaseInfo(OldMovie, OldYear, _),
         OldYear < CurrYear)).

genreDirector(Name, Genre) :-
    directedBy(Movie1, Name),
    directedBy(Movie2, Name),
    not(Movie1 = Movie2),
    movieGenre(Movie1, Genre),
    movieGenre(Movie2, Genre).

genreActor(Name, Genre) :-
    actedIn(Name, Movie1, _),
    actedIn(Name, Movie2, _),
    not(Movie1 = Movie2),
    movieGenre(Movie1, Genre),
    movieGenre(Movie2, Genre).

% lexicon
article(a).
article(an).
article(the).
article(any).

common_noun(movie, X) :- movie(X).
common_noun(film, X)  :- movie(X).
common_noun(actor, X) :- actor(X).
common_noun(director, X) :- director(X).
common_noun(character, X) :- character(X).
common_noun(length, X) :- movieLength(X).
common_noun(running_time, X) :- movieLength(X).
common_noun(genre, X) :- genre(X).
common_noun(release_year, X) :- releaseYear(X).


adjective(three_hour, X) :- 
   movie(X), 
   movieLength(X, L), 
   L >= 180.
adjective(short, X) :- 
   movie(X), 
   movieLength(X, L), 
   L < 60.


adjective(new, X) :- 
   movie(X), 
   releaseInfo(X, Year, _), 
   currentYear(Year).
adjective(new, X) :-
   actor(X),
   newActor(X).
adjective(new, X) :- 
   director(X), 
   newDirector(X).

adjective(Genre, X) :- 
   movie(X), 
   movieGenre(X, Genre).
adjective(Genre, X) :- 
   actor(X), 
   genreActor(X, Genre).
adjective(Genre, X) :- 
   director(X), 
   genreDirector(X, Genre).

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

preposition(by, X, Y) :- directedBy(X, Y).
preposition(with, X, Y) :- actedIn(Y, X, _).
preposition(with, X, Y) :- actedIn(_, X, Y).
preposition(in, X, Y) :- actedIn(X, Y, _).
preposition(in, X, Y) :- actedIn(_, Y, X).
preposition(from, X, Y) :- releaseInfo(X, Y, _).
preposition(released_in, X, Y) :- releaseInfo(X, Y, _).
preposition(played_by, X, Y) :- actedIn(Y, _, X).

preposition(of, length, Y) :-
   movie(Y).

preposition(of, running_time, Y) :-
   movie(Y).

preposition(of, release_year, Y) :-
   movie(Y).

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
   



