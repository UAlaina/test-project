import 'package:flutter/material.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final DbHelper dbHelper = DbService().dbHelper;
  List<Report>? _reports = [];
  String _selectedInterval = 'Weekly';
  Map<String, String?> selectedValues = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedReports = await DbService().dbHelper.getReportsByInterval(_selectedInterval);
      print('[!report] interval $_selectedInterval');
      setState(() {
        _reports = loadedReports;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reports: $e');
    }
    for (var report in _reports!) {
      print('[!report]found a report');
      print('${report.toString()}');
    }
    print(_reports);
    print('\n\n\n\n\n\n\n\n\n\nTEST\n\n\n\n\n\n');
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Progress Reports'),
      //   // backgroundColor: Colors.teal,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown('Sort by', ['Daily', 'Weekly', 'Monthly']),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reports == null || _reports!.isEmpty
                  ? const Center(
                child: Text(
                  'No reports yet.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: _reports!.length,
                itemBuilder: (context, index) {
                  final report = _reports![index];
                  final score = report.score.clamp(0.0, 1.0);
                  final readableTime = DateTime.fromMillisecondsSinceEpoch(
                      report.startTime);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 45.0,
                          lineWidth: 10.0,
                          percent: score,
                          center: Text('${(score * 100).round()}%'),
                          progressColor: Colors.teal,
                          backgroundColor: Colors.grey[300]!,
                          animation: true,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interval: ${report.interval}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Start: ${readableTime.toLocal()}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildDropdown(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValues[label],
            underline: SizedBox(),
            items: options
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedValues[label] = value;
                _selectedInterval = value!;
              });
              _loadData();
            },
            hint: Text('Select Sort Condition'),
          ),
        ),
      ],
    );
  }


}



