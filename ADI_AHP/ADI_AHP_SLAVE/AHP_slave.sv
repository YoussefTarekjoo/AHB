import AHP_SLAVE_PKG ::*;

module AHP_slave
(
 output reg HREADY                     ,
 input wire HSEL                       ,
 input wire HCLK                       ,
 input wire HRESETn                    ,
 input wire  HTRANS_ENUM HTRANS        ,
 input wire [2:0] HBURST               ,
 output reg [31:0] HRDATA              ,
 input wire HWRITE                     ,
 input wire [1:0] HSIZE                ,
 input wire [31:0] HADDR               ,
 input wire [31:0] HWDATA              
);

//due to that slave_mem of size 256 we can address it by using 8 bits address

reg ready_flag ;
reg [8:0] SLAVE_MEM [255:0] ;
reg HTRANS_reg ;
reg [2:0] HBURST_reg ;
reg HWRITE_reg ;
reg [2:0] HSIZE_reg ;
reg [31:0] HADDR_reg ;
reg [31:0] HWDATA_reg ;
reg HSEL_reg ;

always @(*)
 begin
   ready_flag = SLAVE_MEM[HADDR[7:0]][8] ;
   if(!HWRITE && !ready_flag)
    HREADY = 0 ;
   else
    HREADY = 1 ;
 end

always @(posedge HCLK or negedge HRESETn)
 begin
  if(!HRESETn)
   begin
     HBURST_reg <= 0 ;
	 HTRANS_reg <= 0 ;
	 HWRITE_reg <= 0 ;
	 HSIZE_reg <= 0 ;
	 HADDR_reg <= 0 ;
	 HWDATA_reg <= 0 ;
	 HSEL_reg <= 0 ;
	 for(int i=0 ; i<256 ;i=i+1)
	  SLAVE_MEM[i] = 0 ;
   end
  else
   begin
     HBURST_reg <= HBURST ;
	 HTRANS_reg <= HTRANS ;
	 HWRITE_reg <= HWRITE ;
	 HSIZE_reg <= HSIZE ;
	 HADDR_reg <= HADDR ;
	 HWDATA_reg <= HWDATA ;
	 HSEL_reg <= HSEL ;
   end
 
 end
 
always @(posedge HCLK or negedge HRESETn)
 begin
  if(!HRESETn)
   begin
     HRDATA <= 0 ;
   end
   //write in slave_memory
  else if((HTRANS_reg == NON_SEQ || HTRANS_reg == SEQ) && HSEL_reg && HWRITE_reg)
   begin
     case(HSIZE_reg)
	  // byte
	  2'b00 : begin
	    SLAVE_MEM[HADDR_reg[7:0]] <= {1,HWDATA[7:0]} ;
	  end
	  
	  // half_word
	  2'b01 : begin
	    SLAVE_MEM[HADDR_reg[7:0]] <= {1,HWDATA[7:0]} ;
		SLAVE_MEM[HADDR_reg[7:0]+1] <= {1,HWDATA[15:8]} ;
	  end
	  
	  // word
	  2'b10 : begin
	    SLAVE_MEM[HADDR_reg[7:0]] <= {1,HWDATA[7:0]} ;
		SLAVE_MEM[HADDR_reg[7:0]+1] <= {1,HWDATA[15:8]} ;
		SLAVE_MEM[HADDR_reg[7:0]+2] <= {1,HWDATA[23:16]} ;
		SLAVE_MEM[HADDR_reg[7:0]+3] <= {1,HWDATA[31:24]} ;
	  end
	  
	  // default
	  default : begin
        SLAVE_MEM[HADDR_reg[7:0]] <= 0 ;
	  end
	  
	 endcase
   end
   
  //read from slave_memory
  else if((HTRANS == NON_SEQ || HTRANS == SEQ) && HSEL && (!HWRITE))
   begin
     case(HSIZE)
	  // byte
	  2'b00 : begin
	    HRDATA[7:0] <= SLAVE_MEM[HADDR[7:0]] ;
		HRDATA[31:8] <= 0 ;
	  end
	  
	  // half_word
	  2'b01 : begin
	    HRDATA[7:0] <= SLAVE_MEM[HADDR[7:0]] ;
		HRDATA[15:8] <= SLAVE_MEM[HADDR[7:0]+1] ;
		HRDATA[31:16] <= 0 ;
	  end
	  
	  2'b10 : begin
	    HRDATA[7:0] <= SLAVE_MEM[HADDR[7:0]] ;
		HRDATA[15:8] <= SLAVE_MEM[HADDR[7:0]+1] ;
		HRDATA[23:16] <= SLAVE_MEM[HADDR[7:0]+2] ;
		HRDATA[31:24] <= 0 ;
	  end
	  
	  // default
	  default : begin
        HRDATA <= 0 ;
	  end
	  
	 endcase
   end
 end

endmodule