# picotron-upgraded-shell
PUSH

PUSH is a modified version of the default Picotron terminal. PUSH stands for **P**icotron **U**pgraded **SH**ell (mainly because I wanted to give it a cool name lol)

## Usage

### As a window

Download `push.lua` and launch it in the same way you launch `terminal.lua`

### As the fullscreen terminal

You can replace the fullscreen terminal with PUSH by replacing `terminal.lua` in the startup script.

```lua
-- place this in /appdata/system/startup.lua or include this script from startup.lua

-- replace system terminal with push
-- if you want to have terminal.lua available, make a copy somewhere else
cp("/appdata/system/apps/push.lua", "/system/apps/terminal.lua")

-- replace the terminal.lua process with push.lua
create_process("/appdata/system/apps/push.lua",
	{
		window_attribs = {fullscreen = true, pwc_output = true, immortal = true},
		immortal   = true
	}
)
```

## How Modified?

* PUSH can load custom modules to do things such as add commands, shortcuts, and change appearance.
* PUSH changes the way builtin commands are handled, allowing users to add and override builtin commands.
* PUSH allows users to append to `_update`, letting you run a custom function every frame.
* PUSH changes the default `cd` behavior. If run with no arguments, it will be treated as `cd /`
* PUSH disables input while holding alt (to allow for `Alt+Key` shortcuts)
* PUSH changes the title of the window from "Terminal" to "PUSH"

All modified sections in `push.lua` are fenced with `=== PUSH ===` and `=== END PUSH ===` comments.

## How can I write a module?

PUSH modules are just lua modules. PUSH looks for modules in `/appdata/system/terminal/`. PUSH looks for certain exported keys and handles them accordingly.

You should not `print()` inside a module. Use `add_line()` instead.

### `_get_push_vars()`

`_get_push_vars()` is a global function that returns push variables. It's used to make local variables accessible to module code. The push variables are passed to functions as an argument automatically, so there should not be any reason to call this directly.

The variables this exposes are:
* `cmd` - currently typed command
* `cursor_pos` - current cursor position
* `get_prompt()` - prompt function
* `run_terminal_command()` - run any terminal command

### `_set_push_vars()`

`_get_push_vars()` is a global function that sets push variables. It's used to make local variables accessible to module code. The push variables are set based on the return value of update functions automatically, so there should not be any reason to call this directly.

The variables you can set are:
* `cmd` - currently typed command
* `cursor_pos` - current cursor position
* `get_prompt()` - prompt function

### Key: `init`

The `init` key should contain a list of functions to run once after loading.

### Key: `update`

The `update` key should contain a list of functions that you want to run every frame. This could be used for adding a shortcut.

* Update functions should take 1 parameter, the push variables table. (See `_get_push_vars()`)
* Update functions optionally should return a table of push variables to set. (See `_set_push_vars()`)

### Key: `commands`

The `commands` key should contain a table of commands to add. The key should be the name of the command, and the value should be a function that runs when that command is typed.

* Command functions should takes two arguments, a list of arguments given to the command and the push variables table. (See `_get_push_vars()`)

### Key: `command_handlers`

The `command_handlers` key should contain a list of functions to handle unspecified commands. Command handlers are run *after* builtin commands but *before* executing programs from path.

Command handlers should be used to handle commands with non-standard names. (For example, if you want to `cd` into a path by typing just the directory name). If a command has a standard name, you should use `commands` or an external program instead.

* Command handler functions should take two arguments, the full command and the push variables table. (See `_get_push_vars()`)
* Command handler functions should return a boolean. `true` if the command was handled, and `false` if it wasn't.

### Key: `prompt`

The `prompt` key should contain a function to replace the prompt. It should return a string to use as the prompt.

## Example Modules

The `examples/` folder in this repo contains a list of example modules that can be used to add functionality to PUSH and to demonstrate how to write modules. You can install the example modules by moving them to `/appdata/system/terminal/`

### `altl.lua`

Adds a fish style `Alt+L` shortcut to list the files in the current directory, or the files in the directory under the cursor

### `barecd.lua`

Adds bare cd (move to a directory by typing just the directory).

Adds dots to go up a directory (`..` is equivalent to `cd ..`, `...` is equivalent to `cd ../..`, etc)

Also adds an `up` command to go up a directory. (`up 1` is equivalent to `cd ..`, `up 2` is equivalent to `cd ../..`, etc)

### `cd.lua`

Adds fish style history to the `cd` command. Overrides the builtin `cd` command.

Adds a `cdh` command to view directory history and switch to a previous directory with `cdh <number>`.

Adds `Ctrl+N` (next) and `Ctrl+P` (previous) shortcuts to navigate history.

Adds `nextd` (next) and `prevd` (previous) commands to navigate history.

### `ctrlc.lua`

Clear the current command by pressing `Ctrl+C`.

### `ctrld.lua`

Close the terminal if `Ctrl+D` is pressed and no command is typed.

### `emacs.lua`

Adds some emacs shortcuts, such as `Ctrl+F` (forward), `Ctrl+B` (backward), `Ctrl+Left` (Move to previous word), `Ctrl+Right` (Move to next word), and `Ctrl+W` (delete from cursor to previous word).

`Ctrl+A` and `Ctrl+E` are builtin to `terminal.lua`, so they are not included in the module.

Uses some code from `/system/lib/gui_ed.lua`.

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
* `examples/emacs.lua` uses `calculate_skip_steps` and `get_char_cat` from `/system/lib/gui_ed.lua`
