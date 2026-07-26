import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1️⃣ Solicitar permiso (parámetros nombrados)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('Permiso de notificaciones denegado');
      return;
    }

    // 2️⃣ Configurar canales para Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // ✅ CORRECCIÓN: Usar "settings:" como parámetro nombrado
    await _localNotifications.initialize(settings: initSettings);

    // 3️⃣ Escuchar mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensaje en primer plano: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // 4️⃣ Escuchar cuando el usuario toca la notificación (app en segundo plano)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notificación abierta: ${message.data}');
      _handleTap(message);
    });

    // 5️⃣ Obtener y guardar el token FCM
    String? token = await _fcm.getToken();
    debugPrint('FCM Token: $token');
    await _saveToken(token);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notificaciones de mensajes nuevos',
      importance: Importance.high,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: 0,
      title: message.notification?.title ?? 'Nuevo mensaje',
      body: message.notification?.body ?? 'Tienes un nuevo mensaje',
      notificationDetails: notificationDetails, // ✅ Cambio clave: 'details' → 'notificationDetails'
    );
  }

  static Future<void> _handleTap(RemoteMessage message) async {
    // Aquí puedes navegar al chat correspondiente
    // Ejemplo: final chatId = message.data['chatId'];
    debugPrint('Abrir chat con datos: ${message.data}');
    // TODO: Implementar navegación
  }

  static Future<void> _saveToken(String? token) async {
    if (token == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final DatabaseReference ref =
    FirebaseDatabase.instance.ref('usuarios/${user.uid}/fcmToken');
    await ref.set(token);
  }

  // Método para actualizar token (ej: después de login)
  static Future<void> updateToken() async {
    String? token = await _fcm.getToken();
    await _saveToken(token);
  }
}