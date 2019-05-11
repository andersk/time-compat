{-# LANGUAGE CPP #-}
module Data.Time.Format.Compat (
    -- * UNIX-style formatting
    FormatTime(),formatTime,

    -- * UNIX-style parsing
    -- ** __Note__ in compat mode acceptWS argument is ignored, it's always 'True'.
    parseTimeM, parseTimeOrError,
    readSTime, readPTime,
    parseTime, readTime, readsTime,
    ParseTime(),

    -- * Locale
    TimeLocale(..),

    defaultTimeLocale,

    iso8601DateFormat,
    rfc822DateFormat,
    ) where

import Data.Time.Orphans ()

import Data.Time.Format

#if !MIN_VERSION_time(1,5,0)
import System.Locale (TimeLocale, defaultTimeLocale, iso8601DateFormat, rfc822DateFormat)
import qualified Control.Monad.Fail as Fail
import Text.ParserCombinators.ReadP (readP_to_S, readS_to_P, ReadP)

parseTimeM
    :: (Fail.MonadFail m, ParseTime t)
    => Bool       -- ^ Accept leading and trailing whitespace?
    -> TimeLocale -- ^ Time locale.
    -> String     -- ^ Format string.
    -> String     -- ^ Input string.
    -> m t        -- ^ Return the time value, or fail if the in
parseTimeM _acceptWS l fmt s = case parseTime l fmt s of
    Just x  -> return x
    Nothing -> Fail.fail "parseTimeM: no parse"

parseTimeOrError
    :: ParseTime t
    => Bool       -- ^ Accept leading and trailing whitespace?
    -> TimeLocale -- ^ Time locale.
    -> String     -- ^ Format string.
    -> String     -- ^ Input string.
    -> t          -- ^ The time value.
parseTimeOrError _acceptWS l fmt s = case parseTime l fmt s of
    Just x  -> x
    Nothing -> error "parseTimeOrError: no parse"

-- | Parse a time value given a format string.  See 'parseTimeM' for details.
readSTime :: ParseTime t =>
             Bool       -- ^ Accept leading whitespace?
          -> TimeLocale -- ^ Time locale.
          -> String     -- ^ Format string
          -> ReadS t
readSTime _acceptWS l f  = readsTime l f

-- | Parse a time value given a format string.  See 'parseTimeM' for details.
readPTime :: ParseTime t =>
             Bool       -- ^ Accept leading whitespace?
          -> TimeLocale -- ^ Time locale.
          -> String     -- ^ Format string
          -> ReadP t
readPTime acceptWS l f = readS_to_P (readSTime acceptWS l f)
#endif