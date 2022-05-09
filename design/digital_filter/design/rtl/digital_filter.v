`default_nettype none
// digital filter top
module digital_filter (
    input wire clk,
    input wire rst_n,
    input wire unsigned data_in,
    output reg unsigned [11:0] data_out,
    output reg new_data
);
    
    wire unsigned [8:0] int_1_out;
    wire unsigned [17:0] int_2_out;
    reg rst_n_d1, rst_n_d2;

    always @(posedge clk) begin
        rst_n_d1 <= rst_n;
        rst_n_d2 <= rst_n_d1;
    end

    integrator_1 int_1 (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(int_1_out)
    );

    integrator_2 int_2 (
        .clk(clk),
        .rst_n(rst_n_d1),
        .data_in(int_1_out),
        .data_out(int_2_out)
    );

    decimator decim (
        .clk(clk),
        .rst_n(rst_n_d2),
        .data_in(int_2_out[17:6]),
        .data_out(data_out),
        .new_data(new_data)
    );

endmodule