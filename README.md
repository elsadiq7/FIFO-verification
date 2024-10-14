# FIFO Test Environment and Test Cases

This repository contains the test environment and test cases designed for verifying the FIFO (First-In-First-Out) memory behavior. The environment includes a well-structured **testbench**, with components such as **drivers**, **monitors**, and **scoreboards** that facilitate a comprehensive verification flow. Below is a high-level description of the verification environment, including coverage, random testing, and the corresponding test cases.

<details>
  <summary>1- FIFO Test plan</summary>
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
  
</details>




<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

<details>
    <summary>2-Verification Environment Overview</summary>

Our FIFO verification environment follows a layered architecture and consists of the following components:
- **Test Bench Functionality Summary**
    - The testbench orchestrates the test and connects all components in the environment, generating stimulus sequences, handling driver and monitor interactions, and verifying the DUT (Device Under Test) through golden model comparison
 
- **FIFO Transaction**
   - The `FIFO_transaction_pkg` package defines a transaction class that models the behavior of individual FIFO operations (read/write transactions). The transaction class incorporates randomization to test the FIFO under various conditions.

- **Functional Coverage**
  -  The coverage analysis is a key component of the verification environment, ensuring that all critical functional scenarios and corner cases of the FIFO design are sufficiently verified. The coverage is captured in multiple categories, as outlined in the `coverage_pkg` package [coverage report](https://github.com/elsadiq7/FIFO-verification/blob/main/Ver_enviroments/sim.log).
      
- **Driver**
  - Sends transactions to the DUT by converting higher-level sequences into low-level signals, initiating read and write operations and controlling enable signals (`wr_en`, `rd_en`).
    
- **Monitor**
  - Passively observes DUT output, capturing signals such as `data_out`, `wr_ack`, `overflow`, etc., and checks expected behavior.

- **Scoreboard**
  - Compares expected results against actual DUT output, verifying functionality through reference model checks.

- **Transaction**
  - Represents a unit of operation, including write or read requests to the FIFO, with relevant data and control information.

- **Environment (Env)**
  - Integrates all components (driver, monitor, scoreboard), handles stimulus generation, manages response checking, and ensures functional coverage.

- **Stimulus Generation**
  - Drives the FIFO through various test scenarios, applying constraints on signals like `wr_en`, `rd_en`, etc.

- **Test**
  - Defines scenarios to verify DUT behavior under different conditions, including boundary cases, overflow/underflow conditions, and normal operations.
<details>
<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

  <summary>3- Bugs Found</summary>
During the course of verification, the following bugs were identified and fixed:
1. **Write Acknowledgment Not Resetting (`wr_ack`)**:
   - Issue: The `wr_ack` signal was not being reset properly after write operations, causing incorrect handshaking behavior.
   - Fix: Ensured that `intf.wr_ack <= 0;` was explicitly reset after write transactions.

2. **Overflow Signal Not Resetting (`overflow`)**:
   - Issue: The `overflow` signal was not being reset after handling an overflow condition, leading to incorrect overflow detection in subsequent cycles.
   - Fix: Modified the design to explicitly reset `intf.overflow <= 0;` when reseting handling an overflow.

3. **Read Pointer and Write Pointer Logic Issue**:
   - Issue: There was a logic error where the design did not properly check the condition `rd_ptr != wr_ptr` before allowing certain operations, which led to erroneous data reads/writes when pointers were equal.
   - Fix: Incorporated a check to ensure that `rd_ptr != wr_ptr` before proceeding with read/write operations to avoid erroneous FIFO operations.

These bugs were discovered through the use of constrained random testing and functional coverage, demonstrating the importance of coverage-driven verification in finding corner cases and subtle design issues.
</details>

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------->


