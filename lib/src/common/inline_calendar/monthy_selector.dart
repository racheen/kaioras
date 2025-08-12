import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';

class MonthlySelector extends StatelessWidget {
  final Function getPreviousMonth;
  final Function getNextMonth;
  final String currentMonth;

  const MonthlySelector({
    super.key,
    required this.getPreviousMonth,
    required this.getNextMonth,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      iconSize: 15,
      backgroundColor: Colors.grey.shade200,
      foregroundColor: Colors.black,
      shadowColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: Size(50, 50),
    );

    ButtonStyle textButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.violet99,
      side: BorderSide(color: AppColors.violet99),
      overlayColor: Colors.transparent,
      disabledForegroundColor: AppColors.violet99,
      shadowColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      minimumSize: Size(200, 55),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => getPreviousMonth(),
            style: buttonStyle,
            child: Icon(Icons.arrow_back_ios_new),
          ),
          SizedBox(width: 3),
          TextButton(
            onPressed: null,
            style: textButtonStyle,
            child: Text(currentMonth),
          ),
          SizedBox(width: 3),
          ElevatedButton(
            onPressed: () => getNextMonth(),
            style: buttonStyle,
            child: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
