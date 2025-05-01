--------------------------------------------------------------------------------
-- KU Leuven - ESAT/COSIC - Emerging technologies, Systems & Security
--------------------------------------------------------------------------------
-- Module Name:     wrapped_sensor - Behavioural
-- Project Name:    sensor
-- Description:     
--
-- Revision     Date       Author     Comments
-- v0.1         20250324   VlJo       Initial version
--
--------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
--    use IEEE.NUMERIC_STD.ALL;

library work;
    use work.PKG_hwswcd.ALL;

entity hashcomputer is
    port(
        clock : in STD_LOGIC;
        reset : in STD_LOGIC;
        iface_di : in STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
        iface_a : in STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
        iface_we : in STD_LOGIC;
        iface_do : out STD_LOGIC_VECTOR(C_WIDTH-1 downto 0)
    );
end entity hascomputer;


architecture Behavioural of hascomputer is

    -- (DE-)LOCALISING IN/OUTPUTS
    signal clock_i : STD_LOGIC;
    signal reset_i : STD_LOGIC;
    signal iface_di_i : STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
    signal iface_a_i : STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
    signal iface_we_i : STD_LOGIC;
    signal iface_do_o : STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);

    signal reg0, reg2: STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);

    signal data_in, data_out: STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);

    signal address_within_range : STD_LOGIC;
begin

    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    clock_i <= clock;
    reset_i <= reset;
    iface_di_i <= iface_di;
    iface_a_i <= iface_a;
    iface_we_i <= iface_we;
    iface_do <= iface_do_o;
    
    -------------------------------------------------------------------------------
    -- PARSING
    -------------------------------------------------------------------------------
    address_within_range <= '1' when iface_a_i(C_WIDTH-1 downto C_PERIPHERAL_MASK_LOWINDEX) = C_HASH_BASE_ADDRESS_MASK else '0';

    -------------------------------------------------------------------------------
    -- COMPUTE
    -------------------------------------------------------------------------------
    data_in <= reg0;
    data_out <= reg1;
    data_out <= ((data_in(31 downto 24) * 3) + (data_in(23 downto 16) * 5) + (data_in(15 downto 8) * 7) + (data_in(7 downto 0), 11)) & 0x3F

    -------------------------------------------------------------------------------
    -- WRITE
    -------------------------------------------------------------------------------
    PREG: process(clock_i)
    begin
        if rising_edge(clock_i) then
            if reset_i = '1' then 
                reg0 <= (others => '0');
            else
                if address_within_range = '1' then 
                    if iface_we_i = '1' then 
                            reg0 <= iface_di_i;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -------------------------------------------------------------------------------
    -- WRITE
    -------------------------------------------------------------------------------
    PMUX: process(address_within_range, iface_we_i, reg0, reg1)
    begin
        iface_do_o <= reg1;
    end process; 


end Behavioural;
