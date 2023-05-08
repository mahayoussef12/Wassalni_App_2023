import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/Weather/ui/widgets/main_screen/main_screen_model.dart';
import 'package:wassalni/Weather/ui/widgets/main_screen/main_screen_widget.dart';


class weather extends StatelessWidget {
  const weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => MainScreenModel(),
          lazy: false,
          child: const MainScreenWidget(),
        ),
      ),
    );
  }
}
