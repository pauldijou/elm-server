module Server.Request exposing (Request)

{-|

@docs Request

-}

import Dict exposing (Dict)
import Server.Method exposing (Method)

{-|
A normalized request received by the server. Depending on server implementation and plugins used, `params` and `cookies` might or might not be available.
-}
type alias Request =
  { method: Method
  , path: String
  , headers: Dict String String
  , params: Dict String String
  , query: Dict String String
  , cookies: Dict String String
  , body: Maybe String
  }
