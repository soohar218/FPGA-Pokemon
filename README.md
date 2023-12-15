# FPGA Pokemon Simulator

## How to Play

The user can interact with the keyboard to start the game by pressing any keys approximately 5 seconds after the screen loads.

Player movement is controlled by up, down, right, and left keys on the connected USB keyboard. A random pokemon shows up in each map for the user to interact with. Once the player encounters the pokemon, the player can choose to either try to catch the pokemon by pressing the 'c' key or run by pressing the 'r' key. When the player attempts to catch the pokemon, the pokemon may be caught with a 2/3 probability. 

There are two maps the player can explore. Player can teleport to each of the maps by following the paths. Each map has a boundary in which the player cannot move to. There are two conditions wherein the game ends: (1) if the player moves out of the screen to the right on the second map, or (2) once the player caught three pokemons. The number of pokemons caught is shown on the Urbana board hex display (left-most LED). The two right-most LEDs display keycodes the user is pressing. To speed up the whole game process, the player can press the number '2' key. The number '1' key can be pressed to simply go back to normal speed.

There is an easter egg in the game: to honor the course ECE 385, if the player presses keys '3', '8', and '5', the player can catch a pokemon without fail. ;)
