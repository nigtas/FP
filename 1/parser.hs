module Parser
where

import Data.List.Extra

type InternalMap = [(String, String)]

message :: String
message = "[{\"x\": 0, \"y\": 2, \"v\": \"x\"}, {\"x\": 1, \"y\": 1, \"v\": \"o\"}, {\"x\": 1, \"y\": 0, \"v\": \"x\"}, {\"x\": 1, \"y\": 2, \"v\": \"o\"}, {\"x\": 2, \"y\": 2, \"v\": \"x\"}]"

--parser

getMapInnards :: String -> InternalMap -> InternalMap
getMapInnards [] acc = acc
getMapInnards str acc =
    let 
        item = takeWhile (/= ',') str
        tuple = case (stripInfix ":" item) of
            Just (key, value) -> (key, value)
            Nothing -> error "Parser error."
        rest = drop (length item + 1) str
    in reverse $ getMapInnards rest (tuple : acc)


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
        parsed = getMapInnards striped []
    in parseMap xs (parsed : res)


parseJson :: String -> [InternalMap]
parseJson str =
	let
		arrayInfo = stripElem str "[" "]"
		gameData = parseMap (parseList arrayInfo []) []
	in gameData

--parser
