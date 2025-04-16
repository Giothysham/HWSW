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
        INIT_00 => X"004124230031222300112023340111730000001300000013000000131140006f",
        INIT_01 => X"02c1242302b1222302a1202300912e2300812c2300712a230061282300512623",
        INIT_02 => X"05412423053122230521202303112e2303012c2302f12a2302e1282302d12623",
        INIT_03 => X"07c1242307b1222307a1202305912e2305812c2305712a230561282305512623",
        INIT_04 => X"008122030041218300012083218000ef3420357307f12a2307e1282307d12623",
        INIT_05 => X"02812603024125830201250301c1248301812403014123830101230300c12283",
        INIT_06 => X"04812a03044129830401290303c1288303812803034127830301270302c12683",
        INIT_07 => X"06812e0306412d8306012d0305c12c8305812c0305412b8305012b0304c12a83",
        INIT_08 => X"000001930000011300000093302000733401117307412f8307012f0306c12e83",
        INIT_09 => X"0000059300000513000004930000041300000393000003130000029300000213",
        INIT_0A => X"0000099300000913000008930000081300000793000007130000069300000613",
        INIT_0B => X"00000d9300000d1300000c9300000c1300000b9300000b1300000a9300000a13",
        INIT_0C => X"eef18193deadc1b7fe0101130000113700000f9300000f1300000e9300000e13",
        INIT_0D => X"fff0011330511073e60101130000011734011073000101130000113700018213",
        INIT_0E => X"0051222300112023ff4101130540006f39c000ef001000733a4000ef30411073",
        INIT_0F => X"0140006f0005853300029663fff50293000583330280006f0005146300612423",
        INIT_10 => X"00c1011300812303004122830001208300030533fe029ce3fff2829300b30333",
        INIT_11 => X"00f720230077e7930007278381000737000000000000006f0000006f00008067",
        INIT_12 => X"00112623ff0101130000806700f72023ff87f793000727838100073700008067",
        INIT_13 => X"000080670101011300c1208300f720230017e7930007278381000737fe5ff0ef",
        INIT_14 => X"00c1208300f720230027e7930007278381000737fbdff0ef00112623ff010113",
        INIT_15 => X"0000806700e7a023fff00713800007b700050863004575130000806701010113",
        INIT_16 => X"00a80eb30200039300800f9300400293fff007130000081300812623ff010113",
        INIT_17 => X"000f002300fe0f3300ef002300fe8f330000079300d808b300c8033300b80e33",
        INIT_18 => X"000f002300fe8f33fc579ee30017879300ef002300f88f33000f002300f30f33",
        INIT_19 => X"fdf79ee30017879300ef002300f88f33000f002300f30f3300ef002300fe0f33",
        INIT_1A => X"01050f33040004130080029307f0071300400393fff00893f8781ce300880813",
        INIT_1B => X"000f802300fe8fb3000f802300ff0fb3000007930106833301060e3301058eb3",
        INIT_1C => X"00ef802300ff0fb3fc779ee300178793011f802300f30fb3011f802300fe0fb3",
        INIT_1D => X"fc579ee300178793011f802300f30fb300ef802300fe0fb300ef802300fe8fb3",
        INIT_1E => X"000005130205866300050793000080670101011300c12403f8881ce300880813",
        INIT_1F => X"fe9ff06f00f50533fe0708e30015f71300058a630015d593001797930100006f",
        INIT_20 => X"018597130ff57513001505130000051300050693000080670005851300008067",
        INIT_21 => X"00008067fc079ee300e7e7b300070593000786930085d71300f767b30086d793",
        INIT_22 => X"00159e1301088893000028b74107c703000027b706064063ff86061300361613",
        INIT_23 => X"0017071300f6802300f867b300c557b3010e183340c308330280006f01f00313",
        INIT_24 => X"fddff06f00f5d7b3fc07cae3fe06079300e886b300064c63ff8606130ff77713",
        INIT_25 => X"0121282300912a2300812c2300112e23fe0101130000806740e78823000027b7",
        INIT_26 => X"0050059300050413f01ff0ef0030059300068493000609130005899301312623",
        INIT_27 => X"00b0059300a40433ee1ff0ef000905130070059300a40433ef1ff0ef00098513",
        INIT_28 => X"01012903014124830181240301c1208303f5751300a40533ed1ff0ef00048513",
        INIT_29 => X"4107c683000027b7000080670ff5751340b50533000080670201011300c12983",
        INIT_2A => X"0017879300e620230007c7038000063700f686b301078793000027b702068263",
        INIT_2B => X"23312e2325212023249122232481242324112623db01011300008067fed79ae3",
        INIT_2C => X"21b12e2323a120232391222323812423237126232361282323512a2323412c23",
        INIT_2D => X"1101071301010793d0dff0ef1d010513190105931501061311010693ca5ff0ef",
        INIT_2E => X"0047851300070713000027374107c783000027b7fee79ce3004787930007a023",
        INIT_2F => X"0ff7f7930017879300c680230007460300f586b301058593000025b70ff57513",
        INIT_30 => X"0044250300400613000404130000243740f7082300002737fea794e300170713",
        INIT_31 => X"00c4450300100613e0dff0ef000005930084250300400613e1dff0ef00000593",
        INIT_32 => X"0000049300800d93dedff0ef0000059300d4450300100613dfdff0ef00000593",
        INIT_33 => X"000b8b9300002bb700000c1300000c9300000d1300f124230ff00793fff00a13",
        INIT_34 => X"0007c783008787b319010793018494930007c483008787b31d0107932b40006f",
        INIT_35 => X"008787b31501079300f4e4b30007c783008787b31101079300f4e4b301079793",
        INIT_36 => X"0c40006f418a5a13018a1a13001a0a131500006f00f4e4b3008797930007c783",
        INIT_37 => X"018716930ff676130016061300000613000587130005081341f555930c0a0513",
        INIT_38 => X"d25ff0effc079ee300d7e7b300068713000788130087569300f6e7b300885793",
        INIT_39 => X"00c127830680006fd0dff0ef000005930ff57513001006131000006ffff00a13",
        INIT_3A => X"002a8a9300f5e5b3002997930029899300459593002705931ad7986300812683",
        INIT_3B => X"0ff7f7930207879302c0006fcd1ff0ef41f5d5930405e513001006130155e5b3",
        INIT_3C => X"ca5ff0ef0fe0059300048513000b06131967846300cbc78316f6fe6303f00693",
        INIT_3D => X"008787b3150107930007cc83008787b3190107930007cc03008787b31d010793",
        INIT_3E => X"0004871315b408630014041300f124230007c783008787b3110107930007cd03",
        INIT_3F => X"008787b319010793010494930007c483008787b31d010793eb6780e300cbc783",
        INIT_40 => X"eae48ae300f4e4b30007c783008787b31501079300f4e4b3008797930007c783",
        INIT_41 => X"150107930007c983008787b3190107930007c903008787b31d010793ec0a50e3",
        INIT_42 => X"000a86130007869300f126230007c783008787b3110107930007ca83008787b3",
        INIT_43 => X"00d707330101069320070713002797130ff57793c45ff0ef0009051300098593",
        INIT_44 => X"41890933e097a02300e787b3010107132007879300279793ea9702e3e0072703",
        INIT_45 => X"018a9a9341aa8ab34189d993018999930ff9f793419989b34187571301891713",
        INIT_46 => X"0010069310d9c463ffe00693eb26e4e3003006930ff9791300290913418ada93",
        INIT_47 => X"0fc0006f4137073300098793e557d6e30010079300fac663ffe00793e936cce3",
        INIT_48 => X"0ff0059300048513005006130e80006fe6d74ee3ff8006934137073300098793",
        INIT_49 => X"00400b1300048713ff8d841300fd8a6304800793008d8d93e7dff06fb21ff0ef",
        INIT_4A => X"00000513be1ff0efaedff0ef000005930010051300800613040a5c63ea1ff06f",
        INIT_4B => X"23012b0323412a8323812a0323c1298324012903244124832481240324c12083",
        INIT_4C => X"0c0a0513000080672501011321c12d8322012d0322412c8322812c0322c12b83",
        INIT_4D => X"00885793018716930ff676130016061300000613000587130005081341f55593",
        INIT_4E => X"f6dff06fa69ff0effc079ee300d7e7b300068713000788130087569300f6e7b3",
        INIT_4F => X"d8e6c6e3007006934137073300098793d8f6eee303f006930ff7f79302078793",
        INIT_50 => X"02078513d6c698e30081260300c12683d6c6eee300800693004a861340fa8ab3",
        INIT_51 => X"00f56533000087b700f56533004717930087071301556533008a8a9300851513",
        INIT_52 => X"00885793018716930ff676130016061300000613000587130005081341f55593",
        INIT_53 => X"d25ff06f9c9ff0effc079ee300d7e7b300068713000788130087569300f6e7b3",
        INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
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
        INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
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
        INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
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
