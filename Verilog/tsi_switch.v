module tsi_switch(clk,reset,input_valid ,control_write,sync,control_addr,control_data,
				stream_in_1,stream_in_2,stream_in_3,stream_in_4,stream_in_5,stream_in_6,stream_in_7,stream_in_8,
				stream_out_1,stream_out_2,stream_out_3,stream_out_4,stream_out_5,stream_out_6,stream_out_7,stream_out_8);
				
				
		
//--------------------------------------------------------------------------------------//
//            						Input PINS				                            //
//--------------------------------------------------------------------------------------//	
				
input clk,reset,input_valid ,control_write,
		stream_in_1,stream_in_2,stream_in_3,stream_in_4,stream_in_5,stream_in_6,stream_in_7,stream_in_8;
		
input[4:0]control_addr;
input [15:0]control_data;


//--------------------------------------------------------------------------------------//
//            						Output PINS                                         //
//--------------------------------------------------------------------------------------//	

		
output reg stream_out_1,stream_out_2,stream_out_3,stream_out_4,stream_out_5,stream_out_6,stream_out_7,stream_out_8,sync;


//--------------------------------------------------------------------------------------//
//            					Intearnal Registers                                 	//
//--------------------------------------------------------------------------------------//	
reg [7:0] buf1[0:31];
reg[7:0] buf2 [0:31]; 
reg [15:0] control_reg [0:31];

reg [1:0]state;
reg [4:0]row_index_1,row_index_2,row_index_3,row_index_4,row_index_5,row_index_6,row_index_7,row_index_8;
reg [2:0]bit_index;
reg tx_incomplete;



//--------------------------------------------------------------------------------------//
//            		Control Registers -   Reset and Writing Operation                   //
//--------------------------------------------------------------------------------------//	

always @(posedge clk)
begin
	if (reset)    
	begin                                 
		control_reg[5'd0] <= 16'h0000;
		control_reg[5'd1] <= 16'h0000;
		control_reg[5'd2] <= 16'h0000;
		control_reg[5'd3] <= 16'h0000;
		control_reg[5'd4] <= 16'h0000;
		control_reg[5'd5] <= 16'h0000;
		control_reg[5'd6] <= 16'h0000;
		control_reg[5'd7] <= 16'h0000;
		control_reg[5'd8] <= 16'h0000;
		control_reg[5'd9] <= 16'h0000;
		control_reg[5'd10] <= 16'h0000;
		control_reg[5'd11] <= 16'h0000;
		control_reg[5'd12] <= 16'h0000;
		control_reg[5'd13] <= 16'h0000;
		control_reg[5'd14] <= 16'h0000;
		control_reg[5'd15] <= 16'h0000;
		control_reg[5'd16] <= 16'h0000;
		control_reg[5'd17] <= 16'h0000;
		control_reg[5'd18] <= 16'h0000;
		control_reg[5'd19] <= 16'h0000;
		control_reg[5'd20] <= 16'h0000;
		control_reg[5'd21] <= 16'h0000;
		control_reg[5'd22] <= 16'h0000;
		control_reg[5'd23] <= 16'h0000;
		control_reg[5'd24] <= 16'h0000;
		control_reg[5'd25] <= 16'h0000;
		control_reg[5'd26] <= 16'h0000;
		control_reg[5'd27] <= 16'h0000;
		control_reg[5'd28] <= 16'h0000;
		control_reg[5'd29] <= 16'h0000;
		control_reg[5'd30] <= 16'h0000;
		control_reg[5'd31] <= 16'h0000;
			
	end
	else if(control_write)
	begin	
		control_reg[control_addr[4:0]] <= control_data[15:0];
	end
	
end



//--------------------------------------------------------------------------------------//
//            						The main code FSM                                   //
//--------------------------------------------------------------------------------------//	

always@(posedge clk)
begin
	if (reset)
	begin
				// |--------------------------------|
				// |  	   Reset conditions			|
				// |--------------------------------|
				
			bit_index<=3'd7;  		// 0–7					|-----------------------------------------------------|				
			row_index_1<=5'b11111;  // 0–3					|		Reset the row and colum pointers.					|		
			row_index_2<=5'b00011;  // 4-7					|Bit index goes from 0 to 7 and row_index_1 foes from |									
			row_index_3<=5'b00111;  // 8-11					| 0 to 3 , row_index 3 foes from 4 to 7 and so on		|																	|		
			row_index_4<=5'b01011;  // 12-15				|-----------------------------------------------------|	
			row_index_5<=5'b01111;  // 0–3
			row_index_6<=5'b10011;  // 4-7
			row_index_7<=5'b10111;  // 8-11
			row_index_8<=5'b11011;  // 12-15
			
			buf1[0]<=8'd0;   buf2[0]<=8'd0;
			buf1[1]<=8'd0;   buf2[1]<=8'd0;
			buf1[2]<=8'd0;   buf2[2]<=8'd0;				
			buf1[3]<=8'd0;   buf2[3]<=8'd0;
			buf1[4]<=8'd0;   buf2[4]<=8'd0;
			buf1[5]<=8'd0;   buf2[5]<=8'd0;
			buf1[6]<=8'd0;   buf2[6]<=8'd0;
			buf1[7]<=8'd0;   buf2[7]<=8'd0;
			buf1[8]<=8'd0;   buf2[8]<=8'd0;
			buf1[9]<=8'd0;   buf2[9]<=8'd0;
			buf1[10]<=8'd0;  buf2[10]<=8'd0;
			buf1[11]<=8'd0;  buf2[11]<=8'd0;	//                      |-------------------------------------------------------|
			buf1[12]<=8'd0;  buf2[12]<=8'd0;	//						| buf 1 and buf 2 are temporary register,(32x8 bits) 	|
			buf1[13]<=8'd0;  buf2[13]<=8'd0;	//						| which are  reset here. Data coming from input is  	|
			buf1[14]<=8'd0;  buf2[14]<=8'd0;	//						| stored in buf 2 for first 32 cycles, then moved to 	|
			buf1[15]<=8'd0;  buf2[15]<=8'd0;	//						| buf 2 in one clock cycle and then the next incoming	|
			buf1[16]<=8'd0;  buf2[16]<=8'd0;	//						|bits are stored in buf1 again , while buf2 is used 	|
			buf1[17]<=8'd0;  buf2[17]<=8'd0;	//						| to send the data out . 								|
			buf1[18]<=8'd0;  buf2[18]<=8'd0;	//						|														|
			buf1[19]<=8'd0;  buf2[19]<=8'd0;	//						|-------------------------------------------------------|
			buf1[20]<=8'd0;  buf2[20]<=8'd0;
			buf1[21]<=8'd0;  buf2[21]<=8'd0;
			buf1[22]<=8'd0;  buf2[22]<=8'd0;
			buf1[23]<=8'd0;  buf2[23]<=8'd0;
			buf1[24]<=8'd0;  buf2[24]<=8'd0;
			buf1[25]<=8'd0;  buf2[25]<=8'd0;
			buf1[26]<=8'd0;  buf2[26]<=8'd0;
			buf1[27]<=8'd0;  buf2[27]<=8'd0;
			buf1[28]<=8'd0;  buf2[28]<=8'd0;
			buf1[29]<=8'd0;  buf2[29]<=8'd0;
			buf1[30]<=8'd0;  buf2[30]<=8'd0;
			buf1[31]<=8'd0;  buf2[31]<=8'd0;
			
			sync <= 1'b0;
			
         stream_out_1 <= 1'b0; 
			stream_out_2 <= 1'b0; 
			stream_out_3 <= 1'b0; 	
			stream_out_4 <= 1'b0;
         stream_out_5 <= 1'b0; 
			stream_out_6 <= 1'b0; 
			stream_out_7 <= 1'b0; 
			stream_out_8 <= 1'b0;

			tx_incomplete<=1'b0;
			state<=2'd0;
	end
	
	else
	begin
		if(input_valid | tx_incomplete)
		begin
			case(state)
				// |------------------------------------------------------|					
				// |  	   State 0 is the state just after reset. 		  |
				// |	 No data is available in  buf2 to be transmitted. |
				// |    Only the incoming data is being stored in buf1.   |
				// |------------------------------------------------------|
			
			2'd0:																					
			begin
					buf1[row_index_1][bit_index] <= stream_in_1;
					buf1[row_index_2][bit_index] <= stream_in_2;
					buf1[row_index_3][bit_index] <= stream_in_3;
					buf1[row_index_4][bit_index] <= stream_in_4;
					buf1[row_index_5][bit_index] <= stream_in_5;
					buf1[row_index_6][bit_index] <= stream_in_6;
					buf1[row_index_7][bit_index] <= stream_in_7;
					buf1[row_index_8][bit_index] <= stream_in_8;
						
					tx_incomplete<=1'b1;
					stream_out_1<=1'b0;
					stream_out_2<=1'b0;
					stream_out_3<=1'b0;
					stream_out_4<=1'b0;
					stream_out_5<=1'b0;
					stream_out_6<=1'b0;
					stream_out_7<=1'b0;
					stream_out_8<=1'b0;

					if(bit_index==3'd7 && row_index_1==5'd3)
					begin
						// bit_index<=3'd0;									// |---------------------------------|
						row_index_1<=5'd0;									// | This condition shows 32 bits    |
						row_index_2<=5'd4;									// | have arrived in each input      |
						row_index_3<=5'd8;									// | stream and buf 1 is completely  |
						row_index_4<=5'd12;									// |	filled. So go to next state.	 |
						row_index_5<=5'd16;									// |---------------------------------|
						row_index_6<=5'd20;
						row_index_7<=5'd24;
						row_index_8<=5'd28;
						state<=2'd1;
					end
						
							
						else if(bit_index==3'd7)								// 	|--------------------------|
							begin												//	| Go to next row after 	   |
								bit_index<=3'd0;								//	| 		every 8 bits  	   |
								row_index_1<=row_index_1+5'd1; 					// 	|--------------------------|
								row_index_2<=row_index_2+5'd1;				
								row_index_3<=row_index_3+5'd1;				
								row_index_4<=row_index_4+5'd1;				
								row_index_5<=row_index_5+5'd1; 
								row_index_6<=row_index_6+5'd1;
								row_index_7<=row_index_7+5'd1;
								row_index_8<=row_index_8+5'd1;
							end
						
						bit_index<=bit_index+1'd1;
				
				end
				
				2'd1:
				// |--------------------------------------------------------|					
				// |  	 As the buf1 is filled , copy buf1 to buf2 		 	|
				// |	 and also store the next incoming bit from stream   |
				// |   input stream to buf1. This state stays for only    	|
				// |      					one clock cycle                 |   
				// |--------------------------------------------------------|
					begin
						bit_index<=3'd0;
						buf2[5'd0]  <= buf1[5'd0]; 
						buf2[5'd1]  <= buf1[5'd1]; 
						buf2[5'd2]  <= buf1[5'd2]; 
						buf2[5'd3]  <= buf1[5'd3];
						buf2[5'd4]  <= buf1[5'd4];
						buf2[5'd5]  <= buf1[5'd5]; 
						buf2[5'd6]  <= buf1[5'd6];
						buf2[5'd7]  <= buf1[5'd7];
						buf2[5'd8]  <= buf1[5'd8]; 
						buf2[5'd9]  <= buf1[5'd9]; 
						buf2[5'd10] <= buf1[5'd10]; 
						buf2[5'd11] <= buf1[5'd11];
						buf2[5'd12] <= buf1[5'd12]; 
						buf2[5'd13] <= buf1[5'd13]; 
						buf2[5'd14] <= buf1[5'd14]; 
						buf2[5'd15] <= buf1[5'd15];
						buf2[5'd16] <= buf1[5'd16]; 
						buf2[5'd17] <= buf1[5'd17]; 
						buf2[5'd18] <= buf1[5'd18]; 
						buf2[5'd19] <= buf1[5'd19]; 
						buf2[5'd20] <= buf1[5'd20]; 
						buf2[5'd21] <= buf1[5'd21]; 
						buf2[5'd22] <= buf1[5'd22];
						buf2[5'd23] <= buf1[5'd23];
						buf2[5'd24] <= buf1[5'd24]; 
						buf2[5'd25] <= buf1[5'd25]; 
						buf2[5'd26] <= buf1[5'd26];
						buf2[5'd27] <= buf1[5'd27];
						buf2[5'd28] <= buf1[5'd28]; 
						buf2[5'd29] <= buf1[5'd29]; 
						buf2[5'd30] <= buf1[5'd30]; 
						buf2[5'd31] <= buf1[5'd31];


						buf1[row_index_1][bit_index] <= stream_in_1;
						buf1[row_index_2][bit_index] <= stream_in_2;
						buf1[row_index_3][bit_index] <= stream_in_3;
						buf1[row_index_4][bit_index] <= stream_in_4;
						buf1[row_index_5][bit_index] <= stream_in_5;
						buf1[row_index_6][bit_index] <= stream_in_6;
						buf1[row_index_7][bit_index] <= stream_in_7;
						buf1[row_index_8][bit_index] <= stream_in_8;
						
						sync<=1'b1;
						state<=2'd2;
						tx_incomplete<=1'b1;
						
						
						// |------------------------------------------------------------|					
						// | Checks if OE bit is high . If its low , transmit 0    		|
						// |	or else check PC bit. If PC is also High , data is in   |
						// |  control register itself. If PC is low , control register  |
						// |  has the address to the data stored in buf2				|
						// |------------------------------------------------------------|
						
						
						stream_out_1 <= control_reg[row_index_1][13] ?(control_reg[row_index_1][15] == 1'b0 ?
								buf1[control_reg[row_index_1][4:0]][bit_index] :
                    			control_reg[row_index_1][bit_index]) :
								1'b0;
							
						stream_out_2 <= control_reg[row_index_2][13] ?(control_reg[row_index_2][15] == 1'b0 ?
								buf1[control_reg[row_index_2][4:0]][bit_index] :
                    			control_reg[row_index_2][bit_index]) :
								1'b0;
							
						stream_out_3 <= control_reg[row_index_3][13] ?(control_reg[row_index_3][15] == 1'b0 ?
								buf1[control_reg[row_index_3][4:0]][bit_index] :
                    			control_reg[row_index_3][bit_index]) :
								1'b0;
							
						stream_out_4 <= control_reg[row_index_4][13] ?(control_reg[row_index_4][15] == 1'b0 ?
								buf1[control_reg[row_index_4][4:0]][bit_index] :
                    			control_reg[row_index_4][bit_index]) :
								1'b0;
							
						stream_out_5 <= control_reg[row_index_5][13] ?(control_reg[row_index_5][15] == 1'b0 ?
								buf1[control_reg[row_index_5][4:0]][bit_index] :
                    			control_reg[row_index_5][bit_index]) :
								1'b0;
							
						stream_out_6 <= control_reg[row_index_6][13] ?(control_reg[row_index_6][15] == 1'b0 ?
								buf1[control_reg[row_index_6][4:0]][bit_index] :
								control_reg[row_index_6][bit_index]) :
								1'b0;
							
						stream_out_7 <= control_reg[row_index_7][13] ?(control_reg[row_index_7][15] == 1'b0 ?
								buf1[control_reg[row_index_7][4:0]][bit_index] :
								control_reg[row_index_7][bit_index]) :
								1'b0;
							
						stream_out_8 <= control_reg[row_index_8][13] ?(control_reg[row_index_8][15] == 1'b0 ?
								buf1[control_reg[row_index_8][4:0]][bit_index] :
								control_reg[row_index_8][bit_index]) :
								1'b0;
							
							bit_index<=bit_index+1'd1;

						end
					
					2'd2:
						// |------------------------------------------------------|					
						// |  	 	Same as the state 1 except for that the		  |									 
						// |	   	 		buf 1 is not copied in buf2			  |									
						// |       	buf1 is taking in the data and buf2 is 		  |					
						// |   	 used to transmit the previously received data	  |                              
						// |------------------------------------------------------|
					
						begin
						buf1[row_index_1][bit_index] <= stream_in_1;
						buf1[row_index_2][bit_index] <= stream_in_2;
						buf1[row_index_3][bit_index] <= stream_in_3;
						buf1[row_index_4][bit_index] <= stream_in_4;
						buf1[row_index_5][bit_index] <= stream_in_5;
						buf1[row_index_6][bit_index] <= stream_in_6;
						buf1[row_index_7][bit_index] <= stream_in_7;
						buf1[row_index_8][bit_index] <= stream_in_8;
						
						sync<=1'b0;
						state<=2'd2;
						tx_incomplete<=1'b1;
						
						stream_out_1 <= control_reg[row_index_1][13] ?(control_reg[row_index_1][15] == 1'b0 ?
								buf2[control_reg[row_index_1][4:0]][bit_index] :
                    			control_reg[row_index_1][bit_index]) :
								1'b0;
							
						stream_out_2 <= control_reg[row_index_2][13] ?(control_reg[row_index_2][15] == 1'b0 ?
								buf2[control_reg[row_index_2][4:0]][bit_index] :
                    			control_reg[row_index_2][bit_index]) :
								1'b0;
							
						stream_out_3 <= control_reg[row_index_3][13] ?(control_reg[row_index_3][15] == 1'b0 ?
								buf2[control_reg[row_index_3][4:0]][bit_index] :
                    			control_reg[row_index_3][bit_index]) :
								1'b0;
							
						stream_out_4 <= control_reg[row_index_4][13] ?(control_reg[row_index_4][15] == 1'b0 ?
								buf2[control_reg[row_index_4][4:0]][bit_index] :
                    			control_reg[row_index_4][bit_index]) :
								1'b0;
							
						stream_out_5 <= control_reg[row_index_5][13] ?(control_reg[row_index_5][15] == 1'b0 ?
								buf2[control_reg[row_index_5][4:0]][bit_index] :
                    			control_reg[row_index_5][bit_index]) :
								1'b0;
							
						stream_out_6 <= control_reg[row_index_6][13] ?(control_reg[row_index_6][15] == 1'b0 ?
								buf2[control_reg[row_index_6][4:0]][bit_index] :
                    			control_reg[row_index_6][bit_index]) :
								1'b0;
							
						stream_out_7 <= control_reg[row_index_7][13] ?(control_reg[row_index_7][15] == 1'b0 ?
								buf2[control_reg[row_index_7][4:0]][bit_index] :
                    			control_reg[row_index_7][bit_index]) :
								1'b0;
							
						stream_out_8 <= control_reg[row_index_8][13] ?(control_reg[row_index_8][15] == 1'b0 ?
								buf2[control_reg[row_index_8][4:0]][bit_index] :
                    			control_reg[row_index_8][bit_index]) :
								1'b0;
							
						
						if(bit_index==3'd7 && row_index_1==5'd3)
						begin
							bit_index<=3'd0;
							row_index_1<=5'd0;
							row_index_2<=5'd4;
							row_index_3<=5'd8;
							row_index_4<=5'd12;
							row_index_5<=5'd16;
							row_index_6<=5'd20;
							row_index_7<=5'd24;
							row_index_8<=5'd28;
							sync <= 1'b0;
							stream_out_1 <= 1'b0; 
							stream_out_2 <= 1'b0; 
							stream_out_3 <= 1'b0; 
							stream_out_4 <= 1'b0;
							stream_out_5 <= 1'b0; 
							stream_out_6 <= 1'b0; 
							stream_out_7 <= 1'b0; 
							stream_out_8 <= 1'b0;

							if(input_valid)
							begin
								state<=2'd1;
							end
							else
							begin
								state<=2'd0;
								tx_incomplete<=1'b0;
							end

						end
						
							
						else if(bit_index==3'd7)
							begin
								bit_index<=3'd0;
								row_index_1<=row_index_1+5'd1; 
								row_index_2<=row_index_2+5'd1;
								row_index_3<=row_index_3+5'd1;
								row_index_4<=row_index_4+5'd1;
								row_index_5<=row_index_5+5'd1; 
								row_index_6<=row_index_6+5'd1;
								row_index_7<=row_index_7+5'd1;
								row_index_8<=row_index_8+5'd1;
							end

						bit_index<=bit_index+1'd1;
						
						
						end
				
			endcase
	end
end
end

endmodule
