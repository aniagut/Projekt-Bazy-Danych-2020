import random
import datetime
def LoadList(filename):
    num = []
    num_list = open(filename, 'r')
    for line in num_list:
        num.append(line.strip())
    num_list.close();
    return num
def gen():
    nums = LoadList("txt.txt")
    for i in range(len(nums)):
        nums[i] = int(nums[i])
    for i in range(3000):
        i=random.randint(1,3000)
        if(nums.__contains__(i)):
            #klient indywidualny
            start_date=datetime.date(2021,1,5)
            random_date=start_date+datetime.timedelta(days=random.randint(1,8)+7)
            random_date1=start_date+datetime.timedelta(days=random.randint(1,8)+14)


            print('INSERT INTO CustomersDiscounts (CompanyID,CustomerID,OrdersWithK1,ValidTillR2,ValidTillR3,MonthsWithFK1,QuarterDiscount)'
                  ' VALUES('+str(random.randint(1,50))+','+str(i)+','+str(random.randint(1,15))+',\''+str(random_date.strftime('%Y/%m/%d'))+
                  '\',\''+str(random_date1.strftime('%Y/%m/%d'))+'\','+str(0)+','+str(0)+')')
        else:
            print('INSERT INTO CustomersDiscounts (CompanyID,CustomerID,OrdersWithK1,ValidTillR2,ValidTillR3,MonthsWithFK1,QuarterDiscount)'
                  ' VALUES('+str(random.randint(1,50))+','+str(i)+',0'+',NULL,NULL,'+str(random.randint(1,12))+','+str(random.randint(0,1000))+')')

gen()