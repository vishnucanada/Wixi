import SwiftUI
import MapKit

enum AppState: Equatable {
    case home
    case destinationPicker
    case rideSelection(TripDestination)
    case driverMatching(TripDestination, RideOption)
    case driverFound(TripDestination, RideOption, Driver)
    case rideInProgress(TripDestination, RideOption, Driver)
    case tripComplete(TripDestination, RideOption, Driver)

    static func == (lhs: AppState, rhs: AppState) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home): return true
        case (.destinationPicker, .destinationPicker): return true
        case (.rideSelection, .rideSelection): return true
        case (.driverMatching, .driverMatching): return true
        case (.driverFound, .driverFound): return true
        case (.rideInProgress, .rideInProgress): return true
        case (.tripComplete, .tripComplete): return true
        default: return false
        }
    }
}

struct HomeView: View {
    @State private var appState: AppState = .home
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: syntagmaSquare,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    @State private var selectedRide: RideOption?
    @State private var showContactSheet = false
    @State private var showShareSheet = false
    @State private var showSafetySheet = false

    var body: some View {
        ZStack {
            // Map
            mapView
                .ignoresSafeArea()

            // Top bar for in-progress ride
            if case .rideInProgress = appState {
                VStack {
                    rideTopBar
                    Spacer()
                }
            }

            // Bottom sheet
            VStack {
                Spacer()
                bottomSheet
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: stateKey)
        .sheet(isPresented: $showContactSheet) {
            ContactDriverSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareTripSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSafetySheet) {
            SafetySheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private var stateKey: String {
        switch appState {
        case .home: return "home"
        case .destinationPicker: return "picker"
        case .rideSelection: return "ride"
        case .driverMatching: return "matching"
        case .driverFound: return "found"
        case .rideInProgress: return "progress"
        case .tripComplete: return "complete"
        }
    }

    // MARK: - Top Bar (ride in progress)

    private var rideTopBar: some View {
        HStack(spacing: 12) {
            Button(action: { showSafetySheet = true }) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Theme.navy)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            Spacer()
            Button(action: { showShareSheet = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                    Text("Share trip")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Theme.navy)
                .clipShape(Capsule())
                .shadow(radius: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    // MARK: - Map

    @ViewBuilder
    private var mapView: some View {
        Map(position: $cameraPosition) {
            // Pickup pin
            Annotation("", coordinate: syntagmaSquare) {
                ZStack {
                    Circle()
                        .fill(Theme.navy)
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                }
                .shadow(radius: 4)
            }

            // Destination pin
            if let dest = currentDestination {
                Annotation("", coordinate: dest.coordinate) {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundStyle(Theme.pinkDark)
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.pinkDark)
                            .offset(y: -4)
                    }
                    .shadow(radius: 4)
                }
            }

            // Driver car pin (when in progress)
            if let dest = currentDestination, isRideActive {
                Annotation("", coordinate: driverPosition(for: dest)) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 36, height: 36)
                            .shadow(radius: 4)
                        Text("🚗")
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls { }
    }

    private var isRideActive: Bool {
        switch appState {
        case .rideInProgress: return true
        default: return false
        }
    }

    private func driverPosition(for dest: TripDestination) -> CLLocationCoordinate2D {
        // Place driver between pickup and destination
        CLLocationCoordinate2D(
            latitude: syntagmaSquare.latitude + (dest.coordinate.latitude - syntagmaSquare.latitude) * 0.3,
            longitude: syntagmaSquare.longitude + (dest.coordinate.longitude - syntagmaSquare.longitude) * 0.3
        )
    }

    private var currentDestination: TripDestination? {
        switch appState {
        case .rideSelection(let d): return d
        case .driverMatching(let d, _): return d
        case .driverFound(let d, _, _): return d
        case .rideInProgress(let d, _, _): return d
        case .tripComplete(let d, _, _): return d
        default: return nil
        }
    }

    // MARK: - Bottom Sheet

    @ViewBuilder
    private var bottomSheet: some View {
        switch appState {
        case .home:
            HomeSheetView(
                onDestinationSelected: selectDestination,
                onSearchTap: { withAnimation { appState = .destinationPicker } }
            )

        case .destinationPicker:
            DestinationPickerView(
                onSelect: selectDestination,
                onBack: { withAnimation { appState = .home } }
            )

        case .rideSelection(let destination):
            RideSelectionView(
                destination: destination,
                selectedRide: $selectedRide,
                onConfirm: { ride in confirmRide(destination: destination, ride: ride) },
                onBack: { withAnimation { appState = .home; resetMap() } }
            )

        case .driverMatching(let destination, let ride):
            DriverMatchingView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        let driver = mockDrivers.randomElement()!
                        withAnimation { appState = .driverFound(destination, ride, driver) }
                    }
                }

        case .driverFound(let destination, let ride, let driver):
            DriverFoundView(
                destination: destination,
                ride: ride,
                driver: driver,
                onCancel: { withAnimation { appState = .home; selectedRide = nil; resetMap() } },
                onContact: { showContactSheet = true },
                onStartRide: {
                    withAnimation { appState = .rideInProgress(destination, ride, driver) }
                }
            )

        case .rideInProgress(let destination, let ride, let driver):
            RideInProgressView(
                destination: destination,
                ride: ride,
                driver: driver,
                onShare: { showShareSheet = true },
                onSafety: { showSafetySheet = true },
                onComplete: {
                    withAnimation { appState = .tripComplete(destination, ride, driver) }
                }
            )

        case .tripComplete(let destination, let ride, let driver):
            TripCompleteView(
                destination: destination,
                ride: ride,
                driver: driver,
                onDone: { withAnimation { appState = .home; selectedRide = nil; resetMap() } }
            )
        }
    }

    // MARK: - Actions

    private func selectDestination(_ destination: TripDestination) {
        selectedRide = rideOptions(for: destination.basePrice).first
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            appState = .rideSelection(destination)
            zoomToRoute(destination: destination)
        }
    }

    private func confirmRide(destination: TripDestination, ride: RideOption) {
        withAnimation { appState = .driverMatching(destination, ride) }
    }

    private func zoomToRoute(destination: TripDestination) {
        let midLat = (syntagmaSquare.latitude + destination.coordinate.latitude) / 2
        let midLon = (syntagmaSquare.longitude + destination.coordinate.longitude) / 2
        let latDelta = abs(syntagmaSquare.latitude - destination.coordinate.latitude) * 1.6
        let lonDelta = abs(syntagmaSquare.longitude - destination.coordinate.longitude) * 1.6
        cameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: midLat, longitude: midLon),
            span: MKCoordinateSpan(latitudeDelta: max(latDelta, 0.05), longitudeDelta: max(lonDelta, 0.05))
        ))
    }

    private func resetMap() {
        cameraPosition = .region(MKCoordinateRegion(
            center: syntagmaSquare,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        ))
    }
}

// MARK: - Home Sheet

struct HomeSheetView: View {
    let onDestinationSelected: (TripDestination) -> Void
    let onSearchTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 0) {
                    Text("Wi")
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.navy)
                    Text("X")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.pinkDark)
                    Text("i")
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.navy)
                }

                Button(action: onSearchTap) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Theme.pinkDark)
                            .frame(width: 10, height: 10)
                        Text("Where to?")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Theme.gray400)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Theme.gray400)
                    }
                    .padding(16)
                    .background(Theme.pinkLight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                HStack(spacing: 10) {
                    ForEach(mockDestinations) { dest in
                        Button(action: { onDestinationSelected(dest) }) {
                            HStack(spacing: 6) {
                                Image(systemName: dest.shortName == "Airport" ? "airplane" : "mappin")
                                    .font(.caption)
                                Text(dest.shortName)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundStyle(Theme.navy)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Theme.gray50)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Theme.gray200, lineWidth: 1))
                        }
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Driven by women. Designed for women.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.gray500)
                    Text("The world's first taxi service consisting exclusively of women drivers — accepting only women passengers.")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.gray400)
                        .lineSpacing(3)
                }
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }
}

// MARK: - Destination Picker

struct DestinationPickerView: View {
    let onSelect: (TripDestination) -> Void
    let onBack: () -> Void
    @State private var searchText = ""

    private var allDestinations: [TripDestination] {
        mockDestinations + [
            TripDestination(name: "Glyfada Beach", shortName: "Glyfada", distance: "20 km", duration: "~30 min",
                          coordinate: CLLocationCoordinate2D(latitude: 37.8607, longitude: 23.7533), basePrice: 18.00),
            TripDestination(name: "Acropolis Museum", shortName: "Acropolis", distance: "2 km", duration: "~8 min",
                          coordinate: CLLocationCoordinate2D(latitude: 37.9685, longitude: 23.7292), basePrice: 6.00),
            TripDestination(name: "Monastiraki Square", shortName: "Monastiraki", distance: "1.5 km", duration: "~5 min",
                          coordinate: CLLocationCoordinate2D(latitude: 37.9762, longitude: 23.7257), basePrice: 5.00),
        ]
    }

    private var filtered: [TripDestination] {
        if searchText.isEmpty { return allDestinations }
        return allDestinations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(spacing: 16) {
                // Header
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.navy)
                    }
                    Spacer()
                    Text("Choose destination")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0)
                }

                // Pickup
                HStack(spacing: 12) {
                    Circle()
                        .fill(Theme.navy)
                        .frame(width: 10, height: 10)
                    Text("Syntagma Square, Athens")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.gray600)
                    Spacer()
                }
                .padding(14)
                .background(Theme.gray50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Search
                HStack(spacing: 12) {
                    Circle()
                        .fill(Theme.pinkDark)
                        .frame(width: 10, height: 10)
                    TextField("Search destination...", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(14)
                .background(Theme.pinkLight)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Divider()

                // Results
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filtered) { dest in
                            Button(action: { onSelect(dest) }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Theme.pinkDark)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(dest.name)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Theme.gray900)
                                        Text("\(dest.distance) · \(dest.duration)")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Theme.gray400)
                                    }
                                    Spacer()
                                    Text(String(format: "€%.0f", dest.basePrice))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Theme.navy)
                                }
                                .padding(.vertical, 12)
                            }
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 250)
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }
}

#Preview {
    HomeView()
}
