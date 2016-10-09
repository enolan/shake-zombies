import Development.Shake
import Development.Shake.FilePath
import Distribution.Simple
import Distribution.Simple.Build
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.Setup
main = defaultMainWithHooks $ simpleUserHooks {buildHook = myBuildH}

myBuildH pkgdesc lbi userhooks buildFlags =
  shake shakeOptions {shakeThreads = 0} $ rules pkgdesc lbi buildFlags

rules pkgdesc lbi buildFlags = do
  let buildPref = fromFlag $ configDistPref $ configFlags lbi
      exePath = buildPref </> "build" </> "shaketest" </> "shaketest" <.> exe
  want $ [exePath] ++ map ("out-" ++) (map show [1..50])
  exePath %> \_ -> do
    hsFiles <- getDirectoryFiles "" ["src" <//> "*.hs"]
    need hsFiles
    traced "haskell compile" $ build (localPkgDescr lbi) lbi buildFlags []
  "out-*" %> \p -> do
    cmd "echo Hello" p (FileStdout p)

