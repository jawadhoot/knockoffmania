# knockoffmania

Game Developed for #colotterygamejam using (https://godotengine.org/). It is a Betting Monitor Game, where players put their bets on the outcome of game, and the game plays by itself.

In this game there are 20 cars in an arena, each car tries to hit and eliminate other cars. The final 3 cars are on podium in the order of their eliminaton, the last car is on the first place on podium, the last car to eliminate is on the second place of podium, and the second last car to be eliminated is on the third place of the podium.

Players put ther bets by picking the cars they think will be on the podium, order of the pick if correct gives higher payout.

source code: (https://github.com/jawadhoot/knockoffmania)

## Payout:

__ALL_ON_PODIUM_IN_ORDER__ pays __100__:

  all 3 of the cars in the bet are on podium and the podium is in order of the pick, eg : your bet is (A,B,C) and podium is (A,B,C)

__ALL_ON_PODIUM__ pays __20__:

  all 3 of the cars in the bet are on podium, eg : your bet is (A,C,B) and podium is (A,B,C)

__TOP_2_ON_SPOT__ pays __10__:

  2 of the cars in the bet are on podium and are 1 and 2 in that order, eg : your bet is (A,B,D) and podium is (A,B,C)
  Note : your bet is (D,A,B) and podium is (A,B,C) does not qualify for this

__PICKED_TOP_2__ pays __5__:

  2 of the cars in the bet are on podium and are in Top 2 position, eg : your bet is (B,A,D) and podium is (A,B,C)

__2_ON_PODIUM__ pays __3__:

  2 of the cars in the bet are on podium, eg : your bet is (D,A,B) and podium is (A,B,C)

__PICKED_THE_WINNER__ pays __2__:

  1 of the car in the bet is on podium and is in first place, eg : your bet is (D,E,A) and podium is (A,B,C)

__1_ON_PODIUM__ pays __1__:

  1 of the car in the bet is on podium, eg : your bet is (D,E,B) and podium is (A,B,C)

__SORRY__ pays __0__:

  None of the car in the bet are on podium, eg : your bet is (D,E,F) and podium is (A,B,C)

## Simulate Probablities

| Name                   | Percent |
|------------------------|---------|
| ALL_ON_PODIUM_IN_ORDER | 0.02    |
| ALL_ON_PODIUM          | 0.07    |
| TOP_2_ON_SPOT          | 0.25    |
| PICKED_TOP_2           | 1.24    |
| 2_ON_PODIUM            | 2.99    |
| PICKED_THE_WINNER      | 11.92   |
| 1_ON_PODIUM            | 23.86   |
| SORRY                  | 59.65   |
| payout                 | 68.25   |
