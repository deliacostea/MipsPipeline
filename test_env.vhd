library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is 
component MPG1 is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component MPG1;

component SSD is
    Port(
            clk : in std_logic;
            digits: in std_logic_vector(15 downto 0);
            an : out std_logic_vector(3 downto 0);
            cat : out std_logic_vector(6 downto 0));
         end component SSD;
         
 component reg_file1 is
  Port ( ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regwr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
 end component;
 
 component InstructionFetch is
 Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
 end component;
   
 component IDecode is
  Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (12 downto 0);
           Wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
            wa:in std_logic_vector(2 downto 0);
           ExtOp : in STD_LOGIC;
           Rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           rt:out std_logic_vector(2 downto 0);
           rd:out std_logic_vector(2 downto 0));
 end component;
 
 
 
 component ControlUnit is
 Port	( Instr:in std_logic_vector(2 downto 0);
              RegDst: out std_logic;
              ExtOp: out std_logic;
              ALUSrc: out std_logic;
              Branch: out std_logic;
              Jump: out std_logic;
              ALUOp: out std_logic_vector(2 downto 0);
              MemWrite: out std_logic;
              MemtoReg: out std_logic;
              RegWrite: out std_logic);
 end component;
 
 component Ex is
 Port ( PcInc : in STD_LOGIC_VECTOR (15 downto 0);
           Rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           rt: in std_logic_vector(2 downto 0);
           rd: in std_logic_vector(2 downto 0);
           RegDst : in std_logic;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
          BranchAdd : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           rWa: out std_logic_vector(2 downto 0);
           Zero : out STD_LOGIC);
end component;

component MEM is
 Port ( clk : in STD_LOGIC;
          en : in STD_LOGIC;
          ALURes : in STD_LOGIC_VECTOR (15 downto 0);
          RD2 : in STD_LOGIC_VECTOR (15 downto 0);
          MemWrite : in STD_LOGIC;
          MemData : out STD_LOGIC_VECTOR (15 downto 0);
          ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;
                 
 
signal Instr, PcInc,sum,Rd1,Rd2,Ext_imm,ext_func,ext_sa,WD:std_logic_vector(15 downto 0);
signal JumpAddress,BranchAddress,ALURes,ALURes1,MemData:Std_Logic_vector(15 downto 0);
signal digits:std_logic_vector(15 downto 0);
signal en,rst,sa,zero,PCSrc,br_ne: std_logic;
signal func:std_logic_vector(2 downto 0);
signal RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite:std_logic;
signal AluOp:std_logic_vector(2 downto 0);
---------------------IF/ID
signal Instruction_IF_ID: std_logic_vector(15 downto 0);
signal PC_1_IF_ID: std_logic_vector(15 downto 0);
---------------------ID/EX
signal RegDst_ID_EX: std_logic;
signal Branch_ID_EX: std_logic;
signal RegWr_ID_EX: std_logic;
signal Br_ne_ID_EX: std_logic;
signal ALUSrc_ID_EX: std_logic;
signal ALUOp_ID_EX: std_logic_vector(2 downto 0);
signal MemWr_ID_EX: std_logic;
signal MemtoReg_ID_EX: std_logic;
signal RD1_ID_EX: std_logic_VECTOR(15 downto 0);
signal RD2_ID_EX: std_logic_VECTOR(15 downto 0);
signal ExtImm_ID_EX: std_logic_VECTOR(15 downto 0);
signal func_ID_EX: std_logic_VECTOR(2 downto 0);
signal sa_ID_EX: std_logic;
signal RD_ID_EX: std_logic_VECTOR(2 downto 0);
signal RT_ID_EX: std_logic_VECTOR(2 downto 0);
signal PCinc_ID_EX: std_logic_VECTOR(15 downto 0);
-------------------------EX/MEM
signal Branch_EX_MEM : std_logic;
signal MemWr_EX_MEM : std_logic;
signal MemtoReg_EX_MEM : std_logic;
signal RegWr_EX_MEM : std_logic;
signal Br_ne_EX_MEM : std_logic;
signal Zero_EX_MEM : std_logic;
signal BrAddr_EX_MEM : std_logic_vector(15 downto 0);
signal ALURes_EX_MEM : std_logic_vector(15 downto 0);
signal RD_EX_MEM : std_logic_vector(2 downto 0);
signal RD2_EX_MEM : std_logic_vector(15 downto 0);
-------------------------MEM/WB
signal RegWr_MEM_WB : std_logic;
signal MemtoReg_MEM_WB : std_logic;
signal ALURes_MEM_WB : std_logic_vector(15 downto 0);
signal MemData_MEM_WB : std_logic_vector(15 downto 0);
signal RD_MEM_WB : std_logic_VECTOR(2 downto 0);
signal rd,rt,rWa:std_logic_vector(2 downto 0);

begin 
--sumreg<=rd1+rd2;
MPG:  MPG1 port map(clk,btn(0), en);
Mpg2: MPG1 port map(clk,btn(1),rst);

PCSrc<=(Zero_EX_MEM and  Branch_EX_MEM )or ( not Zero_EX_MEM and Br_ne_EX_MEM); 
instr_fetch: InstructionFetch port map(clk,en,rst, BrAddr_EX_MEM,JumpAddress,Jump,PCSrc,Instr,PcInc);
dec: IDecode port map(clk,en, Instruction_IF_ID(12 downto 0), WD,RegWr_MEM_WB,RD_MEM_WB,ExtOp,Rd1,Rd2,Ext_imm,func,sa,rt,rd);
control:ControlUnit port map(Instruction_IF_ID(15 downto 13),RegDst,ExtOp,ALUSrc,Branch,Jump,AluOp,MemWrite,MemtoReg,RegWrite);
Execute: Ex port map(PCinc_ID_EX,RD1_ID_EX,RD2_ID_EX, ExtImm_ID_EX,func_ID_EX, sa_ID_EX,ALUSrc_ID_EX, RT_ID_EX, RD_ID_EX,RegDst_ID_EX,ALUOp_ID_EX,BranchAddress,ALURes,rWa,zero);
ram: MEM port map(clk,en, ALURes_EX_MEM,RD2_EX_MEM,MemWr_EX_MEM,MemData,AluRes1);


mux:process( ALURes_MEM_WB, MemData_MEM_WB,MemtoReg_MEM_WB)
begin
if MemtoReg_MEM_WB ='0' then
WD <=  ALURes_MEM_WB;
else WD<= MemData_MEM_WB;
end if; 
end process;

JumpAddress <=PcInc(15 downto 13) & Instr(12 downto 0);
with sw(7 downto 5) select
digits <= Instr when "000",
          PcInc when "001",
          RD1_ID_EX when   "010",
          RD2_ID_EX when    "011",
         ExtImm_ID_EX when "100",
          AluRes when "101",
          MemData when "110",
         WD when "111",
(others => 'X')when others;
display: SSD port map (clk,digits,an,cat);

process(clk)
begin
    if rising_edge(clk) then
        if en='1' then
            --IF/ID
            PC_1_IF_ID<=pcinc;
            Instruction_IF_ID<=instr;
            --ID/EX
            PCinc_ID_EX<=PC_1_IF_ID;
            RD1_ID_EX<=RD1;
            RD2_ID_EX<=RD2;
            ExtImm_ID_EX<=Ext_imm;
            sa_ID_EX<=sa;
            func_ID_EX<=func;
            RT_ID_EX<=rt;
            RD_ID_EX<=rd;
            MemtoReg_ID_EX<=MemtoReg;
            RegWr_ID_EX<=RegWrite;
            MemWr_ID_EX<=MemWrite;
            Branch_ID_EX<=Branch;
            Br_ne_ID_EX<=br_ne;
            ALUSrc_ID_EX<=ALUSrc;
            ALUOp_ID_EX<=ALUOp;
            RegDst_ID_EX<=RegDst;
            --EX/MEM
            BrAddr_EX_MEM<=BranchAddress;
            Zero_EX_MEM<=Zero;
            ALURes_EX_MEM<=ALURes;
            RD2_EX_MEM<=RD2_ID_EX;
            RD_EX_MEM<=rWA; 
            MemtoReg_EX_MEM<=MemtoReg_ID_EX; 
            RegWr_EX_MEM<=RegWr_ID_EX;
            MemWr_EX_MEM<=MemWr_ID_EX;
            Branch_EX_MEM<=Branch_ID_EX; 
            Br_ne_EX_MEM<=Br_ne_ID_EX;   
            --MEM/WB
            MemData_MEM_WB<=MemData;
            ALURes_MEM_WB<=ALURes1;
            RD_MEM_WB<=RD_EX_MEM;
            MemtoReg_MEM_WB<=MemtoReg_EX_MEM;
            RegWr_MEM_WB<=RegWr_EX_MEM;  
        end if;
    end if;
end process;

led(10 downto 0) <=AluOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

end Behavioral;

