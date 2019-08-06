# haskell-singer

[Singer](https://github.com/singer-io/) compatible ETL jobs written in haskell

# Build

to build the project run `stack build`

# Repl

to enter a repl simply run `stack repl`, and for ghcid just run `ghcid`

# Run

to run the main program just run `stack exec haskell-singer`

# Details

Basically creates the serde boilerplate used for converting from conduit streams into singer compatible streams.

# TODO

- [x] Create base CSV tap
- [ ] Create base CSV target
- [ ] Create a SQLite compatible tap/target
- [ ] Testing suite
- [ ] Convert project to `nix` to be able to package up existing taps and targets and run integration tests against them


