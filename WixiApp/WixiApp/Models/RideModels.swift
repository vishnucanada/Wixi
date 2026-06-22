import Foundation
import CoreLocation

struct RideOption: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let eta: Int
    let icon: String
}

struct Driver: Equatable {
    let name: String
    let rating: Double
    let car: String
    let plate: String
    let eta: Int

    var initials: String {
        name.split(separator: " ").map { String($0.prefix(1)) }.joined()
    }
}

struct TripDestination: Identifiable, Equatable {
    static func == (lhs: TripDestination, rhs: TripDestination) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let name: String
    let shortName: String
    let distance: String
    let duration: String
    let coordinate: CLLocationCoordinate2D
    let basePrice: Double
}

// MARK: - Mock Data

let syntagmaSquare = CLLocationCoordinate2D(latitude: 37.9755, longitude: 23.7348)

let mockDestinations: [TripDestination] = [
    TripDestination(
        name: "Athens International Airport",
        shortName: "Airport",
        distance: "32 km",
        duration: "~35 min",
        coordinate: CLLocationCoordinate2D(latitude: 37.9364, longitude: 23.9445),
        basePrice: 24.50
    ),
    TripDestination(
        name: "Piraeus Port",
        shortName: "Piraeus",
        distance: "12 km",
        duration: "~20 min",
        coordinate: CLLocationCoordinate2D(latitude: 37.9475, longitude: 23.6371),
        basePrice: 12.00
    ),
    TripDestination(
        name: "Kifisia",
        shortName: "Kifisia",
        distance: "18 km",
        duration: "~28 min",
        coordinate: CLLocationCoordinate2D(latitude: 38.0746, longitude: 23.8108),
        basePrice: 16.00
    ),
]

func rideOptions(for basePrice: Double) -> [RideOption] {
    [
        RideOption(name: "WiXi", description: "Affordable rides", price: basePrice, eta: 4, icon: "car.fill"),
        RideOption(name: "WiXi Comfort", description: "Newer cars, extra legroom", price: (basePrice * 1.3 * 100).rounded() / 100, eta: 7, icon: "car.fill"),
        RideOption(name: "WiXi XL", description: "Up to 6 passengers", price: (basePrice * 1.55 * 100).rounded() / 100, eta: 12, icon: "suv.side.fill"),
    ]
}

let mockDrivers: [Driver] = [
    Driver(name: "Maraya B.", rating: 4.98, car: "Toyota Corolla", plate: "ΙΖΑ-4521", eta: 4),
    Driver(name: "Lyly P.", rating: 4.95, car: "Fiat 500", plate: "ΝΚΗ-7832", eta: 5),
    Driver(name: "Ala S.", rating: 4.97, car: "Honda CR-V", plate: "ΥΜΕ-1156", eta: 3),
]
