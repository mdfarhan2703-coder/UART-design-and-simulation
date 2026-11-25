`timescale 1ns/1ps

module uart_tb;

reg clk, rst, tx_start;
reg [7:0] tx_data;

wire tx, tx_busy;
wire [7:0] rx_data;
wire rx_done;

uart_tx #(.CLKS_PER_BIT(16)) tx_unit (
    .clk(clk), .rst(rst),
    .tx_start(tx_start), .tx_data(tx_data),
    .tx(tx), .tx_busy(tx_busy)
);

uart_rx #(.CLKS_PER_BIT(16)) rx_unit (
    .clk(clk), .rst(rst),
    .rx(tx), .rx_data(rx_data),
    .rx_done(rx_done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

task send_byte;
    input [7:0] data;
    begin
        @(negedge clk);
        tx_data = data;
        tx_start = 1;

        @(negedge clk);
        tx_start = 0;

        wait(rx_done);

        #1;
        $display("TX = %h | RX = %h | %s",
                 data, rx_data,
                 (data == rx_data) ? "PASS" : "FAIL");

        wait(!tx_busy);
        repeat(3) @(negedge clk);
    end
endtask

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

    rst = 1;
    tx_start = 0;
    tx_data = 0;

    repeat(5) @(negedge clk);
    rst = 0;

    send_byte(8'hA5);
    send_byte(8'h55);
    send_byte(8'hAA);
    send_byte(8'hFF);
    send_byte(8'h00);

    $display("ALL TESTS COMPLETED");

    #50;
    $finish;
end

endmodule
