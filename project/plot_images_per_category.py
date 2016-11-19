import os
import matplotlib.pyplot as plt

directory = './Images/train'

count_files_dir = dict()

for dirs in os.listdir(directory):
    if not os.path.isdir(os.path.join(directory, dirs)):
        continue
    #cdir = os.path.join(directory, dirs)
    count = len([file for file in os.listdir(os.path.join(directory, dirs))
        if os.path.isfile(os.path.join(directory, dirs, file))])
    count_files_dir[dirs] = count

plt.bar(range(len(count_files_dir)), count_files_dir.values(), align='center')
plt.xticks(range(len(count_files_dir)), count_files_dir.keys(), rotation=45)
plt.show()