import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'constants.dart';

class SolarTechBluetoothDataSource {
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();

  void checkDeviceStatus(String deviceId) {
    List<int> buffer = [];
    buffer += checkDeviceStatusCommand;
    flutterReactiveBle.writeCharacteristicWithoutResponse(
      QualifiedCharacteristic(
        characteristicId: bleWriteUuid,
        serviceId: bleServiceUuid,
        deviceId: deviceId,
      ),
      value: buffer,
    );
  }

  void checkLockStatus(String deviceId) {
    List<int> buffer = [];
    buffer += checkLockStatusCommand;
    print(buffer.length);
    flutterReactiveBle.writeCharacteristicWithoutResponse(
      QualifiedCharacteristic(
        characteristicId: bleWriteUuid,
        serviceId: bleServiceUuid,
        deviceId: deviceId,
      ),
      value: buffer,
    );
  }

  void unlock(String deviceId, String password) {
    List<int> buffer = [];
    buffer += unlockCommand;
    buffer += [0x01];
    buffer = password.split('').map((e) => int.parse(e)).toList();
    buffer += [
      0xAF,
      0x04,
      0xED,
      0x02,
      0x0a,
      0x3c,
    ];
    flutterReactiveBle.writeCharacteristicWithoutResponse(
      QualifiedCharacteristic(
        characteristicId: bleWriteUuid,
        serviceId: bleServiceUuid,
        deviceId: deviceId,
      ),
      value: buffer,
    );
  }

  void lock(String deviceId) {
    List<int> buffer = [];
    buffer += lockCommand;
    buffer += [0x00];
    buffer += [
      0xAF,
      0x04,
      0xED,
      0x02,
      0x0a,
      0x3c,
    ];
    print(buffer.length);
    flutterReactiveBle.writeCharacteristicWithoutResponse(
      QualifiedCharacteristic(
        characteristicId: bleWriteUuid,
        serviceId: bleServiceUuid,
        deviceId: deviceId,
      ),
      value: buffer,
    );
  }
}
