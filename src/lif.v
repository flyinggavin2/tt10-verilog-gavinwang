`default_nettype none

module lif(
    input wire [7:0] current,
    input wire clk,
    input wire reset_n,
    output reg [7:0] state,
    output wire spike // based off logic gate
);
    wire [7:0] next_state;
    reg [7:0] threshold; // Example threshold value  represents an 8-bit unsigned integer with a decimal value of 10 (stored in binary as 00001010

    //assign --> use wire
    //always @... (flipflop) --> use reg

    //flipflop to update state on clock edge
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= 8'd0; // Reset state to 0
            threshold <= 8'd200; // Reset threshold to default value
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    //next state logic
    assign next_state = current + (state >> 1); 
    //right shift state by 1 to divide by 2, effectively implementing the decay factor (beta) in the update rule. This is a simple approximation of the LIF model's behavior.
    // Example update rule (8 bits + (8bits * 8bits) = 16 bits, but we only take the lower 8 bits), Maximum value: 255 × 255 = 65,025, which fits safely inside the 16-bit unsigned maximum of 65,535 (2¹⁶ - 1).


    //spike logic
    assign spike = (next_state >= threshold) ? 1'b1 : 1'b0; // Generate a spike if the next state exceeds the threshold
endmodule

    
