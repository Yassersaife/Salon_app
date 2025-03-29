import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/models/service.dart';
import 'package:salon_booking_app/models/staff.dart';
import 'package:salon_booking_app/providers/booking_provider.dart';
import 'package:salon_booking_app/theme.dart';

class BookingScreen extends StatefulWidget {
  final Salon salon;
  final Service service;

  const BookingScreen({
    Key? key,
    required this.salon,
    required this.service,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  Staff? _selectedStaff;

  final List<String> _timeSlots = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
    '18:00', '18:30', '19:00', '19:30', '20:00'
  ];

  @override
  void initState() {
    super.initState();
    // تحديد أول موظف افتراضيًا
    if (widget.salon.staff.isNotEmpty) {
      _selectedStaff = widget.salon.staff.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز موعد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // معلومات الخدمة
            _buildServiceInfo(),

            const SizedBox(height: 24),

            // اختيار الموظف
            const Text(
              'اختر أخصائي التجميل',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStaffSelection(),

            const SizedBox(height: 24),

            // اختيار التاريخ
            const Text(
              'اختر التاريخ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDateSelection(),

            const SizedBox(height: 24),

            // اختيار الوقت
            const Text(
              'اختر الوقت',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeSelection(),

            const SizedBox(height: 32),

            // زر تأكيد الحجز
            SizedBox(
              width: double.infinity,
              child: Consumer<BookingProvider>(
                builder: (context, bookingProvider, child) {
                  return ElevatedButton(
                    onPressed: bookingProvider.status == BookingStatus.loading
                        ? null
                        : _confirmBooking,
                    child: bookingProvider.status == BookingStatus.loading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('تأكيد الحجز'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.service.price} ر.س',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.service.durationMinutes} دقيقة',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.salon.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.service.name,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffSelection() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.salon.staff.length,
        itemBuilder: (context, index) {
          final staff = widget.salon.staff[index];
          final isSelected = _selectedStaff?.id == staff.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStaff = staff;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightPurple : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(staff.imageUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                    backgroundColor: Colors.grey[200],
                    child: staff.imageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    staff.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelection() {
    // إنشاء قائمة بالأيام القادمة (7 أيام)
    final dates = List.generate(7, (index) {
      return DateTime.now().add(Duration(days: index));
    });

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          // تهيئة التنسيق بالعربية
          final dayNameFormat = DateFormat.EEEE('ar');
          final dayNumberFormat = DateFormat.d('ar');

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _selectedTime = null; // إعادة تعيين الوقت عند تغيير التاريخ
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNameFormat.format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dayNumberFormat.format(date),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTime == time;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTime = time;
            });
          },
          child: Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _confirmBooking() {
    if (_selectedStaff == null) {
      _showErrorMessage('يرجى اختيار أخصائي التجميل');
      return;
    }

    if (_selectedTime == null) {
      _showErrorMessage('يرجى اختيار وقت للحجز');
      return;
    }

    // تحويل الوقت إلى كائن DateTime
    final timeParts = _selectedTime!.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final appointmentDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    bookingProvider.createBooking(
      salonId: widget.salon.id,
      salonName: widget.salon.name,
      salonImage: widget.salon.imageUrl,
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      servicePrice: widget.service.price,
      staffId: _selectedStaff!.id,
      staffName: _selectedStaff!.name,
      appointmentDateTime: appointmentDateTime,
      durationMinutes: widget.service.durationMinutes,
    ).then((success) {
      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorMessage(bookingProvider.errorMessage);
      }
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('تم الحجز بنجاح'),
          ],
        ),
        content: const Text('تم تأكيد حجزك بنجاح. يمكنك متابعة حجوزاتك من قائمة الحجوزات.'),
        actions: [
          TextButton(
            child: const Text('حسناً'),
            onPressed: () {
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // العودة إلى الشاشة السابقة
            },
          ),
        ],
      ),
    );
  }
}