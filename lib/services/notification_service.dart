
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'course_updates_channel',
    'Course Updates',
    description: 'Notifikasi pembaruan Course Data Manager',
    importance: Importance.max,
  );

  // Inisialisasi notifikasi lokal
  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    debugPrint('Local notification berhasil diinisialisasi');
  }

  // Meminta izin notifikasi
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: ${settings.authorizationStatus}',
    );
  }

  // Mendengarkan Firebase Installation ID
  void listenRegistration() {
    _messaging.onRegistered.listen(
      (installationId) {
        debugPrint('Firebase Installation ID: $installationId');
      },
      onError: (error) {
        debugPrint('Gagal mendapatkan Installation ID: $error');
      },
    );
  }

  // Menampilkan notifikasi
  Future<void> showNotification(RemoteMessage message) async {
    final title =
        message.notification?.title ?? 'Course Data Manager';

    final body =
        message.notification?.body ?? 'Ada pembaruan baru';

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );

    debugPrint('NOTIFIKASI BERHASIL DITAMPILKAN');
    debugPrint('Judul: $title');
    debugPrint('Pesan: $body');
  }

  // Menerima pesan saat aplikasi terbuka
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        debugPrint('FOREGROUND NOTIFICATION DITERIMA');
        await showNotification(message);
      },
      onError: (error) {
        debugPrint('Error foreground notification: $error');
      },
    );
  }

  // Berlangganan topic
  Future<void> subscribeToTopic() async {
    try {
      await _messaging.subscribeToTopic('course_updates');
      debugPrint(
        'Berhasil berlangganan topic course_updates',
      );
    } catch (e) {
      debugPrint('Gagal berlangganan topic: $e');
    }
  }

  // Inisialisasi layanan
  Future<void> init() async {
    await requestPermission();
    await initializeLocalNotifications();

    listenRegistration();
    listenForegroundMessages();

    await _messaging.register();
    await subscribeToTopic();

    debugPrint('Notification Service siap digunakan');
  }
}
