# FIFO Test Environment and Test Cases

This repository contains the test environment and test cases designed for verifying the FIFO (First-In-First-Out) memory behavior. The environment includes a well-structured **testbench**, with components such as **drivers**, **monitors**, and **scoreboards** that facilitate a comprehensive verification flow. Below is a high-level description of the verification environment, including coverage, random testing, and the corresponding test cases.



# 1-FIFO Test plan 

This table outlines various test cases for FIFO (First-In-First-Out) memory, with fields for **Label**, **Description**, **Stimulus Generation**, **Functional Coverage**, and **Functionality Check**. These test cases cover various conditions related to FIFO behavior, including states like `almostfull`, `empty`, `overflow`, and `underflow`.

## Test Case Overview

| Label   | Description                                                                                          | Stimulus Generation                                                                                          | Functional Coverage                                                                      | Functionality Check                    |
|---------|------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|----------------------------------------|
| FIFO_1  | In case of `rst=0`, `{data_out, full, almostfull, overflow, underflow, wr_ack, almostempty}` must be zero. `{empty}` must be one, else no effect. | Constraint on reset: 90% one, 10% zero.                                                                      | No functional coverage specified for this test.                                           | Check output against golden model.     |
| FIFO_2  | In case of `wr_en && almostfull == 0 && full == 0` at next posedge clock (check at negedge), `data[wrt_ptr-1] == data_in`, `wr_ack == 1`, `overflow == 0`, `full == 0`, `almostfull == 1` if there is one place to write only. | Constraint on `wr_en`: 60% high, 40% low.                                                                  | Cross coverage between `wr_en && full` and `almostfull`, labeled `p1`.                   | Check output against golden model.     |
| FIFO_3  | In case of `wr_en && almostfull == 1 && full == 0` at next posedge clock (check at negedge), `data[wrt_ptr-1] == data_in`, `wr_ack == 1`, `overflow == 0`, `almostfull == 0`, `full == 1`. | Constraint on `wr_en`: 60% high, 40% low.                                                                  | Cross coverage between `wr_en && full` and `almostfull`, labeled `p1`.                   | Check output against golden model.     |
| FIFO_4  | In case of `wr_en && almostfull == 0 && full == 1` at next posedge clock (check at negedge), `data[wrt_ptr-1] == data_in` has no change, `wr_ack == 0`, `overflow == 1`, `almostfull == 0`, `full == 1`. | Constraint on `wr_en`: 60% high, 40% low.                                                                  | Cross coverage between `wr_en && full` and `almostfull`, labeled `p1`.                   | Check output against golden model.     |
| FIFO_5  | In case of `almostfull == 1 && full == 1`, assert error.                                               | N/A                                                                                                          | N/A                                                                                      | Assertion labeled `p3`.               |
| FIFO_6  | In case of `rd_en && almost_empty == 0 && empty == 0` at next posedge clock (check at negedge), `data_out == mem[rd_ptr-1]`, `underflow == 0`, `empty == 0`, `almostempty == 1` if there is one place to read only. | Constraint on `rd_en`: 60% high, 40% low.                                                                  | Cross coverage between `rd_en && empty` and `almostempty`, labeled `p2`.                 | Check output against golden model.     |
| FIFO_7  | In case of `rd_en && almost_empty == 1 && empty == 0` at next posedge clock (check at negedge), `data_out == mem[rd_ptr-1]`, `underflow == 1`, `empty == 1`, `almostempty == 0`. | Constraint on `rd_en`: 60% high, 40% low.                                                                  | Cross coverage between `rd_en && empty` and `almostempty`, labeled `p2`.                 | Check output against golden model.     |
| FIFO_8  | In case of `rd_en && almost_empty == 0 && empty == 1` at next posedge clock (check at negedge), `data_out == mem[rd_ptr-1]`, `underflow == 1`, `empty == 1`, `almostempty == 0`. | Constraint on `rd_en`: 60% high, 40% low.                                                                  | Cross coverage between `rd_en && empty` and `almostempty`, labeled `p2`.                 | Check output against golden model.     |
| FIFO_9  | In case of `almostempty == 1 && empty == 1`, assert error.                                              | N/A                                                                                                          | N/A                                                                                      | Assertion labeled `p4`.               |
| FIFO_10 | In case of `write == 1` and `read == 1`, deal as FIFO_2_3_4_5.                                          | Mix of `rd_en`: 60%, `wr_en`: 40%.                                                                          | Cross coverage between `wr_en && rd_en`, labeled `p3`.                                   | Check output against golden model.     |
| FIFO_11 | Coverage of data in bins for values `< 0.25`, `0.5`, `0.75`, `1` of max value.                         | N/A                                                                                                          | Coverage of data bins `[<0.25, 0.5, 0.75, 1]` of max value.                             | N/A                                    |
| FIFO_12 | Check `!(intf.underflow === 1 && intf.overflow === 1)`.                                                | N/A                                                                                                          | N/A                                                                                      | Assertion labeled `p2`.               |
| FIFO_13 | Check `!(intf.full === 1 && intf.empty === 1)`.                                                        | N/A                                                                                                          | N/A                                                                                      | Assertion labeled `p2`.               |

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->



## 2-Verification Environment Overview

Our FIFO verification environment follows a layered architecture and consists of the following components:

# FIFO Test Bench Functionality Summary 📝

<summary> 1. **Testbench Overview**</summary> <details>
  ## 1. **Testbench Overview**
The testbench orchestrates the test and connects all the components in the environment. It generates various stimulus sequences, handles interactions between drivers and monitors, and checks the functional correctness of the DUT (Device Under Test) through a golden model comparison.

 ## Key Functions

### 1. **Clock Signal Generation ⏰**
- Generates a clock signal (`clk`) that toggles every 10 time units to synchronize the operations of the FIFO.

### 2. **FIFO Model and Pointer Initialization 🛠️**
- Defines golden model FIFO memory and pointers, including:
  - **Memory**: Stores FIFO data for comparison.
  - **Write Pointer**: Tracks the position for writing data.
  - **Read Pointer**: Tracks the position for reading data.
  - **Count**: Indicates the number of elements currently in the FIFO.

### 3. **DUT Instantiation**
- Instantiates the Design Under Test (DUT) FIFO module and connects it to the test bench.

### 4. **Test Class Initialization 📚**
- Creates an instance of the test class that encapsulates the testing logic and scenarios.

### 5. **Simulation Setup and Execution 🚀**
- Sets up the simulation environment and runs the test using a fork-join construct, which allows simultaneous operations for dynamic updates.

### 6. **Dynamic Data Assignment 🔄**
- Continuously updates golden model values and DUT outputs during simulation:
  - Copies data from the test environment to the golden model.
  - Ensures synchronization between the golden model and DUT's current state.

### 7. **Waveform Dumping 📊**
- Dumps simulation waveforms to a VCD file for analysis and debugging, allowing users to visualize the signal behavior over time.

  
</details>






2. **Driver:** The driver sends transactions to the DUT by converting higher-level sequences into low-level signals. It initiates read and write operations on the FIFO and controls the enable signals (`wr_en`, `rd_en`) based on stimulus generation.

3. **Monitor:** The monitor passively observes the DUT's output. It captures the behavior of signals such as `data_out`, `wr_ack`, `overflow`, `underflow`, `full`, `empty`, `almostfull`, and `almostempty`. The monitor checks whether these signals behave according to the expected protocol.

4. **Scoreboard:** The scoreboard compares the expected results against the actual output from the DUT. It verifies the functionality by checking the DUT's output against a reference or golden model.

5. **Transaction:** A transaction represents a single unit of operation that includes write or read requests sent to the FIFO. It contains relevant data and control information, such as `data_in`, `wr_en`, `rd_en`, and the expected results for read or write operations.

6. **Environment (Env):** The environment integrates all components, such as the driver, monitor, and scoreboard. It handles stimulus generation, manages response checking, and ensures that the functional coverage is achieved.

7. **Stimulus Generation:** Stimulus sequences are used to drive the FIFO through various test scenarios. Constraints are applied on signals like `wr_en`, `rd_en`, `rst`, and `clk` to ensure that the FIFO is exercised under a range of conditions.

8. **Test:** The test defines specific scenarios to verify the DUT's behavior under different conditions, such as boundary cases (full/empty states), overflow/underflow conditions, and normal operational scenarios. Tests check for correct functionality and ensure that edge cases are handled gracefully.

## FIFO Transaction Package (`FIFO_transaction_pkg`)

The `FIFO_transaction_pkg` package defines a transaction class that models the behavior of individual FIFO operations (read/write transactions). The transaction class incorporates randomization to test the FIFO under various conditions.

### Key Components of `FIFO_transaction_pkg`:

- **Parameters:**
  - `FIFO_WIDTH`: Defines the width (number of bits) of each data element (default 16 bits).
  - `FIFO_DEPTH`: Defines the FIFO's depth, i.e., the number of elements it can store (default 8 elements).

- **Randomized Fields:**
  - `data_in`: Represents the input data to the FIFO, randomized to generate diverse scenarios.
  - `wr_en`: Write enable signal, randomized to control the write operation.
  - `rd_en`: Read enable signal, randomized to control the read operation.
  - `rst_n`: Reset signal, randomly asserted to check the proper reset behavior.

- **Constraints:**
  The following constraints control the randomization of key signals:
  - `rst_n` is distributed such that it is high (`1`) 90% of the time and low (`0`) 10% of the time.
  - `wr_en` and `rd_en` are controlled by the distribution values `WR_EN_ON_DIST` and `RD_EN_ON_DIST`, which represent the likelihood of write and read operations being enabled.

## Functional Coverage

The coverage analysis is a key component of the verification environment, ensuring that all critical functional scenarios and corner cases of the FIFO design are sufficiently verified. The coverage is captured in multiple categories, as outlined in the `coverage_pkg` package.

### Key Components of `coverage_pkg`:

The `coverage_pkg` defines several coverage groups to capture the most critical scenarios related to FIFO operation. These groups are designed to monitor the behavior of control signals such as write/read enables, full/empty status, and data input ranges.

#### Coverage Groups:

1. **Write Enable, Full, and Almost Full Coverage (`wr_full_coverage`):**
   This group tracks how the write enable (`wr_en`) signal interacts with the `full` and `almostfull` status signals. It also tracks the cross-coverage between these signals to ensure full exploration of edge cases.

   - `wr_en_cp`: Coverage point for the write enable signal.
   - `full_cp`: Coverage point for the `full` signal.
   - `almost_full_cp`: Coverage point for the `almostfull` signal.

   **Cross Coverage:** Crosses `wr_en_cp`, `full_cp`, and `almost_full_cp`, ensuring that combinations like writing to a full FIFO are handled.

2. **Read Enable, Empty, and Almost Empty Coverage (`rd_empty_coverage`):**
   This group tracks the interaction between the read enable (`rd_en`) signal and the `empty` and `almostempty` status signals. It ensures proper behavior when the FIFO is nearly or completely empty.

   - `rd_en_cp`: Coverage point for the read enable signal.
   - `empty_cp`: Coverage point for the `empty` signal.
   - `almost_empty_cp`: Coverage point for the `almostempty` signal.

   **Cross Coverage:** Crosses `rd_en_cp`, `empty_cp`, and `almost_empty_cp`, covering situations like attempting to read from an empty FIFO.

3. **Read/Write Enable Cross Coverage (`rd_wr_enable_cross_coverage`):**
   This group captures the cross-coverage between read enable (`rd_en`) and write enable (`wr_en`) signals to explore how these signals interact under different operational conditions.

4. **Data Input Range Coverage (`data_input_range_coverage`):**
   This group captures the range of values for the data input (`data_in`) signal, ensuring that all potential input ranges are tested.

   - **Data Range Bins:** 
     - `low`: Values from 0 to 16383.
     - `lower_mid`: Values from 16384 to 32767.
     - `upper_mid`: Values from 32768 to 49151.
     - `high`: Values from 49152 to 65535.

5. **Reset Signal Coverage (`reset_coverage`):**
   Tracks the occurrences of the reset signal (`rst_n`) to ensure proper behavior when the system is reset.







### Bugs Found:

During the course of verification, the following bugs were identified and fixed:

1. **Write Acknowledgment Not Resetting (`wr_ack`)**:
   - Issue: The `wr_ack` signal was not being reset properly after write operations, causing incorrect handshaking behavior.
   - Fix: Ensured that `intf.wr_ack <= 0;` was explicitly reset after write transactions.

2. **Overflow Signal Not Resetting (`overflow`)**:
   - Issue: The `overflow` signal was not being reset after handling an overflow condition, leading to incorrect overflow detection in subsequent cycles.
   - Fix: Modified the design to explicitly reset `intf.overflow <= 0;` after handling an overflow.

3. **Read Pointer and Write Pointer Logic Issue**:
   - Issue: There was a logic error where the design did not properly check the condition `rd_ptr != wr_ptr` before allowing certain operations, which led to erroneous data reads/writes when pointers were equal.
   - Fix: Incorporated a check to ensure that `rd_ptr != wr_ptr` before proceeding with read/write operations to avoid erroneous FIFO operations.

These bugs were discovered through the use of constrained random testing and functional coverage, demonstrating the importance of coverage-driven verification in finding corner cases and subtle design issues.

## Functional and Random Testing

Functional coverage and randomization work together to ensure that all critical scenarios are tested. The combination of constrained random stimulus generation from `FIFO_transaction_pkg` and comprehensive coverage analysis from `coverage_pkg` provides robust verification of the FIFO's functionality.
