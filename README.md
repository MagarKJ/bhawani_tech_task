# bhawani_tech_task

A new Flutter project.

## Getting Started

Before running the app, ensure that you have the following installed:

- Flutter
- Dart
- Android Studio (for Android development)

### Steps

1. Clone the repository: `https://github.com/MagarKJ/bhawani_tech_task`
2. Add `adminsdk.json` to the `assets/adminsdk` folder (provided via email).
3. Run `flutter pub get`.

### Features and Architecture

1. **Firebase Integration**
   - Authentication: Firebase is used for user authentication.
   - Firestore: User information and expense data are stored in Firebase Firestore.
   - Push Notifications: Firebase Cloud Messaging (FCM) is implemented to notify employees when there is a state change in their application.

2. **Local Storage**
   - SQLite: Used to store expense details locally.
   - Shared Preferences: Used to store user information locally.

3. **User Roles**
   - Employee: Can add expenses and get notified when there is a state change in their application.
   - Manager: Can change the state of applications and filter them.
   - Admin: Can view applications, filter them, generate reports, and download the reports in PDF format.

4. **Image Storage**
   - Initially, Firebase was considered for storing images, but it was moved to a paid tier. The app now uses Cloudinary for image storage, which provides more flexibility and free storage.

5. **Responsive Design**
   - The app is fully responsive and works on both small and large screen devices. Although the app is designed to support iOS devices, I currently do not own a Mac to build for iOS. However, I have experience building cross-platform apps.

6. **State Management: BLoC (Business Logic Component)**
   - For this project, I have chosen BLoC (Business Logic Component) as the state management solution. Here's why this approach is ideal:
     - **Separation of Concerns**: BLoC allows for clear separation between business logic and UI code, making the app easier to maintain and scale. UI components interact with the BLoC, which handles all the complex business logic and state transitions.
     - **Predictable State**: BLoC promotes a predictable state through explicit events and states. This makes it easier to debug and test the app, as the state transitions are clearly defined.
     - **Reusability**: Once a BLoC is created, it can be reused across the app for similar functionality. This allows for modularization and reduces code duplication.
     - **Scalability**: Given that the app involves multiple roles and states (Employee, Manager, Admin), I felt that BLoC would provide the necessary flexibility and control to manage the app's complex state transitions. I'm also comfortable with BLoC, and it’s a solution that I trust to handle the needs of this project.

### Conclusion

This project demonstrates a comprehensive approach to building a Flutter application with Firebase integration, local storage, responsive design, and state management using BLoC. By following the steps outlined in this README, you should be able to set up and run the application successfully. The architecture and features implemented in this project aim to provide a scalable and maintainable solution for managing expenses with different user roles. If you have any questions or need further assistance, feel free to reach out.