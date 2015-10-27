module Parser
where

import Data.List.Extra

type InternalMap = [(String, String)]

message :: String
message = "[{\"x\": 0, \"y\": 2, \"v\": \"x\"}, {\"x\": 1, \"y\": 1, \"v\": \"o\"}, {\"x\": 1, \"y\": 0, \"v\": \"x\"}, {\"x\": 1, \"y\": 2, \"v\": \"o\"}, {\"x\": 2, \"y\": 2, \"v\": \"x\"}]"

n :: Int
n = 3

data Player = X | O deriving (Show, Read, Eq)
type Position = (Int, Int)

type Grid = [[Maybe Player]]

strToPlayer :: String -> Player
strToPlayer "x" = X
strToPlayer "X" = X
strToPlayer "o" = O
strToPlayer "O" = O
strToPlayer "0" = O

--parser

getMoves :: String -> InternalMap -> InternalMap
getMoves [] acc = acc
getMoves str acc =
    let 
        item = takeWhile (/= ',') str
        tuple = case (stripInfix ":" item) of
            Just (key, value) -> (key, value)
            Nothing -> error "Parser error."
        rest = drop (length item + 1) str
    in reverse $ getMoves rest (tuple : acc)


stripElem :: String -> String -> String -> String
stripElem str elemPre elemPost  = 
    case stripPrefix elemPre str of
        Just rest -> case stripSuffix elemPost rest of
            Just rest -> rest
            Nothing -> error "Strip error"
        Nothing -> error "Strip error"

getMapElem :: String -> Maybe (String, String)
getMapElem [] = Nothing
getMapElem str =
    let 
        key = takeWhile (/= '}') str ++ "}"
        rest = drop (length key + 2) str
    in Just (key, rest)

parseList :: String -> [String] -> [String]
parseList "" result = result
parseList str result =
	case getMapElem str of
	    Just (key, rest) -> parseList rest (key : result)
	    Nothing -> error "Error."

parseMap :: [String] -> [InternalMap] -> [InternalMap]
parseMap [] res = res
parseMap (x:xs) res =
    let
        striped = filter (/=' ') (filter (/= '"') (stripElem x "{" "}"))
        parsed = getMoves striped []
    in parseMap xs (parsed : res)


parseJson :: String -> [InternalMap]
parseJson str =
	let
		arrayInfo = stripElem str "[" "]"
		gameData = parseMap (parseList arrayInfo []) []
	in gameData

--parser

emptyGrid :: Grid
emptyGrid = replicate n $ replicate n Nothing

replaceNth :: Int -> Maybe Player -> [Maybe Player] -> [Maybe Player]
replaceNth n newVal (x:xs)
     | n == 0 = newVal:xs
     | otherwise = x:replaceNth (n-1) newVal xs

findParam :: InternalMap -> String -> String -> String
findParam map param errorMsg =
    case lookup param map of
        Just val -> val
        Nothing -> error errorMsg

fillTheGrid :: [InternalMap] -> [Maybe Player] -> Grid
fillTheGrid [] grid = chunksOf n grid
fillTheGrid (x:xs) grid =
    let
        pos1 = read (findParam x "x" "x not defined.") :: Int
        pos2 = read (findParam x "y" "y not defined.") :: Int
        player = findParam x "v" "player not defined."
        index = n * pos1 + pos2
        newGrid = replaceNth index (Just (strToPlayer player)) grid
    in fillTheGrid xs newGrid

getWinSeqs :: Grid -> [[Maybe Player]]
getWinSeqs grid = horizontal ++ vertical ++ [fDiag, bDiag]
  where horizontal = grid
        vertical = transpose grid
        fDiag = zipWith (!!) (reverse grid) [0..]
        bDiag = zipWith (!!) grid [0..]

winner :: String -> Maybe Char
winner map
    | winner' X  = Just 'x'
    | winner' O  = Just 'o'
    | otherwise = Nothing
    where
        grid = fillTheGrid (parseJson map) (concat emptyGrid)
        winner' :: Player -> Bool
        winner' player = any (all (== Just player)) $ getWinSeqs grid

