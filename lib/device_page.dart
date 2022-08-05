import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:solartech/constants.dart';
import 'package:solartech/solartech_bluetooth_data_source.dart';

class DevicePage extends StatefulWidget {
  final String deviceId;
  const DevicePage({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late Stream<ConnectionStateUpdate> connectionStream;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  StreamSubscription? _dataStream;
  _connect() {
    connectionStream = FlutterReactiveBle().connectToDevice(
        id: widget.deviceId,
        servicesWithCharacteristicsToDiscover: {
          bleServiceUuid: [
            bleNotifyUuid,
            bleWriteUuid,
          ]
        }).asBroadcastStream();
    _connection = connectionStream.listen((event) {
      if (event.connectionState == DeviceConnectionState.connected) {
        _dataStream = FlutterReactiveBle()
            .subscribeToCharacteristic(
          QualifiedCharacteristic(
            characteristicId: bleNotifyUuid,
            serviceId: bleServiceUuid,
            deviceId: widget.deviceId,
          ),
        )
            .listen((data) {
          print(data);
        });
      }
    });
  }

  @override
  void initState() {
    _connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.deviceId,
        ),
      ),
      body: StreamBuilder<ConnectionStateUpdate>(
        stream: connectionStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          final DeviceConnectionState connectionState =
              snapshot.data!.connectionState;
          if (connectionState == DeviceConnectionState.connected) {
            return Center(
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('connected'),
                    ElevatedButton(
                      onPressed: () {
                        SolarTechBluetoothDataSource()
                            .unlock(widget.deviceId, '654321');
                      },
                      child: const Text('unlock'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SolarTechBluetoothDataSource().lock(widget.deviceId);
                      },
                      child: const Text('lock'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SolarTechBluetoothDataSource()
                            .checkStatus(widget.deviceId);
                      },
                      child: const Text('device status'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SolarTechBluetoothDataSource()
                            .checkLockStatus(widget.deviceId);
                      },
                      child: const Text('lock status'),
                    ),
                  ],
                );
              }),
            );
          } else if (connectionState == DeviceConnectionState.connecting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (connectionState == DeviceConnectionState.disconnected) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      _connect();
                    },
                  );
                },
                child: const Text('reconnect'),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    _connection?.cancel();
    _dataStream?.cancel();
    super.dispose();
  }
}
