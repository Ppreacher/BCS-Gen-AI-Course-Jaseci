import random;:
import from byllm.llm { Model }

glob llm = Model(
    model_name="groq/llama-3.1-8b-instant",
    verbose=False
);

"""Generate smart response to player's move"""
def generate_response(player_choice: str, computer_choice: str) -> str by llm();

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

with entry:__main__ {
    root spawn RPSGame();
}

impl RPSGame.start {
    player_choice = input("Enter rock, paper, or scissors: ");
    self.player_choice = player_choice.lower();

    if not [root --> (`?round)] {
        next = root ++> round(computer_choice=random.choice(["rock", "paper", "scissors"]));
    } else {
        next = [root --> (`?round)];
    }
    visit next;
}

impl RPSGame.play_round {
    self.computer_choice = here.computer_choice;

    print(f"Player chooses: {self.player_choice}");
    print(f"Computer chooses: {self.computer_choice}");

    if self.player_choice == self.computer_choice {
        self.result = "It's a tie!";
    } elif (self.player_choice == "rock" and self.computer_choice == "scissors") or
         (self.player_choice == "scissors" and self.computer_choice == "paper") or
         (self.player_choice == "paper" and self.computer_choice == "rock") {
        self.result = "Player wins!";
    } else {
        self.result = "Computer wins!";
    }

    # Use AI model to generate a smart response
    smart_response = generate_response(self.player_choice, self.computer_choice);
    print(smart_response);

    disengage;
}
