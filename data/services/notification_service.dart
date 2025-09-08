import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/data/services/api_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService();

  Future<void> initialize() async {
    // Demander la permission pour les notifications
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialiser les notifications locales
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Configurer les notifications en arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Obtenir le token FCM et l'envoyer au serveur
    final token = await _messaging.getToken();
    if (token != null) {
      await _apiService.updateFcmToken(token);
    }

    // Écouter les changements de token
    _messaging.onTokenRefresh.listen((token) async {
      await _apiService.updateFcmToken(token);
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'matches_channel',
            'Matches',
            channelDescription: 'Notifications pour les nouveaux matches',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['profile_id']?.toString(),
      );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // TODO: Naviguer vers la page de match quand on clique sur la notification
    if (response.payload != null) {
      // Naviguer vers la page de match avec l'ID du profil
      // Utiliser GoRouter pour la navigation
    }
  }
}

// Cette fonction doit être définie en dehors de la classe car elle est appelée en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialiser Firebase si nécessaire
  // await Firebase.initializeApp();

  // Traiter le message en arrière-plan
  print('Message reçu en arrière-plan: ${message.messageId}');
}
