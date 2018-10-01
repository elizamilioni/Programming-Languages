#!/usr/bin/env python3
import math, itertools, sys, re

def sub(int1, int2):
    return int1 - int2
def sum(int1, int2):
    return int1 + int2

# Declare and initialize all the necessary lists.
team, teams, defeated_teams, winning_teams, round_winners, round_results = [], [], [], [], [], []

# Use the input file for reading the content.
with open(sys.argv[1], 'r') as fo:

    # Read the first line which is the number of list_of__total_teams.
    N = fo.readline()

    # Take the log and find the total rounds incl. finals.
    # Convert from string to integer.
    rounds = int(math.log(float(N), 2))
    defeated_teams.append([])
    winning_teams.append ([])

    for i in range(0, rounds + 2, 1):
        defeated_teams.append([])
        winning_teams.append([])
    for i in range(0, rounds + 1, 1):
        round_results.append([])

    # Create list of lists (each line a sublist).
    for line in fo:
        line = re.split("[ |'\n']", line.rstrip())
        team.clear()
        team.append((line.pop(0)))
        for i in line:
            team.append(int(i))
        teams.append((list(team)))
# eof

# For each round separate winning teams from defeated ones.
# If p(i) = 1, defeated else winner.
def separate_winners_defeated(teams, round):
    for team in teams:
        if team[1] != 1:
            winning_teams[round].append(team)
        else:
            defeated_teams[round].append(team)


# Compare and combine winners and defeated for a specific round.
# https://docs.python.org/3/library/itertools.html
def compare_and_combine(winning_teams, defeated_teams, round):
    for winner in itertools.permutations(winning_teams[round], len(defeated_teams[round])):
        begin_matching(list(zip(winner, defeated_teams[round])), round)

def begin_matching(combination, round):
    # Each round's results define the winning teams and the defeated ones for the next round.
    round_results[round], winning_teams[round + 1], defeated_teams[round + 1] = [], [], []
    for index in combination:
        # In each combination, first index is for winner and second for the defeated.
        winner = index[0]
        loser  = index[1]
        # Reduce the winner's given goals by the number of the defeated's taken goals.
        winner_pi_matches = sub(winner[1], 1)
        # Reduce the winner's taken goals of the winner by the number of the defeated's taken goals.
        winner_ai_goals = sub(winner[2], loser[3])
        # Reduce by 1 the playing matches of the winner.
        winner_bi_goals = sub(winner[3], loser[2])
        # Check if the logical requirements are fulfilled.
        if winner_ai_goals >= 0 and winner_bi_goals >= 0 and loser[3] != 0:
            round_winners.append([winner[0], winner_pi_matches, winner_ai_goals, winner_bi_goals])
            round_results[round].append([winner[0], loser[0], loser[3], loser[2]])
        else:
            # If not, clear the results, break the loop, go back and start over.
            round_winners.clear()
            break

    # 2 remaining means finals. MUST Winner(ai) = Defeated(bi) && Defeated(ai) = Defeated(bi)
    if len(round_winners) == 2:
            winner = round_winners[0]
            loser = round_winners[1]
            round_winners.clear()
            if winner[2] == loser[3] and winner[3] == loser[2] and winner[2] != 0:
                if winner[2] < winner[3]:
                    temp = winner
                    winner = loser
                    loser = temp
                winning_teams[round + 1] = winner
                defeated_teams[round + 1] = loser
                round_results[round + 1].append([winner[0], loser[0], loser[3], loser[2]])
                print_scores(round_results)
                exit()
    # If there are more than 2, repeat the whole process till finals.
    if len(round_winners) > 2:
        round += 1
        separate_winners_defeated(round_winners, round)
        compare_and_combine(winning_teams, defeated_teams, round)

def print_scores(scores):
    del scores[0]
    for round in scores:
        for score in round:
            print(score[0], "-", score[1], " ", score[2], "-", score[3], sep = '')

separate_winners_defeated(teams, 1)
compare_and_combine(winning_teams, defeated_teams, 1)  
