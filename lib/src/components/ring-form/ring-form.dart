import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../services/firebase_service.dart';

@Component(
  selector: 'ring-form',
  templateUrl: 'ring-form.html',
  directives: const [COMMON_DIRECTIVES, formDirectives],
)
class RingFormComponent {
  final FirebaseService fbService;
  bool isOpen = false;
  String _selectedOption = "Select an Option!";
  RingFormComponent(this.fbService) {}

  List<String> get options => ['Soft', 'Loud', 'Ugh'];

  String get selectedOption => _selectedOption;
  set selectedOption(String selectedOption) => _selectedOption = selectedOption;

  onClick(MouseEvent event) {
    isOpen = !isOpen;
  }

  onOptionClick(String option) {
    _selectedOption = option;
  }

  onRingClick(String message) {
    String ringString = "";
    if (_selectedOption == "Soft") ringString = "softHit";
    if (_selectedOption == "Loud") ringString = "sneakAttack";
    if (_selectedOption == "Ugh") ringString = "rollHit";
    fbService.sendRing(message, ringString);
  }
}
