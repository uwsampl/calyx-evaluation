/* verilator lint_off WIDTH */
module std_reg
  #(parameter width = 32)
   (input wire [width-1:0] in,
    input wire write_en,
    input wire clk,
    // output
    output logic [width - 1:0] out,
    output logic done);

  always_ff @(posedge clk) begin
    if (write_en) begin
      out <= in;
      done <= 1'd1;
    end else
      done <= 1'd0;
  end
endmodule

module std_add
  #(parameter width = 32)
  (input  logic [width-1:0] left,
    input  logic [width-1:0] right,
    output logic [width-1:0] out);
  assign out = left + right;
endmodule

module std_mult
  #(parameter width = 32)
  (input logic  [width-1:0] left,
    input logic  [width-1:0] right,
    output logic [width-1:0] out);
  assign out = left * right;
endmodule

module std_mem_d1
  #(parameter width = 32,
    parameter size = 16,
    parameter idx_size = 4)
   (input logic [idx_size-1:0] addr0,
    input logic [width-1:0]   write_data,
    input logic               write_en,
    input logic               clk,
    output logic [width-1:0]  read_data,
    output logic done);

  logic [width-1:0]  mem[size-1:0];

  assign read_data = mem[addr0];
  always_ff @(posedge clk) begin
    if (write_en) begin
      mem[addr0] <= write_data;
      done <= 1'd1;
    end else
      done <= 1'd0;
  end
endmodule

// Component Signature
module mac_pe (
      input wire [31:0] top,
      input wire [31:0] left,
      input wire go,
      input wire clk,
      output wire [31:0] down,
      output wire [31:0] right,
      output wire done
  );
  
  // Structure wire declarations
  wire [31:0] mul_left;
  wire [31:0] mul_right;
  wire [31:0] mul_out;
  wire [31:0] add_left;
  wire [31:0] add_right;
  wire [31:0] add_out;
  wire [31:0] mul_reg_in;
  wire mul_reg_write_en;
  wire mul_reg_clk;
  wire [31:0] mul_reg_out;
  wire mul_reg_done;
  wire [31:0] acc_in;
  wire acc_write_en;
  wire acc_clk;
  wire [31:0] acc_out;
  wire acc_done;
  wire [31:0] fsm0_in;
  wire fsm0_write_en;
  wire fsm0_clk;
  wire [31:0] fsm0_out;
  wire fsm0_done;
  
  // Subcomponent Instances
  std_mult #(32) mul (
      .left(mul_left),
      .right(mul_right),
      .out(mul_out)
  );
  
  std_add #(32) add (
      .left(add_left),
      .right(add_right),
      .out(add_out)
  );
  
  std_reg #(32) mul_reg (
      .in(mul_reg_in),
      .write_en(mul_reg_write_en),
      .clk(clk),
      .out(mul_reg_out),
      .done(mul_reg_done)
  );
  
  std_reg #(32) acc (
      .in(acc_in),
      .write_en(acc_write_en),
      .clk(clk),
      .out(acc_out),
      .done(acc_done)
  );
  
  std_reg #(32) fsm0 (
      .in(fsm0_in),
      .write_en(fsm0_write_en),
      .clk(clk),
      .out(fsm0_out),
      .done(fsm0_done)
  );
  
  // Input / output connections
  assign down = top;
  assign right = left;
  assign done = (fsm0_out == 32'd2) ? 1'd1 : '0;
  assign mul_left = (fsm0_out == 32'd0 & !mul_reg_done & go) ? top : '0;
  assign mul_right = (fsm0_out == 32'd0 & !mul_reg_done & go) ? left : '0;
  assign add_left = (fsm0_out == 32'd1 & !acc_done & go) ? acc_out : '0;
  assign add_right = (fsm0_out == 32'd1 & !acc_done & go) ? mul_reg_out : '0;
  assign mul_reg_in = (fsm0_out == 32'd0 & !mul_reg_done & go) ? mul_out : '0;
  assign mul_reg_write_en = (fsm0_out == 32'd0 & !mul_reg_done & go) ? 1'd1 : '0;
  assign acc_in = (fsm0_out == 32'd1 & !acc_done & go) ? add_out : '0;
  assign acc_write_en = (fsm0_out == 32'd1 & !acc_done & go) ? 1'd1 : '0;
  assign fsm0_in = (fsm0_out == 32'd1 & acc_done & go) ? 32'd2 : (fsm0_out == 32'd0 & mul_reg_done & go) ? 32'd1 : (fsm0_out == 32'd2) ? 32'd0 : '0;
  assign fsm0_write_en = (fsm0_out == 32'd0 & mul_reg_done & go | fsm0_out == 32'd1 & acc_done & go | fsm0_out == 32'd2) ? 1'd1 : '0;
endmodule // end mac_pe
// Component Signature
module main (
      input wire go,
      input wire clk,
      output wire done
  );
  
  // Structure wire declarations
  wire [31:0] left_11_read_in;
  wire left_11_read_write_en;
  wire left_11_read_clk;
  wire [31:0] left_11_read_out;
  wire left_11_read_done;
  wire [31:0] top_11_read_in;
  wire top_11_read_write_en;
  wire top_11_read_clk;
  wire [31:0] top_11_read_out;
  wire top_11_read_done;
  wire [31:0] pe_11_top;
  wire [31:0] pe_11_left;
  wire pe_11_go;
  wire pe_11_clk;
  wire [31:0] pe_11_down;
  wire [31:0] pe_11_right;
  wire pe_11_done;
  wire [31:0] right_10_write_in;
  wire right_10_write_write_en;
  wire right_10_write_clk;
  wire [31:0] right_10_write_out;
  wire right_10_write_done;
  wire [31:0] left_10_read_in;
  wire left_10_read_write_en;
  wire left_10_read_clk;
  wire [31:0] left_10_read_out;
  wire left_10_read_done;
  wire [31:0] top_10_read_in;
  wire top_10_read_write_en;
  wire top_10_read_clk;
  wire [31:0] top_10_read_out;
  wire top_10_read_done;
  wire [31:0] pe_10_top;
  wire [31:0] pe_10_left;
  wire pe_10_go;
  wire pe_10_clk;
  wire [31:0] pe_10_down;
  wire [31:0] pe_10_right;
  wire pe_10_done;
  wire [31:0] down_01_write_in;
  wire down_01_write_write_en;
  wire down_01_write_clk;
  wire [31:0] down_01_write_out;
  wire down_01_write_done;
  wire [31:0] left_01_read_in;
  wire left_01_read_write_en;
  wire left_01_read_clk;
  wire [31:0] left_01_read_out;
  wire left_01_read_done;
  wire [31:0] top_01_read_in;
  wire top_01_read_write_en;
  wire top_01_read_clk;
  wire [31:0] top_01_read_out;
  wire top_01_read_done;
  wire [31:0] pe_01_top;
  wire [31:0] pe_01_left;
  wire pe_01_go;
  wire pe_01_clk;
  wire [31:0] pe_01_down;
  wire [31:0] pe_01_right;
  wire pe_01_done;
  wire [31:0] down_00_write_in;
  wire down_00_write_write_en;
  wire down_00_write_clk;
  wire [31:0] down_00_write_out;
  wire down_00_write_done;
  wire [31:0] right_00_write_in;
  wire right_00_write_write_en;
  wire right_00_write_clk;
  wire [31:0] right_00_write_out;
  wire right_00_write_done;
  wire [31:0] left_00_read_in;
  wire left_00_read_write_en;
  wire left_00_read_clk;
  wire [31:0] left_00_read_out;
  wire left_00_read_done;
  wire [31:0] top_00_read_in;
  wire top_00_read_write_en;
  wire top_00_read_clk;
  wire [31:0] top_00_read_out;
  wire top_00_read_done;
  wire [31:0] pe_00_top;
  wire [31:0] pe_00_left;
  wire pe_00_go;
  wire pe_00_clk;
  wire [31:0] pe_00_down;
  wire [31:0] pe_00_right;
  wire pe_00_done;
  wire [1:0] l1_addr0;
  wire [31:0] l1_write_data;
  wire l1_write_en;
  wire l1_clk;
  wire [31:0] l1_read_data;
  wire l1_done;
  wire [1:0] l1_add_left;
  wire [1:0] l1_add_right;
  wire [1:0] l1_add_out;
  wire [1:0] l1_idx_in;
  wire l1_idx_write_en;
  wire l1_idx_clk;
  wire [1:0] l1_idx_out;
  wire l1_idx_done;
  wire [1:0] l0_addr0;
  wire [31:0] l0_write_data;
  wire l0_write_en;
  wire l0_clk;
  wire [31:0] l0_read_data;
  wire l0_done;
  wire [1:0] l0_add_left;
  wire [1:0] l0_add_right;
  wire [1:0] l0_add_out;
  wire [1:0] l0_idx_in;
  wire l0_idx_write_en;
  wire l0_idx_clk;
  wire [1:0] l0_idx_out;
  wire l0_idx_done;
  wire [1:0] t1_addr0;
  wire [31:0] t1_write_data;
  wire t1_write_en;
  wire t1_clk;
  wire [31:0] t1_read_data;
  wire t1_done;
  wire [1:0] t1_add_left;
  wire [1:0] t1_add_right;
  wire [1:0] t1_add_out;
  wire [1:0] t1_idx_in;
  wire t1_idx_write_en;
  wire t1_idx_clk;
  wire [1:0] t1_idx_out;
  wire t1_idx_done;
  wire [1:0] t0_addr0;
  wire [31:0] t0_write_data;
  wire t0_write_en;
  wire t0_clk;
  wire [31:0] t0_read_data;
  wire t0_done;
  wire [1:0] t0_add_left;
  wire [1:0] t0_add_right;
  wire [1:0] t0_add_out;
  wire [1:0] t0_idx_in;
  wire t0_idx_write_en;
  wire t0_idx_clk;
  wire [1:0] t0_idx_out;
  wire t0_idx_done;
  wire par_reset0_in;
  wire par_reset0_write_en;
  wire par_reset0_clk;
  wire par_reset0_out;
  wire par_reset0_done;
  wire par_done_reg0_in;
  wire par_done_reg0_write_en;
  wire par_done_reg0_clk;
  wire par_done_reg0_out;
  wire par_done_reg0_done;
  wire par_done_reg1_in;
  wire par_done_reg1_write_en;
  wire par_done_reg1_clk;
  wire par_done_reg1_out;
  wire par_done_reg1_done;
  wire par_done_reg2_in;
  wire par_done_reg2_write_en;
  wire par_done_reg2_clk;
  wire par_done_reg2_out;
  wire par_done_reg2_done;
  wire par_done_reg3_in;
  wire par_done_reg3_write_en;
  wire par_done_reg3_clk;
  wire par_done_reg3_out;
  wire par_done_reg3_done;
  wire par_reset1_in;
  wire par_reset1_write_en;
  wire par_reset1_clk;
  wire par_reset1_out;
  wire par_reset1_done;
  wire par_done_reg4_in;
  wire par_done_reg4_write_en;
  wire par_done_reg4_clk;
  wire par_done_reg4_out;
  wire par_done_reg4_done;
  wire par_done_reg5_in;
  wire par_done_reg5_write_en;
  wire par_done_reg5_clk;
  wire par_done_reg5_out;
  wire par_done_reg5_done;
  wire par_reset2_in;
  wire par_reset2_write_en;
  wire par_reset2_clk;
  wire par_reset2_out;
  wire par_reset2_done;
  wire par_done_reg6_in;
  wire par_done_reg6_write_en;
  wire par_done_reg6_clk;
  wire par_done_reg6_out;
  wire par_done_reg6_done;
  wire par_done_reg7_in;
  wire par_done_reg7_write_en;
  wire par_done_reg7_clk;
  wire par_done_reg7_out;
  wire par_done_reg7_done;
  wire par_reset3_in;
  wire par_reset3_write_en;
  wire par_reset3_clk;
  wire par_reset3_out;
  wire par_reset3_done;
  wire par_done_reg8_in;
  wire par_done_reg8_write_en;
  wire par_done_reg8_clk;
  wire par_done_reg8_out;
  wire par_done_reg8_done;
  wire par_done_reg9_in;
  wire par_done_reg9_write_en;
  wire par_done_reg9_clk;
  wire par_done_reg9_out;
  wire par_done_reg9_done;
  wire par_done_reg10_in;
  wire par_done_reg10_write_en;
  wire par_done_reg10_clk;
  wire par_done_reg10_out;
  wire par_done_reg10_done;
  wire par_done_reg11_in;
  wire par_done_reg11_write_en;
  wire par_done_reg11_clk;
  wire par_done_reg11_out;
  wire par_done_reg11_done;
  wire par_done_reg12_in;
  wire par_done_reg12_write_en;
  wire par_done_reg12_clk;
  wire par_done_reg12_out;
  wire par_done_reg12_done;
  wire par_reset4_in;
  wire par_reset4_write_en;
  wire par_reset4_clk;
  wire par_reset4_out;
  wire par_reset4_done;
  wire par_done_reg13_in;
  wire par_done_reg13_write_en;
  wire par_done_reg13_clk;
  wire par_done_reg13_out;
  wire par_done_reg13_done;
  wire par_done_reg14_in;
  wire par_done_reg14_write_en;
  wire par_done_reg14_clk;
  wire par_done_reg14_out;
  wire par_done_reg14_done;
  wire par_done_reg15_in;
  wire par_done_reg15_write_en;
  wire par_done_reg15_clk;
  wire par_done_reg15_out;
  wire par_done_reg15_done;
  wire par_done_reg16_in;
  wire par_done_reg16_write_en;
  wire par_done_reg16_clk;
  wire par_done_reg16_out;
  wire par_done_reg16_done;
  wire par_done_reg17_in;
  wire par_done_reg17_write_en;
  wire par_done_reg17_clk;
  wire par_done_reg17_out;
  wire par_done_reg17_done;
  wire par_done_reg18_in;
  wire par_done_reg18_write_en;
  wire par_done_reg18_clk;
  wire par_done_reg18_out;
  wire par_done_reg18_done;
  wire par_reset5_in;
  wire par_reset5_write_en;
  wire par_reset5_clk;
  wire par_reset5_out;
  wire par_reset5_done;
  wire par_done_reg19_in;
  wire par_done_reg19_write_en;
  wire par_done_reg19_clk;
  wire par_done_reg19_out;
  wire par_done_reg19_done;
  wire par_done_reg20_in;
  wire par_done_reg20_write_en;
  wire par_done_reg20_clk;
  wire par_done_reg20_out;
  wire par_done_reg20_done;
  wire par_done_reg21_in;
  wire par_done_reg21_write_en;
  wire par_done_reg21_clk;
  wire par_done_reg21_out;
  wire par_done_reg21_done;
  wire par_done_reg22_in;
  wire par_done_reg22_write_en;
  wire par_done_reg22_clk;
  wire par_done_reg22_out;
  wire par_done_reg22_done;
  wire par_done_reg23_in;
  wire par_done_reg23_write_en;
  wire par_done_reg23_clk;
  wire par_done_reg23_out;
  wire par_done_reg23_done;
  wire par_reset6_in;
  wire par_reset6_write_en;
  wire par_reset6_clk;
  wire par_reset6_out;
  wire par_reset6_done;
  wire par_done_reg24_in;
  wire par_done_reg24_write_en;
  wire par_done_reg24_clk;
  wire par_done_reg24_out;
  wire par_done_reg24_done;
  wire par_done_reg25_in;
  wire par_done_reg25_write_en;
  wire par_done_reg25_clk;
  wire par_done_reg25_out;
  wire par_done_reg25_done;
  wire par_done_reg26_in;
  wire par_done_reg26_write_en;
  wire par_done_reg26_clk;
  wire par_done_reg26_out;
  wire par_done_reg26_done;
  wire par_done_reg27_in;
  wire par_done_reg27_write_en;
  wire par_done_reg27_clk;
  wire par_done_reg27_out;
  wire par_done_reg27_done;
  wire par_done_reg28_in;
  wire par_done_reg28_write_en;
  wire par_done_reg28_clk;
  wire par_done_reg28_out;
  wire par_done_reg28_done;
  wire par_done_reg29_in;
  wire par_done_reg29_write_en;
  wire par_done_reg29_clk;
  wire par_done_reg29_out;
  wire par_done_reg29_done;
  wire par_reset7_in;
  wire par_reset7_write_en;
  wire par_reset7_clk;
  wire par_reset7_out;
  wire par_reset7_done;
  wire par_done_reg30_in;
  wire par_done_reg30_write_en;
  wire par_done_reg30_clk;
  wire par_done_reg30_out;
  wire par_done_reg30_done;
  wire par_done_reg31_in;
  wire par_done_reg31_write_en;
  wire par_done_reg31_clk;
  wire par_done_reg31_out;
  wire par_done_reg31_done;
  wire par_done_reg32_in;
  wire par_done_reg32_write_en;
  wire par_done_reg32_clk;
  wire par_done_reg32_out;
  wire par_done_reg32_done;
  wire par_reset8_in;
  wire par_reset8_write_en;
  wire par_reset8_clk;
  wire par_reset8_out;
  wire par_reset8_done;
  wire par_done_reg33_in;
  wire par_done_reg33_write_en;
  wire par_done_reg33_clk;
  wire par_done_reg33_out;
  wire par_done_reg33_done;
  wire par_done_reg34_in;
  wire par_done_reg34_write_en;
  wire par_done_reg34_clk;
  wire par_done_reg34_out;
  wire par_done_reg34_done;
  wire par_reset9_in;
  wire par_reset9_write_en;
  wire par_reset9_clk;
  wire par_reset9_out;
  wire par_reset9_done;
  wire par_done_reg35_in;
  wire par_done_reg35_write_en;
  wire par_done_reg35_clk;
  wire par_done_reg35_out;
  wire par_done_reg35_done;
  wire [31:0] fsm0_in;
  wire fsm0_write_en;
  wire fsm0_clk;
  wire [31:0] fsm0_out;
  wire fsm0_done;
  
  // Subcomponent Instances
  std_reg #(32) left_11_read (
      .in(left_11_read_in),
      .write_en(left_11_read_write_en),
      .clk(clk),
      .out(left_11_read_out),
      .done(left_11_read_done)
  );
  
  std_reg #(32) top_11_read (
      .in(top_11_read_in),
      .write_en(top_11_read_write_en),
      .clk(clk),
      .out(top_11_read_out),
      .done(top_11_read_done)
  );
  
  mac_pe #() pe_11 (
      .top(pe_11_top),
      .left(pe_11_left),
      .go(pe_11_go),
      .clk(clk),
      .down(pe_11_down),
      .right(pe_11_right),
      .done(pe_11_done)
  );
  
  std_reg #(32) right_10_write (
      .in(right_10_write_in),
      .write_en(right_10_write_write_en),
      .clk(clk),
      .out(right_10_write_out),
      .done(right_10_write_done)
  );
  
  std_reg #(32) left_10_read (
      .in(left_10_read_in),
      .write_en(left_10_read_write_en),
      .clk(clk),
      .out(left_10_read_out),
      .done(left_10_read_done)
  );
  
  std_reg #(32) top_10_read (
      .in(top_10_read_in),
      .write_en(top_10_read_write_en),
      .clk(clk),
      .out(top_10_read_out),
      .done(top_10_read_done)
  );
  
  mac_pe #() pe_10 (
      .top(pe_10_top),
      .left(pe_10_left),
      .go(pe_10_go),
      .clk(clk),
      .down(pe_10_down),
      .right(pe_10_right),
      .done(pe_10_done)
  );
  
  std_reg #(32) down_01_write (
      .in(down_01_write_in),
      .write_en(down_01_write_write_en),
      .clk(clk),
      .out(down_01_write_out),
      .done(down_01_write_done)
  );
  
  std_reg #(32) left_01_read (
      .in(left_01_read_in),
      .write_en(left_01_read_write_en),
      .clk(clk),
      .out(left_01_read_out),
      .done(left_01_read_done)
  );
  
  std_reg #(32) top_01_read (
      .in(top_01_read_in),
      .write_en(top_01_read_write_en),
      .clk(clk),
      .out(top_01_read_out),
      .done(top_01_read_done)
  );
  
  mac_pe #() pe_01 (
      .top(pe_01_top),
      .left(pe_01_left),
      .go(pe_01_go),
      .clk(clk),
      .down(pe_01_down),
      .right(pe_01_right),
      .done(pe_01_done)
  );
  
  std_reg #(32) down_00_write (
      .in(down_00_write_in),
      .write_en(down_00_write_write_en),
      .clk(clk),
      .out(down_00_write_out),
      .done(down_00_write_done)
  );
  
  std_reg #(32) right_00_write (
      .in(right_00_write_in),
      .write_en(right_00_write_write_en),
      .clk(clk),
      .out(right_00_write_out),
      .done(right_00_write_done)
  );
  
  std_reg #(32) left_00_read (
      .in(left_00_read_in),
      .write_en(left_00_read_write_en),
      .clk(clk),
      .out(left_00_read_out),
      .done(left_00_read_done)
  );
  
  std_reg #(32) top_00_read (
      .in(top_00_read_in),
      .write_en(top_00_read_write_en),
      .clk(clk),
      .out(top_00_read_out),
      .done(top_00_read_done)
  );
  
  mac_pe #() pe_00 (
      .top(pe_00_top),
      .left(pe_00_left),
      .go(pe_00_go),
      .clk(clk),
      .down(pe_00_down),
      .right(pe_00_right),
      .done(pe_00_done)
  );
  
  std_mem_d1 #(32, 2, 2) l1 (
      .addr0(l1_addr0),
      .write_data(l1_write_data),
      .write_en(l1_write_en),
      .clk(clk),
      .read_data(l1_read_data),
      .done(l1_done)
  );
  
  std_add #(2) l1_add (
      .left(l1_add_left),
      .right(l1_add_right),
      .out(l1_add_out)
  );
  
  std_reg #(2) l1_idx (
      .in(l1_idx_in),
      .write_en(l1_idx_write_en),
      .clk(clk),
      .out(l1_idx_out),
      .done(l1_idx_done)
  );
  
  std_mem_d1 #(32, 2, 2) l0 (
      .addr0(l0_addr0),
      .write_data(l0_write_data),
      .write_en(l0_write_en),
      .clk(clk),
      .read_data(l0_read_data),
      .done(l0_done)
  );
  
  std_add #(2) l0_add (
      .left(l0_add_left),
      .right(l0_add_right),
      .out(l0_add_out)
  );
  
  std_reg #(2) l0_idx (
      .in(l0_idx_in),
      .write_en(l0_idx_write_en),
      .clk(clk),
      .out(l0_idx_out),
      .done(l0_idx_done)
  );
  
  std_mem_d1 #(32, 2, 2) t1 (
      .addr0(t1_addr0),
      .write_data(t1_write_data),
      .write_en(t1_write_en),
      .clk(clk),
      .read_data(t1_read_data),
      .done(t1_done)
  );
  
  std_add #(2) t1_add (
      .left(t1_add_left),
      .right(t1_add_right),
      .out(t1_add_out)
  );
  
  std_reg #(2) t1_idx (
      .in(t1_idx_in),
      .write_en(t1_idx_write_en),
      .clk(clk),
      .out(t1_idx_out),
      .done(t1_idx_done)
  );
  
  std_mem_d1 #(32, 2, 2) t0 (
      .addr0(t0_addr0),
      .write_data(t0_write_data),
      .write_en(t0_write_en),
      .clk(clk),
      .read_data(t0_read_data),
      .done(t0_done)
  );
  
  std_add #(2) t0_add (
      .left(t0_add_left),
      .right(t0_add_right),
      .out(t0_add_out)
  );
  
  std_reg #(2) t0_idx (
      .in(t0_idx_in),
      .write_en(t0_idx_write_en),
      .clk(clk),
      .out(t0_idx_out),
      .done(t0_idx_done)
  );
  
  std_reg #(1) par_reset0 (
      .in(par_reset0_in),
      .write_en(par_reset0_write_en),
      .clk(clk),
      .out(par_reset0_out),
      .done(par_reset0_done)
  );
  
  std_reg #(1) par_done_reg0 (
      .in(par_done_reg0_in),
      .write_en(par_done_reg0_write_en),
      .clk(clk),
      .out(par_done_reg0_out),
      .done(par_done_reg0_done)
  );
  
  std_reg #(1) par_done_reg1 (
      .in(par_done_reg1_in),
      .write_en(par_done_reg1_write_en),
      .clk(clk),
      .out(par_done_reg1_out),
      .done(par_done_reg1_done)
  );
  
  std_reg #(1) par_done_reg2 (
      .in(par_done_reg2_in),
      .write_en(par_done_reg2_write_en),
      .clk(clk),
      .out(par_done_reg2_out),
      .done(par_done_reg2_done)
  );
  
  std_reg #(1) par_done_reg3 (
      .in(par_done_reg3_in),
      .write_en(par_done_reg3_write_en),
      .clk(clk),
      .out(par_done_reg3_out),
      .done(par_done_reg3_done)
  );
  
  std_reg #(1) par_reset1 (
      .in(par_reset1_in),
      .write_en(par_reset1_write_en),
      .clk(clk),
      .out(par_reset1_out),
      .done(par_reset1_done)
  );
  
  std_reg #(1) par_done_reg4 (
      .in(par_done_reg4_in),
      .write_en(par_done_reg4_write_en),
      .clk(clk),
      .out(par_done_reg4_out),
      .done(par_done_reg4_done)
  );
  
  std_reg #(1) par_done_reg5 (
      .in(par_done_reg5_in),
      .write_en(par_done_reg5_write_en),
      .clk(clk),
      .out(par_done_reg5_out),
      .done(par_done_reg5_done)
  );
  
  std_reg #(1) par_reset2 (
      .in(par_reset2_in),
      .write_en(par_reset2_write_en),
      .clk(clk),
      .out(par_reset2_out),
      .done(par_reset2_done)
  );
  
  std_reg #(1) par_done_reg6 (
      .in(par_done_reg6_in),
      .write_en(par_done_reg6_write_en),
      .clk(clk),
      .out(par_done_reg6_out),
      .done(par_done_reg6_done)
  );
  
  std_reg #(1) par_done_reg7 (
      .in(par_done_reg7_in),
      .write_en(par_done_reg7_write_en),
      .clk(clk),
      .out(par_done_reg7_out),
      .done(par_done_reg7_done)
  );
  
  std_reg #(1) par_reset3 (
      .in(par_reset3_in),
      .write_en(par_reset3_write_en),
      .clk(clk),
      .out(par_reset3_out),
      .done(par_reset3_done)
  );
  
  std_reg #(1) par_done_reg8 (
      .in(par_done_reg8_in),
      .write_en(par_done_reg8_write_en),
      .clk(clk),
      .out(par_done_reg8_out),
      .done(par_done_reg8_done)
  );
  
  std_reg #(1) par_done_reg9 (
      .in(par_done_reg9_in),
      .write_en(par_done_reg9_write_en),
      .clk(clk),
      .out(par_done_reg9_out),
      .done(par_done_reg9_done)
  );
  
  std_reg #(1) par_done_reg10 (
      .in(par_done_reg10_in),
      .write_en(par_done_reg10_write_en),
      .clk(clk),
      .out(par_done_reg10_out),
      .done(par_done_reg10_done)
  );
  
  std_reg #(1) par_done_reg11 (
      .in(par_done_reg11_in),
      .write_en(par_done_reg11_write_en),
      .clk(clk),
      .out(par_done_reg11_out),
      .done(par_done_reg11_done)
  );
  
  std_reg #(1) par_done_reg12 (
      .in(par_done_reg12_in),
      .write_en(par_done_reg12_write_en),
      .clk(clk),
      .out(par_done_reg12_out),
      .done(par_done_reg12_done)
  );
  
  std_reg #(1) par_reset4 (
      .in(par_reset4_in),
      .write_en(par_reset4_write_en),
      .clk(clk),
      .out(par_reset4_out),
      .done(par_reset4_done)
  );
  
  std_reg #(1) par_done_reg13 (
      .in(par_done_reg13_in),
      .write_en(par_done_reg13_write_en),
      .clk(clk),
      .out(par_done_reg13_out),
      .done(par_done_reg13_done)
  );
  
  std_reg #(1) par_done_reg14 (
      .in(par_done_reg14_in),
      .write_en(par_done_reg14_write_en),
      .clk(clk),
      .out(par_done_reg14_out),
      .done(par_done_reg14_done)
  );
  
  std_reg #(1) par_done_reg15 (
      .in(par_done_reg15_in),
      .write_en(par_done_reg15_write_en),
      .clk(clk),
      .out(par_done_reg15_out),
      .done(par_done_reg15_done)
  );
  
  std_reg #(1) par_done_reg16 (
      .in(par_done_reg16_in),
      .write_en(par_done_reg16_write_en),
      .clk(clk),
      .out(par_done_reg16_out),
      .done(par_done_reg16_done)
  );
  
  std_reg #(1) par_done_reg17 (
      .in(par_done_reg17_in),
      .write_en(par_done_reg17_write_en),
      .clk(clk),
      .out(par_done_reg17_out),
      .done(par_done_reg17_done)
  );
  
  std_reg #(1) par_done_reg18 (
      .in(par_done_reg18_in),
      .write_en(par_done_reg18_write_en),
      .clk(clk),
      .out(par_done_reg18_out),
      .done(par_done_reg18_done)
  );
  
  std_reg #(1) par_reset5 (
      .in(par_reset5_in),
      .write_en(par_reset5_write_en),
      .clk(clk),
      .out(par_reset5_out),
      .done(par_reset5_done)
  );
  
  std_reg #(1) par_done_reg19 (
      .in(par_done_reg19_in),
      .write_en(par_done_reg19_write_en),
      .clk(clk),
      .out(par_done_reg19_out),
      .done(par_done_reg19_done)
  );
  
  std_reg #(1) par_done_reg20 (
      .in(par_done_reg20_in),
      .write_en(par_done_reg20_write_en),
      .clk(clk),
      .out(par_done_reg20_out),
      .done(par_done_reg20_done)
  );
  
  std_reg #(1) par_done_reg21 (
      .in(par_done_reg21_in),
      .write_en(par_done_reg21_write_en),
      .clk(clk),
      .out(par_done_reg21_out),
      .done(par_done_reg21_done)
  );
  
  std_reg #(1) par_done_reg22 (
      .in(par_done_reg22_in),
      .write_en(par_done_reg22_write_en),
      .clk(clk),
      .out(par_done_reg22_out),
      .done(par_done_reg22_done)
  );
  
  std_reg #(1) par_done_reg23 (
      .in(par_done_reg23_in),
      .write_en(par_done_reg23_write_en),
      .clk(clk),
      .out(par_done_reg23_out),
      .done(par_done_reg23_done)
  );
  
  std_reg #(1) par_reset6 (
      .in(par_reset6_in),
      .write_en(par_reset6_write_en),
      .clk(clk),
      .out(par_reset6_out),
      .done(par_reset6_done)
  );
  
  std_reg #(1) par_done_reg24 (
      .in(par_done_reg24_in),
      .write_en(par_done_reg24_write_en),
      .clk(clk),
      .out(par_done_reg24_out),
      .done(par_done_reg24_done)
  );
  
  std_reg #(1) par_done_reg25 (
      .in(par_done_reg25_in),
      .write_en(par_done_reg25_write_en),
      .clk(clk),
      .out(par_done_reg25_out),
      .done(par_done_reg25_done)
  );
  
  std_reg #(1) par_done_reg26 (
      .in(par_done_reg26_in),
      .write_en(par_done_reg26_write_en),
      .clk(clk),
      .out(par_done_reg26_out),
      .done(par_done_reg26_done)
  );
  
  std_reg #(1) par_done_reg27 (
      .in(par_done_reg27_in),
      .write_en(par_done_reg27_write_en),
      .clk(clk),
      .out(par_done_reg27_out),
      .done(par_done_reg27_done)
  );
  
  std_reg #(1) par_done_reg28 (
      .in(par_done_reg28_in),
      .write_en(par_done_reg28_write_en),
      .clk(clk),
      .out(par_done_reg28_out),
      .done(par_done_reg28_done)
  );
  
  std_reg #(1) par_done_reg29 (
      .in(par_done_reg29_in),
      .write_en(par_done_reg29_write_en),
      .clk(clk),
      .out(par_done_reg29_out),
      .done(par_done_reg29_done)
  );
  
  std_reg #(1) par_reset7 (
      .in(par_reset7_in),
      .write_en(par_reset7_write_en),
      .clk(clk),
      .out(par_reset7_out),
      .done(par_reset7_done)
  );
  
  std_reg #(1) par_done_reg30 (
      .in(par_done_reg30_in),
      .write_en(par_done_reg30_write_en),
      .clk(clk),
      .out(par_done_reg30_out),
      .done(par_done_reg30_done)
  );
  
  std_reg #(1) par_done_reg31 (
      .in(par_done_reg31_in),
      .write_en(par_done_reg31_write_en),
      .clk(clk),
      .out(par_done_reg31_out),
      .done(par_done_reg31_done)
  );
  
  std_reg #(1) par_done_reg32 (
      .in(par_done_reg32_in),
      .write_en(par_done_reg32_write_en),
      .clk(clk),
      .out(par_done_reg32_out),
      .done(par_done_reg32_done)
  );
  
  std_reg #(1) par_reset8 (
      .in(par_reset8_in),
      .write_en(par_reset8_write_en),
      .clk(clk),
      .out(par_reset8_out),
      .done(par_reset8_done)
  );
  
  std_reg #(1) par_done_reg33 (
      .in(par_done_reg33_in),
      .write_en(par_done_reg33_write_en),
      .clk(clk),
      .out(par_done_reg33_out),
      .done(par_done_reg33_done)
  );
  
  std_reg #(1) par_done_reg34 (
      .in(par_done_reg34_in),
      .write_en(par_done_reg34_write_en),
      .clk(clk),
      .out(par_done_reg34_out),
      .done(par_done_reg34_done)
  );
  
  std_reg #(1) par_reset9 (
      .in(par_reset9_in),
      .write_en(par_reset9_write_en),
      .clk(clk),
      .out(par_reset9_out),
      .done(par_reset9_done)
  );
  
  std_reg #(1) par_done_reg35 (
      .in(par_done_reg35_in),
      .write_en(par_done_reg35_write_en),
      .clk(clk),
      .out(par_done_reg35_out),
      .done(par_done_reg35_done)
  );
  
  std_reg #(32) fsm0 (
      .in(fsm0_in),
      .write_en(fsm0_write_en),
      .clk(clk),
      .out(fsm0_out),
      .done(fsm0_done)
  );
  
  // Input / output connections
  assign done = (fsm0_out == 32'd10) ? 1'd1 : '0;
  assign left_11_read_in = (!(par_done_reg29_out | left_11_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go | !(par_done_reg34_out | left_11_read_done) & fsm0_out == 32'd8 & !par_reset8_out & go) ? right_10_write_out : '0;
  assign left_11_read_write_en = (!(par_done_reg29_out | left_11_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go | !(par_done_reg34_out | left_11_read_done) & fsm0_out == 32'd8 & !par_reset8_out & go) ? 1'd1 : '0;
  assign top_11_read_in = (!(par_done_reg26_out | top_11_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go | !(par_done_reg33_out | top_11_read_done) & fsm0_out == 32'd8 & !par_reset8_out & go) ? down_01_write_out : '0;
  assign top_11_read_write_en = (!(par_done_reg26_out | top_11_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go | !(par_done_reg33_out | top_11_read_done) & fsm0_out == 32'd8 & !par_reset8_out & go) ? 1'd1 : '0;
  assign pe_11_top = (!(par_done_reg32_out | pe_11_done) & fsm0_out == 32'd7 & !par_reset7_out & go | !(par_done_reg35_out | pe_11_done) & fsm0_out == 32'd9 & !par_reset9_out & go) ? top_11_read_out : '0;
  assign pe_11_left = (!(par_done_reg32_out | pe_11_done) & fsm0_out == 32'd7 & !par_reset7_out & go | !(par_done_reg35_out | pe_11_done) & fsm0_out == 32'd9 & !par_reset9_out & go) ? left_11_read_out : '0;
  assign pe_11_go = (!pe_11_done & (!(par_done_reg32_out | pe_11_done) & fsm0_out == 32'd7 & !par_reset7_out & go | !(par_done_reg35_out | pe_11_done) & fsm0_out == 32'd9 & !par_reset9_out & go)) ? 1'd1 : '0;
  assign right_10_write_in = (pe_10_done & (!(par_done_reg23_out | right_10_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg31_out | right_10_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? pe_10_right : '0;
  assign right_10_write_write_en = (pe_10_done & (!(par_done_reg23_out | right_10_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg31_out | right_10_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? 1'd1 : '0;
  assign left_10_read_in = (!(par_done_reg18_out | left_10_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg28_out | left_10_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? l1_read_data : '0;
  assign left_10_read_write_en = (!(par_done_reg18_out | left_10_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg28_out | left_10_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign top_10_read_in = (!(par_done_reg15_out | top_10_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg25_out | top_10_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? down_00_write_out : '0;
  assign top_10_read_write_en = (!(par_done_reg15_out | top_10_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg25_out | top_10_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign pe_10_top = (!(par_done_reg23_out | right_10_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg31_out | right_10_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go) ? top_10_read_out : '0;
  assign pe_10_left = (!(par_done_reg23_out | right_10_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg31_out | right_10_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go) ? left_10_read_out : '0;
  assign pe_10_go = (!pe_10_done & (!(par_done_reg23_out | right_10_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg31_out | right_10_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? 1'd1 : '0;
  assign down_01_write_in = (pe_01_done & (!(par_done_reg22_out | down_01_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg30_out | down_01_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? pe_01_down : '0;
  assign down_01_write_write_en = (pe_01_done & (!(par_done_reg22_out | down_01_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg30_out | down_01_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? 1'd1 : '0;
  assign left_01_read_in = (!(par_done_reg17_out | left_01_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg27_out | left_01_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? right_00_write_out : '0;
  assign left_01_read_write_en = (!(par_done_reg17_out | left_01_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg27_out | left_01_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign top_01_read_in = (!(par_done_reg14_out | top_01_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg24_out | top_01_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? t1_read_data : '0;
  assign top_01_read_write_en = (!(par_done_reg14_out | top_01_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg24_out | top_01_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign pe_01_top = (!(par_done_reg22_out | down_01_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg30_out | down_01_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go) ? top_01_read_out : '0;
  assign pe_01_left = (!(par_done_reg22_out | down_01_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg30_out | down_01_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go) ? left_01_read_out : '0;
  assign pe_01_go = (!pe_01_done & (!(par_done_reg22_out | down_01_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go | !(par_done_reg30_out | down_01_write_done) & fsm0_out == 32'd7 & !par_reset7_out & go)) ? 1'd1 : '0;
  assign down_00_write_in = (pe_00_done & (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go)) ? pe_00_down : '0;
  assign down_00_write_write_en = (pe_00_done & (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go)) ? 1'd1 : '0;
  assign right_00_write_in = (pe_00_done & (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go)) ? pe_00_right : '0;
  assign right_00_write_write_en = (pe_00_done & (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go)) ? 1'd1 : '0;
  assign left_00_read_in = (!(par_done_reg7_out | left_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg16_out | left_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? l0_read_data : '0;
  assign left_00_read_write_en = (!(par_done_reg7_out | left_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg16_out | left_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign top_00_read_in = (!(par_done_reg6_out | top_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg13_out | top_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? t0_read_data : '0;
  assign top_00_read_write_en = (!(par_done_reg6_out | top_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg13_out | top_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign pe_00_top = (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? top_00_read_out : '0;
  assign pe_00_left = (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? left_00_read_out : '0;
  assign pe_00_go = (!pe_00_done & (!(par_done_reg12_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg21_out | right_00_write_done & down_00_write_done) & fsm0_out == 32'd5 & !par_reset5_out & go)) ? 1'd1 : '0;
  assign l1_addr0 = (!(par_done_reg18_out | left_10_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg28_out | left_10_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? l1_idx_out : '0;
  assign l1_add_left = (!(par_done_reg11_out | l1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg20_out | l1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? 2'd1 : '0;
  assign l1_add_right = (!(par_done_reg11_out | l1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg20_out | l1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? l1_idx_out : '0;
  assign l1_idx_in = (!(par_done_reg11_out | l1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg20_out | l1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? l1_add_out : (!(par_done_reg3_out | l1_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go) ? 2'd3 : '0;
  assign l1_idx_write_en = (!(par_done_reg3_out | l1_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go | !(par_done_reg11_out | l1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg20_out | l1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign l0_addr0 = (!(par_done_reg7_out | left_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg16_out | left_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? l0_idx_out : '0;
  assign l0_add_left = (!(par_done_reg5_out | l0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg9_out | l0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? 2'd1 : '0;
  assign l0_add_right = (!(par_done_reg5_out | l0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg9_out | l0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? l0_idx_out : '0;
  assign l0_idx_in = (!(par_done_reg5_out | l0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg9_out | l0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? l0_add_out : (!(par_done_reg2_out | l0_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go) ? 2'd3 : '0;
  assign l0_idx_write_en = (!(par_done_reg2_out | l0_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go | !(par_done_reg5_out | l0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg9_out | l0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign t1_addr0 = (!(par_done_reg14_out | top_01_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go | !(par_done_reg24_out | top_01_read_done) & fsm0_out == 32'd6 & !par_reset6_out & go) ? t1_idx_out : '0;
  assign t1_add_left = (!(par_done_reg10_out | t1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg19_out | t1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? 2'd1 : '0;
  assign t1_add_right = (!(par_done_reg10_out | t1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg19_out | t1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? t1_idx_out : '0;
  assign t1_idx_in = (!(par_done_reg10_out | t1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg19_out | t1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? t1_add_out : (!(par_done_reg1_out | t1_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go) ? 2'd3 : '0;
  assign t1_idx_write_en = (!(par_done_reg1_out | t1_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go | !(par_done_reg10_out | t1_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go | !(par_done_reg19_out | t1_idx_done) & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign t0_addr0 = (!(par_done_reg6_out | top_00_read_done) & fsm0_out == 32'd2 & !par_reset2_out & go | !(par_done_reg13_out | top_00_read_done) & fsm0_out == 32'd4 & !par_reset4_out & go) ? t0_idx_out : '0;
  assign t0_add_left = (!(par_done_reg4_out | t0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg8_out | t0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? 2'd1 : '0;
  assign t0_add_right = (!(par_done_reg4_out | t0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg8_out | t0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? t0_idx_out : '0;
  assign t0_idx_in = (!(par_done_reg4_out | t0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg8_out | t0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? t0_add_out : (!(par_done_reg0_out | t0_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go) ? 2'd3 : '0;
  assign t0_idx_write_en = (!(par_done_reg0_out | t0_idx_done) & fsm0_out == 32'd0 & !par_reset0_out & go | !(par_done_reg4_out | t0_idx_done) & fsm0_out == 32'd1 & !par_reset1_out & go | !(par_done_reg8_out | t0_idx_done) & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_reset0_in = par_reset0_out ? 1'd0 : (par_done_reg0_out & par_done_reg1_out & par_done_reg2_out & par_done_reg3_out & fsm0_out == 32'd0 & !par_reset0_out & go) ? 1'd1 : '0;
  assign par_reset0_write_en = (par_done_reg0_out & par_done_reg1_out & par_done_reg2_out & par_done_reg3_out & fsm0_out == 32'd0 & !par_reset0_out & go | par_reset0_out) ? 1'd1 : '0;
  assign par_done_reg0_in = par_reset0_out ? 1'd0 : (t0_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go) ? 1'd1 : '0;
  assign par_done_reg0_write_en = (t0_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go | par_reset0_out) ? 1'd1 : '0;
  assign par_done_reg1_in = par_reset0_out ? 1'd0 : (t1_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go) ? 1'd1 : '0;
  assign par_done_reg1_write_en = (t1_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go | par_reset0_out) ? 1'd1 : '0;
  assign par_done_reg2_in = par_reset0_out ? 1'd0 : (l0_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go) ? 1'd1 : '0;
  assign par_done_reg2_write_en = (l0_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go | par_reset0_out) ? 1'd1 : '0;
  assign par_done_reg3_in = par_reset0_out ? 1'd0 : (l1_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go) ? 1'd1 : '0;
  assign par_done_reg3_write_en = (l1_idx_done & fsm0_out == 32'd0 & !par_reset0_out & go | par_reset0_out) ? 1'd1 : '0;
  assign par_reset1_in = par_reset1_out ? 1'd0 : (par_done_reg4_out & par_done_reg5_out & fsm0_out == 32'd1 & !par_reset1_out & go) ? 1'd1 : '0;
  assign par_reset1_write_en = (par_done_reg4_out & par_done_reg5_out & fsm0_out == 32'd1 & !par_reset1_out & go | par_reset1_out) ? 1'd1 : '0;
  assign par_done_reg4_in = par_reset1_out ? 1'd0 : (t0_idx_done & fsm0_out == 32'd1 & !par_reset1_out & go) ? 1'd1 : '0;
  assign par_done_reg4_write_en = (t0_idx_done & fsm0_out == 32'd1 & !par_reset1_out & go | par_reset1_out) ? 1'd1 : '0;
  assign par_done_reg5_in = par_reset1_out ? 1'd0 : (l0_idx_done & fsm0_out == 32'd1 & !par_reset1_out & go) ? 1'd1 : '0;
  assign par_done_reg5_write_en = (l0_idx_done & fsm0_out == 32'd1 & !par_reset1_out & go | par_reset1_out) ? 1'd1 : '0;
  assign par_reset2_in = par_reset2_out ? 1'd0 : (par_done_reg6_out & par_done_reg7_out & fsm0_out == 32'd2 & !par_reset2_out & go) ? 1'd1 : '0;
  assign par_reset2_write_en = (par_done_reg6_out & par_done_reg7_out & fsm0_out == 32'd2 & !par_reset2_out & go | par_reset2_out) ? 1'd1 : '0;
  assign par_done_reg6_in = par_reset2_out ? 1'd0 : (top_00_read_done & fsm0_out == 32'd2 & !par_reset2_out & go) ? 1'd1 : '0;
  assign par_done_reg6_write_en = (top_00_read_done & fsm0_out == 32'd2 & !par_reset2_out & go | par_reset2_out) ? 1'd1 : '0;
  assign par_done_reg7_in = par_reset2_out ? 1'd0 : (left_00_read_done & fsm0_out == 32'd2 & !par_reset2_out & go) ? 1'd1 : '0;
  assign par_done_reg7_write_en = (left_00_read_done & fsm0_out == 32'd2 & !par_reset2_out & go | par_reset2_out) ? 1'd1 : '0;
  assign par_reset3_in = par_reset3_out ? 1'd0 : (par_done_reg8_out & par_done_reg9_out & par_done_reg10_out & par_done_reg11_out & par_done_reg12_out & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_reset3_write_en = (par_done_reg8_out & par_done_reg9_out & par_done_reg10_out & par_done_reg11_out & par_done_reg12_out & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_done_reg8_in = par_reset3_out ? 1'd0 : (t0_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_done_reg8_write_en = (t0_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_done_reg9_in = par_reset3_out ? 1'd0 : (l0_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_done_reg9_write_en = (l0_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_done_reg10_in = par_reset3_out ? 1'd0 : (t1_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_done_reg10_write_en = (t1_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_done_reg11_in = par_reset3_out ? 1'd0 : (l1_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_done_reg11_write_en = (l1_idx_done & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_done_reg12_in = par_reset3_out ? 1'd0 : (right_00_write_done & down_00_write_done & fsm0_out == 32'd3 & !par_reset3_out & go) ? 1'd1 : '0;
  assign par_done_reg12_write_en = (right_00_write_done & down_00_write_done & fsm0_out == 32'd3 & !par_reset3_out & go | par_reset3_out) ? 1'd1 : '0;
  assign par_reset4_in = par_reset4_out ? 1'd0 : (par_done_reg13_out & par_done_reg14_out & par_done_reg15_out & par_done_reg16_out & par_done_reg17_out & par_done_reg18_out & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_reset4_write_en = (par_done_reg13_out & par_done_reg14_out & par_done_reg15_out & par_done_reg16_out & par_done_reg17_out & par_done_reg18_out & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg13_in = par_reset4_out ? 1'd0 : (top_00_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg13_write_en = (top_00_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg14_in = par_reset4_out ? 1'd0 : (top_01_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg14_write_en = (top_01_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg15_in = par_reset4_out ? 1'd0 : (top_10_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg15_write_en = (top_10_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg16_in = par_reset4_out ? 1'd0 : (left_00_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg16_write_en = (left_00_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg17_in = par_reset4_out ? 1'd0 : (left_01_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg17_write_en = (left_01_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_done_reg18_in = par_reset4_out ? 1'd0 : (left_10_read_done & fsm0_out == 32'd4 & !par_reset4_out & go) ? 1'd1 : '0;
  assign par_done_reg18_write_en = (left_10_read_done & fsm0_out == 32'd4 & !par_reset4_out & go | par_reset4_out) ? 1'd1 : '0;
  assign par_reset5_in = par_reset5_out ? 1'd0 : (par_done_reg19_out & par_done_reg20_out & par_done_reg21_out & par_done_reg22_out & par_done_reg23_out & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_reset5_write_en = (par_done_reg19_out & par_done_reg20_out & par_done_reg21_out & par_done_reg22_out & par_done_reg23_out & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_done_reg19_in = par_reset5_out ? 1'd0 : (t1_idx_done & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_done_reg19_write_en = (t1_idx_done & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_done_reg20_in = par_reset5_out ? 1'd0 : (l1_idx_done & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_done_reg20_write_en = (l1_idx_done & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_done_reg21_in = par_reset5_out ? 1'd0 : (right_00_write_done & down_00_write_done & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_done_reg21_write_en = (right_00_write_done & down_00_write_done & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_done_reg22_in = par_reset5_out ? 1'd0 : (down_01_write_done & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_done_reg22_write_en = (down_01_write_done & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_done_reg23_in = par_reset5_out ? 1'd0 : (right_10_write_done & fsm0_out == 32'd5 & !par_reset5_out & go) ? 1'd1 : '0;
  assign par_done_reg23_write_en = (right_10_write_done & fsm0_out == 32'd5 & !par_reset5_out & go | par_reset5_out) ? 1'd1 : '0;
  assign par_reset6_in = par_reset6_out ? 1'd0 : (par_done_reg24_out & par_done_reg25_out & par_done_reg26_out & par_done_reg27_out & par_done_reg28_out & par_done_reg29_out & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_reset6_write_en = (par_done_reg24_out & par_done_reg25_out & par_done_reg26_out & par_done_reg27_out & par_done_reg28_out & par_done_reg29_out & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg24_in = par_reset6_out ? 1'd0 : (top_01_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg24_write_en = (top_01_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg25_in = par_reset6_out ? 1'd0 : (top_10_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg25_write_en = (top_10_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg26_in = par_reset6_out ? 1'd0 : (top_11_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg26_write_en = (top_11_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg27_in = par_reset6_out ? 1'd0 : (left_01_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg27_write_en = (left_01_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg28_in = par_reset6_out ? 1'd0 : (left_10_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg28_write_en = (left_10_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_done_reg29_in = par_reset6_out ? 1'd0 : (left_11_read_done & fsm0_out == 32'd6 & !par_reset6_out & go) ? 1'd1 : '0;
  assign par_done_reg29_write_en = (left_11_read_done & fsm0_out == 32'd6 & !par_reset6_out & go | par_reset6_out) ? 1'd1 : '0;
  assign par_reset7_in = par_reset7_out ? 1'd0 : (par_done_reg30_out & par_done_reg31_out & par_done_reg32_out & fsm0_out == 32'd7 & !par_reset7_out & go) ? 1'd1 : '0;
  assign par_reset7_write_en = (par_done_reg30_out & par_done_reg31_out & par_done_reg32_out & fsm0_out == 32'd7 & !par_reset7_out & go | par_reset7_out) ? 1'd1 : '0;
  assign par_done_reg30_in = par_reset7_out ? 1'd0 : (down_01_write_done & fsm0_out == 32'd7 & !par_reset7_out & go) ? 1'd1 : '0;
  assign par_done_reg30_write_en = (down_01_write_done & fsm0_out == 32'd7 & !par_reset7_out & go | par_reset7_out) ? 1'd1 : '0;
  assign par_done_reg31_in = par_reset7_out ? 1'd0 : (right_10_write_done & fsm0_out == 32'd7 & !par_reset7_out & go) ? 1'd1 : '0;
  assign par_done_reg31_write_en = (right_10_write_done & fsm0_out == 32'd7 & !par_reset7_out & go | par_reset7_out) ? 1'd1 : '0;
  assign par_done_reg32_in = par_reset7_out ? 1'd0 : (pe_11_done & fsm0_out == 32'd7 & !par_reset7_out & go) ? 1'd1 : '0;
  assign par_done_reg32_write_en = (pe_11_done & fsm0_out == 32'd7 & !par_reset7_out & go | par_reset7_out) ? 1'd1 : '0;
  assign par_reset8_in = par_reset8_out ? 1'd0 : (par_done_reg33_out & par_done_reg34_out & fsm0_out == 32'd8 & !par_reset8_out & go) ? 1'd1 : '0;
  assign par_reset8_write_en = (par_done_reg33_out & par_done_reg34_out & fsm0_out == 32'd8 & !par_reset8_out & go | par_reset8_out) ? 1'd1 : '0;
  assign par_done_reg33_in = par_reset8_out ? 1'd0 : (top_11_read_done & fsm0_out == 32'd8 & !par_reset8_out & go) ? 1'd1 : '0;
  assign par_done_reg33_write_en = (top_11_read_done & fsm0_out == 32'd8 & !par_reset8_out & go | par_reset8_out) ? 1'd1 : '0;
  assign par_done_reg34_in = par_reset8_out ? 1'd0 : (left_11_read_done & fsm0_out == 32'd8 & !par_reset8_out & go) ? 1'd1 : '0;
  assign par_done_reg34_write_en = (left_11_read_done & fsm0_out == 32'd8 & !par_reset8_out & go | par_reset8_out) ? 1'd1 : '0;
  assign par_reset9_in = par_reset9_out ? 1'd0 : (par_done_reg35_out & fsm0_out == 32'd9 & !par_reset9_out & go) ? 1'd1 : '0;
  assign par_reset9_write_en = (par_done_reg35_out & fsm0_out == 32'd9 & !par_reset9_out & go | par_reset9_out) ? 1'd1 : '0;
  assign par_done_reg35_in = par_reset9_out ? 1'd0 : (pe_11_done & fsm0_out == 32'd9 & !par_reset9_out & go) ? 1'd1 : '0;
  assign par_done_reg35_write_en = (pe_11_done & fsm0_out == 32'd9 & !par_reset9_out & go | par_reset9_out) ? 1'd1 : '0;
  assign fsm0_in = (fsm0_out == 32'd4 & par_reset4_out & go) ? 32'd5 : (fsm0_out == 32'd3 & par_reset3_out & go) ? 32'd4 : (fsm0_out == 32'd2 & par_reset2_out & go) ? 32'd3 : (fsm0_out == 32'd1 & par_reset1_out & go) ? 32'd2 : (fsm0_out == 32'd0 & par_reset0_out & go) ? 32'd1 : (fsm0_out == 32'd10) ? 32'd0 : (fsm0_out == 32'd9 & par_reset9_out & go) ? 32'd10 : (fsm0_out == 32'd8 & par_reset8_out & go) ? 32'd9 : (fsm0_out == 32'd7 & par_reset7_out & go) ? 32'd8 : (fsm0_out == 32'd6 & par_reset6_out & go) ? 32'd7 : (fsm0_out == 32'd5 & par_reset5_out & go) ? 32'd6 : '0;
  assign fsm0_write_en = (fsm0_out == 32'd0 & par_reset0_out & go | fsm0_out == 32'd1 & par_reset1_out & go | fsm0_out == 32'd2 & par_reset2_out & go | fsm0_out == 32'd3 & par_reset3_out & go | fsm0_out == 32'd4 & par_reset4_out & go | fsm0_out == 32'd5 & par_reset5_out & go | fsm0_out == 32'd6 & par_reset6_out & go | fsm0_out == 32'd7 & par_reset7_out & go | fsm0_out == 32'd8 & par_reset8_out & go | fsm0_out == 32'd9 & par_reset9_out & go | fsm0_out == 32'd10) ? 1'd1 : '0;
endmodule // end main