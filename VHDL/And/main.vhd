ENTITY c_and IS PORT(a, b : IN BIT; y : OUT BIT);
END c_and;

ARCHITECTURE ckt OF c_and IS
BEGIN
    y <= a AND b;
END ckt