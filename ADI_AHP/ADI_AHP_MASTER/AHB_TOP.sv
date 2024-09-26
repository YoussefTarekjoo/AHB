import AHP_SLAVE_PKG ::*;

module AHP_TOP
(
 input wire HCLK                       ,
 input wire HRESETn                        
);

logic [2:0] HBURST ;
logic HREADY , Enable_Transfer , HWRITE , HREADY1 , HREADY2 ;
logic [31:0] HRDATA , HWDATA , HADDR , HRDATA1 , HRDATA2 ;
logic [63:0] CPU_OUT ;
logic [1:0] HSIZE ;
logic [1:0] HTRANS_ENUM HTRANS ;
reg [1:0] SEL_SLAVE , SEL_SLAVE_reg ;

AHP_master master
(
 .HREADY(HREADY)                     ,
 .HCLK(HCLK)                         ,
 .Enable_Transfer(Enable_Transfer)   ,
 .HRESETn(HRESETn)                   ,
 .HRDATA(HRDATA)                     ,
 .CPU_OUT(CPU_OUT)                   ,
 .HADDR(HADDR)                       ,
 .HWRITE(HWRITE)                     ,
 .HSIZE(HSIZE)                       ,
 .HBURST(HBURST)                     ,
 .HTRANS(HTRANS)                     ,
 .HWDATA(HWDATA)                      
);

always @(posedge HCLK or negedge HRESETn)
 begin
   if(!HRESETn)
    begin
	  SEL_SLAVE_reg <= 0 ;
	end
   else
    begin
	  SEL_SLAVE_reg <= SEL_SLAVE ;
	end
 end
 
always @(*)
 begin
   SEL_SLAVE = 0 ;
   case(HADDR[18])
     1'b0 : begin
	   SEL_SLAVE[0] = 1 ;
	 end
	 
	 1'b1 : begin
	   SEL_SLAVE[1] = 1 ;
	 end
   endcase
 end
 
always@(*)
 begin
  case(SEL_SLAVE_reg)
     2'b01:
      begin
       HRDATA = HRDATA1 ;
       HREADY = HREADY1 ;     
      end
     2'b10:
      begin
       HRDATA = HRDATA2 ;
       HREADY = HREADY2 ;     
      end      
     default:
      begin
       HRDATA = 0 ;
       HREADY = 0 ;   
      end
    endcase
 end
 
AHP_slave slave_1
(
 .HREADY(HREADY1)                   ,
 .HSEL(SEL_SLAVE_reg[0])            ,
 .HCLK(HCLK)                        ,
 .HRESETn(HRESETn)                  ,
 .HTRANS(HTRANS)                    ,
 .HBURST(HBURST)                    ,
 .HRDATA(HRDATA1)                   ,
 .HWRITE(HWRITE)                    ,
 .HSIZE(HSIZE)                      ,
 .HADDR(HADDR)                      , 
 .HWDATA(HWDATA)              
);

AHP_slave slave_2
(
 .HREADY(HREADY2)                   ,
 .HSEL(SEL_SLAVE_reg[1])            ,
 .HCLK(HCLK)                        ,
 .HRESETn(HRESETn)                  ,
 .HTRANS(HTRANS)                    ,
 .HBURST(HBURST)                    ,
 .HRDATA(HRDATA2)                   ,
 .HWRITE(HWRITE)                    ,
 .HSIZE(HSIZE)                      ,
 .HADDR(HADDR)                      , 
 .HWDATA(HWDATA)              
);
 
endmodule

