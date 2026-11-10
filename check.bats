#!/usr/bin/env bats
# Checks the workshop's permissions and your answers in answers.txt, working each answer out
# from the workshop and your computer, the way you would.
# Run it from this folder with:  bats check.bats
# You don't need to change this file.

setup() {
  cd "$BATS_TEST_DIRNAME"
}

# The answer written after "N)" in answers.txt, without spaces or quotes at either end.
answer() {
  grep -E "^$1\)" answers.txt | head -n 1 | sed -E "s/^$1\)[[:space:]]*//; s/[[:space:]]+\$//; s/^[\"'\`]//; s/[\"'\`]\$//"
}

# Fails with a message when question N has no answer yet.
need() {
  if [[ -z "$(answer "$1")" ]]; then
    echo "Question $1 has no answer yet. Write it after \"$1)\" in answers.txt."
    return 1
  fi
}

# The three-digit number for nine permission letters such as rwxr-xr-x: r is 4, w is 2, x is 1.
number_for() {
  local letters="$1" number="" i sum
  for i in 0 3 6; do
    sum=0
    [[ "${letters:i:1}" == "r" ]] && sum=$((sum + 4))
    [[ "${letters:i+1:1}" == "w" ]] && sum=$((sum + 2))
    [[ "${letters:i+2:1}" == "x" ]] && sum=$((sum + 1))
    number="$number$sum"
  done
  echo "$number"
}

@test "the workshop is still here" {
  for f in kettle-bot clock broken-toaster tools/oilcan diary.txt work-order.txt; do
    if [[ ! -f "workshop/$f" ]]; then
      echo "workshop/$f is missing. Download the exercise again to get it back."
      return 1
    fi
  done
}

@test "the kettle-bot may run" {
  if [[ ! -x workshop/kettle-bot ]]; then
    echo "The kettle-bot can't run yet: ls -l shows no x in its permissions. chmod +x adds it."
    return 1
  fi
}

@test "the clock may run" {
  if [[ ! -x workshop/clock ]]; then
    echo "The clock can't run yet: ls -l shows no x in its permissions. chmod +x adds it."
    return 1
  fi
}

@test "the oil can may run" {
  if [[ ! -x workshop/tools/oilcan ]]; then
    echo "The oil can in workshop/tools can't run yet. A program on your PATH needs its x permission too."
    return 1
  fi
}

@test "the broken toaster still may not run" {
  if [[ -x workshop/broken-toaster ]]; then
    echo "The broken toaster may run, and Ada said it isn't safe. chmod -x takes the x away. (Did a chmod +x * catch it?)"
    return 1
  fi
}

@test "1) the kettle-bot's ticket" {
  need 1
  want="$(POWER=on bash workshop/kettle-bot | grep -oE 'TEA-[0-9]+')"
  got="$(answer 1 | grep -oE 'TEA-[0-9]+' | head -n 1)"
  if [[ "$got" != "$want" ]]; then
    echo "Question 1: \"$(answer 1)\" isn't the ticket yet. Without POWER the kettle-bot says NO POWER. Put POWER=on in front of the command, or export it first."
    return 1
  fi
}

@test "2) the oil can's code" {
  need 2
  mkdir -p "$BATS_TEST_TMPDIR/bin"
  cp workshop/tools/oilcan "$BATS_TEST_TMPDIR/bin/oilcan"
  chmod +x "$BATS_TEST_TMPDIR/bin/oilcan"
  want="$(PATH="$BATS_TEST_TMPDIR/bin:$PATH" oilcan | grep -oE 'OIL-[0-9]+')"
  got="$(answer 2 | grep -oE 'OIL-[0-9]+' | head -n 1)"
  if [[ "$got" != "$want" ]]; then
    echo "Question 2: \"$(answer 2)\" isn't the code yet. The oil can only works by name: add the tools folder to the end of PATH with export PATH=\"\$PATH:...\", then type oilcan."
    return 1
  fi
}

@test "3) the kettle-bot's permissions as a number" {
  need 3
  want="$(number_for "$(ls -l workshop/kettle-bot | cut -c2-10)")"
  if [[ "$(answer 3)" != "$want" ]]; then
    echo "Question 3: \"$(answer 3)\" isn't it yet. Read the kettle-bot's nine letters in ls -l. For each set of three, add r = 4, w = 2 and x = 1."
    return 1
  fi
}

@test "4) the number for a private file" {
  need 4
  want="$(number_for "rw-------")"
  if [[ "$(answer 4)" != "$want" ]]; then
    echo "Question 4: \"$(answer 4)\" isn't it yet. The owner gets read and write (4 + 2), and the group and others get nothing (0)."
    return 1
  fi
}

@test "5) who owns /etc/hosts" {
  need 5
  want="$(ls -l /etc/hosts | awk '{ print $3 }')"
  if [[ "$(answer 5)" != "$want" ]]; then
    echo "Question 5: \"$(answer 5)\" isn't the owner. In ls -l /etc/hosts, the owner is the first name after the permissions and the number."
    return 1
  fi
}

@test "6) where bash lives" {
  need 6
  a="$(answer 6)"
  if [[ "$a" != /* ]] || ! type -a -P bash | grep -qxF "$a"; then
    echo "Question 6: \"$a\" isn't where bash lives. which bash prints the path of its program file, starting with /."
    return 1
  fi
}

@test "7) what kind of command cd is" {
  need 7
  want="$(type -t cd)"
  if [[ "$(answer 7)" != *"$want"* ]]; then
    echo "Question 7: \"$(answer 7)\" isn't it yet. Run type cd and copy the words after \"cd is\"."
    return 1
  fi
}
