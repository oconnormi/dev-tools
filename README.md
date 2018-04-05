# Collection of helper scripts
This is just a place for me to store some simple helper scripts and tools that I use to make life a little easier

# Building

Require:
* [argbash](https://github.com/matejak/argbash)
* make

To build run `make`

To install in `/usr/local/bin` run `make install`

# Tools

## mib (Maven incremental build)
This isn't a tool so much as a wrapper around some maven options. It was a little more flexible than the various aliases I was using previously

Its functionality depends entirely on having the [gitflow-incremental-builder](https://github.com/vackosar/gitflow-incremental-builder) extension added to the maven project

### Usage

To build a feature branch or any unstaged local changes: `mib -b <target_branch> <goals>` where `<target_branch>` is the branch that the feature will be merged into when completed

```bash
Execute a maven incremental build (requires gitflow-incremental-builder maven extension)
Usage: /usr/local/bin/mib [-s|--(no-)skip-tests] [-i|--(no-)skip-it] [-S|--(no-)skip-static] [-b|--branch <arg>] [-h|--help] [<maven-goals-1>] ... [<maven-goals-n>] ...
	<maven-goals>: Specify any maven goals to execute. (Note: non-goal arguments not yet supported) (defaults for <maven-goals>: 'install')
	-s,--skip-tests,--no-skip-tests: Skips all tests (off by default)
	-i,--skip-it,--no-skip-it: Skips integration tests (off by default)
	-S,--skip-static,--no-skip-static: Skips static analysis plugins (off by default)
	-b,--branch: Specify the branch to use for incremental build comparison (default: 'origin/master')
	-h,--help: Prints help
```

## ddf-boot

Useful for ddf development. Can bootstrap an installation of a ddf-based distribution.
The bootstrapping process includes generating certificates for the current system hostname, wait for the system to start up, and run through the installer.

There are also some additional options for starting the system in debug mode and a few other things

### Usage

```bash
Bootstrap a ddf node from an unzipped ddf archive)
Usage: /usr/local/bin/ddf-boot [-s|--(no-)disable-security] [-p|--https-port <arg>] [-P|--http-port <arg>] [--profile <arg>] [-d|--(no-)debug-mode] [-i|--(no-)interactive-client] [-h|--help] [<ddf-directory>]
	<ddf-directory>: Directory where ddf instance is located (default: '$(pwd)')
	-s,--disable-security,--no-disable-security: Disable security manager (off by default)
	-p,--https-port: Set https port for ddf instance (default: '8993')
	-P,--http-port: Set http port for ddf instance (default: '8181')
	--profile: Installation profile (no default)
	-d,--debug-mode,--no-debug-mode: Enables karaf debug mode (off by default)
	-i,--interactive-client,--no-interactive-client: Start a client session after system boots (off by default)
	-h,--help: Prints help
```

## ddf-create-cdm

Useful for ddf development and testing. This script will create a cdm config given only a path to a directory. It also allows any additional settings for the cdm to be specified. By default this script should be run from inside of DDF_HOME, otherwise specify ddf home directory via `-d <path>`

If a cdm configuration for a given directory already exists the script will do nothing and will exit with a value of `1`

### Usage

```
Create a ContentDirectoryMonitor for a specified directory. Nothing will be done if configuration already exists
Usage: /usr/local/bin/ddf-create-cdm [-p|--processing-mechanism <arg>] [-t|--threads <arg>] [-d|--ddf-directory <arg>] [-r|--readlock-interval <arg>] [-o|--attribute-override <arg>] [-h|--help] <directory>
	<directory>: Specify the path to the directory to be monitored
	-p,--processing-mechanism: behavior when files are processed. Choices are in_place, move, and delete (default: 'in_place')
	-t,--threads: specify the number of threads to use for processing files (default: '1')
	-d,--ddf-directory: Directory where ddf instance is located (default: '$(pwd)')
	-r,--readlock-interval: specify the amount of time to wait before acquiring a file lock (default: '500')
	-o,--attribute-override: Specify attribute overrides of the form 'key=value' (Not yet supported!) (empty by default)
	-h,--help: Prints help
```
