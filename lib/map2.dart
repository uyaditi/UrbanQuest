import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

// A callback to notifiy the hosting widget.
typedef ShowDialogFunction = void Function(String title, String message);

class MapItemsExample {
  final HereMapController _hereMapController;
  List<MapMarker> _mapMarkerList = [];
  MapImage? _poiMapImage;

  MapItemsExample(HereMapController hereMapController)
      : _hereMapController = hereMapController {
    double distanceToEarthInMeters = 8000;
    MapMeasure mapMeasureZoom =
    MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
    _hereMapController.camera.lookAtPointWithMeasure(
        GeoCoordinates(19.0760, 72.8777), mapMeasureZoom);
  }

  void showAnchoredMapMarkers(GeoCoordinates inputGeoCoordinates) {
    _unTiltMap();

    // take input geocordinates
    GeoCoordinates geoCoordinates = inputGeoCoordinates;

    _addPOIMapMarker(geoCoordinates, 1);
  }

  Future<void> _addPOIMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('assets/poi.png');
      _poiMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
    MapMarker.withAnchor(geoCoordinates, _poiMapImage!, anchor2D);
    mapMarker.drawOrder = drawOrder;

    // Metadata metadata = Metadata();
    // metadata.setString("key_poi", "Metadata: This is a POI.");
    // mapMarker.metadata = metadata;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }

  Future<Uint8List> _loadFileAsUint8List(String assetPathToFile) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load(assetPathToFile);
    return Uint8List.view(fileData.buffer);
  }

  void _unTiltMap() {
    double bearing =
        _hereMapController.camera.state.orientationAtTarget.bearing;
    double tilt = 0;
    _hereMapController.camera
        .setOrientationAtTarget(GeoOrientationUpdate(bearing, tilt));
  }
}