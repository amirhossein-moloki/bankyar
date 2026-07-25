/// Model representing the encrypted state of the PIN.
class PinModel {

  /// Constructor.
  const PinModel({required this.pinHash, required this.salt});
  /// The hashed representation of the user PIN.
  final String pinHash;

  /// The unique dynamic salt prepended/appended to the PIN before hashing.
  final String salt;
}
