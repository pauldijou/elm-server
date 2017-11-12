var _pauldijou$elm_server$Native_Server = function () {
  const helpers = _pauldijou$elm_kernel_helpers$Native_Kernel_Helpers;
  const settings = {};

  function init(messages) {
    settings.messages = messages;
    return helpers.task.succeed();
  }

  function setup(sta) {
    settings.sendToApp = sta;
    return helpers.task.succeed();
  }

  function sendToApp(event) {
    if (settings.sendToApp) {
      helpers.task.rawSpawn(settings.sendToApp(event));
    }
  }

  function onRequest(replier, request) {
    sendToApp(A2(settings.messages.requested, replier, request));
  }

  function hasServer() {
    return settings.server !== undefined
  }

  function assignServer(server) {
    settings.server = server;
  }

  function removeServer() {
    settings.server = undefined;
  }

  function getServer() {
    return helpers.task.fromCallback((succeed, fail) => {
      if (hasServer()) {
        succeed(settings.server);
      } else {
        fail(new Error('You didn\'t start any server or you have already stopped it.'));
      }
    })
  }

  function start(server) {
    return helpers.task.fromCallback((succeed, fail) => {
      try {
        if (hasServer()) {
          fail(new Error('You already have a server running.'))
          return;
        }

        assignServer(server);
        server.implementation.start({
          onRequest: onRequest
        }).then(started => {
          succeed(Object.assign(server, { implementation: started }));
        }).catch(err => {
          removeServer();
          fail(err);
        })
      } catch (err) {
        removeServer();
        fail(err);
      }
    })
  }

  function stop(server) {
    return helpers.task.fromCallback((succeed, fail) => {
      try {
        server.implementation.stop().then(() => {
          removeServer();
          succeed();
        }).catch(fail)
      } catch (err) {
        fail(err);
      }
    })
  }

  return {
    init: init,
    setup: setup,
    start: start,
    stop: stop
  }
}()
