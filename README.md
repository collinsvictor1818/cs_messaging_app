# CS Messaging Web App
Welcome to the CS Messaging Web App project! This application is built using Flutter and Firestore to streamline customer inquiries for Branch.
![CS](https://github.com/collinsvictor1818/cs_messaging_app/assets/42299025/d561d367-204a-4179-aa8c-6c6ea3c13f41)


### Installation Process
To install and run the CS Messaging Web App on your local machine, follow these steps:

#### Prerequisites
- Flutter SDK installed on your machine. You can download it from the [official Flutter website](https://flutter.dev/docs/get-started/install).
- A Firebase project set up with Firestore enabled. You can create one through the [Firebase Console](https://console.firebase.google.com/).
- Git installed for cloning the repository (optional).

#### Installation Steps
1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/your-repo-name/cs-messaging-web-app.git
    ```

2. Navigate to the project directory:
    ```bash
    cd cs-messaging-web-app
    ```

3. Install dependencies using Flutter:
    ```bash
    flutter pub get
    ```

4. Configure Firebase for Flutter by following the instructions provided by Firebase. This typically involves downloading `google-services.json` and placing it in the appropriate directory of your Flutter project.

5. Run the app on your preferred device or simulator:
    ```bash
    flutter run
    ```

6. Access the app through your device or simulator to start using the CS Messaging Web App.
7. 
#### Additional Configuration
- Ensure that Firestore rules are configured to allow read and write access to your database as per your application's requirements.
- If you encounter any issues during installation or configuration, refer to the Flutter and Firebase documentation for troubleshooting tips and solutions.

## Completed Features:
1. **Basic Messaging Functionality**: Agents can log in and respond to customer inquiries.
2. **Storage of Messages**: Customer messages are stored in Firestore database.
3. **View and Respond**: Agents can view and respond to individual messages.
4. **Hosting**: The application is hosted on Firebase for easy access.
5. **Video and Code Walkthrough**: Included a video demonstrating the application's functionality and a code walkthrough.

## Features Attempted:
1. **Search Functionality**: Work in progress. Implementing Firestore queries for message and customer search.
2. **Customer Information Display**: Integrating Firestore to display additional customer context.

## Features Yet to Attempt:
1. **Work Division Scheme**: Develop a system to distribute workload among agents effectively.
2. **Urgent Message Flagging**: Implement a method to prioritize urgent messages for prompt attention.

## Next Steps:
1. **Complete Search Functionality**: Prioritize completing the search feature to enhance agent efficiency.
2. **Enhance Customer Information Display**: Provide comprehensive customer profiles for better context.
3. **Implement Work Division Scheme**: Develop a system to distribute workload evenly among agents.
4. **Urgent Message Flagging**: Designate a method for agents to identify and respond to urgent inquiries promptly.

## Deployment:
The application is deployed and accessible at: [CS Messaging Web App](https://cs-messaging-app-9773d.web.app/)

## Feedback and Support:

If you encounter any issues or have feedback, feel free to [open an issue](https://github.com/your-repo-name/issues). Your contributions are greatly appreciated!

