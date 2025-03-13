--------------------------------------------------------------------------------
-- KU Leuven - ESAT/COSIC - Emerging technologies, Systems & Security
--------------------------------------------------------------------------------
-- Module Name:     two_k_bram_imem - Behavioural
-- Project Name:    two_k_bram_imem
-- Description:     
--
-- Revision     Date       Author     Comments
-- v0.1         20250204   VlJo       Initial version
--
--------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    -- use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
    use UNISIM.vcomponents.all;

entity two_k_bram_imem is
    port(
        clock : in STD_LOGIC;

        init_data_in : in STD_LOGIC_VECTOR(31 downto 0);
        init_write_enable : in STD_LOGIC;
        init_address : in STD_LOGIC_VECTOR(10 downto 0);

        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        write_enable : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(10 downto 0);
        data_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity two_k_bram_imem;

architecture Behavioural of two_k_bram_imem is

    -- (DE-)LOCALISING IN/OUTPUTS
    signal clock_i : STD_LOGIC;
    signal init_data_in_i : STD_LOGIC_VECTOR(31 downto 0);
    signal init_write_enable_i : STD_LOGIC;
    signal init_address_i : STD_LOGIC_VECTOR(10 downto 0);
    signal data_in_i : STD_LOGIC_VECTOR(31 downto 0);
    signal write_enable_i : STD_LOGIC;
    signal address_i : STD_LOGIC_VECTOR(10 downto 0);
    signal data_out_o : STD_LOGIC_VECTOR(31 downto 0);

    constant C_NULL : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
    constant C_ONES : STD_LOGIC_VECTOR(31 downto 0) := x"FFFFFFFF";

    signal init_address_00, init_address_01 : STD_LOGIC_VECTOR(15 downto 0);
    signal init_write_enable_00, init_write_enable_01 : STD_LOGIC;
    signal init_write_enable_00_vec, init_write_enable_01_vec : STD_LOGIC_VECTOR(3 downto 0);

    signal address_00, address_01 : STD_LOGIC_VECTOR(15 downto 0);
    signal write_enable_00, write_enable_01 : STD_LOGIC;
    signal write_enable_00_vec, write_enable_01_vec : STD_LOGIC_VECTOR(7 downto 0);
    signal data_out_00, data_out_01 : STD_LOGIC_VECTOR(31 downto 0);


begin

    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    clock_i <= clock;
    init_data_in_i <= init_data_in;
    init_write_enable_i <= init_write_enable;
    init_address_i <= init_address;

    data_in_i <= data_in;
    write_enable_i <= write_enable;
    address_i <= address;
    data_out <= data_out_o;


    init_address_00 <= "0" & init_address_i(9 downto 0) & "00000";
    init_address_01 <= "0" & init_address_i(9 downto 0) & "00000";
    init_write_enable_00 <= init_write_enable_i and not(init_address(10));
    init_write_enable_01 <= init_write_enable_i and init_address(10);    
    init_write_enable_00_vec <= (others => init_write_enable_00);
    init_write_enable_01_vec <= (others => init_write_enable_01);
    
    address_00 <= "0" & address_i(9 downto 0) & "00000";
    address_01 <= "0" & address_i(9 downto 0) & "00000";
    write_enable_00 <= write_enable_i and not(address_i(10));
    write_enable_01 <= write_enable_i and address_i(10);
    write_enable_00_vec <= (others => write_enable_00);
    write_enable_01_vec <= (others => write_enable_01);
    data_out_o <= data_out_00 when address_i(10) = '0' else data_out_01;
    

    -------------------------------------------------------------------------------
    -- BRAM PRIMITIVES
    -------------------------------------------------------------------------------
    RAMB36E1_inst00 : RAMB36E1
    generic map (
        RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
        SIM_COLLISION_CHECK => "ALL",
        DOA_REG => 0,
        DOB_REG => 0,
        EN_ECC_READ => FALSE,
        EN_ECC_WRITE => FALSE,
        -- INIT_00 to INIT_7F: Initial contents of the data memory array
        INIT_00 => X"0000041300000393000003130000029300000213000001930000011300000093",
        INIT_01 => X"0000081300000793000007130000069300000613000005930000051300000493",
        INIT_02 => X"00000c1300000b9300000b1300000a9300000a13000009930000091300000893",
        INIT_03 => X"0000113700000f9300000f1300000e9300000e1300000d9300000d1300000c93",
        INIT_04 => X"fff502930005833300008067000514630000006f001000730080006f32c000ef",
        INIT_05 => X"0000806700030533fe029ce3fff2829300b30333000080670005853300029663",
        INIT_06 => X"00150513000080670007946300054783800007370000806700a7a023800007b7",
        INIT_07 => X"000704630015f71300008067000594630000051300050793fedff06f00f72023",
        INIT_08 => X"0091222300812423ff01011304058863fe5ff06f0015d5930017979300f50533",
        INIT_09 => X"0081240300c1208300894e630010091300058413000504930011262301212023",
        INIT_0A => X"fd9ff06f00190913f95ff0ef0004859300008067010101130001290300412483",
        INIT_0B => X"000787130000806700e7a02303000713800007b704051e630000806700100513",
        INIT_0C => X"f75ff0ef00a00513fef6e4e3fee6ece300178793ff6707130000079300158593",
        INIT_0D => X"010101130081240300c120830605126300900613800006b7c307071300001737",
        INIT_0E => X"009006930000059300050793000504130011262300812423ff01011300008067",
        INIT_0F => X"0005079300f6a0230007c78300f707b3fea47ce30017879340a40433fb5ff06f",
        INIT_10 => X"04058263fd5ff06f00000793ff5ff06f00150513ff678793faf676e300000513",
        INIT_11 => X"c4050513000015370005d863800006b7c4470713ffc585930000173700259593",
        INIT_12 => X"fd9ff06f00f6a023ffc585930007c78300f707b300f7f79300b557b3e8dff06f",
        INIT_13 => X"00072783810007370000806700f720230037e793000727838100073700008067",
        INIT_14 => X"0007278381000737fe5ff0ef00112623ff0101130000806700f72023ffc7f793",
        INIT_15 => X"fbdff0ef00112623ff010113000080670101011300f720230017e79300c12083",
        INIT_16 => X"fe010113000080670101011300f720230027e79300c120830007278381000737",
        INIT_17 => X"00912a2300112e23000425030005091300062583012128230005841300812c23",
        INIT_18 => X"00a989b3d79ff0ef00442503000509930084a583d89ff0ef0006049301312623",
        INIT_19 => X"d55ff0ef004425030005099300c4a583d65ff0ef000425030044a58301392023",
        INIT_1A => X"00c42503000509930084a583d41ff0ef013922230084250300a989b30004a583",
        INIT_1B => X"0005099300c4a583d1dff0ef008425030044a5830139242300a989b3d31ff0ef",
        INIT_1C => X"01012903014124830139262300a989b30181240301c12083d0dff0ef00c42503",
        INIT_1D => X"0081242300112623000014b700912223ff010113000080670201011300c12983",
        INIT_1E => X"0060079300f422230020079300f428230050079300f420238004841300100793",
        INIT_1F => X"0080079300f426230040079300f42c230070079300f424230030079300f42a23",
        INIT_20 => X"810007b7e61ff0efec9ff0ef020405138004859301040613e61ff0ef00f42e23",
        INIT_21 => X"000080670101011300000513004124830081240300c12083d45ff0ef00c7a503",
        INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_A => X"000000000",
        INIT_B => X"000000000",
        INIT_FILE => "NONE",
        RAM_MODE => "TDP", -- RAM Mode: "SDP" or "TDP" 
        RAM_EXTENSION_A => "NONE", -- RAM_EXTENSION_A, RAM_EXTENSION_B: Selects cascade mode ("UPPER", "LOWER", or "NONE")
        RAM_EXTENSION_B => "NONE",
        READ_WIDTH_A => 36, -- 0-72
        READ_WIDTH_B => 36, -- 0-36
        WRITE_WIDTH_A => 36, -- 0-36
        WRITE_WIDTH_B => 36, -- 0-72
        RSTREG_PRIORITY_A => "RSTREG", ---- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
        RSTREG_PRIORITY_B => "RSTREG",
        SRVAL_A => X"000000000", -- SRVAL_A, SRVAL_B: Set/reset value for output
        SRVAL_B => X"000000000",
        SIM_DEVICE => "7SERIES",
        WRITE_MODE_A => "WRITE_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
        WRITE_MODE_B => "WRITE_FIRST" 
    )
   port map (
        CASCADEOUTA => open,
        CASCADEOUTB => open,
        DBITERR => open,
        ECCPARITY => open,
        RDADDRECC => open,
        SBITERR => open,
        DOADO => open,
        DOPADOP => open,
        DOBDO => data_out_00,
        DOPBDOP => open,
        CASCADEINA => C_NULL(0),
        CASCADEINB => C_NULL(0),
        INJECTDBITERR => C_NULL(0),
        INJECTSBITERR => C_NULL(0),
        ADDRARDADDR => init_address_00,
        CLKARDCLK => clock_i,
        ENARDEN => C_NULL(0),
        REGCEAREGCE => C_NULL(0),
        RSTRAMARSTRAM => C_NULL(0),
        RSTREGARSTREG => C_NULL(0),
        WEA => init_write_enable_00_vec,
        DIADI => init_data_in_i,
        DIPADIP => C_NULL(3 downto 0),
        ADDRBWRADDR => address_00,
        CLKBWRCLK => clock_i,
        ENBWREN => C_ONES(0),
        REGCEB => C_NULL(0),
        RSTRAMB => C_NULL(0),
        RSTREGB => C_NULL(0),
        WEBWE => write_enable_00_vec,
        DIBDI => data_in_i,
        DIPBDIP => C_NULL(3 downto 0)
    );

    RAMB36E1_inst01 : RAMB36E1
    generic map (
        RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
        SIM_COLLISION_CHECK => "ALL",
        DOA_REG => 0,
        DOB_REG => 0,
        EN_ECC_READ => FALSE,
        EN_ECC_WRITE => FALSE,
        -- INIT_00 to INIT_7F: Initial contents of the data memory array
        INIT_A => X"000000000",
        INIT_B => X"000000000",
        INIT_FILE => "NONE",
        RAM_MODE => "TDP", -- RAM Mode: "SDP" or "TDP" 
        RAM_EXTENSION_A => "NONE", -- RAM_EXTENSION_A, RAM_EXTENSION_B: Selects cascade mode ("UPPER", "LOWER", or "NONE")
        RAM_EXTENSION_B => "NONE",
        READ_WIDTH_A => 36, -- 0-72
        READ_WIDTH_B => 36, -- 0-36
        WRITE_WIDTH_A => 36, -- 0-36
        WRITE_WIDTH_B => 36, -- 0-72
        RSTREG_PRIORITY_A => "RSTREG", ---- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
        RSTREG_PRIORITY_B => "RSTREG",
        SRVAL_A => X"000000000", -- SRVAL_A, SRVAL_B: Set/reset value for output
        SRVAL_B => X"000000000",
        SIM_DEVICE => "7SERIES",
        WRITE_MODE_A => "WRITE_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
        WRITE_MODE_B => "WRITE_FIRST" 
    )
   port map (
        CASCADEOUTA => open,
        CASCADEOUTB => open,
        DBITERR => open,
        ECCPARITY => open,
        RDADDRECC => open,
        SBITERR => open,
        DOADO => open,
        DOPADOP => open,
        DOBDO => data_out_01,
        DOPBDOP => open,
        CASCADEINA => C_NULL(0),
        CASCADEINB => C_NULL(0),
        INJECTDBITERR => C_NULL(0),
        INJECTSBITERR => C_NULL(0),
        ADDRARDADDR => init_address_01,
        CLKARDCLK => clock_i,
        ENARDEN => C_NULL(0),
        REGCEAREGCE => C_NULL(0),
        RSTRAMARSTRAM => C_NULL(0),
        RSTREGARSTREG => C_NULL(0),
        WEA => init_write_enable_01_vec,
        DIADI => init_data_in_i,
        DIPADIP => C_NULL(3 downto 0),
        ADDRBWRADDR => address_01,
        CLKBWRCLK => clock_i,
        ENBWREN => C_ONES(0),
        REGCEB => C_NULL(0),
        RSTRAMB => C_NULL(0),
        RSTREGB => C_NULL(0),
        WEBWE => write_enable_01_vec,
        DIBDI => data_in_i,
        DIPBDIP => C_NULL(3 downto 0)
    );

end Behavioural;
