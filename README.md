# elm-server

:warning: This is probably **not** what you should be using except if you want to write you own server implementation in Elm. Those are low level types and functions to help writing server libs.

If you need to run Elm on server-side, check one of the following implementations:

- [nomalab/elm-hapi](https://github.com/nomalab/elm-hapi) (based on [Hapi.js](https://hapijs.com))
- elm-express (based on [Express](https://expressjs.com), coming soon)
- elm-fastify (based on [fastify](https://www.fastify.io), coming soon)

## Tradeoff

To ease syntax and boilerplate and improve user experience, this lib can only run one server at a time per Elm worker. This is why you can only start once or again after stopping (start task will fail if you call it again) and you do not have to specify which server you are listening to when subscribing.

## Implement your own server

### Provide a server creator

```elm
module YouCustomServer exposing (..)

import Json.Decode exposing (Decoder)
import Server

type alias Options = {
  -- You should put here any options needed to create a raw server
}

create: Options -> Task Error Server.Server
create options =
  { implementation = Native.YouCustomServer.create options
  , requestDecoder = requestDecoder
  -- other stuff...
  }

requestDecoder: Decoder Server.Request
requestDecoder =
  -- you custom request decoder
```

### ServerImplementation

You can put whatever you want in your

```javascript
function start({
  onRequest: function (replier, request) { /* elm-server internals */ }
}) {
  // return Promise<ServerImplementation>
}

function stop() {
  // return Promise
}
```

### Important concerns

This will be fixed on Elm 0.19 but as far as 0.18 go, if a `Json.Decode.Decoder` fails, it will call `JSON.stringify` on the value it tried to decode. Since it is JavaScript, the value might be recursive and it will crash at runtime. To prevent that, you need to add a `toJSON` function on any opaque type (`ServerImplementation`, `Replier`) and your request object **before** parsing it.

## License

This software is licensed under the Apache 2 license, quoted below.

Copyright Paul Dijou ([http://pauldijou.fr](http://pauldijou.fr)).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
