class CustomerIDStorage {
  static String? _customerID;
  static String? _cKYCIDToSave;

  static String? get customerID => _customerID;
  static String? get cKYCIDToSave => _cKYCIDToSave;

  static void setCustomerID(String id) {
    _customerID = id;
  }

  static void setCKYCIDToSave(String id) {
    _cKYCIDToSave = id;
  }
}
