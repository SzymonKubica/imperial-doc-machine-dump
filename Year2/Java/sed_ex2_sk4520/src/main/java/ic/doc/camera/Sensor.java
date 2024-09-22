package ic.doc.camera;

public interface Sensor {

  byte[] readData();

  void powerUp();

  void powerDown();
}
