package Q2;

import java.util.*;

public class Cinema {

  private final TicketIssuer ticketer = new TicketIssuer();
  private final BoxOffice boxOffice = new BoxOffice();

  public void bookTicketFor(CustomerId customer, Showing showing) {

    String ticketId = ticketer.reserveTicketFor(showing);

    boxOffice.getCustomerDatabase().getCustomer(customer).getTickets().add(ticketId);
  }
}

class BoxOffice {

  private final CustomerDatabase customerDatabase = new CustomerDatabase();

  public CustomerDatabase getCustomerDatabase() {
    return customerDatabase;
  }
}

class TicketIssuer {

  public String reserveTicketFor(Showing showing) {
    // generate a ticket id for the relevant showing.
    return UUID.randomUUID().toString();
  }
}

class CustomerDatabase {

  private final Map<CustomerId, Customer> customers = new HashMap<>();

  public Customer getCustomer(CustomerId customerId) {
    return customers.get(customerId);
  }
}

class Customer {

  private final List<String> currentTickets = new ArrayList<>();

  public List<String> getTickets() {
    return currentTickets;
  }

}

class Showing { /* left empty for this exercise */
}

class CustomerId { /* left empty for this exercise */
}
