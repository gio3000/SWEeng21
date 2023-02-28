import 'package:frontend/screens/login_screen.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('validation of user input', () {
    LoginScreenState state = LoginScreenState();
    test('validate username input', () {
      Tuple2<String, String?> input1 =
          const Tuple2('', 'Vergiss nicht den Benutzernamen einzugeben!');
      Tuple2<String, String?> input2 =
          const Tuple2('test-it21@it.dhbw-ravensburg.de', null);
      Tuple2<String, String?> input3 = const Tuple2(
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          'Zu viele Zeichen!');
      expect(state.validateUsernameInput(input1.item1), input1.item2);
      expect(state.validateUsernameInput(input2.item1), input2.item2);
      expect(state.validateUsernameInput(input3.item1), input3.item2);
    });
    test('validate password input', () {
      Tuple2<String, String?> input1 = const Tuple2('', 'Zu wenige Zeichen!');
      Tuple2<String, String?> input2 =
          const Tuple2('abcdef', 'Zu wenige Zeichen!');
      Tuple2<String, String?> input3 = const Tuple2(
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          'Zu viele Zeichen!');
      Tuple2<String, String?> input4 = const Tuple2('MeinPasswort123!', null);
      expect(state.validatePasswordInput(input1.item1), input1.item2);
      expect(state.validatePasswordInput(input2.item1), input2.item2);
      expect(state.validatePasswordInput(input3.item1), input3.item2);
      expect(state.validatePasswordInput(input4.item1), input4.item2);
    });
  });
}
