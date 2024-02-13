import 'package:my_pheonix/Utility/DatabaseHelper.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseManager {
  late Database _db;

  // Singleton pattern for DatabaseManager
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  // Initialize the database
  Future<void> initDatabase() async {
    _db = await DatabaseHelper.instance.database;
    _createTables();
  }

  // Create tables for all forms
  void _createTables() async {
    await createKYCTable();
    await _createPersonalDetailsTable();
    await _createFamilyDetailsTable();
    await _createLoanDetailsTable();
    await createBusinessDetailsTable();
    await createAddressDetailsTable();
    await createBankingDetailsTable();
    await _createPropertyDetailsTable();
    await createInsuranceDetailsTable();
    await createUploadedDocumentsTable();
    // Add other table creation methods as needed for different forms
  }


Future<void> createKYCTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS KYCData (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      ckycNumber TEXT,
      kycType TEXT,
      kycID TEXT,
      documentPath TEXT
    )
  ''');
}

  // Create PersonalDetails table
  Future<void> _createPersonalDetailsTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS PersonalDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      ImagePathPersonal TEXT,
      FirstNameP TEXT,
      MiddleNameP TEXT,
      LastNameP TEXT,
      ApplicantNamePAN TEXT,
      ApplicantNameAdhar TEXT,
      MobileNumberP TEXT,
      PhoneNoSecondary TEXT,
      EmailId TEXT,
      Age TEXT,
      DOBP TEXT,
      CustomerEntityType TEXT,
      ApplicantTypeP TEXT,
      Salutation TEXT,
      Religion TEXT,
      Caste TEXT,
      Occupation TEXT,
      EducationQualification TEXT,
      MaritalStatus TEXT
    )
  ''');
  }


  Future<void> _createFamilyDetailsTable() async {
    await _db.execute('''
        CREATE TABLE IF NOT EXISTS FamilyDetails (
      id INTEGER PRIMARY KEY,
      ClientID TEXT,
      NoOfFamilyMember TEXT,
      NoOfAdult TEXT,
      NoOfKids TEXT,
      NoOfEarner TEXT,
      NoOfDependents TEXT,
      FatherFirstName TEXT,
      FatherMiddleName TEXT,
      FatherLastName TEXT,
      MotherFirstName TEXT,
      MotherMiddleName TEXT,
      MotherLastName TEXT,
      SpouseFirstName TEXT,
      SpouseMiddleName TEXT,
      SpouseLastName TEXT
    )
  ''');
  }

  Future<void> _createLoanDetailsTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS LoanDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      ApplicationID TEXT,
      Product TEXT,
      ApplicationCategory TEXT,
      AppliedLoanAmount TEXT,
      AppliedTenure TEXT,
      EndUseOfTheLoan TEXT
    )
  ''');
}

Future<void> createBusinessDetailsTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS BusinessDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      BusinessName TEXT,
      BusinessActivity TEXT,
      BusinessClassification TEXT,
      BusinessVintage TEXT,
      BusinessExperiance TEXT,
      BusinessOperatedBy TEXT,
      BusinessPremises TEXT,
      AgreementAvailable TEXT,
      BusinessRental TEXT
    )
  ''');
}

Future<void> createAddressDetailsTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS AddressDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      AddressType TEXT,
      SameAs TEXT,
      AddressLine1 TEXT,
      AddressLine2 TEXT,
      AddressLine3 TEXT,
      Pincode TEXT,
      City TEXT,
      Tahsil TEXT,
      District TEXT,
      State TEXT,
      Landmark TEXT
    )
  ''');
}

  // Create PropertyDetails table
  Future<void> _createPropertyDetailsTable() async {
    await _db.execute('''
       CREATE TABLE IF NOT EXISTS PropertyDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      PropertyType TEXT,
      DateOfRegistration TEXT,
      AssetID TEXT,
      SubRegistration TEXT,
      ExtentOfProperty TEXT,
      ImagePath TEXT
    )
  ''');
  }


Future<void> createBankingDetailsTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS BankingDetails (
      id INTEGER PRIMARY KEY,
      CustomerID TEXT,
      AccountNumber TEXT,
      AccountHolderName TEXT,
      AccountType TEXT,
      IFSCCode TEXT,
      BankName TEXT,
      UploadStatement TEXT
    )
  ''');
}

Future<void> createInsuranceDetailsTable() async {
  await _db.execute('''
    CREATE TABLE IF NOT EXISTS InsuranceDetails (
      ID INTEGER PRIMARY KEY,
      ClientID TEXT,
      Height TEXT,
      Weight TEXT,
      NumberOfEarners TEXT,
      WeightChange TEXT,
      WeightChangeReason TEXT,
      CovidSymptoms TEXT,
      CovidComplications TEXT,
      CovidComplicationsReason TEXT,
      RelationshipWithApplicant TEXT,
      NomineeFirstName TEXT,
      NomineeSurname TEXT,
      NomineeGender TEXT,
      NomineeDOB TEXT,
      AddressLine1 TEXT,
      AddressLine2 TEXT,
      AddressLine3 TEXT,
      Pincode TEXT,
      City TEXT,
      Tahsil TEXT,
      District TEXT,
      State TEXT,
      Landmark TEXT
    )
  ''');
}

Future<void> createUploadedDocumentsTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS UploadedDocuments (
        id INTEGER PRIMARY KEY,
        DocumentType TEXT,
        DocumentName TEXT,
        DocumentPath TEXT,
        UploadDate TEXT,
        CustomerID TEXT
      )
    ''');
  }

  // Add other methods for different forms as needed
}
