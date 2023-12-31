import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practical/detailsPage.dart';
import 'package:flutter_practical/destinationServices.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Destination>> futureDestinations;

  @override
  void initState() {
    super.initState();
    futureDestinations = DestinationService().getDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Tours Page")),
        body: Center(
          child: FutureBuilder<List<Destination>>(
            future: futureDestinations,
            initialData: [],
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      Destination destination = snapshot.data![index];
                      // convert destination name to utf 8
                      var destinationName = utf8
                          .decode(destination.destinationName.runes.toList());
                      return ListTile(
                        leading:
                            Image.network(destination.destinationThumbnail),
                        title: Text(destinationName),
                        subtitle:
                            Text('Rating:${destination.destinationRating}'),
                        onTap: () {
                          openPage(context, destination);
                        },
                      );
                    },
                    separatorBuilder: ((context, index) {
                      return const Divider(color: Colors.black26);
                    }),
                    itemCount: snapshot.data!.length);
              } else if (snapshot.hasError) {
                return Text('ERROR: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
          ),
        ));
  }

  openPage(context, Destination destination) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailsPage()));
  }
}
