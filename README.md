# Starch
> Run Steam in an Arch Linux container with zero overhead

## Background

Over the last few years, Valve have done an outstanding job in bringing the massive Steam library to Linux.
However, installing all the required libraries and ensuring they can be correctly linked into all Steam games can still be hard and error-prone, especially on unsupported Linux distributions.

Starch aims to fix this problem by providing an easy way to run Steam inside of a lightweight `systemd-nspawn` Arch Linux container.
This method is possible on all Linux systems using Systemd and should have **zero overhead** compared to running Steam on the host system.

Because of the way `systemd-nspawn` and `machinectl` work, this approach requires running commands which require root access.
As such, Starch is implemented as a **small** and **easy to audit** POSIX SH script which only implements the bare minimum functionality to get a functional system capable of running Steam.

## Usage

A Starch container is set up in multiple distinct stages.
First, a base image provided by Arch Linux is downloaded using `starch pull`.
Then, this image can be booted using the `starch boot` command.
Now it is possible to configure the running container using the `starch setup` command. This also downloads all required packages for a smooth Steam user experience.

Now arbitrary commands can be executed on the Starch container using `starch exec COMMAND ARGS...`. Usually you will be running `starch exec steam` to start a new Steam client session.

In order to access graphical applications running inside the Starch container you will have to allow connections to your host X server.
This is most easily done by installing the XHost application and running `xhost +local:` on your host system.

Audio is also handled automatically, provided you have setup PulseAudio on your host system.
Host systems running only ALSA are unfortunately not supported.

Also remember that you still have access to the full arsenal of `machinectl` when managing your Starch container.
For example, you may run `machinectl shell root@starch` to enter an interactive shell inside of the default Starch container.
For other useful container administration commands, refer to the `machinectl` manual.

## Customization

Starch makes some assumptions about your host system, however these can easily be changed by editing the files contained in the `./files` subdirectory of this repository.

If your user does not have the default user id value of `1000` you will want to adapt the location of your host PulseAudio socket, which, in most cases, is dependent on your user id.
You can change its location by editing the `./files/starch.nspawn` file.

Secondly, if your `DISPLAY` environment variable is not the default `:0` you will want to adapt the value used in the `./files/setup.sh` file.

## Caveats

Because `systemd-nspawn` containers are not real virtual machines but rather fancy managed chroot environments, they also share the Kernel and associated drivers with the host system.
In practice, this means that you will have to install all required graphics and other hardware drivers on your host system.

Also, the experimental version of Proton used by Steam requires a Kernel built with the `PROC_CHILDREN y` configuration option set.
This does not seem to be the default for many Linux distributions, so you might need to rebuild your kernel.

For guides on how to debug specific games and issues please refer to the internet, as this represents an ever-moving target.
However, please don't hesitate when opening issues and/or discussions on this project.
I am happy to help where I can.

#### Resources

+ [man:systemd-nspawn(1)](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)
+ [man:machinectl(1)](https://www.freedesktop.org/software/systemd/man/machinectl.html)
+ [man:xhost(1)](https://www.x.org/archive/X11R6.8.1/doc/xhost.1.html)

## License

[MIT](./LICENSE) © Leo Gaskin 2021
