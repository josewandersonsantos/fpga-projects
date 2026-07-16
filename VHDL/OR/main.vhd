ENTITY c_or IS PORT(a, b : IN BIT; y : OUT BIT);
END c_or;

ARCHITECTURE ckt OF c_or IS
BEGIN
    y <= a OR b;
END ckt;