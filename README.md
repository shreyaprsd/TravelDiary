# Travel Diary 📱✈️

A comprehensive iOS trip planning application that helps users organize their travels, manage expenses, and preserve memories all in one place.

## Overview

Travel Diary is designed to be your ultimate travel companion, offering a seamless experience for planning trips, tracking expenses with real-time currency conversion, and documenting your adventures. Whether you're planning your next getaway or reminiscing about past journeys, Travel Diary keeps everything organized and accessible.

## Key Features

### 🗺️ Trip Management
- **Trip Organization**: Create and manage multiple trips with detailed information
- **Smart Trip List**: View all your trips with destination, dates, budget, and status
- **Trip Search**: Quickly find trips by filtering through destination names
- **Status Tracking**: Monitor trip progress with Planned or Completed status indicators

### 💰 Budget & Expense Tracking
- **Budget Planning**: Set estimated budgets for each trip
- **Expense Monitoring**: Track spending with comprehensive budget summaries
- **Real-time Currency Conversion**: Built-in currency calculator using live exchange rates
- **Financial Overview**: Clear breakdown of total budget, spent amount, and remaining funds

### 📝 Activity & Itinerary Management
- **Day-by-day Planning**: Organize activities by specific trip days
- **Activity Details**: Record activity titles, visit times, locations, and personal notes
- **Flexible Scheduling**: Easy-to-use interface for adding and managing activities
- **Location Tracking**: Store specific place names and locations for each activity

### 🗺️ Interactive Maps
- **MapKit Integration**: Visual trip planning with interactive maps
- **World Map Visualization**: Track your travel progress on a world map
- **Location Context**: Enhanced trip planning with geographical awareness

### 📱 User Experience
- **Multi-tab Interface**: Intuitive navigation across Trip List, Map, Profile, and Share sections
- **Firebase Authentication**: Secure user accounts and data synchronization
- **Network Status**: Real-time connectivity indicators
- **Social Sharing**: Share your travel experiences and recommend the app to friends

### 💾 Data Management
- **SwiftData Integration**: Efficient local data storage and management
- **Firebase Firestore**: Cloud synchronization for photos and trip details
- **Cross-device Sync**: Access your data across multiple devices

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
- **API Endpoint**: `https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/BASE/TARGET/AMOUNT`

### Data Models
- **Trip Model**: Destination, dates, budget, status, activities
- **Activity Model**: Title, time, location, notes, day association
- **User Model**: Profile information, travel statistics
- **Expense Model**: Amount, currency, category, date

## App Structure

### Main Navigation
1. **Trip List Tab**: Primary trip management interface
2. **Map Tab**: Interactive geographical planning tools
3. **Profile Tab**: User statistics and world map progress
4. **Share Tab**: Social features and app promotion

## Installation & Setup

### Prerequisites
- iOS 15.0+
- Xcode 14.0+
- Firebase project setup
- ExchangeRate API key

### Configuration
1. Clone the repository
2. Configure Firebase with your project
3. Add your ExchangeRate API key
4. Build and run on iOS device or simulator

## Privacy & Security

- Secure Firebase Authentication
- Encrypted data transmission
- Local data protection with SwiftData
- Privacy-focused design principles

## Support & Feedback

Travel Diary is designed to make trip planning and memory keeping effortless. Whether you're a frequent traveler or planning your first adventure, the app adapts to your needs with intuitive design and powerful features.

---

*Built with ❤️ for travelers who want to make the most of their journeys*
