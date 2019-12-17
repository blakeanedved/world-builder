# Package

version       = "0.1.0"
author        = "Aaron Ingalls, Blake Nedved"
description   = "A world generation tool written in nim"
license       = "MIT"
srcDir        = "src"
bin           = @["world_builder"]



# Dependencies

requires "nim >= 1.0.0"
requires "nigui >= 0.2.2"
requires "nimnoise >= 0.1.0"
requires "imageman >= 0.6.3"

# Tasks

task test, "Run the nimble tester":
  withdir "tests":
    exec "nim c -r tester"
