import simple.*;
import uk.ac.ic.doc.util.NestedPackagePrinter;

public class Main {

  public static void main(String [] args) {
    System.out.println("Repeating the experiment using separate build directory");
    System.out.print("Attempting to print from...");
    SimplePackagePrinter.print();
    System.out.println("...success!");

    System.out.print("Attempting to print from...");
    NestedPackagePrinter.print();
    System.out.println("...success!");
  }

}
