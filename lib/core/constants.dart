const String baseUrl = 'http://10.0.2.2:3000/api';

Map<String, String> jsonHeaders(String? token) => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
};
