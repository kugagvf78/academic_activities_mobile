# Academic Competition Management System – Mobile App

## Overview

This repository contains the **mobile application** of the _Academic Competition Management System_.

The mobile app is designed for **students and lecturers** to conveniently access academic competition information, register for competitions, submit entries, and track results.

This application **does not manage the database directly**.  
All data is provided via **RESTful APIs** from the backend web system.

---

## System Architecture

- **Mobile App:** Client-side application
- **Backend:** Web-based Academic Competition Management System
- **Database:** Managed entirely by the backend system

Backend Repository:  
👉 https://github.com/kugagvf78/academic_competition_system

---

## Main Features

### For Students

- View academic competitions
- Register for competitions (individual or team)
- Submit competition entries
- View results and rankings

### For Lecturers

- View assigned competitions
- Evaluate submissions
- Track competition progress

---

## Technology Stack

- **Platform:** Android / iOS
- **Framework:** Flutter
- **Language:** Dart
- **API Communication:** RESTful API (JSON)
- **Authentication:** JWT / Session-based (via backend)

---

## Setup & Run Application

```bash
# Prerequisites
# - Flutter SDK
# - Android Studio / Xcode
# - Emulator or physical device

# Configuration
API_BASE_URL=http://localhost:8000/api

# Install dependencies
flutter pub get

# Run application
flutter run
```
