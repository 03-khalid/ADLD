 module vending_machine(
    input clk,             // Clock input
    input reset,           // Reset input
    input coin,            // Coin input (5 or 10)
    input btn_A,           // Button A input
    input btn_B,           // Button B input
    input btn_C,           // Button C input
    input btn_D,           // Button D input
    output reg product_A,  // Product A output
    output reg product_B,  // Product B output
    output reg product_C,  // Product C output
    output reg product_D   // Product D output
);

// Define product prices
parameter PRICE_A = 5;
parameter PRICE_B = 10;
parameter PRICE_C = 15;
parameter PRICE_D = 20;

// Define state machine states
parameter IDLE_STATE = 2'b00;
parameter COIN_STATE = 2'b01;
parameter PRODUCT_STATE = 2'b10;

// Define state machine signals
reg [1:0] state;
reg [3:0] coins;
reg [3:0] change;
reg [1:0] selected_product;
reg product_dispensed;
reg change_dispensed;

always @(posedge clk) begin
    if (reset) begin
        // Reset state machine and outputs
        state <= IDLE_STATE;
        coins <= 0;
        change <= 0;
        selected_product <= 0;
        product_A <= 0;
        product_B <= 0;
        product_C <= 0;
        product_D <= 0;
        product_dispensed <= 0;
        change_dispensed <= 0;
    end else begin
        // Update state machine
        case (state)
            IDLE_STATE:
                // Wait for user to select a product
                if (btn_A) begin
                    selected_product <= 2'b00;
                    state <= COIN_STATE;
                end else if (btn_B) begin
                    selected_product <= 2'b01;
                    state <= COIN_STATE;
                end else if (btn_C) begin
                    selected_product <= 2'b10;
                    state <= COIN_STATE;
                end else if (btn_D) begin
                    selected_product <= 2'b11;
                    state <= COIN_STATE;
                end
            COIN_STATE:
                // Wait for user to insert coins
                if (coin == 5 || coin == 10) begin
                    coins <= coins + coin;
                end
                if (coins >= PRICE_A && selected_product == 2'b00) begin
                    state <= PRODUCT_STATE;
                end else if (coins >= PRICE_B && selected_product == 2'b01) begin
                    state <= PRODUCT_STATE;
                end else if (coins >= PRICE_C && selected_product == 2'b10) begin
                    state <= PRODUCT_STATE;
                end else if (coins >= PRICE_D && selected_product == 2'b11) begin
                    state <= PRODUCT_STATE;
                end
            PRODUCT_STATE:
                // Dispense product and change
                product_dispensed <= 1;
                change_dispensed <= 1;
                if (selected_product == 2'b00) begin
                    product_A <= 1;
                    change <= coins - PRICE_A;
                end else if (selected_product == 2'b01) begin
                    product_B <= 1;
                    change <= coins - PRICE_B;
                end else if (selected_product == 2'b10) begin
                    product_C <= 1;
                    change <= coins - PRICE_C;
                end else if (selected_product == 2'b11) begin
                    product_D <= 1;
                    change <= coins - PRICE_D;
                end
                coins <= 0;
                selected_product <= 0;
                state <= IDLE_STATE;
        endcase
    end
end

// Output product and change
always @(posedge clk) begin
    if (reset) begin
        // Reset outputs
        product_A <= 0;
        product_B <= 0;
        product_C <= 0;
        product_D <= 0;
        product_dispensed <= 0;
        change_dispensed <= 0;
    end else begin
        // Update outputs
        if (product_dispensed) begin
            // Reset product dispensed signal
            product_dispensed <= 0;
            // Reset selected product
            selected_product <= 0;
            // Reset change
            change <= 0;
        end
        if (change_dispensed) begin
            // Reset change dispensed signal
            change_dispensed <= 0;
        end
    end
end

endmodule

module vending_machine_tb();

  // Parameters
  parameter CLK_PERIOD = 10;  // Clock period in ns
  
  // Inputs
  logic clk;
  logic reset;
  logic [1:0] selected_product;
  logic [3:0] coins;
  
  // Outputs
  logic product_A;
  logic product_B;
  logic product_C;
  logic product_D;
  logic product_dispensed;
  logic change_dispensed;
  logic [3:0] change;
  
  // Instantiate vending machine module
  vending_machine dut (
    .clk(clk),
    .reset(reset),
    .selected_product(selected_product),
    .coins(coins),
    .product_A(product_A),
    .product_B(product_B),
    .product_C(product_C),
    .product_D(product_D),
    .product_dispensed(product_dispensed),
    .change_dispensed(change_dispensed),
    .change(change)
  );
  
  // Clock generator
  always #CLK_PERIOD/2 clk = ~clk;
  
  // Reset the DUT
  initial begin
    reset = 1;
    #10;
    reset = 0;
  end
  
  // Test case 1: Buy product A with exact change
  initial begin
    coins = 5;
    selected_product = 2'b00;
    #20;
    if (product_A !== 1 || product_dispensed !== 1 || change_dispensed !== 1 || change !== 0) begin
      $error("Test case 1 failed");
    end
    $display("Test case 1 passed");
  end
  
  // Test case 2: Buy product B with 5 extra coins
  initial begin
    coins = 15;
    selected_product = 2'b01;
    #20;
    if (product_B !== 1 || product_dispensed !== 1 || change_dispensed !== 1 || change !== 5) begin
      $error("Test case 2 failed");
    end
    $display("Test case 2 passed");
  end
  
  // Test case 3: Buy product C with 10 extra coins
  initial begin
    coins = 25;
    selected_product = 2'b10;
    #20;
    if (product_C !== 1 || product_dispensed !== 1 || change_dispensed !== 1 || change !== 10) begin
      $error("Test case 3 failed");
    end
    $display("Test case 3 passed");
  end
  
  // Test case 4: Buy product D with exact change
  initial begin
    coins = 20;
    selected_product = 2'b11;
    #20;
    if (product_D !== 1 || product_dispensed !== 1 || change_dispensed !== 1 || change !== 0) begin
      $error("Test case 4 failed");
    end
    $display("Test case 4 passed");
  end
  
  // End simulation
  initial #100 $finish;
  
endmodule
