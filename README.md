# **Mahila Mitra**

**Mahila Mitra** is a mobile application dedicated to the safety and empowerment of women across the nation.

*Our mission: To provide every sister of this country with a reliable companion in moments of emergency.*

---

## **Project Motive**

Safety is a fundamental right, not a privilege.
**Mahila Mitra** bridges technology and security by providing instant emergency alerts, real-time location tracking, and trusted support.
More than an app, it is a *pledge to protect dignity, preserve lives, and empower women everywhere.*

---

## Key Features

* **SOS Trigger**: One-tap distress alert to notify emergency contacts instantly.
* **Live Location Sharing**: Real-time location tracking to ensure help reaches without delay.
* **Dedicated Emergency Response**: Seamless integration with response services for immediate action.
* **Safe Zone Identification**: Locates nearby safe areas such as police stations, hospitals, or trusted landmarks.

---

## **App Capabilities**

### **1. Authentication & Security**

| Feature                | Description                                                               |
| ---------------------- | ------------------------------------------------------------------------- |
| **Sign In / Sign Up**  | Email + strong password authentication; phone verification ensures trust. |
| **Email Verification** | Prevents bots and duplicate accounts.                                     |
| **Data Protection**    | Firestore security rules maintain privacy & access control.               |

### **2. Permissions & Access Control**

| Permission   | Purpose                                    |
| ------------ | ------------------------------------------ |
| **Location** | Required for SOS alerts and live tracking. |
| **Phone**    | Required for emergency call assistance.    |

### **3. Real-Time Data Integrity**

* Real-time updates synchronize SOS alerts, location changes, and response activities instantly.
* Firestore ensures sensitive user data is strictly access-controlled.

---

## **Tools & Technologies**

| Category                 | Technology / Service                        |
| ------------------------ | ------------------------------------------- |
| **Framework & Language** | Flutter SDK (Dart)                          |
| **Build System**         | Gradle                                      |
| **Backend**              | Firebase Authentication, Firestore Database |
| **Communication**        | Twilio (Emergency alerts via call/SMS)      |
| **Version Control**      | Git + GitHub                                |

---

## **Setup & Installation**

### **Prerequisites**

* Flutter SDK ([Flutter Setup Guide](https://docs.flutter.dev/get-started/install))
* Android Studio or VS Code with Flutter & Dart plugins
* Firebase project configured with Authentication and Firestore enabled
* Twilio account with verified phone number

### **Steps**

1. **Clone Repository**

   ```bash
   git clone https://github.com/your-username/mahila-mitra.git
   cd mahila-mitra
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment Setup**

    * Create a `.env` file at the project root with Firebase and Twilio credentials.
    * Place `google-services.json` under `android/app/`.

4. **Run Application**

   ```bash
   flutter run
   ```
---

## File Structure 
```bash
lib
├── home
│   ├── home.dart
│   └── screens
│       ├── about.dart
│       ├── card_list.dart
│       ├── dashboard.dart
│       ├── edit_contact.dart
│       ├── profile_screen.dart
│       ├── safe_zone.dart
│       └── settings.dart
├── main.dart
├── onboard
│   ├── onboard_content.dart
│   └── onboarding.dart
├── sign
│   ├── sign_in
│   │   └── sign_in.dart
│   └── sign_up
│       ├── credentials.dart
│       ├── med_info.dart
│       ├── user_entry.dart
│       └── verify_email.dart
├── utils
│   ├── firebase_options.dart
│   ├── firebase_service.dart
│   ├── form_validator.dart
│   ├── icons.dart
│   └── theme.dart
└── widgets
    ├── cards.dart
    ├── small_cards.dart
    ├── snackbar.dart
    └── svg_asset.dart
```
---
## Roadmap

* Multi-language support for broader accessibility
* AI-based safe zone recommendation
* Offline SOS with delayed sync
* Community-based trust circles

---

## **Disclaimer**

**Mahila Mitra is currently an academic project.**
While it incorporates real-time emergency features, it is not a substitute for professional security services.