# Advent of Code 2024

AoC 2024 tasks written in Zig and solved at compile-time.

### How to run

```bash
$ zig build -Dtask=1 run
```

Since Zig (as of 0.14.0) doesn't allow printing in `comptime` (or I didn't figure it out), the only option is to use `@compileLog`. Unfortunately, calling this function will add a compilation error to the build. So the output will look messy:

```bash
$ zig build -Dtask=2 run
run
└─ run aoc
   └─ zig build-exe aoc Debug native 1 errors
src/main.zig:15:9: error: found compile log statement
        @compileLog(
        ^~~~~~~~~~~

Compile Log Output:
@as(*const [6:0]u8, "1: ***")  # <-- answers
@as(*const [6:0]u8, "2: ***")  # <--         are here
error: the following command failed with 1 compilation errors: ...
```
