--------------------------------------------------------------------------------
-- KU Leuven - ESAT/COSIC - Emerging technologies, Systems & Security
--------------------------------------------------------------------------------
-- Module Name:     riscv_microcontroller - Behavioural
-- Project Name:    riscv_microcontroller
-- Description:     
--
-- Revision     Date       Author     Comments
-- v0.1         20241210   VlJo       Initial version
--
--------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;

library work;
    use work.PKG_hwswcd.ALL;

entity riscv_microcontroller is
    port(
        sys_clock : in STD_LOGIC;
        sys_reset : in STD_LOGIC;
        gpio_leds : out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity riscv_microcontroller;

architecture Behavioural of riscv_microcontroller is

    -- (DE-)LOCALISING IN/OUTPUTS
    signal clock_i : STD_LOGIC;
    signal reset_i : STD_LOGIC;
    signal dmem_do_i_riscv : STD_LOGIC_VECTOR(31 downto 0);
    signal dmem_we_o_riscv : STD_LOGIC;
    signal dmem_a_o_riscv : STD_LOGIC_VECTOR(31 downto 0);
    signal dmem_di_o_riscv : STD_LOGIC_VECTOR(31 downto 0);
    
    signal dmem_do_i_mem : STD_LOGIC_VECTOR(31 downto 0);
    
    signal timer_do_i : STD_LOGIC_VECTOR(31 downto 0);
    
    signal instruction_i : STD_LOGIC_VECTOR(31 downto 0);
    signal PC_o : STD_LOGIC_VECTOR(31 downto 0);
    signal gpio_leds_o : STD_LOGIC_VECTOR(3 downto 0);
    
    signal clock_i_riscv : STD_LOGIC;
    signal reset_i_riscv : STD_LOGIC;
    signal filler : STD_LOGIC;
    signal leds : STD_LOGIC_VECTOR(6 downto 0);

begin

    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    clock_i <= sys_clock;
    reset_i <= sys_reset;
    gpio_leds <= gpio_leds_o;
    
    
    
    gpio_leds_o <= leds(3 downto 0);

    -------------------------------------------------------------------------------
    -- MICROPROCESSOR
    -------------------------------------------------------------------------------
    riscv_inst00: component riscv port map(
        clock => clock_i_riscv,
        reset => reset_i_riscv,
        dmem_do => dmem_do_i_riscv,
        dmem_we => dmem_we_o_riscv,
        dmem_a => dmem_a_o_riscv,
        dmem_di => dmem_di_o_riscv,
        instruction => instruction_i,
        PC => PC_o
    );
    
    imem_bram: component two_k_bram_imem port map(
        clock => clock_i_riscv,
        init_data_in => C_GND,
        init_write_enable => C_GND(0),
        init_address => C_GND(10 downto 0),
        data_in => C_GND,
        write_enable => C_GND(0),
        address => PC_o(12 downto 2),
        data_out => instruction_i
    );
    
    dram_bram: component two_k_bram_dmem port map(
        clock => clock_i_riscv,
        init_data_in => C_GND,
        init_write_enable => C_GND(0),
        init_address => C_GND(10 downto 0),
        data_in => dmem_di_o_riscv,
        write_enable => dmem_we_o_riscv,
        address => dmem_a_o_riscv(10 downto 0),
        data_out  => dmem_do_i_mem
    );
        
   clock_manager: component clock_and_reset_pynq port map(
        sysclock => clock_i,
        sysreset => reset_i,
        sreset => reset_i_riscv,
        clock => clock_i_riscv,
        heartbeat => filler
    );
    
    wrapper_timer_inst00: wrapped_timer port map(
        clock => clock_i_riscv,
        reset => reset_i_riscv, 
        iface_di => dmem_di_o_riscv,
        iface_a => dmem_a_o_riscv,
        iface_we => dmem_we_o_riscv,
        iface_do => timer_do_i
    );
    
    
    MUX_MEM_TIMER: process(timer_do_i, dmem_do_i_mem, dmem_a_o_riscv)
    begin
        if "10000001000000000000000000000000" <= dmem_a_o_riscv and dmem_a_o_riscv <= "10000001000000000000000011111111" then
            dmem_do_i_riscv <= timer_do_i;
        else
            dmem_do_i_riscv <= dmem_do_i_mem;
        end if;
    end process;
    
    PREG_LEDS: process(clock_i_riscv)
    begin
        if rising_edge(clock_i_riscv) then 
            if reset_i_riscv = '1' then 
                leds <= "0000000";
            else
                if dmem_we_o_riscv = '1' and dmem_a_o_riscv = x"80000000" then 
                    leds <= dmem_di_o_riscv(6 downto 0);
                end if;
            end if;
        end if;
    end process;


end Behavioural;
