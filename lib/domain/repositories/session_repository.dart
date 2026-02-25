import '../models/session.dart';

abstract class SessionRepository {
  Future<List<Session>> getAllSessions();
  Future<Session?> getSession(String id);
  Future<void> saveSession(Session session);
  Future<void> deleteSession(String id);
  Future<List<Session>> getSessionsByDate(DateTime date);
}
