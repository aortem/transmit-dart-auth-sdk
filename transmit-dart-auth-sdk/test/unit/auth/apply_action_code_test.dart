import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/transmit_auth_mock.dart';

void main() {
  group('transmitAuth Tests', () {
    late MocktransmitAuth mocktransmitAuth;

    setUp(() {
      mocktransmitAuth = MocktransmitAuth();
    });

    test('performRequest handles typed arguments correctly', () async {
      // Arrange
      const endpoint = 'update';
      const body = {'key': 'value'};
      final expectedResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'},
      );

      when(mocktransmitAuth.performRequest(endpoint, body))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await mocktransmitAuth.performRequest(endpoint, body);

      // Assert
      expect(result.statusCode, equals(200));
      expect(result.body, containsPair('message', 'Success'));

      verify(mocktransmitAuth.performRequest(endpoint, body)).called(1);
    });
  });
}
