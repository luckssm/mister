# Vision

## The problem

Football manager games are either **simple but disconnected**, where your
choices barely show up in results, or **connected but opaque and heavy**,
where choices matter but it takes hours to learn why, and you often can't
tell what caused a result.

## Elevator pitch

**For** casual football fans **who** want to manage a team without studying
a game, **Mister** is a football manager game **that** turns a few clear
decisions into match results you can see and understand. **Unlike**
Brasfoot, where choices barely show up in results, or Football Manager,
which takes hours to learn, **Mister** makes every tactic's effect visible
in the match report.

## Audience

Casual football fans who want to spend time with football without investing
in learning a complex game. First user: the author (dogfooding). When in
doubt, the casual fan is the tiebreaker.

## Pillars

1. **Legible:** the player can see and understand why things happened.
2. **Consequential:** each decision measurably changes the match.
3. **Simple:** few decisions, no manual needed.

When pillars conflict, legibility wins. A new factor (morale, weather...)
only enters the game once we know how the súmula explains it.

## The box (ranked)

> **Mister**: you make the calls, the match tells you why.
>
> 1. **Every match explains itself.** A súmula after each game shows why you won or lost.
> 2. **Your decisions change the match.** Tactics and lineups have effects you can see.
> 3. **It plays like real football.** Scores, stats and upsets that feel right.

## North-star success criterion

After any match, the player can explain in one sentence why they won or
lost.

## Design rules

- No feature that needs a manual to understand.
- The engine simulates fast; matches play back event by event at a speed the
  player chooses, so they can follow along and step in. The decisions are
  what take thought.
- Every tactical effect we promise is verified by a test.
