module tsi_switch_tb;

    // Inputs
    reg clk;
    reg reset;
    reg input_valid;
    reg control_write;

    reg stream_in_1;
    reg stream_in_2;
    reg stream_in_3;
    reg stream_in_4;
    reg stream_in_5;
    reg stream_in_6;
    reg stream_in_7;
    reg stream_in_8;

    reg [4:0] control_addr;
    reg [15:0] control_data;

    // Outputs
    wire stream_out_1;
    wire stream_out_2;
    wire stream_out_3;
    wire stream_out_4;
    wire stream_out_5;
    wire stream_out_6;
    wire stream_out_7;
    wire stream_out_8;
	 
    reg [31:0] pattern1 = 32'h4433_2211;
    reg [31:0] pattern2 = 32'h8877_6655;
    reg [31:0] pattern3 = 32'hCCBB_AA99;
    reg [31:0] pattern4 = 32'h65FF_EEDD;
    reg [31:0] pattern5 = 32'hA1A2_A3A4;
    reg [31:0] pattern6 = 32'hB1B2_B3B4;
    reg [31:0] pattern7 = 32'hC1C2_C3C4;
    reg [31:0] pattern8 = 32'hD1D2_D3D4;
	 
    integer i, m;

    // DUT INSTANCE
    tsi_switch dut (
        .clk(clk),
        .reset(reset),
        .input_valid(input_valid),
        .control_write(control_write),
        .control_addr(control_addr),
        .control_data(control_data),

        .stream_in_1(stream_in_1),
        .stream_in_2(stream_in_2),
        .stream_in_3(stream_in_3),
        .stream_in_4(stream_in_4),
        .stream_in_5(stream_in_5),
        .stream_in_6(stream_in_6),
        .stream_in_7(stream_in_7),
        .stream_in_8(stream_in_8),

        .stream_out_1(stream_out_1),
        .stream_out_2(stream_out_2),
        .stream_out_3(stream_out_3),
        .stream_out_4(stream_out_4),
        .stream_out_5(stream_out_5),
        .stream_out_6(stream_out_6),
        .stream_out_7(stream_out_7),
        .stream_out_8(stream_out_8)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end

    // Basic stimulus
    initial begin
        reset = 1;
        input_valid = 0;
        control_write = 0;
        control_addr = 0;
        control_data = 0;

        stream_in_1=0; stream_in_2=0; stream_in_3=0; stream_in_4=0;
        stream_in_5=0; stream_in_6=0; stream_in_7=0; stream_in_8=0;

        #100 reset = 0;
        #50
        control_write=1;
        @(posedge clk);
        control_addr <= 5'd0;
        control_data <= 16'h2005;

        @(posedge clk);
        control_addr <= 5'd1;
        control_data <= 16'h2007;

        @(posedge clk);
        control_addr <= 5'd2;
        control_data <= 16'h2001;

        @(posedge clk);
        control_addr <= 5'd3;
        control_data <= 16'h2009;

        @(posedge clk);
        control_addr <= 5'd4;
        control_data <= 16'h2006;

        @(posedge clk);
        control_addr <= 5'd5;
        control_data <= 16'h2002;

        @(posedge clk);
        control_addr <= 5'd6;
        control_data <= 16'h200E;

        @(posedge clk);
        control_addr <= 5'd7;
        control_data <= 16'h200C;

        @(posedge clk);
        control_addr <= 5'd8;
        control_data <= 16'h200A;

        @(posedge clk);
        control_addr <= 5'd9;
        control_data <= 16'h200D;

        @(posedge clk);
        control_addr <= 5'd10;
        control_data <= 16'h2008;

        @(posedge clk);
        control_addr <= 5'd11;
        control_data <= 16'h2003;

        @(posedge clk);
        control_addr <= 5'd12;
        control_data <= 16'h200F;

        @(posedge clk);
        control_addr <= 5'd13;
        control_data <= 16'h200B;

        @(posedge clk);
        control_addr <= 5'd14;
        control_data <= 16'h2004;

        @(posedge clk);
        control_addr <= 5'd15;
        control_data <= 16'h2000;

        @(posedge clk);
        control_addr <= 5'd16;
        control_data <= 16'h2010;

        @(posedge clk);
        control_addr <= 5'd17;
        control_data <= 16'h2011;

        @(posedge clk);
        control_addr <= 5'd18;
        control_data <= 16'h2012;

        @(posedge clk);
        control_addr <= 5'd19;
        control_data <= 16'h2013;

        @(posedge clk);
        control_addr <= 5'd20;
        control_data <= 16'h2014;

        @(posedge clk);
        control_addr <= 5'd21;
        control_data <= 16'h2015;

        @(posedge clk);
        control_addr <= 5'd22;
        control_data <= 16'h2016;

        @(posedge clk);
        control_addr <= 5'd23;
        control_data <= 16'h2017;

        @(posedge clk);
        control_addr <= 5'd24;
        control_data <= 16'h2018;

        @(posedge clk);
        control_addr <= 5'd25;
        control_data <= 16'h2019;

        @(posedge clk);
        control_addr <= 5'd26;
        control_data <= 16'h201A;

        @(posedge clk);
        control_addr <= 5'd27;
        control_data <= 16'h201F;

        @(posedge clk);
        control_addr <= 5'd28;
        control_data <= 16'h201C;

        @(posedge clk);
        control_addr <= 5'd29;
        control_data <= 16'h201D;

        @(posedge clk);
        control_addr <= 5'd30;
        control_data <= 16'h201E;

        @(posedge clk);
        control_addr <= 5'd31;
        control_data <= 16'h201B;

        @(posedge clk);
        control_write <= 1'b0;
        
        repeat (40) @(posedge clk);
            
        input_valid = 1;
        for (i = 0; i < 32; i = i + 1) begin
            stream_in_1 <= pattern1[i];
            stream_in_2 <= pattern2[i];
            stream_in_3 <= pattern3[i];
            stream_in_4 <= pattern4[i];
            stream_in_5 <= pattern5[i];
            stream_in_6 <= pattern6[i];
            stream_in_7 <= pattern7[i];
            stream_in_8 <= pattern8[i];
            @(posedge clk);
        end
        for (m = 0; m < 32; m = m + 1) begin
            stream_in_1 <= pattern1[m];
            stream_in_2 <= pattern2[m];
            stream_in_3 <= pattern3[m];
            stream_in_4 <= pattern4[m];
            stream_in_5 <= pattern5[m];
            stream_in_6 <= pattern6[m];
            stream_in_7 <= pattern7[m];
            stream_in_8 <= pattern8[m];
            @(posedge clk);
        end
        @(posedge clk);
        input_valid = 0;

        repeat (100) @(posedge clk);

        control_write=1;
        @(posedge clk);
        control_addr <= 5'd0;
        control_data <= 16'hA001;

        @(posedge clk);
        control_addr <= 5'd1;
        control_data <= 16'hA002;

        @(posedge clk);
        control_addr <= 5'd2;
        control_data <= 16'hA003;

        @(posedge clk);
        control_addr <= 5'd3;
        control_data <= 16'hA004;


        @(posedge clk);
        control_addr <= 5'd4;
        control_data <= 16'hA005;

        @(posedge clk);
        control_addr <= 5'd5;
        control_data <= 16'hA006;

        @(posedge clk);
        control_addr <= 5'd6;
        control_data <= 16'hA007;

        @(posedge clk);
        control_addr <= 5'd7;
        control_data <= 16'hA008;

        @(posedge clk);
        control_addr <= 5'd8;
        control_data <= 16'hA009;

        @(posedge clk);
        control_addr <= 5'd9;
        control_data <= 16'hA00A;

        @(posedge clk);
        control_addr <= 5'd10;
        control_data <= 16'hA00B;

        @(posedge clk);
        control_addr <= 5'd11;
        control_data <= 16'hA00C;

        @(posedge clk);
        control_addr <= 5'd12;
        control_data <= 16'hA00D;

        @(posedge clk);
        control_addr <= 5'd13;
        control_data <= 16'hA00E;

        @(posedge clk);
        control_addr <= 5'd14;
        control_data <= 16'hA00F;

        @(posedge clk);
        control_addr <= 5'd15;
        control_data <= 16'hA010;

        @(posedge clk);
        control_addr <= 5'd16;
        control_data <= 16'hA011;

        @(posedge clk);
        control_addr <= 5'd17;
        control_data <= 16'hA012;

        @(posedge clk);
        control_addr <= 5'd18;
        control_data <= 16'hA013;

        @(posedge clk);
        control_addr <= 5'd19;
        control_data <= 16'hA014;

        @(posedge clk);
        control_addr <= 5'd20;
        control_data <= 16'hA015;

        @(posedge clk);
        control_addr <= 5'd21;
        control_data <= 16'hA016;

        @(posedge clk);
        control_addr <= 5'd22;
        control_data <= 16'hA017;

        @(posedge clk);
        control_addr <= 5'd23;
        control_data <= 16'hA018;

        @(posedge clk);
        control_addr <= 5'd24;
        control_data <= 16'hA019;

        @(posedge clk);
        control_addr <= 5'd25;
        control_data <= 16'hA01A;

        @(posedge clk);
        control_addr <= 5'd26;
        control_data <= 16'hA01B;

        @(posedge clk);
        control_addr <= 5'd27;
        control_data <= 16'hA01C;

        @(posedge clk);
        control_addr <= 5'd28;
        control_data <= 16'hA01D;

        @(posedge clk);
        control_addr <= 5'd29;
        control_data <= 16'hA01E;

        @(posedge clk);
        control_addr <= 5'd30;
        control_data <= 16'hA01F;

        @(posedge clk);
        control_addr <= 5'd31;
        control_data <= 16'hA000;  

        @(posedge clk);
        control_write <= 1'b0; 


        input_valid = 1;
        @(posedge clk);
        input_valid = 0;

        repeat (100) @(posedge clk);

        // end simulation
        #100 $finish;
        
    end
        
    initial begin
        $dumpfile("waveforms.vcd");
        $dumpvars(0,dut);
    end

endmodule