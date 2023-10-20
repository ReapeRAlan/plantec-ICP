import Time "mo:base/Time";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Nat32 "mo:base/Nat32";


actor {
    type Measurement = {
        id: Nat;                      // ID único para cada medición
        soilHumidity: Float;          // Humedad de la Tierra
        ambientHumidity: Float;      // Humedad Ambiente
        ambientTemperature: Float;   // Temperatura Ambiente
        timestamp: Nat;              // Usamos un timestamp en lugar de una fecha textual
    };

    var measurements: [Measurement] = [];
    var nextId: Nat = 0;             // Contador para generar IDs únicos

    private func intToNat(x: Int) : Nat {
        let absValue = Int.abs(x);
        let nat32Value = Nat32.fromIntWrap(absValue);
        return Nat32.toNat(nat32Value); // Convierte el valor de Nat32 a Nat
    };

    public func addMeasurement(soilHumidity: Float, ambientHumidity: Float, ambientTemperature: Float): async Nat {
        let timestamp = intToNat(Time.now());
        let newMeasurement: Measurement = {
            id = nextId;
            soilHumidity = soilHumidity;
            ambientHumidity = ambientHumidity;
            ambientTemperature = ambientTemperature;
            timestamp = timestamp;
        };
        nextId += 1;                    // Incrementa el ID para la próxima inserción
        measurements := Array.append<Measurement>(measurements, [newMeasurement]);
        return newMeasurement.id;       // Retorna el ID del nuevo registro para informar al usuario
    };

    public func getAllMeasurements(): async [Measurement] {
        return measurements;
    };

    public func deleteMeasurementById(idToDelete: Nat): async Bool {
        let originalSize = Array.size(measurements);
        measurements := Array.filter<Measurement>(measurements, func(measurement: Measurement): Bool {
            return measurement.id != idToDelete;
        });
        return originalSize > Array.size(measurements);  // Retorna verdadero si se eliminó algún registro
    }
}