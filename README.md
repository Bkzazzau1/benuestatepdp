# PoliSphere

A responsive Flutter prototype for PoliSphere operations. Narrow layouts provide
the field-agent workflow; desktop layouts open the Situation Room command center
with live operational status, scoped navigation, incident drill-down,
verification, evidence, communications, alerts, and consent-aware media requests.

## Run

```sh
flutter create .
flutter pub get
flutter run
```

The prototype uses only Flutter SDK components. Camera, GPS, encryption,
synchronization, authentication, and secure calling require audited native and
backend integrations before production use. Device media is never activated
automatically in this prototype.

## Source structure

- `lib/main.dart` - application entry point
- `lib/src/app.dart` - root app configuration
- `lib/src/theme/` - colors and Material theme
- `lib/src/widgets/` - shared presentation components
- `lib/src/screens/home/` - field dashboard
- `lib/src/screens/reports/` - report list and submission workflow
- `lib/src/screens/incidents/` - incident list and submission workflow
- `lib/src/screens/more/` - operational tools and SOS
- `lib/src/screens/situation_room/` - responsive desktop command center
