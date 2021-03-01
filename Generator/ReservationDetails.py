import random
def LoadList(filename):
    num = []
    num_list = open(filename, 'r')
    for line in num_list:
        num.append(line.strip())
    num_list.close();
    return num
names=LoadList("NamesFirst.txt")
last=LoadList("NamesLast.txt")
def genname():
    return names[random.randint(0,len(names)-1)]
def genlast():
    return last[random.randint(0,len(last)-1)]
def genpres():
    i=random.randint(1,100)
    if i<=90:
        return 'Y'
    else:
        return 'N'
def gen():
    f=open("plik.txt","a")
    for i in range(130000):
        f.write('INSERT INTO ReservationDetails (ReservationID,Name,Surname,Presence,GuestID) VALUES ('
                +str(random.randint(1,30000))+',\''+genname()+'\',\''+genlast()+'\',\''+genpres()+'\','+str(i)+')\n')
    f.close()
gen()