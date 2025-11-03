"""Rock Paper Scissors Game with User Input"""

import random;

walker RPSGame {
    has player_choice: str = "";
    has computer_choice: str = "";
    has result: str = "";

    can start with `root entry;
    can play_round with round entry;
}

node round {
    has computer_choice: str = "rock";
}

# Run the game by spawning one walker that accepts user input
with entry:__main__ {
    root spawn RPSGame();
}

impl RPSGame.start {
    player_choice = input("Enter rock, paper, or scissors: ");
    self.player_choice = player_choice.lower();

    # Spawn or get existing round node with random computer choice
    if not [root --> (`?round)] {
        next = root ++> round(computer_choice=random.choice(["rock", "paper", "scissors"]));
    } else {
        next = [root --> (`?round)];
    }
    visit next;
}

impl RPSGame.play_round {
    self.computer_choice = here.computer_choice;
    player = self.player_choice;
    computer = self.computer_choice;

    print(f"Player chooses: {player}");
    print(f"Computer chooses: {computer}");

    if player == computer {
        self.result = "It's a tie!";
    } elif (player == "rock" and computer == "scissors") or
         (player == "scissors" and computer == "paper") or
         (player == "paper" and computer == "rock") {
        self.result = "Player wins!";
    } else {
        self.result = "Computer wins!";
    }

    print(self.result);
    disengage;
}