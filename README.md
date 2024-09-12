## [Tower Defense Game](https://github.com/yourusername/TowerDefenseGame)

This project is an implementation of a **Tower Defense** game developed in **Scheme (R5RS)**. The game allows players to strategically place towers to defend against waves of enemies, featuring different types of towers and monsters, as well as dynamic game mechanics.

### Features:
- Strategic tower placement and upgrade system.
- Multiple enemy types with distinct behaviors.
- Several levels with increasing difficulty, each consisting of waves of enemies.
- Dynamic interactions between towers and enemies, including different attack types and effects.

### Technologies Used:
- **Scheme (R5RS)**: The entire game is implemented using the Scheme programming language, with a focus on functional programming principles.
- **ADT-based structure**: The game logic is organized into abstract data types (ADTs) for handling game objects such as towers, monsters, and levels.
- **Custom Graphics**: Simple custom tiles used for visualizing the game state.

### Key Files:
- **main.rkt**: The main entry point for the game, which loads all necessary modules and starts the game.
- **Spel-adt**: Contains the core game logic, including level progression, monster movement, and game state management.
- **Teken-adt**: Responsible for rendering the game elements on the screen, updating tower and monster positions, and managing visual layers.
- **Level-adt**: Handles the creation and management of levels and waves of enemies.
- **Tank-powerup-adt, Monster-adt, Toren-adt**: Define the behavior and characteristics of the tank power-ups, monsters, and towers respectively.

### Key Learning Outcomes:
- Gained proficiency in functional programming through the implementation of game logic using **Scheme (R5RS)**.
- Developed a structured approach to handling game states, events, and interactions using **abstract data types (ADTs)**.
- Enhanced understanding of Scheme's capabilities in managing game mechanics and visual updates in real time.
- Improved problem-solving skills by designing and implementing a game from scratch in a functional programming paradigm.

You can view the project on GitHub: [Tower Defense Game](https://github.com/yourusername/TowerDefenseGame)
