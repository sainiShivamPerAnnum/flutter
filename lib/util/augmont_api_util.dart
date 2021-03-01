const int QUERY_FAILED = 500;
const int QUERY_PASSED = 200;
const String QUERY_SUCCESS_FLAG = "flag";
const String QUERY_FAIL_REASON = "reason";
const String INTERNAL_FAIL_FLAG = "fello_flag";

class CreateUser{
  static final String path = 'api/createUser';
  static final String fldMobile = 'mobile';
  static final String fldID = 'uid';
  static final String fldUserName = 'uname';
  static final String fldStateId = 'stateid';

  static final String resStatusCode = 'statusCode';
}