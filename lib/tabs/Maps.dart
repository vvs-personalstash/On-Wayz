import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController controllerParam;
  final LatLng _kMapCenter = const LatLng(25.2744, 133.7751);
  final List<Marker> _marker = <Marker>[];
  @override
  void initState() {
    //loadData();
    super.initState();
  }

  // loadData() async {
  //   {
  //     Uint8List image = await loadNetworkImage(['url']);
  //     final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
  //         image.buffer.asUint8List(),
  //         targetHeight: 150,
  //         targetWidth: 150);
  //     final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  //     final ByteData? byteData =
  //         await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  //     final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

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

  // Future<Uint8List> loadNetworkImage(path) async {
  //   final completed = Completer<ImageInfo>();
  //   var image = NetworkImage(path);
  //   image.resolve(const ImageConfiguration()).addListener(
  //       ImageStreamListener((info, _) => completed.complete(info)));
  //   final imageInfo = await completed.future;
  //   final byteData =
  //       await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData.buffer.asUint8List();
  // }

  // void _onMapCreated(GoogleMapController controllerParam) {
  //   setState(() {
  //     controller = controllerParam;
  //   });
  // }

  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        // ToDO: add markers
      ),
    );
  }
}
