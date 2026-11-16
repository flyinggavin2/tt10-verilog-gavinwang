/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_lif (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[6:0] = 0; //only uio_out[7] is used for spike output, the rest are set to 0
  assign uio_oe  = 8'b11111111; //(direction mask for uio_in)

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

  // Instantiate the lif module (name it lif1) and connect the ports accordingly
  lif lif1 (
      .current(uio_in),  // Connect uio_in to the current input of lif
      .clk(clk),         // Connect clk to the clock input of lif
      .reset_n(rst_n),   // Connect rst_n to the reset input of lif
      .state(uo_out),    // Connect uo_out to the state output of lif
      .spike(uio_out[7])           // Spike output is not connected in this example, but you can connect it to uio_out[7] if needed
  );

  //connected lif2 to outputs of lif1
  lif lif2 (
      .current({uio_out[7], 7'b0}),  // need 8 bits so concatenate. 
      .clk(clk),         // Connect clk to the clock input of lif
      .reset_n(rst_n),   // Connect rst_n to the reset input of lif
      .state(uo_out),    // Connect uo_out to the state output of lif
      .spike(uio_out[7])           // Spike output is not connected in this example, but you can connect it to uio_out[7] if needed
  );
  

endmodule
