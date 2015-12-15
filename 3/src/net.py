#!/usr/bin/env python
import requests
from pymonad.Maybe import *

import utils

def run(id):

    def next(req):
        return {post: get, get: post}[req]

    def runImpl(idx, req):
        if idx == 9: return Nothing
        status = req(id, 2, 'json+list', utils.predefinedMove('json+list', idx).value)
        if status == 200:
            if req == post:
                runImpl(idx+2, next(req))
            else:
                runImpl(idx, next(req))
        else:
            runImpl(idx, req)

    runImpl(1, get)


def makeUrl(id, player):
    return "http://tictactoe.homedir.eu/game/" + id + "/player/" + str(player)

def post(id, player, protocol, payload):
    r = requests.post(makeUrl(id, player), headers = {'Content-Type': 'application/'+ protocol}, data = payload)
    if r.status_code == 200:
    	print('<< |', id, player, protocol)
    return r.status_code

def get(id, player, protocol, payload):
    r = requests.get(makeUrl(id, player), headers = {'Accept': 'application/'+ protocol})
    if r.status_code == 200:
    	print('>> |', id, player, protocol)
    return r.status_code