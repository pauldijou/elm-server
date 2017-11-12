module Server.Response exposing
  ( Header
  , Response
  , withStatusCode
  , withHeader
  , withHeaders
  , withCookie
  , withBody
  , withJsonBody
  , keepAlive
  , shell
  , continue
  , switchingProcols
  , processing
  , ok
  , created
  , accepted
  , noContent
  , redirect
  , redirectTo
  , notModified
  , badRequest
  , unauthorized
  , paymentRequired
  , forbidden
  , notFound
  , requestTimeout
  , teapot
  , unprocessableEntity
  , internalServerError
  , notImplemented
  , badGateway
  , serviceUnavailable
  )

{-|

@docs Header, Response, withStatusCode, withHeader, withHeaders, withCookie, withBody, withJsonBody, keepAlive, shell, continue, switchingProcols, processing, ok, created, accepted, noContent, redirect, redirectTo, notModified, badRequest, unauthorized, paymentRequired, forbidden, notFound, requestTimeout, teapot, unprocessableEntity, internalServerError, notImplemented, badGateway, serviceUnavailable

-}

import Dict exposing (Dict)
import Json.Encode as Encode
import Tuple exposing (first, second)
import Server.Cookie as Cookie exposing (Cookie)

{-|-}
type alias Header =
  { name: String
  , value: String
  }

{-|-}
type alias Response =
  { statusCode: Int
  , body: Maybe String
  -- Headers with same name will be appended
  , headers: List Header
  , cookies: List Cookie
  , end: Bool
  }

{-|-}
withStatusCode: Int -> Response -> Response
withStatusCode statusCode response =
  { response | statusCode = statusCode }

{-|-}
withHeader: String -> String -> Response -> Response
withHeader name value response =
  { response | headers = { name = name, value = value } :: response.headers }

{-|-}
withHeaders: List (String, String) -> Response -> Response
withHeaders headers response =
  { response
  | headers =
      headers
      |> List.map (\header -> { name = first header, value = second header })
      |> List.append response.headers
  }

{-|-}
withCookie: Cookie -> Response -> Response
withCookie cookie response =
  { response |  cookies = cookie :: response.cookies }

{-|-}
withBody: String -> Response -> Response
withBody body response =
  { response | body = Just body }

{-|-}
withoutBody: Response -> Response
withoutBody response =
  { response | body = Nothing }

{-|-}
withJsonBody: Encode.Value -> Response -> Response
withJsonBody jsBody response =
  withHeader "content-type" "application/json" (withBody (Encode.encode 0 jsBody) response)

{-|-}
keepAlive: Response -> Response
keepAlive response =
  { response | end = False }
  |> withHeader "Connection" "keep-alive"


-- -----------------------------------------------------------------------------
-- Predefined responses

{-| A response with a status code of 0 -}
shell: Response
shell =
  { statusCode = 0
  , body = Nothing
  , headers = []
  , cookies = []
  , end = True
  }

{-| A response with a status code of 100 -}
continue: Response
continue = shell |> withStatusCode 100

{-| A response with a status code of 101 -}
switchingProcols: Response
switchingProcols = shell |> withStatusCode 101

{-| A response with a status code of 102 -}
processing: Response
processing = shell |> withStatusCode 102

{-| A response with a status code of 200 -}
ok: Response
ok = shell |> withStatusCode 200

{-| A response with a status code of 201 -}
created: Response
created = shell |> withStatusCode 201

{-| A response with a status code of 202 -}
accepted: Response
accepted = shell |> withStatusCode 202

{-| A response with a status code of 204 -}
noContent: Response
noContent = shell |> withStatusCode 204

{-| A response with a status code of 302 -}
redirect: Response
redirect = shell |> withStatusCode 302

{-| A response with a status code of 302 and the corresponding Location header -}
redirectTo: String -> Response
redirectTo uri = redirect |> withHeader "Location" uri

{-| A response with a status code of 304 -}
notModified: Response
notModified = shell |> withStatusCode 304

{-| A response with a status code of 400 -}
badRequest: Response
badRequest = shell |> withStatusCode 400

{-| A response with a status code of 401 -}
unauthorized: Response
unauthorized = shell |> withStatusCode 401

{-| A response with a status code of 402 -}
paymentRequired: Response
paymentRequired = shell |> withStatusCode 402

{-| A response with a status code of 403 -}
forbidden: Response
forbidden = shell |> withStatusCode 403

{-| A response with a status code of 404 -}
notFound: Response
notFound = shell |> withStatusCode 404

{-| A response with a status code of 408 -}
requestTimeout: Response
requestTimeout = shell |> withStatusCode 408

{-| A response with a status code of 418 -}
teapot: Response
teapot = shell |> withStatusCode 418

{-| A response with a status code of 422 -}
unprocessableEntity: Response
unprocessableEntity = shell |> withStatusCode 422

{-| A response with a status code of 500 -}
internalServerError: Response
internalServerError = shell |> withStatusCode 500

{-| A response with a status code of 501 -}
notImplemented: Response
notImplemented = shell |> withStatusCode 501

{-| A response with a status code of 502 -}
badGateway: Response
badGateway = shell |> withStatusCode 502

{-| A response with a status code of 503 -}
serviceUnavailable: Response
serviceUnavailable = shell |> withStatusCode 503
