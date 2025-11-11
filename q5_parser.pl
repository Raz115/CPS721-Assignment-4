% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: Raza Hussain Mirza
%%%%% NAME: Alvin Chan
%%%%% NAME: Amitoz Banga
%
% This file contains the parser that you should edit for Q5.
% The code below is the same as in original_parser.pl
%
% Ensure your lexicon works with just the parser in original_parser.pl.
% Further, ensure all your edits are in the augmented_parser section
% If you put the rules anywhere else, you will lose marks.
%
% You may add additional comments as you choose but DO NOT MODIFY the comment lines below
%

%%%%% SECTION: augmented_parser
%%%%% Edit the following files for the functionality needed in q5
%%%%% Any helpers needed for editing the parser should also be included below.

/* Noun phrase can be a proper name or can start with an article */

np([Name], Name) :- proper_noun(Name).
np([Art | Rest], What) :- article(Art), np2(Rest, What).


/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

% Handle "oldest" adjective - must be first in sequence
% Generate candidates matching ALL constraints, then filter for oldest among them
np2([oldest | Rest], What) :- 
    np2(Rest, What),
    releaseInfo(What, Year, _),
    not((np2(Rest, OtherMovie),
         not(What = OtherMovie),
         releaseInfo(OtherMovie, OtherYear, _),
         OtherYear < Year)).

np2([Adj | Rest], What) :- adjective(Adj, What), np2(Rest, What).
np2([Noun | Rest], What) :- common_noun(Noun, What), mods(Rest, What).

/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, What) :-
	append(Start, End, Words),
	prepPhrase(Start, What), 
	mods(End, What).

% Handle "between X and Y" prepositional phrase
% Pattern: "with a <property> between <lower> and <upper>"
prepPhrase([with, Art, Property, between | Rest], Movie) :-
    article(Art),
    split_at_and(Rest, LowerWords, UpperWords),
    np(LowerWords, LowerBound),
    np(UpperWords, UpperBound),
    property_of_movie(Property, Movie, PropertyValue),
    between_constraint(PropertyValue, LowerBound, UpperBound).

% Original prepositional phrase rule
prepPhrase([Prep | Rest], What) :-
	preposition(Prep, What, Ref), 
	np(Rest, Ref).


% Helper to split list at 'and' - only finds the FIRST occurrence
split_at_and([and | Rest], [], Rest).
split_at_and([Word | Rest], [Word | Before], After) :-
    not(Word = and),
    split_at_and(Rest, Before, After).


% Helper: Connect property to movie
property_of_movie(release_year, Movie, Year) :- releaseInfo(Movie, Year, _).
property_of_movie(length, Movie, Length) :- releaseInfo(Movie, _, Length).
property_of_movie(running_time, Movie, Length) :- releaseInfo(Movie, _, Length).


% Helper predicate for "oldest" adjective - works like other adjectives
% Generates movies that are the oldest overall
adjective_oldest(Movie) :-
    releaseInfo(Movie, Year, _),
    not((releaseInfo(OtherMovie, OtherYear, _),
         not(Movie = OtherMovie),
         OtherYear < Year)).


% Helper predicate for "between" constraint
between_constraint(Value, Lower, Upper) :-
    number(Value),
    number(Lower),
    number(Upper),
    Value > Lower,
    Value < Upper.

between_constraint(Value, LowerMovie, Upper) :-
    number(Value),
    movie(LowerMovie),
    releaseInfo(LowerMovie, _, LowerLength),
    number(Upper),
    Value > LowerLength,
    Value < Upper.

between_constraint(Value, Lower, UpperMovie) :-
    number(Value),
    number(Lower),
    movie(UpperMovie),
    releaseInfo(UpperMovie, _, UpperLength),
    Value > Lower,
    Value < UpperLength.

between_constraint(Value, LowerMovie, UpperMovie) :-
    number(Value),
    movie(LowerMovie),
    movie(UpperMovie),
    releaseInfo(LowerMovie, _, LowerLength),
    releaseInfo(UpperMovie, _, UpperLength),
    Value > LowerLength,
    Value < UpperLength.