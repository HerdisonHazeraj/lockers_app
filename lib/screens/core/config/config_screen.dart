class ConfigScreen {
  double maxWidth = 1920;
  double maxHeight = 1017;

  double getWidth(double wWidth, double width) {
    double ratio = width / maxWidth;

    return wWidth * ratio;
  }

  double getHeight(double wHeight, double height) {
    double ratio = height / maxHeight;

    return wHeight * ratio;
  }
}
