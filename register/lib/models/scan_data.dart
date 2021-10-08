class ScanData{
  String _name;
  String _phone;
  ScanData(this._name,this._phone);
  String toParams()=>"?name=$_name&phone=$_phone";
}