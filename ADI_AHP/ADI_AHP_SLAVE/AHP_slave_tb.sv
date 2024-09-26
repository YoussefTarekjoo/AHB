import AHP_SLAVE_PKG ::*;

module AHP_slave_tb() ;

logic HREADY                     ;
logic HSEL                       ;
logic HCLK                       ;
logic HRESETn                    ;
HTRANS_ENUM HTRANS               ;
logic [2:0] HBURST               ;
logic [31:0] HRDATA              ;
logic HWRITE                     ;
logic [1:0] HSIZE                ;
logic [31:0] HADDR               ;
logic [31:0] HWDATA              ;

AHP_slave slave
(
 .HREADY(HREADY)                    ,
 .HSEL(HSEL)                        ,
 .HCLK(HCLK)                        ,
 .HRESETn(HRESETn)                  ,
 .HTRANS(HTRANS)                    ,
 .HBURST(HBURST)                    ,
 .HRDATA(HRDATA)                    ,
 .HWRITE(HWRITE)                    ,
 .HSIZE(HSIZE)                      ,
 .HADDR(HADDR)                      ,
 .HWDATA(HWDATA)              
);

always #1 HCLK = ~HCLK ;

initial 
 begin
  HCLK = 0 ;
  HRESETn = 0 ;
  HSEL = 1 ;
  HTRANS = IDLE ;
  HBURST = 0 ;
  HWRITE = 1 ;
  HSIZE = 0 ;
  HADDR = 0 ;
  HWDATA = 0 ;
  @(negedge HCLK) ;
  HRESETn = 1 ;
  for(int i=0 ; i<240 ;i=i+1)
   begin
    slave.SLAVE_MEM[i][7:0] = $random ;
	slave.SLAVE_MEM[i][8] = 1 ;
   end
   
  HTRANS = NON_SEQ ; 

  repeat(100)
   begin
     HWRITE = $random ;
	 HWDATA = $random ;
	 HSIZE = $random ;
	 HADDR = $random ;
	 @(negedge HCLK) ;
   end
  
  HTRANS = SEQ ; 
   
  repeat(100)
   begin
     HWRITE = $random ;
	 HWDATA = $random ;
	 HSIZE = $random ;
	 HADDR = $random ;
	 @(negedge HCLK) ;
   end
  
  $stop ;
 end

endmodule