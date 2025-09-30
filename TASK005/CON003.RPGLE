**free
//ctl-opt dftactgrp(*no) actgrp(*caller);
// This program demonstrates how to use a cursor with a parameter in SQLRPGLE.
// It fetches Customers records from the CLANA00F file based on a specific header code
// and displays the Customers ID and name. The cursor is opened, rows are fetched in a
// loop, and finally, the cursor is closed. Error handling is included to manage SQL errors
// that may occur during the fetch or close operations.
// The program uses free-form RPG syntax and SQL embedded in RPGLE.
// **********************************************************************
// CLANA00F is a file containing customer data.
// The file structure is defined in the comments above.
// **********************************************************************
// CLANA00F   Record format: CLANA
// COLUMN     | T |  POS. |  POS. | ---FIELD-- | DE |
// NAME       | Y |  FROM |    TO | BYTES | LN | CI |
//            |   |       |       |       |    |----|
// CLANN0     | A |     1 |     1 |     1 |    |    |
// CLCCL0     | S |     2 |     8 |     7 |  7 |    |
// CLCIB0     | A |     9 |    11 |     3 |    |    |
// CLNOM0     | A |    12 |    61 |    50 |    |    |
// CLSTS0     | A |    62 |    62 |     1 |    |    |
// **********************************************************************
// Call this program with a parameter to specify the customer code.
// Example: CALL PGM(CUR_X) PARM(('XXX'))
dcl-s CLCCL0 zoned(7);
dcl-s CLNOM0 varchar(50);
dcl-s CLNOM0_10 char(10);

// Declare input parameter
dcl-pi *n;
  CIBIntCode char(3);   // Input parameter: International code
end-pi;

// Declare cursor with parameter
exec sql declare empCur cursor for
    select CLCCL0, CLNOM0 from CLANA00F
    where CLCIB0 = :CIBIntCode;

// Open the cursor
exec sql open empCur;

// Fetch rows one by one
dow sqlCode = 0;
    exec sql fetch empCur into :CLCCL0, :CLNOM0;

    if sqlCode = 0;
        // Display Customers details
        CLNOM0_10 = %trim(CLNOM0) + '...'; // Truncate name for display
        dsply ('Customers Name: ' + CLNOM0_10);
        dsply ('Customers ID: ' + %char(CLCCL0));
    endif;
enddo;

// Close the cursor
exec sql close empCur;
// Handle SQL errors
if sqlCode < 0;
    dsply ('SQL Error: ' + %char(sqlCode));
else;
    dsply ('Cursor closed successfully.');
endif;
// End of program
// When using embedded SQL and you don't have any files declared
// in the D-spec or F-spec, you could omit *INLR = *ON,
// but it's good practice to include it for compatibility
// and clarity.
*inlr = *on;
return;
