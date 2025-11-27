// lib/main.dart

import 'package:flutter/material.dart';
import 'package:estante/src/app_config.dart';
import 'package:estante/src/shared/services/prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estante/src/features/home/data/repositories/book_repository_impl.dart'; 
import 'package:estante/src/features/home/domain/repositories/book_repository.dart'; 


final PrefsService prefsService = PrefsService();
late final BookRepository bookRepository; 
bool isDependenciesInitialized = false; 

Future<void> initializeDependencies() async {
  if (isDependenciesInitialized) return;

  final sharedPreferences = await SharedPreferences.getInstance();
  
  await prefsService.init(sharedPreferences);
  bookRepository = BookRepositoryImpl(sharedPreferences: sharedPreferences);
  
  isDependenciesInitialized = true;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppConfig();
  }
}