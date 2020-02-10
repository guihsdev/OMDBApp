import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:omdbapp/pages/home/home.dart';
import 'package:omdbapp/stores/omdb_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  // Para conservar a orientação da tela
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OMDB App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: HomePage(),
          // Suporte ao tratamento do sistema e peculiaridades dos Widgets
          supportedLocales: [
            // Informo o tipo de Idioma que estou trabalhando
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: [
            // Requisito que o sistema me traga textos no idioma informado em 'supportedLocales'
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
        // Provider onde está concentrado minha estrutura de dados
        providers: <SingleChildWidget>[
          Provider<OmdbStore>(
            create: (_) => OmdbStore(),
          )
        ]);
  }
}
