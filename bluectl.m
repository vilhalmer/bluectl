#import <stdio.h>
#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

static void NSPrint(NSString *format, ...) {
    va_list args;

    va_start(args, format);
    NSString *string  = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    fprintf(stdout, "%s\n", [string UTF8String]);
}

int connect(IOBluetoothDevice * device) {
    IOReturn success = [device openConnection];

    if (success != kIOReturnSuccess) {
        NSPrint(@"Failed: %d", (int)success);
    }

    return success;
}

int disconnect(IOBluetoothDevice * device) {
    IOReturn success = [device closeConnection];

    if (success != kIOReturnSuccess) {
        NSPrint(@"Failed: %d", (int)success);
    }

    return success;
}

NSString * find_address(NSString * name) {
    for (IOBluetoothDevice * device in [IOBluetoothDevice pairedDevices]) {
        if ([[device name] isEqualToString:name]) {
            return [device addressString];
        }
    }

    return nil;
}

int main(int argc, char const * argv[]) {
    if (argc < 2) {
        // Print all available devices.

        NSPrint(@"Paired devices:\n");
        for (IOBluetoothDevice * device in [IOBluetoothDevice pairedDevices]) {
            NSPrint(@"%@ (%@)", [device name], [device addressString]);
        }

        return 0;
    }

    NSString * address = [NSString stringWithUTF8String:argv[1]];
    IOBluetoothDevice * device = [IOBluetoothDevice deviceWithAddressString:address];
    if (!device) {
        device = [IOBluetoothDevice deviceWithAddressString:find_address(address)];
    }

    if (!device) {
        NSPrint(@"No device by that name.");
        return 1;
    }

    NSString * command = NULL;
    if (argc > 2) {
        command = [NSString stringWithUTF8String:argv[2]];
    }

    if (!command) {
        NSPrint(@"%@", device);
        return 0;
    }

    if ([command isEqualToString:@"name"]) {
        NSPrint([device name]);
    }

    if ([command isEqualToString:@"address"]) {
        NSPrint([device addressString]);
    }

    if ([command isEqualToString:@"connect"]) {
        return connect(device);
    }

    if ([command isEqualToString:@"disconnect"]) {
        return disconnect(device);
    }

    if ([command isEqualToString:@"status"]) {
        NSPrint(@"%@", [device isConnected] ? @"Connected" : @"Disconnected");
    }

    return 0;
}
