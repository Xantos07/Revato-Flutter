// lib/viewmodels/redaction_viewmodel.dart
import '../controller/dream_controller.dart';
import '../models/dream_form_data.dart';

class RedactionViewModel {
  final formData = DreamFormData(
    date: DateTime.now(),
    title: '',
    actors: [],
    locations: [],
    content: '',
    feeling: '',
    tagsBeforeEvent: [],
    tagsBeforeFeeling: [],
    tagsDreamFeeling: [],
  );

  Future<bool> submitDream() async {
    final dream = formData.toDream();
    return await DreamController().createDream(dream);
  }
}
