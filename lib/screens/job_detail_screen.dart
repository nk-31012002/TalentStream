import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job.dart';
import '../services/database_helper.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  void _checkBookmark() async {
    bool exists = await DatabaseHelper.instance.isBookmarked(widget.job.id);
    setState(() {
      _isBookmarked = exists;
    });
  }

  void _toggleBookmark() async {
    try {
      if (_isBookmarked) {
        await DatabaseHelper.instance.removeBookmark(widget.job.id);
      } else {
        await DatabaseHelper.instance.insertBookmark(widget.job);
      }
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error in _toggleBookmark: $e");
      }
    }
  }

  void _makeCall(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Job Details",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade300),
                _buildSectionHeader("Job Information"),
                _buildDetailRow(Icons.business, "Company", job.companyName),
                _buildDetailRow(Icons.location_on, "Location", job.location),
                _buildDetailRow(Icons.work, "Experience", job.experience),
                _buildDetailRow(Icons.attach_money, "Salary", job.salary),
                _buildDetailRow(Icons.people, "Openings", "${job.openingsCount}"),

                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade300),
                _buildSectionHeader("Job Details"),
                _buildDetailRow(Icons.assignment, "Job Role", job.jobRole),
                _buildDetailRow(Icons.access_time, "Job Hours", job.jobHours),
                _buildDetailRow(Icons.school, "Qualification", job.qualification),
                _buildDetailRow(Icons.info, "Other Details", job.otherDetails),

                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade300),
                _buildSectionHeader("Contact Information"),
                _buildDetailRow(Icons.phone, "Phone", job.phone),

                const SizedBox(height: 20),
                _buildCallButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    if (value.isEmpty) return const SizedBox(); // Skip if empty

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.phone, color: Colors.white),
        label: Text(
          widget.job.buttonText.isNotEmpty ? widget.job.buttonText : 'Call Employer',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 5,
        ),
        onPressed: () => _makeCall(widget.job.customLink),
      ),
    );
  }
}
