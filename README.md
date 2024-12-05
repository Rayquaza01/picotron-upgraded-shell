# picotron-upgraded-shell
PUSH

PUSH is a modified version of the default Picotron terminal. PUSH stands for **P**icotron **U**pgraded **SH**ell (mainly because I wanted to give it a cool name lol)

## How Modified?

* PUSH can load custom modules to do things such as add commands, shortcuts, and change appearance.
* PUSH changes the way builtin commands are handled, allowing users to add and override builtin commands.
* PUSH allows users to append to `_update`, letting you run a custom function every frame.
* PUSH changes the default `cd` behavior. If run with no arguments, it will be treated as `cd /`
* PUSH allows you to `cd` into a directory by typing that directory as a command.
* PUSH disables input while holding alt (to allow for `Alt+Key` shortcuts)
* PUSH changes the title of the window from "Terminal" to "PUSH"

All modified sections in `push.lua` are fenced with `=== PUSH ===` and `=== END PUSH ===` comments.

## How can I write a module?

PUSH modules are just lua modules. PUSH looks for modules in `/appdata/system/terminal/`. PUSH looks for certain exported keys and handles them accordingly.

You should not `print()` inside a module. Use `add_line()` instead.

### `init`

The `init` key should be a list of functions to run once after loading.

### `update`

The `update` key should be a list of functions that you want to run every frame. This could be used for adding a shortcut.

* Update functions should take 1 parameter: a table of variables.
    * `cmd`
    * `cursor_pos`
    * `get_prompt()`
    * `run_terminal_command()`
* Update functions optionally should return a table of variables to set.
    * `cmd`
    * `cursor_pos`

### `commands`

The `commands` key should contain a table of commands to add. The key should be the name of the command, and the value should be a function that runs when that command is typed.

* Command functions should takes one argument, a list of arguments given to the command.

### `prompt`

The `prompt` key should contain a function to replace the prompt. It should return a string to use as the prompt.

## Example Modules

The `examples/` folder in this repo contains a list of example modules that can be used to add functionality to PUSH and to demonstrate how to write modules. You can install the example modules by moving them to `/appdata/system/terminal/`

### `altl.lua`

Adds a fish style `Alt+L` shortcut to list the files in the current directory, or the files in the directory under the cursor

### `cd.lua`

Adds fish style history to the `cd` command. Overrides the builtin `cd` command. `cdh` can be used to view directory history and switch to a previous directory with `cdh <number>`. `Ctrl+N` (next) and `Ctrl+P` (previous) can be used to navigate history.

### `ctrlc.lua`

Clear the current command by pressing `Ctrl+C`.

### `ctrld.lua`

Close the terminal if `Ctrl+D` is pressed and no command is typed.

### `prompt.lua`

Replaces the prompt with one that makes the current directory be a brighter color.

### `pwd_title.lua`

Adds the present working directory to the window title.

### `source.lua`

Adds a `source` command, to execute a lua file inside the terminal process

### `z.lua`

Adds a shortcut (`Alt+C`) to launch `fzf` with the `z` shortcut. (Requires [fzf](https://github.com/Rayquaza01/fuzzy-finder-picotron/))

## Acknowledgements

* Using this require function: [lexaloffle.com/bbs/?tid=140784](https://www.lexaloffle.com/bbs/?tid=140784)
* `push.lua` is modified from `terminal.lua`
