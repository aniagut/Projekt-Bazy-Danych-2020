import random
def gen():
    j=1
    for i in range (1,51):
        for k in range(25):
            print('INSERT INTO Tables (TableID,CompanyID,NumberOfChairs) VALUES('+str(j)+','+str(i)+','+str(random.randint(2,6))+')')
            j+=1

gen()