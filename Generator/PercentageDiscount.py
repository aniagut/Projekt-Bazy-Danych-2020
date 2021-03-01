import random
def gen():
    for i in range (5000):
        j=random.randint(1,200000)
        print('UPDATE Orders SET PercentageDiscount='+str(round(random.uniform(0.01,0.2),2))+' WHERE OrderID='+str(j))
gen()