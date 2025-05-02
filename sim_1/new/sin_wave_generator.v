// Testbench module to generate a sine wave
module sine_wave_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns (100 MHz clock)
    parameter SAMPLES = 64; 
    parameter SAMPLES1=64;   // Number of points in one sine cycle
    parameter AMPLITUDE = 127; // Amplitude (e.g., for 8-bit output, max = 127)
    parameter OFFSET = 128;    // DC offset (e.g., to shift from -127 to +127 to 0 to 255)

    // Test signals
    reg clk = 0;
    reg reset = 1;
    reg [7:0] sine_out; // 8-bit output for sine wave
    integer i = 0;      // Counter for indexing

    // Lookup table for sine values (pre-computed)
    reg [7:0] sine_lut [0:SAMPLES-1];
    
    // Clock generation
    initial begin
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Initialize lookup table with sine values
    initial begin
        // Pre-compute sine values (scaled to 0-255)
        for (i = 0; i < SAMPLES; i = i + 1) begin
            sine_lut[i] = AMPLITUDE * $sin(2.0 * 3.14159265359 * i / SAMPLES) + AMPLITUDE*$sin(4.0 * 3.14159265359 * i / SAMPLES1)+ OFFSET;
        end
    end

    // Reset and stimulus generation
    initial begin
        // Apply reset
        reset = 1;
        #20 reset = 0; // Release reset after 20ns

        // Generate sine wave
        forever begin
            @(posedge clk); // Wait for positive edge of clock
            sine_out = sine_lut[i]; // Output current sine value
            i = (i + 1) % SAMPLES;  // Increment index and wrap around
        end
    end

    // Monitor to display results
    initial begin
        $monitor("Time=%0t clk=%b reset=%b sine_out=%d", $time, clk, reset, sine_out);
        #1000 $finish; // Stop simulation after 1000ns
    end

endmodule