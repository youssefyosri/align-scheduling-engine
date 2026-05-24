# Align: Real-Time Scheduling Engine

[![Watch the Align Demo](https://github.com/user-attachments/assets/b2acdba6-d9b3-411a-b8b4-378b989d8c29)](https://youtu.be/YOUR-UNLISTED-LINK)

## Overview
Align is a scheduling engine built to solve a founder’s worst nightmare: data desyncs and double-bookings. This project was stress-tested across concurrent emulator sessions to prove that the backend architecture can handle parallel read/writes and resolve global availability states flawlessly.

## Technical Execution
* **Zero-Latency Syncing:** Engineered bidirectional data streams to ensure that when a user updates a time slot on Device A, it reflects instantly on Device B.
* **Concurrent State Resolution:** Built the backend logic to process simultaneous booking attempts without conflicting database writes.
* **Composite Indexing:** Optimized the database queries with composite indexing, allowing the dashboard to retrieve and snap complex user datasets into place instantly without loading spinners.

## Tech Stack
* **Frontend:** Flutter
* **State Management:** Riverpod
* **Backend:** Firebase Cloud Firestore
* **Sync Protocol:** Real-time WebSockets

---

### Local Development Setup
> **Security Note:** Firebase configuration files (`firebase_options_dev.dart` and `firebase_options_prod.dart`) have been intentionally excluded from this repository to protect production API keys. 
>
> To run this project locally:
> 1. Initialize your own Firebase project.
> 2. Run `flutterfire configure` in the terminal to generate your local configuration files.
> 3. Run `flutter run`.
