import random
l1 = ["Re","Ad","Par","Tru","Thru","In","Bar","Cip","Dop","End","Em","Fro","Gro","Hap","Kli","Lom","Mon","Qwi","Rap","Sup","Sur","Tip","Tup","Un","Up","Var","Win","Zee"]
l2 = ["ban","cad","dud","dim","er","frop","glib","hup","jub","kil","mun","nip","peb","pick","quest","rob","sap","sip","tan","tin","tum","ven","wer","werp","zap"]
l3 = ["il","ic","im","in","up","ad","ack","am","on","ep","ed","ef","eg","aqu","ef","edg","op","oll","omm","ew","an","ex","pl"]
l4 = ["icator","or","ar","ax","an","ex","istor","entor","antor","in","over","ower","azz"]
l5 = ["Pro","Duplex","Multi"]
l6 = ["Direct","WorldWide","Holdings","International"]
l7 = ["Inc","Company","Group","Corp."]

l = []

for i in range(1000):
    comapnyName =""
    comapnyName += random.choice(l1) + random.choice(l2) + random.choice(l3)

    if random.randint(0,1) == 1:
        comapnyName += random.choice(l4)

    if random.randint(0,1) == 1:
        if random.randint(0, 1) == 1:
            comapnyName += "-"
        else:
            comapnyName += " "
        comapnyName += random.choice(l5)

    if random.randint(0,1) == 1:
        comapnyName += " "
        comapnyName += random.choice(l6)

    if random.randint(0,1) == 1:
        comapnyName += " "
        comapnyName += random.choice(l7)
    l.append(comapnyName)


with open('CompanyNames.txt', 'w') as f:
    for item in l:
        f.write("%s\n" % item)