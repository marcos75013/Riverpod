import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_training/apprendre_consumers/consumer_widget.dart';

final imageProvider = Provider<String>((ref) => 'images/riverpod.png');
final iconProvider = Provider<IconData>((ref) => Icons.ac_unit);
final iconProviders2 = Provider<IconData>((ref) => Icons.access_alarm);
final countProvider = Provider<int>((ref) => 1);

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Consumer(builder: (context, ref, child) {
            final imageString = ref.watch(imageProvider);
            return Image.asset(
              imageString,
              height: MediaQuery.of(context).size.height / 3,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer(builder: (context, ref, child) {
                final iconData = ref.watch(iconProvider);
                return Icon(
                  iconData,
                  size: 62,
                  color: Colors.amberAccent,
                );
              }),
              Consumer(builder: (context, ref, _) {
                final iconData2 = ref.watch(iconProviders2);
                return Icon(
                  iconData2,
                  size: 62,
                  color: Colors.deepPurpleAccent,
                );
              }),
            ],
          ),
          Consumer(builder: (context, ref, _) {
            return Text(ref.watch(myFirstProvider));
          }),
          Consumer(builder: (context, ref, _) {
            final countData = ref.watch(countProvider);
            return Text(countData.toString());
          }),
        ],
      ),
    );
  }
}
