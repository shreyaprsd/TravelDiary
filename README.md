# Travel Diary 📱✈️

A comprehensive iOS trip planning application that helps users organize their travels, manage expenses, and preserve memories all in one place.

## Overview

Travel Diary is designed to be your ultimate travel companion, offering a seamless experience for planning trips, tracking expenses with real-time currency conversion, and documenting your adventures. Whether you're planning your next getaway or reminiscing about past journeys, Travel Diary keeps everything organized and accessible.

## Key Features

### 🗺️ Trip Management
- **Trip Organization**: Create and manage multiple trips with detailed information
- **Smart Trip List**: View all your trips with destination, dates, budget, and status
- **Status Tracking**: Monitor trip progress with Planned or Completed status indicators

### 💰 Budget & Expense Tracking
- **Budget Planning**: Set estimated budgets for each trip
- **Expense Monitoring**: Track spending with comprehensive budget summaries
- **Real-time Currency Conversion**: Built-in currency calculator using live exchange rates
- **Financial Overview**: Clear breakdown of total budget, spent amount, and remaining funds

### 🗺️ Interactive Maps
- **MapKit Integration**: Visual trip planning with interactive maps

### 📱 User Experience
- **Multi-tab Interface**: Intuitive navigation across Home, Profile, and Currency sections
- **Firebase Authentication**: Secure user accounts and data synchronization

### 💾 Data Management
- **SwiftData Integration**: Efficient local data storage and management
- **Firebase Firestore**: Cloud synchronization for photos and trip details


## Technical Architecture

### Frontend
- **Platform**: iOS (SwiftUI)
- **Local Storage**: SwiftData for core data persistence
- **Maps**: MapKit for geographical features
- **UI Framework**: Modern SwiftUI components with responsive design

### Backend & APIs
- **Authentication**: Firebase Authentication
- **Database**: Firebase Firestore for cloud data storage
- **Currency Data**: ExchangeRate API for real-time currency conversion
- **API Endpoint**: `https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/BASE/TARGET/AMOUNT

## Installation & Setup

### Prerequisites
- iOS 15.0+
- Xcode 14.0+
- Firebase project setup
- ExchangeRate API key
 
### Configuration
1. Clone the repository
2. Configure Firebase with your project. Download the GoogleServices-Info.plist to the root of your project.
3. Add your ExchangeRate API key
4. Install Firebase SDK and the Google sign-in SDK in Xcode. Below are the links to the SDK
    https://github.com/firebase/firebase-ios-sdk
    https://github.com/google/GoogleSignIn-iOS
6. Build and run on an iOS device or simulator



