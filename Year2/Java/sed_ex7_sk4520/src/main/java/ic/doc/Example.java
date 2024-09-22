package ic.doc;

import com.weather.Day;
import com.weather.Forecast;
import com.weather.Forecaster;
import com.weather.Region;

public class Example {

  public static void main(String[] args) {

    // This is just an example of using the 3rd party API - delete this class before submission.

    Forecaster forecaster = new Forecaster();

    Forecast londonForecast = forecaster.forecastFor(Region.LONDON, Day.MONDAY);

    System.out.println("London outlook: " + londonForecast.summary());
    System.out.println("London temperature: " + londonForecast.temperature());

    Forecast edinburghForecast = forecaster.forecastFor(Region.EDINBURGH, Day.MONDAY);

    System.out.println("Edinburgh outlook: " + edinburghForecast.summary());
    System.out.println("Edinburgh temperature: " + edinburghForecast.temperature());
  }
}
