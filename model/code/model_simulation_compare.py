#%%
import glob
import numpy as np 
import matplotlib.pyplot as plt
import pandas as pd
from scipy.optimize import curve_fit

# filename = 'simu55rpm442mT.txt'


# #Open all relevant csv files at once 
# df = pd.read_csv(filename, delimiter='          ')
# df.to_csv(f'{filename[:-4]}v2.csv', sep=';', index=False)
#%%
# Retrieves all measurements of Pohl pendulum

# omega angles are in degrees. All angles in degrees
pohllist = []
pohltitle= []
for file in glob.glob("Pohl*.txt"):
    pohltitle.append(file)
    df = pd.read_csv(file,delimiter=';', decimal=',',header=1)
    angles_rad = np.deg2rad(df['ω'])
    df = pd.concat([df,angles_rad], axis=1)
    df.columns =['t', 'x','y','θ','ω','α','NaNs','ω(rad)']
    pohllist.append(df)

#%%
# Retrieves all measurements of simulations
simulist = []
simutitle = []
for file in glob.glob("simu*.csv"):
    print(file)
    simutitle.append(file)
    df = pd.read_csv(file,delimiter=';')
    # convert rad to deg
    angles_deg = np.rad2deg(df['Angular Velocity (rad/s)'])
    df2 = pd.concat([df,angles_deg], axis=1)
    df2.columns = ['time(s)', 'ang_vel(rad/s)','ang_vel(deg/s)']
    
    simulist.append(df2)

#%% model part 1: 720s model results
results720=[0,9,16,17,18,19]
slice_start = 0
slice_end = 10000

for i in results720:
    plt.plot(
        simulist[i]['time(s)'][slice_start:slice_end],
        simulist[i]['ang_vel(rad/s)'][slice_start:slice_end],
        label=f'{simutitle[i][9:-10]}'
    )

plt.xlabel('time t[s]')
plt.ylabel('angular velocity ω [rad/s]')
plt.grid()
plt.legend(prop={'size':8})
plt.savefig('results720.pdf', dpi=300)

# model part 2: 180s results

#%% model part 1: 720s model results
results720=[1,2,3,4,5,6,7,8,10,11,12,13,14,15]
slice_start = 0
slice_end = 10000

for i in results720:
    plt.plot(
        simulist[i]['time(s)'][slice_start:slice_end],
        simulist[i]['ang_vel(rad/s)'][slice_start:slice_end],
        label=f'{simutitle[i][9:-6]}'
    )

plt.xlabel('time t[s]')
plt.ylabel('angular velocity ω [rad/s]')
plt.grid()
plt.legend(
    prop={'size':8}, 
    ncol=3
    )

plt.savefig('results180.pdf', dpi=300)







#%%

# pohl & simulation comparison. 
# plot pohl data
slice_start = 145
slice_end = 10000


slice_startlist=[189,147]

N = 9
print(pohltitle[N])
# time adjusted according to slice start time
plt.plot(
    pohllist[N]['t'][slice_start:slice_end] - pohllist[N]['t'][slice_start] ,
    pohllist[N]['ω(rad)'][slice_start:slice_end],
    label=f'measurement:1,0 A '
)
#plot simu data
M = -1
slice_start = 0
slice_end = 25
plt.plot(
    simulist[M]['time(s)'][slice_start:slice_end],
    simulist[M]['ang_vel(rad/s)'][slice_start:slice_end],
    label=f'simulation: 1,0 A (97mT) '
)

plt.xlabel('Time t[s]')
plt.ylabel('Angular velocity ω [rad/s]')
plt.grid()
plt.legend()
plt.savefig('pohlvssim.pdf', dpi=300)




# %%
