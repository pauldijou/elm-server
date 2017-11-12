effect module Server where { subscription = ServerSub } exposing
  ( Method
  , Request
  , Response
  , Cookie
  , Header
  , Server
  , Replier
  , ServerImplementation
  , Msg(..)
  , start
  , stop
  , reply
  , listen
  )

{-|

@docs Method, Request, Response, Cookie, Header, Server, Replier, ServerImplementation, Msg, start, stop, reply, listen

-}

import Task exposing (Task)
import Json.Encode
import Json.Decode exposing (Decoder)
import Error exposing (Error)
import Kernel.Helpers

import Server.Request
import Server.Response
import Server.Cookie
import Server.Method

import Native.Server

{-|-}
type alias Method = Server.Method.Method

{-|-}
type alias Cookie = Server.Cookie.Cookie

{-|-}
type alias Request = Server.Request.Request

{-|-}
type alias Response = Server.Response.Response

{-|-}
type alias Header = Server.Response.Header

{-|-}
type ServerImplementation = ServerImplementation

{-|-}
type Replier = Replier

{-|-}
type alias Server =
  { implementation: ServerImplementation
  , request:
    { decoder: Decoder Request
    }
  , replier:
    { init: Replier -> Replier
    , withStatusCode: Int -> Replier -> Replier
    , withHeader: Header -> Replier -> Replier
    , withCookie: Cookie -> Replier -> Replier
    , withBody: String -> Replier -> Replier
    , send: Bool -> Replier -> Replier
    }
  }

{-|-}
start: Server -> Task Error Server
start server =
  Native.Server.start server
  |> Task.mapError Error.parse

{-|-}
stop: Server -> Task Error ()
stop server =
  Native.Server.stop server
  |> Task.mapError Error.parse

{-|-}
reply: Replier -> Response -> Task Error Replier
reply replier response =
  getServer
  |> Task.map (\server ->
    server.replier.init replier
    |> server.replier.withStatusCode response.statusCode
    |> foldOnReplier server.replier.withHeader response.headers
    |> foldOnReplier server.replier.withCookie response.cookies
    |> (\rplr -> case response.body of
      Nothing -> rplr
      Just body -> server.replier.withBody body rplr
    )
    |> server.replier.send response.end
  )


-- -----------------------------------------------------------------------------
-- SUB
-- -----------------------------------------------------------------------------

{-|-}
type Msg
  = Requested Replier Json.Encode.Value

type ServerSub msg
  = Listen (Msg -> msg)

{-|-}
listen: (Msg -> msg) -> Sub msg
listen =
  subscription << Listen

subMap : (a -> b) -> ServerSub a -> ServerSub b
subMap f sub =
  case sub of
    Listen tagger -> Listen (tagger >> f)


-- -----------------------------------------------------------------------------
-- STATE
-- -----------------------------------------------------------------------------

type alias State msg =
  { initialized: Bool
  , subs: List (ServerSub msg)
  }

init : Task Never (State msg)
init =
  Native.Server.init { requested = Requested }
  |> Task.map (\_ -> { initialized = False, subs = [] })


-- -----------------------------------------------------------------------------
-- EFFECTS
-- -----------------------------------------------------------------------------

onEffects
  : Platform.Router msg Msg
  -> List (ServerSub msg)
  -> State msg
  -> Task Never (State msg)
onEffects router subs state =
  (
    if state.initialized
    then Task.succeed state
    else
      Native.Server.setup (Platform.sendToApp router)
      |> Task.map (\_ -> { state | initialized = True })
  )
  |> Task.map (\s -> { s | subs = subs })


onSelfMsg : Platform.Router msg Msg -> Msg -> State msg -> Task Never (State msg)
onSelfMsg router selfMsg state =
  Task.succeed state


-- -----------------------------------------------------------------------------
-- INTERNALS
-- -----------------------------------------------------------------------------

getServer: Task Error Server
getServer =
  Native.Server.getServer
  |> Task.mapError Error.parse

foldOnReplier: (a -> Replier -> Replier) -> List a -> Replier -> Replier
foldOnReplier folder list replier =
  List.foldl folder replier list

noWarnings: String
noWarnings =
  Kernel.Helpers.noWarnings
