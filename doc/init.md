Sample init scripts and service configuration for vektorcoind
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/vektorcoind.service:    systemd service unit configuration
    contrib/init/vektorcoind.openrc:     OpenRC compatible SysV style init script
    contrib/init/vektorcoind.openrcconf: OpenRC conf.d file
    contrib/init/vektorcoind.conf:       Upstart service configuration file
    contrib/init/vektorcoind.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "vektorcoin" user
and group.  They must be created before attempting to use these scripts.
The macOS configuration assumes vektorcoind will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, vektorcoind requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, vektorcoind will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that vektorcoind and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If vektorcoind is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running vektorcoind without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `share/examples/vektorcoin.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/vektorcoind`  
Configuration file:  `/etc/vektorcoin/vektorcoin.conf`  
Data directory:      `/var/lib/vektorcoind`  
PID file:            `/var/run/vektorcoind/vektorcoind.pid` (OpenRC and Upstart) or `/var/lib/vektorcoind/vektorcoind.pid` (systemd)  
Lock file:           `/var/lock/subsys/vektorcoind` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the vektorcoin user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
vektorcoin user and group.  Access to vektorcoin-cli and other vektorcoind rpc clients
can then be controlled by group membership.

### macOS

Binary:              `/usr/local/bin/vektorcoind`  
Configuration file:  `~/Library/Application Support/VEKTORCOIN/vektorcoin.conf`  
Data directory:      `~/Library/Application Support/VEKTORCOIN`  
Lock file:           `~/Library/Application Support/VEKTORCOIN/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start vektorcoind` and to enable for system startup run
`systemctl enable vektorcoind`

NOTE: When installing for systemd in Debian/Ubuntu the .service file needs to be copied to the /lib/systemd/system directory instead.

### OpenRC

Rename vektorcoind.openrc to vektorcoind and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/vektorcoind start` and configure it to run on startup with
`rc-update add vektorcoind`

### Upstart (for Debian/Ubuntu based distributions)

Upstart is the default init system for Debian/Ubuntu versions older than 15.04. If you are using version 15.04 or newer and haven't manually configured upstart you should follow the systemd instructions instead.

Drop vektorcoind.conf in /etc/init.  Test by running `service vektorcoind start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy vektorcoind.init to /etc/init.d/vektorcoind. Test by running `service vektorcoind start`.

Using this script, you can adjust the path and flags to the vektorcoind program by
setting the VEKTORCOIND and FLAGS environment variables in the file
/etc/sysconfig/vektorcoind. You can also use the DAEMONOPTS environment variable here.

### macOS

Copy org.vektorcoin.vektorcoind.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.vektorcoin.vektorcoind.plist`.

This Launch Agent will cause vektorcoind to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run vektorcoind as the current user.
You will need to modify org.vektorcoin.vektorcoind.plist if you intend to use it as a
Launch Daemon with a dedicated vektorcoin user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
