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
        INIT_04 => X"3004507334011073000101130000113700018213eef18193deadc1b7fe010113",
        INIT_05 => X"00112023ff4101130540006f33c000ef00100073344000ef30411073fff00113",
        INIT_06 => X"0005853300029663fff50293000583330280006f000514630061242300512223",
        INIT_07 => X"00812303004122830001208300030533fe029ce3fff2829300b303330140006f",
        INIT_08 => X"00f720230077e79300072783810007370000006f0000006f0000806700c10113",
        INIT_09 => X"00e7a023001767130007a70300e7a023ff8777130007a703810007b700008067",
        INIT_0A => X"00e7a023002767130007a70300e7a023ff8777130007a703810007b700008067",
        INIT_0B => X"00100713000027b70000806700f72023ff87f793000727838100073700008067",
        INIT_0C => X"ff0101130000806700e7a0230070071300e7a02301700713810007b700e7a823",
        INIT_0D => X"00a80eb3020004130080029300400393fff00713000008130091242300812623",
        INIT_0E => X"000f002300fe0f3300ef002300fe8f330000079300d808b300c8033300b80e33",
        INIT_0F => X"000f002300fe8f33fc779ee30017879300ef0023000f802300f88f3300f30fb3",
        INIT_10 => X"fc579ee30017879300ef0023000f802300f88f3300f30fb300ef002300fe0f33",
        INIT_11 => X"01050f33040004930080039307f0071300400413fff00893f8881ce300880813",
        INIT_12 => X"000f802300fe8fb3000f802300ff0fb3000007930106833301060e3301058eb3",
        INIT_13 => X"00ef802300ff0fb3fc879ee300178793011f80230112802300f30fb300fe02b3",
        INIT_14 => X"fc779ee300178793011f802300e2802300f30fb300fe02b300ef802300fe8fb3",
        INIT_15 => X"000005130005079300008067010101130081248300c12403f8981ce300880813",
        INIT_16 => X"00008067fe0596e30017979300f50533000704630015d5930015f71302058063",
        INIT_17 => X"0036161300008067fe079ce3001505134087d793000005130005079300008067",
        INIT_18 => X"00c5573340c307b3800008b701f0031300159e130000283704064663ff860613",
        INIT_19 => X"0148478300e880230ff7771300d5d7330006c46300e7e733fe06069300fe17b3",
        INIT_1A => X"0030071300a785330015179300008067fc0656e300f80a2300178793ff860613",
        INIT_1B => X"001858130015959300b888b300078463fff70713001877930050081300000893",
        INIT_1C => X"00c7073300058463fff7879300187593007008130030079301150533fe0714e3",
        INIT_1D => X"fff585930016771300b006130040059300e50533fe0794e30018581300161613",
        INIT_1E => X"0000806703f5751300f50533fe0594e3001656130016969300d787b300070463",
        INIT_1F => X"02010513060105930a0106130e010693da010113000080670ff5751340b50533",
        INIT_20 => X"256120232551222325412423253126232521282324912a2324812c2324112e23",
        INIT_21 => X"2201071312010793d69ff0ef23b1262323a1282323912a2323812c2323712e23",
        INIT_22 => X"000024b700078793004f861300078f93000027b7fee79ce3004787930007a023",
        INIT_23 => X"fef614e300e48a23001707130144c70300e68023001787930007c703800006b7",
        INIT_24 => X"00d7f7b341f6d69300e557b3fe070693ff800613800005b701800713004fa503",
        INIT_25 => X"008fa503fcc71ce300f48a2300178793ff8707130144c78300f580230ff7f793",
        INIT_26 => X"0ff7f79300d7f7b341f6d69300e557b3fe070693ff8005938000063701800713",
        INIT_27 => X"00dfc68300cfc783fcb71ce300f48a2300178793ff8707130144c78300f60023",
        INIT_28 => X"00d6002300f48a2300178793008002930ff007130144c78300f60023fff00d93",
        INIT_29 => X"00f48a2300000a9300000413000d88930017879300e12e2300000c930144c783",
        INIT_2A => X"01b12c23ff8d8c93000c871300028d931fe00d1380000bb701f00c1300000993",
        INIT_2B => X"00cfc5030601071300088a9300098d9300070b130080039300040693000a8313",
        INIT_2C => X"000a45830009ce0300400713002789b3019709330a010713020c879301970a33",
        INIT_2D => X"200ade6316d40a6300c4643300a4643300859513010e141318e50c6300094603",
        INIT_2E => X"00d1242300b1262300c1282300612a23000e05130006c683019786b30e010793",
        INIT_2F => X"f00ea28300e78eb302010713200e8793002e9e930ff57e93d71ff0ef01c12223",
        INIT_30 => X"0fe00f13014123030101260300c125830081268300412e0300078f93000027b7",
        INIT_31 => X"41b585b340660633002e0713416e0e333482886300800393ff8007931fc00813",
        INIT_32 => X"00300313f08ea02301861613018595930ff678930ff5f713018e1e130ff77513",
        INIT_33 => X"32b35263001003131ea5c263ffe005130ea36c63418656134185d593418e5e13",
        INIT_34 => X"40b608b300fe48630007059340ee0e3300b56e6303f005130ff5f59302070593",
        INIT_35 => X"00e456b340ec06330ec68063018007130040061300cfc68330e8d663ffc00713",
        INIT_36 => X"0144c68300db80230ff6f69300bf56b30005c46300d666b3fe07059300c81633",
        INIT_37 => X"0e01071300094603000a45830009ce03fcf716e300d48a2300168693ff870713",
        INIT_38 => X"0006031300058d930181270300e12e23000e0b13001c8c930007470301970733",
        INIT_39 => X"0e010713fc5ff06f418ada93018a9a93001a8a93e51ff06f0004069315970c63",
        INIT_3A => X"00a464330086151300a4643301d4643301059e93018e14130005450301970533",
        INIT_3B => X"00700713f2fe48e340be0e33f2e56ce303f005130ff7771302070713e59ff06f",
        INIT_3C => X"00e456b340ec063302000713f2c694e3018007130040061300cfc683f1c75ee3",
        INIT_3D => X"00db80230ff6f69300b6d6b30ff006930005c66300d666b3fe07059300cd1633",
        INIT_3E => X"408ad6130c0a8a93f1dff06ffcf714e300d48a2300168693ff8707130144c683",
        INIT_3F => X"0205c06300b6d6b3ff86061300169513fd86059341fad6930036161300160613",
        INIT_40 => X"40cc05b3000006130276186300d48a23001686930144c68300db80230ff6f693",
        INIT_41 => X"00d48a23001686930144c68300db80230ff6f69300d5e6b300cad6b300b515b3",
        INIT_42 => X"0ff7771302070713d6dff06ffff00a9300094603000a45830009ce03fc760ce3",
        INIT_43 => X"0480069301812d83e29ff06ff1c74ae300700713e4e560e340be0e3303f00513",
        INIT_44 => X"0c0887130608c463ccdd92e300060a9300058993000e0713008d8d93000a8893",
        INIT_45 => X"00800593ff86869300179513fd86861341f75793003696930016869340875693",
        INIT_46 => X"00d757b300c5163340d6063301f00613000006930080006f0206506300c7d7b3",
        INIT_47 => X"fcb688e300f48a23001787930144c78300f60023800006370ff7f79300f667b3",
        INIT_48 => X"00d7f7b341f6d69300e557b3fe070693ff800613800005b70010051303800713",
        INIT_49 => X"25c12083fcc71ce300f48a2300178793ff8707130144c78300f580230ff7f793",
        INIT_4A => X"23c12b8324012b0324412a8324812a0324c12983250129032541248325812403",
        INIT_4B => X"0ff5751300008067260101130000051322c12d8323012d0323412c8323812c03",
        INIT_4C => X"d61ff06f00e48a230009460300170713000a45830009ce030144c70300ab8023",
        INIT_4D => X"cee696e301c12703cf174ae30040071340b888b340be0e3308c35e6308a64663",
        INIT_4E => X"000086b7011767330088889300d7673300859713004e1693008e0e1302058593",
        INIT_4F => X"40d3033301f00313000006930080006f008005130080069341f7589300d76733",
        INIT_50 => X"001606130144c60300cb80230ff6761300c5e633006595b300d7563300189593",
        INIT_51 => X"f7dff06fc6e8c8e340be0e33ffc0071340b608b3cc9ff06ffca688e300c48a23",
        INIT_52 => X"0026061300d76733004717130025969300258593002e0713c6e692e301c12703",
        INIT_53 => X"0000000000000000f11ff06f00e68023800006b70ff777130407671300c76733",
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
