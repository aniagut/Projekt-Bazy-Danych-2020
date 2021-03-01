import random
def gen():
    f=open("sss.txt","a")
    for i in range (20001,40001):
        f.write('INSERT INTO OrderedTables (OrderID,IntervalID,TableID,OccupiedChairs) VALUES('+str(i)+
                ',(SELECT IntervalID FROM Intervals WHERE CompanyID=(SELECT CompanyID FROM Orders WHERE OrderID='+str(i)+
                ') AND (SELECT OrderDate FROM Orders WHERE OrderID='+str(i)+') BETWEEN BeginningDate AND EndDate),(SELECT TOP 1 TableID FROM'
                ' IntervalDetails WHERE IntervalID=(SELECT TOP 1 IntervalID FROM Intervals '
                'WHERE CompanyID=(SELECT CompanyID FROM Orders WHERE OrderID='+str(i)+'))),'+str(random.randint(1,6))+')\n')
    f.close()
gen()