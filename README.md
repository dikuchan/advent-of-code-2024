# Advent of Code 2024

AoC 2024 tasks written in Zig and solved at compile-time.

### How to run

```bash
$ zig build -Dtask=1
```

Since Zig (as of 0.14.0) doesn't allow printing at `comptime` without a build error (or I didn't figure it out), the least painful option is to use `@compileLog`. So the output looks messy:

```bash
$ zig build -Dtask=2
install
└─ install aoc
   └─ zig build-exe aoc Debug native 1 errors
src/main.zig:15:9: error: found compile log statement
        @compileLog(
        ^~~~~~~~~~~

Compile Log Output:
@as(*const [13:0]u8, "Answer 1: 123")  # <-- answers
@as(*const [13:0]u8, "Answer 2: 456")  # <--         are here
error: the following command failed with 1 compilation errors: ...
```

### How to run tests

```bash
$ zig build test --summary all
```
