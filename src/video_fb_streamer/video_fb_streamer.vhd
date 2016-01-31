LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_misc.all;
USE ieee.numeric_std.all;

-- Library containing FIFO components
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY video_fb_streamer IS 
	GENERIC(
		BUFFER_START_ADDRESS : std_logic_vector(31 downto 0) := (others => '0');
		BITS_PER_PIXEL       : integer                       := 8;
		FRAME_WIDTH          : integer                       := 640;
		FRAME_HEIGHT         : integer                       := 480
	);

	PORT (
		clk                      : in    std_logic;
		pix_clk                  : in    std_logic;
		reset                    : in    std_logic;

		coe_swap_frame           : in    std_logic;

		-- Avalon-ST Interface
		aso_source_ready         : in    std_logic;
		aso_source_data          : out   std_logic_vector(BITS_PER_PIXEL-1 downto 0);
		aso_source_startofpacket : out   std_logic;
		aso_source_endofpacket   : out   std_logic;
		aso_source_valid         : out   std_logic;

		-- DMA Master
		avm_dma0_readdata        : in    std_logic_vector(15 downto 0);
		avm_dma0_read            : out   std_logic;
		avm_dma0_writedata       : out   std_logic_vector(15 downto 0);
		avm_dma0_write           : out   std_logic;
		avm_dma0_readdatavalid	 : in    std_logic;
		avm_dma0_waitrequest     : in    std_logic;
		avm_dma0_address         : buffer std_logic_vector(31 downto 0);	
		avm_dma0_burstcount      : out   std_logic_vector(7 downto 0)
	);

END video_fb_streamer;

ARCHITECTURE Behaviour OF video_fb_streamer IS
	-- Type definitions
	TYPE state IS (INIT, INIT_SRAM, SRAM_TO_FIFO, IDLE);

	-- Internal Wires
	SIGNAL pixel                       : std_logic_vector (7 downto 0);

	-- Internal Registers
	SIGNAL x                         : std_logic_vector (9 downto 0);
	SIGNAL y                         : std_logic_vector (8 downto 0);

	SIGNAL fifo_input_data           : std_logic_vector (15 downto 0);
	SIGNAL fifo_write_next           : std_logic;
	SIGNAL fifo_write_used           : std_logic_vector (6 downto 0);
	SIGNAL fifo_write_full           : std_logic;

	SIGNAL fifo_output_data          : std_logic_vector (7 downto 0);
	SIGNAL fifo_output_valid         : std_logic;
	SIGNAL fifo_read_next            : std_logic;
	
	SIGNAL current_state             : state := INIT;
	SIGNAL next_state                : state;

	SIGNAL sram_written              : integer := 0;
BEGIN

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' THEN
				current_state <= INIT;
			ELSE
				current_state <= next_state;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (current_state, sram_written)
	BEGIN
		CASE current_state IS
			WHEN INIT =>
				avm_dma0_address <= BUFFER_START_ADDRESS;
				avm_dma0_burstcount <= std_logic_vector(to_unsigned(32, avm_dma0_burstcount'length));
				avm_dma0_write <= '1';
				avm_dma0_writedata <= x"33CC";
				next_state <= INIT_SRAM;
			WHEN INIT_SRAM =>
				IF (sram_written >= 32) THEN
					avm_dma0_address <= avm_dma0_address + '1';
					avm_dma0_write <= '0';
					next_state <= SRAM_TO_FIFO;
				ELSE
					next_state <= INIT_SRAM;
				END IF;
			WHEN SRAM_TO_FIFO =>
				avm_dma0_address <= BUFFER_START_ADDRESS;
				avm_dma0_burstcount <= std_logic_vector(to_unsigned(1, avm_dma0_burstcount'length));
				avm_dma0_read <= '1';
				next_state <= SRAM_TO_FIFO;
			WHEN IDLE =>
				next_state <= IDLE;
			WHEN OTHERS =>
				next_state <= INIT;
		END CASE;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (current_state = INIT_SRAM and avm_dma0_waitrequest = '0') THEN
				sram_written <= sram_written + 1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk, avm_dma0_readdatavalid)
	BEGIN
		IF (current_state = SRAM_TO_FIFO) THEN
			IF (avm_dma0_readdatavalid = '1') THEN
				fifo_input_data <= avm_dma0_readdata;
				fifo_write_next <= '1';
			ELSE
				fifo_write_next <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	-- Internal Registers
	PROCESS (pix_clk)
	BEGIN
		IF rising_edge(pix_clk) THEN
			IF (reset = '1') THEN
				x <= (OTHERS => '0');
				fifo_read_next <= '0';
			ELSIF (aso_source_ready = '1') THEN
				fifo_read_next <= '1';
				IF (x = (FRAME_WIDTH - 1)) THEN
					x <= (OTHERS => '0');
				ELSE
					x <= x + '1';
				END IF;
			ELSE
				fifo_read_next <= '0';
			END IF;
		END IF;
	END PROCESS;


	PROCESS (pix_clk)
	BEGIN
		IF rising_edge(pix_clk) THEN
			IF (reset = '1') THEN
				y <= (OTHERS => '0');
			ELSIF ((aso_source_ready = '1') AND (x = (FRAME_WIDTH - 1))) THEN
				IF (y = (FRAME_HEIGHT - 1)) THEN
					y <= (OTHERS => '0');
				ELSE
					y <= y + '1';
				END IF;
			END IF;
		END IF;
	END PROCESS;


	-- Output Assignments
	aso_source_data            <= pixel;
	aso_source_startofpacket   <= '1' WHEN ((x = 0) AND (y = 0)) ELSE '0';
	aso_source_endofpacket     <= '1' WHEN ((x = (FRAME_WIDTH - 1)) AND (y = (FRAME_HEIGHT - 1))) ELSE '0';
	aso_source_valid           <= fifo_output_valid;

	-- Internal Assignments
	pixel        <= fifo_output_data;

	-- Instantiate Components
	f0 : dcfifo_mixed_widths
	GENERIC MAP(
		add_ram_output_register => "OFF",
		lpm_numwords            => 128,
		lpm_showahead           => "ON",
		lpm_type                => "dcfifo_mixed_widths",
		lpm_width               => 16,
		lpm_width_r             => 8,
		lpm_widthu_r				=> 8,
		lpm_widthu              => 7,
		overflow_checking       => "OFF",
		underflow_checking      => "OFF",
		use_eab                 => "ON"
	)
	PORT MAP(
		wrclk				=> clk,
		wrreq				=> fifo_write_next,
		wrusedw        => fifo_write_used,
		wrfull         => fifo_write_full,
		data				=> fifo_input_data,

		rdclk          => pix_clk,
		rdreq				=> fifo_read_next,
		rdempty        => fifo_output_valid,
		q					=> fifo_output_data
	);

END Behaviour;
