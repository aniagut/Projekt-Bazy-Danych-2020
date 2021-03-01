import random
def gen():
    f=open("plik.txt","a")
    for i in range (200000):
        f.write('INSERT INTO MenuDetails (MenuID,CourseID,CategoryID,UnitPrice) VALUES ('+str(random.randint(1,17038))+
                ','+str(random.randint(1,65))+','+str(random.randint(1,11))+','+str(random.randint(3,99))+'.'+str(random.randint(0,9))+
                str(random.randint(0,9))+')\n')
    f.close()
gen()