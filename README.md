# Tiva Project

Boilerplate code to compile, run, and debug an embedded program running on the
EK-TM4C123-GXL chip (a.k.a. the Tiva C Series Launchpad). This boilerplate contains:

- A `Makefile` to compile (`make all`), flash (`make flash`), or debug your project
  (`make debug`)
- A YouCompleteMe config file for Vim users wanting to have intelligent autocompletion
  and other excellent IDE-like features
- An example `blinky` project to show how the boilerplate fits together

This is platform-independent and makes use of the free libraries supplied by TI as
well as these open-sourced tools:

- [lm4tools][lm4tools-link] for flashing and creating a GDB bridge

- [GDB][GDB] to provide us with all the useful debugging tools you'd normally find
  in an IDE. I'd recommend installing this via your package manager rather than
  installing from source (i.e. `homebrew` from Mac OSX, `apt-get` for Ubuntu,
  etc.)

- [GNU ARM Cross Compiler][gnu-arm] for cross-compiling

## Platform-specific install notes
### Windows
Unfortunately, the current TI-implemented debugging bridge used in `lm4tools`
is not supported in Windows. According to the `lm4tools` README concerning the
`lmicdiusb` utility:

> Works on all Linux, Mac OS X, and BSD systems. Currently not on Windows, due to the use of poll() which does not work for USB on Windows.

### Mac OS X
Newer versions of OSX will need to add `libusb-1.0` to the package config path
in order for the makefile in `lm4tools` to properly build. Assuming you
installed `libusb` via Homebrew:

```
$ brew list libusb
...
several paths...
/usr/local/Cellar/libusb/<some_version_number>/lib/pkgconfig/libusb-1.0.pc
...
```

You'll need to add the path to the `pkgconfig` directory to the
`PKG_CONFIG_PATH` environment variable. Assuming you are using `bash`, simply
add the following line to your `.bashrc`:

```
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/Cellar/libusb/1.0.20/lib/pkgconfig
```

Then you should have no problem compiling the `lm4tools` tools. Watch those
version numbers in case `libusb` updates later on down the road!

[lm4tools-link]: https://github.com/utzig/lm4tools
[GDB]: https://www.gnu.org/software/gdb
[gnu-arm]: https://launchpad.net/gcc-arm-embedded/+download
