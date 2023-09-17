/*
Profit and Loss daily email statement.

Note these Cursors have been designed to run after the 'Profit Function' has inserted all data into profit and loss tables.

Email to be sent daily via a scheduled job. 

*/

DECLARE
    CURSOR profit_cursor IS
    SELECT item_name, profit_amount, transaction_date FROM profit_log
    WHERE TRUNC(transaction_date) = TRUNC(SYSDATE); -- Filter records for today

    CURSOR loss_cursor IS
    SELECT item_name, loss_amount, transaction_date FROM loss_log
    WHERE TRUNC(transaction_date) = TRUNC(SYSDATE); -- Filter records for today

    v_email_subject VARCHAR2(255);
    v_email_body VARCHAR2(4000);
    v_item_name VARCHAR2(255);
    v_amount NUMBER;
    v_date DATE;
BEGIN
    -- Set the email subject with the current date
    v_email_subject := 'Profit and Loss Summary for ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD');

    -- Initialize the email body
    v_email_body := 'The profit sales from ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' are:' || CHR(10) || CHR(10);

    -- Loop through profit_log records
    FOR profit_rec IN profit_cursor LOOP
        v_item_name := profit_rec.item_name;
        v_amount := profit_rec.profit_amount;
        
        -- Append profit data to the email body
        v_email_body := v_email_body || 'Item: ' || v_item_name || CHR(10);
        v_email_body := v_email_body || 'Profit Amount: £' || TO_CHAR(v_amount, '9990.99') || CHR(10);
        v_email_body := v_email_body || '----------------------------------------' || CHR(10);
    END LOOP;

    -- Add a couple of line breaks for readbility
    v_email_body := v_email_body || CHR(10) || CHR(10);

    -- Append losses section to the email body
    v_email_body := v_email_body || 'The losses from ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' are:' || CHR(10) || CHR(10);

    -- Loop through loss_log records
    FOR loss_rec IN loss_cursor LOOP
        v_item_name := loss_rec.item_name;
        v_amount := loss_rec.loss_amount;

        -- Append loss data to the email body
        v_email_body := v_email_body || 'Item: ' || v_item_name || CHR(10);
        v_email_body := v_email_body || 'Loss Amount: £' || TO_CHAR(v_amount, '9990.99') || CHR(10);
        v_email_body := v_email_body || '----------------------------------------' || CHR(10);
    END LOOP;

    -- Send the email
    UTL_MAIL.send(sender => 'steve@insertname.com',
                  recipients => 'anyone@insertname.com',
                  subject => v_email_subject,
                  message => v_email_body);
END;
/
