import 'package:flutter/material.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(79, 70, 229, 1),
        title: const Text('Chaudière'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Ajouter la fonctionnalité de recherche
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Ajouter la fonctionnalité de filtrage
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Liste des événements à venir ici',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
