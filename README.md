## Rip Compiler


### Assumptions

A project root is demarkated by a `package.toml` file. Source files are to be kept in `./source`. Dependencies are installed in flattened tree under `./vender`. Authors may configure source control to ignore `vendor`, but an exception should be made for the vendor cache (`./vendor/.cache`, see `.gitignore`). This allows for an virtual dependency lock "file". This also allows for offline compiles, as dependencies are committed into source control. The load path is managed at compile time and will only include direct dependencies (so *not* transitive dependencies).


### Usage

`rip-compile` takes a Rip source file as a starting point and a name for the resulting binary. Output directories in the binary name will be created if they don't exist:

`$ rip compile source/main.rip build/rip-spec`

Then run with:

`$ ./build/rip-spec`

Specifying `--` as the output file sends the output to standard out. You probably want to redirect this to another process:

`$ rip compile source/main.rip --`

The output argument is not required if the `executables` table in `package.toml` specifies an output for the input file:

`$ rip compile source/main.rip`

If you simply wish to build everything listed in `executables`:

`$ rip compile`


Compile and execute:

`$ rip execute source/main.rip`

Or just:

`$ rip source/main.rip`


### Notes

compiler optimization passes on ast:

* transform interpolation into concatenation (followed by `.to_string()`)
* lift import
* lift literals, replace with references
* insert return
* expand overloads, replace `self` with generated name
* lift closures, rewrite parameters to accept closed locals, rewrite call sites to propogate closed locals
* flatten nested calls, insert local references (`a(b(c(42)))` => `r1 = c(42); r2 = b(r1); a(r2)`)

