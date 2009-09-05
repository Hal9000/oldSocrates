$:  << "lib"
require 'base'
require 'datastore'
require 'bbhelper'

create_topic "/general","General Knowledge"

question "What is the meaning of life?","42"

fib "Dvorak's Symphony No. 9 is commonly called the --- --- Symphony.",
    "New World"

tf  "Are you a turtle?",false

mchoice "Which state has the most land area?","AK",
    "TX","CA","AK","HI","RI"

computed <<'EOF'
  x = y = 0
  x = rand(100) until x > 10
  y = rand(100) until y > 10
  # Return: question, correct answer
  ["What is #{x} * #{y}?","#{x*y}"]
EOF

computed <<'EOF'
  z = rand(30)
  s1 = "What is #{z} squared?"
  s2 = "#{z**2}"
  [s1, s2]
EOF

create_topic "/astro","Astronomy"

create_topic "/astro/solar", "Our Solar System"

question "Duh... what's that big yellow thing?","the sun"

create_topic "/astro/cosmo", "Cosmology"

fib "Most galaxies experience a spectral shift toward the ---.","red"

fib "Our own galaxy is referred to as the --- ---.","Milky Way"

fib "Right after the Big Bang came ---.", "the big cigarette"
