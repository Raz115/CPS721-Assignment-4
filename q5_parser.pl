% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: 
%%%%% NAME:
%%%%% NAME:
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

np2([Adj | Rest], What) :- adjective(Adj, What), np2(Rest, What).
np2([Noun | Rest], What) :- common_noun(Noun, What), mods(Rest, What).

/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, What) :-
	append(Start, End, Words),
	prepPhrase(Start, What), mods(End, What).

prepPhrase([Prep | Rest], What) :-
	preposition(Prep, What, Ref), np(Rest, Ref).