# bluectl
## A tiny tool to interact with Bluetooth devices in macOS

I needed a CLI interface to some of IOBluetoothDevice's basic functionality, so I wrote this.

### Usage

```
bluectl [<device name> | <device address>] [<command>]

Commands:
    name        Prints the human-friendly name of the device.
    address     Prints the address of the device.
    connect     Attempts to connect the device.
    disconnect  Attempts to disconnect the device.
    status      Prints whether the device is connected or not.

The `device address` can have dashes, colons, or pretty much any other separators you can imagine.
```

Running `bluectl` with no arguments will list all paired devices and their addresses. Running it with a name or address, but no command, will dump the entire text representation of the resulting IOBluetoothDevice object.

### Building

`clang -o bluectl bluectl.m -framework foundation -framework iobluetooth`
