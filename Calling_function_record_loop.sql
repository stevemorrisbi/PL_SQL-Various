/*

Calling the Profit function and looping through it with records

*/


DECLARE
    TYPE profit_data_type IS RECORD (
        purchase_price NUMBER,
        sold_price NUMBER,
        item VARCHAR2(255),
        sponsorship NUMBER
    );

    TYPE profit_data_collection IS TABLE OF profit_data_type;
    
    -- Define a collection to hold your data with 3 rows
    -- variable v_data is of type profit_data_collection, it's ready to hold instances (rows) of the profit_data_type 
    v_data profit_data_collection := profit_data_collection();
BEGIN
    -- Populate the collection with 3 rows of data
    v_data.EXTEND(3);
    v_data(1) := profit_data_type(100.00, 150.00, 'Item1', 0.15);
    v_data(2) := profit_data_type(200.00, 250.00, 'Item2', 0.10);
    v_data(3) := profit_data_type(300.00, 350.00, 'Item3', 0.20);
    
    -- Iterate through the collection and call the function (.count method iterates through each row)
    FOR i IN 1..v_data.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(ProfitCalculator(v_data(i).purchase_price, v_data(i).sold_price, v_data(i).item, v_data(i).sponsorship));
    END LOOP;
END;
/
