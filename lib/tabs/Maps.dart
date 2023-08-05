import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:on_ways/Networking/location.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../Providers/User.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController controllerParam;
  final LatLng _kMapCenter = const LatLng(25.2744, 133.7751);
  List<Marker> markers = <Marker>[];
  @override
  void initState() {
    //loadData();
    super.initState();
    Location().getCurrentLocation();
    _getUserLocation();
  }

  Future<List<DocumentSnapshot>> fetchNearbyUserLocations() async {
    final geo = GeoFlutterFire();
    Users user = Provider.of<Users>(context, listen: false);
    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('user-data')
      ..where(FieldPath.documentId, isNotEqualTo: user.id);
    final GeoFirePoint center = geo.point(
        latitude: user.Location.latitude, longitude: user.Location.longitude);

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: userCollection)
        .within(
          center: center,
          radius: 50, // Set your desired radius here
          field: 'location', // Change to the field containing the location data
          strictMode: true,
        );

    List<DocumentSnapshot> querySnapshot = await stream.first;
    return querySnapshot;
  }

  Future<Uint8List> loadNetworkImage(path) async {
    final completed = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completed.complete(info)));
    final imageInfo = await completed.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // void _onMapCreated(GoogleMapController controllerParam) {
  //   setState(() {
  //     controller = controllerParam;
  //   });
  // }
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      controllerParam = controller;
    });
  }

  Future<void> _getUserLocation() async {
    Users user = Provider.of<Users>(context, listen: false);
    Uint8List image = await loadNetworkImage(user.image);
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 150,
        targetWidth: 150);
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(user.id),
          position: LatLng(user.Location.latitude, user.Location.longitude),
          icon: BitmapDescriptor.fromBytes(resizedImageMarker),
        ),
      );
    });

    List<DocumentSnapshot<Object?>> nearbyUserLocations =
        await fetchNearbyUserLocations();
    List<Marker> restmarkers = [];
    nearbyUserLocations.forEach((userDoc) async {
      GeoPoint location = userDoc['location'];
      double latitude = location.latitude;
      double longitude = location.longitude;
      String username = userDoc['username'];
      String userid = userDoc.id;
      String image = userDoc['image'];
      Uint8List images = await loadNetworkImage(user.image);
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          images.buffer.asUint8List(),
          targetHeight: 150,
          targetWidth: 150);
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
      restmarkers.add(
        Marker(
          markerId: MarkerId(userid), // Use a unique marker ID
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.fromBytes(resizedImageMarker),
          infoWindow: InfoWindow(title: username),
        ),
      );
    });
    setState(() {
      markers.addAll(restmarkers);
    });
  }

  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(context.read<Location>().latitudeoflocation!,
              context.read<Location>().longitudeoflocation!),
          zoom: 14,
        ),
        markers: markers.toSet(),
      ),
    );
  }
}
  // loadData() async {
  //   {
  //  Uint8List image = await loadNetworkImage(['url']);
  // final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
  //     image.buffer.asUint8List(),
  //     targetHeight: 150,
  //     targetWidth: 150);
  // final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  // final ByteData? byteData =
  //     await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  // final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

  //     _marker.add(Marker(
  //         markerId: MarkerId(),
  //         icon: BitmapDescriptor.fromBytes(resizedImageMarker),
  //         position: LatLng(
  //           element['lat'],
  //           element['lon'],
  //         ),
  //         infoWindow: InfoWindow(title: element["title"])));
  //   }
  //   setState(() {});
  // }