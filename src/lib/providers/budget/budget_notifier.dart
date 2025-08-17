import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/repositories/budget_repository.dart';

class BudgetNotifier extends StateNotifier<Budget?> {
  BudgetNotifier(this._repo) : super(null) {
    _init();
  }

  final BudgetRepository _repo;

  Future<void> _init() async {
    state = await _repo.getBudget();
  }

  Future<void> reload() async {
    state = await _repo.getBudget();
  }

  Future<void> save(BudgetsCompanion data) async {
    await _repo.upsert(data);
    state = await _repo.getBudget();
  }
}
