import random
def gen():
    f=open("ccc.txt","a")
    for s in range (50):
        for i in range(s*90+1,(s+1)*90+1):
            for j in range(s*25+1,(s+1)*25+1):
                f.write('INSERT INTO IntervalDetails (TableID,IntervalID,AvailableChairs) VALUES ('+
                        str(j)+','+str(i)+','+str(random.randint(0,6))+')\n')
    f.close()
gen()