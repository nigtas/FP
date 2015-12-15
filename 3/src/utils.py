import random
import string
from collections import defaultdict
from pymonad.Maybe import *

def random_char(y):
	return ''.join(random.choice(string.ascii_letters) for x in range(y))

def predefinedMove(protocol, idx):
	moves = {
		'json+list': [
			'[{"x": 1, "y": 2, "v": "x"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}, {"x": 0, "y": 1, "v": "x"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}, {"x": 0, "y": 1, "v": "x"}, {"x": 0, "y": 2, "v": "o"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}, {"x": 0, "y": 1, "v": "x"}, {"x": 0, "y": 2, "v": "o"}, {"x": 2, "y": 1, "v": "x"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}, {"x": 0, "y": 1, "v": "x"}, {"x": 0, "y": 2, "v": "o"}, {"x": 2, "y": 1, "v": "x"}, {"x": 0, "y": 0, "v": "o"}]',
			'[{"x": 1, "y": 2, "v": "x"}, {"x": 1, "y": 1, "v": "o"}, {"x": 2, "y": 2, "v": "x"}, {"x": 1, "y": 0, "v": "o"}, {"x": 0, "y": 1, "v": "x"}, {"x": 0, "y": 2, "v": "o"}, {"x": 2, "y": 1, "v": "x"}, {"x": 0, "y": 0, "v": "o"}, {"x": 2, "y": 0, "v": "x"}]'
		]
	}

	if protocol in moves.keys():
		return Just(moves[protocol][idx])
	else:
		return Nothing