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
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[6:0] = 0; //only uio_out[7] is used for spike output, the rest are set to 0
  assign uio_oe  = 8'b10000000; //(direction mask for uio_in)

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

  // internal wires
  wire spike1;
  wire spike2;
  wire [7:0] state1;
  wire [7:0] state2;



  // Instantiate the lif module (name it lif1) and connect the ports accordingly
  lif lif1 (
      .current(ui_in),
      .clk(clk),         // Connect clk to the clock input of lif
      .reset_n(rst_n),   // Connect rst_n to the reset input of lif
      .state(state1),    // Connect uo_out to the state output of lif
      .spike(spike1)           // Spike output is not connected in this example, but you can connect it to uio_out[7] if needed
  );

  //connected lif2 to outputs of lif1
  lif lif2 (
      .current({spike1, 7'b0}),  // need 8 bits so concatenate. 
      .clk(clk),         // Connect clk to the clock input of lif
      .reset_n(rst_n),   // Connect rst_n to the reset input of lif
      .state(state2),    // Connect uo_out to the state output of lif
      .spike(spike2)           // Spike output is not connected in this example, but you can connect it to uio_out[7] if needed
  );
  
    assign uio_out[7] = spike2; // Combine spikes from last LIF neurons to the output
    assign uo_out = state2; // Output the state of the last LIF neuron to uo_out

endmodule
