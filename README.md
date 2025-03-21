 # Picture Frame App

## Overview
The **Picture Frame App** is a Flutter application that fetches and displays a rotating gallery of paintings from the Pexels API. It provides a smooth viewing experience with automatic image transitions and manual controls for navigation.

## Features
- Fetches high-quality painting images from the Pexels API.
- Automatically cycles through images every 6 seconds.
- Allows manual navigation using next and previous buttons.
- Pause and resume the image slideshow at any time.
- Displays a sleek, framed design with smooth animations.
- Handles errors gracefully when fetching images.

## Getting Started
### Prerequisites
Before running the app, ensure you have the following installed:
- Flutter
- Dart SDK
- A stable internet connection for API access

### Installation Steps
1. Clone or download this repository.
2. Open a terminal and navigate to the project folder:
   ```sh
   cd picture_frame_app
   ```
3. Install the required dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Dependencies
This app relies on the following dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.4
  cached_network_image: ^3.2.0
```

## How to Use
1. Launch the app to start the automatic image rotation.
2. Use the **pause/resume** button to control the slideshow.
3. Tap the **next** or **previous** button to manually browse images.
4. Enjoy a visually appealing display with a picture frame effect.

## Error Handling
- Displays an error icon if an image fails to load.
- Logs errors when the API request fails.
- Shows a message when no images are available.

## Screenshots

