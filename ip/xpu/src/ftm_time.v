`timescale 1ns / 1ps

`include "clock_speed.v"

/* This module implements a basic clock-driven counter, used for FTM timestamping.
   It is used in both the RX and TX paths to obtain a basic time on which further processing can be done to determine
   the exact moment a packet arrived / was transmitted.
   Since FTM doesn't require the timestamps to have any specific time base, the counter simply starts at zero after reset, and increments
   every clock ftm_time by the amount of picoseconds that have passed. */
module ftm_time(
    input wire clk,
    input wire rstn,
    
    output reg [47:0] ftm_time
);

    localparam PICOSECS_PER_CLK_CYCLE = 1_000_000 / `NUM_CLK_PER_US;
    
    always@(clk) begin
        if (!rstn) begin
            ftm_time <= 0;
        end else begin
            // This will overflow ~every 4.5 minutes.
            // The FTM protocol is designed to handle overflows by signifying a "change of timebase",
            // which the software will take care of automatically.
            ftm_time <= ftm_time + PICOSECS_PER_CLK_CYCLE;
        end    
    end
endmodule
