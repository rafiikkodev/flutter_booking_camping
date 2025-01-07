import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_booking_camping/models/camp.dart';

class BikeSource {
  static Future<List<Camp>?> fetchFeaturedBike() async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("Bikes")
          // .where("rating", isGreaterThan: 4.5)
          .orderBy("rating", descending: true);
      final queryDocs = await ref.get();

      for (var doc in queryDocs.docs) {
        print("Document ID: ${doc.id}");
        print("Data: ${doc.data()}");
      }

      return queryDocs.docs.map((doc) => Camp.fromJson(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<List<Camp>?> fetchNewestBike() async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("Bikes")
          .orderBy("release", descending: true)
          .limit(4);
      final queryDocs = await ref.get();
      return queryDocs.docs.map((doc) => Camp.fromJson(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<Camp?> fetchBike(String bikeId) async {
    try {
      final ref = FirebaseFirestore.instance.collection("Bikes").doc(bikeId);
      final doc = await ref.get();
      Camp? camp = doc.exists ? Camp.fromJson(doc.data()!) : null;
      return camp;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
