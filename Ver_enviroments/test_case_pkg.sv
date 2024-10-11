package test_passed_pkg;

    // Variables to track the number of passed test cases and total test cases
    static int passed_test_count = 0;   // Number of passed test cases
    static int failed_test_count=0;

    // Task to increment the passed test count
    task increment_passed();
        passed_test_count++;
    endtask

    task increment_failed();
        failed_test_count++;

    endtask



    // Task to display the test case results
    task display_test_results();
        $display("==========================================");
        $display("Test Results: Passed = %0d, Failed = %0d", passed_test_count, failed_test_count);
        $display("==========================================");
    endtask

endpackage : test_passed_pkg