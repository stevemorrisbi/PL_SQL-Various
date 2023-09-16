/*
Creating a function in PL/SQL to calculate profit and loss eccomerce item sales.

*/

CREATE OR REPLACE FUNCTION ProfitCalculator(
    purchase_price NUMBER,
    sold_price NUMBER,
    item VARCHAR2,
    sponsorship NUMBER DEFAULT 0
) RETURN VARCHAR2
IS
    sold_post NUMBER := sold_price + 1.50;
    selling_fee NUMBER := sold_post * 0.125;
    minus_ad NUMBER;
    pounds NUMBER;
    profit_format VARCHAR2(100);
BEGIN
    -- Input validation
    IF purchase_price < 0 OR sold_price < 0 OR sponsorship < 0 OR sponsorship > 1 THEN
        RETURN 'Invalid input values. Purchase price, sold price, and sponsorship must not be negative. Sponsorship must be between 0 and 1. (e.g 0.15 = 15%)';
    END IF;

    IF sponsorship = 0 THEN
        minus_ad := sold_price - selling_fee;
    ELSE
        minus_ad := (sold_price - selling_fee) - (sold_post * sponsorship);   
    END IF;
    -- note selling fee and sposorship are sepereate. Some sales don't have a sponsorship fee hence default 0.

    pounds := minus_ad - purchase_price;

    IF pounds < 0 THEN
    -- Log the loss into the loss_log table
        INSERT INTO loss_log(item_name, loss_amount, transaction_date)
        VALUES (item, ABS(pounds), SYSDATE);
        
        -- Display a message for items that made a loss
        DBMS_OUTPUT.PUT_LINE('The ' || item || ' did not make any profit. It made a loss of £' || TO_CHAR(ABS(pounds), '9990.99'));
    ELSE
        -- Log the profit into the profit_log table
        INSERT INTO profit_log(item_name, profit_amount, transaction_date)
        VALUES (item, pounds, SYSDATE);

        -- Display a message for items that made a profit
        profit_format := 'The total profit for ' || item || ' is £' || TO_CHAR(pounds, '9990.99');
        DBMS_OUTPUT.PUT_LINE(profit_format);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN 'An error occurred';
END ProfitCalculator;
/
