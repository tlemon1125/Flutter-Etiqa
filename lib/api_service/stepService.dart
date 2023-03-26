import 'package:http/http.dart' as http;

class stepService {
  update(name, steps) async {
    var response = await http.post(
        Uri.parse('http://10.211.99.75:3000/stepupdate'),
        body: {"name": name, "steps": steps});

    // var response =
    //     await http.get(Uri.parse('http://192.168.0.151:3000/dashboard'));

    print('Response Status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return steps;
  }
}
