import random
def LoadList(filename):
    num = []
    num_list = open(filename, 'r')
    for line in num_list:
        num.append(line.strip())
    num_list.close();
    return num
def nipgenerator():
    nip=[]
    for i in range (1000):
        while True:
            nip1 = ''
            for i in range (10):
                nip1+=str(random.randint(1,9))
            if not nip.__contains__(nip1):
                nip.append(nip1)
                break
    return nip
def faxgenerator():
    fax=[]
    for i  in range (1000):
        fax1=''
        for i in range (4):
            fax1+=str(random.randint(0,9))
        fax1+='-'
        for i in range (2):
            fax1 += str(random.randint(0, 9))
        fax1 += '-'
        for i in range(7):
            fax1 += str(random.randint(0, 9))
        fax.append(fax1)
    return fax
nums = LoadList("txt.txt")
for i in range (len(nums)):
    nums[i]=int(nums[i])
companies=LoadList("CompanyNames.txt")
def generate(nums,companies,niplist,faxlist):
    j=0
    for i in range (1,2001):
        if not nums.__contains__(i):
            if random.randint(0,10)<=5:
                print('INSERT INTO BusinessCustomers (CustomerID, CompanyName, NIP, Fax) VALUES ('+str(i)+',\''
                      +companies[j]+'\',\''+niplist[j]+'\','+'NULL)')
            else:
                print('INSERT INTO BusinessCustomers (CustomerID, CompanyName, NIP, Fax) VALUES (' + str(i) + ',\''
                      +companies[j] + '\',\'' + niplist[j] + '\',\''+faxlist[j]+'\')')
            j+=1
niplist=nipgenerator()
print(nums)
faxlist=faxgenerator()
generate(nums,companies,niplist,faxlist)