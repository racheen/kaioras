import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';

class WeeklySelector extends StatelessWidget {
  final Function getPreviousWeek;
  final Function getNextWeek;
  final Function getToday;

  const WeeklySelector({
    super.key,
    required this.getPreviousWeek,
    required this.getNextWeek,
    required this.getToday,
  });

  @override
  Widget build(BuildContext context) {
    String buttonLabel = 'Today';

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      iconSize: 15,
      backgroundColor: Colors.grey.shade200,
      foregroundColor: Colors.black,
      shadowColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: Size(50, 50),
    );
    ButtonStyle todayButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.violetE3,
      foregroundColor: Colors.white,
      shadowColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: Size(200, 55),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => getPreviousWeek(),
            style: buttonStyle,
            child: Icon(Icons.arrow_back_ios_new),
          ),
          SizedBox(width: 3),
          TextButton(
            onPressed: () => getToday(),
            style: todayButtonStyle,
            child: Text(buttonLabel),
          ),
          SizedBox(width: 3),
          ElevatedButton(
            onPressed: () => getNextWeek(),
            style: buttonStyle,
            child: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
