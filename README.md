# WiXi

**Safe. Every single ride.** WiXi is a women-only ride-hailing concept — every driver is a woman, every passenger is a woman, no exceptions. This repo contains a native iOS prototype of the rider experience, built in SwiftUI.

> ⚠️ This is a UI/UX prototype. It runs entirely on mock data — there is no backend, real matching, or live location tracking.

## Demo

<video src="https://raw.githubusercontent.com/vishnucanada/Wixi/main/demo.mp4" controls muted width="300"></video>

> If the player above doesn't appear, [click here to watch the demo](https://raw.githubusercontent.com/vishnucanada/Wixi/main/demo.mp4).

## Features

- **Onboarding carousel** introducing the women-only concept
- **Home map** with quick-pick destinations (Athens locations)
- **Ride selection** — WiXi, WiXi Comfort, and WiXi XL tiers with live price/ETA
- **Driver matching** flow with an animated searching state
- **Driver found** card showing name, rating, car, and plate
- **Ride in progress** and **trip complete** screens
- Custom navy + blush theme and a polished, animated SwiftUI interface

## Tech Stack

- **SwiftUI** — declarative UI, light mode
- **MapKit / CoreLocation** — map and coordinates
- **iOS 17+**, Swift 5
- No third-party dependencies

## Project Structure

```
WixiApp/
└── WixiApp/
    ├── WixiAppApp.swift        # App entry point
    ├── Theme.swift             # Colors & styling
    ├── Models/
    │   └── RideModels.swift    # Ride options, drivers, destinations (mock data)
    └── Views/
        ├── LandingView.swift       # Onboarding carousel
        ├── HomeView.swift          # Map + destination picker
        ├── RideSelectionView.swift # Choose a ride tier
        ├── DriverMatchingView.swift
        ├── DriverFoundView.swift
        ├── RideInProgressView.swift
        ├── TripCompleteView.swift
        └── SheetViews.swift
```

## Getting Started

**Requirements:** macOS with Xcode 15+ (iOS 17 SDK).

```bash
git clone https://github.com/vishnucanada/Wixi.git
cd Wixi/WixiApp
open WixiApp.xcodeproj
```

Then select an iOS 17 simulator (or a device) and press **▶ Run**.

## Roadmap

Possible next steps to take this from prototype toward a real app:

- Live backend for authentication, matching, and payments
- Real-time driver location and trip tracking
- Driver-side app and identity verification

## License

No license specified yet. All rights reserved unless a license is added.
