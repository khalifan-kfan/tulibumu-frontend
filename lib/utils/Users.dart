class Users {
//non-private property
//list of strings
  List<dynamic> usrs = [];

  List get getUsrs {
    return usrs;
  }

  // Creating the setter method
  // to set the input in Field/Property
  set setUsrs(List<dynamic> users) {
    usrs = users;
  }
}
