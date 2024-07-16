
# Introduction

This Rails application is a very basic implementation of a headless E-Commerce system. The system may be interacted with via multiple clients, such as a RESTful Admin interface, a GraphQL layer, or extracted through data pipelines for analysis.

## The Models

### Skus

Skus represent physical items that we stock. This could be things we sell, packaging, customer gifts, etc.

### Products

Products allow us to add a price and a name to SKUs that we want to sell.

### Orders & OrderProducts

An Order is a collection of OrderProducts. Order Products are essentially line items. They contain the product being purchased and the quantity required.

The shipping date is also stored on an Order.

## The Task

We have the ability to change the price of a product. But unfortunately, this changes the value of every existing order, even if they've been shipped already. We would like to be able to change prices without affecting the price totals of existing orders.

**Acceptance Criteria:**

* The price of existing orders must not change
* The price of new orders will use the new price

## Solution Explanation

### Simplifying with Snapshot Pattern

This requirement could be achieved more simply by adding a method to `OrderProduct` to store the product's price at the time of the order, but this approach was not followed due to its limitations in maintaining historical data and the difficulty of updating existing orders.

### Why Not Snapshot Pattern?

The snapshot pattern, where the price is stored directly in the `OrderProduct` model, has some limitations:

- **Limited Historical Insight:** It is challenging to track historical pricing trends and changes, making it less suitable for detailed auditing and analysis.
- **Complex Updates:** If a retrospective price change is required (e.g., correcting a pricing error across multiple orders), updating each order individually is complex and error-prone.

### Versioned Entities Pattern

**Benefits of Versioned Pattern:**

- **Centralized Price Management:** Prices are managed in a single location (`ProductVersion`), making updates straightforward and reducing the risk of inconsistencies.
  - *Example:* If a product price needs to be updated, you only need to create a new `ProductVersion` record with the updated price. All new orders will automatically use the new price without affecting historical orders.
- **Enhanced Historical Insight:** The versioned pattern provides a clear record of price changes over time, supporting detailed analysis and auditing.
  - *Example:* By maintaining a history of all product prices in the `ProductVersion` table, you can easily generate reports on how prices have changed over time, which is valuable for business analysis and auditing purposes.

### Implementation Details

**Product Model:**

- Manages the relationship with `ProductVersion` and ensures the current version is always referenced.

**ProductVersion Model:**

- Stores historical price data and ensures referential integrity.
- A migration was created to establish this model and populate it with existing product data.
- New versions can be created whenever the price of a product changes, preserving historical prices.

**OrderProduct Model:**

- References `ProductVersion` to maintain historical price accuracy.
- A migration was created to update the `OrderProduct` model to reference `ProductVersion` instead of `Product`.

**Order Model:**

- Calculates totals based on the correct `ProductVersion` prices.

### Steps Taken to Implement Versioned Pattern

1. **Create ProductVersion Model:**
    - Generated a new model `ProductVersion` to store versions of product prices.
    - Added fields for product reference and price.

2. **Migrate Existing Products:**
    - Created a migration to populate the `ProductVersion` table with current product data.
    - Ensured that each existing product has an initial version in `ProductVersion`.

3. **Update OrderProduct Model:**
    - Updated `OrderProduct` to reference `ProductVersion` instead of `Product`.
    - Adjusted associations and validations accordingly.

4. **Adjust Business Logic:**
    - Modified order creation logic to use the current `ProductVersion` for new orders.
    - Ensured that historical orders reference the correct `ProductVersion`.

### Assumptions and Decisions

- Assumed that each product version would only change price and not other attributes.
- Decided to use the `ProductVersion` model to maintain historical prices and ensure that changing the price of a product does not affect past orders.

### How to Run the Project

1. **Setup:**

   - Run `bundle install`
   - Run `rake db:setup`

2. **Running Tests:**

   - Run `bundle exec rspec`
