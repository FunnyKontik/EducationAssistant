import 'package:education_assistant/models/subject_model.dart';
import 'package:meta/meta.dart';

@immutable
class SubjectState {
  final List<SubjectModel> allSubjects;
  final bool isLoading;

  const SubjectState({
    this.allSubjects = const [],
    this.isLoading = true,
  });

  List<SubjectModel> get subjects {
    return allSubjects.toList();
  }


  SubjectState copyWith({
    bool isLoading,
    List<SubjectModel> allSubjects,
  }) {
    return SubjectState(
      isLoading: isLoading ?? this.isLoading,
      allSubjects: allSubjects ?? this.allSubjects,
    );
  }
}
