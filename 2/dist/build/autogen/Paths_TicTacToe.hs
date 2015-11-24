module Paths_TicTacToe (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/vyke/.cabal/bin"
libdir     = "/home/vyke/.cabal/lib/x86_64-linux-ghc-7.10.2.20151118/TicTacToe-0.1.0.0-572dPenwAy9Dnk4JNlFSiW"
datadir    = "/home/vyke/.cabal/share/x86_64-linux-ghc-7.10.2.20151118/TicTacToe-0.1.0.0"
libexecdir = "/home/vyke/.cabal/libexec"
sysconfdir = "/home/vyke/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "TicTacToe_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "TicTacToe_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "TicTacToe_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "TicTacToe_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "TicTacToe_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
