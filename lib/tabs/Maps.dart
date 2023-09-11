import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:on_ways/Networking/location.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:custom_marker/marker_icon.dart';
import '../Providers/User.dart';
import '../Widgets/BottomModalSheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController controllerParam;
  List<Marker> markers = <Marker>[];
  double radius = 50;
  @override
  void initState() {
    //loadData();
    super.initState();
    Initialize();
  }

  Future<void> Initialize() async {
    await Location().getCurrentLocation();
    print(1);
    _getUserLocation();
  }

  Future<List<DocumentSnapshot>> fetchNearbyUserLocations() async {
    final geo = GeoFlutterFire();
    Users user = Provider.of<Users>(context, listen: false);
    print(user.id);
    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('User-Data')
      ..where(FieldPath.documentId, isNotEqualTo: user.id);
    final GeoFirePoint center = geo.point(
        latitude: context.read<Location>().latitudeoflocation!,
        longitude: context.read<Location>().longitudeoflocation!);

    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: userCollection).within(
              center: center,
              radius: radius, // Set your desired radius here
              field:
                  'Last Location', // Change to the field containing the location data
              strictMode: true,
            );
    print(1);
    List<DocumentSnapshot> querySnapshot = await stream.first;
    return querySnapshot;
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      controllerParam = controller;
    });
  }

  // Future<Uint8List> loadNetworkImage(path) async {
  //   final completed = Completer<ImageInfo>();
  //   var image = NetworkImage(path);
  //   image.resolve(const ImageConfiguration()).addListener(
  //       ImageStreamListener((info, _) => completed.complete(info)));
  //   final imageInfo = await completed.future;
  //   final byteData =
  //       await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData!.buffer.asUint8List();
  // }

  // void _onMapCreated(GoogleMapController controllerParam) {
  //   setState(() {
  //     controller = controllerParam;
  //   });
  // }

  Future<void> _getUserLocation() async {
    Users user = Provider.of<Users>(context, listen: false);
    // Uint8List image = await loadNetworkImage(user.image);
    // final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
    //     image.buffer.asUint8List(),
    //     targetHeight: 150,
    //     targetWidth: 150);
    // final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    // final ByteData? byteData =
    //     await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    // final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
    BitmapDescriptor customMarker =
        await MarkerIcon.downloadResizePictureCircle(
      user.image,
      size: 200,
      addBorder: true,
      borderColor: Colors.pinkAccent.withOpacity(0.7),
      borderSize: 30,
    );
    print(user.Location.latitude);
    setState(() {
      markers.add(
        Marker(
          zIndex: 10,
          markerId: MarkerId(user.id),
          position: LatLng(user.Location.latitude, user.Location.longitude),
          icon: customMarker,
          onTap: () {},
        ),
      );
      print(1);
    });

    List<DocumentSnapshot<Object?>> nearbyUserLocations =
        await fetchNearbyUserLocations();
    nearbyUserLocations.forEach((userDoc) async {
      print(userDoc.id);
      if (userDoc.id != user.id) {
        GeoPoint location = userDoc['Last Location']['geopoint'];
        double latitude = location.latitude;
        double longitude = location.longitude;
        print(location);
        String username = userDoc['UserName'];
        String userid = userDoc.id;
        var Age = userDoc['age'];
        String image = userDoc['Photo'];
        // Uint8List images = await loadNetworkImage(image);
        // final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        //     images.buffer.asUint8List(),
        //     targetHeight: 150,
        //     targetWidth: 150);
        // final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
        // final ByteData? byteData =
        //     await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
        // final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
        BitmapDescriptor customMarker =
            await MarkerIcon.downloadResizePictureCircle(
          image,
          size: 200,
          addBorder: true,
          borderColor: Colors.white,
          borderSize: 30,
        );
        setState(() {
          markers.add(
            Marker(
                markerId: MarkerId(userid), // Use a unique marker ID
                position: LatLng(latitude, longitude),
                icon: customMarker,
                infoWindow: InfoWindow(title: username),
                draggable: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      insetPadding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 30),
                      clipBehavior: Clip.hardEdge,
                      titlePadding: EdgeInsets.only(
                          top: 20, bottom: 5, left: 20, right: 5),
                      actionsAlignment: MainAxisAlignment.start,
                      actionsPadding: EdgeInsets.only(left: 5, right: 0),
                      title: Container(
                        width: 50,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(image),
                                    radius: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${username}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Color(0xFF1d2d59),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$Age years old',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Color.fromARGB(97, 75, 74, 74),
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(25, 28, 77, 1),
                                ),
                                onPressed: () {
                                  Users user = Provider.of<Users>(context,
                                      listen: false);
                                  final _firestore = FirebaseFirestore.instance;
                                  _firestore
                                      .collection('User-Data')
                                      .doc(userid)
                                      .collection('Requests')
                                      .add({
                                        'author': user.name,
                                        'image': user.image,
                                        'time': DateTime.now(),
                                      })
                                      .then((value) => print("Request Added"))
                                      .catchError((error) => print(
                                          "Failed to send Request: $error"));

                                  Navigator.pop(context, 'Request sent');
                                },
                                child: const Text('Send Request'))
                          ],
                        ),
                      ),
                    ),
                  ).then((value) => {
                        if (value != null)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$value succesful'),
                              action:
                                  SnackBarAction(label: 'OK', onPressed: () {}),
                            ))
                          }
                      });
                }),
          );
          print(1);
        });
      }
    });
  }

  var db = FirebaseFirestore.instance;
  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        toolbarHeight: 90,
        leadingWidth: 70,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            await Location().getCurrentLocation();
            final geo = GeoFlutterFire();
            Location location = Provider.of(context, listen: false);
            GeoFirePoint myLocation = geo.point(
                latitude: location.latitudeoflocation!,
                longitude: location.longitudeoflocation!);
            db
                .collection("User-Data")
                .doc(user.id)
                .update({"Last Location": myLocation.data}).then(
                    (value) => print("Location successfully updated!"),
                    onError: (e) => print("Error updating Location $e"));
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.pink.shade300,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child:
                Icon(Icons.location_on_rounded, color: Colors.white, size: 30),
          ),
        ),
        title: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Text(
              'People Nearby',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(25, 28, 77, 1),
                  ),
            ),
            SizedBox(height: 7),
            Text(
              'Gwalior',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 15,
                    color: Color.fromRGBO(13, 13, 14, 0.445),
                  ),
            )
          ]),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  context: context,
                  builder: ((context) => SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomAddTaskk(
                          voidCallback: (radiusnew) {
                            setState(() {
                              radius = radiusnew;
                            });
                          },
                          radius: radius,
                        ),
                      )));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(10),
              child: Icon(Icons.settings_input_component,
                  color: Colors.white, size: 23),
            ),
          ),
        ],
      ),
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
