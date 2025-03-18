import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/cognito_auth_mock.dart';

void main() {
  group('cognitoAuth Tests', () {
    late MockcognitoAuth mockcognitoAuth;

    setUp(() {
      mockcognitoAuth = MockcognitoAuth();
    });

    test('performRequest handles typed arguments correctly', () async {
      // Arrange
      const endpoint = 'update';
      const body = {'key': 'value'};
      final expectedResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'},
      );

      when(mockcognitoAuth.performRequest(endpoint, body))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await mockcognitoAuth.performRequest(endpoint, body);

      // Assert
      expect(result.statusCode, equals(200));
      expect(result.body, containsPair('message', 'Success'));

      verify(mockcognitoAuth.performRequest(endpoint, body)).called(1);
    });
  });
}
