/// Base marker interface for all Local Data Sources.
/// Local storage encompasses encrypted SQLite, preferences, or volatile files.
abstract class LocalDataSource {}

/// Base marker interface for all Remote Data Sources.
/// Note: BankYar operates with a strict 100% offline boundary, but this abstraction
/// supports future remote synchronizations or secure backups over physical servers.
abstract class RemoteDataSource {}
