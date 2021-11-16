import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RefreshProgressIndicator(),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Carregando...",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6?.color),
              )
            ],
          ),
        ));
  }
}
