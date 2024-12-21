import 'package:deep_link_client/deep_link_client.dart';
import 'package:drift_storage/drift_storage.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_deep_link_client/firebase_deep_link_client.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/main/bootstrap/bootstrap.dart';
import 'package:zimble/src/version.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';


void main() {
  bootstrap(
        (
        firebaseDynamicLinks,
        firebaseMessaging,
        sharedPreferences,
        analyticsRepository,
        ) async {
      final tokenStorage = InMemoryTokenStorage();

      const permissionClient = PermissionClient();

      final driftStorage = AppDatabase();

      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

      final packageInfoClient = PackageInfoClient(
        appName: 'Zimble [DEV]',
        packageName: 'com.zimble.example.dev',
        packageVersion: packageVersion,
      );

      final deepLinkService = DeepLinkService(
        deepLinkClient: FirebaseDeepLinkClient(
          firebaseDynamicLinks: firebaseDynamicLinks,
        ),
      );

      final userStorage = UserStorage(storage: persistentStorage);

      final authenticationClient = FirebaseAuthenticationClient(
        tokenStorage: tokenStorage,
      );

      final notificationsClient = FirebaseNotificationsClient(
        firebaseMessaging: firebaseMessaging,
      );

      final userRepository = UserRepository(
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkService: deepLinkService,
        storage: userStorage,
      );


      final notificationsRepository = NotificationsRepository(
        permissionClient: permissionClient,
        storage: NotificationsStorage(storage: persistentStorage),
        notificationsClient: notificationsClient,
      );


      final bluetoothReaderClient = BluetoothReaderClient();
      final networkReaderClient = NetworkReaderClient();
      final usbReaderClient = UsbReaderClient();

      final readerClient = ReaderClient(
          bluetoothReaderClient: bluetoothReaderClient,
          networkReaderClient: networkReaderClient,
          usbReaderClient: usbReaderClient
      );

      final readerRepository = ReaderRepository(
        readerClient: readerClient,
        storage: driftStorage,
      );

      return App(
        userRepository: userRepository,
        readerRepository: readerRepository,
        notificationsRepository: notificationsRepository,
        analyticsRepository: analyticsRepository,
        user: await userRepository.user.first,
      );
    },
  );
}
