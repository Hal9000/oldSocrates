$: << "lib"
require 'base'
require 'datastore'
require 'ui_dumbtext'  # could be other pluggable UI

# Start at root of question hierarchy; ask 4 questions; limit to TF or m/c
# session = Session.new(4, [TF, MultipleChoice], "/")

# Default: Ask every question in the tree

session = Session.new("test/store")

session.start

# No recording of stats is done yet
