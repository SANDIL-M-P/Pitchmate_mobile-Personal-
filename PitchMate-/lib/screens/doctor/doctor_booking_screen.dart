import 'package:flutter/material.dart';

class DoctorBookingScreen extends StatefulWidget {
  const DoctorBookingScreen({Key? key}) : super(key: key);

  @override
  State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  static const Color primaryYellow = Color(0xFFF5A623);
  static const Color bgBlack = Colors.black;

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: primaryYellow,
                    onPrimary: bgBlack,
                    surface: Colors.grey[850]!,
                    onSurface: Colors.white70,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryYellow,
                    onPrimary: Colors.white,
                    surface: Colors.grey[200]!,
                    onSurface: Colors.black87,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      setState(() => _selectedDate = newDate);
    }
  }

  Future<void> _pickTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  timePickerTheme: TimePickerThemeData(
                    dialBackgroundColor: Colors.grey[850],
                    dialHandColor: primaryYellow,
                    dialTextColor: Colors.white,
                    hourMinuteTextColor: Colors.white,
                    dayPeriodTextColor: Colors.white70,
                  ),
                  colorScheme: ColorScheme.dark(
                    primary: primaryYellow,
                    onPrimary: bgBlack,
                    surface: Colors.grey[850]!,
                    onSurface: Colors.white70,
                  ),
                )
              : ThemeData.light().copyWith(
                  timePickerTheme: TimePickerThemeData(
                    dialBackgroundColor: Colors.grey[200],
                    dialHandColor: primaryYellow,
                    dialTextColor: Colors.black,
                    hourMinuteTextColor: Colors.black,
                    dayPeriodTextColor: Colors.black54,
                  ),
                  colorScheme: ColorScheme.light(
                    primary: primaryYellow,
                    onPrimary: Colors.white,
                    surface: Colors.grey[200]!,
                    onSurface: Colors.black87,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() => _selectedTime = newTime);
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            title: Text(
              'Confirm Booking',
              style: TextStyle(
                color: primaryYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to book this appointment?',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Proceed with booking
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Booking Confirmed on ${_selectedDate!.toLocal().toString().split(' ')[0]} at ${_selectedTime!.format(context)}',
                      ),
                    ),
                  );
                  Navigator.pop(context); // Close the booking screen
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: primaryYellow),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? bgBlack : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color labelColor = isDark ? Colors.white : Colors.black;
    final Color borderColor = isDark ? Colors.white70 : Colors.grey;

    final Gradient backgroundGradient = isDark
        ? LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Doctor Booking',
          style: TextStyle(color: primaryYellow, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryYellow),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: isDark ? Colors.grey[850] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Optional: Add a top logo or title.
                      Text(
                        'Book a Doctor Session',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryYellow,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Reason for visit
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 2,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Reason for Appointment',
                          labelStyle: TextStyle(color: labelColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryYellow),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe the reason for your appointment';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Date Picker Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _pickDate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryYellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Select Date',
                              style: TextStyle(
                                  color: isDark ? Colors.black : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Time Picker Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedTime == null
                                  ? 'No time selected'
                                  : 'Time: ${_selectedTime!.format(context)}',
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _pickTime,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryYellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Select Time',
                              style: TextStyle(
                                  color: isDark ? Colors.black : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Submit booking button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryYellow,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
