import 'package:flutter/material.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/models/dbHelper.dart';

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
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildDropdown('Sort by', ['Daily', 'Weekly', 'Monthly']),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _reports == null || _reports!.isEmpty
                ? Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text('No Reports Yet'),
                ],
              ),
            ) :
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _reports!.length,
                      itemBuilder: (context, index) {
                        final report = _reports![index];
                        return GestureDetector(
                          onTap: () =>
                          {
                            //_navigateToTaskList(habit.id),
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text('score ${report.score}'),
                                Text('startTime ${DateTime.fromMillisecondsSinceEpoch(report.startTime)}'),
                                Text('startTime ${report.interval}'),
                              ],
                            ),


                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
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



