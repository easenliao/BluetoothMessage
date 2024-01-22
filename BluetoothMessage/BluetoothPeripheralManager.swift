import CoreBluetooth
let characteristicUUID = CBUUID.init(nsuuid: UUID.init())
class BluetoothPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
            transferCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .notify, value: nil, permissions: .readable)
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [transferCharacteristic!]
            peripheralManager.add(service)
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("中央设备已订阅特性")
        // 此处可以保存中央设备的信息，或者根据业务需求处理
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
        }
    }
    // Call this method when you want to send data
    func sendData(_ data: Data) {
        peripheralManager.updateValue(data, for: transferCharacteristic!, onSubscribedCentrals: nil)
    }
    func startAdvertising() {
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [serviceUUID]])
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
        }
    }
}
