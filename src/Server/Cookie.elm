module Server.Cookie exposing
  ( SameSite(..)
  , Expiration(..)
  , Cookie
  , init
  , remove
  , expiresWithSession
  , expiresIn
  , expiresAt
  , withoutExpiration
  , isHttpOnly
  , notHttpOnly
  , isSecure
  , notSecure
  , withPath
  , isStrict
  , isLax
  , withoutSameSite
  , isSigned
  , notSigned
  )

{-|

@docs SameSite, Expiration, Cookie, init, remove, expiresWithSession, expiresIn, expiresAt, withoutExpiration, isHttpOnly, notHttpOnly, isSecure, notSecure, withPath, isStrict, isLax, withoutSameSite, isSigned, notSigned

-}

import Date exposing (Date)

{-|-}
type SameSite
  = Strict
  | Lax

{-|-}
type Expiration
  = Session
  | In Float
  | At Date

{-|-}
type alias Cookie =
  { name: String
  , expiration: Maybe Expiration
  , httpOnly: Bool
  , secure: Bool
  , path: String
  , sameSite: Maybe SameSite
  , signed: Bool
  }

{-|-}
init: String -> Cookie
init name =
  { name = name
  , expiration = Just Session
  , httpOnly = True
  , secure = True
  , path = "/"
  , sameSite = Just Strict
  , signed = True
  }

{-|-}
remove: String -> Cookie
remove name =
  init name
  |> expiresIn 0

{-|-}
expiresWithSession: Cookie -> Cookie
expiresWithSession cookie =
  { cookie | expiration = Just Session }

{-|-}
expiresIn: Float -> Cookie -> Cookie
expiresIn ttl cookie =
  { cookie | expiration = Just (In ttl) }

{-|-}
expiresAt: Date -> Cookie -> Cookie
expiresAt at cookie =
  { cookie | expiration = Just (At at) }

{-|-}
withoutExpiration: Cookie -> Cookie
withoutExpiration cookie =
  { cookie | expiration = Nothing }

{-|-}
isHttpOnly: Cookie -> Cookie
isHttpOnly cookie =
  { cookie | httpOnly = True }

{-|-}
notHttpOnly: Cookie -> Cookie
notHttpOnly cookie =
  { cookie | httpOnly = False }

{-|-}
isSecure: Cookie -> Cookie
isSecure cookie =
  { cookie | secure = True }

{-|-}
notSecure: Cookie -> Cookie
notSecure cookie =
  { cookie | secure = False }

{-|-}
withPath: String -> Cookie -> Cookie
withPath path cookie =
  { cookie | path = path }

{-|-}
isStrict: Cookie -> Cookie
isStrict cookie =
  { cookie | sameSite = Just Strict }

{-|-}
isLax: Cookie -> Cookie
isLax cookie =
  { cookie | sameSite = Just Lax }

{-|-}
withoutSameSite: Cookie -> Cookie
withoutSameSite cookie =
  { cookie | sameSite = Nothing }

{-|-}
isSigned: Cookie -> Cookie
isSigned cookie =
  { cookie | signed = True }

{-|-}
notSigned: Cookie -> Cookie
notSigned cookie =
  { cookie | signed = False }
