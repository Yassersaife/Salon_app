import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/Salon/salon_details.dart';
import 'package:salon_booking_app/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _salonMarkers = [];

  // الإحداثيات الافتراضية والإعدادات الأولية
  LatLng _currentUserLocation = LatLng(31.9522, 35.2332); // إحداثيات افتراضية
  List<Salon> _nearbySalons = [];
  double _currentZoom = 14.0;
  double _searchRadius = 5.0; // نصف قطر البحث بالكيلومتر

  bool _isLoading = false;
  bool _isLocationGranted = false;

  // معلومات الصالون المختار
  Salon? _selectedSalon;

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
      // إذا لم يتم منح الإذن، نحمل جميع الصالونات
      _loadAllSalons();

      // إظهار رسالة للمستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى السماح بالوصول إلى الموقع لرؤية الصالونات القريبة منك'),
          action: SnackBarAction(
            label: 'السماح',
            onPressed: () async {
              final newStatus = await Permission.location.request();
              if (newStatus.isGranted) {
                _getCurrentLocation();
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
      });

      // تحريك الخريطة إلى الموقع الحالي
      _mapController.move(_currentUserLocation, _currentZoom);

      // تحميل الصالونات القريبة
      _loadNearbySalons();

    } catch (e) {
      print('Error getting current location: $e');
      // تحميل جميع الصالونات في حالة الفشل
      _loadAllSalons();

      // إظهار رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تحديد موقعك الحالي: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAllSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);
      await salonsProvider.fetchSalons();

      setState(() {
        _nearbySalons = salonsProvider.salons;
      });

      _createSalonMarkers();

    } catch (e) {
      print('Error loading all salons: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تحميل الصالونات: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNearbySalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);
      await salonsProvider.fetchSalons();

      // جلب جميع الصالونات
      final allSalons = salonsProvider.salons;

      // تصفية الصالونات حسب المسافة
      List<Salon> filtered = [];
      for (var salon in allSalons) {
        double distance = Geolocator.distanceBetween(
          _currentUserLocation.latitude,
          _currentUserLocation.longitude,
          salon.latitude,
          salon.longitude,
        ) / 1000; // تحويل من متر إلى كيلومتر

        if (distance <= _searchRadius) {
          filtered.add(salon);
        }
      }

      // ترتيب الصالونات حسب المسافة (الأقرب أولاً)
      filtered.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          _currentUserLocation.latitude,
          _currentUserLocation.longitude,
          a.latitude,
          a.longitude,
        );

        double distanceB = Geolocator.distanceBetween(
          _currentUserLocation.latitude,
          _currentUserLocation.longitude,
          b.latitude,
          b.longitude,
        );

        return distanceA.compareTo(distanceB);
      });

      setState(() {
        _nearbySalons = filtered;
      });

      _createSalonMarkers();

      if (filtered.isEmpty) {
        // إذا لم يتم العثور على صالونات قريبة، زيادة نصف القطر تلقائياً
        setState(() {
          _searchRadius = _searchRadius + 5.0;
        });



        // إعادة تحميل الصالونات بنصف قطر أكبر
        _loadNearbySalons();
      }

    } catch (e) {
      print('Error loading nearby salons: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تحميل الصالونات القريبة: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createSalonMarkers() {
    _salonMarkers = [];

    // إضافة علامة لموقع المستخدم الحالي
    if (_isLocationGranted) {
      _salonMarkers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: _currentUserLocation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }

    // إضافة علامات للصالونات
    for (var salon in _nearbySalons) {
      // حساب المسافة من موقع المستخدم
      double distance = 0;
      if (_isLocationGranted) {
        distance = Geolocator.distanceBetween(
          _currentUserLocation.latitude,
          _currentUserLocation.longitude,
          salon.latitude,
          salon.longitude,
        ) / 1000; // تحويل من متر إلى كيلومتر
      }

      _salonMarkers.add(
        Marker(
          width: 100.0,
          height: 70.0,
          point: LatLng(salon.latitude, salon.longitude),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedSalon = salon;
              });

              // تحريك الخريطة لوضع الصالون في المنتصف
              _mapController.move(LatLng(salon.latitude, salon.longitude), _currentZoom);
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.spa, color: Colors.white, size: 18),
                ),
                if (_isLocationGranted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${distance.toStringAsFixed(1)} كم',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    salon.name,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLocationGranted ? 'الصالونات القريبة منك' : 'جميع الصالونات'),
        actions: [
          // زر تغيير نطاق البحث
          if (_isLocationGranted)
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _showRadiusDialog,
              tooltip: 'تغيير نطاق البحث',
            ),
          // زر تحديث الموقع
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLocationGranted ? _getCurrentLocation : _loadAllSalons,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Stack(
        children: [
          // خريطة OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentUserLocation,
              initialZoom: _currentZoom,
              onTap: (tapPosition, latLng) {
                // إخفاء بطاقة الصالون عند النقر على الخريطة
                setState(() {
                  _selectedSalon = null;
                });
              },
              interactionOptions: const InteractionOptions(
                enableMultiFingerGestureRace: true,
              ),
            ),
            children: [
              // طبقة الخريطة الأساسية
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.salon_booking_app',
                maxZoom: 19,
              ),

              // رسم دائرة لنطاق البحث (إذا تم تحديد الموقع)
              if (_isLocationGranted)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentUserLocation,
                      radius: _searchRadius * 1000, // تحويل إلى متر
                      color: AppColors.primary.withOpacity(0.1),
                      borderColor: AppColors.primary.withOpacity(0.5),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),

              // طبقة العلامات
              MarkerLayer(markers: _salonMarkers),
            ],
          ),

          // مؤشر التحميل
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // معلومات عن عدد الصالونات القريبة
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.spa,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isLocationGranted
                            ? 'تم العثور على ${_nearbySalons.length} صالون ضمن نطاق $_searchRadius كم'
                            : 'تم العثور على ${_nearbySalons.length} صالون',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // بطاقة معلومات الصالون المختار
          if (_selectedSalon != null)
            Positioned(
              bottom: 20,
              right: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  // الانتقال إلى صفحة تفاصيل الصالون
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalonDetailsScreen(salonId: _selectedSalon!.id),
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // زر الحجز
                            Column(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SalonDetailsScreen(salonId: _selectedSalon!.id),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.calendar_today, size: 16),
                                  label: const Text('حجز'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: BorderSide(color: AppColors.primary),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (_isLocationGranted)
                                  Text(
                                    '${Geolocator.distanceBetween(
                                      _currentUserLocation.latitude,
                                      _currentUserLocation.longitude,
                                      _selectedSalon!.latitude,
                                      _selectedSalon!.longitude,
                                    ) / 1000} كم',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(width: 16),

                            // معلومات الصالون
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _selectedSalon!.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(height: 4),
                                  // التقييم
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '(${_selectedSalon!.reviewsCount})',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _selectedSalon!.rating.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // العنوان
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedSalon!.address,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // صورة الصالون
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _selectedSalon!.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // رسالة للمستخدم
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'اضغط للانتقال إلى صفحة الصالون',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // زر الموقع الحالي
          if (_isLocationGranted)
            Positioned(
              left: 16,
              bottom: _selectedSalon != null ? 180 : 16,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                tooltip: 'العودة إلى موقعي',
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

  void _showRadiusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تغيير نطاق البحث',
          textAlign: TextAlign.right,
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المسافة: $_searchRadius كم',
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _searchRadius,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                label: '${_searchRadius.round()} كم',
                onChanged: (value) {
                  setState(() {
                    _searchRadius = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadNearbySalons(); // إعادة تحميل الصالونات بناءً على النطاق الجديد
            },
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }
}