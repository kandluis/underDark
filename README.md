# Tyrants of the Underdark - Digital Adaptation

This project is a digital implementation of the deck-building and area-control board game, "Tyrants of the Underdark," built using the Godot Engine (v4.x). It serves as a functional prototype with the core gameplay mechanics fully implemented.

## Current Status

The game is in a playable prototype state. The main gameplay loop is complete, supporting multiple players from a dynamic setup menu through to a final victory condition.

## Features

- **Dynamic Game Setup:** Start the game from a menu where you can select the number of players (2-4) and customize their names.
- **Core Gameplay Loop:**
  - **Play Cards:** Click cards in your hand to play them, generating Influence and Power.
  - **Buy from Market:** Click cards in the Market to spend Influence and acquire new cards for your deck.
  - **Deploy Troops:** Click on sites on the game board to spend Power and deploy troops.
- **Turn-Based Multiplayer:** The game manages a turn-based flow for all players, automatically switching context and UI at the end of each turn.
- **Live UI Updates:** The UI is driven by Godot's signal system, providing real-time feedback for:
  - Player hand changes.
  - Market updates.
  - Player resource (Influence/Power) gains, with visual feedback.
  - Troop counts and control status on game board sites.
- **Victory Conditions:** The game automatically ends when the Market deck is depleted. Final scores are calculated based on Victory Points from each player's deck and control of sites on the board.

## How to Run

1.  **Clone the repository:**
    ```bash
    git clone git@github.com:kandluis/underDark.git
    cd underDark
    ```
2.  **Download Godot:** If you don't have it, [download the Godot Engine](https://godotengine.org/download/) (version 4.2 or newer).
3.  **Import the Project:**
    - Launch the Godot editor.
    - In the Project Manager, click the **Import** button.
    - Navigate to the cloned `underDark` directory and select the `project.godot` file.
4.  **Run the Game:**
    - Once the project is open, press the **Play** button (or F5) in the top-right corner of the editor.

## Project Structure

The project is organized to separate logic, scenes, and assets:

- `scenes/`: Contains all Godot scene files (`.tscn`).
  - `ui/`: Reusable UI components like `Card.tscn`, `Site.tscn`, etc.
  - `Main.tscn`: The main game scene.
  - `Menu.tscn`: The initial game setup menu.
- `scripts/`: Contains all GDScript files (`.gd`).
  - `data/`: Data-centric classes like `CardData.gd` and `SiteData.gd`.
  - `ui/`: Scripts that control visual UI components.
  - `singletons/`: Global scripts like `GameSettings.gd`.
  - `Main.gd`, `Player.gd`, `Market.gd`: Core logic scripts.
- `assets/`: Contains all non-code resources.
  - `art/`: Placeholder images and icons (`.svg`).
  - `cards/`: Card data resources (`.tres`).
  - `sites/`: Site data resources (`.tres`).
  - `theme/`: UI theme resources like styles and fonts (`.tres`).

## Architecture Overview

The project uses a signal-driven architecture to decouple game logic from the user interface.

- **Logic Nodes** (`Player.gd`, `Market.gd`) manage the game state and emit signals when that state changes (e.g., `hand_changed`, `stats_changed`).
- **UI Scenes** (`HandUI.gd`, `PlayerStatsUI.gd`) are responsible for visuals. They listen for signals from the logic nodes and update their display accordingly, without needing to know the underlying game rules.
- **`Main.gd`** acts as the central Game Manager, responsible for setting up the game, connecting the logic and UI nodes, and managing the overall turn flow.
- **`GameSettings.gd`** is a globally accessible singleton used to pass data (like player names) from the menu scene to the main game scene.

## Future Development

- **Implement Special Card Actions:** Add the logic for unique card abilities like "promote a card," "assassinate a troop," etc.
- **Add Player Colors:** Assign a unique color to each player for their troops and UI elements to improve board readability.
- **Improve UI/UX:** Enhance the user experience with animations for card drawing/discarding, sound effects, and more intuitive visual feedback.
- **Expand Content:** Add the full set of market cards and all game board sites from the original board game.
- **Implement Card Promotion:** Add the "Inner Circle" mechanic and the ability to promote cards to remove them from your deck.
