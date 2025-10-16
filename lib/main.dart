import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/archive_bloc.dart';
import 'blocs/archive_event.dart';
import 'data/models/archive_model.dart';
import 'data/repositories/archive_repository.dart';
import 'screens/login_screen.dart';
import 'screens/archives_screen.dart';
import 'screens/add_edit_archive_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArchiveModelAdapter());

  // ✅ Open the box before running the app
  await Hive.openBox<ArchiveModel>('archives');

  // ✅ Create repository and run app
  final repository = ArchiveRepository();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ArchiveRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchiveBloc(repository)..add(LoadArchives()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Archives',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/archives': (context) => const ArchivesScreen(),
        },
      ),
    );
  }
}
