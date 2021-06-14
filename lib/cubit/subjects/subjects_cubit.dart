import 'dart:async';
import 'package:education_assistant/cubit/subjects/subjects_state.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/services/subject_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectsCubit extends Cubit<SubjectState> {
  final _subjectService = SubjectService();
  StreamSubscription _subjectsSubscription;

  SubjectsCubit() : super(const SubjectState());

  Future<void> loadInitialData() async {
    try {
      emit(state.copyWith(isLoading: true));
      _subjectsSubscription =
          _subjectService.getSubjects().listen(_updateSubjects);
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void addSubject(String name, String desc, double credits, double hours) async{
    try {
      emit(state.copyWith(isLoading: true));
      await _subjectService.addSubject(name, desc, credits, hours);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void deleteSubject(SubjectModel subject) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _subjectService.deleteSubject(subject);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _updateSubjects(List<SubjectModel> subject) {
    emit(state.copyWith(allSubjects: subject, isLoading: false));
  }

  void dispose() {
    _subjectsSubscription.cancel();
  }
}
