import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class phqChartWidget extends StatelessWidget {
  Future<List<FlSpot>> fetchData() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        // Get the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Reference to the user document in the "users" collection
        DocumentReference userDoc = firestore.collection('users').doc(userId);

        // Get the user document
        DocumentSnapshot userSnapshot = await userDoc.get();

        // Get the "phqScores" array from the user document
        List<dynamic>? phqScores = userSnapshot['phqScores'];

        // Filter scores based on the current year
        int currentYear = DateTime.now().year;
        List<dynamic>? currentYearScores =
            phqScores?.where((entry) => entry['year'] == currentYear).toList();

        // If "currentYearScores" exists, convert it to a list of FlSpot
        if (currentYearScores != null) {
          List<FlSpot> spots = currentYearScores.map((entry) {
            double yValue = entry['totalScore'].toDouble();

            // Convert yValue to the corresponding y-axis value
            double yAxisValue;
            if (yValue >= 0 && yValue <= 4) {
              yAxisValue = 0;
            } else if (yValue >= 5 && yValue <= 9) {
              yAxisValue = 1;
            } else if (yValue >= 10 && yValue <= 14) {
              yAxisValue = 2;
            } else if (yValue >= 15 && yValue <= 19) {
              yAxisValue = 3;
            } else {
              yAxisValue = 4;
            }

            return FlSpot(entry['month'].toDouble() - 1, yAxisValue);
          }).toList();

          return spots;
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    }

    // Return an empty list if there's an error or no data
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: FutureBuilder<List<FlSpot>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text("No data available");
          } else {
            // Use the fetched data to build the line chart
            return LineChart(
              LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 4,
                titlesData: getTitleData(),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Color.fromARGB(255, 219, 204, 229),
                      strokeWidth: 0.5,
                    );
                  },
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Color.fromARGB(255, 219, 204, 229),
                      strokeWidth: 0.5,
                      dashArray: [5],
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF694F79).withOpacity(0.2), width: 4),
                    left: BorderSide(
                        color: Color(0xFF694F79).withOpacity(0.2),
                        width:
                            4), //const BorderSide(color: Colors.transparent),
                    right: const BorderSide(color: Colors.transparent),
                    top: const BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data ?? [],
                    isCurved: true,
                    barWidth: 3,
                    color: const Color(0xFF694F79),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 116, 96, 128)
                              .withOpacity(0.2), // Start color (light purple)
                          Color(0xFFeed8b8)
                              .withOpacity(0.2), // End color (#eed8b8)
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Color(0xFFeed8b8).withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((LineBarSpot lineBarSpot) {
                        final spot = lineBarSpot;
                        // Add your logic to determine the text based on the y-value
                        String text;
                        if (spot.y == 0) {
                          text = 'Score:1-4';
                        } else if (spot.y == 1) {
                          text = 'Score:5-9';
                        } else if (spot.y == 2) {
                          text = 'Score:10-14';
                        } else if (spot.y == 3) {
                          text = 'Score:15-19';
                        } else {
                          text = 'Score:20-27';
                        }

                        // Return a TooltipItem with the determined text
                        return LineTooltipItem(
                            text, TextStyle(color: Color(0xFF675175)));
                      }).toList();
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: const Color(0xFF694F79),
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;

      case 2:
        text = const Text('MAR', style: style);
        break;

      case 4:
        text = const Text('MAY', style: style);
        break;

      case 6:
        text = const Text('JUL', style: style);
        break;

      case 8:
        text = const Text('SEP', style: style);
        break;

      case 10:
        text = const Text('NOV', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  /*Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: const Color(0xFF694F79),
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Minimal', style: style);
        break;

      case 1:
        text = const Text('Mid', style: style);
        break;

      case 2:
        text = const Text('Moderate', style: style);
        break;

      case 3:
        text = const Text('Severe', style: style);
        break;

      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
*/
  /*Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value >= 0 && value <= 4) {
      return Text('Minimal');
    } else if (value >= 5 && value <= 9) {
      return Text('Mid');
    } else if (value >= 10 && value <= 14) {
      return Text('Moderate');
    } else if (value >= 15 && value <= 22) {
      return Text('Severe');
    } else {
      return SizedBox.shrink(); // Return an empty widget if no match
    }
  }*/
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: const Color(0xFF694F79),
    );
    if (value == 0) {
      return Center(child: Text('Minimal', style: style));
    } else if (value == 1) {
      return Center(child: Text('Mild', style: style));
    } else if (value == 2) {
      return Center(child: Text('Moderate', style: style));
    } else if (value == 3) {
      return Center(child: Text('Moderately Severe', style: style));
    } else if (value == 4) {
      return Center(child: Text('Severe', style: style));
    } else {
      return SizedBox.shrink(); // Return an empty widget if no match
    }
  }

  /* Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: const Color(0xFF694F79),
    );

    return Text(
      value.toInt().toString(),
      style: style,
    );
  }
*/
  FlTitlesData getTitleData() => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 80,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 28,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 28,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      );
}
