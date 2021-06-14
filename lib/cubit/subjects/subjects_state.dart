import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/models/user_model.dart';
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

  List<String> getTeachersIds(String subjectId) {
    var ids = <String>[];

    for (int i = 0; i < allSubjects.length; i++) {
      if (allSubjects[i].id == subjectId) ids = allSubjects[i].teachersIds;
    }

    return ids;
  }

  SubjectState copyWith({
    bool isLoading,
    List<SubjectModel> allSubjects,
    List<UserModel> allTeachers,
  }) {
    return SubjectState(
      isLoading: isLoading ?? this.isLoading,
      allSubjects: allSubjects ?? this.allSubjects,
    );
  }
}
