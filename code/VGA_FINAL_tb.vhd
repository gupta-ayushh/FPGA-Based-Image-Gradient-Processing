
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity vga is
  Port (
  Hsync:out std_logic;
  Vsync: out std_logic;
  vRed: out std_logic_vector(3 downto 0);
  vBlue: out std_logic_vector(3 downto 0);
  vGreen: out std_logic_vector(3 downto 0));
end vga;

architecture Behavioral of vga is
    component dist_mem_gen_0
    port(
        clk:in std_logic;
        a: in std_logic_vector(15 downto 0);
        spo: out std_logic_vector(7 downto 0)
        );
    end component;
    component dist_mem_gen_1
    port(
        a: in std_logic_vector(15 downto 0);
        we: in std_logic;
        clk: in std_logic;
        d: in std_logic_vector( 7 downto 0);
        spo: out std_logic_vector(7 downto 0)
        );
    end component;
    constant HorHD : integer:= 639;
    constant HorFP: integer:= 16;
    constant HorSP: integer:= 96;
    constant HorBP: integer:= 48;
    constant VerHD: integer:= 479;
    constant VerFP: integer:= 10;
    constant VerSP: integer:= 2;
    constant VerBP: integer:= 33;
    signal r: std_logic:='0';
    signal t1: std_logic_vector(8 downto 0):=(others =>'0');
    signal countkrnewawla:integer:=0;
    signal clk25: std_logic := '0';
    signal t2: std_logic_vector(8 downto 0):=(others =>'0');
    signal t3: std_logic_vector(8 downto 0):=(others =>'0');
    signal pp: std_logic_vector(7 downto 0):=(others=>'0');
    signal p: std_logic_vector(7 downto 0):=(others=>'0');
    signal current: std_logic_vector(7 downto 0):=(others=>'0');
    signal gradient: std_logic_vector(7 downto 0):=(others=>'0');
    signal rom_data:std_logic_vector(7 downto 0):=(others=>'0');
    signal rom_address: std_logic_vector(15 downto 0):=(others=>'0');
    signal ram_address: std_logic_vector(15 downto 0):=(others=>'0');
    signal ram_data_in: std_logic_vector(7 downto 0):=(others=>'0');
    signal ram_data_out :std_logic_vector(7 downto 0);
    signal write_enable: std_logic := '1';
    signal CLK: std_logic:= '0';
    constant clock_period: time := 4 ps;
    signal reset : std_logic:='0';

    signal Hpos: integer:=0;
    signal Vpos: integer:=0;

    signal vidOn:std_logic:='0';

    begin

    uut: dist_mem_gen_0 PORT MAP (
            clk  => clk25,
            spo => rom_data,
            a => rom_address
            );
        uut1: dist_mem_gen_1 PORT MAP(
            spo => ram_data_out,
            a => ram_address,
            we=> write_enable,
            clk => clk25,
            d => ram_data_in
            );




     clock_div: process(clk)
     begin
        if(rising_edge(clk)) then
            if(countkrnewawla < 1) then
                countkrnewawla <= countkrnewawla+1;
            elsif(countkrnewawla=1) then
                countkrnewawla <= 0;
                clk25<=not clk25;
             end if;
        end if;
     end process;

     Hpos_countkrnewawla:process(clk25,reset)
     begin
        if(write_enable='0') then
            if(reset='1')then
                hpos<=0;
            elsif(clk25'event and clk25='1') then
                if(hpos=(HorHD+HorFP+HorSP+HorBP)) then
                    hpos<=0;
                else
                    hpos<=hpos+1;
                end if;
            end if;
        else
            hpos<=0;
        end if;
     end process;

     Vpos_countkrnewawla:process(clk25,reset,hpos)
     begin
        if(write_enable='0') then
            if(reset ='1')then
                vpos<=0;
            elsif(clk25'event and clk25='1') then
                if(hpos = HorHD+ HorFP+HorSP+HorBP) then
                    if( vpos = (VerHD+VerFP+VerSP+VerBP)) then
                        vpos<=0;
                    else
                        vpos<=vpos+1;
                    end if;
                end if;
            end if;
        else
            vpos<=0;
        end if;
     end process;

     Hor_Sync:process(clk25,reset,hpos)
     begin
        if(write_enable ='0') then
            if(reset='1')then
                HSYNC<='0';
            elsif(clk25'event and clk25='1')then
                if((hpos<=(HorHD+HorFP))OR(hpos>HorHD+HorFP+HorSP)) then
                    HSYNC<='1';
                else
                    HSYNC<='0';
                end if;
            end if;
        else
            HSYNC<='0';
        end if;
     end process;

     Ver_Sync:process(clk25,reset,vpos)
     begin
        if(write_enable ='0') then
            if(reset='1')then
                VSYNC<='0';
            elsif(clk25'event and clk25='1')then
                if((vpos<=(VerHD+VerFP)) OR (vpos>VerHD+VerFP+VerSP))  then
                    VSYNC<='1';
                else
                    VSYNC<='0';
                end if;
            end if;
        else
            VSYNC <='0';
        end if;
     end process;


     VIDEO_ON:process(clk25,reset,hpos,vpos)
     begin
            if(write_enable='0') then
                if(reset='1')then
                    vidOn<='0';
                elsif(clk25'event and clk25='1')then
                    if(hpos<=HorHD and vpos<=VerHD)then
                        vidOn<='1';
                    else
                        vidOn<='0';
                    end if;
                end if;
            end if;
     end process;


   clock_process :process
    begin
        CLK <= '0';
        wait for clock_period/2;
        CLK <= '1';
        wait for clock_period/2;
    end process;

    stim_process: process(clk25)

    variable temp1:std_logic_vector(8 downto 0);
    variable temp2: std_logic_vector(8 downto 0);
    variable temp3: std_logic_vector(8 downto 0);
    variable temp4: std_logic_vector(8 downto 0);
    variable prev_prev: std_logic_vector(7 downto 0);
    variable prev: std_logic_vector(7 downto 0);
    variable curren: std_logic_vector(7 downto 0);
    variable grad: std_logic_vector(7 downto 0);
    variable i: integer:=0;
    variable j: integer:= 0;
    variable v:integer:=0;
        begin

        if rising_edge(clk25) then
           if  write_enable='1' then
                if j = 0 then
                    pp <= (others => '0');
                    p <= (others => '0');
                    rom_address <= std_logic_vector(to_unsigned(256 * i + j, 16));
                    current <= rom_data;
                elsif j < 256 then
                    prev_prev:= p;
                    prev:= current;
                    pp <= prev_prev;
                    p <= prev;
                    rom_address <= std_logic_vector(to_unsigned(256 * i + j, 16));
                    curren := rom_data;
                    current<= curren;
                else
                    prev_prev:= p;
                    prev:= current;
                    pp <= prev_prev;
                    p <= prev;
                    curren := (others => '0');
                    current <=  curren;
                end if;
                if j > 0 then
                    temp1 := ('0' & curren) + ('0' & prev_prev);
                    t1<= temp1;
                    temp4 := ('0' & prev);
                    temp2 := ('0' & prev) + ('0' & prev);
                    t2 <= temp2;
                    if temp1 < temp2 then
                        grad := (others => '0');
                        gradient <= grad;
                    else
                        temp3 := (temp1 - temp2);
                        t3 <= temp3;
                        if temp3(8) = '1' then
                            grad := (others => '1');
                            gradient <= grad;
                        else
                            grad := temp3(7 downto 0);
                            gradient <= grad;
                        end if;
                    end if;
                    if i = 0 then
                        if j = 1 then
                            ram_address <= "0000000000000000" ;
                        else
                            ram_address <= 256 * i + j-"0000000000000001";
                        end if;
                    else
                        ram_address <= (256 * i + j - "0000000000000001");
                    end if;
                    ram_data_in <= grad;
                end if;
                    if(j <255) then
                        j := j+1;
                    elsif(j=255 and i<256) then
                        j:=0;
                        i:=i+1;
                    elsif(j=255 and i=256) then
                        write_enable <='0';
                        ram_address <= "0000000000000000";

                    end if;
             elsif write_enable='0' then
                if ((hPos >= 0 and hPos < 256)AND(vPos >= 0 and vPos < 256 )) then


                                v:= hPos + 256*vPos + 1;
                           ram_address <= std_logic_vector(to_unsigned(v,16));
                    end if;

            end if;
        end if;
    end process stim_process;


Display:process(vidOn,vpos,hpos,clk25,reset,r,ram_address)
      variable l: integer:=0;
    begin
        if(write_enable= '0') then
            if(reset = '1') then
                vRed <= "0000";
                vBlue <= "0000";
                vGreen <= "0000";
            elsif(rising_edge(clk25)) then
                if(vidOn ='1') then
                    if(vpos>=0 and vpos < 256 ) and (hpos >=0 and hpos <256 ) then
                        vRed <= ram_data_out(7 downto 4);
                        vBlue <= ram_data_out(7 downto 4);
                        vGreen <= ram_data_out(7 downto 4);
                    else
                        vRed <="0000";
                        vBlue <="0000";
                        vGreen <= "0000";
                    end if;
                end if;
            end if;
        else
                vRed <= "0000";
                vBlue <= "0000";
                vGreen <= "0000";
        end if;

    end process;

end Behavioral;
