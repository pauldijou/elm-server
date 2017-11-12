module Server.Method exposing (Method(..), decoderLower, decoderUpper)

{-|

@docs Method, decoderLower, decoderUpper

-}

import Json.Decode exposing (Decoder)

{-| Simple type to represent an HTTP method -}
type Method
  = Get
  | Post
  | Put
  | Patch
  | Delete
  | Options
  | Trace
  | Connect


---------------------------------------------------------------------
-- Decoders

{-| Decoder trying to parse an HTTP method from a lowercase string -}
decoderLower: Decoder Method
decoderLower =
  Json.Decode.string
  |> Json.Decode.andThen (\str -> case str of
    "get"     -> Json.Decode.succeed Get
    "post"    -> Json.Decode.succeed Post
    "put"     -> Json.Decode.succeed Put
    "patch"   -> Json.Decode.succeed Patch
    "delete"  -> Json.Decode.succeed Delete
    "options" -> Json.Decode.succeed Options
    "trace"   -> Json.Decode.succeed Trace
    "connect" -> Json.Decode.succeed Connect
    _         -> Json.Decode.fail ("Unknown method: " ++ str)
  )

{-| Decoder trying to parse an HTTP method from an uppercase string -}
decoderUpper: Decoder Method
decoderUpper =
  Json.Decode.string
  |> Json.Decode.andThen (\str -> case str of
    "GET"     -> Json.Decode.succeed Get
    "POST"    -> Json.Decode.succeed Post
    "PUT"     -> Json.Decode.succeed Put
    "PATCH"   -> Json.Decode.succeed Patch
    "DELETE"  -> Json.Decode.succeed Delete
    "OPTIONS" -> Json.Decode.succeed Options
    "TRACE"   -> Json.Decode.succeed Trace
    "CONNECT" -> Json.Decode.succeed Connect
    _         -> Json.Decode.fail ("Unknown method: " ++ str)
  )
