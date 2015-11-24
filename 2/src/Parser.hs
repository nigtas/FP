module Parser where

import Data.List.Extra

type InternalMap = [(String, String)]
data Player = X | O deriving (Show, Read, Eq)

playerToStr player =
    case player of
        Just X -> "x"
        Just O -> "o"

findParam :: InternalMap -> String -> String -> String
findParam map param errorMsg =
    case lookup param map of
        Just val -> val
        Nothing -> error errorMsg

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

serializeJsonMapInnards [] acc = acc
serializeJsonMapInnards (x:xs) acc =
    let
        xVal = findParam x "x" "x not defined."
        yVal = findParam x "y" "y not defined."
        player = findParam x "v" "v not defined."
        str = "{\"x\": " ++ xVal ++ ", \"y\": " ++ yVal ++ ", \"v\": \"" ++ player ++ "\"}"
    in serializeJsonMapInnards xs (str : acc)

serializeJsonGridInnards :: [Maybe Player] -> Int -> [String] -> [String]
serializeJsonGridInnards [] n acc = acc
serializeJsonGridInnards (x:xs) n acc =
    if x /= Nothing then let
        (xVal,yVal) = (divMod n 3)
        str = "{\"x\": " ++ (show xVal) ++ ", \"y\": " ++ (show yVal) ++ ", \"v\": \"" ++ (playerToStr x) ++ "\"}"
    in serializeJsonGridInnards xs (n+1) (str:acc)
    else serializeJsonGridInnards xs (n+1) acc

serializeJsonMap :: [InternalMap] -> String
serializeJsonMap map =
    let
        innards = intercalate ", " (reverse $ serializeJsonMapInnards map [])
    in "[" ++ innards ++ "]"

serializeJsonGrid :: [Maybe Player] -> String
serializeJsonGrid list =
    let
        innards = intercalate ", " (reverse $ serializeJsonGridInnards list 0 [])
    in "[" ++ innards ++ "]"

