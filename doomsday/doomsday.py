#!/usr/bin/env python3

import sys
import fileinput
import os
from collections import deque

class Dev:
    def __init__(self, myqueue, myarr, flag, N, M, ans):
        self.myqueue = myqueue
        self.myarr = myarr
        self.flag = flag
        self.N = N
        self.M = M
        self.ans = ans

class Info: 
    def __init__(self, s, xi, yi, ti):
        self.sign = s
        self.x = xi
        self.y = yi
        self.time = ti

def check(inf, dev):
    if inf.sign == '+':
        nots = '-'
    else:
        nots = '+'
    if inf.x < dev.N and inf.y < dev.M:
        if inf.time > dev.ans and dev.ans != 0:
            return 1, dev

        if inf.x-1 >= 0 and dev.myarr[inf.x-1][inf.y] == nots:
            dev.myarr[inf.x-1][inf.y] = '*'
            dev.flag[inf.x-1][inf.y] = 1
            dev.flag[inf.x][inf.y] = 1
            dev.ans = inf.time
        if  inf.x+1 < dev.N and dev.myarr[inf.x+1][inf.y] == nots:
            dev.myarr[inf.x+1][inf.y] = '*'
            dev.flag[inf.x+1][inf.y] = 1
            dev.flag[inf.x][inf.y] = 1
            dev.ans = inf.time
        if  inf.y-1 >= 0 and dev.myarr[inf.x][inf.y - 1] == nots:
            dev.myarr[inf.x][inf.y - 1] = '*'
            dev.flag[inf.x][inf.y - 1] = 1
            dev.flag[inf.x][inf.y] = 1
            dev.ans = inf.time
        if  inf.y+1 < dev.M and dev.myarr[inf.x][inf.y+1] == nots:
            dev.myarr[inf.x][inf.y+1] = '*'
            dev.flag[inf.x][inf.y+1] = 1
            dev.flag[inf.x][inf.y] = 1
            dev.ans = inf.time

        if  inf.x-1 >= 0 and dev.myarr[inf.x-1][inf.y] == '.':
            dev.myarr[inf.x-1][inf.y] = inf.sign
            dev.flag[inf.x-1][inf.y] = 1
            newInf = Info(inf.sign, inf.x-1, inf.y, inf.time+1)
            dev.myqueue.append(newInf)
        if  inf.x+1 < dev.N and dev.myarr[inf.x + 1][inf.y] == '.':
            dev.myarr[inf.x+1][inf.y] = inf.sign
            dev.flag[inf.x + 1][inf.y] = 1
            newInf = Info(inf.sign, inf.x+1, inf.y, inf.time+1)
            dev.myqueue.append(newInf)
        if inf.y-1 >= 0 and dev.myarr[inf.x][inf.y - 1] == '.':
            dev.myarr[inf.x][inf.y-1] = inf.sign
            dev.flag[inf.x][inf.y-1] = 1
            newInf = Info(inf.sign, inf.x, inf.y-1, inf.time+1)
            dev.myqueue.append(newInf)
        if inf.y+1 < dev.M and dev.myarr[inf.x][inf.y+1] == '.':
            dev.myarr[inf.x][inf.y+1] = inf.sign
            dev.flag[inf.x][inf.y+1] = 1
            newInf = Info(inf.sign, inf.x, inf.y+1, inf.time+1)
            dev.myqueue.append(newInf)
    return 0, dev

def solve(f):
    myqueue = deque([])
    myarr = []
    flag = []
    N = 0
    ans = 0
    list=[]
    list = f.readline()
    M = len(list[:-1])
    i = 0
    while len(list)!=0:
        i = i+1
        myarr.insert(i,[list[j] for j in range(M)])
        list = f.readline()
    N = i
    #print(myarr)
    flag = [[0 for i in range(M+1)] for j in range(N)]
    for k in range(N):
        for j in range(M):
            if(myarr[k][j] == '+' or myarr[k][j] == '-'):
                newInf = Info(myarr[k][j], k, j, 0) 
                myqueue.append(newInf)

    dev = Dev(myqueue, myarr, flag, N, M, ans)  
    while dev.myqueue:
        info = dev.myqueue.popleft()
        ch, dev = check(info, dev)
        if(ch==1):
            break
    if(dev.ans != 0):
        print(dev.ans+1)
    else:
        print('the world is saved')
    #file = open("test.txt", "w")
    for i in range(N):
        for j in range(M):
            #file.write(myarr[i][j])
            sys.stdout.write(myarr[i][j])   
        #file.write("\n")
        sys.stdout.write('\n')
    sys.stdout.write('\n')
    return -1

if __name__ == "__main__":
    if len(sys.argv)>1:
        with open(sys.argv[1], "rt") as f:
            solve(f)
    else:
        solve(sys.stdin)


