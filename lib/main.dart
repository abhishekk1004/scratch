import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch/constants/colors.dart';
import 'package:scratch/repo/product_repo.dart';
import 'package:scratch/repo/product_repo_impl.dart';
import 'package:scratch/view/home_screen.dart';
import 'package:scratch/viewmodels/product_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductRepo>(create: (_) => ProductRepoImpl()),
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(
            productRepo: context.read<ProductRepo>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: black),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
