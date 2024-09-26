import AHP_MASTER_PKG ::*;

module AHP_TOP_tb() ;

logic HCLK                       ;
logic HRESETn                    ;

AHP_TOP TOP
(
 .HCLK(HCLK)                       ,
 .HRESETn(HRESETn)                        
);

always #1 HCLK = ~HCLK ;

initial 
 begin
   HCLK = 0 ;
   HRESETn = 0 ;
   @(negedge HCLK) ;
   HRESETn = 1 ;
   
   for(int i=0 ; i<256 ; i=i+1)
    begin
	  TOP.slave_1.SLAVE_MEM[i][7:0] = $random ;
	  TOP.slave_1.SLAVE_MEM[i][8] = 1 ;
	  TOP.slave_2.SLAVE_MEM[i][7:0] = $random ;
	  TOP.slave_2.SLAVE_MEM[i][8] = 1 ;
	end
	
 end
 
endmodule