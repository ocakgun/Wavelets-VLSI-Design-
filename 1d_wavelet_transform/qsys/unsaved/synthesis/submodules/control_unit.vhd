library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity controlunit is
port (clk,start: in std_logic; state : in smstate; read_row: in std_logic;

address_in : in std_logic_vector(5 downto 0);data : out std_logic_vector(15 downto 0); status: out std_logic);
end controlunit;


architecture controlunit_arch of controlunit is

signal address2,address,address3 : std_logic_vector(width-1 downto 0) := (others => '0');
signal readdata,writedata,readdata2,writedata2,readdata3,writedata3 : std_logic_vector(width-1 downto 0) := (others => '0');
signal read_en,read2,read3,write3,write2,write_en,reset : std_logic := '0';
signal counter,counter1,delay : unsigned(3 downto 0) := (others=>'0');
--signal counter1: unsigned(1 downto 0) := "00";
--signal row_complete : std_logic := '0';
signal dout_hp,dout_lp,data_in : unsigned(7 downto 0);
--signal out_lp,out_hp,out_1,out_2,out_3,out_4 : unsigned(7 downto 0);
signal switch,in_process : std_logic:='0';
signal row_pixel_count: unsigned (3 downto 0) := (others=> '0');
signal total_pixel_count: unsigned(3 downto 0) := (others=> '0');
--signal next_stage_data : unsigned(7 downto 0) := (others => '0');
--signal pixel_count : unsigned(3 downto 0):= "0000";
--signal pulse_count : unsigned(7 downto 0) := x"00";

component input_ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(width-1 downto 0); readdata : out std_logic_vector(width-1 downto 0);
address : in std_logic_vector(width-1 downto 0)
);
end component;

component filter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;


component output1 is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(7 downto 0); readdata : out std_logic_vector(7 downto 0);
 address : in std_logic_vector(7 downto 0));
end component;

begin

ram: component input_ram port map (clk,read_en,write_en,writedata,readdata,address);

filter_1 : component filter port map (clk,data_in,dout_lp,dout_hp);

outputram1 : component output1 port map (clk,read2,write2,writedata2,readdata2,address2);
outputram2 : component output1 port map (clk,read3,write3,writedata3,readdata3,address3);
read2 <= read_row;
read3 <= read_row;

Process(clk,state,read_row)
variable row : std_logic := '0';
variable pulse_count : unsigned(3 downto 0) := "0000";
begin
if state=compute then
	if clk'event and clk='1' then
		if row='0'  then
			read_en <= '1';
		--data_in_valid <= '1';
			--counter <= x"0000";
			counter <= counter + 1;
			row_pixel_count <= row_pixel_count + 1;
			pulse_count := pulse_count + 1;
		end if;
		--address <= address + 1;
	if start = '1' and pulse_count="0010" then
		--row := '1';
		--we <= '1';
		--read_en <= '0';
		--counter <= counter; 
		in_process <= '1';--retain counter value
		--row_pixel_count <= (others=>'0');
	end if;	
	if start = '1' and row_pixel_count="1111" then
		row := '1';
		--we <= '1';
		read_en <= '0';
		counter <= counter; 
	end if;
	
end if;
end if;
--counter <= count;
end process;

--address generator process
--row_count - 4
--pixel_count -16

Process(clk,state,in_process)
begin
if state=compute then
	if clk'event and clk='1' then
		if in_process = '1' and switch ='0' then
			delay <= counter1;
			counter1 <= delay + 1;
			write2 <= '1';
			write3 <= '1';
		end if;
		if counter1 = "1010" then
			write2 <= '0';
			write3 <= '0';
			switch <= '1';
			status <= switch;
		end if;
			
	end if;
end if;
end process;
			
	
-- Process(clk,read_row)
-- begin
-- if clk'event and clk='1' then
	-- if read_row <= '1' then
		-- read2 <= '1';
	-- end if;
-- end if;
-- end process;

	
	
writedata2 <= std_logic_vector(dout_lp);
writedata3 <= std_logic_vector(dout_hp);
data_in <= unsigned(readdata) when readdata /= "ZZZZZZZZ" else x"00";
address <= "0000" & std_logic_vector(counter);
address2 <= "0000" & std_logic_vector(counter1) when switch='0' else "00" & std_logic_vector(address_in);
address3 <= "0000" & std_logic_vector(counter1) when switch='0' else "00" & std_logic_vector(address_in);
data <= readdata2 & readdata3 when switch = '1' else (others => '0');
end architecture controlunit_arch;





