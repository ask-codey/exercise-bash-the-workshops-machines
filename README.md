# Exercise: The Workshop's Machines

Exercise code for the lesson **Exercise: The Workshop's Machines** in Bash in Depth on [ask-codey.com](https://www.ask-codey.com).

Ada Wren's workshop is full of machines, and every machine is a small program. None of them works yet: they need permission to run, a setting from the environment, and a place on your PATH. Ada left you a work order. Get the machines going with `ls -l`, `chmod`, environment variables and `PATH`, answer her questions in `answers.txt`, and let a check script tell you what's done.

## Before you start

You need a terminal (the Terminal app on a Mac, Ubuntu on Linux or in WSL on Windows) and **bats**, the tool that runs the check. If `bats --version` doesn't print a version yet, install it:

```bash
sudo apt install bats       # Ubuntu, and Ubuntu in WSL
brew install bats-core      # a Mac, with Homebrew
```

**On Windows, unzip or clone this folder inside Ubuntu**, in your Linux home folder (for example `~/terminal-practice/`), not in a Windows folder under `/mnt/c`. Windows folders don't keep Linux permissions, so `chmod` wouldn't work there.

## What's here

- `workshop/`: Ada's machines (`kettle-bot`, `clock`, `broken-toaster` and `tools/oilcan`), her diary and `work-order.txt`, her list of jobs.
- `answers.txt`: seven questions, each with a numbered line for your answer. For you to finish.
- `check.bats`: checks the machines' permissions and your answers. You don't need to change it.

## Run it

Open a terminal in this folder (the one with `answers.txt` in it), then read the work order:

```bash
cd workshop
cat work-order.txt
ls -l
```

Read each machine with `cat` before you run it. Open `answers.txt` in any text editor to write your answers, and save it after each one.

## Check your work

From this folder (not from inside `workshop`):

```bash
bats check.bats
```

At first most checks fail: that is expected. Each job you finish turns its check into a ✓. A failing check's message says which job or question it is and gives a hint.

## The rules

- Change permissions with `chmod`. Don't edit the machines themselves.
- The broken toaster must stay unable to run.
- Write each answer on its numbered line, after the `)`, like the example: `0) work-order.txt`.

## Tips

- `ls -l` shows each file's permissions: an `x` means it may run.
- A program in the folder you're in runs with `./` in front of its name.
- `NAME=value command` sets an environment variable for one command; `export NAME=value` keeps it for the rest of the session.
- `export PATH="$PATH:/full/path/to/a/folder"` adds a folder to the end of your PATH. `pwd` prints the full path of the folder you're in.
- In `chmod`'s numbers, read is 4, write is 2 and run is 1.

## Hand it in

When it works, push your solution to a public repo of your own on GitHub, then paste that repo's address into **Submit your exercise** on the lesson page at [ask-codey.com](https://www.ask-codey.com). That's what completes the lesson. The lesson page shows the Git commands, step by step.
