import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final bleServiceUuid =
    Uuid.parse('27760003-999c-4d6a-9fc4-c7272be10900'.toUpperCase());

final bleWriteUuid =
    Uuid.parse('27760003-999c-4d6a-9fc4-c7272be10900'.toUpperCase());

final bleNotifyUuid =
    Uuid.parse('27760003-999c-4d6a-9fc4-c7272be10900'.toUpperCase());

final List<int> checkStatusCommand = [
  0x20,
  0x00,
  0x01,
];

final List<int> unlockCommand = [
  0x60,
  0x07,
  0xDA,
];

final List<int> lockCommand = [
  0x60,
  0x07,
  0xDB,
];
