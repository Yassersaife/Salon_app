import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/salon_details.dart';
import 'package:salon_booking_app/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};
  final List<LatLng> _palestinianCities = [
    const LatLng(31.9522, 35.2332), // رام الله
    const LatLng(31.7683, 35.2137), // القدس
    const LatLng(32.2227, 35.2108), // نابلس
    const LatLng(31.5383, 35.0998), // الخليل
    const LatLng(32.4618, 35.2956), // جنين
    const LatLng(31.9032, 35.2039), // البيرة
    const LatLng(31.7038, 35.1951), // بيت لحم
    const LatLng(32.3211, 35.3691), // طوباس
    const LatLng(32.1921, 35.2542), // طولكرم
    const LatLng(31.4448, 34.3656), // غزة
    const LatLng(31.5379, 34.4644), // خان يونس
    const LatLng(31.5022, 34.4667), // رفح
    const LatLng(31.3546, 34.3088), // دير البلح
    const LatLng(31.2827, 34.2502), // بيت حانون
  ];

  final Map<String, String> _palestinianCityNames = {
    '31.9522,35.2332': 'رام الله',
    '31.7683,35.2137': 'القدس',
    '32.2227,35.2108': 'نابلس',
    '31.5383,35.0998': 'الخليل',
    '32.4618,35.2956': 'جنين',
    '31.9032,35.2039': 'البيرة',
    '31.7038,35.1951': 'بيت لحم',
    '32.3211,35.3691': 'طوباس',
    '32.1921,35.2542': 'طولكرم',
    '31.4448,34.3656': 'غزة',
    '31.5379,34.4644': 'خان يونس',
    '31.5022,34.4667': 'رفح',
    '31.3546,34.3088': 'دير البلح',
    '31.2827,34.2502': 'بيت حانون',
  };

  String _selectedCity = 'الكل';
  String _selectedArea = 'الكل';
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(31.9522, 35.2332), // رام الله كموقع مبدئي
    zoom: 9.0,
  );

  bool _isLoading = false;
  bool _isLocationGranted = false;
  double _searchRadius = 5.0; // نصف قطر البحث بالكيلومتر

  final List<String> _palestineCities = [
    'الكل',
    'رام الله',
    'القدس',
    'نابلس',
    'الخليل',
    'جنين',
    'البيرة',
    'بيت لحم',
    'طوباس',
    'طولكرم',
    'غزة',
    'خان يونس',
    'رفح',
    'دير البلح',
    'بيت حانون',
  ];

  final Map<String, List<String>> _cityAreas = {
    'رام الله': ['الكل', 'المنارة', 'الماصيون', 'البالوع', 'الطيرة', 'البيرة', 'عين مصباح'],
    'القدس': ['الكل', 'البلدة القديمة', 'الشيخ جراح', 'بيت حنينا', 'شعفاط', 'العيسوية', 'سلوان'],
    'نابلس': ['الكل', 'وسط البلد', 'رفيديا', 'المخفية', 'المساكن الشعبية', 'الضاحية', 'عسكر'],
    'الخليل': ['الكل', 'وسط البلد', 'وادي الهرية', 'عين سارة', 'نمرة', 'حارة الشيخ', 'الحاووز'],
    'غزة': ['الكل', 'الرمال', 'التفاح', 'الشجاعية', 'الزيتون', 'الصبرة', 'تل الهوى'],
    // يمكن إضافة مناطق لبقية المدن
  };

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();

    setState(() {
      _isLocationGranted = status.isGranted;
    });

    if (_isLocationGranted) {
      _getCurrentLocation();
    } else {
      // إذا لم يتم منح الإذن، نحمل الصالونات في رام الله افتراضياً
      _loadSalonsForCity('رام الله');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));

      // تحديد المدينة الأقرب للمستخدم
      String closestCity = _findClosestCity(position.latitude, position.longitude);
      setState(() {
        _selectedCity = closestCity;
        _selectedArea = 'الكل';
      });

      // تحميل الصالونات في المدينة الأقرب
      _loadSalonsForCity(closestCity);

    } catch (e) {
      print('Error getting current location: $e');
      // تحميل صالونات رام الله افتراضياً
      _loadSalonsForCity('رام الله');
    }
  }

  String _findClosestCity(double lat, double lng) {
    double minDistance = double.infinity;
    String closestCity = 'رام الله'; // افتراضي

    for (var cityLatLng in _palestinianCities) {
      double distance = Geolocator.distanceBetween(
          lat, lng, cityLatLng.latitude, cityLatLng.longitude
      );

      if (distance < minDistance) {
        minDistance = distance;
        String key = '${cityLatLng.latitude},${cityLatLng.longitude}';
        closestCity = _palestinianCityNames[key] ?? 'رام الله';
      }
    }

    return closestCity;
  }

  Future<void> _loadSalonsForCity(String city) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // في الإنتاج، سنستدعي مزود الصالونات لتحميل الصالونات حسب المدينة
      final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);
      await salonsProvider.fetchSalons();

      // نصفي الصالونات حسب المدينة
      final salons = salonsProvider.salons;
      List<Salon> filteredSalons = [];

      if (city == 'الكل') {
        filteredSalons = salons;
      } else {
        filteredSalons = salons.where((salon) =>
            _isSalonInCity(salon, city, _selectedArea)
        ).toList();
      }

      // نمركز الخريطة على المدينة المختارة
      _moveToCity(city);

      // ننشئ العلامات على الخريطة
      _createMarkers(filteredSalons);

    } catch (e) {
      print('Error loading salons for city: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isSalonInCity(Salon salon, String city, String area) {
    // في الإنتاج، سيكون هناك حقل للمدينة والمنطقة في نموذج الصالون
    // هنا نحاكي ذلك باستخدام العنوان
    bool inCity = salon.address.contains(city);
    if (area == 'الكل') {
      return inCity;
    } else {
      return inCity && salon.address.contains(area);
    }
  }

  void _moveToCity(String city) {
    if (city == 'الكل') return;

    // نجد إحداثيات المدينة
    for (var i = 0; i < _palestinianCities.length; i++) {
      String key = '${_palestinianCities[i].latitude},${_palestinianCities[i].longitude}';
      if (_palestinianCityNames[key] == city) {
        _initialCameraPosition = CameraPosition(
          target: _palestinianCities[i],
          zoom: 12.0,
        );

        _mapController.future.then((controller) {
          controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        });
        break;
      }
    }
  }

  void _createMarkers(List<Salon> salons) {
    _markers.clear();

    // إضافة علامات للمدن الرئيسية
    for (var i = 0; i < _palestinianCities.length; i++) {
      String city = _palestinianCityNames['${_palestinianCities[i].latitude},${_palestinianCities[i].longitude}'] ?? '';
      if (city.isNotEmpty) {
        _markers.add(
          Marker(
            markerId: MarkerId('city_$i'),
            position: _palestinianCities[i],
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: city,
              snippet: 'انقر لعرض صالونات $city',
              onTap: () {
                setState(() {
                  _selectedCity = city;
                  _selectedArea = 'الكل';
                });
                _loadSalonsForCity(city);
              },
            ),
          ),
        );
      }
    }

    // إضافة علامات للصالونات
    for (final salon in salons) {
      final marker = Marker(
        markerId: MarkerId('salon_${salon.id}'),
        position: LatLng(salon.latitude, salon.longitude),
        infoWindow: InfoWindow(
          title: salon.name,
          snippet: '${salon.rating} ★ - ${salon.address}',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalonDetailsScreen(salonId: salon.id),
              ),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: () {
          _showSalonPreview(salon);
        },
      );

      _markers.add(marker);
    }

    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _showSalonPreview(Salon salon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // مقبض السحب
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة الصالون
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      salon.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 30),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // معلومات الصالون
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          salon.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${salon.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          salon.address,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        // عدد الخدمات
                        Text(
                          'عدد الخدمات: ${salon.services.length}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // زر الحجز
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق القائمة السفلية
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalonDetailsScreen(salonId: salon.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('عرض التفاصيل والحجز'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صالونات فلسطين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLocationGranted ? _getCurrentLocation : null,
            tooltip: 'تحديث الموقع',
          ),
        ],
      ),
      body: Stack(
        children: [
          // خريطة Google
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            myLocationEnabled: _isLocationGranted,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
          ),

          // مؤشر التحميل
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // مرشحات البحث
          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCity,
                            decoration: const InputDecoration(
                              labelText: 'المدينة',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            items: _palestineCities.map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value!;
                                _selectedArea = 'الكل';
                              });
                              _loadSalonsForCity(value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedArea,
                            decoration: const InputDecoration(
                              labelText: 'المنطقة',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            items: (_cityAreas[_selectedCity] ?? ['الكل']).map((area) {
                              return DropdownMenuItem<String>(
                                value: area,
                                child: Text(area),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedArea = value!;
                              });
                              _loadSalonsForCity(_selectedCity);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _loadSalonsForCity(_selectedCity);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('بحث'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // معلومات عدد الصالونات
          Positioned(
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _markers.isEmpty ? '0' : '${_markers.length - _palestinianCities.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('صالون في'),
                        const SizedBox(width: 4),
                        Text(
                          _selectedCity,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedArea != 'الكل')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('منطقة:'),
                            const SizedBox(width: 4),
                            Text(
                              _selectedArea,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // زر الموقع الحالي
          if (_isLocationGranted)
            Positioned(
              left: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}