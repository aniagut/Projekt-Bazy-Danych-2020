import random
def gen():
    for i in range (1,66):
        for j in range (5):
            print('INSERT INTO [Contains] (CourseID,IngredientID) VALUES ('+str(i)+','+str(random.randint(1,1000))+')')
gen()