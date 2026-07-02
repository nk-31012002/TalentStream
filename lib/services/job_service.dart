import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class JobService {
  final String baseUrl = 'https://testapi.talentstream.com/common/jobs';

  Future<List<Job>> fetchJobs(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded.containsKey('results')) {
        final List<dynamic> jobsJson = decoded['results'];
        return jobsJson.map((json) => Job.fromJson(json)).toList();
      }
      else {
        throw Exception('Unexpected API response structure');
      }
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
