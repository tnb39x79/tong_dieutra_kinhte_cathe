extension StringX on String {
  ///Capitalizes the first letter of each word in a string
  String capitalizeFirstLetter() {
    return split(" ").map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(" ");
  }
}
